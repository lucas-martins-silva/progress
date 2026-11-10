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
{include/i-prgvrs.i BOIN177 2.00.00.005} /*** "010005" 27/10/2023 17:03:43  ***/
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
&GLOBAL-DEFINE DBOName BOIN177
&GLOBAL-DEFINE DBOVersion 2.0
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-estab
&GLOBAL-DEFINE TableLabel Itens do Estabelecimento
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin177.i RowObject}


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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "deposito-pad":U THEN ASSIGN pFieldValue = RowObject.deposito-pad.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "niv-rest-dentro":U THEN ASSIGN pFieldValue = RowObject.niv-rest-dentro.
        WHEN "niv-rest-fora":U THEN ASSIGN pFieldValue = RowObject.niv-rest-fora.
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
        WHEN "data-ult-con":U THEN ASSIGN pFieldValue = RowObject.data-ult-con.
        WHEN "data-ult-sai":U THEN ASSIGN pFieldValue = RowObject.data-ult-sai.
        WHEN "mensal-ate":U THEN ASSIGN pFieldValue = RowObject.mensal-ate.
        WHEN "on-line-ate":U THEN ASSIGN pFieldValue = RowObject.on-line-ate.
        WHEN "padrao-ate":U THEN ASSIGN pFieldValue = RowObject.padrao-ate.
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
        WHEN "consumo-aad":U THEN ASSIGN pFieldValue = RowObject.consumo-aad.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "per-rest-dentro":U THEN ASSIGN pFieldValue = RowObject.per-rest-dentro.
        WHEN "per-rest-fora":U THEN ASSIGN pFieldValue = RowObject.per-rest-fora.
        WHEN "qtidade-atu":U THEN ASSIGN pFieldValue = RowObject.qtidade-atu.
        WHEN "sald-atu-ggf-m[1]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-ggf-m[1].
        WHEN "sald-atu-ggf-m[2]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-ggf-m[2].
        WHEN "sald-atu-ggf-m[3]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-ggf-m[3].
        WHEN "sald-atu-ggf-o[1]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-ggf-o[1].
        WHEN "sald-atu-ggf-o[2]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-ggf-o[2].
        WHEN "sald-atu-ggf-o[3]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-ggf-o[3].
        WHEN "sald-atu-ggf-p[1]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-ggf-p[1].
        WHEN "sald-atu-ggf-p[2]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-ggf-p[2].
        WHEN "sald-atu-ggf-p[3]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-ggf-p[3].
        WHEN "sald-atu-mat-m[1]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-mat-m[1].
        WHEN "sald-atu-mat-m[2]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-mat-m[2].
        WHEN "sald-atu-mat-m[3]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-mat-m[3].
        WHEN "sald-atu-mat-o[1]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-mat-o[1].
        WHEN "sald-atu-mat-o[2]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-mat-o[2].
        WHEN "sald-atu-mat-o[3]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-mat-o[3].
        WHEN "sald-atu-mat-p[1]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-mat-p[1].
        WHEN "sald-atu-mat-p[2]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-mat-p[2].
        WHEN "sald-atu-mat-p[3]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-mat-p[3].
        WHEN "sald-atu-mob-m[1]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-mob-m[1].
        WHEN "sald-atu-mob-m[2]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-mob-m[2].
        WHEN "sald-atu-mob-m[3]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-mob-m[3].
        WHEN "sald-atu-mob-o[1]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-mob-o[1].
        WHEN "sald-atu-mob-o[2]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-mob-o[2].
        WHEN "sald-atu-mob-o[3]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-mob-o[3].
        WHEN "sald-atu-mob-p[1]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-mob-p[1].
        WHEN "sald-atu-mob-p[2]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-mob-p[2].
        WHEN "sald-atu-mob-p[3]":U THEN ASSIGN pFieldValue = RowObject.sald-atu-mob-p[3].
        WHEN "sald-ini-ggf-m[1]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-ggf-m[1].
        WHEN "sald-ini-ggf-m[2]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-ggf-m[2].
        WHEN "sald-ini-ggf-m[3]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-ggf-m[3].
        WHEN "sald-ini-ggf-o[1]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-ggf-o[1].
        WHEN "sald-ini-ggf-o[2]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-ggf-o[2].
        WHEN "sald-ini-ggf-o[3]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-ggf-o[3].
        WHEN "sald-ini-ggf-p[1]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-ggf-p[1].
        WHEN "sald-ini-ggf-p[2]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-ggf-p[2].
        WHEN "sald-ini-ggf-p[3]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-ggf-p[3].
        WHEN "sald-ini-mat-m[1]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-mat-m[1].
        WHEN "sald-ini-mat-m[2]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-mat-m[2].
        WHEN "sald-ini-mat-m[3]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-mat-m[3].
        WHEN "sald-ini-mat-o[1]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-mat-o[1].
        WHEN "sald-ini-mat-o[2]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-mat-o[2].
        WHEN "sald-ini-mat-o[3]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-mat-o[3].
        WHEN "sald-ini-mat-p[1]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-mat-p[1].
        WHEN "sald-ini-mat-p[2]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-mat-p[2].
        WHEN "sald-ini-mat-p[3]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-mat-p[3].
        WHEN "sald-ini-mob-m[1]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-mob-m[1].
        WHEN "sald-ini-mob-m[2]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-mob-m[2].
        WHEN "sald-ini-mob-m[3]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-mob-m[3].
        WHEN "sald-ini-mob-o[1]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-mob-o[1].
        WHEN "sald-ini-mob-o[2]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-mob-o[2].
        WHEN "sald-ini-mob-o[3]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-mob-o[3].
        WHEN "sald-ini-mob-p[1]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-mob-p[1].
        WHEN "sald-ini-mob-p[2]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-mob-p[2].
        WHEN "sald-ini-mob-p[3]":U THEN ASSIGN pFieldValue = RowObject.sald-ini-mob-p[3].
        WHEN "tx-importacao":U THEN ASSIGN pFieldValue = RowObject.tx-importacao.
        WHEN "val-unit-ggf-m[1]":U THEN ASSIGN pFieldValue = RowObject.val-unit-ggf-m[1].
        WHEN "val-unit-ggf-m[2]":U THEN ASSIGN pFieldValue = RowObject.val-unit-ggf-m[2].
        WHEN "val-unit-ggf-m[3]":U THEN ASSIGN pFieldValue = RowObject.val-unit-ggf-m[3].
        WHEN "val-unit-ggf-o[1]":U THEN ASSIGN pFieldValue = RowObject.val-unit-ggf-o[1].
        WHEN "val-unit-ggf-o[2]":U THEN ASSIGN pFieldValue = RowObject.val-unit-ggf-o[2].
        WHEN "val-unit-ggf-o[3]":U THEN ASSIGN pFieldValue = RowObject.val-unit-ggf-o[3].
        WHEN "val-unit-ggf-p[1]":U THEN ASSIGN pFieldValue = RowObject.val-unit-ggf-p[1].
        WHEN "val-unit-ggf-p[2]":U THEN ASSIGN pFieldValue = RowObject.val-unit-ggf-p[2].
        WHEN "val-unit-ggf-p[3]":U THEN ASSIGN pFieldValue = RowObject.val-unit-ggf-p[3].
        WHEN "val-unit-mat-m[1]":U THEN ASSIGN pFieldValue = RowObject.val-unit-mat-m[1].
        WHEN "val-unit-mat-m[2]":U THEN ASSIGN pFieldValue = RowObject.val-unit-mat-m[2].
        WHEN "val-unit-mat-m[3]":U THEN ASSIGN pFieldValue = RowObject.val-unit-mat-m[3].
        WHEN "val-unit-mat-o[1]":U THEN ASSIGN pFieldValue = RowObject.val-unit-mat-o[1].
        WHEN "val-unit-mat-o[2]":U THEN ASSIGN pFieldValue = RowObject.val-unit-mat-o[2].
        WHEN "val-unit-mat-o[3]":U THEN ASSIGN pFieldValue = RowObject.val-unit-mat-o[3].
        WHEN "val-unit-mat-p[1]":U THEN ASSIGN pFieldValue = RowObject.val-unit-mat-p[1].
        WHEN "val-unit-mat-p[2]":U THEN ASSIGN pFieldValue = RowObject.val-unit-mat-p[2].
        WHEN "val-unit-mat-p[3]":U THEN ASSIGN pFieldValue = RowObject.val-unit-mat-p[3].
        WHEN "val-unit-mob-m[1]":U THEN ASSIGN pFieldValue = RowObject.val-unit-mob-m[1].
        WHEN "val-unit-mob-m[2]":U THEN ASSIGN pFieldValue = RowObject.val-unit-mob-m[2].
        WHEN "val-unit-mob-m[3]":U THEN ASSIGN pFieldValue = RowObject.val-unit-mob-m[3].
        WHEN "val-unit-mob-o[1]":U THEN ASSIGN pFieldValue = RowObject.val-unit-mob-o[1].
        WHEN "val-unit-mob-o[2]":U THEN ASSIGN pFieldValue = RowObject.val-unit-mob-o[2].
        WHEN "val-unit-mob-o[3]":U THEN ASSIGN pFieldValue = RowObject.val-unit-mob-o[3].
        WHEN "val-unit-mob-p[1]":U THEN ASSIGN pFieldValue = RowObject.val-unit-mob-p[1].
        WHEN "val-unit-mob-p[2]":U THEN ASSIGN pFieldValue = RowObject.val-unit-mob-p[2].
        WHEN "val-unit-mob-p[3]":U THEN ASSIGN pFieldValue = RowObject.val-unit-mob-p[3].
        WHEN "varia-acum":U THEN ASSIGN pFieldValue = RowObject.varia-acum.
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
        WHEN "ciclo-contag":U THEN ASSIGN pFieldValue = RowObject.ciclo-contag.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "num-id-item-estab":U THEN ASSIGN pFieldValue = RowObject.num-id-item-estab.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice item
  Parameters:  
               retorna valor do campo it-codigo
               retorna valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE item-estab.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE item-estab.cod-estabel NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo
           pcod-estabel = RowObject.cod-estabel.

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
        WHEN "atualizado":U THEN ASSIGN pFieldValue = RowObject.atualizado.
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
  Purpose:     Reposiciona registro com base no °ndice item
  Parameters:  
               recebe valor do campo it-codigo
               recebe valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE item-estab.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE item-estab.cod-estabel NO-UNDO.

    FIND FIRST bfitem-estab WHERE 
        bfitem-estab.it-codigo = pit-codigo AND 
        bfitem-estab.cod-estabel = pcod-estabel NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-estab THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-estab)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram 
PROCEDURE openQueryDefault :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   OPEN QUERY {&QueryName} FOR EACH {&TableName}  NO-LOCK INDEXED-REPOSITION.
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

