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
{include/i-prgvrs.i BOIN706 2.00.00.005 } /*** "010005" 24/11/2023 13:25:27  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin706 MUT}
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
&GLOBAL-DEFINE DBOName BOIN706
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName Desp-cotacao-item
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin706.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
{utp/ut-glob.i} 
{cdp/cd0666.i} /*Definiá∆o da tt-erro*/
{cdp/cdcfgmat.i}
&if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
{cdp/cd2508.i} /*Funá∆o - EMS2-COMEX-MEXICO*/
&endif
/****************/

/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var i-numero-ordem like ordem-compra.numero-ordem no-undo.
def var i-cod-emitente like ordem-compra.cod-emitente no-undo.
def var c-it-codigo    like ordem-compra.it-codigo    no-undo.
def var i-seq-cotacao  like cotacao-item.seq-cotac    no-undo.

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
         HEIGHT             = 20.42
         WIDTH              = 40.86.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  run pi-envia-multiplanta in this-procedure (input 3).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaTotalDespesas DBOProgram 
PROCEDURE calculaTotalDespesas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param rowid-cotacao   as rowid no-undo.
    def output param de-tot-despesas as decimal no-undo.
    def var de-qtd-prim-parcela      as decimal no-undo.
    def var i-nr-parcelas            as decimal no-undo.
    def var de-qtd-rec-elimin        as decimal no-undo.
    
    find cotacao-item where
         rowid(cotacao-item) = rowid-cotacao no-lock no-error.
    
    if  not avail cotacao-item then
        return "NOK":U.

    find ordem-compra where
         ordem-compra.numero-ordem = cotacao-item.numero-ordem no-lock no-error.
    
    if  not avail ordem-compra then
        return "NOK":U.

    for each prazo-compra fields(qtd-rec-forn)
        where prazo-compra.numero-ordem = ordem-compra.numero-ordem
          and (   prazo-compra.situacao = 4 /* Eliminadas */ 
               or prazo-compra.situacao = 6 /* Recebidas */) no-lock:
          assign de-qtd-rec-elimin = de-qtd-rec-elimin + prazo-compra.qtd-rec-forn.
    end.    
        
    for each  desp-cotacao-item 
        where desp-cotacao-item.numero-ordem = cotacao-item.numero-ordem
          and desp-cotacao-item.it-codigo    = cotacao-item.it-codigo
          and desp-cotacao-item.cod-emitente = cotacao-item.cod-emitente
          and desp-cotacao-item.seq-cotac    = cotacao-item.seq-cotac no-lock:
          
        find despesa where
             despesa.cod-despesa = desp-cotacao-item.cod-despesa no-lock no-error.
             
        if  not avail despesa then
            next.
        
        if  despesa.cdn-aplic-desp = 1 /* Todas as notas */ then do:
            if  despesa.cdn-tp-calculo = 1 /* Percentual */ then 
                assign de-tot-despesas = de-tot-despesas +
                                         (  (cotacao-item.preco-unit * (ordem-compra.qt-solic - de-qtd-rec-elimin)) 
                                          * (desp-cotacao-item.val-per-desp / 100)).
                                           
            if  despesa.cdn-tp-calculo = 2 /* Valor */ then do:
                if  i-nr-parcelas = 0 then
                    for each prazo-compra fields(parcela quant-saldo)
                        where prazo-compra.numero-ordem = ordem-compra.numero-ordem
                          and (    prazo-compra.situacao <> 4 /* Eliminadas */ 
                               and prazo-compra.situacao <> 6 /* Recebidas */) no-lock:
                          if  prazo-compra.parcela = 1 then
                              assign de-qtd-prim-parcela = prazo-compra.quant-saldo.
                                
                          assign i-nr-parcelas = i-nr-parcelas + 1.
                    end.    
                    
                assign de-tot-despesas = de-tot-despesas +
                                         (desp-cotacao-item.val-despesa * i-nr-parcelas).
                                           
            end.
        end.                                
        else if despesa.cdn-aplic-desp = 2 /* Primeira nota */ then do:
        
             if despesa.cdn-tp-calculo = 1 /* Percentual */ then do:
                  if  de-qtd-prim-parcela = 0 then
                      for first prazo-compra fields(quant-saldo)
                          where prazo-compra.numero-ordem = ordem-compra.numero-ordem
                            and prazo-compra.parcela = 1
                            and (    prazo-compra.situacao <> 4 /* Eliminada */
                                 and prazo-compra.situacao <> 6 /* Recebida */ ) no-lock: end.

                      if  avail prazo-compra then
                          assign de-qtd-prim-parcela = prazo-compra.quant-saldo.

                  assign de-tot-despesas = de-tot-despesas + 
                                      (  (cotacao-item.preco-unit * de-qtd-prim-parcela)
                                       * (desp-cotacao-item.val-per-desp / 100)).
                   
             end.
             
             if  despesa.cdn-tp-calculo = 2 /* Valor */ then do:
                 /*--- Somente considera o valor da primeira parcela se ela
                       n∆o estiver recebida nem eliminada ---*/
                 if not can-find(first prazo-compra
                                 where prazo-compra.numero-ordem = ordem-compra.numero-ordem
                                   and prazo-compra.parcela  = 1
                                   and (   prazo-compra.situacao = 4 /* Eliminada */
                                        or prazo-compra.situacao = 6 /* Recebida */)) then
                     assign de-tot-despesas = de-tot-despesas + desp-cotacao-item.val-despesa.
             end.
        end.  
    end.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaTotalDespesasParcela DBOProgram 
