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
{include/i-prgvrs.i BOIN295DESC 2.00.00.035 } /*** "010035" 17/06/2025 16:40:48 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin295desc MUT}
&ENDIF

{cdp/cdcfgmat.i}
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
&GLOBAL-DEFINE DBOName BOIN295
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName pedido-compr
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

&if  defined(bf_mat_custeio_item) &then
/*---- Vari veis globais usadas para validacao do local de entrega
       Definidas no cc0300.w, cc0300a.w e cc0300b.w new field----*/
def new global shared var g-nr-ped-venda  like ped-venda.nr-pedcli   no-undo.
def new global shared var g-nr-seq-pedido like ped-item.nr-sequencia no-undo.
&endif

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin295.i RowObject}


/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/


/*--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var c-seg-usuario        as char no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
def var i-ep-codigo          LIKE empresa.ep-codigo  no-undo.
&ELSE
def var i-ep-codigo          as int  no-undo.
&ENDIF
def var i-pais-impto-usuario    as int no-undo.
def var h_api_cta_ctbl          as handle  no-undo.
def var v_des_cta_ctbl          as char    no-undo.
def var v_num_tip_cta_ctbl      as char    no-undo. 
def var v_num_sit_cta_ctbl      as char    no-undo. 
def var v_ind_finalid_cta       as char    no-undo. 

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro   as integer   format ">>>>,>>9" label "N£mero"          column-label "N£mero"
    field ttv_des_msg_ajuda  as character format "x(40)"    label "Mensagem Ajuda"  column-label "Mensagem Ajuda"
    field ttv_des_msg_erro   as character format "x(60)"    label "Mensagem Erro"   column-label "Inconsistˆncia".

/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/

&Scoped-define SEGUR-ESTAB-ATRIBUTE end-entrega /*atributo que contem o estabelecimento na query*/

{include/i-estab-security.i}


/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/

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
         HEIGHT             = 2.21
         WIDTH              = 40.86.
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

    {method/svc/autentic/autentic.i 
             &vUserName="c-seg-usuario"
             &vUserEnterprise="i-ep-codigo"
             &vUserCountryTax="i-pais-impto-usuario"}

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "c-cod-tabela":U THEN ASSIGN pFieldValue = RowObject.c-cod-tabela.
        WHEN "c-descr-merc[1]":U THEN ASSIGN pFieldValue = RowObject.c-descr-merc[1].
        WHEN "c-descr-merc[2]":U THEN ASSIGN pFieldValue = RowObject.c-descr-merc[2].
        WHEN "c-descr-merc[3]":U THEN ASSIGN pFieldValue = RowObject.c-descr-merc[3].
        WHEN "c-embalagem[1]":U THEN ASSIGN pFieldValue = RowObject.c-embalagem[1].
        WHEN "c-embalagem[2]":U THEN ASSIGN pFieldValue = RowObject.c-embalagem[2].
        WHEN "c-embalagem[3]":U THEN ASSIGN pFieldValue = RowObject.c-embalagem[3].
        WHEN "c-observacao[1]":U THEN ASSIGN pFieldValue = RowObject.c-observacao[1].
        WHEN "c-observacao[2]":U THEN ASSIGN pFieldValue = RowObject.c-observacao[2].
        WHEN "c-observacao[3]":U THEN ASSIGN pFieldValue = RowObject.c-observacao[3].
        WHEN "c-observacao[4]":U THEN ASSIGN pFieldValue = RowObject.c-observacao[4].
        WHEN "c-observacao[5]":U THEN ASSIGN pFieldValue = RowObject.c-observacao[5].
        WHEN "c-prazo":U THEN ASSIGN pFieldValue = RowObject.c-prazo.
        WHEN "cargo-ass[1]":U THEN ASSIGN pFieldValue = RowObject.cargo-ass[1].
        WHEN "cargo-ass[2]":U THEN ASSIGN pFieldValue = RowObject.cargo-ass[2].
        WHEN "cargo-ass[3]":U THEN ASSIGN pFieldValue = RowObject.cargo-ass[3].
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-estab-gestor":U THEN ASSIGN pFieldValue = RowObject.cod-estab-gestor.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "comentarios":U THEN ASSIGN pFieldValue = RowObject.comentarios.
        WHEN "compl-entrega":U THEN ASSIGN pFieldValue = RowObject.compl-entrega.
        WHEN "desc-forma":U THEN ASSIGN pFieldValue = RowObject.desc-forma.
        WHEN "desc-via":U THEN ASSIGN pFieldValue = RowObject.desc-via.
        WHEN "end-cobranca":U THEN ASSIGN pFieldValue = RowObject.end-cobranca.
        WHEN "end-entrega":U THEN ASSIGN pFieldValue = RowObject.end-entrega.
        WHEN "mot-elimina":U THEN ASSIGN pFieldValue = RowObject.mot-elimina.
        WHEN "nome-ass[1]":U THEN ASSIGN pFieldValue = RowObject.nome-ass[1].
        WHEN "nome-ass[2]":U THEN ASSIGN pFieldValue = RowObject.nome-ass[2].
        WHEN "nome-ass[3]":U THEN ASSIGN pFieldValue = RowObject.nome-ass[3].
        WHEN "responsavel":U THEN ASSIGN pFieldValue = RowObject.responsavel.
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
        WHEN "data-pedido":U THEN ASSIGN pFieldValue = RowObject.data-pedido.
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
        WHEN "de-vl-fob":U THEN ASSIGN pFieldValue = RowObject.de-vl-fob.
        WHEN "de-vl-frete-i":U THEN ASSIGN pFieldValue = RowObject.de-vl-frete-i.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescCGCEmitente DBOProgram 
