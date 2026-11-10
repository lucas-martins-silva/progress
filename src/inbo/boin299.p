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
{include/i-prgvrs.i BOIN299 2.00.00.009 } /*** "010009" 27/10/2023 17:03:45  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"

&THEN
{include/i-license-manager.i BOIN299 MUT}
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
&GLOBAL-DEFINE DBOName periodo
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName periodo
&GLOBAL-DEFINE TableLabel periodo
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE KeyField1 ano /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE KeyField2 cd-tipo /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE KeyField3 nr-periodo /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES


/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/
{inbo/boin299.i RowObject}
{java/boRest.i}

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Vari veis necess rias aos setConstraint's */

  define variable c-inicial as character no-undo. 
  define variable c-final   as character no-undo.
  define variable c-cd-tipo as character no-undo.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE canFindPeriodo DBOProgram 
PROCEDURE canFindPeriodo :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se existe per¡odo com a sele‡Æo enviada
  Parameters:  i - tipo per¡odo, i - ano inicial, i - ano final
               i - per¡odo inicial, i - per¡odo final
  Notes:       
------------------------------------------------------------------------------*/
    def input param pcd-tipo  as int no-undo.
    def input param p-ano-ini as int no-undo.
    def input param p-ano-fim as int no-undo.
    def input param p-per-ini as int no-undo.
    def input param p-per-fim as int no-undo.

    find first periodo use-index codigo
        where  periodo.cd-tipo     = pcd-tipo
        and  ((periodo.ano         > p-ano-ini
        and    periodo.ano         < p-ano-fim)
         or   (periodo.ano         = p-ano-ini
        and    periodo.ano         = p-ano-fim
        and    periodo.nr-periodo >= p-per-ini
        and    periodo.nr-periodo <= p-per-fim)
         or   (periodo.ano         = p-ano-ini
        and    periodo.ano         < p-ano-fim
        and    periodo.nr-periodo >= p-per-ini)
         or   (periodo.ano         > p-ano-ini
        and    periodo.ano         = p-ano-fim
        and    periodo.nr-periodo <= p-per-fim))
        no-lock no-error.
    if avail periodo then
         return "OK":U.
    else return "NOK":U.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findAno DBOProgram 
PROCEDURE findAno :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo ¡ndice, caso nÆo ache, retorna
                mensagem de erro padrÆo do  EMS
  Parameters: ipar1:i-cd-tipo: Tipo Per¡odo
              ipar2:i-ano: Ano
              ipar3:i-nr-periodo: Per¡odo
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter i-ano as inte no-undo.
    def input parameter i-cd-tipo as inte no-undo.
    def input parameter i-nr-periodo as inte no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToKey (input i-ano,
                 input i-cd-tipo,
                 input i-nr-periodo).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo nÆo acha o registro */
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCh_termino DBOProgram 
PROCEDURE findCh_termino :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo ¡ndice, caso nÆo ache, retorna
                mensagem de erro padrÆo do  EMS
  Parameters: ipar1:i-cd-tipo: Tipo Per¡odo
              ipar2:da-dt-termino: Data T‚rmino
              
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter i-cd-tipo as inte no-undo.
    def input parameter da-dt-termino as date no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToCh_termino (input i-cd-tipo,
                        input da-dt-termino).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo nÆo acha o registro */
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCodigo DBOProgram 
PROCEDURE findCodigo :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo ¡ndice, caso nÆo ache, retorna
                mensagem de erro padrÆo do  EMS
  Parameters: ipar1:i-cd-tipo: Tipo Per¡odo
              ipar2:i-ano: Ano
              ipar3:i-nr-periodo: Per¡odo
       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter i-cd-tipo as inte no-undo.
    def input parameter i-ano as inte no-undo.
    def input parameter i-nr-periodo as inte no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToKey (input i-ano,
                 input i-cd-tipo,
                 input i-nr-periodo).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo nÆo acha o registro */
    end.

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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
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
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-inicio":U THEN ASSIGN pFieldValue = RowObject.dt-inicio.
        WHEN "dt-termino":U THEN ASSIGN pFieldValue = RowObject.dt-termino.
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
        WHEN "nr-periodo":U THEN ASSIGN pFieldValue = RowObject.nr-periodo.
        WHEN "ano":U THEN ASSIGN pFieldValue = RowObject.ano.
        WHEN "cd-tipo":U THEN ASSIGN pFieldValue = RowObject.cd-tipo.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice ANO
  Parameters:
               retorna valor dos campos do ¡ndice ANO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pano LIKE periodo.ano NO-UNDO.
    DEFINE OUTPUT PARAMETER pcd-tipo LIKE periodo.cd-tipo NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-periodo LIKE periodo.nr-periodo NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pano = RowObject.ano.
    ASSIGN pcd-tipo = RowObject.cd-tipo.
    ASSIGN pnr-periodo = RowObject.nr-periodo.

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

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
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
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToCh_termino DBOProgram 
PROCEDURE goToCh_termino :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo ¡ndice, caso nÆo ache, retorna
                mensagem de erro padrÆo do  EMS
  Parameters: ipar1:pcd-tipo: Tipo Per¡odo
              ipar2:pdt-termino: Data T‚rmino