PROCEDURE calculaTotalDespesasParcela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param rowid-parcela as rowid no-undo.
    def output param de-tot-despesas like desp-cotacao-item.val-despesa no-undo.
        
    find prazo-compra where 
         rowid(prazo-compra) = rowid-parcela no-lock no-error.
    if  not avail prazo-compra then
        return "NOK":U.
        
    FOR FIRST cotacao-item FIELDS(it-codigo cod-emitente seq-cotac preco-unit numero-ordem) 
         where cotacao-item.numero-ordem = prazo-compra.numero-ordem
           and cotacao-item.cot-aprovada NO-LOCK: END.
    if  not avail cotacao-item then      
        return "NOK":U.
    
    for each  desp-cotacao-item 
        where desp-cotacao-item.numero-ordem = cotacao-item.numero-ordem
          and desp-cotacao-item.it-codigo    = cotacao-item.it-codigo
          and desp-cotacao-item.cod-emitente = cotacao-item.cod-emitente
          and desp-cotacao-item.seq-cotac    = cotacao-item.seq-cotac no-lock:
          
        find despesa where
             despesa.cod-despesa = desp-cotacao-item.cod-despesa no-lock no-error.
             
        if  not avail despesa then
            next.
        
        if  despesa.cdn-aplic-desp = 1 /* Todas as notas */ then do:
            if  despesa.cdn-tp-calculo = 1 /* Percentual */ then 
                assign de-tot-despesas = de-tot-despesas +
                                         (  (cotacao-item.preco-unit * prazo-compra.quant-saldo) 
                                          * (desp-cotacao-item.val-per-desp / 100)).
            
            if  despesa.cdn-tp-calculo = 2 /* Valor */ then                                
                assign de-tot-despesas = de-tot-despesas + desp-cotacao-item.val-despesa.
        end.
        else if despesa.cdn-aplic-desp = 2 /* Primeira nota */ then do:
             if prazo-compra.parcela = 1 then do:
             
                if despesa.cdn-tp-calculo = 1 /* Percentual */ then
                   assign de-tot-despesas = de-tot-despesas + 
                                         ((cotacao-item.preco-unit * prazo-compra.quant-saldo)
                                        * (desp-cotacao-item.val-per-desp / 100)).
                                        
                if  despesa.cdn-tp-calculo = 2 /* Valor */ then
                    assign de-tot-despesas = de-tot-despesas + desp-cotacao-item.val-despesa.
             END.
        end.  
    end.
            
    return "OK":U.
    
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
        WHEN "Dsl-Narrativa":U THEN ASSIGN pFieldValue = RowObject.Dsl-Narrativa.
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
        WHEN "Numero-ordem":U THEN ASSIGN pFieldValue = RowObject.Numero-ordem.
        WHEN "Seq-cotac":U THEN ASSIGN pFieldValue = RowObject.Seq-cotac.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice Desp-cotac
  Parameters:  
               retorna valor do campo Numero-ordem
               retorna valor do campo Cod-emitente
               retorna valor do campo It-codigo
               retorna valor do campo Seq-cotac
               retorna valor do campo Num-seq-desp
               retorna valor do campo Cod-despesa
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pNumero-ordem LIKE Desp-cotacao-item.Numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pCod-emitente LIKE Desp-cotacao-item.Cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pIt-codigo LIKE Desp-cotacao-item.It-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pSeq-cotac LIKE Desp-cotacao-item.Seq-cotac NO-UNDO.
    DEFINE OUTPUT PARAMETER pNum-seq-desp LIKE Desp-cotacao-item.Num-seq-desp NO-UNDO.
    DEFINE OUTPUT PARAMETER pCod-despesa LIKE Desp-cotacao-item.Cod-despesa NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pNumero-ordem = RowObject.Numero-ordem
           pCod-emitente = RowObject.Cod-emitente
           pIt-codigo = RowObject.It-codigo
           pSeq-cotac = RowObject.Seq-cotac
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
  Notes: Retorna a sequencia da proxima despesa da cotacao
