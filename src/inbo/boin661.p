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
{include/i-prgvrs.i BOIN661 2.00.00.007 } /*** "010007" 01/12/2023 10:51:02  ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin661 MUT}
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
&GLOBAL-DEFINE DBOName estab-mat
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName estab-mat
&GLOBAL-DEFINE TableLabel estab-mat
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{inbo/boin661.i RowObject}
{inbo/boin661.i tt-estab-mat-aux}
{adbo/boad107na.i tt-estabelec}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-cod-estabel LIKE estab-mat.cod-estabel NO-UNDO.
DEFINE VARIABLE c-cod-estabel-ini    LIKE estab-mat.cod-estabel   NO-UNDO.
DEFINE VARIABLE c-cod-estabel-fim    LIKE estab-mat.cod-estabel   NO-UNDO.
DEFINE VARIABLE c-cod-estabel-parent LIKE estab-mat.cod-estabel   NO-UNDO.

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
         HEIGHT             = 19.21
         WIDTH              = 46.14.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBatchRecordsCustom DBOProgram 
PROCEDURE getBatchRecordsCustom :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR tt-estab-mat-aux.
    
    FOR EACH tt-estab-mat-aux:
        DELETE tt-estab-mat-aux.
    END.  
    
    
    FOR EACH tt-estabelec:
        FIND FIRST estab-mat WHERE estab-mat.cod-estabel = tt-estabelec.cod-estabel NO-LOCK NO-ERROR.
        IF AVAIL estab-mat THEN DO:
            CREATE tt-estab-mat-aux.
            BUFFER-COPY estab-mat TO tt-estab-mat-aux.
        END.          
    END.  
    
    FOR EACH tt-estabelec:
        DELETE tt-estabelec.
    END.  
    
    
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
        WHEN "ct-ext-ipi":U THEN ASSIGN pFieldValue = RowObject.ct-ext-ipi.
        WHEN "ct-icms-comp":U THEN ASSIGN pFieldValue = RowObject.ct-icms-comp.
        WHEN "ct-icms-ft":U THEN ASSIGN pFieldValue = RowObject.ct-icms-ft.
        WHEN "ct-ipi":U THEN ASSIGN pFieldValue = RowObject.ct-ipi.
        WHEN "ct-ipi-ft":U THEN ASSIGN pFieldValue = RowObject.ct-ipi-ft.
        WHEN "ct-pis-subs":U THEN ASSIGN pFieldValue = RowObject.ct-pis-subs.
        WHEN "dep-rej-cq":U THEN ASSIGN pFieldValue = RowObject.dep-rej-cq.
        WHEN "deposito-cq":U THEN ASSIGN pFieldValue = RowObject.deposito-cq.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-estabel-prin":U THEN ASSIGN pFieldValue = RowObject.cod-estabel-prin.
        WHEN "conta-act-medio":U THEN ASSIGN pFieldValue = RowObject.conta-act-medio.
        WHEN "conta-dev-cli":U THEN ASSIGN pFieldValue = RowObject.conta-dev-cli.
        WHEN "conta-ent-benef":U THEN ASSIGN pFieldValue = RowObject.conta-ent-benef.
        WHEN "conta-ent-consig":U THEN ASSIGN pFieldValue = RowObject.conta-ent-consig.
        WHEN "conta-extorno-icms":U THEN ASSIGN pFieldValue = RowObject.conta-extorno-icms.
        WHEN "conta-extorno-ipi":U THEN ASSIGN pFieldValue = RowObject.conta-extorno-ipi.
        WHEN "conta-finsoc-subs":U THEN ASSIGN pFieldValue = RowObject.conta-finsoc-subs.
        WHEN "conta-fornec":U THEN ASSIGN pFieldValue = RowObject.conta-fornec.
        WHEN "ct-finsoc-subs":U THEN ASSIGN pFieldValue = RowObject.ct-finsoc-subs.
        WHEN "ct-icm":U THEN ASSIGN pFieldValue = RowObject.ct-icm.
        WHEN "sc-ext-icms":U THEN ASSIGN pFieldValue = RowObject.sc-ext-icms.
        WHEN "sc-ext-ipi":U THEN ASSIGN pFieldValue = RowObject.sc-ext-ipi.
        WHEN "sc-finsoc-subs":U THEN ASSIGN pFieldValue = RowObject.sc-finsoc-subs.
        WHEN "sc-icm":U THEN ASSIGN pFieldValue = RowObject.sc-icm.
        WHEN "sc-icms-comp":U THEN ASSIGN pFieldValue = RowObject.sc-icms-comp.
        WHEN "sc-icms-ft":U THEN ASSIGN pFieldValue = RowObject.sc-icms-ft.
        WHEN "sc-ipi":U THEN ASSIGN pFieldValue = RowObject.sc-ipi.
        WHEN "sc-ipi-ft":U THEN ASSIGN pFieldValue = RowObject.sc-ipi-ft.
        WHEN "sc-pis-subs":U THEN ASSIGN pFieldValue = RowObject.sc-pis-subs.
        WHEN "ult-per-fech":U THEN ASSIGN pFieldValue = RowObject.ult-per-fech.
        WHEN "conta-frete":U THEN ASSIGN pFieldValue = RowObject.conta-frete.
        WHEN "conta-icms":U THEN ASSIGN pFieldValue = RowObject.conta-icms.
        WHEN "conta-icms-comp":U THEN ASSIGN pFieldValue = RowObject.conta-icms-comp.
        WHEN "conta-icms-ft":U THEN ASSIGN pFieldValue = RowObject.conta-icms-ft.
        WHEN "conta-inven-ent":U THEN ASSIGN pFieldValue = RowObject.conta-inven-ent.
        WHEN "conta-inven-sai":U THEN ASSIGN pFieldValue = RowObject.conta-inven-sai.
        WHEN "conta-ipi":U THEN ASSIGN pFieldValue = RowObject.conta-ipi.
        WHEN "conta-ipi-fat":U THEN ASSIGN pFieldValue = RowObject.conta-ipi-fat.
        WHEN "conta-mob":U THEN ASSIGN pFieldValue = RowObject.conta-mob.
        WHEN "conta-pis-subs":U THEN ASSIGN pFieldValue = RowObject.conta-pis-subs.
        WHEN "conta-rec-fisico":U THEN ASSIGN pFieldValue = RowObject.conta-rec-fisico.
        WHEN "conta-sai-benef":U THEN ASSIGN pFieldValue = RowObject.conta-sai-benef.
        WHEN "conta-sai-consig":U THEN ASSIGN pFieldValue = RowObject.conta-sai-consig.
        WHEN "conta-transf":U THEN ASSIGN pFieldValue = RowObject.conta-transf.
        WHEN "ct-ext-icms":U THEN ASSIGN pFieldValue = RowObject.ct-ext-icms.
        WHEN "cod-cta-transf-unif":U THEN ASSIGN pFieldValue = RowObject.cod-cta-transf-unif.
        WHEN "cod-ccusto-transf-unif":U THEN ASSIGN pFieldValue = RowObject.cod-ccusto-transf-unif.
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
        WHEN "mensal-ate":U THEN ASSIGN pFieldValue = RowObject.mensal-ate.
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "sumar-ate":U THEN ASSIGN pFieldValue = RowObject.sumar-ate.
        WHEN "ult-fech-dia":U THEN ASSIGN pFieldValue = RowObject.ult-fech-dia.
        WHEN "contab-ate":U THEN ASSIGN pFieldValue = RowObject.contab-ate.
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
        WHEN "perc-acum-a":U THEN ASSIGN pFieldValue = RowObject.perc-acum-a.
        WHEN "perc-acum-b":U THEN ASSIGN pFieldValue = RowObject.perc-acum-b.
        WHEN "perc-acum-c":U THEN ASSIGN pFieldValue = RowObject.perc-acum-c.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dias-min-c":U THEN ASSIGN pFieldValue = RowObject.dias-min-c.
        WHEN "fase-medio":U THEN ASSIGN pFieldValue = RowObject.fase-medio.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-ord-per":U THEN ASSIGN pFieldValue = RowObject.nr-ord-per.
        WHEN "num-dec":U THEN ASSIGN pFieldValue = RowObject.num-dec.
        WHEN "custo-contab":U THEN ASSIGN pFieldValue = RowObject.custo-contab.
        WHEN "dias-max-a":U THEN ASSIGN pFieldValue = RowObject.dias-max-a.
        WHEN "dias-max-b":U THEN ASSIGN pFieldValue = RowObject.dias-max-b.
        WHEN "dias-max-c":U THEN ASSIGN pFieldValue = RowObject.dias-max-c.
        WHEN "dias-min-a":U THEN ASSIGN pFieldValue = RowObject.dias-min-a.
        WHEN "dias-min-b":U THEN ASSIGN pFieldValue = RowObject.dias-min-b.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "tipo-pr-med":U THEN ASSIGN pFieldValue = RowObject.tipo-pr-med.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ESTABELECIMENTO
  Parameters:
               retorna valor dos campos do °ndice ESTABELECIMENTO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE estab-mat.cod-estabel NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel.

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
        WHEN "fec-ja-ini":U THEN ASSIGN pFieldValue = RowObject.fec-ja-ini.
        WHEN "gera-act":U THEN ASSIGN pFieldValue = RowObject.gera-act.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "pm-ja-ini":U THEN ASSIGN pFieldValue = RowObject.pm-ja-ini.
        WHEN "acerto-aut":U THEN ASSIGN pFieldValue = RowObject.acerto-aut.
        WHEN "usa-on-line":U THEN ASSIGN pFieldValue = RowObject.usa-on-line.
        WHEN "usa-padrao":U THEN ASSIGN pFieldValue = RowObject.usa-padrao.
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
  Purpose:     Reposiciona registro com base no °ndice ESTABELECIMENTO
  Parameters:
               recebe valor dos campos do °ndice ESTABELECIMENTO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE estab-mat.cod-estabel NO-UNDO.

    FIND FIRST bfestab-mat WHERE
        bfestab-mat.cod-estabel = pcod-estabel
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfestab-mat THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfestab-mat)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodEstabel DBOProgram 
PROCEDURE openQueryCodEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH estab-mat NO-LOCK 
        WHERE estab-mat.cod-estabel >= c-cod-estabel-ini
        AND   estab-mat.cod-estabel <= c-cod-estabel-fim INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFormation DBOProgram 
PROCEDURE openQueryFormation :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH estab-mat NO-LOCK 
        WHERE estab-mat.cod-estabel <> c-cod-estabel-parent INDEXED-REPOSITION.

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
    OPEN QUERY {&QueryName} FOR EACH estab-mat NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recebe-tt-estabelec DBOProgram 
PROCEDURE recebe-tt-estabelec :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-estabelec.
    
 
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodEstabel DBOProgram 
PROCEDURE setConstraintCodEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-cod-estabel-ini LIKE estab-mat.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel-fim LIKE estab-mat.cod-estabel  NO-UNDO.

    ASSIGN c-cod-estabel-ini = p-cod-estabel-ini
           c-cod-estabel-fim = p-cod-estabel-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFormation DBOProgram 
PROCEDURE setConstraintFormation :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-cod-estabel    LIKE RowObject.cod-estabel  NO-UNDO.

    ASSIGN c-cod-estabel-parent = p-cod-estabel.

    RETURN "OK":U.
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