------------------------------------------------------------------------------*/
    def input parameter pcd-tipo as inte no-undo.
    def input parameter pdt-termino as date no-undo.

    FIND FIRST bfperiodo WHERE
        bfperiodo.cd-tipo    = pcd-tipo AND
        bfperiodo.dt-termino = pdt-termino
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfperiodo THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfperiodo)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToInicio DBOProgram 
PROCEDURE goToInicio :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no Tipo e na Data de In¡cio
  Parameters:  recebe valor do Tipo do Per¡odo e da Data de In¡cio
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcd-tipo   LIKE periodo.cd-tipo   NO-UNDO.
    DEFINE INPUT PARAMETER pdt-inicio LIKE periodo.dt-inicio NO-UNDO.

    find bfperiodo use-index codigo 
         where bfperiodo.cd-tipo    = pcd-tipo
           and bfperiodo.dt-inicio  = pdt-inicio NO-LOCK no-error.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfperiodo THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfperiodo)).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToInicioMaior DBOProgram 
PROCEDURE goToInicioMaior :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no tipo e na data de in¡cio
  Parameters:  recebe valor dos tipo e data de inicio
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcd-tipo   LIKE periodo.cd-tipo   NO-UNDO.
    DEFINE INPUT PARAMETER pdt-inicio LIKE periodo.dt-inicio NO-UNDO.

    find first bfperiodo
         where bfperiodo.cd-tipo    = pcd-tipo
           and bfperiodo.dt-inicio >= pdt-inicio NO-LOCK no-error.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfperiodo THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfperiodo)).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToIniFim DBOProgram 
PROCEDURE goToIniFim :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice CODIGO
  Parameters:  recebe valor dos campos do ¡ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcd-tipo LIKE periodo.cd-tipo    NO-UNDO.
    DEFINE INPUT PARAMETER pda-ini  LIKE periodo.dt-inicio  NO-UNDO.
    DEFINE INPUT PARAMETER pda-fim  LIKE periodo.dt-termino NO-UNDO.

    find bfperiodo use-index codigo 
         where bfperiodo.cd-tipo    =  pcd-tipo and 
               bfperiodo.dt-inicio  <  pda-ini  and
               bfperiodo.dt-termino >= pda-fim  NO-LOCK no-error.
               
    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfperiodo THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfperiodo)).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice ANO
  Parameters:
               recebe valor dos campos do ¡ndice ANO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pano LIKE periodo.ano NO-UNDO.
    DEFINE INPUT PARAMETER pcd-tipo LIKE periodo.cd-tipo NO-UNDO.
    DEFINE INPUT PARAMETER pnr-periodo LIKE periodo.nr-periodo NO-UNDO.

    FIND FIRST bfperiodo WHERE
        bfperiodo.ano = pano AND
        bfperiodo.cd-tipo = pcd-tipo AND
        bfperiodo.nr-periodo = pnr-periodo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfperiodo THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfperiodo)).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyLast DBOProgram 