PROCEDURE getDescCGCEmitente :
/*------------------------------------------------------------------------------
  Purpose: Retorna o nome e o cgc do emitente recebido como parƒmetro.
------------------------------------------------------------------------------*/
    def input  param i-cod-emitente like emitente.cod-emitente no-undo.
    def output param c-desc-emit    like emitente.nome-abrev   no-undo.
    def output param c-cgc-emit     like emitente.cgc          no-undo.
    
    for first emitente fields (nome-abrev cgc)
        where emitente.cod-emitente = i-cod-emitente no-lock: end.
    if avail emitente then
        assign c-desc-emit = emitente.nome-abrev
               c-cgc-emit  = emitente.cgc.
    else do:
        assign c-desc-emit = "":U
               c-cgc-emit  = "":U.
        return "NOK":U.
    end.    

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescComprador DBOProgram 
PROCEDURE getDescComprador :
/*------------------------------------------------------------------------------
  Purpose: Retorna o nome do comprador recebido como parƒmetro.
------------------------------------------------------------------------------*/
    def input  param c-cod-comprado  like comprador.cod-comprado no-undo.
    def output param c-nome-comprado like comprador.nome         no-undo.
    
    for first comprador fields (nome)
        where comprador.cod-comprado = c-cod-comprado no-lock: end.
    if  available comprador then 
        assign c-nome-comprado = comprador.nome.
    else do:
        assign c-nome-comprado = "":U.
        return "NOK":U.
    end.    
        
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescCondPag DBOProgram 
PROCEDURE getDescCondPag :
/*------------------------------------------------------------------------------
  Purpose: Retorna a descricao da condi‡Æo de pagto recebida como parƒmetro.
------------------------------------------------------------------------------*/
    def input  param i-cod-cond-pag like cond-pagto.cod-cond-pag no-undo.
    def output param c-desc-cond    like cond-pagto.descricao    no-undo.
    
    for first cond-pagto fields (descricao)
        where cond-pagto.cod-cond-pag = i-cod-cond-pag no-lock: end.
    if  available cond-pagto then 
        assign c-desc-cond = cond-pagto.descricao.
    else do:
        assign c-desc-cond = "Condi‡Æo Pagto Espec¡fica".
        return "NOK":U.
    end.    
        
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescContaContab DBOProgram 
PROCEDURE getDescContaContab :
/*------------------------------------------------------------------------------
  Purpose: Retorna o titulo da conta contabil recebida como parƒmetro.
------------------------------------------------------------------------------*/
    def input  param i-empresa      as character no-undo.
    def input  param c-ct-codigo    as character no-undo.
    def input  param dt-entrega     as date      no-undo.
    def output param c-desc-conta   as character no-undo.
    
    run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,              /* EMPRESA EMS2 */
                                                   input        "",                     /* PLANO DE CONTAS */
                                                   input-output c-ct-codigo,            /* CONTA */
                                                   input        dt-entrega,             /* DATA TRANSACAO */   
                                                   output       v_des_cta_ctbl,         /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl,     /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl,     /* SITUA€ÇO DA CONTA */
                                                   output       v_ind_finalid_cta,      /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).           /* ERROS */
    if valid-handle(h_api_cta_ctbl) then
        delete object h_api_cta_ctbl.

    if not can-find(tt_log_erro) then do:
        assign c-desc-conta = v_des_cta_ctbl.
    end.
    else do:
        assign c-desc-conta = "":U.
        return "NOK":U.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescDeposito DBOProgram 
