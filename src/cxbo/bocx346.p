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
&GLOBAL-DEFINE DBOName BOCX346
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName proc-docto-export
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{cxbo/bocx346.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEF var cCodEstabel  LIKE processo-exp.cod-estabel  NO-UNDO.
DEF var cNrProcExp   LIKE processo-exp.nr-proc-exp  NO-UNDO.

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
        WHEN "cod-docto":U THEN ASSIGN pFieldValue = RowObject.cod-docto.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "des-docto":U THEN ASSIGN pFieldValue = RowObject.des-docto.
        WHEN "hora-emissao":U THEN ASSIGN pFieldValue = RowObject.hora-emissao.
        WHEN "nr-proc-exp":U THEN ASSIGN pFieldValue = RowObject.nr-proc-exp.
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
        WHEN "data-emissao":U THEN ASSIGN pFieldValue = RowObject.data-emissao.
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
        WHEN "idi-tip-docto":U THEN ASSIGN pFieldValue = RowObject.idi-tip-docto.
        WHEN "num-cop-docto":U THEN ASSIGN pFieldValue = RowObject.num-cop-docto.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-vias":U THEN ASSIGN pFieldValue = RowObject.num-vias.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice prcsdctx-id
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo nr-proc-exp
               retorna valor do campo data-emissao
               retorna valor do campo hora-emissao
               retorna valor do campo idi-tip-docto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE proc-docto-export.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-proc-exp LIKE proc-docto-export.nr-proc-exp NO-UNDO.
    DEFINE OUTPUT PARAMETER pdata-emissao LIKE proc-docto-export.data-emissao NO-UNDO.
    DEFINE OUTPUT PARAMETER phora-emissao LIKE proc-docto-export.hora-emissao NO-UNDO.
    DEFINE OUTPUT PARAMETER pidi-tip-docto LIKE proc-docto-export.idi-tip-docto NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pnr-proc-exp = RowObject.nr-proc-exp
           pdata-emissao = RowObject.data-emissao
           phora-emissao = RowObject.hora-emissao
           pidi-tip-docto = RowObject.idi-tip-docto.

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
  Purpose:     Reposiciona registro com base no °ndice prcsdctx-id
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo nr-proc-exp
               recebe valor do campo data-emissao
               recebe valor do campo hora-emissao
               recebe valor do campo idi-tip-docto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE proc-docto-export.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-exp LIKE proc-docto-export.nr-proc-exp NO-UNDO.
    DEFINE INPUT PARAMETER pdata-emissao LIKE proc-docto-export.data-emissao NO-UNDO.
    DEFINE INPUT PARAMETER phora-emissao LIKE proc-docto-export.hora-emissao NO-UNDO.
    DEFINE INPUT PARAMETER pidi-tip-docto LIKE proc-docto-export.idi-tip-docto NO-UNDO.

    FIND FIRST bfproc-docto-export WHERE 
        bfproc-docto-export.cod-estabel = pcod-estabel AND 
        bfproc-docto-export.nr-proc-exp = pnr-proc-exp AND 
        bfproc-docto-export.data-emissao = pdata-emissao AND 
        bfproc-docto-export.hora-emissao = phora-emissao AND 
        bfproc-docto-export.idi-tip-docto = pidi-tip-docto NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfproc-docto-export THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfproc-docto-export)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfProcExp DBOProgram 
PROCEDURE openQueryOfProcExp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query qr{&tableName} 
         FOR EACH  {&tableName} 
             WHERE {&tableName}.cod-estabel  = cCodEstabel 
             AND   {&tableName}.nr-proc-exp  = cNrProcExp
        NO-LOCK INDEXED-REPOSITION.                                         

     RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfProcExp DBOProgram 
PROCEDURE setConstraintOfProcExp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pcCodEstabel  LIKE processo-exp.cod-estabel  NO-UNDO.
    DEF INPUT PARAM pcNrProcExp   LIKE processo-exp.nr-proc-exp  NO-UNDO.

    ASSIGN cCodEstabel  = pcCodEstabel 
           cNrProcExp   = pcNrProcExp.

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
        when "Create":U or when "Update":U then do:

            if  RowObject.data-emissao = ? then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-data-emissao AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Data_Emiss∆o" *}
                ASSIGN c-lbl-liter-data-emissao = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-docto-proc-exportacao AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Docto_Proc_Exportaá∆o" *}
                ASSIGN c-lbl-liter-docto-proc-exportacao = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-merge-data-emissaodocto-proc-exporta AS CHARACTER NO-UNDO.
                ASSIGN c-lbl-merge-data-emissaodocto-proc-exporta = c-lbl-liter-data-emissao + "~~" + c-lbl-liter-docto-proc-exportacao.
                {method/svc/errors/inserr.i
                            &ErrorNumber=6216
                            &ErrorType="EMS"
                            &ErrorParameters="c-lbl-merge-data-emissaodocto-proc-exporta"}
            end.

            if  RowObject.hora-emissao = "" or
                int(RowObject.hora-emissao) = 0 then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-hora-emissao AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Hora_Emiss∆o" *}
                ASSIGN c-lbl-liter-hora-emissao = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-docto-proc-exportacao-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Docto_Proc_Exportaá∆o" *}
                ASSIGN c-lbl-liter-docto-proc-exportacao-2 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-merge-hora-emissaodocto-proc-exporta AS CHARACTER NO-UNDO.
                ASSIGN c-lbl-merge-hora-emissaodocto-proc-exporta = c-lbl-liter-hora-emissao + "~~" + c-lbl-liter-docto-proc-exportacao-2.
                {method/svc/errors/inserr.i
                            &ErrorNumber=6216
                            &ErrorType="EMS"
                            &ErrorParameters="c-lbl-merge-hora-emissaodocto-proc-exporta"}
            end.

             if  pType = "Create":U then do:
                 if  can-find(first bfproc-docto-export no-lock
                              where bfproc-docto-export.cod-estabel   = RowObject.cod-estabel
                                and bfproc-docto-export.nr-proc-exp   = RowObject.nr-proc-exp
                                and bfproc-docto-export.data-emissao  = RowObject.data-emissao
                                and bfproc-docto-export.hora-emissao  = RowObject.hora-emissao
                                and bfproc-docto-export.idi-tip-docto = RowObject.idi-tip-docto) then do:
                     /* Inicio -- Projeto Internacional */
                     DEFINE VARIABLE c-lbl-liter-docto-proc-exportacao-3 AS CHARACTER NO-UNDO.
                     {utp/ut-liter.i "Docto_Proc_Exportaá∆o" *}
                     ASSIGN c-lbl-liter-docto-proc-exportacao-3 = TRIM(RETURN-VALUE).
                     {method/svc/errors/inserr.i
                             &ErrorNumber="1"
                             &ErrorType="EMS"
                             &ErrorParameters="c-lbl-liter-docto-proc-exportacao-3"}
                 end.
             end.

             if  RowObject.cod-docto = "" then do:
                 {method/svc/errors/inserr.i
                             &ErrorNumber=6247
                             &ErrorType="EMS"}
             end.

             if  RowObject.des-docto = "" then do:
                 {method/svc/errors/inserr.i
                             &ErrorNumber=190
                             &ErrorType="EMS"}
             end.
        end.

    end case.       

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