PROCEDURE goToKeyLast :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona no £ltimo registro pela chave
  Parameters:  recebe valor dos campos do ¡ndice
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pano LIKE periodo.ano NO-UNDO.
    DEFINE INPUT PARAMETER pcd-tipo LIKE periodo.cd-tipo NO-UNDO.
    DEFINE INPUT PARAMETER pnr-periodo LIKE periodo.nr-periodo NO-UNDO.

    FIND LAST bfperiodo WHERE
        bfperiodo.ano        = pano AND
        bfperiodo.cd-tipo    = pcd-tipo AND
        bfperiodo.nr-periodo = pnr-periodo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfperiodo THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfperiodo)).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToPeriodo DBOProgram 
PROCEDURE goToPeriodo :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no Tipo e numa Data de per¡odo
  Parameters:  recebe valor do Tipo do Per¡odo e da Data do per¡odo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcd-tipo    LIKE periodo.cd-tipo   NO-UNDO.
    DEFINE INPUT PARAMETER pdt-periodo LIKE periodo.dt-inicio NO-UNDO.

    find bfperiodo use-index codigo 
         where bfperiodo.cd-tipo    = pcd-tipo
           and bfperiodo.dt-inicio  <= pdt-periodo 
           AND bfperiodo.dt-termino >= pdt-periodo NO-LOCK no-error.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfperiodo THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfperiodo)).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToTermino DBOProgram 
PROCEDURE goToTermino :
/*------------------------------------------------------------------------------
  Purpose:     procura o registro utilizando o tipo do per¡odo e 
               com a data de termino maior ou igual a data informada
  Parameters:  tipo do per¡odo e data referˆncia
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter pcd-tipo as inte no-undo.
    def input parameter pdt-termino as date no-undo.

    find first bfperiodo use-index ch-termino
         where bfperiodo.cd-tipo     = pcd-tipo
           and bfperiodo.dt-termino >= pdt-termino no-lock no-error.
         
    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfperiodo THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfperiodo)).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VerificaInicioPeriodo DBOProgram 
PROCEDURE VerificaInicioPeriodo :
/*------------------------------------------------------------------------------
  Purpose:     procura o registro utilizando o tipo do per¡odo e 
               com a data de incio igual a data informada
  Parameters:  tipo do per¡odo e data referˆncia
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter pcd-tipo    as inte no-undo.
    def input parameter pdt-termino as date no-undo.

    find LAST  bfperiodo
         where bfperiodo.cd-tipo   = pcd-tipo
           and bfperiodo.dt-inicio = pdt-termino no-lock no-error.
         
    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfperiodo THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfperiodo)).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToTipoIniFim DBOProgram 
PROCEDURE goToTipoIniFim :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona o registro com base no Tipo do Per¡odo, com a Data de In¡cio (menor ou igual 
               a informada) e com a Data de Termino (maior ou igual a informada).
  Parameters:  Recebe o Tipo do Per¡odo, a Data de In¡cio e a Data de T‚rmino
               Retorna status do processo
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pcd-tipo    LIKE periodo.cd-tipo    NO-UNDO.
    DEFINE INPUT PARAMETER pdt-inicio  LIKE periodo.dt-inicio  NO-UNDO.
    DEFINE INPUT PARAMETER pdt-termino LIKE periodo.dt-termino NO-UNDO.

    FIND FIRST bfperiodo WHERE
        bfperiodo.cd-tipo     = pcd-tipo   AND
        bfperiodo.dt-inicio  <= pdt-inicio AND
        bfperiodo.dt-termino >= pdt-termino
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfperiodo THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfperiodo)).

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
              RUN openQueryStatic (input "FiltroData":U).
           
           when 3 then
              RUN openQueryStatic (input "FiltroCdTipo":U).
           
       end case.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroCdTipo DBOProgram 
PROCEDURE openQueryFiltroCdTipo :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela periodo considerando 
              uma faixa de tipo de per¡odo inicial e final. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  open query {&QUERYNAME} for each {&TABLENAME} where {&TABLENAME}.cd-tipo >= integer(c-inicial) AND
                                                      {&TABLENAME}.cd-tipo <= integer(c-final) 
                                                       NO-LOCK INDEXED-REPOSITION.
                                          
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroData DBOProgram 
PROCEDURE openQueryFiltroData :
/*------------------------------------------------------------------------------
  Purpose:  Busca conjunto de registros da tabela periodo considerando
            o tipo de per¡odo e uma faixa de data de in¡cio e data de t‚rmino. 
  
------------------------------------------------------------------------------*/
open query {&QUERYNAME} for each {&TABLENAME} where {&TABLENAME}.cd-tipo = integer(c-cd-tipo) AND
                                                        {&TABLENAME}.dt-inicio  >= date(c-inicial) and 
                                                        {&TABLENAME}.dt-termino <= date(c-final)
                                                         NO-LOCK INDEXED-REPOSITION.
                                          
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

    OPEN QUERY {&QueryName} FOR EACH periodo NO-LOCK INDEXED-REPOSITION.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processaDatas DBOProgram 
