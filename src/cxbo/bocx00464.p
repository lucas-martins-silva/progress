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
{include/i-prgvrs.i BOCX00464 2.00.00.008} /*** "010008" 11/12/2023 10:13:21 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX00464
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName due-item-draw-nf
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
{cxbo/bocx00464.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Definiá∆o de Vari†veis Locais */
DEFINE VARIABLE lbl-msg                AS   CHARACTER                        NO-UNDO.
DEFINE VARIABLE de-cdd-due-ems         LIKE due-item-draw-nf.cdd-due-ems     NO-UNDO.
DEFINE VARIABLE i-num-versao-due       LIKE due-item-draw-nf.num-versao-due  NO-UNDO.
DEFINE VARIABLE i-num-seq-it-due       LIKE due-item-draw-nf.num-seq-it-due  NO-UNDO.
DEFINE VARIABLE i-num-seq-it-draw      LIKE due-item-draw-nf.num-seq-it-draw NO-UNDO.
DEFINE VARIABLE de-qtd-total-item-draw LIKE due-item-draw-nf.qtd-utlzad      NO-UNDO.
DEFINE VARIABLE de-vlr-total-item-draw LIKE due-item-draw-nf.val-item        NO-UNDO.

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
        WHEN "cod-chave-aces-nf-eletro":U THEN ASSIGN pFieldValue = RowObject.cod-chave-aces-nf-eletro.
        WHEN "cod-item":U THEN ASSIGN pFieldValue = RowObject.cod-item.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-nat-operac":U THEN ASSIGN pFieldValue = RowObject.cod-nat-operac.
        WHEN "cod-serie-docto":U THEN ASSIGN pFieldValue = RowObject.cod-serie-docto.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
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
        WHEN "dat-emis":U THEN ASSIGN pFieldValue = RowObject.dat-emis.
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-trans":U THEN ASSIGN pFieldValue = RowObject.dat-trans.
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
        WHEN "val-item":U THEN ASSIGN pFieldValue = RowObject.val-item.
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
        WHEN "cdn-emitente":U THEN ASSIGN pFieldValue = RowObject.cdn-emitente.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-seq-it-draw":U THEN ASSIGN pFieldValue = RowObject.num-seq-it-draw.
        WHEN "num-seq-it-draw-nf":U THEN ASSIGN pFieldValue = RowObject.num-seq-it-draw-nf.
        WHEN "num-seq-it-due":U THEN ASSIGN pFieldValue = RowObject.num-seq-it-due.
        WHEN "num-sequencia":U THEN ASSIGN pFieldValue = RowObject.num-sequencia.
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
  Purpose:     Retorna valores dos campos do °ndice dtmdrwnf_id1
  Parameters:  
               retorna valor do campo cdd-due-ems
               retorna valor do campo num-versao-due
               retorna valor do campo num-seq-it-due
               retorna valor do campo num-seq-it-draw
               retorna valor do campo num-seq-it-draw-nf
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdd-due-ems LIKE due-item-draw-nf.cdd-due-ems NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-versao-due LIKE due-item-draw-nf.num-versao-due NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq-it-due LIKE due-item-draw-nf.num-seq-it-due NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq-it-draw LIKE due-item-draw-nf.num-seq-it-draw NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq-it-draw-nf LIKE due-item-draw-nf.num-seq-it-draw-nf NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdd-due-ems = RowObject.cdd-due-ems
           pnum-versao-due = RowObject.num-versao-due
           pnum-seq-it-due = RowObject.num-seq-it-due
           pnum-seq-it-draw = RowObject.num-seq-it-draw
           pnum-seq-it-draw-nf = RowObject.num-seq-it-draw-nf.

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
  Purpose:     Reposiciona registro com base no °ndice dtmdrwnf_id1
  Parameters:  
               recebe valor do campo cdd-due-ems
               recebe valor do campo num-versao-due
               recebe valor do campo num-seq-it-due
               recebe valor do campo num-seq-it-draw
               recebe valor do campo num-seq-it-draw-nf
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdd-due-ems LIKE due-item-draw-nf.cdd-due-ems NO-UNDO.
    DEFINE INPUT PARAMETER pnum-versao-due LIKE due-item-draw-nf.num-versao-due NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-it-due LIKE due-item-draw-nf.num-seq-it-due NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-it-draw LIKE due-item-draw-nf.num-seq-it-draw NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-it-draw-nf LIKE due-item-draw-nf.num-seq-it-draw-nf NO-UNDO.

    FIND FIRST bfdue-item-draw-nf WHERE 
        bfdue-item-draw-nf.cdd-due-ems = pcdd-due-ems AND 
        bfdue-item-draw-nf.num-versao-due = pnum-versao-due AND 
        bfdue-item-draw-nf.num-seq-it-due = pnum-seq-it-due AND 
        bfdue-item-draw-nf.num-seq-it-draw = pnum-seq-it-draw AND 
        bfdue-item-draw-nf.num-seq-it-draw-nf = pnum-seq-it-draw-nf NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdue-item-draw-nf THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdue-item-draw-nf)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySeqItDrawNF DBOProgram 