------------------------------------------------------------------------------*/

    def input param p-numero-ordem like cotacao-item.numero-ordem no-undo.
    def input param p-cod-emitente like cotacao-item.cod-emitente no-undo.
    def input param p-it-codigo    like cotacao-item.it-codigo    no-undo.
    def input param p-seq-cotac    like cotacao-item.seq-cotac    no-undo.
    def output param p-seq-desp    like desp-cotacao-item.num-seq-desp no-undo.
    
    find last desp-cotacao-item 
         where desp-cotacao-item.numero-ordem = p-numero-ordem
           and desp-cotacao-item.cod-emitente = p-cod-emitente
           and desp-cotacao-item.it-codigo    = p-it-codigo
           and desp-cotacao-item.seq-cotac    = p-seq-cotac no-lock no-error.
    if  avail desp-cotacao-item then
        assign p-seq-desp = desp-cotacao-item.num-seq-desp + 1.
    else
        assign p-seq-desp = 1.
        
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice Desp-cotac
  Parameters:  
               recebe valor do campo Numero-ordem
               recebe valor do campo Cod-emitente
               recebe valor do campo It-codigo
               recebe valor do campo Seq-cotac
               recebe valor do campo Num-seq-desp
               recebe valor do campo Cod-despesa
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pNumero-ordem LIKE Desp-cotacao-item.Numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER pCod-emitente LIKE Desp-cotacao-item.Cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pIt-codigo LIKE Desp-cotacao-item.It-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pSeq-cotac LIKE Desp-cotacao-item.Seq-cotac NO-UNDO.
    DEFINE INPUT PARAMETER pNum-seq-desp LIKE Desp-cotacao-item.Num-seq-desp NO-UNDO.
    DEFINE INPUT PARAMETER pCod-despesa LIKE Desp-cotacao-item.Cod-despesa NO-UNDO.

    FIND FIRST bfDesp-cotacao-item WHERE 
        bfDesp-cotacao-item.Numero-ordem = pNumero-ordem AND 
        bfDesp-cotacao-item.Cod-emitente = pCod-emitente AND 
        bfDesp-cotacao-item.It-codigo = pIt-codigo AND 
        bfDesp-cotacao-item.Seq-cotac = pSeq-cotac AND 
        bfDesp-cotacao-item.Num-seq-desp = pNum-seq-desp AND 
        bfDesp-cotacao-item.Cod-despesa = pCod-despesa NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfDesp-cotacao-item THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfDesp-cotacao-item)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToCotacao DBOProgram 
PROCEDURE linkToCotacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-handle as handle no-undo.
    
    run getKey in p-handle(output i-numero-ordem,
                           output i-cod-emitente,
                           output c-it-codigo,
                           output i-seq-cotacao).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfCotacaoItem DBOProgram 
PROCEDURE openQueryOfCotacaoItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     
    open query {&queryName} for each  {&tableName}
                                where {&tableName}.numero-ordem = i-numero-ordem
                                  and {&tableName}.cod-emitente = i-cod-emitente
                                  and {&tablename}.it-codigo    = c-it-codigo
                                  and {&tableName}.seq-cotac    = i-seq-cotacao
                                  no-lock indexed-reposition.

    return "OK":U.
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

  FOR FIRST ordem-compra FIELDS(num-pedido)
      WHERE ordem-compra.numero-ordem = RowObject.numero-ordem NO-LOCK,
      FIRST pedido-compr FIELDS()
      WHERE pedido-compr.num-pedido = ordem-compra.num-pedido
        AND pedido-compr.situacao   = 1 /* Impresso */ NO-LOCK: END.
         
  IF  AVAIL pedido-compr THEN
      run ccp/ccapi200.p(input "despesa-cotacao":U, 
                         input rowObject.r-rowid,
                         input p-movimento,
                         input-output table tt-erro).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recalculaDespesa DBOProgram 