PROCEDURE processaDatas :
/*------------------------------------------------------------------------------
  Purpose:  /*Este procedimento tem por finalidade processar a faixa de datas e de per¡odos de acordo
            com o que for informado. Caso seja informado as datas inicial e final, entÆo este procedimento
            retornar  os per¡odos (inicial e final). Caso sejam informados os per¡odos (inicial e final)
            entÆo este retornar  as datas (inicial e final).
            Coment rio Importante: O per¡odo prevalece sobre a data.*/
  Parameters: recebe: tipo per¡odo, ano inicial, per¡odo inicial, 
                      ano final, per¡odo final, data inicial, data final
              devolve: data inicial, data final, per¡odo inicial, per¡odo final
  Notes:       
------------------------------------------------------------------------------*/

define input  parameter p-cd-tipo     as character no-undo.
define input  parameter p-ano-ini     as character no-undo.
define input  parameter p-periodo-ini as character no-undo.
define input  parameter p-ano-fim     as character no-undo.
define input  parameter p-periodo-fim as character no-undo.
define input  parameter p-data-ini    as character no-undo.
define input  parameter p-data-fim    as character no-undo.

define output parameter r-data-ini    as character no-undo.
define output parameter r-data-fim    as character no-undo.
define output parameter r-periodo-ini as character no-undo.
define output parameter r-periodo-fim as character no-undo.
define output parameter table for RowErrors.

for each RowErrors:
    delete RowErrors.
