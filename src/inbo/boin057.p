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
{include/i-prgvrs.i BOIN057 2.00.00.013 } /*** "010013" 23/11/2023 16:19:41  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin057 MUT}
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
&GLOBAL-DEFINE DBOName BOIN057
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName cond-especif
&GLOBAL-DEFINE TableLabel Condiá∆o Espec°fica
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin057.i RowObject}
{utp/ut-glob.i}

define temp-table tt-cond NO-UNDO
    field data-pagto1   as date
    field perc-pagto1   as int
    field comentarios1  as char 
    field data-pagto2   as date
    field perc-pagto2   as int 
    field comentarios2  as char
    field data-pagto3   as date
    field perc-pagto3   as int
    field comentarios3  as char
    field data-pagto4   as date
    field perc-pagto4   as int
    field comentarios4  as char
    field data-pagto5   as date
    field perc-pagto5   as int 
    field comentarios5  as char 
    field data-pagto6   as date 
    field perc-pagto6   as int 
    field comentarios6  as char 
    field data-pagto7   as date
    field perc-pagto7   as int
    field comentarios7  as char
    field data-pagto8   as date
    field perc-pagto8   as int
    field comentarios8  as char 
    field data-pagto9   as date
    field perc-pagto9   as int
    field comentarios9  as char 
    field data-pagto10  as date
    field perc-pagto10  as int
    field comentarios10 as char 
    field data-pagto11  as date
    field perc-pagto11  as int
    field comentarios11 as char
    field data-pagto12  as date
    field perc-pagto12  as int
    field comentarios12 as char.    
 

        
/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/*----            DEFINIÄ«O VARIµVEIS        -----*/

def var iCont      as INTEGER  no-undo.
def var de-total   as DECIMAL  no-undo.
def var iTotal     as DECIMAL  no-undo.    

