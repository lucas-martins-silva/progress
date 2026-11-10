&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/
{include/i-prgvrs.i BOAD355 2.00.00.015 } /*** "010015" 20/10/2023 10:44:29  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad355 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : dbo.p
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
&GLOBAL-DEFINE DBOName              BOAD355
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName            integr-mec-modul-funcao
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName            qr{&TableName} 


/*--- Include com defini»’o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com 
      extens’o .i ---*/
{adbo/boad355.i RowObject}


/*--- Include com defini»’o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera»’o da defini»’o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»’o 
      manual da query ---*/
{method/dboqry.i}

/*--- Include utilizada para a conexao do ems 5---*/
{utp/ut-glob.i}
{cdp/cd1202.i5}
{btb/btb009za.i} 

{include/i_dbvers.i}

/*Tratamento de Miniflexibiliza‡Æo*/
{cdp/cdcfgfin.i}

/*--- Defini»’o de buffer que serÿ utilizado pelo m²todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.


define temp-table tt-param no-undo
    field seq       as INTEGER format "9"
    field funcao    as char    format "x(25)".

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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        &IF "{&mguni_version}" >= "2.07A" &THEN
            WHEN "cod-empresa":U THEN ASSIGN pFieldValue = RowObject.cod-empresa.
        &ENDIF
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-estab":U THEN ASSIGN pFieldValue = RowObject.cod-estab.
        WHEN "cod-modul-integr":U THEN ASSIGN pFieldValue = RowObject.cod-modul-integr.
        WHEN "cod-produt-modul":U THEN ASSIGN pFieldValue = RowObject.cod-produt-modul.
        WHEN "ind-funcao-integr":U THEN ASSIGN pFieldValue = RowObject.ind-funcao-integr.
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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
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
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        &IF "{&mguni_version}" < "2.07A" &THEN
            WHEN "cod-empresa":U THEN ASSIGN pFieldValue = RowObject.cod-empresa.
        &ENDIF
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
  Purpose:     Retorna valores dos campos do ­ndice codigo
  Parameters:  
               retorna valor do campo cod-modul-integr
               retorna valor do campo ind-funcao-integr
               retorna valor do campo cod-empresa
               retorna valor do campo cod-estab
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-modul-integr LIKE integr-mec-modul-funcao.cod-modul-integr NO-UNDO.
    DEFINE OUTPUT PARAMETER pind-funcao-integr LIKE integr-mec-modul-funcao.ind-funcao-integr NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-empresa LIKE integr-mec-modul-funcao.cod-empresa NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estab LIKE integr-mec-modul-funcao.cod-estab NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-modul-integr = RowObject.cod-modul-integr
           pind-funcao-integr = RowObject.ind-funcao-integr
           pcod-empresa = RowObject.cod-empresa
           pcod-estab = RowObject.cod-estab.

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
  Purpose:     Reposiciona registro com base no ­ndice codigo
  Parameters:  
               recebe valor do campo cod-modul-integr
               recebe valor do campo ind-funcao-integr
               recebe valor do campo cod-empresa
               recebe valor do campo cod-estab
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-modul-integr LIKE integr-mec-modul-funcao.cod-modul-integr NO-UNDO.
    DEFINE INPUT PARAMETER pind-funcao-integr LIKE integr-mec-modul-funcao.ind-funcao-integr NO-UNDO.
    DEFINE INPUT PARAMETER pcod-empresa LIKE integr-mec-modul-funcao.cod-empresa NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estab LIKE integr-mec-modul-funcao.cod-estab NO-UNDO.

    FIND FIRST bfintegr-mec-modul-funcao WHERE 
        bfintegr-mec-modul-funcao.cod-modul-integr = pcod-modul-integr AND 
        bfintegr-mec-modul-funcao.ind-funcao-integr = pind-funcao-integr AND 
        bfintegr-mec-modul-funcao.cod-empresa = pcod-empresa AND 
        bfintegr-mec-modul-funcao.cod-estab = pcod-estab NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfintegr-mec-modul-funcao THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfintegr-mec-modul-funcao)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryMain DBOProgram 
PROCEDURE OpenQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-tabela DBOProgram 
PROCEDURE pi-atualiza-tabela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-pagar      as logical no-undo.
    def input param p-receber    as logical no-undo.
    def input param p-tesouraria as logical no-undo.
    def input param p-pagar-ems5 as logical no-undo.
    def input param p-receber-ems5 as logical no-undo.
    DEF OUTPUT PARAM TABLE FOR tt_erros_conexao.

    assign cQueryUseded = "Main".

    for each RowObject exclusive-lock:
        delete RowObject.
    end.

    /*** CONTAS A PAGAR ***/
    if p-pagar = yes then do:
         find first integr-mec-modul-funcao exclusive-lock
         where integr-mec-modul-funcao.cod-modul-integr  = "MEC"               and
               integr-mec-modul-funcao.ind-funcao-integr = "Integra_Cta_Pagar" and
               &IF "{&mguni_version}" >= "2.07A" &THEN
               integr-mec-modul-funcao.cod-empresa       = ""                  and
               &ELSE
               integr-mec-modul-funcao.cod-empresa       = 0                   and
               &ENDIF
               integr-mec-modul-funcao.cod-estab         = ""                  no-error.
         if not avail integr-mec-modul-funcao then do:
            Create RowObject.
            Assign RowObject.cod-modul-integr  = "MEC"
                   &IF "{&mguni_version}" >= "2.07A" &THEN
                   RowObject.cod-empresa       = ""
                   &ELSE
                   RowObject.cod-empresa       = 0
                   &ENDIF
                   RowObject.cod-estab         = ""
                   RowObject.cod-produt-modul  = "EMS 2"
                   RowObject.ind-funcao-integr = "Integra_Cta_Pagar".
            run CreateRecord in this-procedure.
         end.
         else
             assign integr-mec-modul-funcao.cod-produt-modul  = "EMS 2".
    end.
    else do:
         find first integr-mec-modul-funcao exclusive-lock
         where integr-mec-modul-funcao.cod-modul-integr  = "MEC"               and
               integr-mec-modul-funcao.ind-funcao-integr = "Integra_Cta_Pagar" and
               &IF "{&mguni_version}" >= "2.07A" &THEN
               integr-mec-modul-funcao.cod-empresa       = ""                  and
               &ELSE
               integr-mec-modul-funcao.cod-empresa       = 0                   and
               &ENDIF
               integr-mec-modul-funcao.cod-estab         = ""                  and
               integr-mec-modul-funcao.cod-produt-modul  = "EMS 2"             no-error.
         if avail integr-mec-modul-funcao then
            delete integr-mec-modul-funcao.
    end.
    
    for each RowObject exclusive-lock:
        delete RowObject.
    end.

    /*** CONTAS A RECEBER ***/
    if p-receber = yes then do:
         find first integr-mec-modul-funcao exclusive-lock
         where integr-mec-modul-funcao.cod-modul-integr  = "MEC"                 and
               integr-mec-modul-funcao.ind-funcao-integr = "Integra_Cta_Receber" and
               &IF "{&mguni_version}" >= "2.07A" &THEN
               integr-mec-modul-funcao.cod-empresa       = ""                    and
               &ELSE
               integr-mec-modul-funcao.cod-empresa       = 0                     and
               &ENDIF
               integr-mec-modul-funcao.cod-estab         = ""                    no-error.
         if not avail integr-mec-modul-funcao then do:
            Create RowObject.
            Assign RowObject.cod-modul-integr  = "MEC"
                   &IF "{&mguni_version}" >= "2.07A" &THEN
                   RowObject.cod-empresa       = ""
                   &ELSE
                   RowObject.cod-empresa       = 0
                   &ENDIF
                   RowObject.cod-estab         = ""
                   RowObject.cod-produt-modul  = "EMS 2"
                   RowObject.ind-funcao-integr = "Integra_Cta_Receber".
            run CreateRecord in this-procedure.
         end.
         else
             assign integr-mec-modul-funcao.cod-produt-modul  = "EMS 2".

    end.
    else do:
         find first integr-mec-modul-funcao exclusive-lock
         where integr-mec-modul-funcao.cod-modul-integr  = "MEC"                 and
               integr-mec-modul-funcao.ind-funcao-integr = "Integra_Cta_Receber" and
               &IF "{&mguni_version}" >= "2.07A" &THEN
               integr-mec-modul-funcao.cod-empresa       = ""                    and
               &ELSE
               integr-mec-modul-funcao.cod-empresa       = 0                     and
               &ENDIF
               integr-mec-modul-funcao.cod-estab         = ""                    and
               integr-mec-modul-funcao.cod-produt-modul  = "EMS 2"               no-error.
         if avail integr-mec-modul-funcao then
            delete integr-mec-modul-funcao.
    end.

    for each RowObject exclusive-lock:
        delete RowObject.
    end.

    /*** TESOURARIA ***/
    if p-tesouraria = yes then do:
         find first integr-mec-modul-funcao no-lock
         where integr-mec-modul-funcao.cod-modul-integr  = "MEC"               and
               integr-mec-modul-funcao.ind-funcao-integr = "Aplica_Empre"      and
               &IF "{&mguni_version}" >= "2.07A" &THEN
               integr-mec-modul-funcao.cod-empresa       = ""                  and
               &ELSE
               integr-mec-modul-funcao.cod-empresa       = 0                   and
               &ENDIF
               integr-mec-modul-funcao.cod-estab         = ""                  and
               integr-mec-modul-funcao.cod-produt-modul  = "EMS 5"             no-error.
         if not avail integr-mec-modul-funcao then do:
            Create RowObject.
            Assign RowObject.cod-modul-integr  = "MEC"
                   &IF "{&mguni_version}" >= "2.07A" &THEN
                   RowObject.cod-empresa       = ""
                   &ELSE
                   RowObject.cod-empresa       = 0
                   &ENDIF
                   RowObject.cod-estab         = ""
                   RowObject.cod-produt-modul  = "EMS 5"
                   RowObject.ind-funcao-integr = "Aplica_Empre".
            run CreateRecord in this-procedure.
        end.
    end.
    else do:
         find first integr-mec-modul-funcao exclusive-lock
         where integr-mec-modul-funcao.cod-modul-integr  = "MEC"               and
               integr-mec-modul-funcao.ind-funcao-integr = "Aplica_Empre"      and
               &IF "{&mguni_version}" >= "2.07A" &THEN
               integr-mec-modul-funcao.cod-empresa       = ""                  and
               &ELSE
               integr-mec-modul-funcao.cod-empresa       = 0                   and
               &ENDIF
               integr-mec-modul-funcao.cod-estab         = ""                  and
               integr-mec-modul-funcao.cod-produt-modul  = "EMS 5"             no-error.
         if avail integr-mec-modul-funcao then
            delete integr-mec-modul-funcao.
    end.
    
    for each RowObject exclusive-lock:
        delete RowObject.
    end.

    /*** CONTAS A PAGAR EMS5 ***/
    if p-pagar-ems5 = yes then do:
         find first integr-mec-modul-funcao exclusive-lock
         where integr-mec-modul-funcao.cod-modul-integr  = "MEC"               and
               integr-mec-modul-funcao.ind-funcao-integr = "Integra_Cta_Pagar" and
               &IF "{&mguni_version}" >= "2.07A" &THEN
               integr-mec-modul-funcao.cod-empresa       = ""                  and
               &ELSE
               integr-mec-modul-funcao.cod-empresa       = 0                   and
               &ENDIF
               integr-mec-modul-funcao.cod-estab         = ""                  no-error.
         if not avail integr-mec-modul-funcao then do:
            Create RowObject.
            Assign RowObject.cod-modul-integr  = "MEC"
                   &IF "{&mguni_version}" >= "2.07A" &THEN
                   RowObject.cod-empresa       = ""
                   &ELSE
                   RowObject.cod-empresa       = 0
                   &ENDIF
                   RowObject.cod-estab         = ""
                   RowObject.cod-produt-modul  = "EMS 5"
                   RowObject.ind-funcao-integr = "Integra_Cta_Pagar".
            run CreateRecord in this-procedure.
         end.
         else
             assign integr-mec-modul-funcao.cod-produt-modul  = "EMS 5".
    end.
    else do:
         find first integr-mec-modul-funcao exclusive-lock
         where integr-mec-modul-funcao.cod-modul-integr  = "MEC"               and
               integr-mec-modul-funcao.ind-funcao-integr = "Integra_Cta_Pagar" and
               &IF "{&mguni_version}" >= "2.07A" &THEN
               integr-mec-modul-funcao.cod-empresa       = ""                  and
               &ELSE
               integr-mec-modul-funcao.cod-empresa       = 0                   and
               &ENDIF
               integr-mec-modul-funcao.cod-estab         = ""                  and
               integr-mec-modul-funcao.cod-produt-modul  = "EMS 5"             no-error.
         if avail integr-mec-modul-funcao then
            delete integr-mec-modul-funcao.
    end.
    
    for each RowObject exclusive-lock:
        delete RowObject.
    end.

    /*** CONTAS A RECEBER EMS5 ***/
    if p-receber-ems5 = yes then do:
         find first integr-mec-modul-funcao exclusive-lock
         where integr-mec-modul-funcao.cod-modul-integr  = "MEC"                 and
               integr-mec-modul-funcao.ind-funcao-integr = "Integra_Cta_Receber" and
               &IF "{&mguni_version}" >= "2.07A" &THEN
               integr-mec-modul-funcao.cod-empresa       = ""                  and
               &ELSE
               integr-mec-modul-funcao.cod-empresa       = 0                   and
               &ENDIF
               integr-mec-modul-funcao.cod-estab         = ""                    no-error.
         if not avail integr-mec-modul-funcao then do:
            Create RowObject.
            Assign RowObject.cod-modul-integr  = "MEC"
                   &IF "{&mguni_version}" >= "2.07A" &THEN
                   RowObject.cod-empresa       = ""
                   &ELSE
                   RowObject.cod-empresa       = 0
                   &ENDIF
                   RowObject.cod-estab         = ""
                   RowObject.cod-produt-modul  = "EMS 5"
                   RowObject.ind-funcao-integr = "Integra_Cta_Receber".
            run CreateRecord in this-procedure.
         end.
         else
             assign integr-mec-modul-funcao.cod-produt-modul  = "EMS 5".
    end.
    else do:
         find first integr-mec-modul-funcao exclusive-lock
         where integr-mec-modul-funcao.cod-modul-integr  = "MEC"                 and
               integr-mec-modul-funcao.ind-funcao-integr = "Integra_Cta_Receber" and
               &IF "{&mguni_version}" >= "2.07A" &THEN
               integr-mec-modul-funcao.cod-empresa       = ""                    and
               &ELSE
               integr-mec-modul-funcao.cod-empresa       = 0                     and
               &ENDIF
               integr-mec-modul-funcao.cod-estab         = ""                    and
               integr-mec-modul-funcao.cod-produt-modul  = "EMS 5"               no-error.
         if avail integr-mec-modul-funcao then
            delete integr-mec-modul-funcao.
    end.

    /* Fun‡äes especiais Cƒmbio Ems2 x Ems5 */
    IF p-receber-ems5 THEN DO:
        RUN pi-cadastra-funcao(INPUT "EMS 5").
    END.
    
    IF p-receber THEN DO:
        RUN pi-cadastra-funcao(INPUT "EMS 2").
    END.

    IF p-receber = NO AND p-receber-ems5 = NO THEN DO:
        RUN pi-cadastra-funcao(INPUT "Nenhum").
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-param DBOProgram 
PROCEDURE pi-busca-param :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param p-pagar        as logical no-undo.
    def output param p-receber      as logical no-undo.
    def output param p-tesouraria   as logical no-undo.
    def output param p-pagar-ems5   as logical no-undo.
    def output param p-receber-ems5 as logical no-undo.

    assign p-pagar        = no
           p-receber      = no
           p-tesouraria   = no
           p-pagar-ems5   = no
           p-receber-ems5 = no.

    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN

        assign p-pagar        = no
               p-receber      = no
               p-tesouraria   = yes
               p-pagar-ems5   = yes
               p-receber-ems5 = yes.

    &ELSE

        for each integr-mec-modul-funcao no-lock:
            if integr-mec-modul-funcao.ind-funcao-integr = "Integra_Cta_Pagar" and
               &IF "{&mguni_version}" >= "2.07A" &THEN
               integr-mec-modul-funcao.cod-empresa       = ""                  and
               &ELSE
               integr-mec-modul-funcao.cod-empresa       = 0                   and
               &ENDIF
               integr-mec-modul-funcao.cod-estab         = ""                  and
               integr-mec-modul-funcao.cod-produt-modul  = "EMS 2"             then
                assign p-pagar = yes.

            if integr-mec-modul-funcao.ind-funcao-integr = "Integra_Cta_Receber" and
               &IF "{&mguni_version}" >= "2.07A" &THEN
               integr-mec-modul-funcao.cod-empresa       = ""                  and
               &ELSE
               integr-mec-modul-funcao.cod-empresa       = 0                   and
               &ENDIF
               integr-mec-modul-funcao.cod-estab         = ""                    and
               integr-mec-modul-funcao.cod-produt-modul  = "EMS 2"               then
                assign p-receber = yes.

            if integr-mec-modul-funcao.ind-funcao-integr = "Aplica_Empre" and
               &IF "{&mguni_version}" >= "2.07A" &THEN
               integr-mec-modul-funcao.cod-empresa       = ""                  and
               &ELSE
               integr-mec-modul-funcao.cod-empresa       = 0                   and
               &ENDIF
               integr-mec-modul-funcao.cod-estab         = ""             and
               integr-mec-modul-funcao.cod-produt-modul  = "EMS 5"        then
                assign p-tesouraria = yes.

            if integr-mec-modul-funcao.ind-funcao-integr = "Integra_Cta_Pagar" and
               &IF "{&mguni_version}" >= "2.07A" &THEN
               integr-mec-modul-funcao.cod-empresa       = ""                  and
               &ELSE
               integr-mec-modul-funcao.cod-empresa       = 0                   and
               &ENDIF
               integr-mec-modul-funcao.cod-estab         = ""                  and
               integr-mec-modul-funcao.cod-produt-modul  = "EMS 5"             then
                assign p-pagar-ems5 = yes.

            if integr-mec-modul-funcao.ind-funcao-integr = "Integra_Cta_Receber" and
               &IF "{&mguni_version}" >= "2.07A" &THEN
               integr-mec-modul-funcao.cod-empresa       = ""                  and
               &ELSE
               integr-mec-modul-funcao.cod-empresa       = 0                   and
               &ENDIF
               integr-mec-modul-funcao.cod-estab         = ""                    and
               integr-mec-modul-funcao.cod-produt-modul  = "EMS 5"               then
                assign p-receber-ems5 = yes.

        end.

    &ENDIF

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cadastra-funcao DBOProgram 
PROCEDURE pi-cadastra-funcao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-comando    AS CHAR NO-UNDO.

