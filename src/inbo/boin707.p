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
{include/i-prgvrs.i BOIN707 2.00.00.003 } /*** "010003" 24/11/2023 13:25:27  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN707 MUT}
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
&GLOBAL-DEFINE DBOName BOIN707
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName Desp-item-fornec
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin707.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
{utp/ut-glob.i} 

/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* MULTI-PLANTA */
DEF VAR i-tipo-movto AS INTEGER NO-UNDO.
{cdp/cd7300.i1}
/****************/

def var c-it-codigo    as char no-undo.
def var i-cod-emitente as int no-undo.

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
         HEIGHT             = 12.21
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeDeleteRecord DBOProgram 
PROCEDURE BeforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Tratamento Multiplanta na eliminacao da desp-item-fornec */
    RUN pi-envia-multiplanta IN THIS-PROCEDURE (INPUT 3).
    
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
        WHEN "Cod-despesa":U THEN ASSIGN pFieldValue = RowObject.Cod-despesa.
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
        WHEN "Val-per-desp":U THEN ASSIGN pFieldValue = RowObject.Val-per-desp.
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
        WHEN "Cod-emitente":U THEN ASSIGN pFieldValue = RowObject.Cod-emitente.
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
  Purpose:     Retorna valores dos campos do °ndice desp-item
  Parameters:  
               retorna valor do campo It-codigo
               retorna valor do campo Cod-emitente
               retorna valor do campo Num-seq-desp
               retorna valor do campo Cod-despesa
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pIt-codigo LIKE Desp-item-fornec.It-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pCod-emitente LIKE Desp-item-fornec.Cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pNum-seq-desp LIKE Desp-item-fornec.Num-seq-desp NO-UNDO.
    DEFINE OUTPUT PARAMETER pCod-despesa LIKE Desp-item-fornec.Cod-despesa NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pIt-codigo = RowObject.It-codigo
           pCod-emitente = RowObject.Cod-emitente
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
    def input  param p-it-codigo    as char no-undo.
    def input  param p-cod-emitente as int  no-undo.
    def output param p-seq-despesa  as int  no-undo.
    
    /* Busca £ltima sequencia da despesa do item-fornec para 
       sugerir a pr¢xima no cc0105c.w */
    find last  bfDesp-item-fornec
         where bfDesp-item-fornec.it-codigo = p-it-codigo
           and bfDesp-item-fornec.cod-emitente = p-cod-emitente no-lock no-error.
    if  not avail bfDesp-item-fornec then
        assign p-seq-despesa = 1.
    else
        assign p-seq-despesa = bfDesp-item-fornec.num-seq-desp + 1.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice desp-item
  Parameters:  
               recebe valor do campo It-codigo
               recebe valor do campo Cod-emitente
               recebe valor do campo Num-seq-desp
               recebe valor do campo Cod-despesa
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pIt-codigo LIKE Desp-item-fornec.It-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pCod-emitente LIKE Desp-item-fornec.Cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pNum-seq-desp LIKE Desp-item-fornec.Num-seq-desp NO-UNDO.
    DEFINE INPUT PARAMETER pCod-despesa LIKE Desp-item-fornec.Cod-despesa NO-UNDO.

    FIND FIRST bfDesp-item-fornec WHERE 
        bfDesp-item-fornec.It-codigo = pIt-codigo AND 
        bfDesp-item-fornec.Cod-emitente = pCod-emitente AND 
        bfDesp-item-fornec.Num-seq-desp = pNum-seq-desp AND 
        bfDesp-item-fornec.Cod-despesa = pCod-despesa NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfDesp-item-fornec THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfDesp-item-fornec)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToItem-fornec DBOProgram 
PROCEDURE linkToItem-fornec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-handle as handle no-undo.
    
    run getKey in p-handle(output c-it-codigo,
                           output i-cod-emitente).

    return "OK":U.
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

    open query {&queryName} for each {&tableName} no-lock indexed-reposition.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfItemFornec DBOProgram 