PROCEDURE getDescDeposito :
/*------------------------------------------------------------------------------
  Purpose: Retorna o nome do deposito recebido como parƒmetro.
------------------------------------------------------------------------------*/
    def input  param i-cod-depos  like deposito.cod-depos no-undo.
    def output param c-nome-depos like deposito.nome      no-undo.
    
    for first deposito fields (nome)
        where deposito.cod-depos = i-cod-depos no-lock: end.
    if  available deposito then 
        assign c-nome-depos = deposito.nome.
    else do:
        assign c-nome-depos = "":U.
        return "NOK":U.
    end.    

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescDespesa DBOProgram 
PROCEDURE getDescDespesa :
/*------------------------------------------------------------------------------
  Purpose: Retorna a descri‡Æo da despesa recebida como parƒmetro.
------------------------------------------------------------------------------*/
    def input  param c-cod-despesa like despesa.cod-despesa no-undo.
    def output param c-des-despesa like despesa.des-despesa no-undo.
    
    for first despesa fields (des-despesa)
        where despesa.cod-despesa = c-cod-despesa no-lock: end.
    if  available despesa then 
        assign c-des-despesa = despesa.des-despesa.
    else do:
        assign c-des-despesa = "":U.
        return "NOK":U.
    end.    
        
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescEstabelec DBOProgram 
PROCEDURE getDescEstabelec :
/*------------------------------------------------------------------------------
  Purpose: Retorna o nome do estabelecimento recebido como parƒmetro.
------------------------------------------------------------------------------*/
    def input  param i-cod-estabel  like estabelec.cod-estabel no-undo.
    def output param c-nome-estabel like estabelec.nome        no-undo.
    
    ASSIGN c-nome-estabel = "".

    IF l-estab-security-active THEN 
        FOR first estabelec FIELDS(nome)
             where estabelec.cod-estabel = i-cod-estabel NO-LOCK,
            FIRST {&ESTAB-SEC-TT} WHERE {&ESTAB-SEC-TT-FIELD} = estabelec.cod-estabel NO-LOCK:
            ASSIGN c-nome-estabel = estabelec.nome.
        END.
    ELSE
        FOR first estabelec FIELDS(nome)
             where estabelec.cod-estabel = i-cod-estabel NO-LOCK:
            ASSIGN c-nome-estabel = estabelec.nome.
        END.

    /*NÆo alterar e essa l¢gica para nÆo gerar conflito nos programas chamadores*/
    IF c-nome-estabel = "" THEN
        RETURN "NOK":U.
        
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescItem DBOProgram 
PROCEDURE getDescItem :
/*------------------------------------------------------------------------------
  Purpose: Retorna a descricao do item recebido como parƒmetro.
------------------------------------------------------------------------------*/
    def input  param i-cod-item  like item.it-codigo no-undo.
    def output param c-desc-item like item.desc-item no-undo.
    
    for first item fields (desc-item)
        where item.it-codigo = i-cod-item no-lock: end.
    if  available item then 
        assign c-desc-item = item.desc-item.
    else do:
        assign c-desc-item = "":U.
        return "NOK":U.
    end.    
        
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescMensagem DBOProgram 
PROCEDURE getDescMensagem :
/*------------------------------------------------------------------------------
  Purpose: Retorna a descricao da mensagem recebida como parƒmetro.
------------------------------------------------------------------------------*/
    def input  param i-cod-mensagem  like mensagem.cod-mensage no-undo.
    def output param c-desc-mensagem like mensagem.descricao   no-undo.
    
    for first mensagem fields (descricao)
        where mensagem.cod-mensagem = i-cod-mensagem no-lock: end.
    if  available mensagem then 
        assign c-desc-mensagem = mensagem.descricao.
    else do:
        assign c-desc-mensagem = "":U.
        return "NOK":U.
    end.    
        
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescMoeda DBOProgram 
PROCEDURE getDescMoeda :
/*------------------------------------------------------------------------------
  Purpose: Retorna o nome do comprador recebido como parƒmetro.
------------------------------------------------------------------------------*/
    def input  param i-cod-moeda  like moeda.mo-codigo no-undo.
    def output param c-desc-moeda like moeda.descricao no-undo.
    
    for first moeda fields (descricao)
        where moeda.mo-codigo = i-cod-moeda no-lock: end.
    if  available moeda then 
        assign c-desc-moeda = moeda.descricao.
    else do:
        assign c-desc-moeda = "":U.
        return "NOK":U.
    end.    
        
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescOperacao DBOProgram 
PROCEDURE getDescOperacao :
/*------------------------------------------------------------------------------
  Purpose: Retorna o nome da operacao recebida como parƒmetro.
------------------------------------------------------------------------------*/
    def input  param i-op-codigo like operacao.op-codigo no-undo.
    def input  param c-item-cod  like operacao.it-codigo no-undo.
    def output param c-desc-oper like operacao.descricao no-undo.
    
    for first operacao fields (descricao)
        where operacao.op-codigo = i-op-codigo 
        and   operacao.it-codigo = c-item-cod
        no-lock: end.
    if  available operacao then 
        assign c-desc-oper = operacao.descricao.
    else do:
        assign c-desc-oper = "":U.
        return "NOK":U.
    end.    
        
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescProcesso DBOProgram 
PROCEDURE getDescProcesso :
/*------------------------------------------------------------------------------
  Purpose: Retorna a descri‡Æo do processo recebido como parƒmetro.
------------------------------------------------------------------------------*/
    def input  param i-nr-processo    like pedido-compr.nr-processo no-undo.
    def output param c-desc-proc      like proc-compra.descricao    no-undo.
    
    for first proc-compra fields (descricao)
        where proc-compra.nr-processo = i-nr-processo no-lock: end.
    if  available proc-compra then 
        assign c-desc-proc = proc-compra.descricao.
    else do:
        assign c-desc-proc = "":U.
        return "NOK":U.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescRequisitante DBOProgram 
