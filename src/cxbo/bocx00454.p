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

{include/i-prgvrs.i BOCX00454 2.00.00.006 } /*** "010006" 16/09/2025 16:13:57 ***/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX00454
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName internac-impto-faixa
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
{cxbo/bocx00454.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-cod-estabel LIKE param-imp.cod-estabel NO-UNDO.
DEFINE VARIABLE i-cont        AS INTEGER                 NO-UNDO.
DEFINE VARIABLE l-erro        AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE d-cotacao     AS DECIMAL                 NO-UNDO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-livre-3":U THEN ASSIGN pFieldValue = RowObject.cod-livre-3.
        WHEN "cod-livre-4":U THEN ASSIGN pFieldValue = RowObject.cod-livre-4.
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
        WHEN "dat-livre-3":U THEN ASSIGN pFieldValue = RowObject.dat-livre-3.
        WHEN "dat-livre-4":U THEN ASSIGN pFieldValue = RowObject.dat-livre-4.
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
        WHEN "val-final-base":U THEN ASSIGN pFieldValue = RowObject.val-final-base.
        WHEN "val-inicial-base":U THEN ASSIGN pFieldValue = RowObject.val-inicial-base.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-livre-3":U THEN ASSIGN pFieldValue = RowObject.val-livre-3.
        WHEN "val-livre-4":U THEN ASSIGN pFieldValue = RowObject.val-livre-4.
        WHEN "val-max-impto":U THEN ASSIGN pFieldValue = RowObject.val-max-impto.
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
        WHEN "cdn-moed-base-impto":U THEN ASSIGN pFieldValue = RowObject.cdn-moed-base-impto.
        WHEN "cdn-moed-impto":U THEN ASSIGN pFieldValue = RowObject.cdn-moed-impto.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-livre-3":U THEN ASSIGN pFieldValue = RowObject.num-livre-3.
        WHEN "num-livre-4":U THEN ASSIGN pFieldValue = RowObject.num-livre-4.
        WHEN "num-sequencia":U THEN ASSIGN pFieldValue = RowObject.num-sequencia.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice intrncmp_id2
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo num-sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE internac-impto-faixa.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-sequencia LIKE internac-impto-faixa.num-sequencia NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pnum-sequencia = RowObject.num-sequencia.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLastSeq DBOProgram 
PROCEDURE getLastSeq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pCodEstabel LIKE {&TABLENAME}.cod-estabel   NO-UNDO.
DEF OUTPUT PARAM pSequencia  LIKE {&TABLENAME}.num-sequencia NO-UNDO.
              
FIND LAST bf{&TABLENAME}
     WHERE bf{&TABLENAME}.cod-estabel = pCodEstabel NO-LOCK NO-ERROR.
IF AVAIL bf{&TABLENAME} THEN
    ASSIGN pSequencia = bf{&TABLENAME}.num-sequencia + 1.
ELSE
    ASSIGN pSequencia = 1.

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
        WHEN "log-livre-3":U THEN ASSIGN pFieldValue = RowObject.log-livre-3.
        WHEN "log-livre-4":U THEN ASSIGN pFieldValue = RowObject.log-livre-4.
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
  Purpose:     Reposiciona registro com base no °ndice intrncmp_id2
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo num-sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE internac-impto-faixa.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnum-sequencia LIKE internac-impto-faixa.num-sequencia NO-UNDO.

    FIND FIRST bfinternac-impto-faixa WHERE 
        bfinternac-impto-faixa.cod-estabel = pcod-estabel AND 
        bfinternac-impto-faixa.num-sequencia = pnum-sequencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfinternac-impto-faixa THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfinternac-impto-faixa)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToParamImp DBOProgram 
PROCEDURE linkToParamImp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM ph-param-imp AS HANDLE NO-UNDO.

