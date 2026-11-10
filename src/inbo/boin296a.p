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
*******************************************************************************/
{include/i-prgvrs.i BOIN296A 2.00.00.006} /*** "010006" 17/06/2025 16:40:48 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN296A MUT}
&ENDIF

/*--------------------------------------------------------------------------
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

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN296
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName pend-item
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

DEFINE QUERY {&QUERYNAME} for {&TABLENAME}, item scrolling.

&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
   &GLOBAL-DEFINE v9indrep  INDEXED-REPOSITION
&endif


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

&GLOBAL-DEFINE XMLReceiver YES    /* DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /* Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /* Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin296a.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
/*{method/dboqry.i}*/


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var c-op-combo      as char no-undo.
def var i-compr-fabric  as int no-undo.
def var l-ativo         as log no-undo.
def var l-auto          as log no-undo. 
def var l-todos         as log no-undo. 
def var l-obsoleto      as log no-undo.
def var i-op-radio      as int no-undo.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deletePendItem DBOProgram 
PROCEDURE deletePendItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-item   AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER p-modulo AS CHAR NO-UNDO.

FIND FIRST pend-item
     WHERE pend-item.it-codigo = p-item
     AND   pend-item.MODULO    = p-modulo EXCLUSIVE-LOCK NO-ERROR.

   IF AVAIL pend-item THEN
       DELETE pend-item.

   RETURN 'OK':U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetBatchRecordsCustom DBOProgram 
PROCEDURE GetBatchRecordsCustom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pItCodigo     AS CHAR FORMAT "x(16)" NO-UNDO.
DEFINE INPUT  PARAMETER pModulo       AS CHAR FORMAT "x(3)"  NO-UNDO.
DEFINE INPUT  PARAMETER pNext         AS LOGICAL NO-UNDO.
DEFINE INPUT  PARAMETER pRowsToReturn AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER pRowsReturned AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR RowObjectAux.

DEFINE VARIABLE c-comprado         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-fabricado        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-ativo            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-obsoleto-ord-aut AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-obsoleto-tod-ord AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-tot-obsoleto     AS CHARACTER  NO-UNDO.


{ utp/ut-liter.i Comprado *}
ASSIGN c-comprado = RETURN-VALUE .
{ utp/ut-liter.i Fabricado *}
ASSIGN c-fabricado = RETURN-VALUE.
{ utp/ut-liter.i Ativo *}
ASSIGN c-ativo = RETURN-VALUE .          
{ utp/ut-liter.i Obsoleto_Ordens_Autom†ticas *}
ASSIGN c-obsoleto-ord-aut = RETURN-VALUE .
{ utp/ut-liter.i Obsoleto_Todas_as_Ordens *}
ASSIGN c-obsoleto-tod-ord = RETURN-VALUE .
{ utp/ut-liter.i Totalmente_Obsoleto *}
ASSIGN c-tot-obsoleto = RETURN-VALUE .



DEFINE VAR pRowid        AS ROWID   NO-UNDO.

IF pItCodigo = ? THEN DO :
    GET FIRST {&QueryName} NO-LOCK.
    ASSIGN pRowid = ROWID({&TableName}).
END.
ELSE DO:
    FIND pend-item 
        WHERE pend-item.it-codigo = pItCodigo
        AND   pend-item.MODULO    = pModulo
        NO-LOCK NO-ERROR.
    IF AVAIL pend-item THEN 
        ASSIGN pRowid = ROWID(pend-item).
END.

&IF "{&ROW-NUM-DEFINED}" = "YES" &THEN
    DEFINE VARIABLE iNextSeq AS INTEGER NO-UNDO INIT 0.