def var i-pedido-ini as int no-undo.
def var i-pedido-fim as int no-undo.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteCondEspecif DBOProgram 
PROCEDURE deleteCondEspecif :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pi-pedido-compr like pedido-compr.num-pedido no-undo.
    
    for each bfcond-especif 
        where bfcond-especif.num-pedido = pi-pedido-compr exclusive-lock:
        delete bfcond-especif.
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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "comentarios[1]":U THEN ASSIGN pFieldValue = RowObject.comentarios[1].
        WHEN "comentarios[2]":U THEN ASSIGN pFieldValue = RowObject.comentarios[2].
        WHEN "comentarios[3]":U THEN ASSIGN pFieldValue = RowObject.comentarios[3].
        WHEN "comentarios[4]":U THEN ASSIGN pFieldValue = RowObject.comentarios[4].
        WHEN "comentarios[5]":U THEN ASSIGN pFieldValue = RowObject.comentarios[5].
        WHEN "comentarios[6]":U THEN ASSIGN pFieldValue = RowObject.comentarios[6].
        WHEN "comentarios[7]":U THEN ASSIGN pFieldValue = RowObject.comentarios[7].
        WHEN "comentarios[8]":U THEN ASSIGN pFieldValue = RowObject.comentarios[8].
        WHEN "comentarios[9]":U THEN ASSIGN pFieldValue = RowObject.comentarios[9].
        WHEN "comentarios[10]":U THEN ASSIGN pFieldValue = RowObject.comentarios[10].
        WHEN "comentarios[11]":U THEN ASSIGN pFieldValue = RowObject.comentarios[11].
        WHEN "comentarios[12]":U THEN ASSIGN pFieldValue = RowObject.comentarios[12].
        WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
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
        WHEN "data-pagto[1]":U THEN ASSIGN pFieldValue = RowObject.data-pagto[1].
        WHEN "data-pagto[2]":U THEN ASSIGN pFieldValue = RowObject.data-pagto[2].
        WHEN "data-pagto[3]":U THEN ASSIGN pFieldValue = RowObject.data-pagto[3].
        WHEN "data-pagto[4]":U THEN ASSIGN pFieldValue = RowObject.data-pagto[4].
        WHEN "data-pagto[5]":U THEN ASSIGN pFieldValue = RowObject.data-pagto[5].
        WHEN "data-pagto[6]":U THEN ASSIGN pFieldValue = RowObject.data-pagto[6].
        WHEN "data-pagto[7]":U THEN ASSIGN pFieldValue = RowObject.data-pagto[7].
        WHEN "data-pagto[8]":U THEN ASSIGN pFieldValue = RowObject.data-pagto[8].
        WHEN "data-pagto[9]":U THEN ASSIGN pFieldValue = RowObject.data-pagto[9].
        WHEN "data-pagto[10]":U THEN ASSIGN pFieldValue = RowObject.data-pagto[10].
        WHEN "data-pagto[11]":U THEN ASSIGN pFieldValue = RowObject.data-pagto[11].
        WHEN "data-pagto[12]":U THEN ASSIGN pFieldValue = RowObject.data-pagto[12].
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
        WHEN "num-pedido":U THEN ASSIGN pFieldValue = RowObject.num-pedido.
        WHEN "perc-pagto[1]":U THEN ASSIGN pFieldValue = RowObject.perc-pagto[1].
        WHEN "perc-pagto[2]":U THEN ASSIGN pFieldValue = RowObject.perc-pagto[2].
        WHEN "perc-pagto[3]":U THEN ASSIGN pFieldValue = RowObject.perc-pagto[3].
        WHEN "perc-pagto[4]":U THEN ASSIGN pFieldValue = RowObject.perc-pagto[4].
        WHEN "perc-pagto[5]":U THEN ASSIGN pFieldValue = RowObject.perc-pagto[5].
        WHEN "perc-pagto[6]":U THEN ASSIGN pFieldValue = RowObject.perc-pagto[6].
        WHEN "perc-pagto[7]":U THEN ASSIGN pFieldValue = RowObject.perc-pagto[7].
        WHEN "perc-pagto[8]":U THEN ASSIGN pFieldValue = RowObject.perc-pagto[8].
        WHEN "perc-pagto[9]":U THEN ASSIGN pFieldValue = RowObject.perc-pagto[9].
        WHEN "perc-pagto[10]":U THEN ASSIGN pFieldValue = RowObject.perc-pagto[10].
        WHEN "perc-pagto[11]":U THEN ASSIGN pFieldValue = RowObject.perc-pagto[11].
        WHEN "perc-pagto[12]":U THEN ASSIGN pFieldValue = RowObject.perc-pagto[12].
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice pedido
  Parameters:  
               retorna valor do campo num-pedido
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnum-pedido LIKE cond-especif.num-pedido NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnum-pedido = RowObject.num-pedido.

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
  Purpose:     Reposiciona registro com base no °ndice pedido
  Parameters:  
               recebe valor do campo num-pedido
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-pedido LIKE cond-especif.num-pedido NO-UNDO.

    FIND FIRST bfcond-especif WHERE 
        bfcond-especif.num-pedido = pnum-pedido NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcond-especif THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcond-especif)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByPedidoCompr DBOProgram 
PROCEDURE openQueryByPedidoCompr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    open query {&queryName} for each {&TableName} 
         where {&TableName}.num-pedido >= i-pedido-ini
           and {&TableName}.num-pedido <= i-pedido-fim
           no-lock indexed-reposition.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH cond-especif NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnAvailCondPagto DBOProgram 
PROCEDURE returnAvailCondPagto :
/*------------------------------------------------------------------------------
  Purpose: Verifica se j† existe condicao de pagamento para o pedido de compra
           recebido como parÉmetro.
------------------------------------------------------------------------------*/
    def input  param i-pedido-compr like pedido-compr.num-pedido no-undo.
    def output param l-existe as log no-undo.
    
    for first bfcond-especif fields()
        where bfcond-especif.num-pedido = i-pedido-compr no-lock: end.
    assign l-existe = avail bfcond-especif.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPedidoCompr DBOProgram 