end.

    if  p-periodo-ini <> ? or p-periodo-ini <> "" and
        p-periodo-fim <> ? or p-periodo-fim <> "" and
        p-ano-ini     <> ? or p-ano-ini     <> "" and
        p-ano-fim     <> ? or p-ano-fim     <> "" then do:

        find {&TABLENAME} where {&TABLENAME}.cd-tipo    = integer (p-cd-tipo)     and
                                 {&TABLENAME}.ano        = integer (p-ano-ini)     and
                                 {&TABLENAME}.nr-periodo = integer (p-periodo-ini) no-lock no-error.
        if  avail {&TABLENAME} then
            assign r-data-ini = string({&TABLENAME}.dt-inicio).

        find {&TABLENAME} where {&TABLENAME}.cd-tipo    = integer (p-cd-tipo)     and
                                 {&TABLENAME}.ano        = integer (p-ano-fim)     and
                                 {&TABLENAME}.nr-periodo = integer (p-periodo-fim) no-lock no-error.
        if  avail {&TABLENAME} then
            assign r-data-fim = string({&TABLENAME}.dt-termino).
    end.
    else do:
       find first {&TABLENAME} where {&TABLENAME}.cd-tipo    = integer (p-cd-tipo) and
                                     {&TABLENAME}.dt-inicio >= date(p-data-ini)    no-lock no-error.
       if  avail {&TABLENAME} then do:
           assign r-periodo-ini = string({&TABLENAME}.nr-periodo,"999") + string({&TABLENAME}.ano,"9999")
                  r-data-ini    = string({&TABLENAME}.dt-inicio).
       end.
       else do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-periodo AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Per¡odo" *}
            ASSIGN c-lbl-liter-periodo = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
             &ErrorNumber="56"
             &ErrorType="EMS"
             &ErrorParameters="c-lbl-liter-periodo"}
             leave.
       end.
       find first {&TABLENAME} where {&TABLENAME}.cd-tipo     = integer (p-cd-tipo) and
                                     {&TABLENAME}.dt-termino >= date(p-data-fim)    no-lock no-error.
       if  avail {&TABLENAME} then do:
           assign r-periodo-fim = string({&TABLENAME}.nr-periodo,"999") + string({&TABLENAME}.ano,"9999")
                  r-data-fim    = string({&TABLENAME}.dt-termino).
       end.
       else do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-periodo-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Per¡odo" *}
            ASSIGN c-lbl-liter-periodo-2 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
             &ErrorNumber="56"
             &ErrorType="EMS"
             &ErrorParameters="c-lbl-liter-periodo-2"}  
             leave.
       end.
   end.
   
   RETURN "OK":U.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint1 DBOProgram 
PROCEDURE setConstraint1 :
/*------------------------------------------------------------------------------
  Purpose:     Seta as vari veis de controle para queries contendo o 
               tipo de per¡odo inicial e final.
  Parameters:  ipar1:p-inicial:Per¡odo Inicial
               ipar2:p-final:Per¡odo Final
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    define input parameter p-inicial      as character.
    define input parameter p-final        as character.
    
    run setConstraintFiltroCdTipo (p-inicial,
                                   p-final).
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:     Seta as vari veis de controle para queries contendo o 
               data inicial e final e o tipo de per¡odo.
  Parameters:  ipar1:p-inicial:Data Inicial
               ipar2:p-final:  Data Final
               ipar3:p-cd-tipo:Tipo Per¡odo
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
   def input parameter p-inicial      as char.
   def input parameter p-final        as char.
   def input parameter p-cd-tipo      as char.
    
    run setConstraintFiltroData (p-inicial,
                                 p-final,
                                 p-cd-tipo).
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroCdTipo DBOProgram 
PROCEDURE setConstraintFiltroCdTipo :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo o 
               tipo de per¡odo inicial e final.
  Parameters:  ipar1:p-inicial:Per¡odo Inicial
               ipar2:p-final:Per¡odo Final
------------------------------------------------------------------------------*/
   define input parameter p-inicial      as character.
   define input parameter p-final        as character.

   assign c-inicial      = p-inicial.
   assign c-final        = p-final.
   
   RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroData DBOProgram 
PROCEDURE setConstraintFiltroData :
/*------------------------------------------------------------------------------
  Purpose:     Seta as vari veis de controle para queries contendo o 
               data inicial e final e o tipo de per¡odo.
  Parameters:  ipar1:p-inicial:Data Inicial
               ipar2:p-final:  Data Final
               ipar3:p-cd-tipo:Tipo Per¡odo
------------------------------------------------------------------------------*/
   def input parameter p-inicial      as char.
   def input parameter p-final        as char.
   def input parameter p-cd-tipo      as char.

     assign c-inicial      = p-inicial.
     assign c-final        = p-final.
     assign c-cd-tipo      = p-cd-tipo.
   
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram 
PROCEDURE openQueryDefault :
/*:T------------------------------------------------------------------------------
  Purpose: Procedure obrigat¢ria para execu‡Æo via MetaDados
  Parameters:  <none>
  Notes: Para execu‡Æo do DBO via Metadados ‚ necess rio que o DBO utilize a Procedure openQueryDefault para abrir a query principal do DBO.
         Esta Procedure pode ser customizada conforme necessidade do usu rio.
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.

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

    /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

