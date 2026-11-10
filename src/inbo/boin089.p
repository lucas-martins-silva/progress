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
{include/i-prgvrs.i BOIN089 2.00.00.012 } /*** "010012" 13/11/2023 11:45:47 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin089 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ² um programa PROGRESS
                 que cont²m a l½gica de neg½cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini»’o ---*/
&GLOBAL-DEFINE DBOName doc-fisico
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName doc-fisico
&GLOBAL-DEFINE TableLabel doc-fisico
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com defini»’o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com
      extens’o .i ---*/
{inbo/boin089.i RowObject}

/*--- Include com defini»’o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera»’o da defini»’o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»’o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Variaveis para openQuery e SetConstraint Range1, Range2, Range3         */

def var cIniNroDocto   as char no-undo.
def var cEndNroDocto   as char no-undo.
def var cIniSerieDocto as char no-undo.
def var cEndSerieDocto as char no-undo.
def var iIniEmitente   as int  no-undo.
def var iEndEmitente   as int  no-undo.
def var cIniCodEstabel as char no-undo.
def var cEndCodEstabel as char no-undo.
def var dIniDtTrans    as date no-undo.
def var dEndDtTrans    as date no-undo.
def var iSituacao      as int  no-undo.
DEF VAR iIniTpNota     AS INT  NO-UNDO.
DEF VAR iEndTpNota     AS INT  NO-UNDO.

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
         HEIGHT             = 24.17
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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "estab-de-or":U THEN ASSIGN pFieldValue = RowObject.estab-de-or.
        WHEN "nat-comp":U THEN ASSIGN pFieldValue = RowObject.nat-comp.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-atualiza":U THEN ASSIGN pFieldValue = RowObject.dt-atualiza.
        WHEN "dt-emissao":U THEN ASSIGN pFieldValue = RowObject.dt-emissao.
        WHEN "dt-trans":U THEN ASSIGN pFieldValue = RowObject.dt-trans.
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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "valor-seguro":U THEN ASSIGN pFieldValue = RowObject.valor-seguro.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "despesa-nota":U THEN ASSIGN pFieldValue = RowObject.despesa-nota.
        WHEN "tot-desconto":U THEN ASSIGN pFieldValue = RowObject.tot-desconto.
        WHEN "tot-peso":U THEN ASSIGN pFieldValue = RowObject.tot-peso.
        WHEN "valor-frete":U THEN ASSIGN pFieldValue = RowObject.valor-frete.
        WHEN "valor-mercad":U THEN ASSIGN pFieldValue = RowObject.valor-mercad.
        WHEN "valor-outras":U THEN ASSIGN pFieldValue = RowObject.valor-outras.
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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        WHEN "tipo-nota":U THEN ASSIGN pFieldValue = RowObject.tipo-nota.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ­ndice DOCUMENTO
  Parameters:
               retorna valor dos campos do ­ndice DOCUMENTO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE doc-fisico.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE doc-fisico.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE doc-fisico.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER ptipo-nota LIKE doc-fisico.tipo-nota NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pserie-docto = RowObject.serie-docto.
    ASSIGN pnro-docto = RowObject.nro-docto.
    ASSIGN pcod-emitente = RowObject.cod-emitente.
    ASSIGN ptipo-nota = RowObject.tipo-nota.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l½gico
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "estorn-comis":U THEN ASSIGN pFieldValue = RowObject.estorn-comis.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
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
  Purpose:     Reposiciona registro com base no ­ndice DOCUMENTO
  Parameters:
               recebe valor dos campos do ­ndice DOCUMENTO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE doc-fisico.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE doc-fisico.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE doc-fisico.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER ptipo-nota LIKE doc-fisico.tipo-nota NO-UNDO.

    FIND FIRST bfdoc-fisico WHERE
        bfdoc-fisico.serie-docto = pserie-docto AND
        bfdoc-fisico.nro-docto = pnro-docto AND
        bfdoc-fisico.cod-emitente = pcod-emitente AND
        bfdoc-fisico.tipo-nota = ptipo-nota
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdoc-fisico THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdoc-fisico)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
    OPEN QUERY {&QueryName} FOR EACH doc-fisico NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangePage1 DBOProgram 