&ENDIF
    
    /*--- Verifica permiss∆o de execuá∆o ---*/
    {method/svc/security/permit.i &Method="Navigation"}
    
    /*--- Limpa temptable RowObjectAux ---*/
    RUN emptyRowObjectAux IN THIS-PROCEDURE.
    
    IF pRowid <> ? THEN DO:
        
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:REPOSITION-TO-ROWID(pRowid) NO-ERROR.
        &ELSE
            REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
        &ENDIF
        /* DBO-XML-END */
        
            IF ERROR-STATUS:ERROR THEN DO:
            &IF "{&NewRecordOffQuery}" = "YES" &THEN
                /* DBO-XML-BEGIN */
                /* Se a Query Dinamica estiver habilitada, usa o handle dela */
                &IF {&DYNAMIC-QUERY-ENABLED} &THEN
                     hQuery:GET-FIRST(NO-LOCK).
                  ASSIGN pRowid = rowid({&TableName}).
                     hQuery:REPOSITION-TO-ROWID(pRowid) NO-ERROR.
                &ELSE
                    GET FIRST {&QueryName} NO-LOCK.
                    ASSIGN pRowid = rowid({&TableName}).
                    REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
                &ENDIF
            &ELSE
                RETURN "NOK":U.
            &ENDIF
            IF ERROR-STATUS:ERROR THEN do:
                RETURN "NOK":U.
            end.
        END.
        /* DBO-XML-BEGIN */
            /* Se a Query Dinamica estiver habilitada, usa o handle dela */
            &IF {&DYNAMIC-QUERY-ENABLED} &THEN
                hQuery:GET-NEXT(NO-LOCK).
            &ELSE
                GET NEXT {&QueryName} NO-LOCK.
            &ENDIF
        /* DBO-XML-END */
        /*--- Este teste torna-se necess†rio devido ao fato de realizar-se um 
              reposicionamento de um registro recÇm eliminado. Neste caso n∆o Ç 
              retornado erro no comando REPOSITION, pois o reposicionamento da
              QUERY Ç processado com base no RESULT-LIST ---*/
        IF NOT AVAILABLE {&TableName} THEN
            RETURN "NOK":U.
    END.
    
    IF pNext THEN DO:
        /* DBO-XML-BEGIN */
            /* Se a Query Dinamica estiver habilitada, usa o handle dela */
            &IF {&DYNAMIC-QUERY-ENABLED} &THEN
                hQuery:GET-NEXT(NO-LOCK).
            &ELSE
                GET NEXT {&QueryName} NO-LOCK.
            &ENDIF
        /* DBO-XML-END */
    END.
    
    /*--- Grava temptable RowObjectAux ---*/
    DO WHILE AVAILABLE({&TableName}):
        IF pRowsToReturn <> 0 AND pRowsReturned >= pRowsToReturn THEN
            LEAVE.

        /*--- Atualiza temptable RowObject ---*/
            RUN _copyBuffer2TT IN THIS-PROCEDURE.

&IF "{&ROW-NUM-DEFINED}" = "YES" &THEN
        ASSIGN iNextSeq = iNextSeq + 1
               RowObject.RowNum = iNextSeq.
