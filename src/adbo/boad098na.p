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
{include/i-prgvrs.i BOAD098NA 2.00.00.039 } /*** "010039" 01/09/2026 09:07:07 ***/

/* procedure para gerar a versÆo para o log do appserver ou client log, o metodo apenas precisa receber parametros nao precisa fazer nada */
PROCEDURE geraLogApp:
    DEFINE INPUT  PARAMETER cPrgObj AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER cPrgVrs AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER fineNameProcessor AS CHARACTER   NO-UNDO.	
END PROCEDURE.
RUN geraLogApp (c-prg-obj, c-prg-vrs, "{&FILE-NAME}").
/* fim - procedure para gerar a versÆo para o log do appserver ou client log, o metodo apenas precisa receber parametros nao precisa fazer nada */


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boad098na MUT}
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
&GLOBAL-DEFINE DBOName BOAD098
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName emitente
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

&GLOBAL-DEFINE KeyField1 cod-emitente /*:T Informar os campos da chave quando o Progress n’o conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m²todo Receive Message) */
/*&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES*/

&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND TRUE
&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND-PROCS Main

/*--- Include com preprocessador p/release 2.05---*/
{cdp/cdcfgmat.i}

/*--- Include com defini»’o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com 
      extens’o .i ---*/
{adbo/boad098na.i RowObject}


/*--- Include com defini»’o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera»’o da defini»’o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»’o 
      manual da query ---*/
{method/dboqry.i}


/*--- Defini»’o de buffer que serÿ utilizado pelo m²todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Defini»’o da variÿvel necessÿria a setConstraintEmitente */
DEFINE VARIABLE cCodEmitente AS CHARACTER NO-UNDO.

/* Defini»’o as variÿveis para a setConstraintFaixaEmitente */

def var i-cod-emitente-ini  as integer no-undo.
def var i-cod-emitente-fim  as integer no-undo.

DEFINE TEMP-TABLE tt-cta_usuar NO-UNDO  /* conta por usuÿrio */
    FIELD cod_pessoa_erp   AS CHARACTER
    FIELD num_id_pessoa    AS INTEGER
    INDEX id num_id_pessoa ASC.

DEFINE TEMP-TABLE ttGrupoCliente NO-UNDO
    FIELD codgrcli AS CHARACTER.

DEFINE VARIABLE companyUsesSalesTeam    AS LOGICAL     NO-UNDO.

/* Defini»’o as variÿveis para a setConstraintFaixaNomeAbrev */

def var c-nome-abrev-ini    as char    no-undo.
def var c-nome-abrev-fim    as char    no-undo.

/* Defini»’o as variÿveis para a setConstraintFaixaCGC */

def var c-cgc-ini           as char    no-undo.
def var c-cgc-fim           as char    no-undo.

/* Defini»’o as variÿveis para a setConstraintFaixaGrupo */

def var i-cod-gr-cli-ini    as integer no-undo.
def var i-cod-gr-cli-fim    as integer no-undo.

/* Defini»’o as variÿveis para a setConstraintFaixaNomeEmit */

def var c-nome-emit-ini     as char    no-undo.
def var c-nome-emit-fim     as char    no-undo.

def var i-cod-rep-ini as int no-undo.
def var i-cod-rep-fim as int no-undo.

DEF VAR c-nome-matriz-ini AS CHAR NO-UNDO.
DEF VAR c-nome-matriz-fim AS CHAR NO-UNDO.

DEF VAR i-ordena AS INT NO-UNDO.

DEF VAR i-cod-repre AS INT NO-UNDO.

/*Variÿveis para guardar dados do usuÿrio logado*/
DEFINE VARIABLE h-handle     AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-boCrmHier AS HANDLE      NO-UNDO.
DEFINE VARIABLE cPerfil      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCodigoRep   AS CHAR       NO-UNDO.

/* variavel que guarda o criterio de pesquisa */
DEFINE VARIABLE criteria AS CHARACTER   NO-UNDO.
DEFINE VARIABLE numresults AS INTEGER     NO-UNDO.

/*Variÿveis definida para controlar o filtro de clientes Ativos e Inativos*/
DEFINE VARIABLE filtro     AS LOGICAL  INIT NO   NO-UNDO.
DEFINE VARIABLE iCategoria AS INT                NO-UNDO.

DEFINE TEMP-TABLE ttListaRowid NO-UNDO FIELD uid as CHAR.

DEFINE VARIABLE iHierarchy      AS INTEGER     NO-UNDO INITIAL -1.
DEFINE VARIABLE iHierarchyType  AS INTEGER     NO-UNDO INITIAL -1.
//DEFINE VARIABLE ignoreHierarchy AS LOGICAL     NO-UNDO.

DEFINE VARIABLE lIntCRM11     AS LOGICAL NO-UNDO INITIAL FALSE.
RUN utp/ut-crm11.p (OUTPUT lIntCRM11).

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHAR NO-UNDO.

// Defini‡Æo de TT para usar na procedure getCustomerBySalesChannel
DEFINE TEMP-TABLE tt-clientes-repres NO-UNDO
    FIELD cod-emitente  AS INTEGER.  

/*Esta triger ² para tirar da query os cliente que n’o entrao na condi»’o de ativos e inativos*/
ON find OF emitente
DO:


    IF companyUsesSalesTeam AND criteria <> "" AND NOT CAN-FIND(tt-cta_usuar WHERE int(cod_pessoa_erp) = emitente.cod-emitente) THEN RETURN ERROR.

    IF NOT filtro THEN
       RETURN.

    IF iCategoria = 0 THEN RETURN.


    /* Este codido estÿ repetido na procedure returnNumresultsByCategoria */
    DEFINE VARIABLE da-ult-ven AS DATE    NO-UNDO.
    DEFINE VARIABLE da-movto AS DATE    NO-UNDO.
    DEFINE VARIABLE i-nr-mesina AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-nr-meses AS INTEGER     NO-UNDO.
    DEFINE VARIABLE l-inativo AS LOGICAL     NO-UNDO.
    
    ASSIGN da-ult-ven  = emitente.data-implant.

    ASSIGN da-movto    = 01/01/1901.
           i-nr-mesina = emitente.nr-mesina.

    &IF DEFINED(bf_resum_emit) &THEN
    &ELSE    
        IF  i-nr-mesina = 0 THEN DO:
            l-inativo = NO.
        END.
        ELSE
    &ENDIF

    DO:
        FOR FIRST estatist FIELDS (estatist.dt-ult-tit) WHERE 
                  estatist.cod-emitente = emitente.cod-emitente NO-LOCK:
            ASSIGN da-movto = estatist.dt-ult-tit.
        END.

    FOR LAST nota-fiscal FIELDS (nota-fiscal.dt-emis-nota) USE-INDEX ch-emi-nota WHERE 
         nota-fiscal.cod-emitente = emitente.cod-emitente AND 
         nota-fiscal.replica-nf   = NO AND 
         nota-fiscal.dt-cancela   = ? NO-LOCK:

            IF  nota-fiscal.dt-emis-nota > da-movto THEN   
                ASSIGN da-movto = nota-fiscal.dt-emis-nota.
    END.

        ASSIGN da-ult-ven = IF  da-movto > da-ult-ven 
                            THEN da-movto 
                            ELSE da-ult-ven.
                    
        ASSIGN i-nr-meses = (YEAR(TODAY)      * 12 + MONTH(TODAY))
                          - (YEAR(da-ult-ven) * 12 + MONTH(da-ult-ven)) - 1
               l-inativo  = (i-nr-meses > i-nr-mesina).  
    END.

    IF iCategoria = 1 AND l-inativo THEN RETURN ERROR.        
    IF iCategoria = 2 AND NOT l-inativo THEN RETURN ERROR.

END.

define temp-table RowErrorsFrotas no-undo
    field ErrorSequence    as integer
    field ErrorNumber      as integer
    field ErrorDescription as character
    field ErrorParameters  as character
    field ErrorType        as character
    field ErrorHelp        as character
    field ErrorSubType     as character.

/* PCREQ-9042 - Portador do Emitente */
define variable i-portador      as integer no-undo.
define variable i-modalidade    as integer no-undo.
define variable i-port-prefer   as integer no-undo.
define variable i-mod-prefer    as integer no-undo.
define variable i-portador-ap   as integer no-undo.
define variable i-modalidade-ap as integer no-undo.

{cdp/cdapi3009.i1}

/******  BANCOS HIST…RICOS ******/
/*-- Defini»’o da tt-tabela ---*/
{bhp/bh9999.i1}

{cdp/cd1000.i}
/******  BANCOS HIST…RICOS ******/

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
         HEIGHT             = 3.5
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

{cdp/fnConsisteCampoRamalCliente.i}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 

