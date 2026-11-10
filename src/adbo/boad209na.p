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
{include/i-prgvrs.i BOAD209NA 2.00.00.013 } /*** "010013" 10/06/2025 09:30:37 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad209na MUT}
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
&GLOBAL-DEFINE DBOName portador
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName portador
&GLOBAL-DEFINE TableLabel portador
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE XMLReceiver YES
&GLOBAL-DEFINE XMLProducer YES  
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

&GLOBAL-DEFINE SOAutentic

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{adbo/boad209na.i RowObject}

{java/boRest.i}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* local var definitions ---                                               */
def var i-modalidade like portador.modalidade no-undo.
    
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
        &IF "{&mguni_version}" >= "2.07A" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "e-mail":U THEN ASSIGN pFieldValue = RowObject.e-mail.
        WHEN "esp-cob-esc":U THEN ASSIGN pFieldValue = RowObject.esp-cob-esc.
        WHEN "home-page":U THEN ASSIGN pFieldValue = RowObject.home-page.
        WHEN "intervalo-det":U THEN ASSIGN pFieldValue = RowObject.intervalo-det.
        WHEN "intervalo-head":U THEN ASSIGN pFieldValue = RowObject.intervalo-head.
        WHEN "nome":U THEN ASSIGN pFieldValue = RowObject.nome.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "nome-agencia":U THEN ASSIGN pFieldValue = RowObject.nome-agencia.
        WHEN "pref-agencia":U THEN ASSIGN pFieldValue = RowObject.pref-agencia.
        WHEN "ramal":U THEN ASSIGN pFieldValue = RowObject.ramal.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-carteira":U THEN ASSIGN pFieldValue = RowObject.cod-carteira.
        WHEN "cod-resp":U THEN ASSIGN pFieldValue = RowObject.cod-resp.
        WHEN "complemento":U THEN ASSIGN pFieldValue = RowObject.complemento.
        WHEN "conta-contabil":U THEN ASSIGN pFieldValue = RowObject.conta-contabil.
        WHEN "conta-corren":U THEN ASSIGN pFieldValue = RowObject.conta-corren.
        WHEN "conta-descontos":U THEN ASSIGN pFieldValue = RowObject.conta-descontos.
        WHEN "conta-despesas":U THEN ASSIGN pFieldValue = RowObject.conta-despesas.
        WHEN "conta-juros-recebidos":U THEN ASSIGN pFieldValue = RowObject.conta-juros-recebidos.
        WHEN "conta-principal":U THEN ASSIGN pFieldValue = RowObject.conta-principal.
        WHEN "contr-garant":U THEN ASSIGN pFieldValue = RowObject.contr-garant.
        WHEN "ct-deb-princ":U THEN ASSIGN pFieldValue = RowObject.ct-deb-princ.
        WHEN "ct-despesas":U THEN ASSIGN pFieldValue = RowObject.ct-despesas.
        WHEN "ct-juros-rec":U THEN ASSIGN pFieldValue = RowObject.ct-juros-rec.
        WHEN "ct-tit-desc":U THEN ASSIGN pFieldValue = RowObject.ct-tit-desc.
        WHEN "ramal-fax":U THEN ASSIGN pFieldValue = RowObject.ramal-fax.
        WHEN "sc-deb-princ":U THEN ASSIGN pFieldValue = RowObject.sc-deb-princ.
        WHEN "sc-despesas":U THEN ASSIGN pFieldValue = RowObject.sc-despesas.
        WHEN "sc-juros-rec":U THEN ASSIGN pFieldValue = RowObject.sc-juros-rec.
        WHEN "sc-tit-desc":U THEN ASSIGN pFieldValue = RowObject.sc-tit-desc.
        WHEN "telefax":U THEN ASSIGN pFieldValue = RowObject.telefax.
        WHEN "telefone":U THEN ASSIGN pFieldValue = RowObject.telefone.
        WHEN "telex":U THEN ASSIGN pFieldValue = RowObject.telex.
        WHEN "agencia":U THEN ASSIGN pFieldValue = RowObject.agencia.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
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
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-saldo":U THEN ASSIGN pFieldValue = RowObject.dt-saldo.
        WHEN "dt-saldo-ini":U THEN ASSIGN pFieldValue = RowObject.dt-saldo-ini.
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
        WHEN "valor-saldo":U THEN ASSIGN pFieldValue = RowObject.valor-saldo.
        WHEN "valor-saldo-me":U THEN ASSIGN pFieldValue = RowObject.valor-saldo-me.
        WHEN "vl-saldo-ini":U THEN ASSIGN pFieldValue = RowObject.vl-saldo-ini.
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
        when "carteira[1]" then pFieldValue = RowObject.carteira[1].
        when "carteira[2]" then pFieldValue = RowObject.carteira[2].
        when "carteira[3]" then pFieldValue = RowObject.carteira[3].
        when "carteira[4]" then pFieldValue = RowObject.carteira[4].
        when "carteira[5]" then pFieldValue = RowObject.carteira[5].
        when "carteira[6]" then pFieldValue = RowObject.carteira[6].
        when "cod-banco" then pFieldValue = RowObject.cod-banco.
        when "cod-febraban" then pFieldValue = RowObject.cod-febraban.
        when "cod-parc-edi" then pFieldValue = RowObject.cod-parc-edi.
        when "cod-portador" then pFieldValue = RowObject.cod-portador.
        when "convenio" then pFieldValue = RowObject.convenio.
        when "emissao-oc" then pFieldValue = RowObject.emissao-oc.
        when "emite-bloq" then pFieldValue = RowObject.emite-bloq.
        &IF "{&mguni_version}" < "2.07A" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        when "int-1" then pFieldValue = RowObject.int-1.
        when "int-2" then pFieldValue = RowObject.int-2.
        when "mo-codigo" then pFieldValue = RowObject.mo-codigo.
        when "modalidade" then pFieldValue = RowObject.modalidade.
        when "nr-prox-boleto" then pFieldValue = RowObject.nr-prox-boleto.
        when "perc-part-dest" then pFieldValue = RowObject.perc-part-dest.
        when "pr-env-pag" then pFieldValue = RowObject.pr-env-pag.
        when "pr-lib-tit" then pFieldValue = RowObject.pr-lib-tit.
        when "prazo-max" then pFieldValue = RowObject.prazo-max.
        when "prazo-max-ap" then pFieldValue = RowObject.prazo-max-ap.
        when "prazo-min" then pFieldValue = RowObject.prazo-min.
        when "prazo-min-ap" then pFieldValue = RowObject.prazo-min-ap.
        when "prox-remessa-ap" then pFieldValue = RowObject.prox-remessa-ap.
        when "prox-remessa-cr" then pFieldValue = RowObject.prox-remessa-cr.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice CODIGO
  Parameters:
               retorna valor dos campos do °ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE portador.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-portador LIKE portador.cod-portador NO-UNDO.
    DEFINE OUTPUT PARAMETER pmodalidade LIKE portador.modalidade NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo.
    ASSIGN pcod-portador = RowObject.cod-portador.
    ASSIGN pmodalidade = RowObject.modalidade.

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
        when "bancario" then pFieldValue = RowObject.bancario.
        when "considera-fluxo-ap" then pFieldValue = RowObject.considera-fluxo-ap.
        when "considera-fluxo-cr" then pFieldValue = RowObject.considera-fluxo-cr.
        when "exige-aceite" then pFieldValue = RowObject.exige-aceite.
        when "gera-disponivel" then pFieldValue = RowObject.gera-disponivel.
        when "ind-dt-cred-ret" then pFieldValue = RowObject.ind-dt-cred-ret.
        when "log-1" then pFieldValue = RowObject.log-1.
        when "log-2" then pFieldValue = RowObject.log-2.
        when "usa-cob-esc" then pFieldValue = RowObject.usa-cob-esc.
        when "usa-inter" then pFieldValue = RowObject.usa-inter.
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
  Purpose:     Reposiciona registro com base no °ndice CODIGO
  Parameters:
               recebe valor dos campos do °ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE portador.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-portador LIKE portador.cod-portador NO-UNDO.
    DEFINE INPUT PARAMETER pmodalidade LIKE portador.modalidade NO-UNDO.

    FIND FIRST bfportador WHERE
        bfportador.ep-codigo = pep-codigo AND
        bfportador.cod-portador = pcod-portador AND
        bfportador.modalidade = pmodalidade
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfportador THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfportador)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToPortador DBOProgram 
PROCEDURE goToPortador :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice CODIGO
  Parameters:
               recebe valor dos campos do °ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-portador LIKE portador.cod-portador NO-UNDO.

    FIND FIRST bfportador WHERE
        bfportador.cod-portador = pcod-portador
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfportador THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfportador)).
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
    OPEN QUERY {&QueryName} FOR EACH portador NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintArgentina DBOProgram 