PROCEDURE recalculaDespesa :
/*------------------------------------------------------------------------------
  Parameters: rw-cotacao-item - rowid da cotacao
              rw-desp-cotacao - rowid da desp-cotacao-item
  Notes: Calcula o valor da despesa com base nos parÉmetros da despesa.
         Este mÇtodo Ç utilizado por consultas e relat¢rios e serve para 
         que se possa consultar o valor de cada despesa.      
------------------------------------------------------------------------------*/
    def input param rw-cotacao-item as rowid no-undo.
    def input param rw-desp-cotacao as rowid no-undo.
    def output param de-valor-desp  like desp-cotacao-item.val-despesa no-undo.
    def var i-nr-parcelas  as int no-undo.
    def var de-qtd-rec-elimin as int no-undo.
    
    find desp-cotacao-item where
         rowid(desp-cotacao-item) = rw-desp-cotacao exclusive-lock no-error.
    if  not avail desp-cotacao-item then
        return "NOK":U.
   
    for first cotacao-item fields(preco-unit numero-ordem)
        where rowid(cotacao-item) = rw-cotacao-item no-lock: end.
    if  not avail cotacao-item then 
        return "NOK".
       
    for first ordem-compra fields(qt-solic numero-ordem)
        where ordem-compra.numero-ordem = cotacao-item.numero-ordem no-lock: end.
    if  not avail ordem-compra then do:
        /*--- Se nao achar OC retorna o valor informado na propria desp-cotacao-item,
              pois pode tratar-se de cotacao desvinculada ---*/
        assign de-valor-desp = desp-cotacao-item.val-despesa.
        return "NOK":U.
    end.
    
    find despesa where
         despesa.cod-despesa = desp-cotacao-item.cod-despesa no-lock no-error.
    
    if  avail despesa then do:
        if  despesa.cdn-tp-calculo = 1 /* Percentual */ then do:
             if  despesa.cdn-aplic-desp = 2 /* Primeira nota */ then do:
                for first prazo-compra fields(quant-saldo)
                    where prazo-compra.numero-ordem = ordem-compra.numero-ordem
                      and prazo-compra.parcela = 1
                      and (    prazo-compra.situacao <> 4 /* Eliminada */
                           and prazo-compra.situacao <> 6 /* Recebida */ ) no-lock:
                    
                    assign desp-cotacao-item.val-despesa = (  (cotacao-item.preco-unit * prazo-compra.quant-saldo) 
                                                            * (desp-cotacao-item.val-per-desp / 100))
                           de-valor-desp = desp-cotacao-item.val-despesa.
                           
                end.
            end.
            else if despesa.cdn-aplic-desp = 1 /* Todas as notas */ 
            then do:
            
                for each prazo-compra fields(qtd-rec-forn)
                    where prazo-compra.numero-ordem = ordem-compra.numero-ordem
                      and (   prazo-compra.situacao = 4 /* Eliminadas */ 
                           or prazo-compra.situacao = 6 /* Recebidas */) no-lock:
                      assign de-qtd-rec-elimin = de-qtd-rec-elimin + prazo-compra.qtd-rec-forn.
                end.              
            
                assign desp-cotacao-item.val-despesa = (  (cotacao-item.preco-unit * (ordem-compra.qt-solic - de-qtd-rec-elimin)) 
                                                        * (desp-cotacao-item.val-per-desp / 100))
                       de-valor-desp = desp-cotacao-item.val-despesa.        
            end.
        end.
        else if  despesa.cdn-tp-calculo = 2 /* Valor */ then do:
             if  despesa.cdn-aplic-desp = 2 /* Primeira nota */ then do:
                 /*--- Somente considera o valor da primeira parcela se ela
                       n∆o estiver recebida nem eliminada ---*/
                 if  not can-find(first prazo-compra
                                 where prazo-compra.numero-ordem = ordem-compra.numero-ordem
                                   and prazo-compra.parcela  = 1
                                   and (   prazo-compra.situacao = 4 /* Eliminada */
                                        or prazo-compra.situacao = 6 /* Recebida */)) then             
                     assign de-valor-desp = desp-cotacao-item.val-despesa.
                 else
                     assign de-valor-desp = 0.
                 
             end.
             else if  despesa.cdn-aplic-desp = 1 /* Todas as notas */ 
             then do:
                 for each prazo-compra fields()
                    where prazo-compra.numero-ordem = desp-cotacao-item.numero-ordem
                      and (    prazo-compra.situacao <> 4 /* Eliminadas */ 
                           and prazo-compra.situacao <> 6 /* Recebidas */) no-lock:
                      assign i-nr-parcelas = i-nr-parcelas + 1.
                 end.  
    
                 if  i-nr-parcelas <> 0 then
                     assign de-valor-desp = desp-cotacao-item.val-despesa * i-nr-parcelas.

             end.
        end.
    end.
    
    /* Comando necess†rio para que n∆o ocorra
       dead-lock na tabela desp-cotacao-item */
    release desp-cotacao-item.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recalculaDespesasAlteracaoCotacao DBOProgram 