/* ***************************  Main Block  *************************** */
/* PCREQ-9042 - Portador do Emitente */
{cdp/cdapi3009.i2}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findEmitente DBOProgram 
PROCEDURE findEmitente :
/*------------------------------------------------------------------------------
  Purpose:   Procura pelo ¡ndice, caso nÆo ache, retorna
                mensagem de erro padrÆo do  EMS
  Parameters: 
 ------------------------------------------------------------------------------*/
    
    def input parameter c-cod-emitente as char no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToKey (input c-cod-emitente).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo n’o acha o registro */
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "agencia":U THEN ASSIGN pFieldValue = RowObject.agencia.
        WHEN "atividade":U THEN ASSIGN pFieldValue = RowObject.atividade.
        WHEN "bairro":U THEN ASSIGN pFieldValue = RowObject.bairro.
        WHEN "bairro-cob":U THEN ASSIGN pFieldValue = RowObject.bairro-cob.
        WHEN "caixa-postal":U THEN ASSIGN pFieldValue = RowObject.caixa-postal.
        WHEN "categoria":U THEN ASSIGN pFieldValue = RowObject.categoria.
        WHEN "cep":U THEN ASSIGN pFieldValue = RowObject.cep.
        WHEN "cep-cob":U THEN ASSIGN pFieldValue = RowObject.cep-cob.
        WHEN "cgc":U THEN ASSIGN pFieldValue = RowObject.cgc.
        WHEN "cgc-cob":U THEN ASSIGN pFieldValue = RowObject.cgc-cob.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cidade":U THEN ASSIGN pFieldValue = RowObject.cidade.
        WHEN "cidade-cob":U THEN ASSIGN pFieldValue = RowObject.cidade-cob.
        WHEN "cn-codigo":U THEN ASSIGN pFieldValue = RowObject.cn-codigo.
        WHEN "cod-cacex":U THEN ASSIGN pFieldValue = RowObject.cod-cacex.
        WHEN "cod-entrega":U THEN ASSIGN pFieldValue = RowObject.cod-entrega.
        WHEN "cod-suframa":U THEN ASSIGN pFieldValue = RowObject.cod-suframa.
        WHEN "conta-corren":U THEN ASSIGN pFieldValue = RowObject.conta-corren.
        WHEN "contato[1]":U THEN ASSIGN pFieldValue = RowObject.contato[1].
        WHEN "contato[2]":U THEN ASSIGN pFieldValue = RowObject.contato[2].
        WHEN "cx-post-cob":U THEN ASSIGN pFieldValue = RowObject.cx-post-cob.
        WHEN "e-mail":U THEN ASSIGN pFieldValue = RowObject.e-mail.
        WHEN "endereco":U THEN ASSIGN pFieldValue = RowObject.endereco.
        WHEN "endereco-cob":U THEN ASSIGN pFieldValue = RowObject.endereco-cob.
        WHEN "endereco2":U THEN ASSIGN pFieldValue = RowObject.endereco2.
        WHEN "estado":U THEN ASSIGN pFieldValue = RowObject.estado.
        WHEN "estado-cob":U THEN ASSIGN pFieldValue = RowObject.estado-cob.
        WHEN "home-page":U THEN ASSIGN pFieldValue = RowObject.home-page.
        WHEN "inf-complementar":U THEN ASSIGN pFieldValue = RowObject.inf-complementar.
        WHEN "ins-est-cob":U THEN ASSIGN pFieldValue = RowObject.ins-est-cob.
        WHEN "ins-estadual":U THEN ASSIGN pFieldValue = RowObject.ins-estadual.
        WHEN "ins-municipal":U THEN ASSIGN pFieldValue = RowObject.ins-municipal.
        WHEN "insc-subs-trib":U THEN ASSIGN pFieldValue = RowObject.insc-subs-trib.
        WHEN "linha-produt":U THEN ASSIGN pFieldValue = RowObject.linha-produt.
        WHEN "nat-ope-ext":U THEN ASSIGN pFieldValue = RowObject.nat-ope-ext.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "nome-emit":U THEN ASSIGN pFieldValue = RowObject.nome-emit.
        WHEN "nome-matriz":U THEN ASSIGN pFieldValue = RowObject.nome-matriz.
        WHEN "nome-mic-reg":U THEN ASSIGN pFieldValue = RowObject.nome-mic-reg.
        WHEN "nome-tr-red":U THEN ASSIGN pFieldValue = RowObject.nome-tr-red.
        WHEN "nr-tabpre":U THEN ASSIGN pFieldValue = RowObject.nr-tabpre.
        WHEN "obs-entrega":U THEN ASSIGN pFieldValue = RowObject.obs-entrega.
        WHEN "observacoes":U THEN ASSIGN pFieldValue = RowObject.observacoes.
        WHEN "pais":U THEN ASSIGN pFieldValue = RowObject.pais.
        WHEN "pais-cob":U THEN ASSIGN pFieldValue = RowObject.pais-cob.
        WHEN "ramal[1]":U THEN ASSIGN pFieldValue = RowObject.ramal[1].
        WHEN "ramal[2]":U THEN ASSIGN pFieldValue = RowObject.ramal[2].
        WHEN "ramal-fac":U THEN ASSIGN pFieldValue = RowObject.ramal-fac.
        WHEN "ramal-fax":U THEN ASSIGN pFieldValue = RowObject.ramal-fax.
        WHEN "ramal-modem":U THEN ASSIGN pFieldValue = RowObject.ramal-modem.
        WHEN "telef-fac":U THEN ASSIGN pFieldValue = RowObject.telef-fac.
        WHEN "telef-modem":U THEN ASSIGN pFieldValue = RowObject.telef-modem.
        WHEN "telefax":U THEN ASSIGN pFieldValue = RowObject.telefax.
        WHEN "telefone[1]":U THEN ASSIGN pFieldValue = RowObject.telefone[1].
        WHEN "telefone[2]":U THEN ASSIGN pFieldValue = RowObject.telefone[2].
        WHEN "telex":U THEN ASSIGN pFieldValue = RowObject.telex.
        WHEN "user-libcre":U THEN ASSIGN pFieldValue = RowObject.user-libcre.
        WHEN "zip-cob-code":U THEN ASSIGN pFieldValue = RowObject.zip-cob-code.
        WHEN "zip-code":U THEN ASSIGN pFieldValue = RowObject.zip-code.
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
        WHEN "data-implant":U THEN ASSIGN pFieldValue = RowObject.data-implant.
        WHEN "data-taxa":U THEN ASSIGN pFieldValue = RowObject.data-taxa.
        WHEN "dt-fim-cred":U THEN ASSIGN pFieldValue = RowObject.dt-fim-cred.
        WHEN "dt-lim-cred":U THEN ASSIGN pFieldValue = RowObject.dt-lim-cred.
        WHEN "dt-ult-venda":U THEN ASSIGN pFieldValue = RowObject.dt-ult-venda.
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
        WHEN "bonificacao":U THEN ASSIGN pFieldValue = RowObject.bonificacao.
        WHEN "compr-period":U THEN ASSIGN pFieldValue = RowObject.compr-period.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "lim-adicional":U THEN ASSIGN pFieldValue = RowObject.lim-adicional.
        WHEN "lim-credito":U THEN ASSIGN pFieldValue = RowObject.lim-credito.
        WHEN "per-max-canc":U THEN ASSIGN pFieldValue = RowObject.per-max-canc.
        WHEN "per-minfat":U THEN ASSIGN pFieldValue = RowObject.per-minfat.
        /*WHEN "rend-tribut":U THEN ASSIGN pFieldValue = RowObject.rend-tribut.*/ /*Este campo necessita de pre-processador*/
        WHEN "taxa-financ":U THEN ASSIGN pFieldValue = RowObject.taxa-financ.
        WHEN "val-quota-media":U THEN ASSIGN pFieldValue = RowObject.val-quota-media.
        WHEN "valor-minimo":U THEN ASSIGN pFieldValue = RowObject.valor-minimo.
        WHEN "vl-max-devol":U THEN ASSIGN pFieldValue = RowObject.vl-max-devol.
        WHEN "vl-min-ad":U THEN ASSIGN pFieldValue = RowObject.vl-min-ad.
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
        WHEN "bx-acatada":U THEN ASSIGN pFieldValue = RowObject.bx-acatada.
        WHEN "cod-banco":U THEN ASSIGN pFieldValue = RowObject.cod-banco.
        WHEN "cod-canal-venda":U THEN ASSIGN pFieldValue = RowObject.cod-canal-venda.
        WHEN "cod-classif-cliente":U THEN ASSIGN pFieldValue = RowObject.cod-classif-cliente.
        WHEN "cod-classif-fornec":U THEN ASSIGN pFieldValue = RowObject.cod-classif-fornec.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-gr-cli":U THEN ASSIGN pFieldValue = RowObject.cod-gr-cli.
        WHEN "cod-gr-forn":U THEN ASSIGN pFieldValue = RowObject.cod-gr-forn.
        WHEN "cod-isencao":U THEN ASSIGN pFieldValue = RowObject.cod-isencao.
        WHEN "cod-mensagem":U THEN ASSIGN pFieldValue = RowObject.cod-mensagem.
        WHEN "cod-parceiro-edi":U THEN ASSIGN pFieldValue = RowObject.cod-parceiro-edi.
        WHEN "cod-rep":U THEN ASSIGN pFieldValue = RowObject.cod-rep.