&IF "{&mguni_version}" >= "2.07A" &THEN
DEF VAR i-ep-codigo LIKE empresa.ep-codigo NO-UNDO.
&ELSE
DEF VAR i-ep-codigo AS INTEGER NO-UNDO.
&ENDIF
DEF VAR i-seq-erro AS INTEGER NO-UNDO.

/* Cadastro das fun‡äes especiais no Ems5 */
{method/svc/autentic/autentic.i
     &vUserEnterprise="i-ep-codigo"}

{cdp/cd1202.i3 i-ep-codigo}
if l-conec-bas = yes and l-conec-fin = yes and l-conec-uni = yes  then do:
   IF p-comando = "Ems 5" THEN DO: /* Ativar */
       run prgint/ufn/ufn906zb.p (INPUT "Ems 5").
   END.
   IF p-comando = "Ems 2" THEN DO: /* Desativar */
       run prgint/ufn/ufn906zb.p (INPUT "Ems 2").
   END.
   IF p-comando = "Nenhum" THEN DO: /* Desativar - Geral */
       run prgint/ufn/ufn906zb.p (INPUT "Nenhum").
   END.

   {cdp/cd1202.i4 i-ep-codigo}
END.
ELSE DO:
   RETURN "NOK":U.
END.

/* Cadastro das fun‡äes especiais no Ems2 */
&if "{&mgadm_version}":U < "2.05":U &then
  
    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
        EMPTY TEMP-TABLE tt-param NO-ERROR.
    &ELSE
        FOR EACH tt-param:
            DELETE tt-param.
        END.
    &ENDIF

    CREATE tt-param.
    ASSIGN tt-param.seq    = 1
           tt-param.funcao = "int-mec-ems5":U. 
    
    CREATE tt-param.
    ASSIGN tt-param.seq    = 2
           tt-param.funcao = "mec-fase-II":U. 
    
    CREATE tt-param.
    ASSIGN tt-param.seq    = 3
           tt-param.funcao = "juro-liq-ace":U. 
    
    CREATE tt-param.
    ASSIGN tt-param.seq    = 4
           tt-param.funcao = "faixa-moeda":U. 
    
    CREATE tt-param.
    ASSIGN tt-param.seq    = 5
           tt-param.funcao = "ord-comp-ant":U. 
    
    CREATE tt-param.
    ASSIGN tt-param.seq    = 6
           tt-param.funcao = "nro-proc-exp":U. 
    
    CREATE tt-param.
    ASSIGN tt-param.seq    = 7
           tt-param.funcao = "pre-pagto":U. 
    
    CREATE tt-param.
    ASSIGN tt-param.seq    = 8
           tt-param.funcao = "liq-processo":U. 

    IF  p-comando = "EMS 5" THEN DO: /* ativar */
        FOR EACH tt-param NO-LOCK:
            find first funcao
                 where funcao.cd-funcao = "spp-" + trim(tt-param.funcao) exclusive-lock no-error.
            if not avail funcao then do:
               create funcao.
               assign funcao.cd-funcao = "spp-" + trim(tt-param.funcao)
                      funcao.descricao = funcao.cd-funcao
                      funcao.log-1     = FALSE
                      funcao.ativo     = yes.
            end.
        END.

        find first funcao
             where funcao.cd-funcao = "spp-" + "substituicao":U exclusive-lock no-error.
        if not avail funcao then do:
           create funcao.
           assign funcao.cd-funcao = "spp-" + "substituicao":U
                  funcao.descricao = funcao.cd-funcao
                  funcao.log-1     = FALSE
                  funcao.ativo     = yes.
        end.
    END.

    IF  p-comando = "EMS 2" THEN DO: /* Desativar, exceto a fun‡Æo spp-substituicao */
        FOR EACH tt-param NO-LOCK:
            find first funcao
                 where funcao.cd-funcao = "spp-" + trim(tt-param.funcao) exclusive-lock no-error.
            if avail funcao then do:
               DELETE funcao.
            end.
        END.
        
        find first funcao
             where funcao.cd-funcao = "spp-" + "substituicao":U exclusive-lock no-error.
        if not avail funcao then do:
           create funcao.
           assign funcao.cd-funcao = "spp-" + "substituicao":U
                  funcao.descricao = funcao.cd-funcao
                  funcao.log-1     = FALSE
                  funcao.ativo     = yes.
        end.
    END.

    IF p-comando = "Nenhum" THEN DO:
        FOR EACH tt-param NO-LOCK:
            find first funcao
                 where funcao.cd-funcao = "spp-" + trim(tt-param.funcao) exclusive-lock no-error.
            if avail funcao then do:
               DELETE funcao.
            end.
        END.
        
        find first funcao
             where funcao.cd-funcao = "spp-" + "substituicao":U exclusive-lock no-error.
        if avail funcao then do:
           DELETE funcao.
        end.
    END.
