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
{include/i-prgvrs.i BOIN622 2.00.00.003} /*** "010003" 24/11/2023 13:25:24  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN622 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
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
&GLOBAL-DEFINE DBOName aprovador
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName aprovador
&GLOBAL-DEFINE TableLabel aprovador
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{inbo/boin622.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Definiá∆o das vari†veis necess†rias a setConstraintByCodAprov */
DEFINE VARIABLE c-cod-aprov-ini         AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-aprov-fim         AS CHARACTER NO-UNDO.

/* Definiá∆o das vari†veis necess†rias a setConstraintByDesAprov */
DEFINE VARIABLE c-des-aprov-ini         AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-des-aprov-fim         AS CHARACTER NO-UNDO.

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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "des-aprov":U THEN ASSIGN pFieldValue = RowObject.des-aprov.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "cod-aprov":U THEN ASSIGN pFieldValue = RowObject.cod-aprov.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
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
               retorna status do processo
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
        WHEN "lim-cotac":U THEN ASSIGN pFieldValue = RowObject.lim-cotac.
        WHEN "lim-event":U THEN ASSIGN pFieldValue = RowObject.lim-event.
        WHEN "lim-medic":U THEN ASSIGN pFieldValue = RowObject.lim-medic.
        WHEN "lim-pedido":U THEN ASSIGN pFieldValue = RowObject.lim-pedido.
        WHEN "lim-req-manut":U THEN ASSIGN pFieldValue = RowObject.lim-req-manut.
        WHEN "lim-requis":U THEN ASSIGN pFieldValue = RowObject.lim-requis.
        WHEN "lim-solic":U THEN ASSIGN pFieldValue = RowObject.lim-solic.
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
               retorna status do processo
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
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice APROVADOR
  Parameters:
               retorna valor dos campos do °ndice APROVADOR
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-aprov LIKE aprovador.cod-aprov NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-aprov = RowObject.cod-aprov.

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
               retorna status do processo
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
        WHEN "mestre":U THEN ASSIGN pFieldValue = RowObject.mestre.
        WHEN "perm-contdoc":U THEN ASSIGN pFieldValue = RowObject.perm-contdoc.
        WHEN "perm-cotac":U THEN ASSIGN pFieldValue = RowObject.perm-cotac.
        WHEN "perm-event":U THEN ASSIGN pFieldValue = RowObject.perm-event.
        WHEN "perm-manut":U THEN ASSIGN pFieldValue = RowObject.perm-manut.
        WHEN "perm-medic":U THEN ASSIGN pFieldValue = RowObject.perm-medic.
        WHEN "perm-pedido":U THEN ASSIGN pFieldValue = RowObject.perm-pedido.
        WHEN "perm-requis":U THEN ASSIGN pFieldValue = RowObject.perm-requis.
        WHEN "perm-solic":U THEN ASSIGN pFieldValue = RowObject.perm-solic.
        WHEN "aprov-tec":U THEN ASSIGN pFieldValue = RowObject.aprov-tec.
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
               retorna status do processo
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
  Purpose:     Reposiciona registro com base no °ndice APROVADOR
  Parameters:
               recebe valor dos campos do °ndice APROVADOR
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-aprov LIKE aprovador.cod-aprov NO-UNDO.

    FIND FIRST bfaprovador WHERE
        bfaprovador.cod-aprov = pcod-aprov
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfaprovador THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfaprovador)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByCodAprov DBOProgram 
PROCEDURE openQueryByCodAprov :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TABLENAME} WHERE 
                                     {&TABLENAME}.cod-aprov >= c-cod-aprov-ini   AND
                                     {&TABLENAME}.cod-aprov <= c-cod-aprov-fim   NO-LOCK 
                                     BY {&TABLENAME}.cod-aprov INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDesAprov DBOProgram 