/*        WHEN "cod-repres-imp":U THEN ASSIGN pFieldValue = RowObject.cod-repres-imp.*/ /*Este campo necessita de pre-processador*/
        WHEN "cod-tax":U THEN ASSIGN pFieldValue = RowObject.cod-tax.
        WHEN "cod-tip-ent":U THEN ASSIGN pFieldValue = RowObject.cod-tip-ent.
        WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-transp.
        WHEN "dias-comp":U THEN ASSIGN pFieldValue = RowObject.dias-comp.
        WHEN "emissao-ped":U THEN ASSIGN pFieldValue = RowObject.emissao-ped.
        WHEN "end-cobranca":U THEN ASSIGN pFieldValue = RowObject.end-cobranca.
        WHEN "esp-pd-venda":U THEN ASSIGN pFieldValue = RowObject.esp-pd-venda.
        WHEN "estoque":U THEN ASSIGN pFieldValue = RowObject.estoque.
        WHEN "flag-pag":U THEN ASSIGN pFieldValue = RowObject.flag-pag.
        WHEN "gera-difer":U THEN ASSIGN pFieldValue = RowObject.gera-difer.
        WHEN "hora-fim":U THEN ASSIGN pFieldValue = RowObject.hora-fim.
        WHEN "hora-ini":U THEN ASSIGN pFieldValue = RowObject.hora-ini.
        WHEN "identific":U THEN ASSIGN pFieldValue = RowObject.identific.
        WHEN "ind-abrange-aval":U THEN ASSIGN pFieldValue = RowObject.ind-abrange-aval.
        WHEN "ind-atraso":U THEN ASSIGN pFieldValue = RowObject.ind-atraso.
        WHEN "ind-aval":U THEN ASSIGN pFieldValue = RowObject.ind-aval.
        WHEN "ind-aval-embarque":U THEN ASSIGN pFieldValue = RowObject.ind-aval-embarque.
        WHEN "ind-cre-cli":U THEN ASSIGN pFieldValue = RowObject.ind-cre-cli.
        WHEN "ind-dif-atrs-1":U THEN ASSIGN pFieldValue = RowObject.ind-dif-atrs-1.
        WHEN "ind-dif-atrs-2":U THEN ASSIGN pFieldValue = RowObject.ind-dif-atrs-2.
        WHEN "ind-div-atraso":U THEN ASSIGN pFieldValue = RowObject.ind-div-atraso.
        WHEN "ind-emit-retencao":U THEN ASSIGN pFieldValue = RowObject.ind-emit-retencao.
        WHEN "ind-moeda-tit":U THEN ASSIGN pFieldValue = RowObject.ind-moeda-tit.
        WHEN "ind-sit-emitente":U THEN ASSIGN pFieldValue = RowObject.ind-sit-emitente.
        WHEN "ins-banc[1]":U THEN ASSIGN pFieldValue = RowObject.ins-banc[1].
        WHEN "ins-banc[2]":U THEN ASSIGN pFieldValue = RowObject.ins-banc[2].
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "istr":U THEN ASSIGN pFieldValue = RowObject.istr.
        WHEN "mod-prefer":U THEN ASSIGN pFieldValue = RowObject.mod-prefer.
        WHEN "modalidade":U THEN ASSIGN pFieldValue = RowObject.modalidade.
        WHEN "moeda-libcre":U THEN ASSIGN pFieldValue = RowObject.moeda-libcre.
        WHEN "natureza":U THEN ASSIGN pFieldValue = RowObject.natureza.
        WHEN "nr-cheque-devol":U THEN ASSIGN pFieldValue = RowObject.nr-cheque-devol.
        WHEN "nr-copias-ped":U THEN ASSIGN pFieldValue = RowObject.nr-copias-ped.
        WHEN "nr-dias":U THEN ASSIGN pFieldValue = RowObject.nr-dias.
        WHEN "nr-dias-atraso":U THEN ASSIGN pFieldValue = RowObject.nr-dias-atraso.
        WHEN "nr-dias-taxa":U THEN ASSIGN pFieldValue = RowObject.nr-dias-taxa.
        WHEN "nr-mesina":U THEN ASSIGN pFieldValue = RowObject.nr-mesina.
        WHEN "nr-peratr":U THEN ASSIGN pFieldValue = RowObject.nr-peratr.
        WHEN "nr-tab-progr":U THEN ASSIGN pFieldValue = RowObject.nr-tab-progr.
        WHEN "nr-titulo":U THEN ASSIGN pFieldValue = RowObject.nr-titulo.
        WHEN "perc-fat-ped":U THEN ASSIGN pFieldValue = RowObject.perc-fat-ped.
        WHEN "periodo-devol":U THEN ASSIGN pFieldValue = RowObject.periodo-devol.
        WHEN "port-prefer":U THEN ASSIGN pFieldValue = RowObject.port-prefer.
        WHEN "portador":U THEN ASSIGN pFieldValue = RowObject.portador.
        WHEN "prox-ad":U THEN ASSIGN pFieldValue = RowObject.prox-ad.
        WHEN "resumo-mp":U THEN ASSIGN pFieldValue = RowObject.resumo-mp.
        WHEN "tip-cob-desp":U THEN ASSIGN pFieldValue = RowObject.tip-cob-desp.
        WHEN "tp-desp-padrao":U THEN ASSIGN pFieldValue = RowObject.tp-desp-padrao.
        WHEN "tp-inspecao":U THEN ASSIGN pFieldValue = RowObject.tp-inspecao.
        WHEN "tp-pagto":U THEN ASSIGN pFieldValue = RowObject.tp-pagto.
        WHEN "tp-qt-prg":U THEN ASSIGN pFieldValue = RowObject.tp-qt-prg.
        WHEN "tp-rec-padrao":U THEN ASSIGN pFieldValue = RowObject.tp-rec-padrao.
        WHEN "tr-ar-valor":U THEN ASSIGN pFieldValue = RowObject.tr-ar-valor.
        WHEN "ven-domingo":U THEN ASSIGN pFieldValue = RowObject.ven-domingo.
        WHEN "ven-feriado":U THEN ASSIGN pFieldValue = RowObject.ven-feriado.
        WHEN "ven-sabado":U THEN ASSIGN pFieldValue = RowObject.ven-sabado.
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
               retorna valor do campo cod-emitente
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE emitente.cod-emitente NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-emitente = RowObject.cod-emitente.

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
        WHEN "agente-retencao":U THEN ASSIGN pFieldValue = RowObject.agente-retencao.
        WHEN "calcula-multa":U THEN ASSIGN pFieldValue = RowObject.calcula-multa.
        WHEN "contrib-icms":U THEN ASSIGN pFieldValue = RowObject.contrib-icms.
        WHEN "emite-bloq":U THEN ASSIGN pFieldValue = RowObject.emite-bloq.
        WHEN "emite-etiq":U THEN ASSIGN pFieldValue = RowObject.emite-etiq.
        WHEN "forn-exp":U THEN ASSIGN pFieldValue = RowObject.forn-exp.
        WHEN "gera-ad":U THEN ASSIGN pFieldValue = RowObject.gera-ad.
        WHEN "ind-apr-cred":U THEN ASSIGN pFieldValue = RowObject.ind-apr-cred.
        WHEN "ind-cred-abat":U THEN ASSIGN pFieldValue = RowObject.ind-cred-abat.
        WHEN "ind-fat-par":U THEN ASSIGN pFieldValue = RowObject.ind-fat-par.
        WHEN "ind-lib-estoque":U THEN ASSIGN pFieldValue = RowObject.ind-lib-estoque.
        WHEN "ind-licenciador":U THEN ASSIGN pFieldValue = RowObject.ind-licenciador.
        WHEN "ind-rendiment":U THEN ASSIGN pFieldValue = RowObject.ind-rendiment.
        WHEN "item-cli":U THEN ASSIGN pFieldValue = RowObject.item-cli.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "percepcao":U THEN ASSIGN pFieldValue = RowObject.percepcao.
        WHEN "prog-emit":U THEN ASSIGN pFieldValue = RowObject.prog-emit.
        WHEN "recebe-inf-sci":U THEN ASSIGN pFieldValue = RowObject.recebe-inf-sci.
/*        WHEN "vencto-dia-nao-util":U THEN ASSIGN pFieldValue = RowObject.vencto-dia-nao-util.*/ /*Este campo necessita de pre-processador*/
        &if "{&bf_mat_versao_ems}" >= "2.07" &then
            WHEN "log-possui-nf-eletro" THEN ASSIGN pFieldValue = RowObject.log-possui-nf-eletro. 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToCGC DBOProgram 
PROCEDURE goToCGC :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no CGC do emitente
  Parameters:  recebe valor do campo des_cgc_transp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdes_cgc_transp LIKE emitente.cgc NO-UNDO.

    FIND FIRST bfemitente WHERE 
        bfemitente.cgc = pdes_cgc_transp NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfemitente THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfemitente)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ­ndice codigo
  Parameters:  
               recebe valor do campo cod-emitente
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-emitente LIKE emitente.cod-emitente NO-UNDO.

    FIND FIRST bfemitente WHERE 
        bfemitente.cod-emitente = pcod-emitente NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfemitente THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfemitente)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToNome-abrev DBOProgram 
PROCEDURE goToNome-abrev :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ­ndice nome
  Parameters:  
               recebe valor do campo nome-abrev
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnome-abrev LIKE emitente.nome-abrev NO-UNDO.

    FIND FIRST bfemitente WHERE 
        bfemitente.nome-abrev = pnome-abrev NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfemitente THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfemitente)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToNomeIdentif DBOProgram 
PROCEDURE goToNomeIdentif :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no Nome e da Identifica»’o
  Parameters:  
               recebe valor do campo nome-abrev e identifica»’o
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnome-abrev LIKE emitente.nome-abrev NO-UNDO.
    
    FIND FIRST bfemitente WHERE 
        bfemitente.nome-abrev = pnome-abrev AND
        bfemitente.identific  <> 2 NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfemitente THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfemitente)).
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
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
 DEF INPUT PARAM piQueryNumber AS INT NO-UNDO.

 CASE piQueryNumber:
     WHEN 38 THEN
         RUN openQueryStatic ("ZoomRanges":U).
     WHEN 43 THEN
         RUN openQueryStatic ("RepresFixed":U).
 END CASE.
 
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCliente DBOProgram 
PROCEDURE openQueryCliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF cCodEmitente <> "" THEN
    OPEN QUERY qr{&tableName} FOR EACH {&tableName} WHERE 
                 {&tableName}.cod-emitente = int(cCodEmitente) AND
                 {&tablename}.identific <> 2 NO-LOCK INDEXED-REPOSITION.
  ELSE
    OPEN QUERY qr{&tableName} FOR EACH {&tableName} WHERE
                 {&tablename}.identific <> 2 NO-LOCK INDEXED-REPOSITION.


  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryClienteRepres DBOProgram 
PROCEDURE openQueryClienteRepres :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN findPerfilUsuar.

  IF cCodEmitente <> "" THEN
    OPEN QUERY qr{&tableName} FOR EACH {&tableName} WHERE
                 {&tableName}.cod-rep = int(cCodigoRep) AND
                 {&tableName}.cod-emitente = int(cCodEmitente) AND
                 {&tablename}.identific <> 2 NO-LOCK INDEXED-REPOSITION.
  ELSE
    OPEN QUERY qr{&tableName} FOR EACH {&tableName} WHERE
                 {&tableName}.cod-rep = int(cCodigoRep) AND
                 {&tablename}.identific <> 2 NO-LOCK INDEXED-REPOSITION.


  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEmitente DBOProgram 
PROCEDURE openQueryEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF cCodEmitente <> "" THEN
    OPEN QUERY qr{&tableName} FOR EACH {&tableName} WHERE 
                 {&tableName}.cod-emitente = int(cCodEmitente) AND
                 {&tablename}.identific <> 1 NO-LOCK INDEXED-REPOSITION.
  ELSE
    OPEN QUERY qr{&tableName} FOR EACH {&tableName} WHERE
                 {&tablename}.identific <> 1 NO-LOCK INDEXED-REPOSITION.

  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCategoria DBOProgram 
