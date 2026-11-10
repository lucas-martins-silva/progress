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

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX00515
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-atrib-cond
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
{cxbo/bocx00515.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-cod-item       LIKE item-atrib-cond.cod-item NO-UNDO.
DEFINE VARIABLE c-cod-class-fisc LIKE item-atrib-cond.cod-class-fisc NO-UNDO.
DEFINE VARIABLE c-cod-atrib      LIKE item-atrib-cond.cod-atrib NO-UNDO.
DEFINE VARIABLE c-cod-domin      LIKE item-atrib-cond.cod-domin NO-UNDO.
DEFINE VARIABLE i-ind-modal      LIKE item-atrib-cond.ind-modal NO-UNDO.
DEFINE VARIABLE i-num-seq        LIKE item-atrib-cond.num-seq NO-UNDO.

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
        WHEN "cod-atrib":U THEN ASSIGN pFieldValue = RowObject.cod-atrib.
        WHEN "cod-atrib-cond":U THEN ASSIGN pFieldValue = RowObject.cod-atrib-cond.
        WHEN "cod-class-fisc":U THEN ASSIGN pFieldValue = RowObject.cod-class-fisc.
        WHEN "cod-domin":U THEN ASSIGN pFieldValue = RowObject.cod-domin.
        WHEN "cod-domin-cond":U THEN ASSIGN pFieldValue = RowObject.cod-domin-cond.
        WHEN "cod-item":U THEN ASSIGN pFieldValue = RowObject.cod-item.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-valor":U THEN ASSIGN pFieldValue = RowObject.cod-valor.
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
        WHEN "val-valor":U THEN ASSIGN pFieldValue = RowObject.val-valor.
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
        WHEN "idi-forma-preench":U THEN ASSIGN pFieldValue = RowObject.idi-forma-preench.
        WHEN "ind-modal":U THEN ASSIGN pFieldValue = RowObject.ind-modal.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-seq":U THEN ASSIGN pFieldValue = RowObject.num-seq.
        WHEN "num-valor":U THEN ASSIGN pFieldValue = RowObject.num-valor.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice itAtribCond
  Parameters:  
               retorna valor do campo cod-item
               retorna valor do campo cod-class-fisc
               retorna valor do campo cod-atrib
               retorna valor do campo cod-domin
               retorna valor do campo ind-modal
               retorna valor do campo num-seq
               retorna valor do campo cod-atrib-cond
               retorna valor do campo cod-domin-cond
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-item LIKE item-atrib-cond.cod-item NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-class-fisc LIKE item-atrib-cond.cod-class-fisc NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-atrib LIKE item-atrib-cond.cod-atrib NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-domin LIKE item-atrib-cond.cod-domin NO-UNDO.
    DEFINE OUTPUT PARAMETER pind-modal LIKE item-atrib-cond.ind-modal NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq LIKE item-atrib-cond.num-seq NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-atrib-cond LIKE item-atrib-cond.cod-atrib-cond NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-domin-cond LIKE item-atrib-cond.cod-domin-cond NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-item = RowObject.cod-item
           pcod-class-fisc = RowObject.cod-class-fisc
           pcod-atrib = RowObject.cod-atrib
           pcod-domin = RowObject.cod-domin
           pind-modal = RowObject.ind-modal
           pnum-seq = RowObject.num-seq
           pcod-atrib-cond = RowObject.cod-atrib-cond
           pcod-domin-cond = RowObject.cod-domin-cond.

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
        WHEN "log-valor":U THEN ASSIGN pFieldValue = RowObject.log-valor.
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
  Purpose:     Reposiciona registro com base no °ndice itAtribCond
  Parameters:  
               recebe valor do campo cod-item
               recebe valor do campo cod-class-fisc
               recebe valor do campo cod-atrib
               recebe valor do campo cod-domin
               recebe valor do campo ind-modal
               recebe valor do campo num-seq
               recebe valor do campo cod-atrib-cond
               recebe valor do campo cod-domin-cond
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-item LIKE item-atrib-cond.cod-item NO-UNDO.
    DEFINE INPUT PARAMETER pcod-class-fisc LIKE item-atrib-cond.cod-class-fisc NO-UNDO.
    DEFINE INPUT PARAMETER pcod-atrib LIKE item-atrib-cond.cod-atrib NO-UNDO.
    DEFINE INPUT PARAMETER pcod-domin LIKE item-atrib-cond.cod-domin NO-UNDO.
    DEFINE INPUT PARAMETER pind-modal LIKE item-atrib-cond.ind-modal NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq LIKE item-atrib-cond.num-seq NO-UNDO.
    DEFINE INPUT PARAMETER pcod-atrib-cond LIKE item-atrib-cond.cod-atrib-cond NO-UNDO.
    DEFINE INPUT PARAMETER pcod-domin-cond LIKE item-atrib-cond.cod-domin-cond NO-UNDO.

    FIND FIRST bfitem-atrib-cond WHERE 
        bfitem-atrib-cond.cod-item = pcod-item AND 
        bfitem-atrib-cond.cod-class-fisc = pcod-class-fisc AND 
        bfitem-atrib-cond.cod-atrib = pcod-atrib AND 
        bfitem-atrib-cond.cod-domin = pcod-domin AND 
        bfitem-atrib-cond.ind-modal = pind-modal AND 
        bfitem-atrib-cond.num-seq = pnum-seq AND 
        bfitem-atrib-cond.cod-atrib-cond = pcod-atrib-cond AND 
        bfitem-atrib-cond.cod-domin-cond = pcod-domin-cond NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-atrib-cond THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-atrib-cond)).
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
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintAtribDet DBOProgram 
PROCEDURE setConstraintAtribDet :
/*------------------------------------------------------------------------------
  Purpose:     Recebe os parÉmetros para abertura da query "AtribDet"
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-item LIKE item-atrib-cond.cod-item NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-class-fisc LIKE item-atrib-cond.cod-class-fisc NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-atrib LIKE item-atrib-cond.cod-item NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-domin LIKE item-atrib-cond.cod-item NO-UNDO.
    DEFINE INPUT PARAMETER pi-ind-modal LIKE item-atrib-cond.ind-modal NO-UNDO.
    DEFINE input PARAMETER pi-num-seq LIKE item-atrib-cond.num-seq NO-UNDO.

    ASSIGN c-cod-item       = pc-cod-item
           c-cod-class-fisc = pc-cod-class-fisc
           c-cod-atrib      = pc-cod-atrib
           c-cod-domin      = pc-cod-domin
           i-ind-modal      = pi-ind-modal
           i-num-seq        = pi-num-seq.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByAtribDet DBOProgram
PROCEDURE openQueryByAtribDet :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME}
                               WHERE {&TABLENAME}.cod-item       = c-cod-item
                                 AND {&TABLENAME}.cod-class-fisc = c-cod-class-fisc
                                 AND {&TABLENAME}.cod-atrib      = c-cod-atrib
                                 AND {&TABLENAME}.cod-domin      = c-cod-domin
                                 AND {&TABLENAME}.ind-modal      = i-ind-modal
                                 AND {&TABLENAME}.num-seq        = i-num-seq
                                 NO-LOCK INDEXED-REPOSITION.

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

    IF  pType = "Create":U THEN do:
        if can-find(first item-atrib-cond no-lock
                    where item-atrib-cond.cod-item       = RowObject.cod-item      
                    and   item-atrib-cond.cod-class-fisc = RowObject.cod-class-fisc
                    and   item-atrib-cond.cod-atrib      = RowObject.cod-atrib     
                    and   item-atrib-cond.cod-domin      = RowObject.cod-domin     
                    and   item-atrib-cond.ind-modal      = RowObject.ind-modal     
                    and   item-atrib-cond.num-seq        = RowObject.num-seq
                    and   item-atrib-cond.cod-atrib-cond = RowObject.cod-atrib-cond
                    and   item-atrib-cond.cod-domin-cond = RowObject.cod-domin-cond) THEN do:
            {utp/ut-liter.i Item_Atributo_Condicionado * R}
            {method/svc/errors/inserr.i &ErrorNumber="1"
                            &ErrorType="EMS"
                            &ErrorSubType="Error"
                            &ErrorParameters="return-value"}
        end.
    end.

    IF  pType = "Create":U 
    or  pType = "Update":U THEN do:    
        if  not can-find(FIRST classif-atrib-cond-atrib 
                         WHERE classif-atrib-cond-atrib.cod-class-fisc = ""
                         AND   classif-atrib-cond-atrib.cod-atrib      = RowObject.cod-atrib
                         AND   classif-atrib-cond-atrib.cod-domin      = ""
                         AND   classif-atrib-cond-atrib.ind-modal      = RowObject.ind-modal
                         AND   classif-atrib-cond-atrib.cod-atrib-cond = RowObject.cod-atrib-cond) then do:
            {utp/ut-table.i mgcex classif-atrib-cond-atrib 1}
            {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="RETURN-VALUE" }
        END.

        IF  RowObject.cod-domin-cond <> ""
        and not can-find(FIRST dominio-atrib 
                         WHERE dominio-atrib.cod-domin    = RowObject.cod-domin-cond
                         AND   dominio-atrib.cod-atributo = RowObject.cod-atrib-cond) then do:
            {utp/ut-table.i mgcex dominio-atrib 1}
            {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="RETURN-VALUE" }
        end.
    end.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


