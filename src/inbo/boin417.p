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
{include/i-prgvrs.i BOIN417 2.00.00.022 } /*** "010022" 19/11/2024 16:57:46 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin417 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName tab-unidade
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName tab-unidade
&GLOBAL-DEFINE TableLabel tab-unidade
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/
{inbo/boin417.i RowObject}

DEFINE TEMP-TABLE tt-un-medida NO-UNDO LIKE tab-unidade.
      
DEFINE TEMP-TABLE tt-unidade NO-UNDO LIKE tab-unidade
       field fator-conver like item-fornec.fator-conver
       field num-casa-dec like item-fornec.num-casa-dec
       field r-rowid as rowid.

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
{method/dboqry.i}

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m²todo Receive Message) */
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

{cdp/cdcfgman.i} /* Definicao de pre-processadores Manufatura */

/******************************ATENCAO*************************************
 Pre-processador abaixo responsavel por distinguir o produto que
 esta executando o componente ( Magnus ou EMS ). 
 Se estiver definida a variavel bf-mat-comex 
 ( &if defined(bf-mat-comex) &then ), significa que o produto
 chamador e o Magnus se nÆo, EMS. Utilizado pelo produto Comercio Exterior
**************************************************************************/ 
{cdp/cdcfgmat.i} /* Definicao de pre-processadores - Magnus ou EMS */

/* Variaveis necessarias aos setConstraint's */
   
   def var c-unid_medida as char no-undo.
   def var c-un-ini      as char no-undo.
   def var c-un-fim      as char no-undo.
   def var c-desc-ini    as char no-undo.
   def var c-desc-fim    as char no-undo.

{inbo/boin417.i1} /* procedure findCodigo - utilizada pelos produtos EMS e Magnus */

    
DEFINE TEMP-TABLE RowErrorsFrotas no-undo
    field ErrorSequence as integer
    field ErrorNumber   as integer
    field ErrorDescription as char
    field ErrorParameters as char
    field ErrorType       as char
    field Errorhelp       as char
    field Errorsubtype    as char.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

DEFINE VARIABLE lIntCRM11     AS LOGICAL NO-UNDO INITIAL FALSE.
RUN utp/ut-crm11.p (OUTPUT lIntCRM11).


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
         HEIGHT             = 19.08
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


FUNCTION fn-has-row-errors RETURNS LOGICAL ():

    FOR EACH RowErrors 
        WHERE UPPER(RowErrors.ErrorType) = 'INTERNAL':U:
        DELETE RowErrors. 
    END.

    RETURN CAN-FIND(FIRST RowErrors 
        WHERE UPPER(RowErrors.ErrorSubType) = 'ERROR':U).
    
END FUNCTION. 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &IF "{&bf_mat_versao_ems}":U >= "2.08":U &THEN
        IF program-name(3) MATCHES("*axrma006*") THEN
            ASSIGN tab-unidade.log-orig-ext = YES.
    &ELSE 
        &IF "{&bf_mat_versao_ems}":U >= "2.062":U &THEN
            IF program-name(3) MATCHES("*axrma006*") THEN 
               ASSIGN OVERLAY(tab-unidade.char-1,2,1) = "S":U
                      tab-unidade.log-1 = YES.

        &ENDIF
    &ENDIF
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &IF "{&bf_mat_versao_ems}":U >= "2.08":U &THEN
        IF program-name(3) MATCHES("*axrma006*") THEN
            ASSIGN tab-unidade.log-orig-ext = YES.
    &ELSE 
        &IF "{&bf_mat_versao_ems}":U >= "2.062":U &THEN
            IF program-name(3) MATCHES("*axrma006*") THEN 
               ASSIGN OVERLAY(tab-unidade.char-1,2,1) = "S":U
                      tab-unidade.log-1 = YES.
        &ENDIF
    &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
       RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTUnidadeItemFornec DBOProgram 
