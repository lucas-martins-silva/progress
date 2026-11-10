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

{include/i-prgvrs.i BOIN01073 2.00.00.016 } /*** "010016" 06/03/2025 10:55:28 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN01073 MUT}
&ENDIF

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN01073
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-internac
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
{inbo/boin01073.i RowObject}
{utp/ut-glob.i}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bf-item-internac-aux FOR {&TableName}.

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
         HEIGHT             = 9.58
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
        WHEN "cod-ident-item":U THEN ASSIGN pFieldValue = RowObject.cod-ident-item.
        WHEN "cod-tipo-codific":U THEN ASSIGN pFieldValue = RowObject.cod-tipo-codific.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
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
        WHEN "cdn-imposto-saida-div":U THEN ASSIGN pFieldValue = RowObject.cdn-imposto-saida-div. 
        WHEN "idi-tipo-existencia":U THEN ASSIGN pFieldValue = RowObject.idi-tipo-existencia. 
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice itmntrnc_id
  Parameters:  
               retorna valor do campo it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE item-internac.it-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo.

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
        WHEN "log-codific-padr":U THEN ASSIGN pFieldValue = RowObject.log-codific-padr.
        WHEN "log-isento":U THEN ASSIGN pFieldValue = RowObject.log-isento.
        WHEN "log-direito-tribut" THEN ASSIGN pFieldValue = RowObject.log-direito-tribut.
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
  Purpose:     Reposiciona registro com base no °ndice itmntrnc_id
  Parameters:  
               recebe valor do campo it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE item-internac.it-codigo NO-UNDO.

    FIND FIRST bfitem-internac WHERE 
        bfitem-internac.it-codigo = pit-codigo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-internac THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-internac)).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
 OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salva-item-internac DBOProgram 
PROCEDURE pi-salva-item-internac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-it-codigo         LIKE item.it-codigo                   NO-UNDO.
    DEF INPUT PARAM p-tg-isento         LIKE item-internac.log-isento         NO-UNDO.
    DEF INPUT PARAM p-tg-cod-padrao     LIKE item-internac.log-codific-pad    NO-UNDO.
    DEF INPUT PARAM p-c-cod-tipo-codfic LIKE item-internac.cod-tipo-codific   NO-UNDO.
    DEF INPUT PARAM p-c-cod-ident-item  LIKE item-internac.cod-ident-item     NO-UNDO.
    DEF INPUT PARAM p-c-modelo          AS   CHAR                             NO-UNDO.
    DEF INPUT PARAM p-c-usa-desc-item   AS   CHAR                             NO-UNDO.
    DEF INPUT PARAM p-i-cod-imp-percep  LIKE item-internac.num-livre-1        NO-UNDO.

    FIND FIRST bf-item-internac-aux EXCLUSIVE-LOCK
        WHERE  bf-item-internac-aux.it-codigo = p-it-codigo  NO-ERROR.
    
    IF NOT AVAIL bf-item-internac-aux THEN DO:
        CREATE  bf-item-internac-aux.
        ASSIGN  bf-item-internac-aux.it-codigo = p-it-codigo.
    END.

    ASSIGN bf-item-internac-aux.log-isento                   = p-tg-isento
           bf-item-internac-aux.log-codific-padr             = p-tg-cod-padrao
           bf-item-internac-aux.cod-tipo-codific             = p-c-cod-tipo-codfic
           bf-item-internac-aux.cod-ident-item               = p-c-cod-ident-item
           OVERLAY(bf-item-internac-aux.cod-livre-1, 1, 100) = p-c-modelo
           OVERLAY(bf-item-internac-aux.cod-livre-1, 101, 1) = p-c-usa-desc-item
           bf-item-internac-aux.num-livre-1                  = p-i-cod-imp-percep.
    
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

         IF (pType = "CREATE":U OR pType = "UPDATE") THEN DO:
             
             IF i-pais-impto-usuario = 21 THEN DO:
                 DEF VAR l-cd0204   AS LOG NO-UNDO.
                 DEF VAR v-num-cont AS INT NO-UNDO.
                 ASSIGN v-num-cont = 1.
                 /* Pula a validaá∆o se a chamada do programa vier do programa v34in172(viewer do cd0204) */
                 REPEAT WHILE PROGRAM-NAME(v-num-cont) <> ?.
                     IF INDEX(PROGRAM-NAME(v-num-cont),"v34in172") <> 0 THEN DO:
                         ASSIGN l-cd0204 = YES.
                         LEAVE.
                     END.
                     ASSIGN v-num-cont = v-num-cont + 1.
                 END.

                 IF (RowObject.cdn-sustent-tribut <= 0 OR RowObject.cdn-sustent-tribut > 15) AND l-cd0204 = NO THEN DO:
                    {utp/ut-liter.i C¢digo_Sustento *}
                    {method/svc/errors/inserr.i &ErrorNumber="3662" /* &1 deve estar entre &2 e &3 */
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="RETURN-VALUE + '~~~~' + '1' + '~~~~' + '15' " }
                 END.
             END.
             
             IF i-pais-impto-usuario = 33 /* Peru*/ THEN DO:
                DEF VAR c-liter AS CHAR NO-UNDO.
                
                IF RowObject.num-livre-2 <> 0 THEN DO: 
                
                    FIND FIRST tipo-tax-internac
                         WHERE tipo-tax-internac.cod-tax = RowObject.num-livre-2  AND
                               tipo-tax-internac.log-livre-1 = YES NO-LOCK NO-ERROR.
                    IF NOT AVAIL tipo-tax-internac THEN DO:
                
                        {utp/ut-liter.i "C¢digo_Imposto_Percepá∆o__" *}
                        ASSIGN c-liter = TRIM(RETURN-VALUE).
                        {utp/ut-liter.i "do tipo Imposto de Percepá∆o" *}
                        ASSIGN c-liter = c-liter + "~~" + TRIM(RETURN-VALUE).
                        {utp/ut-liter.i "Imposto informado deve estar marcado como Imposto Percepá∆o no CD0182" *}
                        ASSIGN c-liter = c-liter + "~~" + TRIM(RETURN-VALUE).
                    
                        {method/svc/errors/inserr.i &ErrorNumber="32387" /* &1 deve ser &2 ~~ &1 deve ser &2. &3 */
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="c-liter" }
                    END.
                END.    
             END.
             
             /*C¢digo do Imposto n∆o pode ser igual ao c¢digo da Retená∆o de IR*/
             FOR FIRST item-mat NO-LOCK
                 WHERE item-mat.it-codigo = RowObject.it-codigo:
                 IF (RowObject.cdn-imposto-retenc-ir <> 0 AND item-mat.cod-tax <> 0) 
                     AND RowObject.cdn-imposto-retenc-ir = item-mat.cod-tax THEN DO:
                     {method/svc/errors/inserr.i &ErrorNumber="53919"
                                                 &ErrorType="EMS"
                                                 &ErrorSubType="ERROR"
                                                 &ErrorParameters="''"} 
                 END.
             END.

             IF RowObject.cdn-imposto-retenc-ir <> 0 THEN DO:
                 FOR FIRST tipo-tax NO-LOCK
                     WHERE tipo-tax.cod-tax = RowObject.cdn-imposto-retenc-ir:
                     IF tipo-tax.tipo <> 1 THEN DO:
                         {method/svc/errors/inserr.i &ErrorNumber="7417"
                                                     &ErrorType="EMS"
                                                     &ErrorSubType="ERROR"
                                                     &ErrorParameters="''"} 
                     END.
                     
                     /*O valor da base de retená∆o deve ser Valor Item*/
                     IF tipo-tax.idi-val-base-retenc <> 1 THEN DO:
                         {utp/ut-liter.i Valor_Item}
                         {method/svc/errors/inserr.i &ErrorNumber="53952"
                                                     &ErrorType="EMS"
                                                     &ErrorSubType="ERROR"
                                                     &ErrorParameters="RETURN-VALUE"} 
                     END.
                 END.
             END.

             IF  RowObject.cdn-imposto-retenc-ir <> 0 
                 AND NOT CAN-FIND(FIRST tipo-tax
                                  WHERE tipo-tax.cod-tax = RowObject.cdn-imposto-retenc-ir) THEN DO:
                 {utp/ut-liter.i CΩdigo_Imposto_Retená∆o_IR *}
                 {method/svc/errors/inserr.i &ErrorNumber="2" /* C¢digo Imposto n∆o cadastrado */
                                             &ErrorType="EMS"
                                             &ErrorSubType="ERROR"
                                             &ErrorParameters="RETURN-VALUE" }
                                           
             END.

             IF  i-pais-impto-usuario = 2
             OR  i-pais-impto-usuario = 21 THEN DO:
                 IF RowObject.cdn-imposto-saida-div <>0 
                    AND NOT CAN-FIND(FIRST tipo-tax
                                 WHERE tipo-tax.cod-tax = RowObject.cdn-imposto-saida-div) THEN DO:
                                 
                     IF  i-pais-impto-usuario = 2 THEN {utp/ut-liter.i Imposto_Pa°s *}
                                                  ELSE {utp/ut-liter.i C¢digo_Imposto_ISD *}
                        
                     {method/svc/errors/inserr.i &ErrorNumber="2" /* C¢digo Imposto n∆o cadastrado */
                                                 &ErrorType="EMS"
                                                 &ErrorSubType="ERROR"
                                                 &ErrorParameters="RETURN-VALUE" }
                 END.
             END.
             
             IF  i-pais-impto-usuario = 33 /* Peru*/ THEN DO:
                 IF RowObject.idi-tipo-existencia = 0 THEN DO:
                     {utp/ut-liter.i Tipo_Existància *}
                     {method/svc/errors/inserr.i &ErrorNumber="17677" /* &1 deve ser diferente de branco*/
                                                 &ErrorType="EMS"
                                                 &ErrorSubType="ERROR"
                                                 &ErrorParameters="RETURN-VALUE" }
                 END.
             END.
             
         END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