PROCEDURE setConstraintPedidoCompr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pi-pedido-ini like pedido-compr.num-pedido no-undo.
    def input param pi-pedido-fim like pedido-compr.num-pedido no-undo.

    assign i-pedido-ini = pi-pedido-ini
           i-pedido-fim = pi-pedido-fim.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCondicaoPagtoEspecifica DBOProgram 
PROCEDURE validateCondicaoPagtoEspecifica :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    def input  param table for rowObject.
    def output param table for rowErrors.
    def output param table for tt-cond.
    
    
    find first rowObject no-lock no-error.
    if avail rowObject then do: 
       do iCont = 1 to 12:
          assign iTotal = iTotal + RowObject.perc-pagto[iCont].  
       end.
       if iTotal > 100 then do:
          {method/svc/errors/inserr.i &ErrorNumber="1684"
                                      &ErrorType="EMS":U
                                      &ErrorSubType="ERROR":U} 
       end.
       if iTotal < 100 then do:
            {method/svc/errors/inserr.i &ErrorNumber="1688"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
       end.
       do iCont = 2 to 12:
           if RowObject.data-pagto[iCont] = ? then do:
                if RowObject.data-pagto[iCont] < RowObject.data-pagto[iCont - 1] then do:
                         /* Inicio -- Projeto Internacional */
                         DEFINE VARIABLE c-lbl-liter-data-de-pagamento AS CHARACTER NO-UNDO.
                         {utp/ut-liter.i "Data_de_Pagamento" *}
                         ASSIGN c-lbl-liter-data-de-pagamento = TRIM(RETURN-VALUE).
                         {method/svc/errors/inserr.i &ErrorNumber="1207"
                                                     &ErrorType="EMS":U
                                                     &ErrorSubType="ERROR":U
                                                     &ErrorParameters="c-lbl-liter-data-de-pagamento + string(iCont) + 
                                                                      '~~~~~' + c-lbl-liter-data-de-pagamento + string(iCont - 1)"}
                end.
           end.
       end.
       do iCont = 1 to 12:
            if (RowObject.data-pagto[iCont] <> ? and RowObject.perc-pagto[iCont] = 0) or
               (RowObject.data-pagto[iCont] = ?  and RowObject.perc-pagto[iCont] <> 0) then do:
                    {method/svc/errors/inserr.i &ErrorNumber="1669"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U}
            end.           
       end.
    end.
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    ELSE DO:
        create tt-cond.
        assign  tt-cond.data-pagto1   = RowObject.data-pagto[1]
                tt-cond.perc-pagto1   = RowObject.perc-pagto[1]
                tt-cond.comentarios1  = RowObject.comentarios[1]
                tt-cond.data-pagto2   = RowObject.data-pagto[2]
                tt-cond.perc-pagto2   = RowObject.perc-pagto[2]
                tt-cond.comentarios2  = RowObject.comentarios[2]
                tt-cond.data-pagto3   = RowObject.data-pagto[3]
                tt-cond.perc-pagto3   = RowObject.perc-pagto[3]
                tt-cond.comentarios3  = RowObject.comentarios[3]
                tt-cond.data-pagto4   = RowObject.data-pagto[4]
                tt-cond.perc-pagto4   = RowObject.perc-pagto[4]
                tt-cond.comentarios4  = RowObject.comentarios[4]
                tt-cond.data-pagto5   = RowObject.data-pagto[5]
                tt-cond.perc-pagto5   = RowObject.perc-pagto[5]
                tt-cond.comentarios5  = RowObject.comentarios[5]
                tt-cond.data-pagto6   = RowObject.data-pagto[6]
                tt-cond.perc-pagto6   = RowObject.perc-pagto[6]
                tt-cond.comentarios6  = RowObject.comentarios[6]
                tt-cond.data-pagto7   = RowObject.data-pagto[7]
                tt-cond.perc-pagto7   = RowObject.perc-pagto[7]
                tt-cond.comentarios7  = RowObject.comentarios[7]
                tt-cond.data-pagto8   = RowObject.data-pagto[8]
                tt-cond.perc-pagto8   = RowObject.perc-pagto[8]
                tt-cond.comentarios8  = RowObject.comentarios[8]
                tt-cond.data-pagto9   = RowObject.data-pagto[9]
                tt-cond.perc-pagto9   = RowObject.perc-pagto[9]
                tt-cond.comentarios9  = RowObject.comentarios[9]
                tt-cond.data-pagto10  = RowObject.data-pagto[10]
                tt-cond.perc-pagto10  = RowObject.perc-pagto[10]
                tt-cond.comentarios10 = RowObject.comentarios[10]
                tt-cond.data-pagto11  = RowObject.data-pagto[11]
                tt-cond.perc-pagto11  = RowObject.perc-pagto[11]
                tt-cond.comentarios11 = RowObject.comentarios[11]
                tt-cond.data-pagto12  = RowObject.data-pagto[12]
                tt-cond.perc-pagto12  = RowObject.perc-pagto[12]
                tt-cond.comentarios12 = RowObject.comentarios[12].    
    END.    


    RETURN "OK":U.
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
    
    find first RowObject no-lock no-error.

    IF pType = "Update":U or pType = "Create":U THEN DO:
       assign iTotal = 0.
       do iCont = 1 to 12:
          assign iTotal = iTotal + RowObject.perc-pagto[iCont].  
       end.
              
       if iTotal > 100 then do:
          {method/svc/errors/inserr.i &ErrorNumber="1684"
                                      &ErrorType="EMS":U
                                      &ErrorSubType="ERROR":U} 
       end.
       if iTotal < 100 then do:
            {method/svc/errors/inserr.i &ErrorNumber="1688"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
       end.
       do iCont = 2 to 12:
           if RowObject.data-pagto[iCont] <> ? then do:
                if RowObject.data-pagto[iCont] <
                   RowObject.data-pagto[iCont - 1] then do:
                         /* Inicio -- Projeto Internacional */
                         DEFINE VARIABLE c-lbl-liter-data-de-pagamento-2 AS CHARACTER NO-UNDO.
                         {utp/ut-liter.i "Data_de_Pagamento" *}
                         ASSIGN c-lbl-liter-data-de-pagamento-2 = TRIM(RETURN-VALUE).
                         {method/svc/errors/inserr.i &ErrorNumber="1207"
                                                     &ErrorType="EMS":U
                                                     &ErrorSubType="ERROR":U
                                                     &ErrorParameters="c-lbl-liter-data-de-pagamento-2 + string(iCont) + 
                                                                      '~~~~~' + c-lbl-liter-data-de-pagamento-2 + string(iCont - 1)"}
                end.
           end.
       end.
       if RowObject.data-pagto[1] < RowObject.data-1 then do:
             {method/svc/errors/inserr.i &ErrorNumber="1687"
                                         &ErrorType="EMS":U
                                         &ErrorSubType="ERROR":U}
       end.
        
       do iCont = 1 to 12:
            if (RowObject.data-pagto[iCont] <> ? and 
               RowObject.perc-pagto[iCont] = 0) or
               (RowObject.data-pagto[iCont] = ? and
               RowObject.perc-pagto[iCont] <> 0) then do:
                 {method/svc/errors/inserr.i &ErrorNumber="1669"
                                             &ErrorType="EMS":U
                                             &ErrorSubType="ERROR":U}
                                       
            end.           
       end.
    END.

    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-criaaltped DBOProgram 
PROCEDURE pi-criaaltped:

    DEF INPUT PARAM pi-num-pedido like pedido-compr.num-pedido no-undo.

    DEF VAR c-alt-ped     AS CHAR NO-UNDO.
    DEF VAR c-alt-ped-aux AS CHAR NO-UNDO.
    DEF VAR i-cont        AS INT  NO-UNDO.
    
    FIND FIRST RowObject WHERE RowObject.num-pedido = pi-num-pedido no-lock no-error.

    FIND FIRST cond-especif WHERE cond-especif.num-pedido = pi-num-pedido NO-LOCK NO-ERROR.

    IF AVAIL cond-especif AND AVAIL RowObject THEN DO:
        DO i-cont = 1 TO 12:
            /*Grava o numero das parcelas da condiá∆o especifica*/
            IF cond-especif.data-pagto[i-cont] <> RowObject.data-pagto[i-cont] OR
               cond-especif.perc-pagto[i-cont] <> RowObject.perc-pagto[i-cont] THEN
                ASSIGN c-alt-ped = c-alt-ped + 'Parc ' + STRING(i-cont,"99") + " ".
            
            /*Grava as alteraá‰es de datas de entrega das parcelas da condiá∆o especifica*/
            IF cond-especif.data-pagto[i-cont] <> ? AND 
               RowObject.data-pagto[i-cont]    <> ? THEN DO:
                IF cond-especif.data-pagto[i-cont] <> RowObject.data-pagto[i-cont] THEN
                    ASSIGN c-alt-ped = c-alt-ped + 'Dt:' +
                                       string(RowObject.data-pagto[i-cont],"99/99/9999") + ' - ' + 
                                       string(cond-especif.data-pagto[i-cont],"99/99/9999") + ', '.
            END.
            ELSE IF cond-especif.data-pagto[i-cont] <> ? THEN 
                 ASSIGN c-alt-ped = c-alt-ped + 'Eliminada, '.
            ELSE IF RowObject.data-pagto[i-cont] <> ? THEN 
                 ASSIGN c-alt-ped = c-alt-ped + 'Incluida ' +
                                    'Dt:' + string(RowObject.data-pagto[i-cont],"99/99/9999") + ', ' + 
                                    '%:'  + string(RowObject.perc-pagto[i-cont],">>9.99") + ', '.
            
            /*Grava as alteraá‰es dos percentuais das parcelas da condiá∆o especifica*/
            IF cond-especif.perc-pagto[i-cont] <> 0 AND 
               RowObject.perc-pagto[i-cont]    <> 0 THEN DO:
                IF cond-especif.perc-pagto[i-cont] <> RowObject.perc-pagto[i-cont] THEN
                    ASSIGN c-alt-ped = c-alt-ped + '%:' +
                                       string(RowObject.perc-pagto[i-cont],">>9.99") + ' - ' + 
                                       string(cond-especif.perc-pagto[i-cont],">>9.99") + ', '.
            END.

        END.
        /* S¢ gera alt-ped quando os campo foram alterados*/
        IF c-alt-ped <> "" THEN DO:
            for each ordem-compra where ordem-compra.num-pedido = RowObject.num-pedido NO-LOCK:
                create alt-ped.
                assign alt-ped.data         = today
                       alt-ped.hora         = string(time,"HH:MM:SS")
                       alt-ped.usuario      = c-seg-usuario
                       alt-ped.num-pedido   = RowObject.num-pedido
                       alt-ped.numero-ordem = ordem-compra.numero-ordem
                       alt-ped.cod-cond-pag = ordem-compra.cod-cond-pag 
                       alt-ped.preco        = ?
                       alt-ped.quantidade   = ?
                       alt-ped.data-entrega = ?
                       alt-ped.char-1       = "" + "|" + "" + "|" + "?" + "|" + "0"
                       c-alt-ped-aux        = 'Alterada Cond. Pagto Especifica: ' + c-alt-ped.
                IF ("{&mgadm_dbtype}" <> "PROGRESS") THEN 
                    ASSIGN alt-ped.observacao = SUBSTRING(c-alt-ped-aux,1,76).
                ELSE
                    ASSIGN alt-ped.observacao   = c-alt-ped-aux.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