RUN getKey IN ph-param-imp (OUTPUT c-cod-estabel).

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByParamImp DBOProgram 
PROCEDURE openQueryByParamImp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK
                            WHERE {&TABLENAME}.cod-estabel = c-cod-estabel INDEXED-REPOSITION.

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
OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-impto-faixa DBOProgram 
PROCEDURE pi-calcula-impto-faixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM p-cod-estabel     LIKE {&TABLENAME}.cod-estabel      NO-UNDO.
DEF INPUT  PARAM p-base-impto      LIKE cotacao-item.preco-unit       NO-UNDO.
DEF INPUT  PARAM p-val-impto       LIKE cotacao-item-cex.val-desp     NO-UNDO.
DEF INPUT  PARAM p-data-cotacao    AS   DATE                          NO-UNDO.
DEF OUTPUT PARAM p-val-impto-faixa LIKE cotacao-item-cex.val-desp     NO-UNDO.

DEF VAR d-val-impto-conv       LIKE cotacao-item-cex.val-desp     NO-UNDO.
DEF VAR d-val-base-impto-conv  LIKE cotacao-item-cex.val-desp     NO-UNDO.
DEF VAR d-val-impto-faixa-conv LIKE cotacao-item-cex.val-desp     NO-UNDO.

FOR EACH bf{&TABLENAME} NO-LOCK
    WHERE bf{&TABLENAME}.cod-estabel = p-cod-estabel:
    
    ASSIGN d-val-impto-conv = 0.

    IF bf{&TABLENAME}.cdn-moed-base-impto <> 0 THEN DO:
        IF d-cotacao = 0 THEN
            RUN cdp/cd0812.p (INPUT 0,
                              INPUT bf{&TABLENAME}.cdn-moed-base-impto,
                              INPUT p-base-impto,
                              INPUT p-data-cotacao,
                              OUTPUT d-val-base-impto-conv).
        ELSE
            RUN cdp/cd0812a.p (INPUT 0,
                               INPUT bf{&TABLENAME}.cdn-moed-base-impto,
                               INPUT p-base-impto,
                               INPUT d-cotacao,
                               OUTPUT d-val-base-impto-conv).        
    END.                      
    ELSE
        ASSIGN d-val-base-impto-conv = p-base-impto.

    IF bf{&TABLENAME}.cdn-moed-impto <> 0 THEN DO:
        IF d-cotacao = 0 THEN
            RUN cdp/cd0812.p (INPUT 0,
                              INPUT bf{&TABLENAME}.cdn-moed-base-impto,
                              INPUT p-val-impto,
                              INPUT p-data-cotacao,
                              OUTPUT d-val-impto-conv).
        ELSE
            RUN cdp/cd0812a.p (INPUT 0,
                               INPUT bf{&TABLENAME}.cdn-moed-base-impto,
                               INPUT p-val-impto,
                               INPUT d-cotacao,
                               OUTPUT d-val-impto-conv).        
    END.                      
    ELSE
        ASSIGN d-val-impto-conv = p-val-impto.

    IF (    d-val-base-impto-conv >= bf{&TABLENAME}.val-inicial-base
        AND d-val-base-impto-conv <= bf{&TABLENAME}.val-final-base) 
        AND bf{&TABLENAME}.val-max-impto < d-val-impto-conv THEN DO:

        ASSIGN d-val-impto-faixa-conv = 0.

        IF bf{&TABLENAME}.cdn-moed-impto <> 0 THEN DO:        
            /*Converte da MOEDA da faixa (im0007) para a moeda 0 o valor, pois a taxa de estat°stica Ç sempre em pesos*/
            IF d-cotacao = 0 THEN
                RUN cdp/cd0812.p (INPUT bf{&TABLENAME}.cdn-moed-base-impto,
                                  INPUT 0,
                                  INPUT bf{&TABLENAME}.val-max-impto,
                                  INPUT p-data-cotacao,
                                  OUTPUT d-val-impto-faixa-conv). 
            ELSE
                RUN cdp/cd0812a.p (INPUT bf{&TABLENAME}.cdn-moed-base-impto,
                                   INPUT 0,
                                   INPUT bf{&TABLENAME}.val-max-impto,
                                   INPUT d-cotacao,
                                   OUTPUT d-val-impto-faixa-conv). 
            
        END.                      
        ELSE
            ASSIGN d-val-impto-faixa-conv = bf{&TABLENAME}.val-max-impto.

        ASSIGN p-val-impto-faixa = d-val-impto-faixa-conv.
    END.
    