PROCEDURE getDescRequisitante :
/*------------------------------------------------------------------------------
  Purpose: Retorna o nome do requisitante recebido como parƒmetro.
------------------------------------------------------------------------------*/
    def input  param c-nm-abrev-requis like requisitante.nome-abrev no-undo.
    def output param c-nome-requis     like requisitante.nome       no-undo.
    
    for first requisitante fields (nome)
        where requisitante.nome-abrev = c-nm-abrev-requis no-lock: end.
    if  available requisitante then 
        assign c-nome-requis = requisitante.nome.
    else do:
        assign c-nome-requis = "":U.
        return "NOK":U.
    end.    
        
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescResponsavel DBOProgram 
PROCEDURE getDescResponsavel :
/*------------------------------------------------------------------------------
  Purpose: Retorna o nome do comprador recebido como parƒmetro.
------------------------------------------------------------------------------*/
    def input  param i-cod-comprado   like comprador.cod-comprado no-undo.
    def output param c-nome-comprador like comprador.nome         no-undo.
    
    for first comprador fields (nome)
        where comprador.cod-comprado = i-cod-comprado no-lock: end.
    if  available comprador then 
        assign c-nome-comprador = comprador.nome.
    else do:
        assign c-nome-comprador = "":U.
        return "NOK":U.
    end.    
        
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescTpDesp DBOProgram 
PROCEDURE getDescTpDesp :
/*------------------------------------------------------------------------------
  Purpose: Retorna descricao do tipo despesa recebida como parƒmetro.
------------------------------------------------------------------------------*/
    def input  param i-tp-codigo like tipo-rec-desp.tp-codigo no-undo.
    def output param c-descricao like tipo-rec-desp.descricao no-undo.
    
    for first tipo-rec-desp fields (descricao)
        where tipo-rec-desp.tp-codigo = i-tp-codigo no-lock: end.
    if  available tipo-rec-desp then 
        assign c-descricao = tipo-rec-desp.descricao.
    else do:
        assign c-descricao = "":U.
        return "NOK":U.
    end.    
        
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescViaTransp DBOProgram 
PROCEDURE getDescViaTransp :
/*------------------------------------------------------------------------------
  Purpose: Retorna o nome e via de transporte da transportadora recebida
           como parƒmetro.
------------------------------------------------------------------------------*/
    def input  param i-cod-transp  like transporte.cod-transp no-undo.
    def output param c-desc-transp like transporte.nome-abrev no-undo.
    def output param i-via-transp  like transporte.via-transp no-undo.
    
    for first transporte fields(nome-abrev via-transp)
        where transporte.cod-transp = i-cod-transp no-lock: end.
    if  available transporte then 
        assign c-desc-transp = transporte.nome-abrev
               i-via-transp  = transporte.via-transp.
    else do:
        assign c-desc-transp = "":U
               i-via-transp  = 0.
        return "NOK":U.
    end.    
        
    return "OK":U.
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
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emit-terc":U THEN ASSIGN pFieldValue = RowObject.cod-emit-terc.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-maq-origem":U THEN ASSIGN pFieldValue = RowObject.cod-maq-origem.
        WHEN "cod-mensagem":U THEN ASSIGN pFieldValue = RowObject.cod-mensagem.
        WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-transp.
        WHEN "frete":U THEN ASSIGN pFieldValue = RowObject.frete.
        WHEN "i-cod-forma":U THEN ASSIGN pFieldValue = RowObject.i-cod-forma.
        WHEN "i-cod-porto":U THEN ASSIGN pFieldValue = RowObject.i-cod-porto.
        WHEN "i-cod-via":U THEN ASSIGN pFieldValue = RowObject.i-cod-via.
        WHEN "i-exportador":U THEN ASSIGN pFieldValue = RowObject.i-exportador.
        WHEN "i-importador":U THEN ASSIGN pFieldValue = RowObject.i-importador.
        WHEN "i-moeda":U THEN ASSIGN pFieldValue = RowObject.i-moeda.
        WHEN "i-situacao":U THEN ASSIGN pFieldValue = RowObject.i-situacao.
        WHEN "ind-orig-entrada":U THEN ASSIGN pFieldValue = RowObject.ind-orig-entrada.
        WHEN "ind-via-envio":U THEN ASSIGN pFieldValue = RowObject.ind-via-envio.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "l-classificacao":U THEN ASSIGN pFieldValue = RowObject.l-classificacao.
        WHEN "l-tipo-ped":U THEN ASSIGN pFieldValue = RowObject.l-tipo-ped.
        WHEN "natureza":U THEN ASSIGN pFieldValue = RowObject.natureza.
        WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        WHEN "nr-processo":U THEN ASSIGN pFieldValue = RowObject.nr-processo.
        WHEN "nr-prox-ped":U THEN ASSIGN pFieldValue = RowObject.nr-prox-ped.
        WHEN "nro-proc-alteracao":U THEN ASSIGN pFieldValue = RowObject.nro-proc-alteracao.
        WHEN "nro-proc-entrada":U THEN ASSIGN pFieldValue = RowObject.nro-proc-entrada.
        WHEN "nro-proc-saida":U THEN ASSIGN pFieldValue = RowObject.nro-proc-saida.
        WHEN "num-id-documento":U THEN ASSIGN pFieldValue = RowObject.num-id-documento.
        WHEN "num-ped-benef":U THEN ASSIGN pFieldValue = RowObject.num-ped-benef.
        WHEN "num-pedido":U THEN ASSIGN pFieldValue = RowObject.num-pedido.
        WHEN "num-processo-mp":U THEN ASSIGN pFieldValue = RowObject.num-processo-mp.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        WHEN "via-transp":U THEN ASSIGN pFieldValue = RowObject.via-transp.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice numero
  Parameters:  
               retorna valor do campo num-pedido
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnum-pedido LIKE pedido-compr.num-pedido NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnum-pedido = RowObject.num-pedido.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLeaveFornecedor DBOProgram 
PROCEDURE getLeaveFornecedor :
/*------------------------------------------------------------------------------
  Purpose: Retorna o emitente de entrega e
                   a condi‡Æo de pagamento do emitente recebido como parƒmetro.
           A interface est  executando tamb‚m a getTransp.
------------------------------------------------------------------------------*/
    def input  param i-cod-emitente like emitente.cod-emitente   no-undo.
    def output param i-cd-emit-terc like emitente.cod-emitente   no-undo.
    def output param i-cod-cond-pag like cond-pagto.cod-cond-pag no-undo.

    assign i-cd-emit-terc = 0 /* i-cod-emitente */.

    for first emitente fields (cod-cond-pag)
        where emitente.cod-emitente = i-cod-emitente no-lock: end.
    if avail emitente then
        assign i-cod-cond-pag = emitente.cod-cond-pag.
    else do:
        assign i-cod-cond-pag = 0.
        return "NOK":U.
    end.    

    return "OK":U.
    
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
        WHEN "contr-forn":U THEN ASSIGN pFieldValue = RowObject.contr-forn.
        WHEN "emergencial":U THEN ASSIGN pFieldValue = RowObject.emergencial.
        WHEN "gera-edi":U THEN ASSIGN pFieldValue = RowObject.gera-edi.
        WHEN "impr-pedido":U THEN ASSIGN pFieldValue = RowObject.impr-pedido.
        WHEN "l-ind-prof":U THEN ASSIGN pFieldValue = RowObject.l-ind-prof.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getMoedaPadrao DBOProgram 