PROCEDURE recalculaDespesasAlteracaoCotacao :
/*------------------------------------------------------------------------------
  Notes: Recalcula o valor das despesas qdo for alterado o preáo ou quantidade
------------------------------------------------------------------------------*/
    def input param rowid-cotacao as rowid no-undo.
    def var de-valor-desp as dec no-undo.
    
    /* Recalcula o valor de cada despesa da cotaá∆o quando for alterado
       o preáo unit†rio da mesma */
    for first cotacao-item fields(preco-unit numero-ordem preco-unit) where
        rowid(cotacao-item) = rowid-cotacao no-lock: end.
    
    if  avail cotacao-item then do:
        for each  desp-cotacao-item
            where desp-cotacao-item.numero-ordem  = cotacao-item.numero-ordem
              and desp-cotacao-item.cod-emitente  = cotacao-item.cod-emitente
              and desp-cotacao-item.it-codigo     = cotacao-item.it-codigo
              and desp-cotacao-item.seq-cotac     = cotacao-item.seq-cotac no-lock:
            
            run recalculaDespesa (input rowid(cotacao-item),
                                  input rowid(desp-cotacao-item),
                                  output de-valor-desp).
                  
        end.
    end.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recalcValorDesp DBOProgram 
PROCEDURE recalcValorDesp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param rowid-cotacao as rowid no-undo.
    def input param rowid-desp    as rowid no-undo.
    def var de-total-desp like desp-cotacao-item.val-despesa no-undo.
    
    /* C†lculo est† sendo desviado para outra procedure para
       que o c¢digo n∆o fique duplicado */
    run recalculaDespesa (rowid-cotacao, rowid-desp, output de-total-desp).
    
    /*************
    for first cotacao-item fields(preco-unit numero-ordem)
        where rowid(cotacao-item) = rowid-cotacao no-lock,
        first ordem-compra fields(qt-solic) 
        where ordem-compra.numero-ordem = cotacao-item.numero-ordem no-lock: end.
    if  not avail cotacao-item then
        return "NOK":U.
    
    for first desp-cotacao-item 
        where rowid(desp-cotacao-item) = rowid-desp exclusive-lock,
        first despesa 
        where despesa.cod-despesa = desp-cotacao-item.cod-despesa no-lock: end.
    if  not avail desp-cotacao-item then
        return "NOK":U.
    
    if  despesa.cdn-tp-calc = 1 /* Percentual */ then
        assign desp-cotacao-item.val-despesa = (cotacao-item.preco-uni * ordem-compra.qt-solic) *
                                               (desp-cotacao-item.val-per-desp / 100).
    ****************/
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnDisplayValorDespesa DBOProgram 
PROCEDURE returnDisplayValorDespesa :
/*------------------------------------------------------------------------------
  Notes: Retorna o valor que deve ser mostrado em consultas e relat¢rios quando
         o tipo da despesa Ç valor e se aplica a todas as notas.
------------------------------------------------------------------------------*/

    def input param row-desp-cotacao-item as rowid no-undo.
    def output param de-valor-display like desp-cotacao-item.val-despesa no-undo.
    
    def var i-nr-parcelas as int no-undo.
    
    find desp-cotacao-item where
         rowid(desp-cotacao-item) = row-desp-cotacao-item no-lock no-error.
    if  not avail desp-cotacao-item then
        return "NOK":U.
        
    find despesa 
         where despesa.cod-despesa = desp-cotacao-item.cod-despesa
           and despesa.cdn-aplic-desp = 1 /* Todas as notas */
           and despesa.cdn-tp-calculo = 2 /* Valor */ no-lock no-error.
    if  not avail despesa then
        return "NOK":U.
    
    for each prazo-compra fields()
        where prazo-compra.numero-ordem = desp-cotacao-item.numero-ordem
          and (    prazo-compra.situacao <> 4 /* Eliminadas */ 
               and prazo-compra.situacao <> 6 /* Recebidas */) no-lock:
          assign i-nr-parcelas = i-nr-parcelas + 1.
    end.  
    
    if  i-nr-parcelas <> 0 then
        assign de-valor-display = desp-cotacao-item.val-despesa * i-nr-parcelas.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnExisteDesp DBOProgram 