&endif 

&if "{&mgadm_version}":U = "2.05":U &then

    IF  p-comando = "EMS 5" THEN DO: /* Ativar */
        find first funcao
             where funcao.cd-funcao = "spp-" + "liq-processo":U exclusive-lock no-error.
        if not avail funcao then do:
            create funcao.
            assign funcao.cd-funcao = "spp-" + "liq-processo":U
                   funcao.descricao = funcao.cd-funcao
                   funcao.log-1     = FALSE
                   funcao.ativo     = yes.
        end.
        
        find first funcao
             where funcao.cd-funcao = "spp-" + "pre-pagto":U exclusive-lock no-error.
        if not avail funcao then do:
            create funcao.
            assign funcao.cd-funcao = "spp-" + "pre-pagto":U
                   funcao.descricao = funcao.cd-funcao
                   funcao.log-1     = FALSE
                   funcao.ativo     = yes.
        end.
    END.

    IF  p-comando = "EMS 2" THEN DO: /* Desativar, exceto a fun‡Æo spp-liq-processo */
        
        find first funcao
             where funcao.cd-funcao = "spp-" + "pre-pagto":U exclusive-lock no-error.
        if avail funcao then do:
           DELETE funcao.
        end.
        
        find first funcao
             where funcao.cd-funcao = "spp-" + "liq-processo":U exclusive-lock no-error.
        if not avail funcao then do:
            create funcao.
            assign funcao.cd-funcao = "spp-" + "liq-processo":U
                   funcao.descricao = funcao.cd-funcao
                   funcao.log-1     = FALSE
                   funcao.ativo     = yes.
        end.
    END.

    IF p-comando = "Nenhum" THEN DO:
        find first funcao
             where funcao.cd-funcao = "spp-" + "liq-processo":U exclusive-lock no-error.
        if avail funcao then do:
           DELETE funcao.
        end.
        
        find first funcao
             where funcao.cd-funcao = "spp-" + "pre-pagto":U exclusive-lock no-error.
        if avail funcao then do:
           DELETE funcao.
        end.
    END.
