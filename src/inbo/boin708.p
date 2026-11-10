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
{include/i-prgvrs.i BOIN708 2.00.00.002 } /*** "010002" 24/11/2023 13:25:27  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN708 MUT}
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
&GLOBAL-DEFINE DBOName BOIN708
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName Desp-item-fornec-estab
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

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
{inbo/boin708.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
def var c-it-codigo    as char no-undo.
def var c-cod-estabel  as char no-undo.
def var i-cod-emitente as int  no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram



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
         HEIGHT             = 2.01
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
        WHEN "Cod-despesa":U THEN ASSIGN pFieldValue = RowObject.Cod-despesa.
        WHEN "Cod-estabel":U THEN ASSIGN pFieldValue = RowObject.Cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "It-codigo":U THEN ASSIGN pFieldValue = RowObject.It-codigo.
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
        WHEN "Val-despesa":U THEN ASSIGN pFieldValue = RowObject.Val-despesa.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "Val-Per-desp":U THEN ASSIGN pFieldValue = RowObject.Val-Per-desp.
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
        WHEN "Cod-emite":U THEN ASSIGN pFieldValue = RowObject.Cod-emite.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "Num-seq-desp":U THEN ASSIGN pFieldValue = RowObject.Num-seq-desp.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice Desp-item
  Parameters:  
               retorna valor do campo It-codigo
               retorna valor do campo Cod-emite
               retorna valor do campo Cod-estabel
               retorna valor do campo Num-seq-desp
               retorna valor do campo Cod-despesa
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pIt-codigo LIKE Desp-item-fornec-estab.It-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pCod-emite LIKE Desp-item-fornec-estab.Cod-emite NO-UNDO.
    DEFINE OUTPUT PARAMETER pCod-estabel LIKE Desp-item-fornec-estab.Cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pNum-seq-desp LIKE Desp-item-fornec-estab.Num-seq-desp NO-UNDO.
    DEFINE OUTPUT PARAMETER pCod-despesa LIKE Desp-item-fornec-estab.Cod-despesa NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pIt-codigo = RowObject.It-codigo
           pCod-emite = RowObject.Cod-emite
           pCod-estabel = RowObject.Cod-estabel
           pNum-seq-desp = RowObject.Num-seq-desp
           pCod-despesa = RowObject.Cod-despesa.

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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSeqDespesa DBOProgram 
PROCEDURE getSeqDespesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p-it-codigo    like desp-item-fornec-estab.it-codigo   no-undo.
    def input  param p-cod-emitente like desp-item-fornec-estab.cod-emite   no-undo.
    def input  param p-cod-estabel  like desp-item-fornec-estab.cod-estabel no-undo.
    def output param p-seq-despesa  as int  no-undo.
    
    /* Busca £ltima sequencia da despesa do item-fornec-estab para 
       sugerir a pr¢xima no cc0531c.w */
    find last  bfDesp-item-fornec-estab
         where bfDesp-item-fornec-estab.it-codigo   = p-it-codigo
           and bfDesp-item-fornec-estab.cod-emite   = p-cod-emitente
           and bfDesp-item-fornec-estab.cod-estabel = p-cod-estabel no-lock no-error.
    if  not avail bfDesp-item-fornec-estab then
        assign p-seq-despesa = 1.
    else
        assign p-seq-despesa = bfDesp-item-fornec-estab.num-seq-desp + 1.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice Desp-item
  Parameters:  
               recebe valor do campo It-codigo
               recebe valor do campo Cod-emite
               recebe valor do campo Cod-estabel
               recebe valor do campo Num-seq-desp
               recebe valor do campo Cod-despesa
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pIt-codigo LIKE Desp-item-fornec-estab.It-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pCod-emite LIKE Desp-item-fornec-estab.Cod-emite NO-UNDO.
    DEFINE INPUT PARAMETER pCod-estabel LIKE Desp-item-fornec-estab.Cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pNum-seq-desp LIKE Desp-item-fornec-estab.Num-seq-desp NO-UNDO.
    DEFINE INPUT PARAMETER pCod-despesa LIKE Desp-item-fornec-estab.Cod-despesa NO-UNDO.

    FIND FIRST bfDesp-item-fornec-estab WHERE 
        bfDesp-item-fornec-estab.It-codigo = pIt-codigo AND 
        bfDesp-item-fornec-estab.Cod-emite = pCod-emite AND 
        bfDesp-item-fornec-estab.Cod-estabel = pCod-estabel AND 
        bfDesp-item-fornec-estab.Num-seq-desp = pNum-seq-desp AND 
        bfDesp-item-fornec-estab.Cod-despesa = pCod-despesa NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfDesp-item-fornec-estab THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfDesp-item-fornec-estab)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linktoitem-fornec-estab DBOProgram 