PROCEDURE carregaTTUnidadeItemFornec :
/*------------------------------------------------------------------------------
  Purpose:     Carrega temp-table com unidades cadastradas na rela‡Æo 
               Item X Fornecedor e Item X Fornecedor X Unidade Medida
  Parameters:  recebe item, fornecedor e numero da p gina do Zoom
               retorna tt-unidade com as unidades dos relacionamentos
                       mencionados acima.
  Notes:
------------------------------------------------------------------------------*/
    def input param pc-item like item.it-codigo no-undo.
    def input param pi-emitente like emitente.cod-emitente no-undo.
    def input param pi-page-number as int no-undo.
    def output param table for tt-unidade.

    def var iRowsReturned as int no-undo.

    empty temp-table RowObject.
    if pi-page-number = 1 then 
        RUN openQueryStatic (input "ByFiltroUnMedida":U).
    else
        RUN openQueryStatic (input "ByFiltroDescricao":U).


    RUN getBatchRecords (INPUT ?,
                         INPUT NO,
                         INPUT ?,
                         OUTPUT iRowsReturned,
                         OUTPUT TABLE RowObject).
    empty temp-table tt-unidade.
    for each RowObject:
        find first item where item.it-codigo = pc-item no-lock no-error.
        if avail item and item.tipo-contr = 4 then do:
            create tt-unidade.
            buffer-copy RowObject to tt-unidade no-error.
            find first tab-conv-un where tab-conv-un.un = RowObject.un no-lock no-error.
            if avail tab-conv-un then
                assign tt-unidade.fator-conver = tab-conv-un.fator-conver 
                       tt-unidade.num-casa-dec = tab-conv-un.num-casa-dec.
        end.
        else do:
            find first item-fornec
                 where item-fornec.it-codigo    = pc-item 
                   and item-fornec.cod-emitente = pi-emitente
                   and item-fornec.unid-med-for = RowObject.un no-lock no-error.
            if avail item-fornec then do:
                create tt-unidade.
                buffer-copy RowObject to tt-unidade no-error.
                assign tt-unidade.fator-conver = item-fornec.fator-conver 
                       tt-unidade.num-casa-dec = item-fornec.num-casa-dec.
            end.
    
            find first item-fornec-umd
                 where item-fornec-umd.it-codigo    = pc-item 
                   and item-fornec-umd.cod-emitente = pi-emitente
                   and item-fornec-umd.unid-med-for = RowObject.un no-lock no-error.
            if avail item-fornec-umd then do:
                create tt-unidade.
                buffer-copy RowObject to tt-unidade no-error.
                assign tt-unidade.fator-conver = item-fornec-umd.fator-conver 
                       tt-unidade.num-casa-dec = item-fornec-umd.num-casa-dec.
            end.
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
  Parameters:  recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        &if defined(bf-mat-comex) &then            
            when "u-char-1":U THEN ASSIGN pFieldValue = RowObject.u-char-1.                
        &else         
            WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
            WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        &endif
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

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        &if defined(bf-mat-comex) &then            
        &else    
            WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
            WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        &endif
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

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        &if defined(bf-mat-comex) &then            
        &else            
            WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        &endif
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

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/

    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.
    
    CASE pFieldName:
        &if defined (bf_man_per_ppm) &then
            WHEN "dimensao":u then assign pFieldValue = RowObject.dimensao.
        &endif 
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        &if defined(bf-mat-comex) &then            
        &else            
            WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        &endif
        OTHERWISE RETURN "NOK":U.
    END CASE.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice CODIGO
  Parameters:
               retorna valor dos campos do ¡ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then            
    &else    
        DEFINE OUTPUT PARAMETER pun LIKE tab-unidade.un NO-UNDO.
    
        /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
              retornada flag "NOK":U ---*/
        IF NOT AVAILABLE RowObject THEN
           RETURN "NOK":U.
    
        ASSIGN pun = RowObject.un.
    
        RETURN "OK":U.
    &endif
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

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        &if defined(bf-mat-comex) &then            
        &else            
            WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        &endif
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
    &if defined(bf-mat-comex) &then            
    &else    
        DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
        DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.
    
        /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
              retornada flag "NOK":U ---*/
        IF NOT AVAILABLE RowObject THEN
            RETURN "NOK":U.
    
        CASE pFieldName:
            OTHERWISE RETURN "NOK":U.
        END CASE.
    
        RETURN "OK":U.
    &endif        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice CODIGO
  Parameters:
               recebe valor dos campos do ¡ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pun LIKE tab-unidade.un NO-UNDO.

    FIND FIRST bftab-unidade WHERE
        bftab-unidade.un = pun
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bftab-unidade THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bftab-unidade)).
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
              RUN openQueryStatic (input "Main":U). 
              
           when 2 then
              RUN openQueryStatic (input "UnMedida":U).
           
           when 3 then
              RUN openQueryStatic (input "ByFiltroUnMedida":U).
           
       end case.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByFiltroDescricao DBOProgram 
