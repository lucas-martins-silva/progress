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
{include/i-prgvrs.i BOCX225NA 2.00.00.005} /*** "010005" 27/11/2023 16:32:28  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX225NA MUT}
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
&GLOBAL-DEFINE DBOName BOCX225
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ordens-embarque
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*--- Include com definiá∆o da temptable RowObject ---*/
{cxbo/bocx225.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
{method/dboqry.i}

/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE i-num-ordem-ini LIKE ordens-embarque.numero-ordem NO-UNDO.
DEFINE VARIABLE i-num-ordem-fim LIKE ordens-embarque.numero-ordem NO-UNDO.

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
         HEIGHT             = 18.38
         WIDTH              = 42.57.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindOrdensEmbarque DBOProgram 
PROCEDURE FindOrdensEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM i-numero-ordem LIKE ordens-embarque.numero-ordem NO-UNDO.
    DEFINE INPUT  PARAM i-parcela      LIKE ordens-embarque.parcela      NO-UNDO.
    DEFINE OUTPUT PARAM c-return       AS CHARACTER                      NO-UNDO.
    
    RUN startMethod("find":U).

    FIND FIRST ordens-embarque 
         WHERE ordens-embarque.numero-ordem = i-numero-ordem 
           AND ordens-embarque.parcela      = i-parcela NO-LOCK NO-ERROR.
    
    IF NOT AVAIL ordens-embarque THEN DO:
        {utp/ut-table.i mgcex ordens-embarque 1}
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 2,
                           INPUT RETURN-VALUE).
    
        ASSIGN c-return = RETURN-VALUE.
    END.
    ELSE
        RUN SetCurrent.
    
    RUN EndMethod("find":U).

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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-estabel":U         THEN pFieldValue = RowObject.cod-estabel.
        WHEN "nr-proc-imp":U         THEN pFieldValue = RowObject.nr-proc-imp.
        WHEN "embarque":U            THEN pFieldValue = RowObject.embarque.
        WHEN "identific-container":U THEN pFieldValue = RowObject.identific-container.
        WHEN "caracter-container":U  THEN pFieldValue = RowObject.caracter-container.
        WHEN "char-1":U              THEN pFieldValue = RowObject.char-1.
        WHEN "char-2":U              THEN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U           THEN pFieldValue = RowObject.check-sum.
        WHEN "tipo-container"        THEN pFieldValue = RowObject.tipo-container.
        WHEN "nr-ato-concessorio"    THEN pFieldValue = RowObject.nr-ato-concessorio.
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE      NO-UNDO.

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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL   NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "quantidade":U          THEN pFieldValue = RowObject.quantidade.
        WHEN "qt-do-forn":U          THEN pFieldValue = RowObject.qt-do-forn.
        WHEN "dec-1":U               THEN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U               THEN pFieldValue = RowObject.dec-2.
        WHEN "peso-bruto":U          THEN pFieldValue = RowObject.peso-bruto.
        WHEN "peso-liquido":U        THEN pFieldValue = RowObject.peso-liquido.
        WHEN "aliquota-ipi":U        THEN pFieldValue = RowObject.aliquota-ipi.
        WHEN "aliquota-icms":U       THEN pFieldValue = RowObject.aliquota-icms.
        WHEN "aliquota-ii":U         THEN pFieldValue = RowObject.aliquota-ii.
        WHEN "val-cub-unit":U        THEN pFieldValue = RowObject.val-cub-unit.
        WHEN "val-aliq-ext-pis":U    THEN pFieldValue = RowObject.val-aliq-ext-pis.
        WHEN "val-aliq-ext-cofins":U THEN pFieldValue = RowObject.val-aliq-ext-cofins.
        WHEN "val-cub-tot":U         THEN pFieldValue = RowObject.val-cub-tot.
        WHEN "val-peso-embal":U      THEN pFieldValue = RowObject.val-peso-embal.
        WHEN "val-tax-siscomex":U    THEN pFieldValue = RowObject.val-tax-siscomex.
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER      NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "numero-ordem":U        THEN  pFieldValue = RowObject.numero-ordem.
        WHEN "parcela":U             THEN  pFieldValue = RowObject.parcela.    
        WHEN "int-1":U               THEN  pFieldValue = RowObject.int-1.
        WHEN "int-2":U               THEN  pFieldValue = RowObject.int-2.
        WHEN "cd-trib-ipi":U         THEN  pFieldValue = RowObject.cd-trib-ipi.
        WHEN "cd-trib-icms":U        THEN  pFieldValue = RowObject.cd-trib-icms.
        WHEN "cd-trib-ii":U          THEN  pFieldValue = RowObject.cd-trib-ii.
        WHEN "idi-tributac-pis":U    THEN  pFieldValue = RowObject.idi-tributac-pis.
        WHEN "idi-tributac-cofins":U THEN  pFieldValue = RowObject.idi-tributac-cofins.
        WHEN "num-adic":U            THEN  pFieldValue = RowObject.num-adic.
        OTHERWISE RETURN "NOK":U.          
    END CASE.                              
                                           
    RETURN "OK":U.                         