&endif 

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verificar-produto DBOProgram 
PROCEDURE pi-verificar-produto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param v-pagar      as char no-undo.
    def output param v-receber    as char no-undo.

    assign v-pagar   = ""
           v-receber = "".

    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN

        assign v-pagar   = "EMS 5"
               v-receber = "EMS 5".

    &ELSE

        for each integr-mec-modul-funcao no-lock:
            if integr-mec-modul-funcao.ind-funcao-integr = "Integra_Cta_Pagar" and
               &IF "{&mguni_version}" >= "2.07A" &THEN
               integr-mec-modul-funcao.cod-empresa       = ""                  and
               &ELSE
               integr-mec-modul-funcao.cod-empresa       = 0                   and
               &ENDIF
               integr-mec-modul-funcao.cod-estab         = ""                  and
               integr-mec-modul-funcao.cod-produt-modul  = "EMS 2"             then
                assign v-pagar = "EMS 2".
        
            if integr-mec-modul-funcao.ind-funcao-integr = "Integra_Cta_Receber" and
               &IF "{&mguni_version}" >= "2.07A" &THEN
               integr-mec-modul-funcao.cod-empresa       = ""                  and
               &ELSE
               integr-mec-modul-funcao.cod-empresa       = 0                   and
               &ENDIF
               integr-mec-modul-funcao.cod-estab         = ""                    and
               integr-mec-modul-funcao.cod-produt-modul  = "EMS 2"               then
                assign v-receber = "EMS 2".
        
            if integr-mec-modul-funcao.ind-funcao-integr = "Integra_Cta_Pagar" and
               &IF "{&mguni_version}" >= "2.07A" &THEN
               integr-mec-modul-funcao.cod-empresa       = ""                  and
               &ELSE
               integr-mec-modul-funcao.cod-empresa       = 0                   and
               &ENDIF
               integr-mec-modul-funcao.cod-estab         = ""                  and
               integr-mec-modul-funcao.cod-produt-modul  = "EMS 5"             then
                assign v-pagar = "EMS 5".
        
            if integr-mec-modul-funcao.ind-funcao-integr = "Integra_Cta_Receber" and
               &IF "{&mguni_version}" >= "2.07A" &THEN
               integr-mec-modul-funcao.cod-empresa       = ""                  and
               &ELSE
               integr-mec-modul-funcao.cod-empresa       = 0                   and
               &ENDIF
               integr-mec-modul-funcao.cod-estab         = ""                    and
               integr-mec-modul-funcao.cod-produt-modul  = "EMS 5"               then
                assign v-receber = "EMS 5".
    
        end.

    &ENDIF

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintMain DBOProgram 
PROCEDURE SetConstraintMain :
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
  Purpose:     Valida»„es pertinentes ao DBO
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
    
    /*--- Verifica ocorr¼ncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