PROCEDURE openQueryCategoria :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE BUFFER bfEmitente FOR emitente.

  DEFINE VARIABLE i-num-meses-sem-compra AS INTEGER  NO-UNDO. 
  DEFINE VARIABLE iCodRep AS INTEGER     NO-UNDO.
  DEFINE VARIABLE qry AS HANDLE      NO-UNDO.
 
  DEFINE  QUERY findCustomersBySalesChannel
      FOR emitente,
          tt-clientes-repres.

  RUN findPerfilUsuar.

  ASSIGN filtro = iCategoria <> 3.

  ASSIGN iCodRep = INTEGER(cCodigoRep) NO-ERROR.

  RUN getCustomerBySalesChannel(INPUT cCodigoRep, INPUT-OUTPUT TABLE tt-clientes-repres).

  FOR EACH  bfEmitente NO-LOCK
      WHERE bfEmitente.cod-rep EQ iCodRep:

      CREATE tt-clientes-repres.
      ASSIGN tt-clientes-repres.cod-emitente = bfEmitente.cod-emitente.
  END.
  
  //IF cWhereRep <> "" THEN
    //ASSIGN cri = cri + cWhereRep.

    /*IF CAN-FIND(FIRST user-coml WHERE user-coml.usuario = c-seg-usuario AND user-coml.idi-niv-aces = 1)
    THEN ASSIGN companyUsesSalesTeam = FALSE.
    ELSE DO:
        RUN hbbo/boHierTime.p PERSISTENT SET h-boCrmHier.

        RUN ReturnUseHier IN h-boCrmHier(OUTPUT companyUsesSalesTeam).

        IF companyUsesSalesTeam = TRUE THEN DO:

           IF criteria = "" THEN DO:
               RUN UseParamEms IN h-boCrmHier.
               RUN setUserPortlet IN h-boCrmHier.
           END.

           RUN returnCustomersByHierarchy(INPUT iHierarchy, INPUT iHierarchyType). 

        END.
        IF VALID-HANDLE(h-boCrmHier) THEN DO:
            DELETE PROCEDURE h-boCrmHier.
            ASSIGN h-boCrmHier = ?.
        END.
    END.*/

    //qry = QUERY qr{&tableName}:HANDLE.
    qry = QUERY findCustomersBySalesChannel:HANDLE. 
    /* faz a abertura da query dinamicamente considerando o criterio enviado pelo java 
    
    se for enviado o criterio em branco vai executar: for each emitente where emitente.identific <> 2
    se for enviado o criterio: estado = "BA" vai executar: for each emitente where emitente.identific <> 2 and estado = "BA"
    */

    qry:QUERY-PREPARE("for each emitente where emitente.identific <> 2, FIRST tt-clientes-repres WHERE tt-clientes-repres.cod-emitente EQ emitente.cod-emitente":U).
    qry:QUERY-OPEN().

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCategoriaOrderAdder DBOProgram 
PROCEDURE openQueryCategoriaOrderAdder :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i-num-meses-sem-compra AS INTEGER  NO-UNDO.
  
  ASSIGN filtro = iCategoria <> 3.

  DEFINE VARIABLE cri AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE qry AS HANDLE      NO-UNDO.

  IF criteria <> "" THEN
      cri = " and ":U + criteria.
  
  /*
  IF CAN-FIND(FIRST user-coml WHERE user-coml.usuario = c-seg-usuario AND user-coml.idi-niv-aces = 1)
  THEN ASSIGN companyUsesSalesTeam = FALSE.
  ELSE DO:
        RUN hbbo/boHierTime.p PERSISTENT SET h-boCrmHier.
        
        RUN ReturnUseHier IN h-boCrmHier(OUTPUT companyUsesSalesTeam).
        
        IF companyUsesSalesTeam = TRUE THEN DO:

            IF criteria = "" THEN DO:
                /*RUN UseParamEms IN h-boCrmHier.*/
                RUN setUserPortlet IN h-boCrmHier.
            END.
                                                                                             
            RUN returnCustomersByHierarchy(INPUT iHierarchy, INPUT iHierarchyType). 
                                                                                             
        END.
        IF VALID-HANDLE(h-boCrmHier) THEN DO:
            DELETE PROCEDURE h-boCrmHier.
            ASSIGN h-boCrmHier = ?.
        END.
  END.
  */  

    qry = QUERY qr{&tableName}:HANDLE.
    /* faz a abertura da query dinamicamente considerando o criterio enviado pelo java 
       
    se for enviado o criterio em branco vai executar: for each emitente where emitente.identific <> 2
    se for enviado o criterio: estado = "BA" vai executar: for each emitente where emitente.identific <> 2 and estado = "BA"
    */

    qry:QUERY-PREPARE("for each emitente where emitente.identific <> 2 ":U + cri).
    qry:QUERY-OPEN().

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaCGC DBOProgram 
PROCEDURE openQueryFaixaCGC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

            open query qr{&tableName} for each {&tableName} no-lock 
            where {&tableName}.cgc >= c-cgc-ini
            and   {&tableName}.cgc <= c-cgc-fim
            and   {&tableName}.cod-emitente >= i-cod-emitente-ini
            and   {&tableName}.cod-emitente <= i-cod-emitente-fim
            and   {&tableName}.cod-rep      >= i-cod-rep-ini
            and   {&tableName}.cod-rep      <= i-cod-rep-fim             
            AND   ({&tablename}.identific = 1
            OR     {&tablename}.identific = 3 )
            by    {&tableName}.cgc.
                                               

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaEmitente DBOProgram 
PROCEDURE openQueryFaixaEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

            open query qr{&tableName} for each {&tableName} no-lock 
            where {&tableName}.cod-emitente >= i-cod-emitente-ini
            and   {&tableName}.cod-emitente <= i-cod-emitente-fim
            and   {&tableName}.cod-rep      >= i-cod-rep-ini
            and   {&tableName}.cod-rep      <= i-cod-rep-fim 
            AND   ({&tablename}.identific = 1
            OR     {&tablename}.identific = 3 )
            by    {&tableName}.cod-emitente.

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaGrupo DBOProgram 
PROCEDURE openQueryFaixaGrupo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

            open query qr{&tableName} for each {&tableName} no-lock 
            where {&tableName}.cod-gr-cli >= i-cod-gr-cli-ini
            and   {&tableName}.cod-gr-cli <= i-cod-gr-cli-fim
            and   {&tableName}.cod-emitente >= i-cod-emitente-ini
            and   {&tableName}.cod-emitente <= i-cod-emitente-fim
            and   {&tableName}.cod-rep      >= i-cod-rep-ini
            and   {&tableName}.cod-rep      <= i-cod-rep-fim             
            AND   ({&tablename}.identific = 1
            OR     {&tablename}.identific = 3 )
            by    {&tableName}.cod-gr-cli.
                                               

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaNomeAbrev DBOProgram 
PROCEDURE openQueryFaixaNomeAbrev :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

            open query qr{&tableName} for each {&tableName} no-lock 
            where {&tableName}.nome-abrev >= c-nome-abrev-ini
            and   {&tableName}.nome-abrev <= c-nome-abrev-fim
            and   {&tableName}.cod-emitente >= i-cod-emitente-ini
            and   {&tableName}.cod-emitente <= i-cod-emitente-fim
            and   {&tableName}.cod-rep      >= i-cod-rep-ini
            and   {&tableName}.cod-rep      <= i-cod-rep-fim 
            AND   ({&tablename}.identific = 1
            OR     {&tablename}.identific = 3 )
            by    {&tableName}.nome-abrev.
                                               

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaNomeEmit DBOProgram 
PROCEDURE openQueryFaixaNomeEmit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

            open query qr{&tableName} for each {&tableName} no-lock 
            where {&tableName}.nome-emit >= c-nome-emit-ini
            and   {&tableName}.nome-emit <= c-nome-emit-fim
            and   {&tableName}.cod-emitente >= i-cod-emitente-ini
            and   {&tableName}.cod-emitente <= i-cod-emitente-fim
            and   {&tableName}.cod-rep      >= i-cod-rep-ini
            and   {&tableName}.cod-rep      <= i-cod-rep-fim             
            AND   ({&tablename}.identific = 1
            OR     {&tablename}.identific = 3 )
            by    {&tableName}.nome-emit.
                                               

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  open query qr{&tableName} for each {&tableName} 
       no-lock 
       indexed-reposition.

  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findFirstMain DBOProgram 
PROCEDURE findFirstMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST {&tableName} NO-LOCK NO-ERROR.
     
    RETURN "OK":U  .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findLastMain DBOProgram 
PROCEDURE findLastMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND LAST {&tableName} NO-LOCK NO-ERROR.

    RETURN "OK":U  .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNextMain DBOProgram 
PROCEDURE findNextMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND NEXT {&tableName} NO-LOCK NO-ERROR.
     
    RETURN "OK":U  .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPrevMain DBOProgram 
PROCEDURE findPrevMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND PREV {&tableName} NO-LOCK NO-ERROR.

    RETURN "OK":U  .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRepresFixed DBOProgram 
PROCEDURE openQueryRepresFixed :
/*------------------------------------------------------------------------------
  Purpose:  
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    if i-ordena = 1 then do:
        {adbo/boad098na.i2 "cod-emitente"}
    end.    
    if i-ordena = 2 then do:
        {adbo/boad098na.i2 "nome-abrev"}
    end.  
    if i-ordena = 3 then do:
        {adbo/boad098na.i2 "cgc"}            
    end.
    if i-ordena = 4 then do:
        {adbo/boad098na.i2 "cod-gr-forn"}            
    end.
    if i-ordena = 5 then do:
        {adbo/boad098na.i2 "nome-matriz"}                        
    end.
    if i-ordena = 6 then do:
        {adbo/boad098na.i2 "nome-emit"}            
    end.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryZoomRanges DBOProgram 
PROCEDURE openQueryZoomRanges :
/*------------------------------------------------------------------------------
  Purpose:  
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    if i-ordena = 1 then do:
       {adbo/boad098na.i1 "cod-emitente"}
    end.
    if i-ordena = 2 then do:
       {adbo/boad098na.i1 "nome-abrev"}              
    end.
    if i-ordena = 3 then do:
       {adbo/boad098na.i1 "cgc"}            
    end.
    if i-ordena = 4 then do:
       {adbo/boad098na.i1 "cod-gr-forn"}
    end.               
    if i-ordena = 5 then do:
       {adbo/boad098na.i1 "nome-matriz"}            
    end.
    if i-ordena = 6 then do:
       {adbo/boad098na.i1 "nome-emit"}            
    end.
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornacamposdistemitente DBOProgram 
PROCEDURE retornacamposdistemitente :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no dist-emitente do emitente
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    &IF DEFINED(BF_MAT_BLOQUEIO_FORNEC) &THEN 
        DEFINE OUTPUT PARAMETER pint_situacao    AS INT NO-UNDO.
        DEFINE OUTPUT PARAMETER pdat_dat_vig_ini AS DATE NO-UNDO.
        DEFINE OUTPUT PARAMETER pdat_dat_vig_fim AS DATE NO-UNDO.

        IF AVAIL emitente THEN
           FIND FIRST dist-emitente WHERE dist-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
                IF AVAIL dist-emitente THEN
                   ASSIGN pint_situacao = dist-emitente.idi-sit-fornec
                          pdat_dat_vig_ini = dist-emitente.dat-vigenc-inicial
                          pdat_dat_vig_fim = dist-emitente.dat-vigenc-final. 

       RETURN "OK":U.
    &ENDif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint28 DBOProgram 
PROCEDURE setConstraint28 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

   def input parameter p-cod-emitente-ini     as int no-undo.
   def input parameter p-cod-emitente-fim     as int no-undo.
   def input parameter p-nome-abrev-ini       as char no-undo.
   def input parameter p-nome-abrev-fim       as char no-undo.
   def input parameter p-cgc-ini              as char no-undo.
   def input parameter p-cgc-fim              as char no-undo.
   def input parameter p-nome-emit-ini        as char no-undo.
   def input parameter p-nome-emit-fim        as char no-undo.
   def input parameter p-cod-gr-cli-ini      as int no-undo.
   def input parameter p-cod-gr-cli-fim      as int no-undo.
   def input parameter p-nome-matriz-ini      as char no-undo.
   def input parameter p-nome-matriz-fim      as char no-undo.
   def input parameter p-ordena               as int  no-undo.   

   assign  i-cod-emitente-ini   = p-cod-emitente-ini
           i-cod-emitente-fim   = p-cod-emitente-fim
           c-nome-abrev-ini     = p-nome-abrev-ini
           c-nome-abrev-fim     = p-nome-abrev-fim
           c-cgc-ini            = p-cgc-ini
           c-cgc-fim            = p-cgc-fim
           c-nome-emit-ini      = p-nome-emit-ini
           c-nome-emit-fim      = p-nome-emit-fim
           i-cod-gr-cli-ini    = p-cod-gr-cli-ini
           i-cod-gr-cli-fim    = p-cod-gr-cli-fim
           c-nome-matriz-ini    = p-nome-matriz-ini
           c-nome-matriz-fim    = p-nome-matriz-fim
           i-ordena             = p-ordena.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint29 DBOProgram 
PROCEDURE setConstraint29 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
   def input parameter p-cod-emitente-ini     as int no-undo.
   def input parameter p-cod-emitente-fim     as int no-undo.
   def input parameter p-nome-abrev-ini       as char no-undo.
   def input parameter p-nome-abrev-fim       as char no-undo.
   def input parameter p-cgc-ini              as char no-undo.
   def input parameter p-cgc-fim              as char no-undo.
   def input parameter p-nome-emit-ini        as char no-undo.
   def input parameter p-nome-emit-fim        as char no-undo.
   def input parameter p-cod-gr-cli-ini      as int no-undo.
   def input parameter p-cod-gr-cli-fim      as int no-undo.
   def input parameter p-nome-matriz-ini      as char no-undo.
   def input parameter p-nome-matriz-fim      as char no-undo.
   def input parameter p-ordena               as int  no-undo.   
   def input parameter p-cod-repre            as int  no-undo.   

   assign  i-cod-emitente-ini   = p-cod-emitente-ini
           i-cod-emitente-fim   = p-cod-emitente-fim
           c-nome-abrev-ini     = p-nome-abrev-ini
           c-nome-abrev-fim     = p-nome-abrev-fim
           c-cgc-ini            = p-cgc-ini
           c-cgc-fim            = p-cgc-fim
           c-nome-emit-ini      = p-nome-emit-ini
           c-nome-emit-fim      = p-nome-emit-fim
           i-cod-gr-cli-ini     = p-cod-gr-cli-ini
           i-cod-gr-cli-fim     = p-cod-gr-cli-fim
           c-nome-matriz-ini    = p-nome-matriz-ini
           c-nome-matriz-fim    = p-nome-matriz-fim
           i-ordena             = p-ordena
           i-cod-repre          = p-cod-repre.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEmitente DBOProgram 
PROCEDURE setConstraintEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pCodEmitente AS CHARACTER NO-UNDO.

    ASSIGN cCodEmitente = pCodEmitente.

END PROCEDURE.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCategoria DBOProgram 
PROCEDURE setConstraintCategoria :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER piCategoria    AS INT NO-UNDO.
    DEFINE INPUT  PARAMETER pcriteria     AS CHARACTER   NO-UNDO.


    /* se precisar, entao apos chamar o setConstraintCategoria, chamar tbm o setContraintHierarquia
    DEFINE INPUT PARAMETER pHierarchy     AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER pHierarchyType AS INTEGER NO-UNDO.
    */

    ASSIGN iCategoria = piCategoria
           criteria   = pcriteria.