PROCEDURE openQueryOfItemFornec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&queryName} for each {&tableName}
         where {&tableName}.it-codigo = c-it-codigo
           and {&tableName}.cod-emitente = i-cod-emitente
           no-lock indexed-reposition.
           
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados DBOProgram 
PROCEDURE pi-cria-tt-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAM i-tipo-movto AS INT NO-UNDO.

  IF  NOT AVAIL param-global THEN
      FIND FIRST param-global NO-LOCK NO-ERROR.
  IF  param-global.modulo-mp 
  AND tt-replica-msg.log-replica-msg = YES 
  AND AVAIL RowObject THEN DO:

      FIND item-fornec WHERE
           item-fornec.it-codigo    = RowObject.it-codigo AND
           item-fornec.cod-emitente = RowObject.cod-emitente NO-LOCK NO-ERROR.

      IF  NOT AVAIL item-fornec THEN
          RETURN "NOK":U.

      create tt-dados-env.
      assign tt-dados-env.num-sequencia  = i-seq 
             tt-dados-env.cod-tipo-reg   = 47
             tt-dados-env.ind-tipo-movto = 2
             tt-dados-env.identif-msg    = item-fornec.it-codigo + " , ":U +
                                           string(item-fornec.cod-emitente).
      raw-transfer item-fornec to tt-dados-env.conteudo-msg.
      assign i-seq = i-seq + 1.

      FOR EACH  bfdesp-item-fornec 
          WHERE bfdesp-item-fornec.it-codigo    = item-fornec.it-codigo
            AND bfdesp-item-fornec.cod-emitente = item-fornec.cod-emitente NO-LOCK:

          CREATE tt-dados-env.
          ASSIGN tt-dados-env.num-sequencia  = i-seq
                 tt-dados-env.cod-tipo-reg   = 297
                 tt-dados-env.ind-tipo-movto = IF ROWID(bfdesp-item-fornec) = RowObject.r-rowid 
                                                  THEN i-tipo-movto
                                               ELSE 2
                 tt-dados-env.identif-msg    = STRING(bfdesp-item-fornec.it-codigo)    + " , ":U +
                                               STRING(bfdesp-item-fornec.cod-emitente) + " , ":U +
                                               STRING(bfdesp-item-fornec.num-seq-desp) + " , ":U +
                                               STRING(bfdesp-item-fornec.cod-despesa).
          RAW-TRANSFER bfdesp-item-fornec TO tt-dados-env.conteudo-msg.
          ASSIGN i-seq = i-seq + 1.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-envia-multiplanta DBOProgram 
PROCEDURE pi-envia-multiplanta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DEF INPUT PARAM p-movimento AS INT NO-UNDO.

  IF  NOT AVAIL param-global THEN
      FIND FIRST param-global NO-LOCK NO-ERROR.
  IF  param-global.modulo-mp THEN DO:
      ASSIGN c-transacao = "MAT001".
      {cdp/cd7300.i5 "001" c-transacao}
      ASSIGN i-tipo-movto = p-movimento.
      RUN pi-cria-tt-dados (INPUT i-tipo-movto).
      {cdp/cd7300.i6 "001" c-transacao}
  END.

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
    
        if  can-find(first bfdesp-item-fornec 
                     where bfdesp-item-fornec.it-codigo    = RowObject.it-codigo
                       and bfdesp-item-fornec.cod-emitente = RowObject.cod-emitente
                       and bfdesp-item-fornec.cod-despesa  = RowObject.cod-despesa
                       and bfdesp-item-fornec.num-seq-desp = RowObject.num-seq-desp) then do:
                       
            {method/svc/errors/inserr.i
                                &ErrorNumber="27023" /* J† existe Despesa com Seq: &1 Despesa: &2 */
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="'string(RowObject.num-seq-desp)~' + 'string(RowObject.cod-despesa)'"} 
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