PROCEDURE openQueryByDesAprov :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TABLENAME} WHERE 
                                     {&TABLENAME}.des-aprov >= c-des-aprov-ini   AND
                                     {&TABLENAME}.des-aprov <= c-des-aprov-fim   NO-LOCK 
                                     BY {&TABLENAME}.des-aprov INDEXED-REPOSITION.

    RETURN "OK":U.

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
    OPEN QUERY {&QueryName} FOR EACH aprovador NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByCodAprov DBOProgram 
PROCEDURE setConstraintByCodAprov :
/*------------------------------------------------------------------------------
  Purpose:     SetConstraint referente ordenaá∆o do c¢digo da tabela aprovador
  Parameters:  
               recebe c¢digo inicial da tabela aprovador 
               recebe c¢digo final da tabela aprovador
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-aprov-ini AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcod-aprov-fim AS CHARACTER NO-UNDO.
    ASSIGN c-cod-aprov-ini = pcod-aprov-ini
           c-cod-aprov-fim = pcod-aprov-fim.
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByDesAprov DBOProgram 
PROCEDURE setConstraintByDesAprov :
/*------------------------------------------------------------------------------
  Purpose:     SetConstraint referente ordenaá∆o do nome do aprovador da tabela aprovador
  Parameters:  
               recebe nome do aprovador inicial da tabela aprovador 
               recebe nome do aprovador final da tabela aprovador
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdes-aprov-ini AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pdes-aprov-fim AS CHARACTER NO-UNDO.
    ASSIGN c-des-aprov-ini = pdes-aprov-ini
           c-des-aprov-fim = pdes-aprov-fim.
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE posicionaPagina DBOProgram 
PROCEDURE posicionaPagina:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/

    define input  parameter pRowidAprov     as rowid   no-undo.
    define output parameter lHabilitFolder1 as logical no-undo.
    define output parameter lHabilitFolder2 as logical no-undo.
    define output parameter lHabilitFolder3 as logical no-undo.
    define output parameter lHabilitFolder4 as logical no-undo.
    define output parameter lHabilitFolder5 as logical no-undo.
    define output parameter lHabilitFolder6 as logical no-undo.
    define output parameter lHabilitFolder7 as logical no-undo.
    define output parameter lHabilitFolder8 as logical no-undo.
    define output parameter lHabilitFolder9 as logical no-undo.
    define output parameter iSelectPage     as integer no-undo.


    find aprovador where rowid(aprovador) = pRowidAprov no-lock no-error.
    if avail aprovador then do:
        assign iSelectPage = 1.
        if not aprovador.perm-solic  then do:
            assign lHabilitFolder1 = no
                   lHabilitFolder5 = no.
            assign iSelectPage = 2.
        end.
        else do:
            assign lHabilitFolder1 = yes
                   lHabilitFolder5 = yes.        
        end.

        if not aprovador.perm-requis then do:
            assign lHabilitFolder2 = no.
            if iSelectPage = 2 then
                assign iSelectPage = 3.
        end.
        else
            assign lHabilitFolder2 = yes.

        if not aprovador.perm-cotac  then do:
            assign lHabilitFolder3 = no.
            if iSelectPage = 3 then
                assign iSelectPage = 4.
        end.
        else
            assign lHabilitFolder3 = yes.

        if not aprovador.perm-pedido then do:
            assign lHabilitFolder4 = no
                   lHabilitFolder6 = no.
            if iSelectPage = 4 or iSelectPage = 6 then
                assign iSelectPage = 7.
        end.
        else do:
            assign lHabilitFolder4 = yes
                   lHabilitFolder6 = yes.
        end.

        if not aprovador.log-1  then do:
           assign lHabilitFolder7 = no.
            if iSelectPage = 7 then
                assign iSelectPage = 8.
        end.
        else
            assign lHabilitFolder7 = yes.

        if not aprovador.log-2  then do:
           assign lHabilitFolder8 = no.
            if iSelectPage = 8 then
                assign iSelectPage = 9.
        end.
        else
            assign lHabilitFolder8 = yes.

        if not aprovador.perm-manut  then do:
            assign lHabilitFolder9 = no.
        end.
        else
            assign lHabilitFolder9 = yes.
    end.
     
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
/* _UIB-CODE-BLOCK-END */