END PROCEDURE.
              
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/*
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintIgnoreHierarchy DBOProgram 
PROCEDURE setConstraintIgnoreHierarchy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:      Para ignorar a hierarquia 
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pIgnoreHier    AS LOGICAL NO-UNDO.


    /* se precisar, entao apos chamar o setConstraintCategoria, chamar tbm o setContraintHierarquia
    DEFINE INPUT PARAMETER pHierarchy     AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER pHierarchyType AS INTEGER NO-UNDO.
    */

    ASSIGN ignoreHierarchy = pIgnoreHier.

END PROCEDURE.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaCGC DBOProgram 
PROCEDURE setConstraintFaixaCGC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param p-cgc-ini            as char no-undo.
   def input param p-cgc-fim            as char no-undo.
   def input param p-cod-emitente-ini   as int no-undo.
   def input param p-cod-emitente-fim   as int no-undo.
   def input param p-cod-rep-ini        as int no-undo.
   def input param p-cod-rep-fim        as int no-undo. 
      
   assign c-cgc-ini          = p-cgc-ini
          c-cgc-fim          = p-cgc-fim
          i-cod-emitente-ini = p-cod-emitente-ini
          i-cod-emitente-fim = p-cod-emitente-fim
          i-cod-rep-ini      = p-cod-rep-ini
          i-cod-rep-fim      = p-cod-rep-fim.
          

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaEmitente DBOProgram 
PROCEDURE setConstraintFaixaEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param p-cod-emitente-ini   as int no-undo.
   def input param p-cod-emitente-fim   as int no-undo.
   def input param p-cod-rep-ini        as int no-undo.
   def input param p-cod-rep-fim        as int no-undo.   
   
   assign i-cod-emitente-ini = p-cod-emitente-ini
          i-cod-emitente-fim = p-cod-emitente-fim
          i-cod-rep-ini      = p-cod-rep-ini
          i-cod-rep-fim      = p-cod-rep-fim.
          

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaGrupo DBOProgram 
PROCEDURE setConstraintFaixaGrupo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param p-cod-gr-cli-ini     as int no-undo.
   def input param p-cod-gr-cli-fim     as int no-undo.
   def input param p-cod-emitente-ini   as int no-undo.
   def input param p-cod-emitente-fim   as int no-undo.
   def input param p-cod-rep-ini        as int no-undo.
   def input param p-cod-rep-fim        as int no-undo. 
   
   assign i-cod-gr-cli-ini   = p-cod-gr-cli-ini
          i-cod-gr-cli-fim   = p-cod-gr-cli-fim
          i-cod-emitente-ini = p-cod-emitente-ini
          i-cod-emitente-fim = p-cod-emitente-fim
          i-cod-rep-ini      = p-cod-rep-ini
          i-cod-rep-fim      = p-cod-rep-fim.
          

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaNomeAbrev DBOProgram 
PROCEDURE setConstraintFaixaNomeAbrev :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param p-nome-abrev-ini     as char no-undo.
   def input param p-nome-abrev-fim     as char no-undo.
   def input param p-cod-emitente-ini   as int  no-undo.
   def input param p-cod-emitente-fim   as int  no-undo.
   def input param p-cod-rep-ini        as int  no-undo.
   def input param p-cod-rep-fim        as int  no-undo. 
      
   assign c-nome-abrev-ini   = p-nome-abrev-ini
          c-nome-abrev-fim   = p-nome-abrev-fim
          i-cod-emitente-ini = p-cod-emitente-ini
          i-cod-emitente-fim = p-cod-emitente-fim
          i-cod-rep-ini      = p-cod-rep-ini
          i-cod-rep-fim      = p-cod-rep-fim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaNomeEmit DBOProgram 
PROCEDURE setConstraintFaixaNomeEmit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param p-nome-emit-ini      as char no-undo.
   def input param p-nome-emit-fim      as char no-undo.
   def input param p-cod-emitente-ini   as int no-undo.
   def input param p-cod-emitente-fim   as int no-undo.
   def input param p-cod-rep-ini        as int no-undo.
   def input param p-cod-rep-fim        as int no-undo. 
   
   assign c-nome-emit-ini = p-nome-emit-ini
          c-nome-emit-fim = p-nome-emit-fim
          i-cod-emitente-ini = p-cod-emitente-ini
          i-cod-emitente-fim = p-cod-emitente-fim
          i-cod-rep-ini      = p-cod-rep-ini
          i-cod-rep-fim      = p-cod-rep-fim.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDeleteFrotas DBOProgram 
PROCEDURE validateDeleteFrotas:
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    define variable h-abapi008 as handle  no-undo.
    define variable iErro      as integer no-undo.
    define variable lValida    as logical no-undo.
    define variable i-cont     as integer no-undo.

    assign lValida = no.
    do i-cont = 1 to 4:
        run cdp/cd9902.p (input i-cont).
        if return-value = "OK":U then do:
            assign lValida = yes.
            leave.
        end.
    end.
    if lValida then do:
        /** Passa o rowid para API de Frotas **/
        run abp/abapi008.p persistent set h-abapi008 (input RowObject.r-rowid).
        /** Valida»„es de Frotas **/
        run validateEmitente in h-abapi008 (RowObject.cod-emitente).
        if return-value = "NOK":U then do:
            empty temp-table RowErrorsFrotas.
            /** Busca os erros ocorridos em frotas **/
            run getRowErrors in h-abapi008 (output table RowErrorsFrotas).
            assign iErro = 0.
            /** Se ocorreram erros noproduto padr’o, busca a œltima sequ¼ncia **/
            for last RowErrors no-lock:
                assign iErro = RowErrors.ErrorSequence.
            end.
            /** Percorre os erros ocorridos em frotas **/
            for each RowErrorsFrotas no-lock:
                /** Cria os erros no produto padr’o **/
                create RowErrors.
                buffer-copy RowErrorsFrotas except ErrorSequence to RowErrors
                    assign RowErrors.ErrorSequence = iErro + 1
                           iErro                   = RowErrors.ErrorSequence.
            end.
            empty temp-table RowErrorsFrotas.
        end.
        /** Elimina a API da mem½ria **/
        if valid-handle(h-abapi008) then
            delete procedure h-abapi008.
    end.

    return "OK":U.
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

    DEFINE VARIABLE lEms5            AS LOGICAL     NO-UNDO.

    IF not avail param-global then
        find first param-global no-lock no-error.
    
    // remove extensao do emitente
    for  first dist-emitente exclusive-lock 
         where dist-emitente.cod-emitente = RowObject.cod-emitente:
         
        delete dist-emitente. 
    end.
     
    for first est-ap EXCLUSIVE-LOCK
        where est-ap.cod-fornec = RowObject.cod-emitente:
        
        delete est-ap.
    end.

    for each  his-emit  exclusive-lock
        where his-emit.cod-emitente = RowObject.cod-emitente :
        
        delete his-emit.
    end.
    
    for each  cont-emit exclusive-lock  
        where cont-emit.cod-emitente = RowObject.cod-emitente:
        
         if cont-emit.identific = 2 then 
            delete cont-emit.
         if cont-emit.identific = 3 then
            assign cont-emit.identific = 1.                
    end.
    
    /*verifica‡Æo parƒmetros para integra‡Æo com o EMS5*/
    IF param-global.log-2 eq true THEN DO:
    
        IF RowObject.identific eq 2 THEN DO:
            //fornecedor
            find first funcao no-lock
                 where funcao.cd-funcao = "adm-cdf-ems-5.00" no-error.
        END.
        else do:
            //cliente, ambos
            find first funcao no-lock
                 where funcao.cd-funcao = "adm-cdc-ems-5.00" no-error.
            
        end.
        
        IF avail funcao THEN DO:
            assign lEms5 = true when (funcao.ativo and funcao.log-1).    
        END.
        
        IF lEms5 THEN DO:
            run cdp/cd1608.p (input RowObject.cod-emitente,
                              input RowObject.cod-emitente,
                              input RowObject.identific,
                              input yes,
                              input 2,
                              input 0,
                              input "",
                              input "Arquivo",
                              input "").            
        END.
        
    END.    

    if fn-has-row-errors() then
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piIntegracao V-table-Win 
PROCEDURE piIntegracao private:
/* -----------------------------------------------------------
  Purpose: Api para integra¯´es    
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE h-ut-integration AS HANDLE      NO-UNDO.

    RUN utp/ut-integration.p PERSISTENT SET h-ut-integration.
    RUN eai-integration IN h-ut-integration (INPUT "Customer",    /* Nome da transa¯Êo     */
                                             INPUT ROWID(RowObject),   /* Registro da transa¯Êo */
                                             INPUT pType,              /* Evento da transa¯Êo   */
                                             OUTPUT TABLE RowErrors).  /* Erros da transa¯Êo    */
                                             
    DELETE PROCEDURE h-ut-integration NO-ERROR.

    if fn-has-row-errors() then
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDeleteCustomer DBOProgram 
PROCEDURE validateDeleteCustomer private:

     for  first bf{&tableName} 
          where bf{&TableName}.nome-abrev  ne RowObject.nome-abrev
            and bf{&TableName}.nome-matriz =  RowObject.nome-abrev
            and bf{&TableName}.identific   ne 1 no-lock:
         
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Fornecedor" *}
        
        {method/svc/errors/inserr.i
            &ErrorNumber="81" 
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorParameters=trim(return-value)}
            
     end.
     
    if fn-has-row-errors() then
        RETURN "NOK":U.
        
    run pi-valida-eliminacao in this-procedure. 
    
    if fn-has-row-errors() then
        RETURN "NOK":U.    

    /***** ATENCAO - Uso de Pre-processador *******/
    &if defined (bf_dis_desc_bonif) &then  /* pre-processador */   
        run validateRelCustumer in this-procedure.
        
        if fn-has-row-errors() then
            RETURN "NOK":U.        
    &endif /* preprocessador */
    /***** fim - Uso de Pre-processador *******/
        
    run validateDeleteFrotas in this-procedure.
    
    if fn-has-row-errors() then
        RETURN "NOK":U.        

    RETURN "OK":U.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/***** ATENCAO - Uso de Pre-processador *******/
