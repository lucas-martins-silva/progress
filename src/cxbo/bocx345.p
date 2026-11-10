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
&GLOBAL-DEFINE DBOName BOCX345
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName proc-lote-ped-ent
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{cxbo/bocx345.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var cCodEstabel  like proc-ped-ent.cod-estabel  no-undo.
def var cNrProcExp   like proc-ped-ent.nr-proc-exp  no-undo.
def var cNomeAbrev   like proc-ped-ent.nome-abrev   no-undo.
def var cNrPedCli    like proc-ped-ent.nr-pedcli    no-undo.
def var iNrSequenca  like proc-ped-ent.nr-sequencia no-undo.
def var cItCodigo    like proc-ped-ent.it-codigo    no-undo.
def var cCodRefer    like proc-ped-ent.cod-refer    no-undo.
def var iNrEntrega   like proc-ped-ent.nr-entrega   no-undo.


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
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "nr-pedcli":U THEN ASSIGN pFieldValue = RowObject.nr-pedcli.
        WHEN "nr-proc-exp":U THEN ASSIGN pFieldValue = RowObject.nr-proc-exp.
        WHEN "nr-serlote":U THEN ASSIGN pFieldValue = RowObject.nr-serlote.
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
        WHEN "dat-valid-lote":U THEN ASSIGN pFieldValue = RowObject.dat-valid-lote.
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
        WHEN "qtd-lote":U THEN ASSIGN pFieldValue = RowObject.qtd-lote.
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
        WHEN "nr-entrega":U THEN ASSIGN pFieldValue = RowObject.nr-entrega.
        WHEN "nr-sequencia":U THEN ASSIGN pFieldValue = RowObject.nr-sequencia.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice prcsltpd-id
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo nr-proc-exp
               retorna valor do campo nome-abrev
               retorna valor do campo nr-pedcli
               retorna valor do campo nr-sequencia
               retorna valor do campo it-codigo
               retorna valor do campo cod-refer
               retorna valor do campo nr-entrega
               retorna valor do campo nr-serlote
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE proc-lote-ped-ent.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-proc-exp LIKE proc-lote-ped-ent.nr-proc-exp NO-UNDO.
    DEFINE OUTPUT PARAMETER pnome-abrev LIKE proc-lote-ped-ent.nome-abrev NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-pedcli LIKE proc-lote-ped-ent.nr-pedcli NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-sequencia LIKE proc-lote-ped-ent.nr-sequencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE proc-lote-ped-ent.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-refer LIKE proc-lote-ped-ent.cod-refer NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-entrega LIKE proc-lote-ped-ent.nr-entrega NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-serlote LIKE proc-lote-ped-ent.nr-serlote NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pnr-proc-exp = RowObject.nr-proc-exp
           pnome-abrev = RowObject.nome-abrev
           pnr-pedcli = RowObject.nr-pedcli
           pnr-sequencia = RowObject.nr-sequencia
           pit-codigo = RowObject.it-codigo
           pcod-refer = RowObject.cod-refer
           pnr-entrega = RowObject.nr-entrega
           pnr-serlote = RowObject.nr-serlote.

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
  Purpose:     Reposiciona registro com base no °ndice prcsltpd-id
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo nr-proc-exp
               recebe valor do campo nome-abrev
               recebe valor do campo nr-pedcli
               recebe valor do campo nr-sequencia
               recebe valor do campo it-codigo
               recebe valor do campo cod-refer
               recebe valor do campo nr-entrega
               recebe valor do campo nr-serlote
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE proc-lote-ped-ent.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-exp LIKE proc-lote-ped-ent.nr-proc-exp NO-UNDO.
    DEFINE INPUT PARAMETER pnome-abrev LIKE proc-lote-ped-ent.nome-abrev NO-UNDO.
    DEFINE INPUT PARAMETER pnr-pedcli LIKE proc-lote-ped-ent.nr-pedcli NO-UNDO.
    DEFINE INPUT PARAMETER pnr-sequencia LIKE proc-lote-ped-ent.nr-sequencia NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE proc-lote-ped-ent.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer LIKE proc-lote-ped-ent.cod-refer NO-UNDO.
    DEFINE INPUT PARAMETER pnr-entrega LIKE proc-lote-ped-ent.nr-entrega NO-UNDO.
    DEFINE INPUT PARAMETER pnr-serlote LIKE proc-lote-ped-ent.nr-serlote NO-UNDO.

    FIND FIRST bfproc-lote-ped-ent WHERE 
        bfproc-lote-ped-ent.cod-estabel = pcod-estabel AND 
        bfproc-lote-ped-ent.nr-proc-exp = pnr-proc-exp AND 
        bfproc-lote-ped-ent.nome-abrev = pnome-abrev AND 
        bfproc-lote-ped-ent.nr-pedcli = pnr-pedcli AND 
        bfproc-lote-ped-ent.nr-sequencia = pnr-sequencia AND 
        bfproc-lote-ped-ent.it-codigo = pit-codigo AND 
        bfproc-lote-ped-ent.cod-refer = pcod-refer AND 
        bfproc-lote-ped-ent.nr-entrega = pnr-entrega AND 
        bfproc-lote-ped-ent.nr-serlote = pnr-serlote NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfproc-lote-ped-ent THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfproc-lote-ped-ent)).
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
    open query qr{&tableName} FOR EACH {&tableName} 
        NO-LOCK INDEXED-REPOSITION.                                         

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPedEnt DBOProgram 
PROCEDURE openQueryPedEnt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     open query qr{&tableName} 
         FOR EACH  {&tableName} 
             WHERE {&tableName}.cod-estabel  = cCodEstabel 
             AND   {&tableName}.nr-proc-exp  = cNrProcExp
             and   {&tableName}.nome-abrev   = cNomeAbrev
             and   {&tableName}.nr-pedcli    = cNrPedCli
             and   {&tableName}.nr-sequencia = iNrSequenca
             and   {&tableName}.it-codigo    = cItCodigo
             and   {&tableName}.cod-refer    = cCodRefer
             and   {&tableName}.nr-entrega   = iNrEntrega
        NO-LOCK INDEXED-REPOSITION.                                         

     RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPedEnt DBOProgram 