PROCEDURE setConstraintArgentina :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    def input param pmodalidade like portador.modalidade no-undo.
    
    assign i-modalidade = pmodalidade.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryArgentina DBOProgram 
PROCEDURE openQueryArgentina :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH portador NO-LOCK
        where portador.modalidade = i-modalidade INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-empresa DBOProgram 
PROCEDURE pi-busca-empresa :
/*------------------------------------------------------------------------------
  Purpose: Essa procedure retorna o c¢digo da empresa
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF "{&mguni_version}" >= "2.07A" &THEN
    DEFINE OUTPUT PARAMETER i-ep-codigo          LIKE empresa.ep-codigo NO-UNDO.    
&ELSE
    DEFINE OUTPUT PARAMETER i-ep-codigo          AS INTEGER NO-UNDO.    
&ENDIF
    {method/svc/autentic/autentic.i
            &vUserEnterprise="i-ep-codigo"}
    
    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-pais DBOProgram 
PROCEDURE pi-busca-pais :
/*------------------------------------------------------------------------------
  Purpose: Essa procedure retorna o pais do usu†rio
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER i-pais-impto-usuario AS INTEGER NO-UNDO.
    
    {method/svc/autentic/autentic.i
            &vUserCountryTax="i-pais-impto-usuario"}
    
    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-existe DBOProgram 
PROCEDURE pi-valida-existe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p-ep-codigo  like portador.ep-codigo  no-undo.
    def input  param p-cod-port   like portador.cod-portador   no-undo.
    def input  param p-modalidade like portador.modalidade no-undo.
    def output param p-moeda      like portador.mo-codigo  no-undo.
    
    find portador 
        where portador.ep-codigo  = p-ep-codigo
        and   portador.cod-portador   = p-cod-port
        and   portador.modalidade = p-modalidade no-lock no-error. 

    if avail portador then do:
        assign p-moeda = portador.mo-codigo.
        RETURN "OK":U.
    end.
    else
        RETURN "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-existe2 DBOProgram 
PROCEDURE pi-valida-existe2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param  p-ep-codigo  like portador.ep-codigo  no-undo.
    def input  param  p-cod-port   like portador.cod-portador   no-undo.
    def input  param  p-modalidade like portador.modalidade no-undo.
    def output param  p-bancario   like portador.bancario   no-undo.
    
    find portador 
        where portador.ep-codigo  = p-ep-codigo
        and   portador.cod-portador   = p-cod-port
        and   portador.modalidade = p-modalidade no-lock no-error. 

    if avail portador then do:
        assign p-bancario = portador.bancario.
        RETURN "OK":U.
    end.
    else
        RETURN "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornar-nome-banco DBOProgram 
PROCEDURE retornar-nome-banco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input  parameter p-cod-banco  like portador.cod-banco no-undo.
    define output parameter p-nome-banco like banco.nome-banco   no-undo.
   
    assign  p-nome-banco = ''.
    find banco 
         where banco.cod-banco = p-cod-banco
         no-lock no-error.
    if  avail banco then 
        assign p-nome-banco = banco.nome-banco.
    
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