PROCEDURE returnExisteDesp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Verifica se existe alguma despesa para a cotacao.       
------------------------------------------------------------------------------*/

    def input  param rowid-cotacao as rowid no-undo.
    def output param l-existe      as log   no-undo.
    
    for first cotacao-item fields(numero-ordem cod-emitente
                                  it-codigo seq-cotac)
        where rowid(cotacao-item) = rowid-cotacao no-lock,
        first desp-cotacao-item fields()
        where desp-cotacao-item.numero-ordem = cotacao-item.numero-ordem
          and desp-cotacao-item.cod-emitente = cotacao-item.cod-emitente
          and desp-cotacao-item.it-codigo    = cotacao-item.it-codigo
          and desp-cotacao-item.seq-cotac    = cotacao-item.seq-cotac no-lock: end.
          
    assign l-existe = avail desp-cotacao-item.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnTotalCotacao DBOProgram 
PROCEDURE returnTotalCotacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param rowid-cotacao  as rowid   no-undo.
    def output param de-tot-cotacao as decimal no-undo.
    
    for first cotacao-item fields(numero-ordem preco-unit)
        where rowid(cotacao-item) = rowid-cotacao no-lock,
        first ordem-compra fields(qt-solic)
        where ordem-compra.numero-ordem = cotacao-item.numero-ordem no-lock: end.

    if  not avail cotacao-item then
        return "NOK":U.
    
    assign de-tot-cotacao = cotacao-item.preco-unit * ordem-compra.qt-solic.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnTotalParcela DBOProgram 
