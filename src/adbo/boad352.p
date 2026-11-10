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
{include/i-prgvrs.i BOAD352 2.00.00.005} /*** "010005" 20/10/2023 10:44:29  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad352 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : dbo.p
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
&GLOBAL-DEFINE DBOName BOAD352
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName titcr-port-mec-liq
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{adbo/boad352.i RowObject}


/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var v-num-id    as   integer no-undo.
def var v-sequencia as   integer no-undo.
def var c-usuario   like titcr-port-mec-liq.usuario.

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
         HEIGHT             = 2.01
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeCreateRecord DBOProgram 
PROCEDURE BeforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    assign v-num-id    = 0
           v-sequencia = 0.
           
    {method/svc/autentic/autentic.i
            &vUserName="c-usuario"}

    find last titcr-port-mec-liq no-lock
        where titcr-port-mec-liq.ep-codigo    = RowObject.ep-codigo
        and   titcr-port-mec-liq.cod-portador = RowObject.cod-portador
        and   titcr-port-mec-liq.modalidade   = RowObject.modalidade   no-error.
    if avail titcr-port-mec-liq then
        assign v-sequencia = titcr-port-mec-liq.sequencia.

    assign RowObject.sequencia      = v-sequencia + 1
           RowObject.usuario        = c-usuario
           RowObject.c-time         = string(TIME, "HH:MM")
           RowObject.dt-today       = today.

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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        &IF "{&mguni_version}" >= "2.07A" &THEN	
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "c-time":U THEN ASSIGN pFieldValue = RowObject.c-time.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-esp":U THEN ASSIGN pFieldValue = RowObject.cod-esp.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "nr-docto":U THEN ASSIGN pFieldValue = RowObject.nr-docto.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
        WHEN "serie":U THEN ASSIGN pFieldValue = RowObject.serie.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-movto":U THEN ASSIGN pFieldValue = RowObject.dt-movto.
        WHEN "dt-today":U THEN ASSIGN pFieldValue = RowObject.dt-today.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-portador":U THEN ASSIGN pFieldValue = RowObject.cod-portador.
        &IF "{&mguni_version}" < "2.07A" &THEN	
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "modalidade":U THEN ASSIGN pFieldValue = RowObject.modalidade.
        WHEN "num-id-mov-tit":U THEN ASSIGN pFieldValue = RowObject.num-id-mov-tit.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice codigo
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-portador
               retorna valor do campo modalidade
               retorna valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE titcr-port-mec-liq.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-portador LIKE titcr-port-mec-liq.cod-portador NO-UNDO.
    DEFINE OUTPUT PARAMETER pmodalidade LIKE titcr-port-mec-liq.modalidade NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE titcr-port-mec-liq.sequencia NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-portador = RowObject.cod-portador
           pmodalidade = RowObject.modalidade
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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
  Purpose:     Reposiciona registro com base no ¡ndice codigo
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-portador
               recebe valor do campo modalidade
               recebe valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE titcr-port-mec-liq.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-portador LIKE titcr-port-mec-liq.cod-portador NO-UNDO.
    DEFINE INPUT PARAMETER pmodalidade LIKE titcr-port-mec-liq.modalidade NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE titcr-port-mec-liq.sequencia NO-UNDO.

    FIND FIRST bftitcr-port-mec-liq WHERE 
        bftitcr-port-mec-liq.ep-codigo = pep-codigo AND 
        bftitcr-port-mec-liq.cod-portador = pcod-portador AND 
        bftitcr-port-mec-liq.modalidade = pmodalidade AND 
        bftitcr-port-mec-liq.sequencia = psequencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bftitcr-port-mec-liq THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bftitcr-port-mec-liq)).
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-registro DBOProgram 
PROCEDURE pi-cria-registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-ep-codigo     like titcr-port-mec-liq.ep-codigo       no-undo.
    def input param p-portador      like titcr-port-mec-liq.cod-portador    no-undo.
    def input param p-modalidade    like titcr-port-mec-liq.modalidade      no-undo.
    def input param p-cod-estabel   like titcr-port-mec-liq.cod-estabel     no-undo.
    def input param p-cod-esp       like titcr-port-mec-liq.cod-esp         no-undo.
    def input param p-nr-docto      like titcr-port-mec-liq.nr-docto        no-undo.
    def input param p-parcela       like titcr-port-mec-liq.parcela         no-undo.
    def input param p-cod-emitente  like titcr-port-mec-liq.cod-emitente    no-undo.
    def input param p-moeda         like titcr-port-mec-liq.mo-codigo       no-undo.
    def input param p-dt-movto      like titcr-port-mec-liq.dt-movto        no-undo.
    def input param p-situacao      like titcr-port-mec-liq.situacao        no-undo.
    def input param p-serie         like titcr-port-mec-liq.serie           no-undo.
    def input param p-vl-movto      like titcr-port-mec-liq.vl-movto        no-undo.
    def input param p-vl-movto-me   like titcr-port-mec-liq.vl-movto-me     no-undo.
    def input param p-cotacao       like titcr-port-mec-liq.cotacao-dia     no-undo.
    def input param p-estabel-ref   like titcr-port-mec-liq.cod-estabel-ref no-undo.
    def input param p-referencia    like titcr-port-mec-liq.referencia      no-undo.
    def input param p-dt-referencia like titcr-port-mec-liq.dt-referencia   no-undo.
    def input param p-num-id-movto  like titcr-port-mec-liq.num-id-mov-tit  no-undo.

    assign cQueryUseded = "Main".

    for each RowObject:
        delete RowObject.
    end.

    create RowObject.
    assign RowObject.ep-codigo       = p-ep-codigo
           RowObject.cod-portador    = p-portador
           RowObject.modalidade      = p-modalidade
           RowObject.cod-estabel     = p-cod-estabel
           RowObject.cod-esp         = p-cod-esp
           RowObject.nr-docto        = p-nr-docto
           RowObject.parcela         = p-parcela
           RowObject.cod-emitente    = p-cod-emitente
           RowObject.mo-codigo       = p-moeda
           RowObject.dt-movto        = p-dt-movto
           RowObject.situacao        = p-situacao
           RowObject.serie           = p-serie
           RowObject.vl-movto        = p-vl-movto
           RowObject.vl-movto-me     = p-vl-movto-me
           RowObject.cotacao-dia     = p-cotacao
           RowObject.cod-estabel-ref = p-estabel-ref
           RowObject.referencia      = p-referencia
           RowObject.dt-referencia   = p-dt-referencia
           RowObject.num-id-mov-tit  = p-num-id-movto.

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
    def input param p-ep-codigo     like titcr-port-mec-liq.ep-codigo       no-undo.
    def input param p-cod-estabel   like titcr-port-mec-liq.cod-estabel     no-undo.
    def input param p-cod-esp       like titcr-port-mec-liq.cod-esp         no-undo.
    def input param p-serie         like titcr-port-mec-liq.serie           no-undo.
    def input param p-nr-docto      like titcr-port-mec-liq.nr-docto        no-undo.
    def input param p-parcela       like titcr-port-mec-liq.parcela         no-undo.
    def input param p-referencia    like titcr-port-mec-liq.referencia      no-undo.
    def input param p-dt-referencia like titcr-port-mec-liq.dt-referencia   no-undo.
    def input param p-num-id        like titcr-port-mec-liq.num-id-mov-tit  no-undo.

    find first titcr-port-mec-liq exclusive-lock
         where titcr-port-mec-liq.ep-codigo      = p-ep-codigo
         and   titcr-port-mec-liq.cod-estabel    = p-cod-estabel
         and   titcr-port-mec-liq.cod-esp        = p-cod-esp
         and   titcr-port-mec-liq.serie          = p-serie
         and   titcr-port-mec-liq.nr-docto       = p-nr-docto
         and   titcr-port-mec-liq.parcela        = p-parcela
         and   titcr-port-mec-liq.referencia     = p-referencia
         and   titcr-port-mec-liq.dt-referencia  = p-dt-referencia 
         and   titcr-port-mec-liq.num-id-mov-tit = p-num-id         no-error.
    if avail titcr-port-mec-liq then
        delete titcr-port-mec-liq.

    RETURN "OK":U.
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
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida‡äes ---*/
    
    /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