PROCEDURE openQueryByFiltroDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&QUERYNAME} for each {&TABLENAME} where {&TABLENAME}.descricao >= c-desc-ini and
                                                        {&TABLENAME}.descricao <= c-desc-fim
                                                        NO-LOCK BY {&TABLENAME}.un INDEXED-REPOSITION.
                                      
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByFiltroUnMedida DBOProgram 
PROCEDURE openQueryByFiltroUnMedida :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela tab-unidade,
              dentro de uma faixa de unidade de medida inicial e final.
              Ordena por unidade de medida. 
  -----------------------------------------------------------------------------*/
  open query {&QUERYNAME} for each {&TABLENAME} where {&TABLENAME}.un >= c-un-ini and
                                                      {&TABLENAME}.un <= c-un-fim
                                                      NO-LOCK BY {&TABLENAME}.un INDEXED-REPOSITION.
                                      
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
    OPEN QUERY {&QueryName} FOR EACH tab-unidade NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryUnMedida DBOProgram 
PROCEDURE openQueryUnMedida :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela tab-unidade,
              dentro de uma faixa de unidade de medida.
    
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where {&TABLENAME}.un >= c-unid_medida 
                                                         NO-LOCK INDEXED-REPOSITION.
                                      
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-exclusao-eai DBOProgram 
PROCEDURE pi-valida-exclusao-eai :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param c-un like tab-unidade.un no-undo.

find first item where item.un = c-un no-lock no-error.
if avail item then
    return "nok":u.

return "ok":u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo 
              a unidade de medida. 
  Parameters: ipar: p-unid_medida: Unidade Medida
    
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter p-unid_medida  as char no-undo.
       
    run setConstraintUnMedida (p-unid_medida).
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint3 DBOProgram 
PROCEDURE setConstraint3 :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo
              a unidade de medida inicial e final. 
  Parameters: ipar1:p-un-ini:Unid Medida Inicial
              ipar2:p-un-fim:Unid Medida Final
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter p-un-ini as char no-undo.
    def input parameter p-un-fim as char no-undo.

       
    run setConstraintFiltroUnMedida (p-un-ini,
                                     p-un-fim).
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroDescricao DBOProgram 
PROCEDURE setConstraintFiltroDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param p-desc-ini as char no-undo.
def input param p-desc-fim as char no-undo.

    assign c-desc-ini = p-desc-ini
           c-desc-fim = p-desc-fim.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroUnMedida DBOProgram 
PROCEDURE setConstraintFiltroUnMedida :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo
              a unidade de medida inicial e final. 
  Parameters: ipar1:p-un-ini:Unid Medida Inicial
              ipar2:p-un-fim:Unid Medida Final
------------------------------------------------------------------------------*/
   def input parameter p-un-ini as char no-undo.
   def input parameter p-un-fim as char no-undo.
   
     assign c-un-ini = p-un-ini
            c-un-fim = p-un-fim.

   
   
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintUnMedida DBOProgram 
PROCEDURE setConstraintUnMedida :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo 
              a unidade de medida. 
  Parameters: ipar: p-unid_medida: Unidade Medida