PROCEDURE returnTotalParcela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param rowid-cotacao as rowid no-undo.
    def output param i-tot-parc    as int   no-undo.
    
    for first cotacao-item fields(numero-ordem)
        where rowid(cotacao-item) = rowid-cotacao no-lock,
        each prazo-compra fields()
        where prazo-compra.numero-ordem = cotacao-item.numero-ordem no-lock:
          assign i-tot-parc = i-tot-parc + 1.
    end.
        
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sugereDespesas DBOProgram 
PROCEDURE sugereDespesas :
/*------------------------------------------------------------------------------
  Parameters: rowid-cotacao - rowid da tabela cotacao-item
  Notes:      Esta procedure somente deve ser executada se n∆o existir nenhuma
              despesa cadastrada para a cotaá∆o, caso contr†rio as mesmas ser∆o
              eliminadas e substitu°das
------------------------------------------------------------------------------*/
    def input param rowid-cotacao as rowid no-undo.
    
    def var de-valor-display like desp-cotacao-item.val-despesa no-undo.

    IF  NOT AVAIL param-compra THEN
        FIND FIRST param-compra NO-LOCK NO-ERROR.

    IF  NOT AVAIL param-compra
    OR  NOT param-compra.log-despesa THEN
        NEXT.

    find cotacao-item where
         rowid(cotacao-item) = rowid-cotacao no-lock no-error.
    
    if  not avail cotacao-item then
        return "NOK":U.

    find ordem-compra where 
         ordem-compra.numero-ordem = cotacao-item.numero-ordem no-lock no-error.

    if  not avail ordem-compra then
        return "NOK":U.

    session:set-wait-state("general":U).
    
    /*--- Elimina todas as despesas da cotaá∆o antes de sugerir ---*/ 
    for each  desp-cotacao-item
        where desp-cotacao-item.numero-ordem  = cotacao-item.numero-ordem
          and desp-cotacao-item.cod-emitente  = cotacao-item.cod-emitente
          and desp-cotacao-item.it-codigo     = cotacao-item.it-codigo
          and desp-cotacao-item.seq-cotac     = cotacao-item.seq-cotac exclusive-lock:
          delete desp-cotacao-item no-error.
    end.

    /*********************************************************************
    ** Para criaá∆o da desp-cotacao-item deve-se observar o seguinte:
    ** 1. Quando  houver relacionamento  item-fornec-estab para item 
    **    e emitente da cotaá∆o e estabelecimento da OC, deve-se dar
    **    prioridade para este n°vel.
    ** 2. Caso n∆o haja despesas a n°vel de item-fornec-estab, deve-se
    **    buscar as despesas no relacionamento item-fornec.
    ** 3. Dever† verificar se o item-fornec est† ativo.
    *********************************************************************/
    /* Verifica a existància do relacionamento item-fornec-estab. */     
    if  can-find(first item-fornec-estab
                 where item-fornec-estab.it-codigo    = cotacao-item.it-codigo
                   and item-fornec-estab.cod-emitente = cotacao-item.cod-emitente
                   and item-fornec-estab.cod-estabel  = ordem-compra.cod-estabel
                   and item-fornec-estab.ativo)
    and can-find(first desp-item-fornec-estab
                 where desp-item-fornec-estab.it-codigo   = cotacao-item.it-codigo
                   and desp-item-fornec-estab.Cod-emite   = cotacao-item.cod-emitente 
                   and desp-item-fornec-estab.cod-estabel = ordem-compra.cod-estabel) then do:
         
        /* Caso exista o relacionamento item-fornec-estab e esteja ativo e
           tenha alguma despesa cadastrada para o relacionamento, copia as 
           despesas para a cotacao */
        for each  desp-item-fornec-estab
            where desp-item-fornec-estab.it-codigo   = cotacao-item.it-codigo
              and desp-item-fornec-estab.cod-emite   = cotacao-item.cod-emitente 
              and desp-item-fornec-estab.cod-estabel = ordem-compra.cod-estabel no-lock:
              
            find despesa where
                 despesa.cod-despesa = desp-item-fornec-estab.cod-despesa no-lock no-error.
            if  not avail despesa then
                next.
            
            /* Cria registro na base */
            create desp-cotacao-item.
            assign desp-cotacao-item.numero-ordem  = cotacao-item.numero-ordem
                   desp-cotacao-item.cod-emitente  = cotacao-item.cod-emitente
                   desp-cotacao-item.it-codigo     = cotacao-item.it-codigo
                   desp-cotacao-item.seq-cotac     = cotacao-item.seq-cotac
                   desp-cotacao-item.num-seq-desp  = desp-item-fornec-estab.num-seq-desp
                   desp-cotacao-item.cod-despesa   = desp-item-fornec-estab.cod-despesa
                   desp-cotacao-item.val-despesa   = desp-item-fornec-estab.val-despesa
                   desp-cotacao-item.val-per-desp  = desp-item-fornec-estab.val-per-desp.        
            
            /* Recalcula o valor da despesa pelo valor da cotacao */           
            run recalculaDespesa (input rowid(cotacao-item),
                                  input rowid(desp-cotacao-item),
                                  output de-valor-display).
        end.       
    end.
    /* Verifica a existància do relacionamento item-fornec. */
    else if  can-find(first item-fornec
                      where item-fornec.it-codigo    = cotacao-item.it-codigo
                        and item-fornec.cod-emitente = cotacao-item.cod-emitente
                        and item-fornec.ativo)
         and can-find(first desp-item-fornec
                      where desp-item-fornec.it-codigo    = cotacao-item.it-codigo
                        and desp-item-fornec.cod-emitente = cotacao-item.cod-emitente) then do:

        /* Caso exista o relacionamento item-fornec e esteja ativo e
           tenha alguma despesa cadastrada para o relacionamento, 
           copia as despesas para a cotacao */
         
        for each  desp-item-fornec
            where desp-item-fornec.it-codigo    = cotacao-item.it-codigo
              and desp-item-fornec.cod-emitente = cotacao-item.cod-emitente no-lock:
              
            find despesa where
                 despesa.cod-despesa = desp-item-fornec.cod-despesa no-lock no-error.
            if  not avail despesa then
                next.

            /* Cria registro na base */
            create desp-cotacao-item.
            assign desp-cotacao-item.numero-ordem  = cotacao-item.numero-ordem
                   desp-cotacao-item.cod-emitente  = cotacao-item.cod-emitente
                   desp-cotacao-item.it-codigo     = cotacao-item.it-codigo
                   desp-cotacao-item.seq-cotac     = cotacao-item.seq-cotac
                   desp-cotacao-item.num-seq-desp  = desp-item-fornec.num-seq-desp
                   desp-cotacao-item.cod-despesa   = desp-item-fornec.cod-despesa
                   desp-cotacao-item.val-despesa   = desp-item-fornec.val-despesa
                   desp-cotacao-item.val-per-desp  = desp-item-fornec.val-per-desp.            
                   
            /* Recalcula o valor da despesa pelo valor da cotacao */           
            run recalculaDespesa (input rowid(cotacao-item),
                                  input rowid(desp-cotacao-item),
                                  output de-valor-display).                                      
        end.       
    end.
    
    session:set-wait-state("":U).

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
    

    if  not avail rowObject then
        return "NOK":U.
    
    if  pType = "create":U then do:
        /* Verifica duplicidade de registro */
        if  can-find(first desp-cotacao-item 
                     where desp-cotacao-item.numero-ordem = rowObject.numero-ordem
                       and desp-cotacao-item.it-codigo    = rowObject.it-codigo
                       and desp-cotacao-item.cod-emitente = rowObject.cod-emitente
                       and desp-cotacao-item.seq-cotac    = rowObject.seq-cotac
                       and desp-cotacao-item.cod-despesa  = rowObject.cod-despesa
                       and desp-cotacao-item.num-seq-desp = rowObject.num-seq-desp) 
            then do:
            
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgind desp-cotacao-item 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i
                                &ErrorNumber="7" /* J† existe despesa com a chave informada */
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters=TRIM(RETURN-VALUE)}
        end.        
    end.
        
    find despesa where
         despesa.cod-despesa = rowObject.cod-despesa no-lock no-error.
    if  avail despesa then do:
        if  despesa.cdn-tp-calculo = 1 /* Percentual */
        then do:
            if  rowObject.val-per-desp = 0 then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-percentual AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Percentual" *}
                ASSIGN c-lbl-liter-percentual = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                    &ErrorNumber="822" /* Percentual deve ser informado */
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-liter-percentual" }
            end.
            /* Zera o Valor qdo a despesa for percentual */
            assign rowObject.val-despesa = 0.
        end.
        else if despesa.cdn-tp-calculo = 2 /* Valor */
        then do:
            if  rowObject.val-despesa = 0 then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-valor AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Valor" *}
                ASSIGN c-lbl-liter-valor = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                    &ErrorNumber="822" /* Valor deve ser informado */
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-liter-valor" }
            end.
            /* Zera o Percentual qdo tipo da despesa for valor */
            assign rowObject.val-per-desp = 0. 
        end.
    end.
    else do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-table.i mgdis despesa 1} /* Busca o label da tabela */
        {method/svc/errors/inserr.i
                            &ErrorNumber="2" /* Despesa n∆o cadastrada */
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters=TRIM(RETURN-VALUE)}
    end.

    /*COMEX - N∆o permitir incluir despesas para fornecedor estrangeiro*/
    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
        if  pType = "create":U or pType = "update":U then do:
            if l-ems2-imp-mexico then do:
    
                find ordem-compra no-lock
                     where ordem-compra.numero-ordem = rowObject.numero-ordem no-error.
                if avail ordem-compra then do:
    
                    find pedido-compr no-lock
                         where pedido-compr.num-pedido = ordem-compra.num-pedido no-error.
                    if avail pedido-compr then do:
    
                        find emitente where 
                             emitente.cod-emitente = pedido-compr.cod-emitente no-lock no-error.
                        
                        if avail emitente and 
                                (emitente.natureza = 3 or emitente.natureza = 4) then do:            
                        
                            find estabelec where
                                 estabelec.cod-estabel = pedido-compr.cod-estabel no-lock no-error.
                        
                            if avail estabelec and estabelec.pais <> emitente.pais then do:
                                
                                /* Inicio -- Projeto Internacional */
                                DEFINE VARIABLE c-lbl-liter-pedido-de-importacao AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "Pedido_de_importaá∆o" *}
                                ASSIGN c-lbl-liter-pedido-de-importacao = TRIM(RETURN-VALUE).
                                DEFINE VARIABLE c-lbl-liter-despesas AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "despesas" *}
                                ASSIGN c-lbl-liter-despesas = TRIM(RETURN-VALUE).
                                {method/svc/errors/inserr.i
                                                    &ErrorNumber="7355" 
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="c-lbl-liter-pedido-de-importacao + '~~~~' + c-lbl-liter-despesas" }
    
                            end.
                        end.
                    end.
                end.
            end.
        end.
    &endif

    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