PROCEDURE getMoedaPadrao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param c-cod-emitente as char no-undo.
    def output param i-moeda        as int  no-undo.
    
    find first dist-emitente where
               dist-emitente.cod-emitente = int(c-cod-emitente) no-lock no-error.
    if  avail dist-emitente then
        assign i-moeda = dist-emitente.mo-fatur.
    else
        assign i-moeda = 0.

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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTaxCountry DBOProgram 
PROCEDURE getTaxCountry :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param i-pais-usuario-impto as int no-undo.
    
    assign i-pais-usuario-impto = i-pais-impto-usuario.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTpCalcDespesa DBOProgram 
PROCEDURE getTpCalcDespesa :
/*------------------------------------------------------------------------------
  Purpose: Retorna tipo de calculo da despesa recebida como parƒmetro.
------------------------------------------------------------------------------*/
    def input  param c-cod-despesa like despesa.cod-despesa no-undo.
    def output param i-tp-calculo  like despesa.cdn-tp-calculo no-undo.
    
    for first despesa fields (cdn-tp-calculo)
        where despesa.cod-despesa = c-cod-despesa no-lock: end.
    if  available despesa then 
        assign i-tp-calculo = despesa.cdn-tp-calculo.
    else do:
        assign i-tp-calculo = 0.
        return "NOK":U.
    end.    
        
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTransp DBOProgram 
PROCEDURE getTransp :
/*------------------------------------------------------------------------------
  Purpose: Retorna o c¢digo da transportadora cadastrada para o emitente 
           retornado como parƒmetro.
------------------------------------------------------------------------------*/
    def input  param i-cod-emitente like emitente.cod-emitente no-undo.
    def output param i-cod-transp   like emitente.cod-transp   no-undo.
    
    for first emitente fields(cod-transp)
        where emitente.cod-emitente = i-cod-emitente no-lock: end.
    if  avail emitente then
        assign i-cod-transp = emitente.cod-transp.
    else do:
        assign i-cod-transp = 0.
        return "NOK":U.
    end.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getUnItem DBOProgram 