------------------------------------------------------------------------------*/
    def input parameter p-unid_medida  as char no-undo.
    
      assign c-unid_medida = p-unid_medida.
           
                               
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDeleteFrotas DBOProgram 
PROCEDURE validateDeleteFrotas :
    /*------------------------------------------------------------------------------
      Purpose: Valida as tabelas de Frotas    
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/

    define variable h-abapi008 as handle  no-undo.
    define variable iErro      as integer no-undo.
    define variable lValida    as logical no-undo.
    define variable i-cont     as integer no-undo.

    assign lValida = no.
    do i-cont = 1 to 5:
        if i-cont <> 3
        and i-cont <> 4 then do:
            run cdp/cd9902.p (input i-cont).
            if return-value = "OK":U then do:
                assign lValida = yes.
                leave.
            end.
        end.
    end.
    if lValida then do:
        /** Passa o rowid para API de Frotas **/
        run abp/abapi008.p persistent set h-abapi008 (input RowObject.r-rowid).
        /** Valida‡äes de Frotas **/
        run validateUnidade in h-abapi008 (INPUT RowObject.un).
        if return-value = "NOK":U then do:
            for each RowErrorsFrotas exclusive-lock:
                delete RowErrorsFrotas.
            end.
            /** Busca os erros ocorridos em frotas **/
            run getRowErrors in h-abapi008 (output table RowErrorsFrotas).
            assign iErro = 0.
            /** Se ocorreram erros noproduto padrÆo, busca a £ltima sequˆncia **/
            for last RowErrors no-lock:
                assign iErro = RowErrors.ErrorSequence.
            end.
            /** Percorre os erros ocorridos em frotas **/
            for each RowErrorsFrotas no-lock:
                /** Cria os erros no produto padrÆo **/
                create RowErrors.
                buffer-copy RowErrorsFrotas except ErrorSequence to RowErrors
                    assign RowErrors.ErrorSequence = iErro + 1
                           iErro                   = RowErrors.ErrorSequence.
            end.
            for each RowErrorsFrotas exclusive-lock:
                delete RowErrorsFrotas.
            end.
        end.
        /** Elimina a API da mem¢ria **/
        if valid-handle(h-abapi008) then
            delete procedure h-abapi008.
    end.

    IF fn-has-row-errors() THEN
       RETURN "NOK":U. 

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-eliminacao DBOProgram 
PROCEDURE pi-valida-eliminacao:
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
                      
    {database/tgin/tdp/tdin417.i01}
    
    IF length(c-relacionados) > 0 THEN DO:
          {method/svc/errors/inserr.i
                    &ErrorNumber="17" 
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-table-label + '~~~~' + c-relacionados"}          
    END.  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDeleteUN DBOProgram 
PROCEDURE validateIntegration :

    IF CAN-FIND (FIRST funcao 
         WHERE funcao.cd-funcao = "spp-integra-ems-his"
         AND   funcao.ativo     = YES) THEN DO:
             
         IF RowObject.log-orig-ext EQ TRUE THEN DO:
               {method/svc/errors/inserr.i
                        &ErrorNumber="57932"
                        &ErrorType="EMS"}  
                        
                IF fn-has-row-errors() THEN
                   RETURN "NOK":U.                         
         END.
                        
    END.
    
    DEFINE VARIABLE hIntegra AS HANDLE      NO-UNDO.
    
    IF CONNECTED('mgscm') THEN DO: 
        RUN wmp/wmprx067.p PERSISTENT SET hIntegra.
        
        RUN eliminaUnidMed IN hIntegra(INPUT RowObject.un,
                                        OUTPUT TABLE RowErrors APPEND).
                                        
        DELETE PROCEDURE hIntegra NO-ERROR. 
        
        IF fn-has-row-errors() THEN
           RETURN "NOK":U.        
    END.  
    
    DEFINE VARIABLE h-cd0203-crm AS HANDLE      NO-UNDO.
    
    IF lIntCRM11 EQ TRUE THEN DO:
    
        RUN integracoes/adapters/emstocrm/cd0203-crm.p PERSISTENT SET h-cd0203-crm.        
        RUN deleteFromCRM IN h-cd0203-crm (INPUT tab-unidade.un,
                                      OUTPUT TABLE RowErrors APPEND).
                                      
        DELETE PROCEDURE h-cd0203-crm NO-ERROR.                                      

        IF fn-has-row-errors() THEN
           RETURN "NOK":U.
        
    END.
    
    &IF DEFINED (bf_man_204) &THEN 
      /* Execucao caso usuario possua integracao EAI */
      
        CREATE tt-un-medida.
        BUFFER-COPY RowObject TO tt-un-medida.

        RUN adapters/xml/ma2/axsma002.p (INPUT "del",
                                             INPUT "CD0203.W",
                                             INPUT c-prg-vrs,
                                             INPUT TABLE tt-un-medida,
                                             OUTPUT TABLE RowErrors APPEND).  
        DELETE tt-un-medida.
            
        IF fn-has-row-errors() THEN
           RETURN "NOK":U.

    &ENDIF    

    /*--- Verifica ocorrˆncia de erros ---*/
    IF fn-has-row-errors() THEN
       undo, RETURN "NOK":U.

    RETURN "OK":U.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piIntegracao V-table-Win 
PROCEDURE piIntegracao :
/* -----------------------------------------------------------
  Purpose: Api para integra»„es    
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE h-ut-integration AS HANDLE      NO-UNDO.

    RUN utp/ut-integration.p PERSISTENT SET h-ut-integration.
    RUN eai-integration IN h-ut-integration (INPUT "UnitOfMeasure",    /* Nome da transa»’o     */
                                             INPUT ROWID(RowObject),   /* Registro da transa»’o */
                                             INPUT pType,              /* Evento da transa»’o   */
                                             OUTPUT TABLE RowErrors APPEND).  /* Erros da transa»’o    */
    DELETE PROCEDURE h-ut-integration NO-ERROR.

    /*--- Verifica ocorrˆncia de erros ---*/
    IF fn-has-row-errors() THEN
       RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/
 
        DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
        /*--- Utilize o par³metro pType para identificar quais as valida‡„es a serem
              executadas ---*/
        /*--- Os valores poss¡veis para o par³metro sÆo: Create, Delete e Update ---*/
        /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do
              include: method/svc/errors/inserr.i ---*/
        /*--- Inclua aqui as valida‡„es ---*/
        
        IF pType = "DELETE":U THEN DO:
            RUN pi-valida-eliminacao IN THIS-PROCEDURE.
    
            IF fn-has-row-errors() THEN       
               RETURN "NOK":U.                            
            
            RUN validateIntegration IN THIS-PROCEDURE.
            
            IF fn-has-row-errors() THEN
               RETURN "NOK":U.
               
            RUN validateDeleteFrotas IN THIS-PROCEDURE.
            
            IF fn-has-row-errors() THEN
               RETURN "NOK":U.            
        END.

        IF pType = "CREATE":U THEN DO:
                
           IF CAN-FIND(FIRST tab-unidade NO-LOCK
                       WHERE tab-unidade.un = RowObject.un) THEN DO:
              /* Inicio -- Projeto Internacional */
              {utp/ut-table.i mgind tab-unidade 1} 
              {method/svc/errors/inserr.i
                        &ErrorNumber="8" 
                        &ErrorType="EMS"
                        &ErrorParameters=TRIM(RETURN-VALUE)}
           END.
           
           IF LENGTH(TRIM(RowObject.un)) >= 3 THEN DO:
              {method/svc/errors/inserr.i
                       &ErrorNumber="57904"
                       &ErrorType="EMS"
                       &ErrorParameters=LENGTH(TRIM(RowObject.un))} 
           END.
                      
        END.
        
        IF pType = "CREATE" OR pType = "UPDATE" THEN DO:
            
            IF RowObject.un = ""  THEN DO:
                 {utp/ut-field.i mgind tab-unidade un 1}
                {method/svc/errors/inserr.i
                         &ErrorNumber="5793"
                         &ErrorType="EMS"
                         &ErrorParameters=TRIM(RETURN-VALUE)}
            END.
            
            IF RowObject.descricao = ""  THEN DO:
                {utp/ut-field.i mgind tab-unidade descricao 1}
                {method/svc/errors/inserr.i
                         &ErrorNumber="5793"
                         &ErrorType="EMS"
                         &ErrorParameters=TRIM(RETURN-VALUE)}
            END.
                       
            IF NOT CAN-DO('1,2,3,4,5', STRING(RowObject.dimensao)) THEN DO:
               {method/svc/errors/inserr.i
                        &ErrorNumber="57903"
                        &ErrorType="EMS"
                        &ErrorParameters="RowObject.dimensao"}   
            END.

        END.
                
        IF pType = "UPDATE" THEN DO:
        
           IF NOT CAN-FIND (FIRST tab-unidade NO-LOCK
                            WHERE tab-unidade.un = RowObject.un) THEN DO:

              {method/svc/errors/inserr.i
                        &ErrorNumber="2"
                        &ErrorType="EMS"
                        &ErrorParameters="RowObject.un"}
           END.
           
        END. 
        
        RUN piIntegracao IN THIS-PROCEDURE (INPUT pType).
        
        /*--- Verifica ocorrˆncia de erros ---*/
        IF fn-has-row-errors() THEN
           RETURN "NOK":U.
    
        RETURN "OK":U.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