&ENDIF
      /*--- Executa mÇtodos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="before"
                                        &Procedure="getBatchRecords"}

        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.

        /*--- Copia o registro da temptable RowObject para a temptable RowObjectAux ---*/
        CREATE RowObjectAux.
        ASSIGN RowObjectAux.it-codigo = RowObject.it-codigo
               RowObjectAux.modulo    = RowObject.modulo
               RowObjectAux.char-1    = ITEM.desc-item
               RowObjectAux.r-rowid   = ROWID(ITEM).
               
        
               
                
        IF item.compr-fabric = 1 THEN
            ASSIGN RowObjectAux.char-2 = c-comprado .
        ELSE 
            ASSIGN RowObjectAux.char-2 = c-fabricado .

        IF item.cod-obsoleto = 1 THEN 
            ASSIGN RowObjectAux.situacao = c-ativo.
        ELSE IF item.cod-obsoleto = 2 THEN
            ASSIGN RowObjectAux.situacao = c-obsoleto-ord-aut.
            ELSE IF item.cod-obsoleto = 3 THEN
                ASSIGN RowObjectAux.situacao = c-obsoleto-tod-ord.
                ELSE
                    ASSIGN RowObjectAux.situacao = c-tot-obsoleto.
                            
        ASSIGN pRowsReturned = pRowsReturned + 1.

        /*--- Executa mÇtodos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="after"
                                        &Procedure="getBatchRecords"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
      
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:GET-NEXT(NO-LOCK).
        &ELSE
            GET NEXT {&QueryName} NO-LOCK.
        &ENDIF
        /* DBO-XML-END */
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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "modulo":U THEN ASSIGN pFieldValue = RowObject.modulo.
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
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
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
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescModulo DBOProgram 
PROCEDURE getDescModulo :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pModulo AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pDescModulo LIKE modul_dtsul.des_modul_dtsul NO-UNDO.

    find modul_dtsul where 
         modul_dtsul.cod_modul_dtsul = pModulo no-lock no-error.
           
    IF AVAIL modul_dtsul THEN 
        assign pDescModulo = modul_dtsul.des_modul_dtsul.
    ELSE
        assign pDescModulo = "".

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
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice item-modulo
  Parameters:  
               retorna valor do campo it-codigo
               retorna valor do campo modulo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE pend-item.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pmodulo LIKE pend-item.modulo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo
           pmodulo = RowObject.modulo.

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
  Purpose:     Reposiciona registro com base no °ndice item-modulo
  Parameters:  
               recebe valor do campo it-codigo
               recebe valor do campo modulo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE pend-item.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pmodulo LIKE pend-item.modulo NO-UNDO.

    FIND FIRST bfpend-item WHERE 
        bfpend-item.it-codigo = pit-codigo AND 
        bfpend-item.modulo = pmodulo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpend-item THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpend-item)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryModulo DBOProgram 
PROCEDURE OpenQueryModulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 if i-op-radio = 1 then

       open query {&QueryName} for each {&TableName} where
                                        {&TableName}.modulo = c-op-combo no-lock,
                                   each item of {&TableName} where
                                        ((item.compr-fabric = 1 and i-compr-fabric <> 2) or
                                         (item.compr-fabric = 2 and i-compr-fabric  > 1))
                                   and ((item.cod-obsoleto = 1  and l-ativo)  
                                    or  (item.cod-obsoleto = 2  and l-auto )  
                                    or  (item.cod-obsoleto = 3  and l-todos)  
                                    or  (item.cod-obsoleto = 4  and l-obsoleto))
                                    no-lock by {&tablename}.it-codigo {&v9indrep}.
 else 
       open query {&QueryName} for each {&TableName} where
                                        {&TableName}.modulo = c-op-combo no-lock,
                                   each item of {&TableName} where
                                       ((item.compr-fabric = 1 and i-compr-fabric <> 2) or
                                        (item.compr-fabric = 2 and i-compr-fabric  > 1))
                                   and ((item.cod-obsoleto = 1 and l-ativo) 
                                    or  (item.cod-obsoleto = 2 and l-auto ) 
                                    or  (item.cod-obsoleto = 3 and l-todos) 
                                    or  (item.cod-obsoleto = 4 and l-obsoleto))
                                    no-lock by item.desc-item {&v9indrep}.
                                    
 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintModulo DBOProgram 
PROCEDURE SetConstraintModulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pCompr-fabric as int no-undo.
def input param pL-ativo      as log no-undo.
def input param pL-auto       as log no-undo. 
def input param pL-todas      as log no-undo. 
def input param pL-obsoleto   as log no-undo.
def input param pOpRadio      as int no-undo.
def input param pOpCombo      as char no-undo.

    
    assign  i-compr-fabric = pCompr-fabric 
            l-ativo        = pL-ativo 
            l-auto         = pL-auto 
            l-todos        = pL-todas 
            l-obsoleto     = pL-obsoleto
            i-op-radio     = pOpRadio
            c-op-combo     = pOpCombo. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

