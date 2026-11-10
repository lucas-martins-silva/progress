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
{include/i-prgvrs.i BOCX00511 2.00.00.001} /* 25/04/2025 09:57:46 */
{include/i-license-manager.i BOCX00511 MUT}
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName bocx00511
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName param-imp-trib
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
{cxbo/bocx00511.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEF VAR c-param AS CHAR NO-UNDO.

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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-natur-operac-novo-impto":U THEN ASSIGN pFieldValue = RowObject.cod-natur-operac-novo-impto.
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
        WHEN "cdn-despes-impto-CBS":U THEN ASSIGN pFieldValue = RowObject.cdn-despes-impto-CBS.
        WHEN "cdn-fornec-CBS":U THEN ASSIGN pFieldValue = RowObject.cdn-fornec-CBS.
        WHEN "cdn-despes-impto-IBSMun":U THEN ASSIGN pFieldValue = RowObject.cdn-despes-impto-IBSMun.
        WHEN "cdn-fornec-IBSMun":U THEN ASSIGN pFieldValue = RowObject.cdn-fornec-IBSMun.
        WHEN "cdn-despes-impto-IBSUF":U THEN ASSIGN pFieldValue = RowObject.cdn-despes-impto-IBSUF.
        WHEN "cdn-fornec-IBSUF":U THEN ASSIGN pFieldValue = RowObject.cdn-fornec-IBSUF.
        WHEN "cdn-despes-impto-IS":U THEN ASSIGN pFieldValue = RowObject.cdn-despes-impto-IS.
        WHEN "cdn-fornec-IS":U THEN ASSIGN pFieldValue = RowObject.cdn-fornec-IS.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice id--chave
  Parameters:  
               retorna valor do campo cod-item
               retorna valor do campo cod-class-fisc
               retorna valor do campo cod-atrib
               retorna valor do campo cod-domin
               retorna valor do campo ind-modal
               retorna valor do campo num-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE param-imp-trib.cod-estabel NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel.

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
        WHEN "log-incid-IBSUF-ipi-outros-of":U THEN ASSIGN pFieldValue = RowObject.log-incid-IBSUF-ipi-outros-of.
        WHEN "log-cotac-autom-CBS":U THEN ASSIGN pFieldValue = RowObject.log-cotac-autom-CBS.
        WHEN "log-cotac-autom-IBSMun":U THEN ASSIGN pFieldValue = RowObject.log-cotac-autom-IBSMun.
        WHEN "log-cotac-autom-IBSUF":U THEN ASSIGN pFieldValue = RowObject.log-cotac-autom-IBSUF.
        WHEN "log-cotac-autom-IS":U THEN ASSIGN pFieldValue = RowObject.log-cotac-autom-IS.
        WHEN "log-gerac-cot-desp-novo-impto":U THEN ASSIGN pFieldValue = RowObject.log-gerac-cot-desp-novo-impto.
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
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
  Purpose:     Reposiciona registro com base no °ndice id--chave
  Parameters:  
               recebe valor do campo cod-item
               recebe valor do campo cod-class-fisc
               recebe valor do campo cod-atrib
               recebe valor do campo cod-domin
               recebe valor do campo ind-modal
               recebe valor do campo num-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE param-imp-trib.cod-estabel NO-UNDO.

    FIND FIRST bfparam-imp-trib WHERE 
        bfparam-imp-trib.cod-estabel = pcod-estabel NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfparam-imp-trib THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfparam-imp-trib)).
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

    IF rowObject.cod-natur-operac-novo-impto <> "" 
    AND NOT CAN-FIND(natur-oper WHERE natur-oper.nat-operacao = rowObject.cod-natur-operac-novo-impto) THEN DO:
        ASSIGN c-param = "Natureza de Operaá∆o Novo Imposto":U.
        {method/svc/errors/inserr.i
                &ErrorNumber="2"
                &ErrorType="EMS"
                &ErrorParameters="c-param"}
    END.

    IF rowObject.log-cotac-autom-CBS 
    OR rowObject.log-cotac-autom-IBSMun 
    OR rowObject.log-cotac-autom-IBSUF 
    OR rowObject.log-cotac-autom-IS THEN DO:
       
        IF rowObject.cod-natur-operac-novo-impto = "" THEN DO:
            ASSIGN c-param = "Natureza de Operaá∆o Novo Imposto~~cotaá∆o autom†tica para impostos":U.
            {method/svc/errors/inserr.i
                    &ErrorNumber="30055"
                    &ErrorType="EMS"
                    &ErrorParameters="c-param"}
        END.
    END.

    IF rowObject.log-cotac-autom-CBS THEN DO: 
    
        IF NOT CAN-FIND(desp-imp WHERE desp-imp.cod-desp = rowObject.cdn-despes-impto-CBS) THEN DO:
            ASSIGN c-param = "despesa do CBS":U. 
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorParameters="c-param"}
        END.
        ELSE DO:
            FIND FIRST desp-imp 
                 WHERE desp-imp.cod-desp = rowObject.cdn-despes-impto-CBS NO-LOCK NO-ERROR.

            IF desp-imp.cod-incoterm-rat <> "" THEN DO:
                /* As despesas para impostos nao devem possuir incoterm de rateio */
                {method/svc/errors/inserr.i
                        &ErrorNumber="30180"
                        &ErrorType="EMS"
                        &ErrorParameters=rowObject.cdn-despes-impto-CBS}
            END.

            IF desp-imp.tipo <> 2 THEN DO:
                ASSIGN c-param = "Despesa CBS~~do tipo diferente de Valor Informado":U.
                {method/svc/errors/inserr.i
                        &ErrorNumber="7972"
                        &ErrorType="EMS"
                        &ErrorParameters="c-param"}
            END.
            
            FOR FIRST desp-imp-trib 
                WHERE desp-imp-trib.cod-desp = rowObject.cdn-despes-impto-CBS NO-LOCK:
                IF desp-imp-trib.log-incide-base-CBS-desp
                OR desp-imp-trib.log-incide-base-CBS-vladu THEN DO:
                    /* Despesa do CBS incide sobre sua pr¢pria base */
                    ASSIGN c-param = "Despesa CBS~~incide base CBS":U.
                    {method/svc/errors/inserr.i
                            &ErrorNumber="7972"
                            &ErrorType="EMS"
                            &ErrorParameters="c-param"}

                END.
            END.
        END.
        
        FIND FIRST emitente 
             WHERE emitente.cod-emitente = rowObject.cdn-fornec-CBS NO-LOCK NO-ERROR.
        IF NOT AVAIL emitente
        OR rowObject.cdn-fornec-CBS = 0 THEN DO:
            ASSIGN c-param = "Fornecedor do CBS":U.
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorParameters="c-param"}
        END. 
        ELSE DO:
            /** Emitente deve ser fornecedor **/
            IF emitente.identific = 1 THEN DO: 
                ASSIGN c-param = "Emitente do CBS ~~Fornecedor":U.
                {method/svc/errors/inserr.i
                        &ErrorNumber="17195"
                        &ErrorType="EMS"
                        &ErrorParameters="c-param"}
            END.
        END.
    END. 

    IF rowObject.log-cotac-autom-IBSMun  then do: 

        IF NOT CAN-FIND(desp-imp WHERE desp-imp.cod-desp = rowObject.cdn-despes-impto-IBSMun) THEN DO:
            ASSIGN c-param = "despesa do IBSMun":U.
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorParameters="c-param"}
        END.
        ELSE DO:
            FIND FIRST desp-imp 
                 WHERE desp-imp.cod-desp = rowObject.cdn-despes-impto-IBSMun NO-LOCK NO-ERROR.

            IF desp-imp.cod-incoterm-rat <> "" THEN DO:
                /* As despesas para impostos nao devem possuir incoterm de rateio */
                {method/svc/errors/inserr.i
                        &ErrorNumber="30180"
                        &ErrorType="EMS"
                        &ErrorParameters=rowObject.cdn-despes-impto-IBSMun}
            END.

            IF desp-imp.tipo <> 2 THEN DO:
                ASSIGN c-param = "Despesa IBSMun~~do tipo diferente de Valor Informado":U.
                {method/svc/errors/inserr.i
                        &ErrorNumber="7972"
                        &ErrorType="EMS"
                        &ErrorParameters="c-param"}
            END.
            
            FOR FIRST desp-imp-trib 
                WHERE desp-imp-trib.cod-desp = rowObject.cdn-despes-impto-IBSMun NO-LOCK:
                IF desp-imp-trib.log-incide-base-IBSMun THEN DO:
                    /* Despesa do IBSMun incide sobre sua pr¢pria base */
                    ASSIGN c-param = "Despesa IBSMun~~incide base IBSMun":U.
                    {method/svc/errors/inserr.i
                            &ErrorNumber="7972"
                            &ErrorType="EMS"
                            &ErrorParameters="c-param"}
                END.
            END.
        END.

        FIND FIRST emitente 
             WHERE emitente.cod-emitente = rowObject.cdn-fornec-IBSMun NO-LOCK NO-ERROR.
        IF NOT AVAIL emitente
        OR rowObject.cdn-fornec-IBSMun = 0 THEN DO:
            ASSIGN c-param = "Fornecedor do IBSMun":U.
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorParameters="c-param"}
        END. 
        ELSE DO:
            /** Emitente deve ser fornecedor **/
            IF emitente.identific = 1 THEN DO: 
                ASSIGN c-param = "Emitente do IBSMun ~~Fornecedor":U.
                {method/svc/errors/inserr.i
                        &ErrorNumber="17195"
                        &ErrorType="EMS"
                        &ErrorParameters="c-param"}
            END.
        END.
    END.

    IF rowObject.log-cotac-autom-IBSUF  then do: 

        IF NOT CAN-FIND(desp-imp WHERE desp-imp.cod-desp = rowObject.cdn-despes-impto-IBSUF) THEN DO:
            ASSIGN c-param = "despesa do IBSUF":U.
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorParameters="c-param"}
        END.
        ELSE DO:
            FIND FIRST desp-imp 
                 WHERE desp-imp.cod-desp = rowObject.cdn-despes-impto-IBSUF NO-LOCK NO-ERROR.

            IF desp-imp.cod-incoterm-rat <> "" THEN DO:
                /* As despesas para impostos nao devem possuir incoterm de rateio */
                {method/svc/errors/inserr.i
                        &ErrorNumber="30180"
                        &ErrorType="EMS"
                        &ErrorParameters=rowObject.cdn-despes-impto-IBSUF}
            END.

            IF desp-imp.tipo <> 2 THEN DO:
                ASSIGN c-param = "Despesa IBSUF~~do tipo diferente de Valor Informado":U.
                {method/svc/errors/inserr.i
                        &ErrorNumber="7972"
                        &ErrorType="EMS"
                        &ErrorParameters="c-param"}
            END.
            
            FOR FIRST desp-imp-trib 
                WHERE desp-imp-trib.cod-desp = rowObject.cdn-despes-impto-IBSUF NO-LOCK:
                IF desp-imp-trib.log-incide-base-IBSUF THEN DO:
                    /* Despesa do IBSUF incide sobre sua pr¢pria base */
                    ASSIGN c-param = "Despesa IBSUF~~incide base IBSUF":U.
                    {method/svc/errors/inserr.i
                            &ErrorNumber="7972"
                            &ErrorType="EMS"
                            &ErrorParameters="c-param"}
                END.
            END.
        END.

        FIND FIRST emitente 
             WHERE emitente.cod-emitente = rowObject.cdn-fornec-IBSUF NO-LOCK NO-ERROR.
        IF NOT AVAIL emitente
        OR rowObject.cdn-fornec-IBSUF = 0 THEN DO:
            ASSIGN c-param = "Fornecedor do IBSUF":U.
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorParameters="c-param"}
        END. 
        ELSE DO:
            /** Emitente deve ser fornecedor **/
            IF emitente.identific = 1 THEN DO: 
                ASSIGN c-param = "Emitente do IBSUF ~~Fornecedor":U.
                {method/svc/errors/inserr.i
                        &ErrorNumber="17195"
                        &ErrorType="EMS"
                        &ErrorParameters="c-param"}
            END.
        END.
    END.

    IF rowObject.log-cotac-autom-IS THEN DO: 
    
        IF NOT CAN-FIND(desp-imp WHERE desp-imp.cod-desp = rowObject.cdn-despes-impto-IS) THEN DO:
            ASSIGN c-param = "despesa do IS":U.
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorParameters="c-param"}
        END.
        ELSE DO:
            FIND FIRST desp-imp 
                 WHERE desp-imp.cod-desp = rowObject.cdn-despes-impto-IS NO-LOCK NO-ERROR.

            IF desp-imp.cod-incoterm-rat <> "" THEN DO:
                /* As despesas para impostos nao devem possuir incoterm de rateio */
                {method/svc/errors/inserr.i
                        &ErrorNumber="30180"
                        &ErrorType="EMS"
                        &ErrorParameters=rowObject.cdn-despes-impto-IS}
            END.

            IF desp-imp.tipo <> 2 THEN DO:
                ASSIGN c-param = "Despesa IS~~do tipo diferente de Valor Informado":U.
                {method/svc/errors/inserr.i
                        &ErrorNumber="7972"
                        &ErrorType="EMS"
                        &ErrorParameters="c-param"}
            END.
            
            FOR FIRST desp-imp-trib 
                WHERE desp-imp-trib.cod-desp = rowObject.cdn-despes-impto-IS NO-LOCK:
                IF desp-imp-trib.log-incide-base-IS THEN DO:
                    /* Despesa do IS incide sobre sua pr¢pria base */
                    ASSIGN c-param = "Despesa IS~~incide base IS":U.
                    {method/svc/errors/inserr.i
                            &ErrorNumber="7972"
                            &ErrorType="EMS"
                            &ErrorParameters="c-param"}
                END.
            END.
        END.
        
        FIND FIRST emitente 
             WHERE emitente.cod-emitente = rowObject.cdn-fornec-IS NO-LOCK NO-ERROR.
        IF NOT AVAIL emitente
        OR rowObject.cdn-fornec-IS = 0 THEN DO:
            ASSIGN c-param = "Fornecedor do IS":U.
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorParameters="c-param"}
        END. 
        ELSE DO:
            /** Emitente deve ser fornecedor **/
            IF emitente.identific = 1 THEN DO:
                ASSIGN c-param = "Emitente do IS ~~Fornecedor":U.
                {method/svc/errors/inserr.i
                        &ErrorNumber="17195"
                        &ErrorType="EMS"
                        &ErrorParameters="c-param"}
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

