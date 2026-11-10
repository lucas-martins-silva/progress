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
{include/i-prgvrs.i BOIN082Q02 2.00.00.009 } /*** "010009" 23/11/2023 16:19:42  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN082Q02 MUT}
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
&GLOBAL-DEFINE DBOName cotacao-item
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName cotacao-item
&GLOBAL-DEFINE TableLabel cotacao-item
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (boin082.p) est  com as fun‡äes de inclui (createRecord), 
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas, 
**  porque Sà nela foram implementadas as triggers do dicion rio.
**  Para desabilitar as procedures foram usados os pr‚-processadores abaixo.
**  A procedure validateRecord dessa DBO nÆo deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0


/*--- Include com defini»’o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com
      extens’o .i ---*/
{inbo/boin082.i RowObject}

/*--- Include com defini»’o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera»’o da defini»’o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»’o
      manual da query ---*/
      
/*Include "comentado" pois a query do programa wcc0303.w necessita tamb‚m da tabela ordem-compra 
para a abertura da mesma*/

/*{method/dboqry.i}*/ 


DEFINE QUERY {&QUERYNAME} for {&TABLENAME},ordem-compra,emitente scrolling.

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/******   Vari veis setConstraint1  *******/

    def var cItCodigo    as char no-undo.
    def var daDataIni    as date no-undo.
    def var daDataFim    as date no-undo.     
    def var iEmitenteIni as int  no-undo.
    def var iEmitenteFim as int  no-undo.
    def var iOrdemIni    as int  no-undo.
    def var iOrdemFim    as int  no-undo.       
    def var iLabel       as int  no-undo. 
    def var lAmbos       as log  no-undo.
    def var lAprovada    as log  no-undo.
    def var lDesvinc     as log  no-undo.
    def var de-ordem-fim as dec no-undo.

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
         HEIGHT             = 16.29
         WIDTH              = 60.2.
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
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "motivo-apr":U THEN ASSIGN pFieldValue = RowObject.motivo-apr.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "nr-tab":U THEN ASSIGN pFieldValue = RowObject.nr-tab.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
        WHEN "aprovador":U THEN ASSIGN pFieldValue = RowObject.aprovador.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
        WHEN "contato":U THEN ASSIGN pFieldValue = RowObject.contato.
        WHEN "hora-atualiz":U THEN ASSIGN pFieldValue = RowObject.hora-atualiz.
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
        WHEN "data-atualiz":U THEN ASSIGN pFieldValue = RowObject.data-atualiz.
        WHEN "data-cotacao":U THEN ASSIGN pFieldValue = RowObject.data-cotacao.
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
        WHEN "perc-descto":U THEN ASSIGN pFieldValue = RowObject.perc-descto.
        WHEN "pre-unit-for":U THEN ASSIGN pFieldValue = RowObject.pre-unit-for.
        WHEN "preco-fornec":U THEN ASSIGN pFieldValue = RowObject.preco-fornec.
        WHEN "preco-unit":U THEN ASSIGN pFieldValue = RowObject.preco-unit.
        WHEN "valor-descto":U THEN ASSIGN pFieldValue = RowObject.valor-descto.
        WHEN "valor-frete":U THEN ASSIGN pFieldValue = RowObject.valor-frete.
        WHEN "valor-taxa":U THEN ASSIGN pFieldValue = RowObject.valor-taxa.
        WHEN "aliquota-icm":U THEN ASSIGN pFieldValue = RowObject.aliquota-icm.
        WHEN "aliquota-ipi":U THEN ASSIGN pFieldValue = RowObject.aliquota-ipi.
        WHEN "aliquota-iss":U THEN ASSIGN pFieldValue = RowObject.aliquota-iss.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "ind-reajuste":U THEN ASSIGN pFieldValue = RowObject.ind-reajuste.
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
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "nr-dias-taxa":U THEN ASSIGN pFieldValue = RowObject.nr-dias-taxa.
        WHEN "num-proc-entr-edi":U THEN ASSIGN pFieldValue = RowObject.num-proc-entr-edi.
        WHEN "num-proc-envio-edi":U THEN ASSIGN pFieldValue = RowObject.num-proc-envio-edi.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "prazo-entreg":U THEN ASSIGN pFieldValue = RowObject.prazo-entreg.
        WHEN "seq-cotac":U THEN ASSIGN pFieldValue = RowObject.seq-cotac.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-transp.
        WHEN "codigo-icm":U THEN ASSIGN pFieldValue = RowObject.codigo-icm.
        WHEN "dias-validade":U THEN ASSIGN pFieldValue = RowObject.dias-validade.
        WHEN "ind-via-envio":U THEN ASSIGN pFieldValue = RowObject.ind-via-envio.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "ind-orig-entrada":U THEN ASSIGN pFieldValue = RowObject.ind-orig-entrada.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ­ndice COTACAO
  Parameters:
               retorna valor dos campos do ­ndice COTACAO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnumero-ordem LIKE cotacao-item.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE cotacao-item.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE cotacao-item.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq-cotac LIKE cotacao-item.seq-cotac NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnumero-ordem = RowObject.numero-ordem
           pcod-emitente = RowObject.cod-emitente
           pit-codigo = RowObject.it-codigo
           pseq-cotac = RowObject.seq-cotac.

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
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "possui-reaj":U THEN ASSIGN pFieldValue = RowObject.possui-reaj.
        WHEN "reaj-tabela":U THEN ASSIGN pFieldValue = RowObject.reaj-tabela.
        WHEN "reajusta-cotacao":U THEN ASSIGN pFieldValue = RowObject.reajusta-cotacao.
        WHEN "taxa-financ":U THEN ASSIGN pFieldValue = RowObject.taxa-financ.
        WHEN "codigo-ipi":U THEN ASSIGN pFieldValue = RowObject.codigo-ipi.
        WHEN "cot-aprovada":U THEN ASSIGN pFieldValue = RowObject.cot-aprovada.
        WHEN "frete":U THEN ASSIGN pFieldValue = RowObject.frete.
        WHEN "ind-ret-cotacao":U THEN ASSIGN pFieldValue = RowObject.ind-ret-cotacao.
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
  Purpose:     Reposiciona registro com base no ­ndice COTACAO
  Parameters:
               recebe valor dos campos do ­ndice COTACAO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnumero-ordem LIKE cotacao-item.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE cotacao-item.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE cotacao-item.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pseq-cotac LIKE cotacao-item.seq-cotac NO-UNDO.

    FIND FIRST bfcotacao-item WHERE
        bfcotacao-item.numero-ordem = pnumero-ordem AND
        bfcotacao-item.cod-emitente = pcod-emitente AND
        bfcotacao-item.it-codigo = pit-codigo AND
        bfcotacao-item.seq-cotac = pseq-cotac
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcotacao-item THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcotacao-item)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */ 

    define input parameter i-abertura as integer no-undo.
    
    case i-abertura:
        when 1 then
            RUN openQueryStatic (input "ByCodEmitente":U).       
    end case.    
    
    RETURN "OK":U.                               

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByCodEmitente DBOProgram 
PROCEDURE openQueryByCodEmitente :
/*------------------------------------------------------------------------------
  Purpose: Busca conjunto de registros da tabela cotacao-item de acordo com a 
           situa‡Æo da ordem-compra relacionada dentro de uma faixa de data de
           cota‡Æo, numero da ordem e de c¢digo do emitente, junto com os 
           parƒmetros indicadores cota‡Æo aprovada e ordem pendente ou normal .
           Os registros sÆo ordenados pelo c¢digo do emitente.
    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 

IF NOT lDesvinc THEN DO:
    IF iLabel = 1 THEN DO:
        OPEN QUERY {&QUERYNAME}
          FOR EACH {&TableName} WHERE {&TableName}.it-codigo = cItCodigo
              AND  {&TableName}.cod-emitente <= iEmitenteFim
              AND  {&TableName}.cod-emitente >= iEmitenteIni
              AND  {&TableName}.data-cotacao <> &if "{&ems_dbtype}":u = "mss":u &then 01/01/1800 &else 11/11/1111 &endif 
              AND  {&TableName}.data-cotacao <= daDataFim
              AND  {&TableName}.data-cotacao >= daDataIni 
              AND  {&TableName}.numero-ordem <= iOrdemFim
              AND  {&TableName}.numero-ordem >= iOrdemIni
              AND  ({&TableName}.cot-aprovada = lAprovada OR lAmbos = yes)
              NO-LOCK,
          FIRST ordem-compra WHERE
                ordem-compra.numero-ordem = {&TableName}.numero-ordem
              AND (ordem-compra.situacao = 1 OR
                   ordem-compra.situacao = 3 OR 
                   ordem-compra.situacao = 5)
              NO-LOCK,
          FIRST emitente WHERE emitente.cod-emitente = cotacao-item.cod-emitente
              NO-LOCK
              &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
                 INDEXED-REPOSITION
              &endif.
    END.
    ELSE DO:
        OPEN QUERY {&QUERYNAME}
          for each {&TableName} where
                 {&TableName}.it-codigo     = cItCodigo                   AND
                 {&TableName}.cod-emitente <= iEmitenteFim                AND
                 {&TableName}.cod-emitente >= iEmitenteIni                AND
                 {&TableName}.data-cotacao  = &if "{&ems_dbtype}":u = "mss":u &then 01/01/1800 &else 11/11/1111 &endif AND
                 {&TableName}.numero-ordem <= iOrdemFim                   AND
                 {&TableName}.numero-ordem >= iOrdemIni                   AND
                ({&TableName}.cot-aprovada  = lAprovada OR lAmbos = yes)
                  NO-LOCK ,
          FIRST ordem-compra WHERE
                ordem-compra.numero-ordem = {&TableName}.numero-ordem
              AND (ordem-compra.situacao = 1 OR
                   ordem-compra.situacao = 3 OR
                   ordem-compra.situacao = 5)
              NO-LOCK,
          FIRST emitente WHERE emitente.cod-emitente = cotacao-item.cod-emitente
              NO-LOCK
              &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
                INDEXED-REPOSITION
              &endif.
    END.
END.
ELSE DO:
    IF iLabel = 1 THEN DO:
        OPEN QUERY {&QUERYNAME}
          FOR EACH {&TableName} WHERE {&TableName}.it-codigo = cItCodigo
              AND  {&TableName}.cod-emitente <= iEmitenteFim
              AND  {&TableName}.cod-emitente >= iEmitenteIni
              AND  {&TableName}.data-cotacao <> &if "{&ems_dbtype}":u = "mss":u &then 01/01/1800 &else 11/11/1111 &endif
              AND  {&TableName}.data-cotacao <= daDataFim
              AND  {&TableName}.data-cotacao >= daDataIni
              AND  {&TableName}.numero-ordem = 0
              NO-LOCK,
          FIRST ordem-compra 
              NO-LOCK,
          FIRST emitente WHERE emitente.cod-emitente = cotacao-item.cod-emitente
              NO-LOCK
              &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
                 INDEXED-REPOSITION
              &endif.
    END.
    ELSE DO:
        OPEN QUERY {&QUERYNAME}
          FOR EACH {&TableName} WHERE {&TableName}.it-codigo = cItCodigo
              AND  {&TableName}.cod-emitente <= iEmitenteFim
              AND  {&TableName}.cod-emitente >= iEmitenteIni
              AND  {&TableName}.data-cotacao = &if "{&ems_dbtype}":u = "mss":u &then 01/01/1800 &else 11/11/1111 &endif
              AND  {&TableName}.data-cotacao <= daDataFim
              AND  {&TableName}.data-cotacao >= daDataIni
              AND  {&TableName}.numero-ordem = 0
              NO-LOCK,
          FIRST ordem-compra 
              NO-LOCK,
          FIRST emitente WHERE emitente.cod-emitente = cotacao-item.cod-emitente
              NO-LOCK
              &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
                 INDEXED-REPOSITION
              &endif.  
    END.
END.

    RETURN "OK":U.                                
                                   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint1 DBOProgram 
PROCEDURE setConstraint1 :
/*------------------------------------------------------------------------------
  Purpose: Seta vari veis para openQueryByCodEmitente 
  Parameters:
              ipar1  : pcEmitenteIni : C¢digo do emitente inicial
              ipar2  : pcEmitenteFim : C¢digo do emitente final
              ipar3  : pcOrdemIni    : N£mero da ordem inicial
              ipar4  : pcOrdemFim    : N£mero da ordem final
              ipar5  : pcDataIni     : Data da cota‡Æo inicial
              ipar6  : pcDataFim     : Data da cota‡Æo final
              ipar7  : pcItCodigo    : C¢digo do Item
              ipar8  : plAmbos       : Abre a query com cota‡äes aprovadas e nÆo aprovadas  
              ipar9  : plAprovada    : Abre a query apenas com cota‡äes aprovadas ou nÆo aprovadas
              ipar10 : plLabel       : Indica se a cota‡Æo ‚ 1 - Normal ou 2 - Pendente
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */ 

    def input param pcItCodigo    as char no-undo.
    def input param pcEmitenteIni as char no-undo.
    def input param pcEmitenteFim as char no-undo.
    def input param pcOrdemIni    as char no-undo.
    def input param pcOrdemFim    as char no-undo.       
    def input param pcDataIni     as char no-undo.
    def input param pcDataFim     as char no-undo.     
    def input param plAmbos       as log  no-undo.
    def input param plAprovada    as log  no-undo.
    def input param plDesvinc     as log  no-undo.
    def input param plLabel       as int  no-undo. 

    run setConstraintCodEmitente (pcItCodigo,
                                  pcEmitenteIni,
                                  pcEmitenteFim,
                                  pcOrdemIni,
                                  pcOrdemFim,
                                  pcDataIni,
                                  pcDataFim,
                                  plAmbos,
                                  plAprovada,
                                  plDesvinc,
                                  plLabel).
   RETURN "OK":U.                               

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodEmitente DBOProgram 
PROCEDURE setConstraintCodEmitente :
/*------------------------------------------------------------------------------
  Purpose: Seta vari veis para openQueryByCodEmitente    
  Parameters: 
              ipar1  : pcEmitenteIni : C¢digo do emitente inicial
              ipar2  : pcEmitenteFim : C¢digo do emitente final
              ipar3  : pcOrdemIni    : N£mero da ordem inicial
              ipar4  : pcOrdemFim    : N£mero da ordem final
              ipar5  : pcDataIni     : Data da cota‡Æo inicial
              ipar6  : pcDataFim     : Data da cota‡Æo final
              ipar7  : pcItCodigo    : C¢digo do Item
              ipar8  : plAmbos       : Abre a query com cota‡äes aprovadas e nÆo aprovadas  
              ipar9  : plAprovada    : Abre a query apenas com cota‡äes aprovadas ou nÆo aprovadas
              ipar10 : plLabel       : Indica se a cota‡Æo ‚ 1 - Normal ou 2 - Pendente
  Notes:       
------------------------------------------------------------------------------*/
   
    def input param pcItCodigo    as char no-undo.
    def input param pcEmitenteIni as char no-undo.
    def input param pcEmitenteFim as char no-undo.
    def input param pcOrdemIni    as char no-undo.
    def input param pcOrdemFim    as char no-undo.       
    def input param pcDataIni     as char no-undo.
    def input param pcDataFim     as char no-undo.     
    def input param plAmbos       as log  no-undo.
    def input param plAprovada    as log  no-undo.
    def input param plDesvinc     as log  no-undo.
    def input param plLabel       as int  no-undo.

    assign de-ordem-fim = dec(pcordemfim).

    assign  iEmitenteIni = int(pcEmitenteIni)
            iEmitenteFim = int(pcEmitenteFim)
            iOrdemIni    = int(pcOrdemIni)
            iOrdemFim    = int(pcordemfim)
            daDataIni    = date(pcDataIni)
            daDataFim    = date(pcDataFim)
            cItCodigo    = pcItCodigo
            lAmbos       = plAmbos
            lAprovada    = plAprovada
            lDesvinc     = plDesvinc
            iLabel       = plLabel.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