PROCEDURE openQuerySeqItDrawNF :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura de todas as Notas Fiscais de Drawback para o Item
               de Drawback, utilizado no browser "Notas de Drawback" do folder
               "Drawback" do EX7000b
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
         WHERE {&tablename}.cdd-due-ems     = de-cdd-due-ems    
         AND   {&tablename}.num-versao-due  = i-num-versao-due 
         AND   {&tablename}.num-seq-it-due  = i-num-seq-it-due 
         AND   {&tablename}.num-seq-it-draw = i-num-seq-it-draw
         INDEXED-REPOSITION .
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDeleteOfDUE DBOProgram 
PROCEDURE piDeleteOfDUE :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDesvinculaItemDrawNF DBOProgram 
PROCEDURE piDesvinculaItemDrawNF :
/*:T------------------------------------------------------------------------------
  Purpose:     Elimina os registros referente a notas de drawback quando desvincula a NF da DU-E 
  Parameters:  p-cdd-due-ems    : N£mero interno da DU-E - (input)(integer)
               p-num-versao-due : N£mero da vers∆o da DU-E - (input)(integer)
               p-num-seq-it-due: Sequància do Item da DU-e - (input integer)
               p-num-seq-it-draw: Sequància do item de drawback - (input integer)
       
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cdd-due-ems     LIKE due-item-draw-nf.cdd-due-ems     NO-UNDO.
    DEFINE INPUT PARAMETER p-num-versao-due  LIKE due-item-draw-nf.num-versao-due  NO-UNDO.
    DEFINE INPUT PARAMETER p-num-seq-it-due  LIKE due-item-draw-nf.num-seq-it-due  NO-UNDO.
    DEFINE INPUT PARAMETER p-num-seq-it-draw LIKE due-item-draw-nf.num-seq-it-draw NO-UNDO.

    FOR EACH bfdue-item-draw-nf
       WHERE bfdue-item-draw-nf.cdd-due-ems     = p-cdd-due-ems 
         AND bfdue-item-draw-nf.num-versao-due  = p-num-versao-due
         AND bfdue-item-draw-nf.num-seq-it-due  = p-num-seq-it-due 
         AND bfdue-item-draw-nf.num-seq-it-draw = p-num-seq-it-draw EXCLUSIVE-LOCK:

        DELETE bfdue-item-draw-nf.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piProximaSeq DBOProgram 
PROCEDURE piProximaSeq :
/*------------------------------------------------------------------------------
  Purpose:     Sugere pr¢xima sequencia da nota de drawback no item da DU-E
  Parameters:   Entrada:    p-cdd-due-ems    : C¢digo interno da DU-E (decimal)
                            p-num-versao-due : Vers∆o da DU-E         (integer)
                            p-num-seq-it-due : Seq Item da DU-E       (integer)
                            p-num-seq-it-draw: Seq Item de Drawback   (integer)
                Sa°da p-next-seq: pr¢xima numeraá∆o sugerida pelo sistema (integer)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cdd-due-ems     LIKE bf{&TableName}.cdd-due-ems        NO-UNDO.
    DEFINE INPUT  PARAMETER p-num-versao-due  LIKE bf{&TableName}.num-versao-due     NO-UNDO.
    DEFINE INPUT  PARAMETER p-num-seq-it-due  LIKE bf{&TableName}.num-seq-it-due     NO-UNDO.
    DEFINE INPUT  PARAMETER p-num-seq-it-draw LIKE bf{&TableName}.num-seq-it-draw    NO-UNDO.
    DEFINE OUTPUT PARAMETER p-next-seq        LIKE bf{&TableName}.num-seq-it-draw-nf NO-UNDO.

    FIND LAST bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cdd-due-ems     = p-cdd-due-ems    
          AND bf{&TableName}.num-versao-due  = p-num-versao-due 
          AND bf{&TableName}.num-seq-it-due  = p-num-seq-it-due 
          AND bf{&TableName}.num-seq-it-draw = p-num-seq-it-draw NO-ERROR.
    IF NOT AVAIL bf{&TableName} THEN
       ASSIGN p-next-seq = 1.
    ELSE 
        ASSIGN p-next-seq = bf{&TableName}.num-seq-it-draw-nf + 1.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintBySeqItDrawNF DBOPr xogram 
PROCEDURE setConstraintBySeqItDrawNF :
/*------------------------------------------------------------------------------
  Purpose:     Seta vari†veis para utilizaá∆o no openQuerySeqItDrawNF
  Parameters:  Entrada: p-cdd-due-ems    : C¢digo interno da DU-E (decimal) 
                        p-num-versao-due : Vers∆o da DU-E         (integer) 
                        p-num-seq-it-due : Seq Item da DU-E       (integer) 
                        p-num-seq-it-draw: Seq Item de Drawback   (integer) 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cdd-due-ems     LIKE due-item-draw.cdd-due-ems     NO-UNDO.
    DEFINE INPUT PARAMETER p-num-versao-due  LIKE due-item-draw.num-versao-due  NO-UNDO.
    DEFINE INPUT PARAMETER p-num-seq-it-due  LIKE due-item-draw.num-seq-it-due  NO-UNDO.
    DEFINE INPUT PARAMETER p-num-seq-it-draw LIKE due-item-draw.num-seq-it-draw NO-UNDO.

    ASSIGN de-cdd-due-ems    = p-cdd-due-ems
           i-num-versao-due  = p-num-versao-due
           i-num-seq-it-due  = p-num-seq-it-due
           i-num-seq-it-draw = p-num-seq-it-draw.

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

    DEF BUFFER bf-due-item-draw FOR due-item-draw.

    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    IF  pType = "CREATE":U THEN DO:
        IF CAN-FIND(FIRST bfdue-item-draw-nf
                    WHERE bfdue-item-draw-nf.cdd-due-ems     = RowObject.cdd-due-ems    
                    AND   bfdue-item-draw-nf.num-versao-due  = RowObject.num-versao-due 
                    AND   bfdue-item-draw-nf.num-seq-it-due  = RowObject.num-seq-it-due 
                    AND   bfdue-item-draw-nf.num-seq-it-draw = RowObject.num-seq-it-draw
                    AND   bfdue-item-draw-nf.nro-docto       = RowObject.nro-docto
                    AND   bfdue-item-draw-nf.cod-serie-docto = RowObject.cod-serie-docto   
                    AND   bfdue-item-draw-nf.cdn-emitente    = RowObject.cdn-emitente
                    AND   bfdue-item-draw-nf.cod-nat-operac  = RowObject.cod-nat-operac
                    AND   bfdue-item-draw-nf.num-sequencia   = RowObject.num-sequencia) THEN DO:
            {utp/ut-table.i mgcex due-item-draw-nf 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i
                  &ErrorNumber="1"
                  &ErrorType="EMS"
                  &ErrorParameters=TRIM(RETURN-VALUE)}
        END.

        FIND FIRST bf-due-item-draw NO-LOCK
             WHERE bf-due-item-draw.cdd-due-ems     = RowObject.cdd-due-ems
             AND   bf-due-item-draw.num-versao-due  = RowObject.num-versao-due
             AND   bf-due-item-draw.num-seq-it-due  = RowObject.num-seq-it-due
             AND   bf-due-item-draw.num-seq-it-draw = RowObject.num-seq-it-draw NO-ERROR.

        FIND FIRST item-doc-est NO-LOCK
             WHERE item-doc-est.cod-emitente = RowObject.cdn-emitente
             AND   item-doc-est.serie-docto  = RowObject.cod-serie-docto
             AND   item-doc-est.nat-operacao = RowObject.cod-nat-operac
             AND   item-doc-est.nro-docto    = RowObject.nro-docto
             AND   item-doc-est.sequencia    = RowObject.num-sequencia
             AND   item-doc-est.it-codigo    = RowObject.cod-item NO-ERROR.
        IF  AVAIL item-doc-est THEN DO:
            FOR FIRST docum-est FIELDS (log-1 ce-atual cod-chave-aces-nf-eletro idi-sit-nf-eletro) NO-LOCK
                WHERE docum-est.serie-docto  = item-doc-est.serie-docto 
                  AND docum-est.nro-docto    = item-doc-est.nro-docto   
                  AND docum-est.cod-emitente = item-doc-est.cod-emitente
                  AND docum-est.nat-operacao = item-doc-est.nat-operacao:
    
                IF docum-est.log-1 THEN DO:
                    {utp/ut-liter.i Documento_informado_refere-se_Ö_Nota_Pr¢pria *}
                    ASSIGN lbl-msg = TRIM(RETURN-VALUE).
                    {utp/ut-liter.i Documento * }
                    {method/svc/errors/inserr.i
                            &ErrorNumber="56009"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="lbl-msg + '~~~~~' + RETURN-VALUE + '~~~~' + lbl-msg"}
    
    
                END.
                ELSE DO:
                    IF NOT docum-est.ce-atual THEN DO:
                        {utp/ut-liter.i Documento_n∆o_est†_atualizado_no_Estoque *}
                        ASSIGN lbl-msg = TRIM(RETURN-VALUE).
                        {utp/ut-liter.i Documento * }
                        {method/svc/errors/inserr.i
                                &ErrorNumber="56009"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="lbl-msg + '~~~~~' + RETURN-VALUE + '~~~~' + lbl-msg"}
                    END.
        
                    IF docum-est.cod-chave-aces-nf-eletro = "":U THEN DO:
                        {utp/ut-liter.i Documento_n∆o_possui_Chave_de_Acesso_da_Nota_Fiscal_Eletrìnica *}
                        ASSIGN lbl-msg = TRIM(RETURN-VALUE).
                        {utp/ut-liter.i Documento * }
                        {method/svc/errors/inserr.i
                                &ErrorNumber="56009"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="lbl-msg + '~~~~~' + RETURN-VALUE + '~~~~' + lbl-msg"}
                    END.
        
                    IF docum-est.idi-sit-nf-eletro <> 3 THEN DO:
                        {utp/ut-liter.i Documento_n∆o_est†_com_Uso_Autorizado_na_SEFAZ *}
                        ASSIGN lbl-msg = TRIM(RETURN-VALUE).
                        {utp/ut-liter.i Documento * }
                        {method/svc/errors/inserr.i
                                &ErrorNumber="56009"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="lbl-msg + '~~~~~' + RETURN-VALUE + '~~~~' + lbl-msg"}
                    END.
                END.
            END.

            FOR FIRST natur-oper FIELDS (tipo) NO-LOCK
                WHERE natur-oper.nat-operacao = item-doc-est.nat-operacao:
            END.
            IF  AVAIL natur-oper
            AND natur-oper.tipo <> 1 /* Entrada */ THEN DO:
                {utp/ut-liter.i O_Item_do_documento_deve_estar_ralacionado_a_uma_Natureza_do_Tipo_Entrada *}
                ASSIGN lbl-msg = TRIM(RETURN-VALUE).
                {utp/ut-liter.i Documento * }
                {method/svc/errors/inserr.i
                        &ErrorNumber="56009"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="lbl-msg + '~~~~~' + RETURN-VALUE + '~~~~' + lbl-msg"}
            END.

            IF  item-doc-est.class-fiscal <> bf-due-item-draw.cod-ncm THEN DO:
                {utp/ut-liter.i Classificaá∆o_Fiscal_do_Item_da_Nota_diferente_da_NCM_do_Item_Drawback *}
                ASSIGN lbl-msg = TRIM(RETURN-VALUE).
                {utp/ut-liter.i Documento * }
                {method/svc/errors/inserr.i
                        &ErrorNumber="56009"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="lbl-msg + '~~~~~' + RETURN-VALUE + '~~~~' + lbl-msg"}
            END.

            IF RowObject.qtd-utlzad <= 0 THEN DO:
                {utp/ut-liter.i Quantidade_deve_ser_maior_que_Zero *}
                ASSIGN lbl-msg = TRIM(RETURN-VALUE).
                {utp/ut-liter.i Quantidade * }
                {method/svc/errors/inserr.i
                        &ErrorNumber="56009"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="lbl-msg + '~~~~~' + RETURN-VALUE + '~~~~' + lbl-msg"}
            END.
            ELSE DO:
                IF  RowObject.qtd-utlzad > item-doc-est.quantidade THEN DO:
                    {utp/ut-liter.i Quantidade_informada_n∆o_pode_ultrapassar_a_Quantidade_do_Item_do_Documento_Fiscal *}
                    ASSIGN lbl-msg = TRIM(RETURN-VALUE).
                    {utp/ut-liter.i Quantidade * }
                    {method/svc/errors/inserr.i
                            &ErrorNumber="56009"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="lbl-msg + '~~~~~' + RETURN-VALUE + '~~~~' + lbl-msg"}
                END.
            END.

            IF RowObject.val-item <= 0 THEN DO:
                {utp/ut-liter.i Valor_deve_ser_maior_que_Zero *}
                ASSIGN lbl-msg = TRIM(RETURN-VALUE).
                {utp/ut-liter.i Valor * }
                {method/svc/errors/inserr.i
                        &ErrorNumber="56009"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="lbl-msg + '~~~~~' + RETURN-VALUE + '~~~~' + lbl-msg"}
            END.
            ELSE DO:
                IF  RowObject.val-item > item-doc-est.preco-total[1] THEN DO:
                    {utp/ut-liter.i Valor_Informado_n∆o_pode_ultrapassar_o_Valor_do_Item_do_Documento_Fiscal *}
                    ASSIGN lbl-msg = TRIM(RETURN-VALUE).
                    {utp/ut-liter.i Valor * }
                    {method/svc/errors/inserr.i
                            &ErrorNumber="56009"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="lbl-msg + '~~~~~' + RETURN-VALUE + '~~~~' + lbl-msg"}
                END.
            END.

            ASSIGN de-qtd-total-item-draw = RowObject.qtd-utlzad
                   de-vlr-total-item-draw = RowObject.val-item.

            FOR EACH bfdue-item-draw-nf NO-LOCK
                WHERE bfdue-item-draw-nf.nro-docto       = RowObject.nro-docto
                AND   bfdue-item-draw-nf.cod-serie-docto = RowObject.cod-serie-docto   
                AND   bfdue-item-draw-nf.cdn-emitente    = RowObject.cdn-emitente
                AND   bfdue-item-draw-nf.cod-nat-operac  = RowObject.cod-nat-operac
                AND   bfdue-item-draw-nf.num-sequencia   = RowObject.num-sequencia:
                ASSIGN de-vlr-total-item-draw = de-vlr-total-item-draw + bfdue-item-draw-nf.val-item
                       de-qtd-total-item-draw = de-qtd-total-item-draw + bfdue-item-draw-nf.qtd-utlzad.
            END.

            IF  de-qtd-total-item-draw > item-doc-est.quantidade THEN DO:
                {utp/ut-liter.i A_Soma_da(s)_Quantidade(s)_Informada(s)_Ultrapassa_a_Quantidade_do_Item_do_Documento_Fiscal *}
                ASSIGN lbl-msg = TRIM(RETURN-VALUE).
                {utp/ut-liter.i Quantidade * }
                {method/svc/errors/inserr.i
                        &ErrorNumber="56009"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="lbl-msg + '~~~~~' + RETURN-VALUE + '~~~~' + lbl-msg"}
                        
            END.

            IF  de-vlr-total-item-draw > item-doc-est.preco-total[1] THEN DO:
                {utp/ut-liter.i A_Soma_do(s)_Valor(es)_Informado(s)_Ultrapassa_o_Valor_do_Item_do_Documento_Fiscal *}
                ASSIGN lbl-msg = TRIM(RETURN-VALUE).
                {utp/ut-liter.i Valor * }
                {method/svc/errors/inserr.i
                        &ErrorNumber="56009"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="lbl-msg + '~~~~~' + RETURN-VALUE + '~~~~' + lbl-msg"}
            END.
        END.
        ELSE DO:
            {utp/ut-table.i movind item-doc-est 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i
                  &ErrorNumber="2"
                  &ErrorType="EMS"
                  &ErrorParameters=TRIM(RETURN-VALUE)}
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