PROCEDURE openQueryRangePage1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName}
         where {&tableName}.nro-docto   >= cIniNroDocto
           and {&tableName}.nro-docto   <= cEndNroDocto
           and {&tableName}.serie-docto >= cIniSerieDocto
           and {&tableName}.serie-docto <= cEndSerieDocto             
           and {&tableName}.situacao     = iSituacao
           no-lock 
           indexed-reposition.


   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangePage2 DBOProgram 
PROCEDURE openQueryRangePage2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
      
      open query qr{&tableName} for each {&tableName}
           where {&tableName}.cod-emitente >= iIniEmitente
             and {&tableName}.cod-emitente <= iEndEmitente
             and {&tableName}.cod-estabel  >= cIniCodEstabel
             and {&tableName}.cod-estabel  <= cEndCodEstabel
             and {&tableName}.situacao      = iSituacao
             no-lock
             indexed-reposition.
             
             
      return "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangePage3 DBOProgram 
PROCEDURE openQueryRangePage3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
      
      open query qr{&tableName} for each {&tableName}
           where {&tableName}.dt-trans     >= dIniDtTrans
             and {&tableName}.dt-trans     <= dEndDtTrans
             and {&tableName}.cod-estabel  >= cIniCodEstabel
             and {&tableName}.cod-estabel  <= cEndCodEstabel 
             and {&tableName}.situacao      = iSituacao
             no-lock
             indexed-reposition.             
             
      return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangePage4 DBOProgram 
PROCEDURE openQueryRangePage4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
      OPEN QUERY qr{&tableName} FOR EACH {&tableName}
           WHERE {&tableName}.nro-docto   >= cIniNroDocto   
             AND {&tableName}.nro-docto   <= cEndNroDocto   
             AND {&tableName}.serie-docto >= cIniSerieDocto 
             AND {&tableName}.serie-docto <= cEndSerieDocto 
             AND {&tableName}.cod-emitente >= iIniEmitente
             AND {&tableName}.cod-emitente <= iEndEmitente
             AND {&tableName}.tipo-nota    >= iIniTpNota
             AND {&tableName}.tipo-nota    <= iEndTpNota
             NO-LOCK
             INDEXED-REPOSITION.
             
      return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangePage1 DBOProgram 
PROCEDURE setConstraintRangePage1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pcIniNroDocto   as char no-undo.
def input param pcEndNroDocto   as char no-undo.
def input param pcIniSerieDocto as char no-undo.
def input param pcEndSerieDocto as char no-undo.
def input param piSituacao      as int  no-undo.

    assign cIniNroDocto   = pcIniNroDocto
           cEndNroDocto   = pcEndNroDocto
           cIniSerieDocto = pcIniSerieDocto
           cEndSerieDocto = pcEndSerieDocto
           iSituacao      = piSituacao.

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangePage2 DBOProgram 
PROCEDURE setConstraintRangePage2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param piIniEmitente   as int  no-undo.
def input param piEndEmitente   as int  no-undo.
def input param pcIniCodEstabel as char no-undo.
def input param pcEndCodEstabel as char no-undo.
def input param piSituacao      as int  no-undo.

assign iIniEmitente   = piIniEmitente
       iEndEmitente   = piEndEmitente
       cIniCodEstabel = pcIniCodEstabel
       cEndCodEstabel = pcEndCodEstabel
       iSituacao      = piSituacao.
       
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangePage3 DBOProgram 
PROCEDURE setConstraintRangePage3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pdIniDtTrans    as date no-undo.
def input param pdEndDtTrans    as date no-undo.
def input param pcIniCodEstabel as char no-undo.
def input param pcEndCodEstabel as char no-undo.
def input param piSituacao      as int  no-undo.