&if defined (bf_dis_desc_bonif) &then  /* pre-processador */   

    procedure validateRelCustumer:
    /*
    Metodo implementado para realizar a validacoes na  eliminacao da tabela emitente e verificar se 
    o emitente estÿ sendo usado nas tabelas desconto, canal-cliente, desconto-valor,
    tem-bonif-cliente .
    */
    
        def var c-texto as char extent 2 no-undo.
        DEFINE VARIABLE i-seq-erro AS INTEGER     NO-UNDO.

        IF not avail(param-global) then
            find first param-global no-lock no-error.
    
        if param-global.modulo-09 then do: /* modulo BN */
        
            if can-find (first desconto 
                         where desconto.cod-emitente       = RowObject.cod-emitente
                            or desconto.cdn-cliente-matriz = RowObject.cod-emitente) then do:
                               
                 /* Emitente possui relacionamentos ativos com desconto.*/                
                 assign i-seq-erro = i-seq-erro + 1.
                 {utp/ut-table.i mgadm {&TABLE-NAME} 1}
                 assign c-texto[1] = return-value.
                 {utp/ut-table.i mgdis desconto 1}
                 assign c-texto[2] = return-value.
               
                {method/svc/errors/inserr.i
                    &ErrorNumber="5" 
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-texto[1] + '~~~~' + c-texto[2]"}                
                
            end.
    
            if can-find (first canal-cliente where 
                               canal-cliente.cod-emitente = RowObject.cod-emitente) then do:
                               
                 /* Emitente possui relacionamentos ativos com canal cliente.*/                
                 assign i-seq-erro = i-seq-erro + 1.
                 {utp/ut-table.i mgadm {&TABLE-NAME} 1}
                 assign c-texto[1] = return-value.
                 {utp/ut-table.i mgdis canal-cliente 1}
                 assign c-texto[2] = return-value.
               
                {method/svc/errors/inserr.i
                    &ErrorNumber="5" 
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-texto[1] + '~~~~' + c-texto[2]"}                                                                
                      
            end.

            if can-find (first desconto-valor where 
                               desconto-valor.cdn-cliente = RowObject.cod-emitente) then do:  
                                                              
                 /* Emitente possui relacionamentos ativos com desconto valor.*/                
                 assign i-seq-erro = i-seq-erro + 1.
                 {utp/ut-table.i mgadm {&TABLE-NAME} 1}
                 assign c-texto[1] = return-value.
                 {utp/ut-table.i mgdis desconto-valor 1}
                 assign c-texto[2] = return-value.
               
                {method/svc/errors/inserr.i
                    &ErrorNumber="5" 
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-texto[1] + '~~~~' + c-texto[2]"}                                
                      
            end.

            if can-find (first item-bonif-cliente where 
                               item-bonif-cliente.cdn-cliente = RowObject.cod-emitente) then do:
                               
                 /* Item Bonif Cliente possui relacionamentos ativos com Desconto Valor. */                  
                 assign i-seq-erro = i-seq-erro + 1.
                 {utp/ut-table.i mgadm {&TABLE-NAME} 1}
                 assign c-texto[1] = return-value.
                 {utp/ut-table.i mgdis item-bonif-cliente 1}
                 assign c-texto[2] = return-value.
               
                {method/svc/errors/inserr.i
                    &ErrorNumber="5" 
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-texto[1] + '~~~~' + c-texto[2]"}
                      
            end.

        end. /* param-global */
        
        if fn-has-row-errors() then
            RETURN "NOK":U.
            
    end procedure.
    
&endif /* preprocessador */
/***** fim - Uso de Pre-processador *******/ 

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-eliminacao DBOProgram 
PROCEDURE pi-valida-eliminacao:

    {database/tgad/tdp/tdad098.i01}
    
    IF length(c-relacionados) > 0 THEN DO:
          {method/svc/errors/inserr.i
                    &ErrorNumber="5" 
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-label-tabela + '~~~~' + c-relacionados"}          
    END.  
  
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
    
    IF not avail param-global then
        find first param-global no-lock no-error.    

    if pType = "Delete":U then do:
    
        run validateDeleteCustomer in this-procedure.
        
        if fn-has-row-errors() then
            RETURN "NOK":U.
            
        run piIntegracao in this-procedure(input pType).
        
        if fn-has-row-errors() then
            RETURN "NOK":U.        
            
    end.
    else do: //create or update
        assign RowObject.ramal = fnConsisteCampoRamalCliente(RowObject.ramal).
        
        if fn-has-row-errors() then
            RETURN "NOK":U. 
            
        IF RowObject.categoria EQ ? THEN
            ASSIGN RowObject.categoria = ''.
            
        IF LENGTH(RowObject.categoria) > 3 THEN DO:
            {method/svc/errors/inserr.i
                    &ErrorNumber="58311"
                    &ErrorSubType="ERROR"
                    &ErrorType="EMS2"}            
        END.
    end.
    
    if fn-has-row-errors() then
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionToRecNo DBOProgram 
PROCEDURE repositionToRecNo :
    
    DEFINE INPUT PARAMETER registronum AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER recrowid AS ROWID       NO-UNDO.

    GET FIRST {&QueryName} NO-LOCK.

    REPOSITION {&QueryName} FORWARD registronum.

    GET PREV {&QueryName} NO-LOCK.

    recrowid = ROWID(emitente).
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnQueryNumresults DBOProgram 
PROCEDURE returnQueryNumresults :
    
    DEFINE OUTPUT PARAMETER pnumresults AS INTEGER       NO-UNDO.

    GET FIRST {&QueryName} NO-LOCK.

    pnumresults = 0.
    DO WHILE AVAILABLE(emitente):

        pnumresults = pnumresults + 1.
        GET NEXT {&QueryName} NO-LOCK.
    END. 

    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnRowids DBOProgram 
PROCEDURE returnRowids :
    
    DEFINE OUTPUT PARAMETER TABLE FOR ttListaRowid.

    RUN desativaLog.

    IF companyUsesSalesTeam AND criteria = "" THEN DO: /* quando nÆo tem criterio ignora query */
        
        FOR EACH dist-emitente WHERE dist-emitente.idi-niv-aces = 1 AND dist-emitente.cod-usuar-respons = c-seg-usuario NO-LOCK,
            FIRST emitente WHERE emitente.cod-emitente = dist-emitente.cod-emitente NO-LOCK:
            
            CREATE ttListaRowid.
            ASSIGN ttListaRowid.uid = String(ROWID(emitente)).

        END.

        FOR EACH tt-cta_usuar WHERE tt-cta_usuar.cod_pessoa_erp <> "", FIRST emitente WHERE emitente.cod-emitente = int(tt-cta_usuar.cod_pessoa_erp) NO-LOCK:
            CREATE ttListaRowid.
            ASSIGN ttListaRowid.uid = String(ROWID(emitente)).

        END.

        RUN ativaLog.

        RETURN "OK":U.
    
    END.


    GET FIRST {&QueryName} NO-LOCK.

    EMPTY TEMP-TABLE ttListaRowid.

    DO WHILE AVAILABLE(emitente):
        CREATE ttListaRowid.
        ASSIGN ttListaRowid.uid = String(ROWID(emitente)).
       
        GET NEXT {&QueryName} NO-LOCK.
    END. 

    RUN ativaLog.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnEmitentesByRowids DBOProgram 
PROCEDURE returnEmitentesByRowids :
    
    DEFINE INPUT PARAMETER TABLE FOR ttListaRowid.
    DEFINE OUTPUT PARAMETER TABLE FOR RowObject.

    RUN desativaLog.


    FOR EACH ttListaRowid:
        FIND emitente WHERE ROWID(emitente) = TO-ROWID(ttListaRowid.uid) NO-LOCK NO-ERROR.
        IF AVAIL emitente THEN DO:
            CREATE RowObject.
            BUFFER-COPY emitente TO RowObject.

            /* PCREQ-9042 - Portador do Emitente */
            assign i-portador      = emitente.portador
                   i-modalidade    = emitente.modalidade
                   i-port-prefer   = emitente.port-prefer
                   i-mod-prefer    = emitente.mod-prefer
                   i-portador-ap   = emitente.portador-ap
                   i-modalidade-ap = emitente.modalidade-ap.

            if l-fn-port-emitente then do:

                run prgint/ufn/ufn008za.py persistent set h-api.
                if valid-handle(h-api) then do:
                    empty temp-table tt_log_erro.
                    run pi_busca_dados_portador_fin in h-api (input "",
                                                              input i-portador,
                                                              input i-modalidade,
                                                              input emitente.cod-emitente,
                                                              input "Cliente":U,
                                                              input "":U,
                                                              output i-portador,
                                                              output i-modalidade,
                                                              output table tt_log_erro).
                    if log-manager:logging-level > 2 then do:
                        for each tt_log_erro:
                            log-manager:write-message("Portador do Cliente", "UFN008ZA":U).
                            log-manager:write-message("C¢digo do Erro: ":U + string(tt_log_erro.ttv_num_cod_erro), "UFN008ZA":U).
                            log-manager:write-message("Mensagem......: ":U + tt_log_erro.ttv_des_msg_erro        , "UFN008ZA":U).
                            log-manager:write-message("Ajuda.........: ":U + tt_log_erro.ttv_des_msg_ajuda       , "UFN008ZA":U).
                        end.
                    end.
                    empty temp-table tt_log_erro.
                    run pi_busca_dados_portador_fin in h-api (input "",
                                                              input i-port-prefer,
                                                              input i-mod-prefer,
                                                              input emitente.cod-emitente,
                                                              input "Cliente":U,
                                                              input "Prefer":U,
                                                              output i-port-prefer,
                                                              output i-mod-prefer,
                                                              output table tt_log_erro).
                    if log-manager:logging-level > 2 then do:
                        for each tt_log_erro:
                            log-manager:write-message("Portador Preferencial do Cliente", "UFN008ZA":U).
                            log-manager:write-message("C¢digo do Erro: ":U + string(tt_log_erro.ttv_num_cod_erro), "UFN008ZA":U).
                            log-manager:write-message("Mensagem......: ":U + tt_log_erro.ttv_des_msg_erro        , "UFN008ZA":U).
                            log-manager:write-message("Ajuda.........: ":U + tt_log_erro.ttv_des_msg_ajuda       , "UFN008ZA":U).
                        end.
                    end.
                    empty temp-table tt_log_erro.
                    run pi_busca_dados_portador_fin in h-api (input "",
                                                              input i-portador-ap,
                                                              input i-modalidade-ap,
                                                              input emitente.cod-emitente,
                                                              input "Fornecedor":U,
                                                              input "":U,
                                                              output i-portador-ap,
                                                              output i-modalidade-ap,
                                                              output table tt_log_erro).
                    if log-manager:logging-level > 2 then do:
                        for each tt_log_erro:
                            log-manager:write-message("Portador do Fornecedor", "UFN008ZA":U).
                            log-manager:write-message("C¢digo do Erro: ":U + string(tt_log_erro.ttv_num_cod_erro), "UFN008ZA":U).
                            log-manager:write-message("Mensagem......: ":U + tt_log_erro.ttv_des_msg_erro        , "UFN008ZA":U).
                            log-manager:write-message("Ajuda.........: ":U + tt_log_erro.ttv_des_msg_ajuda       , "UFN008ZA":U).
                        end.
                    end.
                    delete procedure h-api.
                end.
            end.

            assign RowObject.portador      = i-portador     
                   RowObject.modalidade    = i-modalidade   
                   RowObject.port-prefer   = i-port-prefer  
                   RowObject.mod-prefer    = i-mod-prefer   
                   RowObject.portador-ap   = i-portador-ap  
                   RowObject.modalidade-ap = i-modalidade-ap.

        END.
    END.
    RUN ativaLog.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnQueryNumresults DBOProgram 
PROCEDURE returnNumresultsByCategoria :
    
    DEFINE OUTPUT PARAMETER pativos AS INTEGER       NO-UNDO.
    DEFINE OUTPUT PARAMETER pinativos AS INTEGER       NO-UNDO.



    RUN desativaLog.


    pativos = 0.
    pinativos = 0.

    IF companyUsesSalesTeam AND criteria = "" THEN DO: /* quando nÆo tem criterio ignora query */
        
        FOR EACH dist-emitente WHERE dist-emitente.idi-niv-aces = 1 AND dist-emitente.cod-usuar-respons = c-seg-usuario NO-LOCK,
            FIRST emitente WHERE emitente.cod-emitente = dist-emitente.cod-emitente NO-LOCK:
            
            RUN addAtivosInativos(INPUT-OUTPUT pinativos, INPUT-OUTPUT pativos).

        END.


        FOR EACH tt-cta_usuar WHERE tt-cta_usuar.cod_pessoa_erp <> "", FIRST emitente WHERE emitente.cod-emitente = int(tt-cta_usuar.cod_pessoa_erp) NO-LOCK:
            
            RUN addAtivosInativos(INPUT-OUTPUT pinativos, INPUT-OUTPUT pativos).

        END.

        RUN ativaLog.

        RETURN "OK":U.
    
    END.    

    GET FIRST {&QueryName} NO-LOCK.

    DO WHILE AVAILABLE(emitente):
        
        RUN addAtivosInativos(INPUT-OUTPUT pinativos, INPUT-OUTPUT pativos).
        
        GET NEXT {&QueryName} NO-LOCK.
    END. 


    RUN ativaLog.

    
    RETURN "OK":U.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnQueryNumresults DBOProgram 
PROCEDURE returnNumresultsByCategoriaAndByGrupoCliente :

    DEFINE INPUT  PARAMETER TABLE FOR ttGrupoCliente.
    DEFINE OUTPUT PARAMETER pativos AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pinativos AS INTEGER NO-UNDO.

    RUN desativaLog.

    pativos = 0.
    pinativos = 0.
                         
    IF companyUsesSalesTeam AND criteria = "" THEN DO: /* quando nÆo tem criterio ignora query */
        
        FOR EACH dist-emitente WHERE dist-emitente.idi-niv-aces = 1 AND dist-emitente.cod-usuar-respons = c-seg-usuario NO-LOCK:
            
            FOR EACH ttGrupoCliente:                                    
                FIND FIRST emitente WHERE emitente.cod-gr-cli    = int(ttGrupoCliente.codgrcli)
                                       AND emitente.cod-emitente = dist-emitente.cod-emitente NO-LOCK NO-ERROR.
                IF AVAIL emitente THEN                                                                
                    RUN addAtivosInativos(INPUT-OUTPUT pinativos, INPUT-OUTPUT pativos).              
            END.
                                   
        END.

        FOR EACH tt-cta_usuar WHERE tt-cta_usuar.cod_pessoa_erp <> "" NO-LOCK:
            FOR EACH ttGrupoCliente:                                   
                FIND FIRST emitente WHERE emitente.cod-gr-cli   = int(ttGrupoCliente.codgrcli)
                                      AND emitente.cod-emitente = int(tt-cta_usuar.cod_pessoa_erp) NO-LOCK NO-ERROR.
                IF AVAIL emitente THEN                                                                              
                    RUN addAtivosInativos(INPUT-OUTPUT pinativos, INPUT-OUTPUT pativos).                            
            END.                                   
        END.

        RUN ativaLog.

        RETURN "OK":U.
    
    END.    

    FOR EACH ttGrupoCliente:
        FOR EACH emitente WHERE emitente.cod-gr-cli = int(ttGrupoCliente.codgrcli):
            RUN addAtivosInativos(INPUT-OUTPUT pinativos, INPUT-OUTPUT pativos).
        END.
    END.
   
    RUN ativaLog.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE addAtivosInativos:
    DEFINE INPUT-OUTPUT PARAMETER pinativos AS INTEGER     NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER pativos AS INTEGER     NO-UNDO.

    DEFINE VARIABLE da-ult-ven AS DATE    NO-UNDO.
    DEFINE VARIABLE da-movto AS DATE    NO-UNDO.
    DEFINE VARIABLE i-nr-mesina AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-nr-meses AS INTEGER     NO-UNDO.
    DEFINE VARIABLE l-inativo AS LOGICAL     NO-UNDO.
        /* Este codido estÿ repetido na procedure returnNumresultsByCategoria */

        ASSIGN da-ult-ven  = emitente.data-implant.

        ASSIGN da-movto    = 01/01/1901.
               i-nr-mesina = emitente.nr-mesina.

        &IF DEFINED(bf_resum_emit) &THEN
        &ELSE    
            IF  i-nr-mesina = 0 THEN DO:
                l-inativo = NO.
            END.
            ELSE
        &ENDIF

            DO:
                FOR FIRST estatist FIELDS (estatist.dt-ult-tit) WHERE 
                          estatist.cod-emitente = emitente.cod-emitente NO-LOCK:
                    ASSIGN da-movto = estatist.dt-ult-tit.
                END.

        FOR LAST nota-fiscal FIELDS (nota-fiscal.dt-emis-nota) USE-INDEX ch-emi-nota WHERE 
             nota-fiscal.cod-emitente = emitente.cod-emitente AND 
             nota-fiscal.replica-nf   = NO AND 
             nota-fiscal.dt-cancela   = ? NO-LOCK:
        
                        IF  nota-fiscal.dt-emis-nota > da-movto THEN   
                            ASSIGN da-movto = nota-fiscal.dt-emis-nota.
        END.

                ASSIGN da-ult-ven = IF  da-movto > da-ult-ven 
                                    THEN da-movto 
                                    ELSE da-ult-ven.
    
                ASSIGN i-nr-meses = (YEAR(TODAY)      * 12 + MONTH(TODAY))
                                  - (YEAR(da-ult-ven) * 12 + MONTH(da-ult-ven)) - 1
                       l-inativo  = (i-nr-meses > i-nr-mesina).  
        END.

        IF l-inativo THEN pinativos = pinativos + 1.
        IF NOT l-inativo THEN pativos = pativos + 1.
END PROCEDURE.



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/******
PROCEDURE addAtivosInativos:
    DEFINE INPUT-OUTPUT PARAMETER pinativos AS INTEGER     NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER pativos AS INTEGER     NO-UNDO.

    DEFINE VARIABLE da-ult-ven AS DATE    NO-UNDO.
    DEFINE VARIABLE da-movto AS DATE    NO-UNDO.
    DEFINE VARIABLE i-nr-mesina AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-nr-meses AS INTEGER     NO-UNDO.
    DEFINE VARIABLE l-inativo AS LOGICAL     NO-UNDO.
        /* Este codido estÿ repetido na procedure returnNumresultsByCategoria */

    ASSIGN da-ult-ven  = emitente.data-implant.

    ASSIGN da-movto    = 01/01/1901.
    i-nr-mesina = emitente.nr-mesina.

    &IF DEFINED(bf_resum_emit) &THEN
    &ELSE    
        IF  i-nr-mesina = 0 THEN DO:
            l-inativo = NO.
        END.
        ELSE
    &ENDIF
    
            DO:
                FOR FIRST estatist FIELDS (estatist.dt-ult-tit) WHERE 
                          estatist.cod-emitente = emitente.cod-emitente NO-LOCK:
                    ASSIGN da-movto = estatist.dt-ult-tit.
                END.

                FOR LAST nota-fiscal FIELDS (nota-fiscal.dt-emis-nota) USE-INDEX ch-emi-nota WHERE nota-fiscal.cod-emitente = emitente.cod-emitente
                                                                                               AND nota-fiscal.replica-nf   = NO
                                                                                               AND nota-fiscal.dt-cancela   = ? NO-LOCK:

                    IF  nota-fiscal.dt-emis-nota > da-movto THEN   
                        ASSIGN da-movto = nota-fiscal.dt-emis-nota.

                END.
            END.

            ASSIGN da-ult-ven = IF  da-movto > da-ult-ven THEN da-movto ELSE da-ult-ven.
            ASSIGN i-nr-meses = (YEAR(TODAY)      * 12 + MONTH(TODAY)) - (YEAR(da-ult-ven) * 12 + MONTH(da-ult-ven)) - 1 l-inativo  = (i-nr-meses > i-nr-mesina).

            IF l-inativo THEN pinativos = pinativos + 1.
            IF NOT l-inativo THEN pativos = pativos + 1.

END PROCEDURE.
*****/


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


PROCEDURE findPerfilUsuar:
    
    /* Executar API de forma persistente */
    RUN java/partymanagementservicep.p PERSISTENT SET h-handle.
    
    /* Variavel com o perfil a ser verificado para o usu˜rio corrente */
    ASSIGN cPerfil = "Representante".
    
    /* Executando mýtodo da API que verifica se o usu˜rio corrente ý do
       Perfil informado */
    RUN findCodeByProfile IN h-handle(INPUT cPerfil, OUTPUT cCodigoRep).

   
END PROCEDURE.

PROCEDURE setContraintHierarquia:
    DEFINE INPUT PARAMETER pHierarchy AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER pHierarchyType AS INTEGER NO-UNDO.

    ASSIGN iHierarchy = pHierarchy
           iHierarchyType = pHierarchyType.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram  
PROCEDURE openQueryDefault :
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.
                                      
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


PROCEDURE returnCustomersByHierarchy:
    DEFINE INPUT PARAMETER iHierarchy AS INTEGER.
    DEFINE INPUT PARAMETER iHierarchyType AS INTEGER.
    
    DEFINE VARIABLE l-time AS LOGICAL     NO-UNDO.

    FIND FIRST ped-curva USE-INDEX ch-vlitem
        WHERE ped-curva.vl-aberto = 100342
          AND ped-curva.it-codigo = trim(STRING(iHierarchyType)) + "/" + trim(STRING(iHierarchy)) + "/" + c-seg-usuario 
        NO-LOCK NO-ERROR.

    DEFINE VARIABLE i-hora AS INTEGER     NO-UNDO.

    i-hora = TIME - (60 * 60 * 3). /* 3 horas atras */

    IF NOT AVAIL ped-curva 
       OR ped-curva.data-1 < TODAY
       OR ped-curva.int-1  < i-hora THEN DO:
        
        FOR EACH ped-curva USE-INDEX ch-vlitem
            WHERE ped-curva.vl-aberto = 100342
              AND ped-curva.it-codigo BEGINS trim(STRING(iHierarchyType)) + "/" + trim(STRING(iHierarchy)) + "/" + c-seg-usuario EXCLUSIVE-LOCK:
            DELETE ped-curva.
        END.

        RUN ReturnCustumerList IN h-boCrmHier(INPUT c-seg-usuario,
                                              INPUT iHierarchy,
                                              INPUT iHierarchyType,
                                              OUTPUT l-time,
                                              OUTPUT TABLE tt-cta_usuar).

        CREATE ped-curva.
        ASSIGN ped-curva.vl-aberto = 100342
               ped-curva.it-codigo = trim(STRING(iHierarchyType)) + "/" + trim(STRING(iHierarchy)) + "/" + c-seg-usuario
               ped-curva.int-1 = TIME
               ped-curva.data-1 = TODAY.

        FOR EACH tt-cta_usuar:
            CREATE ped-curva.
            ASSIGN ped-curva.vl-aberto = 100342
                   ped-curva.it-codigo = trim(STRING(iHierarchyType)) + "/" + trim(STRING(iHierarchy)) + "/" + c-seg-usuario + "/" + trim(tt-cta_usuar.cod_pessoa_erp)
                   ped-curva.int-2 = INT(tt-cta_usuar.cod_pessoa_erp)
                   ped-curva.int-1 = 0
                   ped-curva.data-1 = ?.
        END.


    END.
    ELSE DO:

        FOR EACH ped-curva USE-INDEX ch-vlitem
            WHERE ped-curva.vl-aberto = 100342
              AND ped-curva.it-codigo BEGINS trim(STRING(iHierarchyType)) + "/" + trim(STRING(iHierarchy)) + "/" + c-seg-usuario 
              AND ped-curva.int-1 = 0
              AND ped-curva.data-1 = ? NO-LOCK:

            CREATE tt-cta_usuar.
            ASSIGN tt-cta_usuar.cod_pessoa_erp = trim(string(ped-curva.int-2)).
        END.

    END.


END PROCEDURE.

DEFINE VARIABLE savedLogginLevel AS INTEGER     NO-UNDO.
DEFINE VARIABLE savedLogEntryTypes AS CHARACTER   NO-UNDO.

PROCEDURE desativaLog:

    /* Estas procedures permitem desativar e restaurar o log, o motivo ‚ evitar que um processo repetitivo gere LOG com execesso.*/

    savedLogginLevel = LOG-MANAGER:LOGGING-LEVEL.
    savedLogEntryTypes = LOG-MANAGER:LOG-ENTRY-TYPES.

    /*  Se  encontrar "NODeactivateLog" nÆo permite desativar o log */
    IF INDEX(savedLogEntryTypes,"NODeactivateLog") = 0 THEN 
        LOG-MANAGER:LOGGING-LEVEL = 1.  /* Somente logar os erros */


END PROCEDURE.

PROCEDURE ativaLog:

    LOG-MANAGER:LOGGING-LEVEL = savedLogginLevel.
    LOG-MANAGER:LOG-ENTRY-TYPES = savedLogEntryTypes.


END PROCEDURE.

PROCEDURE getCustomerBySalesChannel :
    DEFINE INPUT  PARAMETER cCodigoRep AS CHAR NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER table for  tt-clientes-repres.
        
    FOR EACH canal-cliente 
       WHERE canal-cliente.cod-rep = INT(cCodigoRep) 
         AND canal-cliente.dat-inic-validade <= TODAY 
         AND canal-cliente.dat-fim-validade  >= TODAY NO-LOCK:       
        
        create tt-clientes-repres.
        ASSIGN tt-clientes-repres.cod-emitente = canal-cliente.cod-emitente.        
    END.    
    
END.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord Method-Library 
PROCEDURE beforeCreateRecord PRIVATE:

    DEFINE VARIABLE ie AS CHARACTER INITIAL ?   NO-UNDO.

    //busca e atualiza IE se necessario
    IF (RowObject.natureza EQ 2) AND //se for PJ
       (RowObject.ins-estadual EQ ? OR trim(RowObject.ins-estadual) EQ '') THEN DO:

        RUN getInscEstad IN THIS-PROCEDURE(INPUT RowObject.estado , INPUT RowObject.cgc , OUTPUT ie).
        
        IF ie NE ? THEN
            ASSIGN RowObject.ins-estadual = ie.

        IF (RowObject.cgc EQ RowObject.cgc-cob) AND 
           (RowObject.ins-est-cob EQ ? OR TRIM(RowObject.ins-est-cob) EQ '') THEN
            ASSIGN RowObject.ins-est-cob = RowObject.ins-estadual.        

    END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord Method-Library 
PROCEDURE beforeUpdateRecord PRIVATE:

    DEFINE VARIABLE ie AS CHARACTER INITIAL ?   NO-UNDO.

    //busca e atualiza IE se necessario
    IF (RowObject.natureza EQ 2) AND //se for PJ
       (RowObject.ins-estadual EQ ? OR trim(RowObject.ins-estadual) EQ '') THEN DO:

        RUN getInscEstad IN THIS-PROCEDURE(INPUT RowObject.estado , INPUT RowObject.cgc , OUTPUT ie).
        
        IF ie NE ? THEN
            ASSIGN RowObject.ins-estadual = ie.

        IF (RowObject.cgc EQ RowObject.cgc-cob) AND 
           (RowObject.ins-est-cob EQ ? OR TRIM(RowObject.ins-est-cob) EQ '') THEN
            ASSIGN RowObject.ins-est-cob = RowObject.ins-estadual.        

    END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

PROCEDURE getInscEstad:
    DEFINE INPUT  PARAMETER uf   AS CHARACTER FORMAT 'X(2)'   NO-UNDO.
    DEFINE INPUT  PARAMETER cnpj AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER ie   AS CHARACTER   NO-UNDO.
    
    DEFINE VARIABLE h-api-sintegra AS HANDLE      NO-UNDO.

    RUN utils/api-tas.p PERSISTENT SET h-api-sintegra.
    RUN consutaNrInscrEstadual IN h-api-sintegra (INPUT uf, INPUT cnpj, OUTPUT ie).

    FINALLY:

        IF VALID-HANDLE(h-api-sintegra) THEN
            DELETE PROCEDURE h-api-sintegra NO-ERROR.

    END.
END PROCEDURE.


/*PROCEDURE getSalesChannelByCustomerRepresentative :
    DEFINE INPUT PARAMETER cCodigoRep AS CHAR.
    DEFINE OUTPUT PARAMETER cWhereRep AS CHAR.
    
    DEFINE VARIABLE cAux AS CHARACTER   NO-UNDO.

    FOR EACH canal-cliente WHERE canal-cliente.cod-rep = INT(cCodigoRep) AND canal-cliente.dat-inic-validade <= TODAY AND canal-cliente.dat-fim-validade >= TODAY NO-LOCK:       
        FIND FIRST repres WHERE repres.cod-rep = canal-cliente.cod-rep NO-LOCK NO-ERROR.
            IF AVAIL repres THEN DO:
                IF NOT cWhereRep MATCHES "*cod-emitente = " + String(canal-cliente.cod-emitente) + "*" THEN DO:
                    IF cWhereRep = "" THEN
                    	ASSIGN cWhereRep = " OR (emitente.cod-emitente = " + String(canal-cliente.cod-emitente) .    
                    ELSE 
                    	ASSIGN cWhereRep = cWhereRep + " OR emitente.cod-emitente = " + string(canal-cliente.cod-emitente).
                END. 
            END.
    END.

    IF cWhereRep <> "" THEN
        ASSIGN cWhereRep = cWhereRep + ")".
    IF criteria <> "" THEN
        ASSIGN cWhereRep = cWhereRep + " and " + criteria.
END. */