PROCEDURE setConstraintPedEnt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pcCodEstabel like proc-ped-ent.cod-estabel  no-undo.
    def input param pcNrProcExp  like proc-ped-ent.nr-proc-exp  no-undo.
    def input param pcNomeAbrev  like proc-ped-ent.nome-abrev   no-undo.
    def input param pcNrPedCli   like proc-ped-ent.nr-pedcli    no-undo.
    def input param piNrSequenca like proc-ped-ent.nr-sequencia no-undo.
    def input param pcItCodigo   like proc-ped-ent.it-codigo    no-undo.
    def input param pcCodRefer   like proc-ped-ent.cod-refer    no-undo.
    def input param piNrEntrega  like proc-ped-ent.nr-entrega   no-undo.

    assign cCodEstabel = pcCodEstabel
           cNrProcExp  = pcNrProcExp  
           cNomeAbrev  = pcNomeAbrev  
           cNrPedCli   = pcNrPedCli   
           iNrSequenca = piNrSequenca 
           cItCodigo   = pcItCodigo   
           cCodRefer   = pcCodRefer   
           iNrEntrega  = piNrEntrega .

    return "Ok":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidateLoteProcPedEnt DBOProgram 
PROCEDURE ValidateLoteProcPedEnt :
/*:T------------------------------------------------------------------------------
  Purpose:    
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    def input param pc-cod-estabel like proc-ped-ent.cod-estabel no-undo.
    def input param pc-nr-proc-exp like proc-ped-ent.nr-proc-exp no-undo.

    def var de-tot-qt like proc-ped-ent.quantidade[1] no-undo.

    for each  proc-ped-ent no-lock
        where proc-ped-ent.cod-estabel = pc-cod-estabel
          and proc-ped-ent.nr-proc-exp = pc-nr-proc-exp:
        assign de-tot-qt = 0.
        for each bfproc-lote-ped-ent of proc-ped-ent no-lock:
            assign de-tot-qt = de-tot-qt + bfproc-lote-ped-ent.qtd-lote.
        end.
        if  de-tot-qt <> 0 then do:
            if  de-tot-qt < proc-ped-ent.quantidade[1] then do:
                {method/svc/errors/inserr.i &ErrorNumber=30331
                                            &ErrorType="EMS"
                                             &ErrorParameters="proc-ped-ent.nome-abrev              + '~~~~' + 
                                                               proc-ped-ent.nr-pedcli               + '~~~~' +
                                                               string(proc-ped-ent.nr-sequencia)    + '~~~~' +
                                                               proc-ped-ent.it-codigo               + '~~~~' +
                                                               proc-ped-ent.cod-refer               + '~~~~' +
                                                               string(proc-ped-ent.nr-entrega)"}
            end.

            if  de-tot-qt > proc-ped-ent.quantidade[1] then do:
                {method/svc/errors/inserr.i &ErrorNumber=30332
                                            &ErrorType="EMS"
                                             &ErrorParameters="proc-ped-ent.nome-abrev              + '~~~~' + 
                                                               proc-ped-ent.nr-pedcli               + '~~~~' +
                                                               string(proc-ped-ent.nr-sequencia)    + '~~~~' +
                                                               proc-ped-ent.it-codigo               + '~~~~' +
                                                               proc-ped-ent.cod-refer               + '~~~~' +
                                                               string(proc-ped-ent.nr-entrega)"}
            end.
        end.
    end.
    
    
    for each  RowErrors 
        where RowErrors.ErrorType = "internal":U:
        delete RowErrors.
    end.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
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


    case pType:
        when "create":U or when "Update":U then do:
            if  pType = "create":U then 
                if can-find(first bfproc-lote-ped-ent 
                            where bfproc-lote-ped-ent.cod-estabel  = RowObject.cod-estabel 
                              and bfproc-lote-ped-ent.nr-proc-exp  = RowObject.nr-proc-exp 
                              and bfproc-lote-ped-ent.nome-abrev   = RowObject.nome-abrev  
                              and bfproc-lote-ped-ent.nr-pedcli    = RowObject.nr-pedcli   
                              and bfproc-lote-ped-ent.nr-sequencia = RowObject.nr-sequencia
                              and bfproc-lote-ped-ent.it-codigo    = RowObject.it-codigo   
                              and bfproc-lote-ped-ent.cod-refer    = RowObject.cod-refer   
                              and bfproc-lote-ped-ent.nr-entrega   = RowObject.nr-entrega  
                              and bfproc-lote-ped-ent.nr-serlote   = RowObject.nr-serlote) then do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-lote-da-entrega-do-processo AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Lote_da_Entrega_do_Processo" *}
                    ASSIGN c-lbl-liter-lote-da-entrega-do-processo = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                            &ErrorNumber="1"
                            &ErrorType="EMS"
                            &ErrorParameters="c-lbl-liter-lote-da-entrega-do-processo"}
                end.
        
            if  RowObject.nr-serlote = "" then do:
                {method/svc/errors/inserr.i &ErrorNumber=1818
                                            &ErrorType="EMS"}
            end.

            if  RowObject.qtd-lote = 0 then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-quantidade AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Quantidade" *}
                ASSIGN c-lbl-liter-quantidade = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber=36
                                            &ErrorType="EMS"
                                             &ErrorParameters="c-lbl-liter-quantidade"}
            end.                      
        end.
    end case.
    
    for each  RowErrors 
        where RowErrors.ErrorType = "internal":U:
        delete RowErrors.
    end.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