assign dIniDtTrans    = pdIniDtTrans
       dEndDtTrans    = pdEndDtTrans
       cIniCodEstabel = pcIniCodEstabel
       cEndCodEstabel = pcEndCodEstabel
       iSituacao      = piSituacao.
       
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangePage4 DBOProgram 
PROCEDURE setConstraintRangePage4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pcIniNroDocto   AS CHAR NO-UNDO. 
    DEF INPUT PARAM pcEndNroDocto   AS CHAR NO-UNDO.
    DEF INPUT PARAM pcIniSerieDocto AS CHAR NO-UNDO.
    DEF INPUT PARAM pcEndSerieDocto AS CHAR NO-UNDO.
    DEF INPUT PARAM piIniEmitente   AS INT  NO-UNDO.
    DEF INPUT PARAM piEndEmitente   AS INT  NO-UNDO.
    DEF INPUT PARAM piIniTpNota     AS INT  NO-UNDO.
    DEF INPUT PARAM piEndTpNota     AS INT  NO-UNDO.

    ASSIGN cIniNroDocto   = pcIniNroDocto
           cEndNroDocto   = pcEndNroDocto
           cIniSerieDocto = pcIniSerieDocto
           cEndSerieDocto = pcEndSerieDocto
           iIniEmitente   = piIniEmitente
           iEndEmitente   = piEndEmitente
           iIniTpNota     = piIniTpNota
           iEndTpNota     = piEndTpNota.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de valida»’o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*--- Utilize o par³metro pType para identificar quais as valida»„es a serem
          executadas ---*/
    /*--- Os valores poss­veis para o par³metro s’o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav²s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida»„es ---*/

    IF pType = "Create":U
    OR pType = "Update":U THEN DO:
        RUN bloqueiaNfeComDiverg (input RowObject.cod-emitente,
                                  input RowObject.cod-estabel, 
                                  input RowObject.serie-docto, 
                                  input RowObject.nro-docto,   
                                  input RowObject.dt-emissao).
                                  
        IF RowObject.origem <> "XML":U THEN DO:
            RUN bloqueiaDigitXML (INPUT RowObject.cod-emitente,
                                  INPUT RowObject.cod-estabel,
                                  INPUT RowObject.serie-docto,
                                  INPUT RowObject.nro-docto,
                                  INPUT RowObject.dt-emissao).
        END.
    END.

    IF pType = "UPDATE"
    OR pType = "DELETE" THEN DO:
        IF  RowObject.ind-sit-wms-ext = 2 THEN DO: //Aguardando
            {method/svc/errors/inserr.i &ErrorNumber="57470"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" }
        END.
        IF  RowObject.ind-sit-wms-ext = 3 THEN DO: //Em processo
            {method/svc/errors/inserr.i &ErrorNumber="57471"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" }
        END.
        IF  pType = "DELETE" AND RowObject.ind-sit-wms-ext = 5 THEN DO: //Conferencia NOK
            {method/svc/errors/inserr.i &ErrorNumber="57472"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" }
        END.
    END.

    /*--- Verifica ocorr¼ncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaExistenciaDoc DBOProgram 
PROCEDURE verificaExistenciaDoc :
/*------------------------------------------------------------------------------
  Purpose:     Verificar a existˆncia do documento no f¡sico.
  
  Parameters:  p-i-cod-emitente -> C¢digo do emitente do documento;
               p-c-nro-docto    -> N£mero do documento;
               p-c-serie-docto  -> S‚rie do documento;
               p-dt-emissao     -> Data de emissÆo do documento;
               l-ja-existe      -> Indicador de que o documento j  existe no 
                                   f¡sico.                                   
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-i-cod-emitente LIKE doc-fisico.cod-emitente NO-UNDO.
    DEFINE INPUT  PARAMETER p-c-nro-docto    LIKE doc-fisico.nro-docto    NO-UNDO.
    DEFINE INPUT  PARAMETER p-c-serie-docto  LIKE doc-fisico.serie-docto  NO-UNDO.
    DEFINE INPUT  PARAMETER p-dt-emissao     LIKE doc-fisico.dt-emissao   NO-UNDO.
    DEFINE OUTPUT PARAMETER l-ja-existe      AS LOGICAL INITIAL FALSE     NO-UNDO.
    
    ASSIGN l-ja-existe = CAN-FIND(FIRST doc-fisico 
                                  WHERE doc-fisico.cod-emitente = p-i-cod-emitente
                                  AND   doc-fisico.nro-docto    = p-c-nro-docto
                                  AND   doc-fisico.serie-docto  = p-c-serie-docto
                                  AND   doc-fisico.dt-emissao   = p-dt-emissao).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bloqueiaNfeComDiverg DBOProgram 
PROCEDURE bloqueiaNfeComDiverg:
    DEFINE INPUT  PARAMETER p-i-cod-emitente LIKE doc-fisico.cod-emitente NO-UNDO.
    DEFINE INPUT  PARAMETER p-c-cod-estabel  LIKE doc-fisico.cod-estabel  NO-UNDO.
    DEFINE INPUT  PARAMETER p-c-serie-docto  LIKE doc-fisico.serie-docto  NO-UNDO.
    DEFINE INPUT  PARAMETER p-c-nro-docto    LIKE doc-fisico.nro-docto    NO-UNDO.
    DEFINE INPUT  PARAMETER p-dt-emissao     LIKE doc-fisico.dt-emissao   NO-UNDO.
        
    DEF VAR h-boin01109  AS HANDLE NO-UNDO.

    IF NOT VALID-HANDLE(h-boin01109) THEN
       RUN inbo/boin01109.p PERSISTENT SET h-boin01109.

    RUN emptyRowErrors  IN h-boin01109.
    RUN bloqueiaEntNfeComDivergChaveDocto IN h-boin01109 (INPUT p-i-cod-emitente,
                                                          INPUT p-c-cod-estabel,
                                                          INPUT p-c-serie-docto, 
                                                          INPUT p-c-nro-docto,
                                                          INPUT p-dt-emissao).
    RUN getRowErrors    IN h-boin01109 (OUTPUT TABLE RowErrors APPEND).

    IF CAN-FIND(FIRST RowErrors 
                WHERE RowErrors.ErrorType   <> "INTERNAL":U
                  AND RowErrors.ErrorSubType = "ERROR":U) THEN
       RETURN "NOK":U.
    
    
    RETURN "OK":U.       
    FINALLY:
        DELETE PROCEDURE h-boin01109 NO-ERROR.
        ASSIGN h-boin01109 = ?.
    END FINALLY.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bloqueiaDigitXML DBOProgram 
PROCEDURE bloqueiaDigitXML:
    DEFINE INPUT  PARAMETER p-i-cod-emitente LIKE doc-fisico.cod-emitente NO-UNDO.
    DEFINE INPUT  PARAMETER p-c-cod-estabel  LIKE doc-fisico.cod-estabel  NO-UNDO.
    DEFINE INPUT  PARAMETER p-c-serie-docto  LIKE doc-fisico.serie-docto  NO-UNDO.
    DEFINE INPUT  PARAMETER p-c-nro-docto    LIKE doc-fisico.nro-docto    NO-UNDO.
    DEFINE INPUT  PARAMETER p-dt-emissao     LIKE doc-fisico.dt-emissao   NO-UNDO.
        
    DEFINE VARIABLE c-chave-aux     AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE l-erro-aux      AS LOGICAL INITIAL NO   NO-UNDO.
    
    IF CAN-FIND (FIRST param-estoq NO-LOCK
                 WHERE param-estoq.bloq-digit-xml) THEN DO:
        
        FOR FIRST doc-orig-nfe NO-LOCK
            WHERE doc-orig-nfe.cod-emitente    = p-i-cod-emitente
              AND doc-orig-nfe.cod-estabel     = p-c-cod-estabel
              AND doc-orig-nfe.serie-docto     = p-c-serie-docto
              AND doc-orig-nfe.nro-docto       = p-c-nro-docto
              AND doc-orig-nfe.dt-emissao      = p-dt-emissao:
            ASSIGN l-erro-aux   = YES
                   c-chave-aux  = doc-orig-nfe.ch-acesso-comp-nfe.
        END.
        
        IF l-erro-aux THEN DO:
            {METHOD/svc/errors/inserr.i &ErrorNumber="57657"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-chave-aux"}            
        END.
    END.

    
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
