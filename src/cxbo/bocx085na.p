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
{include/i-prgvrs.i BOCX085NA 2.00.00.005 } /*** "010005" 11/12/2023 10:13:22 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX085NA MUT}
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
&GLOBAL-DEFINE DBOName BOCX085NA
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName cotacao-item-cex
&GLOBAL-DEFINE TableLabel
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{cxbo/bocx085.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

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
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 1.85
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findMapaCotacao DBOProgram 
PROCEDURE findMapaCotacao :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no mapa de cotacao
  Parameters:  
               recebe valor do campo numero-ordem
               recebe valor do campo cod-emitente
               recebe valor do campo it-codigo
               recebe valor do campo seq-cotac
               recebe valor do campo data-cotacao
               recebe valor do campo mapa-cotacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnumero-ordem LIKE cotacao-item-cex.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE cotacao-item-cex.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE cotacao-item-cex.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pseq-cotac LIKE cotacao-item-cex.seq-cotac NO-UNDO.
    DEFINE INPUT PARAMETER pdata-cotacao LIKE cotacao-item-cex.data-cotacao NO-UNDO.
    DEFINE INPUT PARAMETER pmapa-cotacao LIKE cotacao-item-cex.mapa-cotacao NO-UNDO.

    FIND FIRST bfcotacao-item-cex WHERE 
        bfcotacao-item-cex.numero-ordem = pnumero-ordem AND 
        bfcotacao-item-cex.cod-emitente = pcod-emitente AND 
        bfcotacao-item-cex.it-codigo = pit-codigo AND 
        bfcotacao-item-cex.seq-cotac = pseq-cotac AND 
        bfcotacao-item-cex.data-cotacao = pdata-cotacao AND 
        bfcotacao-item-cex.mapa-cotacao = pmapa-cotacao NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcotacao-item-cex THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcotacao-item-cex)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaMapaCotacao DBOProgram 
PROCEDURE piRetornaMapaCotacao :
/*------------------------------------------------------------------------------
  Purpose:     Retorna a informaá∆o do primeiro mapa da cotaá∆o cadastrada 
               para a cotaá∆o do item
  Parameters:  
               recebe valor do campo numero-ordem
               recebe valor do campo cod-emitente
               recebe valor do campo it-codigo
               recebe valor do campo seq-cotac
               recebe valor do campo data-cotacao
               retorna valor do campo mapa-cotacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pnumero-ordem LIKE cotacao-item-cex.numero-ordem NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-emitente LIKE cotacao-item-cex.cod-emitente NO-UNDO.
    DEFINE INPUT  PARAMETER pit-codigo    LIKE cotacao-item-cex.it-codigo NO-UNDO.
    DEFINE INPUT  PARAMETER pseq-cotac    LIKE cotacao-item-cex.seq-cotac NO-UNDO.
    DEFINE INPUT  PARAMETER pdata-cotacao LIKE cotacao-item-cex.data-cotacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pmapa-cotacao LIKE cotacao-item-cex.mapa-cotacao NO-UNDO.

    FIND FIRST bfcotacao-item-cex 
         WHERE bfcotacao-item-cex.numero-ordem = pnumero-ordem 
           AND bfcotacao-item-cex.cod-emitente = pcod-emitente 
           AND bfcotacao-item-cex.it-codigo    = pit-codigo 
           AND bfcotacao-item-cex.seq-cotac    = pseq-cotac 
           AND bfcotacao-item-cex.data-cotacao = pdata-cotacao  NO-LOCK NO-ERROR.
        
    IF AVAIL bfcotacao-item-cex THEN
       ASSIGN pmapa-cotacao = bfcotacao-item-cex.mapa-cotacao.
    ELSE DO: 
        ASSIGN pmapa-cotacao = 0.
        RETURN "NOK":U.
    END.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcotacao-item-cex)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
        WHEN "aprovador":U THEN ASSIGN pFieldValue = RowObject.aprovador.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
        WHEN "cod-incoterm":U THEN ASSIGN pFieldValue = RowObject.cod-incoterm.
        WHEN "contato":U THEN ASSIGN pFieldValue = RowObject.contato.
        WHEN "hora-atualiz":U THEN ASSIGN pFieldValue = RowObject.hora-atualiz.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "motivo-apr":U THEN ASSIGN pFieldValue = RowObject.motivo-apr.
        WHEN "nr-tab":U THEN ASSIGN pFieldValue = RowObject.nr-tab.
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
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
        WHEN "data-atualiz":U THEN ASSIGN pFieldValue = RowObject.data-atualiz.
        WHEN "data-cotacao":U THEN ASSIGN pFieldValue = RowObject.data-cotacao.
        WHEN "data-cotacao-desp":U THEN ASSIGN pFieldValue = RowObject.data-cotacao-desp.
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
        WHEN "perc-descto":U THEN ASSIGN pFieldValue = RowObject.perc-descto.
        WHEN "perc-taxa":U THEN ASSIGN pFieldValue = RowObject.perc-taxa.
        WHEN "val-desp":U THEN ASSIGN pFieldValue = RowObject.val-desp.
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
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-desp":U THEN ASSIGN pFieldValue = RowObject.cod-desp.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-emitente-desp":U THEN ASSIGN pFieldValue = RowObject.cod-emitente-desp.
        WHEN "cod-itiner":U THEN ASSIGN pFieldValue = RowObject.cod-itiner.
        WHEN "cod-pto-contr":U THEN ASSIGN pFieldValue = RowObject.cod-pto-contr.
        WHEN "dias-validade":U THEN ASSIGN pFieldValue = RowObject.dias-validade.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "mapa-cotacao":U THEN ASSIGN pFieldValue = RowObject.mapa-cotacao.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "nr-dias-taxa":U THEN ASSIGN pFieldValue = RowObject.nr-dias-taxa.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "seq-cotac":U THEN ASSIGN pFieldValue = RowObject.seq-cotac.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice codigo
  Parameters:  
               retorna valor do campo numero-ordem
               retorna valor do campo cod-emitente
               retorna valor do campo it-codigo
               retorna valor do campo seq-cotac
               retorna valor do campo data-cotacao
               retorna valor do campo mapa-cotacao
               retorna valor do campo cod-incoterm
               retorna valor do campo cod-itiner
               retorna valor do campo sequencia
               retorna valor do campo cod-emitente-desp
               retorna valor do campo cod-desp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnumero-ordem LIKE cotacao-item-cex.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE cotacao-item-cex.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE cotacao-item-cex.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq-cotac LIKE cotacao-item-cex.seq-cotac NO-UNDO.
    DEFINE OUTPUT PARAMETER pdata-cotacao LIKE cotacao-item-cex.data-cotacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pmapa-cotacao LIKE cotacao-item-cex.mapa-cotacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-incoterm LIKE cotacao-item-cex.cod-incoterm NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-itiner LIKE cotacao-item-cex.cod-itiner NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE cotacao-item-cex.sequencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente-desp LIKE cotacao-item-cex.cod-emitente-desp NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-desp LIKE cotacao-item-cex.cod-desp NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnumero-ordem = RowObject.numero-ordem
           pcod-emitente = RowObject.cod-emitente
           pit-codigo = RowObject.it-codigo
           pseq-cotac = RowObject.seq-cotac
           pdata-cotacao = RowObject.data-cotacao
           pmapa-cotacao = RowObject.mapa-cotacao
           pcod-incoterm = RowObject.cod-incoterm
           pcod-itiner = RowObject.cod-itiner
           psequencia = RowObject.sequencia
           pcod-emitente-desp = RowObject.cod-emitente-desp
           pcod-desp = RowObject.cod-desp.

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
        WHEN "taxa-financ":U THEN ASSIGN pFieldValue = RowObject.taxa-financ.
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
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo numero-ordem
               recebe valor do campo cod-emitente
               recebe valor do campo it-codigo
               recebe valor do campo seq-cotac
               recebe valor do campo data-cotacao
               recebe valor do campo mapa-cotacao
               recebe valor do campo cod-incoterm
               recebe valor do campo cod-itiner
               recebe valor do campo sequencia
               recebe valor do campo cod-emitente-desp
               recebe valor do campo cod-desp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnumero-ordem LIKE cotacao-item-cex.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE cotacao-item-cex.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE cotacao-item-cex.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pseq-cotac LIKE cotacao-item-cex.seq-cotac NO-UNDO.
    DEFINE INPUT PARAMETER pdata-cotacao LIKE cotacao-item-cex.data-cotacao NO-UNDO.
    DEFINE INPUT PARAMETER pmapa-cotacao LIKE cotacao-item-cex.mapa-cotacao NO-UNDO.
    DEFINE INPUT PARAMETER pcod-incoterm LIKE cotacao-item-cex.cod-incoterm NO-UNDO.
    DEFINE INPUT PARAMETER pcod-itiner LIKE cotacao-item-cex.cod-itiner NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE cotacao-item-cex.sequencia NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente-desp LIKE cotacao-item-cex.cod-emitente-desp NO-UNDO.
    DEFINE INPUT PARAMETER pcod-desp LIKE cotacao-item-cex.cod-desp NO-UNDO.

    FIND FIRST bfcotacao-item-cex WHERE 
        bfcotacao-item-cex.numero-ordem = pnumero-ordem AND 
        bfcotacao-item-cex.cod-emitente = pcod-emitente AND 
        bfcotacao-item-cex.it-codigo = pit-codigo AND 
        bfcotacao-item-cex.seq-cotac = pseq-cotac AND 
        bfcotacao-item-cex.data-cotacao = pdata-cotacao AND 
        bfcotacao-item-cex.mapa-cotacao = pmapa-cotacao AND 
        bfcotacao-item-cex.cod-incoterm = pcod-incoterm AND 
        bfcotacao-item-cex.cod-itiner = pcod-itiner AND 
        bfcotacao-item-cex.sequencia = psequencia AND 
        bfcotacao-item-cex.cod-emitente-desp = pcod-emitente-desp AND 
        bfcotacao-item-cex.cod-desp = pcod-desp NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcotacao-item-cex THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcotacao-item-cex)).
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

    OPEN QUERY {&QUERYNAME} for each {&TableName} NO-LOCK.

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


