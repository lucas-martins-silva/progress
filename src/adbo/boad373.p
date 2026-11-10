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
{include/i-prgvrs.i BOAD373 2.00.00.004} /*** "010004" 20/10/2023 10:44:30  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad373 MUT}
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
&GLOBAL-DEFINE DBOName            BOAD373
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName          mov-titcr-port-liq-mec
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName          qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{adbo/boad373.i RowObject}

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
        &IF "{&mguni_version}" >= "2.07A" &THEN	
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "cod-docto":U THEN ASSIGN pFieldValue = RowObject.cod-docto.
        WHEN "cod-estabel-ref":U THEN ASSIGN pFieldValue = RowObject.cod-estabel-ref.
        WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        WHEN "nr-docto-banco":U THEN ASSIGN pFieldValue = RowObject.nr-docto-banco.
        WHEN "nr-docto-dest":U THEN ASSIGN pFieldValue = RowObject.nr-docto-dest.
        WHEN "nr-docto-emp":U THEN ASSIGN pFieldValue = RowObject.nr-docto-emp.
        WHEN "referencia":U THEN ASSIGN pFieldValue = RowObject.referencia.
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
        WHEN "dt-contrato":U THEN ASSIGN pFieldValue = RowObject.dt-contrato.
        WHEN "dt-movto":U THEN ASSIGN pFieldValue = RowObject.dt-movto.
        WHEN "dt-referencia":U THEN ASSIGN pFieldValue = RowObject.dt-referencia.
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
        WHEN "cotacao-dia":U THEN ASSIGN pFieldValue = RowObject.cotacao-dia.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "vl-movto":U THEN ASSIGN pFieldValue = RowObject.vl-movto.
        WHEN "vl-movto-me":U THEN ASSIGN pFieldValue = RowObject.vl-movto-me.
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
        WHEN "cod-portador":U THEN ASSIGN pFieldValue = RowObject.cod-portador.
        WHEN "cod-portador-dest":U THEN ASSIGN pFieldValue = RowObject.cod-portador-dest.
        &IF "{&mguni_version}" < "2.07A" &THEN	
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "modalidade":U THEN ASSIGN pFieldValue = RowObject.modalidade.
        WHEN "modalidade-dest":U THEN ASSIGN pFieldValue = RowObject.modalidade-dest.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "tp-desp-rec":U THEN ASSIGN pFieldValue = RowObject.tp-desp-rec.
        WHEN "tp-desp-rec-dest":U THEN ASSIGN pFieldValue = RowObject.tp-desp-rec-dest.
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
               retorna valor do campo ep-codigo
               retorna valor do campo cod-portador
               retorna valor do campo modalidade
               retorna valor do campo referencia
               retorna valor do campo dt-referencia
               retorna valor do campo cod-estabel-ref
               retorna valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE mov-titcr-port-liq-mec.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-portador LIKE mov-titcr-port-liq-mec.cod-portador NO-UNDO.
    DEFINE OUTPUT PARAMETER pmodalidade LIKE mov-titcr-port-liq-mec.modalidade NO-UNDO.
    DEFINE OUTPUT PARAMETER preferencia LIKE mov-titcr-port-liq-mec.referencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-referencia LIKE mov-titcr-port-liq-mec.dt-referencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel-ref LIKE mov-titcr-port-liq-mec.cod-estabel-ref NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE mov-titcr-port-liq-mec.sequencia NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-portador = RowObject.cod-portador
           pmodalidade = RowObject.modalidade
           preferencia = RowObject.referencia
           pdt-referencia = RowObject.dt-referencia
           pcod-estabel-ref = RowObject.cod-estabel-ref
           psequencia = RowObject.sequencia.

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
               recebe valor do campo ep-codigo
               recebe valor do campo cod-portador
               recebe valor do campo modalidade
               recebe valor do campo referencia
               recebe valor do campo dt-referencia
               recebe valor do campo cod-estabel-ref
               recebe valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE mov-titcr-port-liq-mec.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-portador LIKE mov-titcr-port-liq-mec.cod-portador NO-UNDO.
    DEFINE INPUT PARAMETER pmodalidade LIKE mov-titcr-port-liq-mec.modalidade NO-UNDO.
    DEFINE INPUT PARAMETER preferencia LIKE mov-titcr-port-liq-mec.referencia NO-UNDO.
    DEFINE INPUT PARAMETER pdt-referencia LIKE mov-titcr-port-liq-mec.dt-referencia NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel-ref LIKE mov-titcr-port-liq-mec.cod-estabel-ref NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE mov-titcr-port-liq-mec.sequencia NO-UNDO.

    FIND FIRST bfmov-titcr-port-liq-mec WHERE 
        bfmov-titcr-port-liq-mec.ep-codigo = pep-codigo AND 
        bfmov-titcr-port-liq-mec.cod-portador = pcod-portador AND 
        bfmov-titcr-port-liq-mec.modalidade = pmodalidade AND 
        bfmov-titcr-port-liq-mec.referencia = preferencia AND 
        bfmov-titcr-port-liq-mec.dt-referencia = pdt-referencia AND 
        bfmov-titcr-port-liq-mec.cod-estabel-ref = pcod-estabel-ref AND 
        bfmov-titcr-port-liq-mec.sequencia = psequencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmov-titcr-port-liq-mec THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmov-titcr-port-liq-mec)).
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
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-registro DBOProgram 
PROCEDURE pi-cria-registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-cod-docto         like mov-titcr-port-liq-mec.cod-docto. 
    def input param p-cod-estabel-ref   like mov-titcr-port-liq-mec.cod-estabel-ref. 
    def input param p-cod-portador      like mov-titcr-port-liq-mec.cod-portador. 
    def input param p-cod-portador-dest like mov-titcr-port-liq-mec.cod-portador-dest. 
    def input param p-cotacao-dia       like mov-titcr-port-liq-mec.cotacao-dia. 
    def input param p-dt-contrato       like mov-titcr-port-liq-mec.dt-contrato. 
    def input param p-dt-movto          like mov-titcr-port-liq-mec.dt-movto. 
    def input param p-dt-referencia     like mov-titcr-port-liq-mec.dt-referencia. 
    def input param p-ep-codigo         like mov-titcr-port-liq-mec.ep-codigo. 
    def input param p-modalidade        like mov-titcr-port-liq-mec.modalidade. 
    def input param p-modalidade-dest   like mov-titcr-port-liq-mec.modalidade-dest. 
    def input param p-nr-contrato       like mov-titcr-port-liq-mec.nr-contrato. 
    def input param p-nr-docto-banco    like mov-titcr-port-liq-mec.nr-docto-banco. 
    def input param p-nr-docto-dest     like mov-titcr-port-liq-mec.nr-docto-dest. 
    def input param p-nr-docto-emp      like mov-titcr-port-liq-mec.nr-docto-emp. 
    def input param p-referencia        like mov-titcr-port-liq-mec.referencia. 
    def input param p-tp-desp-rec       like mov-titcr-port-liq-mec.tp-desp-rec. 
    def input param p-tp-desp-rec-dest  like mov-titcr-port-liq-mec.tp-desp-rec-dest. 
    def input param p-vl-movto          like mov-titcr-port-liq-mec.vl-movto. 
    def input param p-vl-movto-me       like mov-titcr-port-liq-mec.vl-movto-me.

    def var i-seq as integer no-undo.
    
    assign i-seq = 0.
    
    find LAST mov-titcr-port-liq-mec no-lock
         where mov-titcr-port-liq-mec.ep-codigo       = p-ep-codigo
         and   mov-titcr-port-liq-mec.cod-portador    = p-cod-portador
         and   mov-titcr-port-liq-mec.modalidade      = p-modalidade
         and   mov-titcr-port-liq-mec.referencia      = p-referencia
         and   mov-titcr-port-liq-mec.dt-referencia   = p-dt-referencia
         and   mov-titcr-port-liq-mec.cod-estabel-ref = p-cod-estabel-ref no-error.
    if avail mov-titcr-port-liq-mec then
        assign i-seq = mov-titcr-port-liq-mec.sequencia. 
    
    assign cQueryUseded = "Main".

    for each RowObject:
        delete RowObject.
    end.

    create RowObject.
    assign RowObject.cod-docto         = p-cod-docto
           RowObject.cod-estabel-ref   = p-cod-estabel-ref
           RowObject.cod-portador      = p-cod-portador
           RowObject.cod-portador-dest = p-cod-portador-dest
           RowObject.cotacao-dia       = p-cotacao-dia
           RowObject.dt-contrato       = p-dt-contrato
           RowObject.dt-movto          = p-dt-movto
           RowObject.dt-referencia     = p-dt-referencia
           RowObject.ep-codigo         = p-ep-codigo
           RowObject.modalidade        = p-modalidade
           RowObject.modalidade-dest   = p-modalidade-dest
           RowObject.nr-contrato       = p-nr-contrato
           RowObject.nr-docto-banco    = p-nr-docto-banco
           RowObject.nr-docto-dest     = p-nr-docto-dest
           RowObject.nr-docto-emp      = p-nr-docto-emp
           RowObject.referencia        = p-referencia
           RowObject.sequencia         = i-seq + 1
           RowObject.tp-desp-rec       = p-tp-desp-rec
           RowObject.tp-desp-rec-dest  = p-tp-desp-rec-dest
           RowObject.vl-movto          = p-vl-movto
           RowObject.vl-movto-me       = p-vl-movto-me.

    run CreateRecord in this-procedure.
    RETURN return-value.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina-movimento DBOProgram 
PROCEDURE pi-elimina-movimento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p-ep-codigo         like mov-titcr-port-liq-mec.ep-codigo.
    def input  param p-cod-estabel       like mov-titcr-port-liq-mec.cod-estabel-ref.
    def input  param p-referencia        like mov-titcr-port-liq-mec.referencia.
    def input  param p-dt-referencia     like mov-titcr-port-liq-mec.dt-referencia.
    def output param p-cod-portador-orig like mov-titcr-port-liq-mec.cod-portador.
    def output param p-modalidade-orig   like mov-titcr-port-liq-mec.modalidade.
    def output param p-cod-portador-dest like mov-titcr-port-liq-mec.cod-portador-dest.
    def output param p-modalidade-dest   like mov-titcr-port-liq-mec.modalidade-dest.
    def output param p-dt-movto          like mov-titcr-port-liq-mec.dt-movto.

    find first mov-titcr-port-liq-mec exclusive-lock
         where mov-titcr-port-liq-mec.ep-codigo       = p-ep-codigo
         and   mov-titcr-port-liq-mec.cod-estabel-ref = p-cod-estabel
         and   mov-titcr-port-liq-mec.referencia      = p-referencia
         and   mov-titcr-port-liq-mec.dt-referencia   = p-dt-referencia no-error.
    if avail mov-titcr-port-liq-mec then do:
        assign p-cod-portador-orig = mov-titcr-port-liq-mec.cod-portador
               p-modalidade-orig   = mov-titcr-port-liq-mec.modalidade
               p-cod-portador-dest = mov-titcr-port-liq-mec.cod-portador-dest
               p-modalidade-dest   = mov-titcr-port-liq-mec.modalidade-dest
               p-dt-movto          = mov-titcr-port-liq-mec.dt-movto.
               
        delete mov-titcr-port-liq-mec.
        
        RETURN "OK":U.    
    end.
    
    RETURN "NOK":U.
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