PROCEDURE getUnItem :
/*------------------------------------------------------------------------------
  Purpose: Retorna a Un do item recebido como parƒmetro.
------------------------------------------------------------------------------*/
    def input  param c-cod-item like item.it-codigo no-undo.
    def output param c-un-item  like item.un        no-undo.
    
    for first item fields (un)
        where item.it-codigo = c-cod-item no-lock: end.
    if  available item then 
        assign c-un-item = item.un.
    else do:
        assign c-un-item = "":U.
        return "NOK":U.
    end.    
        
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice numero
  Parameters:  
               recebe valor do campo num-pedido
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-pedido LIKE pedido-compr.num-pedido NO-UNDO.

    FIND FIRST bfpedido-compr WHERE 
        bfpedido-compr.num-pedido = pnum-pedido NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpedido-compr THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpedido-compr)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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

    &Scoped-define KEY-PHRASE TRUE NO-LOCK
    {include/i-estab-openquery.i}
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDescricaoItem DBOProgram 
PROCEDURE retornaDescricaoItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pc-it-codigo AS CHAR  NO-UNDO.
    DEFINE INPUT  PARAMETER prRowidOrdem AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-descricao AS CHAR  NO-UNDO.

    FOR FIRST item fields(it-codigo desc-item tipo-contr) 
        WHERE item.it-codigo = pc-it-codigo NO-LOCK: END.
    IF AVAIL item THEN DO:
        FOR FIRST item-mat fields(log-1) 
            WHERE item-mat.it-codigo = item.it-codigo NO-LOCK: END. 
        IF  AVAIL item-mat AND item-mat.log-1 /*item Gen‚rico*/ AND item.tipo-contr = 4 /* d‚bito direto */ THEN DO:
            /* busca descri‡Æo da ordem-compra */
            FOR FIRST ordem-compra  FIELDS(narrativa)
                WHERE ROWID(ordem-compra) = prRowidOrdem NO-LOCK: END.
            IF  AVAIL ordem-compra THEN
                ASSIGN pc-descricao = SUBSTRING(ordem-compra.narrativa,1,60).
            ELSE
                ASSIGN pc-descricao = item.desc-item.
        END.
        ELSE
            ASSIGN pc-descricao = item.desc-item.
    END.
    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnExtraFornec DBOProgram 
PROCEDURE returnExtraFornec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param r-pedido        as rowid no-undo.
    def output param l-extra-fornec as log   no-undo. 
   
    for first pedido-compr fields(cod-emitente)
        where rowid(pedido-compr) = r-pedido no-lock,
        first dist-emitente fields()
        where dist-emitente.cod-emitente = pedido-compr.cod-emitente
          and dist-emitente.extra-fornec no-lock:
          
          assign l-extra-fornec = yes.
          
    end.
        
    return "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFormatParamGlobal DBOProgram 
PROCEDURE returnFormatParamGlobal :
/*------------------------------------------------------------------------------
  Parameters: c-campo   - recebe o nome do campo com o formato desejado.
              c-formato - retorna o formato do campo recebido como parƒmetro.
  Notes: Retorna o formato parametrizado nos parametros globais (cd0101), do 
         campo recebido como parametro.       
------------------------------------------------------------------------------*/
    def input  param c-campo   as char no-undo.
    def output param c-formato as char no-undo.
    
    find first param-global no-lock no-error.
    
    if  not avail param-global then
        return "NOK":U.

    case c-campo:
         when "formato-cep":U then 
              assign c-formato = param-global.formato-cep.
         when "formato-id-estadual":U then
              assign c-formato = param-global.formato-id-estadual.         
         when "formato-id-federal":U then
              assign c-formato = param-global.formato-id-federal.         
         when "formato-id-pessoal":U then
              assign c-formato = param-global.formato-id-pessoal.         
         when "formato-nr-nota":U then
              assign c-formato = param-global.formato-nr-nota.
         otherwise return "NOK":U.
    end case.
 
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnLocalPedItem DBOProgram 
PROCEDURE returnLocalPedItem :
/*------------------------------------------------------------------------------
  Notes: Esta procedure tem como objetivo achar o ped-item de uma determinada
         sequencia em um pedido de venda e retornar o codigo de entrega deste
         ped-item.
------------------------------------------------------------------------------*/
    def input  param p-nr-pedcli    like ped-item.nr-pedcli    no-undo.
    def input  param p-nome-abrev   like loc-entr.nome-abrev   no-undo.
    def input  param p-nr-sequencia like ped-item.nr-sequencia no-undo.
    def output param p-cod-entrega  like loc-entr.cod-entrega  no-undo.


&if defined(bf_mat_custeio_item) &then

    for first ped-item fields(cod-entrega)
        where ped-item.nr-pedcli    = p-nr-pedcli
          and ped-item.nr-sequencia = p-nr-sequencia 
          and ped-item.nome-abrev   = p-nome-abrev no-lock:
          assign p-cod-entrega  = ped-item.cod-entrega.
    end.
    
    if  not avail ped-item then do:
        assign p-cod-entrega = "".
        return "NOK":U.
    end.