PROCEDURE linktoitem-fornec-estab :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
def input param p-handle as handle no-undo.

run getcharfield in p-handle (input "cod-estabel":U,
                              output c-cod-estabel).
run getcharfield in p-handle (input "it-codigo":U,
                              output c-it-codigo).
run getintfield in p-handle (input "cod-emitente":U,
                              output i-cod-emitente).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openquerymain DBOProgram 
PROCEDURE openquerymain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    OPEN QUERY {&QueryName} FOR EACH desp-item-fornec-estab NO-LOCK INDEXED-REPOSITION.    
    

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openqueryofitem-fornec-estab DBOProgram 
PROCEDURE openqueryofitem-fornec-estab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
open query {&queryname} for each {&tablename}
     where {&tablename}.cod-estabel = c-cod-estabel
       and {&tablename}.it-codigo   = c-it-codigo
       and {&tablename}.cod-emite   = i-cod-emitente no-lock
       indexed-reposition.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaDespesa DBOProgram 
PROCEDURE validaDespesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param rowid-item-fornec-estab as rowid no-undo.
    def output param l-existe      as log   no-undo.
    

    for first item-fornec-estab fields(cod-emite it-codigo cod-estabel)
        where rowid(item-fornec-estab) = rowid-item-fornec-estab no-lock,
        first desp-item-fornec-estab fields()
        where desp-item-fornec-estab.cod-emite   = item-fornec-estab.cod-emitente
          and desp-item-fornec-estab.cod-estabel = item-fornec-estab.cod-estabel
          and desp-item-fornec-estab.it-codigo   = item-fornec-estab.it-codigo
          no-lock:
          assign l-existe = yes.
    end.

    return "OK":U.
 
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
    
    if  pType = "Create":U then do:
    
        if  can-find(first bfdesp-item-fornec-estab 
                     where bfdesp-item-fornec-estab.it-codigo    = RowObject.it-codigo
                       and bfdesp-item-fornec-estab.cod-emite    = RowObject.cod-emite
                       and bfdesp-item-fornec-estab.cod-estabel  = RowObject.cod-estabel
                       and bfdesp-item-fornec-estab.cod-despesa  = RowObject.cod-despesa
                       and bfdesp-item-fornec-estab.num-seq-desp = RowObject.num-seq-desp) then do:
                       
            {method/svc/errors/inserr.i
                                &ErrorNumber="27023" /* J† existe Despesa com Seq: &1 Despesa: &2 */
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="string(RowObject.num-seq-desp) + string(RowObject.cod-despesa)"} 
        end.        
        
    end.
    if  pType = "Create":U 
    or  pType = "Update":U then do:
        
        find despesa where
             despesa.cod-despesa = RowObject.cod-despesa no-lock no-error.
        if  avail despesa then do:
            if  despesa.cdn-tp-calculo = 1 /* Percentual */
            then do:
                if RowObject.val-per-desp = 0 then do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-percentual AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Percentual" *}
                    ASSIGN c-lbl-liter-percentual = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="822" /* Percentual deve ser informado */
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" 
                                        &ErrorParameters="c-lbl-liter-percentual"}
                end.
                /* Zera o Valor qdo a despesa for percentual */
                assign RowObject.val-despesa = 0.
            end.
            else if despesa.cdn-tp-calculo = 2 /* Valor */
            then do:
                if  RowObject.val-despesa = 0 then do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-valor-da-despesa AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Valor_da_despesa" *}
                    ASSIGN c-lbl-liter-valor-da-despesa = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="822" /* Valor da despesa deve ser informado */
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" 
                                        &ErrorParameters="c-lbl-liter-valor-da-despesa"}                
                end.
                /* Zera o Percentual qdo tipo da despesa for valor */
                assign RowObject.val-per-desp = 0.
            end.
        end.
        else do:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgdis despesa 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i
                                &ErrorNumber="2" /*N∆o foi encontrada Despesa para a chave informada*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters=TRIM(RETURN-VALUE)}
        end.
    end.
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