END PROCEDURE.                             

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice embarque
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo embarque
               retorna valor do campo numero-ordem
               retorna valor do campo parcela
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel    LIKE ordens-embarque.cod-estabel    NO-UNDO.
    DEFINE OUTPUT PARAMETER pembarque       LIKE ordens-embarque.embarque       NO-UNDO.
    DEFINE OUTPUT PARAMETER pnumero-ordem   LIKE ordens-embarque.numero-ordem   NO-UNDO.
    DEFINE OUTPUT PARAMETER pparcela        LIKE ordens-embarque.parcela        NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel  = RowObject.cod-estabel
           pembarque     = RowObject.embarque
           pnumero-ordem = RowObject.numero-ordem
           pparcela      = RowObject.parcela.

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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL      NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.
                                                
    CASE pFieldName:                            
        WHEN "log-1":U                    THEN  pFieldValue = RowObject.log-1.
        WHEN "log-2":U                    THEN  pFieldValue = RowObject.log-2.
        WHEN "log-suspens-impto-import":U THEN  pFieldValue = RowObject.log-suspens-impto-import.
        WHEN "log-suspens-ipi-import":U   THEN  pFieldValue = RowObject.log-suspens-ipi-import.
        WHEN "log-ja-gravad":U            THEN  pFieldValue = RowObject.log-ja-gravad.
        WHEN "log-aplica-desc-icms":U     THEN  pFieldValue = RowObject.log-aplica-desc-icms.
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW          NO-UNDO.

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
  Purpose:     Reposiciona registro com base no °ndice embarque
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo embarque
               recebe valor do campo numero-ordem
               recebe valor do campo parcela
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel  LIKE ordens-embarque.cod-estabel   NO-UNDO.
    DEFINE INPUT PARAMETER pembarque     LIKE ordens-embarque.embarque      NO-UNDO.
    DEFINE INPUT PARAMETER pnumero-ordem LIKE ordens-embarque.numero-ordem  NO-UNDO.
    DEFINE INPUT PARAMETER pparcela      LIKE ordens-embarque.parcela       NO-UNDO.

    FIND FIRST bfordens-embarque 
         WHERE bfordens-embarque.cod-estabel  = pcod-estabel 
           AND bfordens-embarque.embarque     = pembarque 
           AND bfordens-embarque.numero-ordem = pnumero-ordem 
           AND bfordens-embarque.parcela      = pparcela NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfordens-embarque THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfordens-embarque)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToOrdemCompra DBOProgram 
PROCEDURE goToOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base na ordem de compra
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnumero-ordem LIKE ordens-embarque.numero-ordem NO-UNDO.

    FIND FIRST bfordens-embarque 
         WHERE bfordens-embarque.numero-ordem = pnumero-ordem NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfordens-embarque THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfordens-embarque)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNumOrdem DBOProgram 
PROCEDURE openQueryByNumOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QUERYNAME} FOR EACH {&TableName} NO-LOCK
                               WHERE {&TableName}.numero-ordem >= i-num-ordem-ini 
                                 AND {&TableName}.numero-ordem <= i-num-ordem-fim.              
              
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

    OPEN QUERY {&QUERYNAME} FOR EACH {&TableName} NO-LOCK.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByNumOrdem DBOProgram 
PROCEDURE setConstraintByNumOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
                           
    DEFINE INPUT PARAM pi-num-ordem-ini LIKE ordens-embarque.numero-ordem NO-UNDO.
    DEFINE INPUT PARAM pi-num-ordem-fim LIKE ordens-embarque.numero-ordem NO-UNDO.                           
                           
    ASSIGN i-num-ordem-ini = pi-num-ordem-ini
           i-num-ordem-fim = pi-num-ordem-fim.

    RETURN "OK":U.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