END.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaValorCotacao DBOProgram 
PROCEDURE setaValorCotacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-d-cotacao AS DECIMAL NO-UNDO.
    
    ASSIGN d-cotacao = p-d-cotacao.

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

    IF pType <> "DELETE":U THEN DO:
        IF NOT CAN-FIND(FIRST moeda
                        WHERE moeda.mo-codigo = RowObject.cdn-moed-base-impto) THEN DO:
            {utp/ut-liter.i "Moeda_Base_Imposto" *}
            {method/svc/errors/inserr.i
                  &ErrorNumber="2"
                  &ErrorType="EMS"
                  &ErrorParameters="TRIM(RETURN-VALUE)"}
        END. 
    
        IF NOT CAN-FIND(FIRST moeda
                        WHERE moeda.mo-codigo = RowObject.cdn-moed-impto) THEN DO:
            {utp/ut-liter.i "Moeda_Imposto" *}
            {method/svc/errors/inserr.i
                  &ErrorNumber="2"
                  &ErrorType="EMS"
                  &ErrorParameters="TRIM(RETURN-VALUE)"}
        END. 
    
        IF RowObject.val-max-impto = 0 THEN DO:
            {method/svc/errors/inserr.i
                  &ErrorNumber="4199"
                  &ErrorType="EMS"
                  &ErrorParameters="''"}
        END.

        IF CAN-FIND(FIRST bf{&TABLENAME}
                    WHERE bf{&TABLENAME}.cod-estabel   = RowObject.cod-estabel
                    AND   bf{&TABLENAME}.val-max-impto = RowObject.val-max-impto
                    AND   bf{&TABLENAME}.num-sequencia <> RowObject.num-sequencia) THEN DO:
            {method/svc/errors/inserr.i
                  &ErrorNumber="55836"
                  &ErrorType="EMS"
                  &ErrorParameters="''"}
        END.
    
        IF RowObject.val-inicial-base >= RowObject.val-final-base THEN DO:
            {method/svc/errors/inserr.i
                  &ErrorNumber="7466"
                  &ErrorType="EMS"
                  &ErrorParameters="''"}
        END.
    
        IF CAN-FIND(FIRST bf{&TABLENAME}
                    WHERE bf{&TABLENAME}.cod-estabel      = RowObject.cod-estabel
                    AND   bf{&TABLENAME}.val-inicial-base = RowObject.val-inicial-base
                    AND   bf{&TABLENAME}.num-sequencia <> RowObject.num-sequencia) THEN DO:
            {utp/ut-liter.i "Valor_Inicial_Base" *}
            {method/svc/errors/inserr.i
                  &ErrorNumber="1"
                  &ErrorType="EMS"
                  &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.
    
        IF CAN-FIND(FIRST bf{&TABLENAME}
                    WHERE bf{&TABLENAME}.cod-estabel    = RowObject.cod-estabel
                    AND   bf{&TABLENAME}.val-final-base = RowObject.val-final-base
                    AND   bf{&TABLENAME}.num-sequencia <> RowObject.num-sequencia) THEN DO:
            {utp/ut-liter.i "Valor_Final_Base" *}
            {method/svc/errors/inserr.i
                  &ErrorNumber="1"
                  &ErrorType="EMS"
                  &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.
    
        ASSIGN l-erro = NO.
    
        FOR EACH bf{&TABLENAME} NO-LOCK
            WHERE bf{&TABLENAME}.cod-estabel   = RowObject.cod-estabel
            AND   bf{&TABLENAME}.num-sequencia <> RowObject.num-sequencia:
            IF (RowObject.val-inicial-base  >= bf{&TABLENAME}.val-inicial-base AND 
                RowObject.val-inicial-base <= bf{&TABLENAME}.val-final-base)
                    OR (RowObject.val-final-base  >= bf{&TABLENAME}.val-inicial-base AND 
                        RowObject.val-final-base <= bf{&TABLENAME}.val-final-base) THEN
                ASSIGN l-erro = YES.        
        END.
    
        IF l-erro THEN DO:
            {method/svc/errors/inserr.i
                  &ErrorNumber="55837"
                  &ErrorType="EMS"
                  &ErrorParameters="''"}
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