&endif
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnEnderecoPedVenda DBOProgram 
PROCEDURE returnEnderecoPedVenda :
/*------------------------------------------------------------------------------
  Notes: Esta procedure tem como objetivo retornar os campos de endereco da
         tabela ped_venda para o pedodo de compra, caso caso o item do pedido 
         de venda esteja com o endereço de entrega em branco.
------------------------------------------------------------------------------*/
    def input  param p-nr-pedcli     like ped-item.nr-pedcli          no-undo.
    def input  param p-nome-abrev    like loc-entr.nome-abrev         no-undo.
    def output param p-endereco-text like ped-venda.endereco_text     no-undo.
    def output param p-endereco      like ped-venda.endereco_text          no-undo.
    def output param p-bairro        like ped-venda.bairro            no-undo.
    def output param p-cidade        like ped-venda.cidade            no-undo.
    def output param p-estado        like ped-venda.estado            no-undo.
    def output param p-pais          like ped-venda.pais              no-undo.
    def output param p-cep           like ped-venda.cep               no-undo.
    def output param p-jurisdicao    like ped-venda.cd-jurisdicao-ent no-undo.

    
&if defined(bf_mat_custeio_item) &then

    for first ped-venda field (endereco_text endereco_text bairro cidade 
                               estado pais cep cd-jurisdicao-ent)
        where ped-venda.nome-abrev = p-nome-abrev  and
              ped-venda.nr-pedcli = p-nr-pedcli  no-lock: 
              assign p-endereco-text  = ped-venda.endereco_text
                     p-endereco       = ped-venda.endereco_text
                     p-bairro         = ped-venda.bairro
                     p-cidade         = ped-venda.cidade
                     p-estado         = ped-venda.estado
                     p-pais           = ped-venda.pais
                     p-cep            = ped-venda.cep
                     p-jurisdicao     = ped-venda.cd-jurisdicao-ent .
    end.
        
    if not avail ped-venda then do:
        assign p-endereco-text  = ""
               p-endereco       = ""
               p-bairro         = ""
               p-cidade         = ""
               p-estado         = ""
               p-pais           = ""
               p-cep            = ""
               p-jurisdicao     = "" .
        return "NOK":U.
    end.

&endif
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnRowidFirstOCPedido DBOProgram 
PROCEDURE returnRowidFirstOCPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param p-num-pedido as int   no-undo.
    def output param p-rowid-oc   as rowid no-undo.
    
    for first ordem-compra fields()
        where ordem-compra.num-pedido = p-num-pedido no-lock: end.
    if  avail ordem-compra then
        assign p-rowid-oc = rowid(ordem-compra).
    else
        assign p-rowid-oc = ?.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaLocEntrega DBOProgram 
PROCEDURE validaLocEntrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input-output param table for RowObject.

&if defined(bf_mat_custeio_item) &then

    find first RowObject no-error.
    find first para-ped  no-lock no-error.
    
        if  not avail RowObject then
            return "NOK":U.

            if  RowObject.local-entrega = 1 /* estabelecimento entrega */
            then do:
         /*--- Quando for parametrizado para buscar o local de entrega 
               do estabelecimento de entrega, serao zerados os campos de
               endereco de entrega do pedido de compra ---*/
         assign RowObject.cod-emit-terc = 0
                RowObject.cod-entrega   = ""
                RowObject.endereco_text = ""
                RowObject.endereco_text      = ""
                RowObject.bairro        = ""
                RowObject.cidade        = ""
                RowObject.estado        = ""
                RowObject.pais          = ""
                RowObject.cep           = "".
    end.
    else if RowObject.local-entrega = 2 /* emitente */ then do:
        /*--- Quando for parametrizado para buscar o local de entrega do
              emitente sera verificada a se os dados existem cadastrados ---*/ 

               find first emitente 
                    where emitente.cod-emitente = RowObject.cod-emit-terc 
               and (   emitente.identific = 1 /* Cliente */
                    or emitente.identific = 3 /* Ambos */ ) no-lock no-error.            
        /*--- S¢ ser  validado o emitente se for diferente de zero ---*/
        if  RowObject.cod-emit-terc > 0 then do:
            if  not avail emitente then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-emitente-entrega AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Emitente_Entrega" *}
                ASSIGN c-lbl-liter-emitente-entrega = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="2" /* nÆo encontrado emitente entrega para a chave informada */
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="c-lbl-liter-emitente-entrega"}
            end.
        end.
        
        /*--- So sera validado o local de entrega se for diferente de branco ---*/
        if  RowObject.cod-entrega <> "" then do:
            
            if  avail emitente
            and not can-find(first loc-entr 
                             where loc-entr.cod-entrega = RowObject.cod-entrega
                               and loc-entr.nome-abrev =  emitente.nome-abrev no-lock) then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-local-entrega AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Local_Entrega" *}
                ASSIGN c-lbl-liter-local-entrega = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="2" /* nÆo encontrado local entrega para a chave informada */
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="c-lbl-liter-local-entrega"}
            end.
        end.
        
        if  RowObject.endereco_text = ""
        and RowObject.endereco_text = "" then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-endereco-completo-ou-endereco AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Endere‡o_completo_ou_Endere‡o" *}
            ASSIGN c-lbl-liter-endereco-completo-ou-endereco = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="17386" /* Endereco completo ou Endereco devem ser preenchidos */
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter-endereco-completo-ou-endereco"}            
        end.
        
        if  not avail param-global then   
            find first param-global no-lock no-error.
            
        if  avail param-global and param-global.dec-1 = 1 then do:
            if  RowObject.cidade = "" then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-cidade AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Cidade" *}
                ASSIGN c-lbl-liter-cidade = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="17386"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter-cidade"}
           end.
           Else do:
                if  not can-find(first cidade
                          where cidade.cidade = RowObject.cidade no-lock) then do:
                     /* nao encontrada cidade para a chave informada */
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-table.i mgdis cidade 1} /* Busca o label da tabela */
                    {method/svc/errors/inserr.i &ErrorNumber="2"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters=TRIM(RETURN-VALUE)}
                end.
            end.
        end.

        
        if  RowObject.estado = "" then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-estado AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Estado" *}
            ASSIGN c-lbl-liter-estado = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="17386" /* Estado deve ser preenchido */
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter-estado"}
        end.
        else
        if  not can-find(first unid-feder
                         where unid-feder.estado = RowObject.estado no-lock) then do:
                /* Inicio -- Projeto Internacional */
                {utp/ut-table.i mguni unid-feder 1} /* Busca o label da tabela */
                {method/svc/errors/inserr.i &ErrorNumber="2" /* nÆo encontrado estado para a chave informada */
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters=TRIM(RETURN-VALUE)}
        end.
        
        if  RowObject.pais = "" then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-pais AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Pais" *}
            ASSIGN c-lbl-liter-pais = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="17386" /* Pais deve ser preenchido */
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter-pais"}
        end.
        else
        if  not can-find(first pais
                         where pais.nome-pais = RowObject.pais no-lock) then do:
                /* Inicio -- Projeto Internacional */
                {utp/ut-table.i mguni pais 1} /* Busca o label da tabela */
                {method/svc/errors/inserr.i &ErrorNumber="2" /* nÆo encontrado pais para a chave informada */
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters=TRIM(RETURN-VALUE)}
        end.
        
        if  RowObject.jurisdicao = "" 
        and i-pais-impto-usuario = 3 /* EUA */ then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-jurisdicao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Jurisdi‡Æo" *}
            ASSIGN c-lbl-liter-jurisdicao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="17386" /* Jurisdicao deve ser preenchido */
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter-jurisdicao"}
        end.            
        else
        if  not can-find(first jurisdicao
                         where jurisdicao.cd-jurisdicao = RowObject.jurisdicao no-lock) 
            and i-pais-impto-usuario = 3 /* EUA */ then do:
                         
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-jurisdicao-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Jurisdi‡Æo" *}
                ASSIGN c-lbl-liter-jurisdicao-2 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="2" /* nÆo encontrado jurisdicao para a chave informada */
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="c-lbl-liter-jurisdicao-2"}                         
        end.

        if  g-nr-ped-venda <> ""
        and g-nr-ped-venda <> "0"
        and g-nr-ped-venda <> ? 
        and avail emitente then do: 
            
            find ped-venda 
                 where ped-venda.nome-abrev = emitente.nome-abrev 
                   and ped-venda.nr-pedcli  = g-nr-ped-venda no-lock no-error.
            
            if  not avail ped-venda then do:
                    {method/svc/errors/inserr.i &ErrorNumber="6269"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U}  
                    

            end.
            else do:          
                if (ped-venda.cod-sit-aval = 1 or ped-venda.cod-sit-aval = 2) then do:
                        {method/svc/errors/inserr.i &ErrorNumber="6270"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U} 
                end.
                if  ped-venda.cod-sit-ped = 2 then do:
                        {method/svc/errors/inserr.i &ErrorNumber="6271"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U} 
      
                end.

                /* Pedido nÆo aprovado no WF de desconto */
                IF  para-ped.log-usa-aprovac-workflow 
                AND ped-venda.log-aprov-workflow = NO THEN DO:
                
                     {method/svc/errors/inserr.i
                                &ErrorNumber="52327"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters=" ped-venda.nr-pedcli + '~~~~' + ped-venda.nome-abrev"}    
                END. 

                /****
                if  ped-venda.cod-sit-ped = 3 and 
                    not p-l-cad-ped-pend then do:
                        /* No UIB - erro 1363 */
                        {method/svc/errors/inserr.i &ErrorNumber="18338"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U}                               
                end.
                ****/
                if  ped-venda.cod-sit-ped = 4 then do:
                        {method/svc/errors/inserr.i &ErrorNumber="6272"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U}   
                end.
                if  ped-venda.cod-sit-ped = 9 then do:
                        {method/svc/errors/inserr.i &ErrorNumber="6273"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U} 
                end. 
            end.
            
            for first ped-item field (nome-abrev nr-pedcli nr-sequencia)
                where ped-item.nome-abrev = emitente.nome-abrev and
                      ped-item.nr-pedcli = g-nr-ped-venda  and
                      ped-item.nr-sequencia = g-nr-seq-pedido no-lock: end.
            if not avail ped-item then do:
                    {method/svc/errors/inserr.i &ErrorNumber="6269"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U}  
            end.
        end.
    end.

&endif

    return "OK":U.
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


