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
{include/i-prgvrs.i BOIN274FX 2.00.00.028 } /*** "010028" 17/09/2026 15:26:06 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin274fx MUT}
&ENDIF

/*:T--------------------------------------------------------------------------
    File       : boin274fx.p
    Purpose    : Programa PROGRESS que contÇm a l¢gica de neg¢cio e acesso a dados 
                 para a tabela ordem-compra do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */
{cdp/cdcfgmat.i} /* Pre-Processadores */
{cdp/cdcfgdis.i} /* Pre-Processadores */

{utp/ut-glob.i} /* Vari†veis Globais  */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN274
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ordem-compra
&GLOBAL-DEFINE TableLabel Ordem Compra
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T--- Include com definiá∆o da temptable RowObject ---*/
{inbo/boin274.i RowObject}

{cdp/cd9590.i}                      /* Unidade de Neg¢cio - l-unidade-negocio, l-dis-unid-negoc, l-mat-unid-negoc */
{cdp/cd0666.i}                      /* tt-erro */
{cdp/cd9400.i4}                     /* Split da Ordem de Compra - tt-ordem, tt-ordem-split */
{mpp/mpapi011.i}                    /* tt-param-maq-ep-est */
{ccp/ccapi012.i1}                   /* tt-ordem-compra, tt-prazo-compra */
{cdp/cd9730.i "new"}                /* t-invest */
{include/i-epc200.i boin274fx}      /* EPC - tt-epc, c-nom-prog-dpc-mg97, c-nom-prog-appc-mg97, c-nom-prog-upc-mg97 */
{inbo/boin356.i ttPrazoCompra}
{inbo/boin356.i ttPrazoCompraAux}
{inbo/boin356.i ttDeliverySchedule}
{fch/fchmat/fchmatkeeptrackofstocklevels.i3 ttRowid}
{fch/fchmat/fchmatkeeptrackofstocklevels.i3 ttRowidAux}
{fch/fchmat/fchmatkeeptrackofstocklevels.i ttStockLevels}
{fch/fchmat/fchmataddpurchaserequisitions.i4 ttParamConfigRules}          /* ttParamConfigRules */
{fch/fchmat/fchmatgeneratepurchaserequisitions.i1 ttPurchaseReqParam}
{fch/fchmat/fchmatgeneratepurchaserequisitions.i ttPurchaseRequisitions}
{inbo/boin168.i ttItRequisicao}
{inbo/boin385.i ttRequisicao}

DEFINE TEMP-TABLE ttParametrosTela NO-UNDO
    FIELD parametro AS CHARACTER
    FIELD valor     AS CHARACTER.

/* Validaá‰es Unidade de Neg¢cio */
DEFINE TEMP-TABLE tt-erro-aux NO-UNDO
    FIELD i-sequen AS INTEGER
    FIELD cd-erro  AS INTEGER
    FIELD mensagem AS CHARACTER FORMAT "x(255)":U.

DEFINE TEMP-TABLE tt-erro-mp NO-UNDO
    FIELD i-sequen AS INTEGER
    FIELD cd-erro  AS INTEGER
    FIELD mensagem AS CHARACTER FORMAT "x(255)":U.

DEFINE TEMP-TABLE tt-erro-split NO-UNDO
    FIELD i-sequen AS INTEGER
    FIELD cd-erro  AS INTEGER
    FIELD mensagem AS CHARACTER FORMAT "x(255)":U.

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
    FIELD ttv_num_cod_erro    AS INTEGER   FORMAT ">>>>,>>9":U LABEL "N£mero":U         COLUMN-LABEL "N£mero":U
    FIELD ttv_des_msg_ajuda   AS CHARACTER FORMAT "x(40)":U    LABEL "Mensagem Ajuda":U COLUMN-LABEL "Mensagem Ajuda":U
    FIELD ttv_des_msg_erro    AS CHARACTER FORMAT "x(60)":U    LABEL "Mensagem Erro":U  COLUMN-LABEL "Inconsistància":U.

DEFINE TEMP-TABLE tt-erro1 NO-UNDO
    FIELD i-sequen AS INTEGER
    FIELD cd-erro  AS INTEGER
    FIELD mensagem AS CHARACTER FORMAT "x(255)":U
    FIELD c-param  AS CHARACTER.

DEFINE TEMP-TABLE tt-fornec NO-UNDO
    FIELD cod-emitente LIKE item-fornec.cod-emitente
    FIELD it-codigo    LIKE item-fornec.it-codigo
    FIELD horiz-fixo   LIKE item-fornec.horiz-fixo
    FIELD ativo        LIKE item-fornec.ativo
    FIELD contr-forn   LIKE item-fornec.contr-forn
    FIELD fator-conver LIKE item-fornec.fator-conver
    FIELD num-casa-dec LIKE item-fornec.num-casa-dec
    FIELD perc-compra  LIKE item-fornec.perc-compra
    FIELD cot-aut      LIKE item-fornec.cot-aut
    FIELD cod-cond-pag LIKE item-fornec.cod-cond-pag
    FIELD unid-med-for LIKE item-fornec.unid-med-for
    FIELD lote-mul-for LIKE item-fornec.lote-mul-for
    FIELD lote-minimo  LIKE item-fornec.lote-minimo
    FIELD i-seq        AS   INTEGER
    index onde-compra  IS   unique it-codigo cod-emitente.

{cdp/cd7300.i1} /* Temp-Tables e variaveis Multi-Planta */

DEFINE TEMP-TABLE tt-dados-env-aux NO-UNDO LIKE tt-dados-env.

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
{method/dboqry.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName}   FOR {&TableName}.

DEFINE BUFFER b-tt-fornec      FOR tt-fornec.
DEFINE BUFFER b2-tt-fornec     FOR tt-fornec.
DEFINE BUFFER b-item-contrat   FOR item-contrat.
DEFINE BUFFER b-tt-dados-env   FOR tt-dados-env.

DEFINE VARIABLE c-diferencas                    AS   CHARACTER                            NO-UNDO. /* armazena o resultado da comparaá∆o de registros alterados */
DEFINE VARIABLE v_des_ccusto                    AS   CHARACTER                            NO-UNDO.
DEFINE VARIABLE v_des_cta_ctbl                  as   CHARACTER                            NO-UNDO.
DEFINE VARIABLE v_cod_cta_ctbl                  AS   CHARACTER                            NO-UNDO.
DEFINE VARIABLE v_num_tip_cta_ctbl              AS   CHARACTER                            NO-UNDO.
DEFINE VARIABLE v_num_sit_cta_ctbl              AS   CHARACTER                            NO-UNDO.
DEFINE VARIABLE v_ind_finalid_cta               AS   CHARACTER                            NO-UNDO.
DEFINE VARIABLE v_cod_finalid                   AS   CHARACTER                            NO-UNDO.
DEFINE VARIABLE c-ct-codigo                     AS   CHARACTER                            NO-UNDO.
DEFINE VARIABLE cErroAux                        AS   CHARACTER                            NO-UNDO.
DEFINE VARIABLE c-lbl-trad                      AS   CHARACTER                            NO-UNDO.
DEFINE VARIABLE de-nr-lotes                     AS   DECIMAL                              NO-UNDO.
DEFINE VARIABLE de-indice                       AS   DECIMAL                              NO-UNDO.
DEFINE VARIABLE de-qtidade                      AS   DECIMAL                              NO-UNDO.
DEFINE VARIABLE de-qtd                          AS   DECIMAL FORMAT ">>>,>>>,>>9.9999":U  NO-UNDO.
DEFINE VARIABLE de-val                          AS   DECIMAL FORMAT ">>>,>>>,>>9.9999":U  NO-UNDO.
DEFINE VARIABLE de-qtd-convertida               AS   DECIMAL FORMAT ">>>,>>>,>>9.9999":U  NO-UNDO.
DEFINE VARIABLE de-total-parcela                AS   DECIMAL FORMAT ">>>>,>>9.9999":U     NO-UNDO.
DEFINE VARIABLE hboMngr                         AS   HANDLE                               NO-UNDO.
DEFINE VARIABLE h-boin657fx                     AS   HANDLE                               NO-UNDO. /* Unidade de Neg¢cio */
DEFINE VARIABLE h-boin356fx                     AS   HANDLE                               NO-UNDO. /* Parcelas da Ordem  */
DEFINE VARIABLE h-boin356vl                     AS   HANDLE                               NO-UNDO. /* Parcelas da Ordem  */
DEFINE VARIABLE h-boin082                       AS   HANDLE                               NO-UNDO. /* Cotaá‰es da Ordem  */
DEFINE VARIABLE h-boin762                       AS   HANDLE                               NO-UNDO. /* Campo Lote Preg∆o  */
DEFINE VARIABLE h-cdapi024                      AS   HANDLE                               NO-UNDO. /* Unidade de Neg¢cio */
DEFINE VARIABLE h-api                           AS   HANDLE                               NO-UNDO.
DEFINE VARIABLE h_api_cta_ctbl                  AS   HANDLE                               NO-UNDO.
DEFINE VARIABLE h_api_ccusto                    AS   HANDLE                               NO-UNDO.
DEFINE VARIABLE apiHandler                      AS   HANDLE                               NO-UNDO.
DEFINE VARIABLE i-tipo-movto                    AS   INTEGER                              NO-UNDO.
DEFINE VARIABLE i-num-ordem                     AS   INTEGER                              NO-UNDO.
DEFINE VARIABLE i-num-parce                     AS   INTEGER                              NO-UNDO.
DEFINE VARIABLE i-sequencia                     AS   INTEGER                              NO-UNDO.
DEFINE VARIABLE i-num-reg                       AS   INTEGER                              NO-UNDO.
DEFINE VARIABLE i-length                        AS   INTEGER                              NO-UNDO.
DEFINE VARIABLE i-seq-ordem                     AS   INTEGER                              NO-UNDO.
DEFINE VARIABLE i-numero-ordem                  AS   INTEGER                              NO-UNDO.
DEFINE VARIABLE i-estoque                       AS   INTEGER                              NO-UNDO.
DEFINE VARIABLE ind                             AS   INTEGER                              NO-UNDO.
DEFINE VARIABLE l-erro                          AS   LOGICAL                              NO-UNDO. /* Split da Ordem de Compra */
DEFINE VARIABLE l-ligado                        AS   LOGICAL                              NO-UNDO. /* Split da Ordem de Compra */
DEFINE VARIABLE l-ligado2                       AS   LOGICAL                              NO-UNDO. /* Split da Ordem de Compra */
DEFINE VARIABLE l-cria                          AS   LOGICAL                              NO-UNDO. /* Split da Ordem de Compra */
DEFINE VARIABLE l-busca-qtd                     AS   LOGICAL                              NO-UNDO.
DEFINE VARIABLE l-ExportaOrdensMultiplas        AS   LOGICAL                              NO-UNDO.
DEFINE VARIABLE l-AtualizaParcelas              AS   LOGICAL INITIAL YES                  NO-UNDO.
DEFINE VARIABLE l-consiste-conta                AS   LOGICAL                              NO-UNDO.
DEFINE VARIABLE l-erro-contrato                 AS   LOGICAL                              NO-UNDO.
DEFINE VARIABLE l-ordem-multipla                AS   LOGICAL                              NO-UNDO.
DEFINE VARIABLE r-ordem                         AS   ROWID                                NO-UNDO. /* Split da Ordem de Compra */
DEFINE VARIABLE l-ativo                         LIKE item-fornec.ativo                    NO-UNDO.
DEFINE VARIABLE c-cod-estabel                   LIKE estabelec.cod-estabel                NO-UNDO.
DEFINE VARIABLE da-horiz-fixo                   LIKE prazo-compra.data-entrega            NO-UNDO.
DEFINE VARIABLE de-qtd-tot                      LIKE prazo-compra.quantidade              NO-UNDO.
DEFINE VARIABLE i-empresa                       LIKE param-global.empresa-prin            NO-UNDO.
DEFINE VARIABLE h-boiv028                       AS   HANDLE                               NO-UNDO.
DEFINE VARIABLE h-boin168fx                     AS   HANDLE                               NO-UNDO.

/************************Consultas Gerais********************************/
{cdp/findparamglobal.i}

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
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 25.04
         WIDTH              = 43.57.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* SINCRONIZAÄ«O DAS PARCELAS DA ORDEM DE COMPRA 
       Validaá‰es que dependem da prazo-compra devem ser executadas ap¢s a chamada desta procedure */
    IF l-AtualizaParcelas THEN DO:
        RUN createUpdateDeleteDeliverySchedule.
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
    END.
    
    RUN afterCreateUpdateRecord.

    /*** MANUFATURA ***/
    IF param-global.modulo-pl OR param-global.modulo-pi THEN
        RUN cdp/cd7000.p (INPUT 0, INPUT RowObject.it-codigo, INPUT RowObject.cod-estabel). 

    /*** MULTIPLANTA ***/
    IF param-global.modulo-mp THEN
        RUN ccp/ccapi200.p (INPUT "Ordem-compra":U,
                            INPUT ROWID(ordem-compra),
                            INPUT 1, /* Inclus∆o */
                            INPUT-OUTPUT TABLE tt-erro).
    
    /*** INVESTIMENTOS ***/
    IF CONNECTED("mginv":U) AND param-global.modulo-in 
                            AND RowObject.num-ord-inv <> 0 
                            AND RowObject.num-ord-inv <> ? THEN DO:

        FOR FIRST bf{&TableName}
            WHERE bf{&TableName}.numero-ordem = RowObject.numero-ordem NO-LOCK:
        END.

        RUN inp/in2110.p (INPUT ROWID(bf{&TableName}), INPUT "I":U).

        FOR EACH prazo-compra
            WHERE prazo-compra.numero-ordem = bf{&TableName}.numero-ordem NO-LOCK:

            RUN inp/in2110a.p (INPUT ROWID(prazo-compra), INPUT "I":U).
        END.

        RUN inp/in2110b.p. /* Descarrega tabela */
        
        RUN ivbo/boiv028.p PERSISTENT SET h-boiv028.
        RUN UpdateOrdPed IN h-boiv028 (INPUT ROWID(bf{&TableName}),
                                       INPUT-OUTPUT TABLE RowErrors).
        DELETE PROCEDURE h-boiv028.
        ASSIGN h-boiv028 = ?.
        
        IF CAN-FIND(FIRST RowErrors where RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            RETURN "NOK":U.
        END.
        
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateUpdateRecord DBOProgram 
PROCEDURE afterCreateUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Centralizar a execuá∆o das regras de neg¢cio comuns a criaá∆o e a
               modificaá∆o do registro.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT AVAIL param-contrat THEN 
        FIND FIRST param-contrat NO-LOCK NO-ERROR.

    ASSIGN RowObject.r-rowid = ROWID(ordem-compra).
    
    IF RowObject.nr-contrato <> 0 AND RowObject.num-seq-item <> 0 THEN DO:
        
        {cdp/findcontratofor.i RowObject.nr-contrato}
        {cdp/finditemcontrat.i RowObject.nr-contrato RowObject.num-seq-item}

        /*** APROVAÄ«O ELETR‚NICA ***/
        IF param-contrat.log-1 THEN DO:
    
            IF  AVAIL contrato-for
            AND contrato-for.dec-2 = 0
            AND AVAIL item-contrat
            AND item-contrat.val-total = 0 THEN
                RUN cdp/cdapi171.p (8, 2, RowObject.r-rowid).
        END.
        
        /*** CONTRATOS ***/
        /* Verifica se h† parcela com entrega fora da data de validade do contrato */
        IF CAN-FIND(FIRST prazo-compra
                    WHERE prazo-compra.numero-ordem = RowObject.numero-ordem
                      AND (   prazo-compra.data-entrega < contrato-for.dt-ini-validade
                           OR prazo-compra.data-entrega > contrato-for.dt-ter-validade)) THEN
            ASSIGN l-erro-contrato = YES.
        /* Outras validaá‰es relacionadas ao contrato */
        ELSE DO:
            IF AVAIL contrato-for THEN
                RUN cnp/cn9080.p (INPUT RowObject.numero-ordem,
                                  INPUT 0,
                                  INPUT 0,
                                  INPUT contrato-for.dt-ini-validade, /* data j† validada no find acima */
                                  OUTPUT l-erro-contrato).
        END.

        IF l-erro-contrato THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="17275"
                                        &ErrorType="EMS"
                                        &ErrorSubType="WARNING"
                                        &ErrorParameters="''"}
        END.

        /* Permite criaá∆o e modificaá∆o da ordem de compra, mas sem relacion†-la ao contrato quando ocorre erro */
        IF l-erro-contrato THEN
            ASSIGN ordem-compra.nr-contrato  = 0
                   ordem-compra.num-seq-item = 0
                   l-erro-contrato           = NO.
    END.

    /* Exporta Parcela */
    if not VALID-HANDLE(h-boin356vl) then
        run inbo/boin356vl.p persistent set h-boin356vl.

    FIND FIRST ttParamConfigRules NO-ERROR.
    IF AVAIL ttParamConfigRules AND ttParamConfigRules.exportSchedule THEN DO:

        FOR EACH ttDeliverySchedule:

            RUN exportaAltCliPedOrdem IN h-boin356vl (INPUT ttDeliverySchedule.numero-ordem,
                                                      INPUT ttDeliverySchedule.parcela,
                                                      INPUT-OUTPUT TABLE ttPrazoCompra,
                                                      INPUT TABLE ttDeliverySchedule).
        END.
    END.
    IF VALID-HANDLE(h-boin356vl) THEN DO:
        DELETE PROCEDURE h-boin356vl.
        ASSIGN h-boin356vl = ?.
    END.

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

    /* SINCRONIZAÄ«O DAS PARCELAS DA ORDEM DE COMPRA 
       Validaá‰es que dependem da prazo-compra devem ser executadas ap¢s a chamada desta procedure ***/
    IF l-AtualizaParcelas THEN DO:
        RUN createUpdateDeleteDeliverySchedule.
        IF  RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
    END.
    
    RUN afterCreateUpdateRecord.

    /* Exportar alteraá‰es efetuadas para as Ordens M£ltiplas */
    IF l-ExportaOrdensMultiplas THEN DO:
        
        FOR EACH bfordem-compra
           WHERE bfordem-compra.numero-ordem >= (i-numero-ordem  +  1)
             AND bfordem-compra.numero-ordem <= (i-numero-ordem  + 99)
             AND ROWID(bfordem-compra)       <> RowObject.r-rowid EXCLUSIVE-LOCK:

            ASSIGN bfordem-compra.cod-estabel   = RowObject.cod-estabel
                   bfordem-compra.op-codigo     = RowObject.op-codigo
                   bfordem-compra.requisitante  = RowObject.requisitante
                   bfordem-compra.dep-almoxar   = RowObject.dep-almoxar
                   bfordem-compra.ordem-servic  = RowObject.ordem-servic
                   bfordem-compra.cod-comprado  = RowObject.cod-comprado
                   bfordem-compra.impr-ficha    = RowObject.impr-ficha.
        END.
    END.

    /*** MULTIPLANTA ***/
    IF param-global.modulo-mp THEN
        RUN ccp/ccapi200.p (INPUT "Ordem-compra":U,
                            INPUT ROWID(ordem-compra),
                            INPUT 2, /* Modificaá∆o */
                            INPUT-OUTPUT TABLE tt-erro).

    /*** INVESTIMENTOS ***/
    IF CONNECTED("mginv":U) AND param-global.modulo-in AND RowObject.num-ord-inv <> 0 THEN DO:
        
        RUN inp/in2110.p (INPUT RowObject.r-rowid, INPUT "M":U).

        RUN inp/in2110b.p.

        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.

        RUN inp/in2112.p (INPUT RowObject.r-rowid, INPUT "M":U).

        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN beforeCreateUpdateRecord.

    IF RowObject.origem = 0 THEN
        ASSIGN RowObject.origem = 1. /* Manual */

    /*Grava usuario que est† efetuando a inclus∆o da ordem*/
    ASSIGN OVERLAY(RowObject.char-1,207,12) = c-seg-usuario.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateUpdateRecord DBOProgram 
PROCEDURE beforeCreateUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Centralizar a execuá∆o das regras de neg¢cio comuns a criaá∆o e a
               modificaá∆o do registro.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
	DEFINE VARIABLE c-msg-param AS CHARACTER NO-UNDO.	

    /* Gravaá∆o da empresa da empresa na ordem de compra */
    {cdp/findestabelec.i RowObject.cod-estabel}
    IF AVAIL estabelec THEN DO:
        
        IF CONNECTED("mginv":U) AND param-global.modulo-in AND RowObject.num-ord-inv <> 0 THEN
            ASSIGN i-empresa = estabelec.ep-codigo.        
        ELSE
            RUN cdp/cd9970.p (INPUT  ROWID(estabelec), OUTPUT i-empresa).

        ASSIGN RowObject.ep-codigo = i-empresa.
    END.
     
    RUN validateDeliverySchedule.
    
    ASSIGN  de-total-parcela = 0.

	FOR EACH ttDeliverySchedule
        WHERE ttDeliverySchedule.numero-ordem = RowObject.numero-ordem NO-LOCK:

        ASSIGN de-total-parcela = de-total-parcela + ttDeliverySchedule.quantidade.
    END.    
	
	/* Caso a quantidade das parcelas for menos ou maior que a quantidade de itens   */
	/* informada na ordem de compras a ordem dever· assumir a soma das parcelas como */
	/* a quantidade da ordem.                                                        */

    /* S¢ efetuar o somat¢rio caso exista algum registro na ttDeliverySchedule */
    FIND FIRST ttDeliverySchedule 
         WHERE ttDeliverySchedule.numero-ordem = RowObject.numero-ordem NO-LOCK NO-ERROR.

    IF AVAIL ttDeliverySchedule AND RowObject.qt-solic <> de-total-parcela THEN DO:
		{utp/ut-liter.i A_Quantidade_da_ordem_foi_alterada_de_ *}
		ASSIGN c-msg-param = RETURN-VALUE + STRING(RowObject.qt-solic).
		{utp/ut-liter.i _para_a_somatÛria_total_das_parcelas_ *}
		ASSIGN c-msg-param = c-msg-param + RETURN-VALUE + '(' + STRING(de-total-parcela) + ')'.
				
		ASSIGN RowObject.qt-solic = de-total-parcela.
		
		{method/svc/errors/inserr.i &ErrorNumber="39073"
                                    &ErrorType="EMS"
                                    &ErrorSubType="INFORMATION"
                                    &ErrorParameters="c-msg-param"}
    END.
    /* Fim validaá∆o relacionada a quantidade da ordem x total das parcelas */
	
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE vOrdemIntegrMe AS LOGICAL NO-UNDO.
    
    ASSIGN vOrdemIntegrMe = can-find(ordem-compra-integr-me where ordem-compra-integr-me.numero-ordem = RowObject.numero-ordem).

    /*** MANUFATURA ***/
    IF param-global.modulo-pl = YES OR param-global.modulo-pi = YES THEN
        RUN cdp/cd7000.p (INPUT 0,
                          INPUT RowObject.it-codigo,
                          INPUT RowObject.cod-estabel).
    

    /*** MULTIPLANTA ***/
    IF param-global.modulo-mp THEN DO:

        EMPTY TEMP-TABLE tt-erro-mp.

        RUN ccp/ccapi200.p(INPUT "Ordem-compra":U,
                           INPUT RowObject.r-rowid,
                           INPUT 3, /* Eliminaá∆o */
                           INPUT-OUTPUT TABLE tt-erro-mp).
    
        IF CAN-FIND(FIRST tt-erro-mp) THEN DO:

            FOR EACH tt-erro-mp:
                RUN _insertErrorManual (INPUT tt-erro-mp.cd-erro,
                                        INPUT "EMS":U,
                                        INPUT "ERROR":U,
                                        INPUT tt-erro-mp.mensagem,
                                        INPUT "":U,
                                        INPUT "":U).
            END.
            RETURN "NOK":U.
        END.
    END.
    
    /* Processo de Cotaá∆o */
    FOR FIRST item-solicit-cotac 
        WHERE item-solicit-cotac.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
        {utp/ut-liter.i "Ordem_de_Compra" *}
        ASSIGN c-lbl-trad = TRIM(RETURN-VALUE).
        {utp/ut-liter.i "Processo_de_Cotaá∆o" *}
        {method/svc/errors/inserr.i &ErrorNumber="5906" 
                                    &ErrorType="EMS" 
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-trad + '~~~~':U + TRIM(RETURN-VALUE) + ' ':U + STRING(item-solicit-cotac.cdd-solicit)" }
        RETURN "NOK":U.
    END.

    /*** Eliminaá∆o das Cotaá‰es da Ordem de Compra ***/
    IF ordem-compra.situacao = 3 THEN DO: /* situaá∆o = "Cotada" */
           /* mensagem: Situacao da ordem nao permite eliminacao */
           {method/svc/errors/inserr.i &ErrorNumber="5987"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"
                                       &ErrorParameters="''"} 
    END.

    /*   ordens de compra integradas ao mercado      */
    /*   eletornico n∆o podem sofrer exclusao f°sica */
    IF vOrdemIntegrMe THEN DO:    
        RUN piCancelaOrdemCompraME.        
    END.
    ELSE DO:
        /*** REQUISIÄÂES DE COMPRA E DE COTAÄ«O ***/
        IF RowObject.nr-requisicao <> 0 THEN
            RUN ccp/ccapi020a.p (INPUT RowObject.numero-ordem).

        /*** Eliminaá∆o das Parcelas da Ordem de Compra ***/
        if not VALID-HANDLE(h-boin356fx) then
            run inbo/boin356fx.p persistent set h-boin356fx.

        RUN openQueryStatic IN h-boin356fx (INPUT "Main":U).
    
        FOR EACH prazo-compra
           WHERE prazo-compra.numero-ordem = RowObject.numero-ordem NO-LOCK:

            RUN emptyRowErrors   IN h-boin356fx.
            RUN repositionRecord IN h-boin356fx (INPUT ROWID(prazo-compra)).
            RUN deleteRecord     IN h-boin356fx.

            IF RETURN-VALUE = "NOK":U THEN DO:

                RUN getRowErrors IN h-boin356fx (OUTPUT TABLE RowErrors).

                FOR EACH RowErrors
                    WHERE RowErrors.ErrorType = "INTERNAL":U:

                    DELETE RowErrors.
                END.

                IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                    IF VALID-HANDLE(h-boin356fx) THEN DO:
                        DELETE PROCEDURE h-boin356fx.
                        ASSIGN h-boin356fx = ?.
                    END.
                    RETURN "NOK":U.
                END.
            END.
        END.

        if not VALID-HANDLE(h-boin082) then
            run inbo/boin082.p persistent set h-boin082.

        RUN openQueryStatic IN h-boin082 (INPUT "Main":U).
        
        FOR EACH cotacao-item
           WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem NO-LOCK:

            RUN emptyRowErrors   IN h-boin082.
            RUN repositionRecord IN h-boin082 (INPUT ROWID(cotacao-item)).
            RUN deleteRecord     IN h-boin082.

            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN getRowErrors IN h-boin082 (OUTPUT TABLE RowErrors).

                FOR EACH RowErrors
                   WHERE RowErrors.ErrorType = "INTERNAL":U:
                    
                    DELETE RowErrors.
                END.

                IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                    IF VALID-HANDLE(h-boin356fx) THEN DO:
                        DELETE PROCEDURE h-boin356fx.
                        ASSIGN h-boin356fx = ?.
                    END.
                    IF VALID-HANDLE(h-boin082) THEN DO:
                        DELETE PROCEDURE h-boin082.
                        ASSIGN h-boin082 = ?.
                    END.
                    RETURN "NOK":U.
                END.
            END.
            
            /* Coloquei essa chamada aqui apenas para lembrar de colocar essa chamada
               no mÇtodo beforeDeleteRecord do BO de Cotaá‰es */
            RUN inp/in2103.p (INPUT  RowObject.r-rowid, INPUT "E":U). /* elimina cotacao-inv */
        END.
    END.
    
    /*** INVESTIMENTOS ***/
    IF CONNECTED("mginv":U) AND param-global.modulo-in  AND ordem-compra.num-ord-inv <> 0 THEN DO:
        RUN inp/in2110.p (INPUT  RowObject.r-rowid, INPUT "E":U).
        RUN inp/in2110b.p.
    END.
    
    /*** Eliminaá∆o das Unidades de Neg¢cio da Ordem de Compra ***/
    IF NOT vOrdemIntegrMe
    AND l-mat-unid-negoc THEN DO:

        if not VALID-HANDLE(h-boin657fx) then
            run inbo/boin657fx.p persistent set h-boin657fx.


        RUN openQueryStatic IN h-boin657fx (INPUT "Main":U).

        FOR EACH unid-neg-ordem
           WHERE unid-neg-ordem.numero-ordem = RowObject.numero-ordem NO-LOCK:

            RUN emptyRowErrors   IN h-boin657fx.
            RUN repositionRecord IN h-boin657fx (INPUT ROWID(unid-neg-ordem)).
            RUN deleteRecord     IN h-boin657fx.

            IF  RETURN-VALUE = "NOK":U THEN DO:
                RUN getRowErrors IN h-boin657fx (OUTPUT TABLE RowErrors).

                FOR EACH RowErrors
                    WHERE RowErrors.ErrorType = "INTERNAL":U:

                    DELETE RowErrors.
                END.

                IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                    IF VALID-HANDLE(h-boin356fx) THEN DO:
                        DELETE PROCEDURE h-boin356fx.
                        ASSIGN h-boin356fx = ?.
                    END.
                    IF VALID-HANDLE(h-boin082) THEN DO:
                        DELETE PROCEDURE h-boin082.
                        ASSIGN h-boin082 = ?.
                    END.
                    IF VALID-HANDLE(h-boin657fx) THEN DO:
                        DELETE PROCEDURE h-boin657fx.
                        ASSIGN h-boin657fx = ?.
                    END.
                    RETURN "NOK":U.
            END.
            END.
        END.
    END.
    
    IF VALID-HANDLE(h-boin356fx) THEN DO:
        DELETE PROCEDURE h-boin356fx.
        ASSIGN h-boin356fx = ?.
    END.
    IF VALID-HANDLE(h-boin082) THEN DO:
        DELETE PROCEDURE h-boin082.
        ASSIGN h-boin082 = ?.
    END.
    IF VALID-HANDLE(h-boin657fx) THEN DO:
        DELETE PROCEDURE h-boin657fx.
        ASSIGN h-boin657fx = ?.
    END.

    RETURN "OK":U.
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
    /* Atualiza tabela de Integraá∆o com Mercado Eletronico*/
    IF NOT VALID-HANDLE(apiHandler) THEN DO:
        RUN ccp/ccOrdemCompraValidaIntegraMe.p PERSISTENT SET apiHandler.
    END.    
    
    RUN altera-status-oc-integr-me IN apiHandler (INPUT RowObject.numero-ordem,
                                                  INPUT 3,
                                                  INPUT 1,
                                                  INPUT v_cod_usuar_corren).
    
   IF  CAN-FIND (FIRST funcao WHERE funcao.cd-funcao = "SPP-INTEGRA-PORTAL-ME":U AND funcao.ativo) THEN
       RUN setExecuteUpdate (INPUT YES).

    FINALLY:
        DELETE PROCEDURE apiHandler NO-ERROR.
    END FINALLY.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN beforeCreateUpdateRecord.
    
    /* Desvincular Ordem do Pacote de Compra */
    IF  LOOKUP("nr-processo":U,c-diferencas) <> 0
    AND RowObject.nr-processo                =  0 THEN DO:

        if not VALID-HANDLE(h-boin762) then
            run inbo/boin762.p persistent set h-boin762.

        RUN eliminarCampoLotePregaoOrd IN h-boin762 (INPUT RowObject.numero-ordem).

        IF VALID-HANDLE(h-boin762) THEN DO:
            DELETE PROCEDURE h-boin762.
            ASSIGN h-boin762 = ?.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE canExecuteSplitPurchaseRequisition DBOProgram 
PROCEDURE canExecuteSplitPurchaseRequisition :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se a execuá∆o do split da ordem de compra Ç permitida
               segundo as regras de neg¢cio.
  Parameters:  pExecutaSplitOrdemCompra.: indica que o split pode ser executado
                                          sobre a ordem de compra.
  Notes:       Quando o retorno for igual a YES, deve ser executada a procedure
               prepareSplitPurchaseRequisition para preparaá∆o dos dados para
               realizaá∆o do split da ordem de compra.
               Caso contr†rio, Ç executado o programa CD9400A e a inclus∆o da 
               ordem de compra Ç encerrada
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pExecutaSplitOrdemCompra AS LOGICAL NO-UNDO.

    IF RowObject.nr-contrato = 0 THEN DO:

        FIND FIRST item-fornec
             WHERE item-fornec.it-codigo = RowObject.it-codigo
               AND item-fornec.ativo NO-LOCK NO-ERROR.

        IF AVAIL item-fornec THEN DO:
            /* Verifica se a ordem informada para split N«O est† relacionada a um pacote de compra e
               se a mesma N«O Ç uma ordem m£ltipla */
            IF RowObject.nr-processo = 0 THEN
                ASSIGN pExecutaSplitOrdemCompra = YES.
            ELSE /* split da ordem de compra N«O pode ser executado */
                RUN cdp/cd9400a.p (INPUT RowObject.r-rowid).
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE contractBalance DBOProgram 
PROCEDURE contractBalance :
/*------------------------------------------------------------------------------
  Purpose:     Verifica saldo do contrato.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE de-qtd         AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U NO-UNDO.
    DEFINE VARIABLE de-val         AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U NO-UNDO.
    DEFINE VARIABLE de-val-tot     AS DECIMAL                             NO-UNDO.

    ASSIGN l-ligado = YES.

    IF l-busca-qtd THEN DO:
        ASSIGN de-qtd = tt-ordem.quantidade.
    END.
    ELSE DO:
        ASSIGN de-indice = b-tt-fornec.fator-conver /
                           IF b-tt-fornec.num-casa-dec = 0 THEN 1
                           ELSE EXP(10,b-tt-fornec.num-casa-dec).

        ASSIGN de-qtd = prazo-compra.quantidade * de-indice * (IF tt-fornec.perc-compra > 0 THEN tt-fornec.perc-compra / 100 ELSE 1).
    END.
    
    ASSIGN de-val = de-qtd * item-contrat.pre-unit-for.

    IF de-qtd >= 0 
    OR de-val >= 0 THEN DO:
        
        IF de-val > 0 AND item-contrat.val-total > 0 THEN DO:

            IF de-val + item-contrat.sld-val > (item-contrat.val-total + (item-contrat.val-total * contrato-for.variacao-preco / 100))THEN
                ASSIGN l-ligado = NO.
            ELSE
                IF NOT l-ligado THEN
                    ASSIGN l-ligado = YES.
                ELSE
                    ASSIGN l-ligado2 = YES.
        END.

        IF  l-ligado = YES
        AND de-qtd > 0 AND item-contrat.qtd-total > 0 THEN DO:

            IF de-qtd + item-contrat.sld-qtd > (item-contrat.qtd-total + (item-contrat.qtd-total * contrato-for.variacao-qtd / 100)) THEN
                ASSIGN l-ligado = NO.
            ELSE
                IF NOT l-ligado THEN
                    ASSIGN l-ligado = YES.
                ELSE
                    ASSIGN l-ligado2 = YES.
        END.
        
        IF  l-ligado = YES
        AND item-contrat.qtd-total = 0 
        AND contrato-for.dec-1 > 0 THEN DO: /* Qtd. Total */

            FOR EACH b-item-contrat FIELD (nr-contrato sld-qtd)
               WHERE b-item-contrat.nr-contrato     = contrato-for.nr-contrato 
                 AND b-item-contrat.ind-caract-item = 1  NO-LOCK:             /* considera apenas itens aditivos para calculo do saldo do contrato */

                ASSIGN de-qtd-tot = de-qtd-tot + b-item-contrat.sld-qtd.
            END.

            IF  de-qtd + de-qtd-tot > (contrato-for.dec-1 + (contrato-for.dec-1 * contrato-for.variacao-qtd / 100)) 
            AND item-contrat.ind-caract-item = 1 THEN
                ASSIGN l-ligado = NO.
            ELSE
                IF NOT l-ligado THEN
                    ASSIGN l-ligado = YES.
                ELSE
                    ASSIGN l-ligado2 = YES.

            ASSIGN de-qtd-tot = 0.
        END.

        IF  l-ligado = YES
        AND contrato-for.dec-2 > 0 THEN DO: /* Val. Total */

            FOR EACH b-item-contrat FIELDS (nr-contrato ind-caract-item sld-val)
               WHERE b-item-contrat.nr-contrato     = contrato-for.nr-contrato 
                 AND b-item-contrat.ind-caract-item = 1   NO-LOCK: /* considera apenas itens aditivos para calculo do saldo do contrato */

                ASSIGN de-val-tot = de-val-tot + b-item-contrat.sld-val.
            END.

            IF de-val + de-val-tot > (contrato-for.dec-2 + (contrato-for.dec-2 * contrato-for.variacao-preco / 100)) 
            AND item-contrat.ind-caract-item = 1 THEN
                ASSIGN l-ligado = NO.
            ELSE
                IF NOT l-ligado THEN
                    ASSIGN l-ligado = YES.
                ELSE
                    ASSIGN l-ligado2 = YES.

            ASSIGN de-val-tot = 0.
        END.

        FIND FIRST item-contrat-estab
             WHERE item-contrat-estab.cod-estabel  = c-cod-estabel
               AND item-contrat-estab.cod-emitente = item-contrat.cod-emitente
               AND item-contrat-estab.nr-contrato  = item-contrat.nr-contrato
               AND item-contrat-estab.it-codigo    = item-contrat.it-codigo
               AND item-contrat-estab.num-seq-item = item-contrat.num-seq-item NO-LOCK NO-ERROR.

        IF AVAIL item-contrat-estab THEN DO:

            IF item-contrat-estab.val-total > 0 THEN 
                IF de-val + item-contrat-estab.sld-val > (item-contrat-estab.val-total + (item-contrat-estab.val-total * contrato-for.variacao-preco / 100)) THEN
                    ASSIGN l-ligado = NO.
                ELSE
                    IF NOT l-ligado THEN
                        ASSIGN l-ligado = YES.
                    ELSE
                        ASSIGN l-ligado2 = YES.
            ELSE
                IF item-contrat-estab.qtd-total > 0 THEN DO:
                    IF de-qtd + item-contrat-estab.sld-qtd > (item-contrat-estab.qtd-total + (item-contrat-estab.qtd-total * contrato-for.variacao-qtd / 100)) THEN
                        ASSIGN l-ligado = NO.
                    ELSE
                        IF NOT l-ligado THEN
                            ASSIGN l-ligado = YES.
                        ELSE
                             ASSIGN l-ligado2 = YES. 
                END.        
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createUpdateDeleteDeliverySchedule DBOProgram 
PROCEDURE createUpdateDeleteDeliverySchedule :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if not VALID-HANDLE(h-boin356fx) then
        run inbo/boin356fx.p persistent set h-boin356fx.    
    
    RUN validateDeliverySchedule.
    IF RETURN-VALUE = "NOK":U THEN DO:
        IF VALID-HANDLE(h-boin356fx) THEN DO:
            DELETE PROCEDURE h-boin356fx.
            ASSIGN h-boin356fx = ?.
        END.
        RETURN "NOK":U.
    END.

    /*** Carga dos registros armazenados no Banco de Dados ***/
    RUN setConstraintDeliveriesOfRequisition IN h-boin356fx (INPUT RowObject.numero-ordem).

    RUN openQueryStatic IN h-boin356fx ("DeliveriesOfRequisition":U).

    RUN getBatchRecords IN h-boin356fx (INPUT ?,
                                        INPUT NO,
                                        INPUT ?,
                                        OUTPUT i-num-reg,
                                        OUTPUT TABLE ttPrazoCompra).
    

    /******************************************************************************/
    /*** SINCRONIZAÄ«O DOS REGISTROS PRAZO-COMPRA DA INTERFACE X BANCO DE DADOS ***/
    /******************************************************************************/

    RUN emptyRowErrors IN h-boin356fx.

    RUN openQueryStatic IN h-boin356fx (INPUT "Main":U).

    /*** Eliminaá∆o ***/
    FOR EACH ttPrazoCompra:

        IF NOT CAN-FIND(FIRST ttDeliverySchedule
                        WHERE ttDeliverySchedule.numero-ordem = ttPrazoCompra.numero-ordem
                          AND ttDeliverySchedule.parcela      = ttPrazoCompra.parcela) THEN DO:

            EMPTY TEMP-TABLE ttPrazoCompraAux.
            CREATE ttPrazoCompraAux.
            BUFFER-COPY ttPrazoCompra TO ttPrazoCompraAux.
    
            RUN gotokey IN h-boin356fx (INPUT ttPrazoCompraAux.numero-ordem,
                                        INPUT ttPrazoCompraAux.parcela). 
    
            RUN deleteRecord IN h-boin356fx.
    
            RUN getRowErrors IN h-boin356fx (OUTPUT TABLE RowErrors APPEND).
        END.
    END.

    /*** Criaá∆o/Alteraá∆o ***/
    FOR EACH ttDeliverySchedule:

        EMPTY TEMP-TABLE ttPrazoCompraAux.
        CREATE ttPrazoCompraAux.
        BUFFER-COPY ttDeliverySchedule TO ttPrazoCompraAux.

        RUN gotokey IN h-boin356fx (INPUT ttPrazoCompraAux.numero-ordem, INPUT ttPrazoCompraAux.parcela). 

        IF RETURN-VALUE = "OK":U THEN DO: /* Alteraá∆o */

            RUN setConfigRulesParam IN h-boin356fx(INPUT TABLE ttParamConfigRules).
            RUN setRecord           IN h-boin356fx(INPUT TABLE ttPrazoCompraAux).
            RUN updateRecord        IN h-boin356fx.
        END.    
        ELSE DO: /* Criaá∆o */

            RUN setConfigRulesParam IN h-boin356fx(INPUT TABLE ttParamConfigRules).
            RUN setRecord           IN h-boin356fx(INPUT TABLE ttPrazoCompraAux).
            RUN createRecord        IN h-boin356fx.
        END.
        
        RUN getRowErrors IN h-boin356fx (OUTPUT TABLE RowErrors APPEND).
    END.

    FOR EACH RowErrors
        WHERE RowErrors.ErrorType = "INTERNAL":U:

        DELETE RowErrors.
    END.
    IF VALID-HANDLE(h-boin356fx) THEN DO:
        DELETE PROCEDURE h-boin356fx.
        ASSIGN h-boin356fx = ?.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE executeSplitPurchaseRequisition DBOProgram 
PROCEDURE executeSplitPurchaseRequisition :
/*------------------------------------------------------------------------------
  Purpose:     Executar o split das ordens de compra
  Parameters:  pExecutaSplitOrdemCompra.: executa a divis∆o da ordem de compra
                                          quando usu†rio confirma a execuá∆o.
               tt-ordem-split...........: temp-table para execuá∆o do split
  Notes:       A preparaá∆o dos dados para split da ordem de compra Ç realizada
               na procedure prepareSplitPurchaseRequisition.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pExecutaSplitOrdemCompra AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER TABLE FOR tt-ordem-split.

    EMPTY TEMP-TABLE tt-erro-split.

    IF pExecutaSplitOrdemCompra THEN /* executado quando o split Ç CONFIRMADO */
        RUN cdp/cd9400.p (INPUT RowObject.numero-ordem, /* n£mero da ordem origem */
                          INPUT YES,                    /* exceuta Split?*/
                          INPUT "M":U,                    /* M = Ordem de Compra Manual */
                          INPUT YES,                    /* verifica Contrato de Fornecimento? */
                          INPUT TABLE tt-ordem-split,   /* temp-table com os registros para execuá∆o do split */
                          OUTPUT l-erro,                /* ocorreu erro na execuá∆o? */
                          OUTPUT r-ordem,
                          OUTPUT TABLE tt-ordem,
                          INPUT-OUTPUT TABLE tt-erro-split,
                          INPUT YES).
    ELSE /* executado quando o split Ç CANCELADO, ou o usu†rio opta por N«O EXECUTAR */
        RUN cdp/cd9400a.p (INPUT RowObject.r-rowid).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnSplitPurchaseRequisition DBOFunction 
PROCEDURE returnSplitPurchaseRequisition :
/*------------------------------------------------------------------------------------
  Purpose: Retorna a temp-table com as ordens criadas pelo Split de ordens de compra    
  Parameters:  tt-ordem - Temp-table com as ordens criadas no mÇtodo 
               executeSplitPurchaseRequisition
  Notes:       
-------------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR tt-ordem.
    
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPurchaseRequisitions DBOProgram 
PROCEDURE getPurchaseRequisitions :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir estado.
  Parameters:  pEstado: retorna o estado da requisiá∆o.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR ttRowid.
    DEFINE OUTPUT PARAMETER TABLE FOR ttPurchaseRequisitions.

    FOR EACH ttRowid,
        FIRST ordem-compra
        WHERE ROWID(ordem-compra) = TO-ROWID(ttRowid.rRowid) NO-LOCK:

        FIND FIRST item 
             WHERE item.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.

        FIND FIRST prazo-compra
             WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK NO-ERROR.
            
        CREATE ttPurchaseRequisitions.
        ASSIGN ttPurchaseRequisitions.purchaseRequisition  = ordem-compra.numero-ordem
               ttPurchaseRequisitions.item                 = ordem-compra.it-codigo
               ttPurchaseRequisitions.itemDescription      = IF AVAIL item THEN item.desc-item ELSE "":U
               ttPurchaseRequisitions.buyer                = ordem-compra.cod-comprado
               ttPurchaseRequisitions.site                 = ordem-compra.cod-estabel
               ttPurchaseRequisitions.deliveryDate         = prazo-compra.data-entrega
               ttPurchaseRequisitions.quantity             = ordem-compra.qt-solic
               ttPurchaseRequisitions.situation            = IF AVAIL ordem-compra THEN ordem-compra.situacao ELSE 0
               ttPurchaseRequisitions.situationDescription = {ininc/i02in274.i 04 ordem-compra.situacao}.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- VerIFica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U                 THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U                 THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U              THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-comprado":U           THEN ASSIGN pFieldValue = RowObject.cod-comprado.
        WHEN "cod-entrega":U            THEN ASSIGN pFieldValue = RowObject.cod-entrega.
        WHEN "cod-estab-ctr":U          THEN ASSIGN pFieldValue = RowObject.cod-estab-ctr.
        WHEN "cod-estab-gestor":U       THEN ASSIGN pFieldValue = RowObject.cod-estab-gestor.
        WHEN "cod-estabel":U            THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-grp-compra":U         THEN ASSIGN pFieldValue = RowObject.cod-grp-compra.
        WHEN "cod-refer":U              THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-refer-b2b":U          THEN ASSIGN pFieldValue = RowObject.cod-refer-b2b.
        WHEN "cod-roteiro":U            THEN ASSIGN pFieldValue = RowObject.cod-roteiro.
        WHEN "cod-unid-negoc":U         THEN ASSIGN pFieldValue = RowObject.cod-unid-negoc.
        WHEN "comentarios":U            THEN ASSIGN pFieldValue = RowObject.comentarios.
        WHEN "conta-contabil":U         THEN ASSIGN pFieldValue = RowObject.conta-contabil.
        WHEN "contato":U                THEN ASSIGN pFieldValue = RowObject.contato.
        WHEN "ct-codigo":U              THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "dep-almoxar":U            THEN ASSIGN pFieldValue = RowObject.dep-almoxar.
        WHEN "des-referencia":U         THEN ASSIGN pFieldValue = RowObject.des-referencia.
        WHEN "estab-entrega":U          THEN ASSIGN pFieldValue = RowObject.estab-entrega.
        WHEN "ep-codigo":U              THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        WHEN "hora-atualiz":U           THEN ASSIGN pFieldValue = RowObject.hora-atualiz.
        WHEN "hra-fim-leilao-rfq":U     THEN ASSIGN pFieldValue = RowObject.hra-fim-leilao-rfq.
        WHEN "hra-inicio-leilao-rfq":U  THEN ASSIGN pFieldValue = RowObject.hra-inicio-leilao-rfq.
        WHEN "it-codigo":U              THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "item-pai":U               THEN ASSIGN pFieldValue = RowObject.item-pai.
        WHEN "licenca-import":U         THEN ASSIGN pFieldValue = RowObject.licenca-import.
        WHEN "loc-entrega":U            THEN ASSIGN pFieldValue = RowObject.loc-entrega.
        WHEN "narrativa":U              THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "nr-pedcli":U              THEN ASSIGN pFieldValue = RowObject.nr-pedcli.
        WHEN "nr-tab":U                 THEN ASSIGN pFieldValue = RowObject.nr-tab.
        WHEN "requisitante":U           THEN ASSIGN pFieldValue = RowObject.requisitante.
        WHEN "sc-codigo":U              THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "usuario":U                THEN ASSIGN pFieldValue = RowObject.usuario.
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE         NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dat-fim-leilao-rfq":U     THEN ASSIGN pFieldValue = RowObject.dat-fim-leilao-rfq.
        WHEN "dat-inicio-leilao-rfq":U  THEN ASSIGN pFieldValue = RowObject.dat-inicio-leilao-rfq.
        WHEN "dat-ordem":U              THEN ASSIGN pFieldValue = RowObject.dat-ordem.
        WHEN "data-1":U                 THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U                 THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-atualiz":U           THEN ASSIGN pFieldValue = RowObject.data-atualiz.
        WHEN "data-cotacao":U           THEN ASSIGN pFieldValue = RowObject.data-cotacao.
        WHEN "data-emissao":U           THEN ASSIGN pFieldValue = RowObject.data-emissao.
        WHEN "data-pedido":U            THEN ASSIGN pFieldValue = RowObject.data-pedido.
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL      NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "aliquota-icm":U   THEN ASSIGN pFieldValue = RowObject.aliquota-icm.
        WHEN "aliquota-ipi":U   THEN ASSIGN pFieldValue = RowObject.aliquota-ipi.
        WHEN "aliquota-iss":U   THEN ASSIGN pFieldValue = RowObject.aliquota-iss.
        WHEN "dec-1":U          THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U          THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "ind-reajuste":U   THEN ASSIGN pFieldValue = RowObject.ind-reajuste.
        WHEN "perc-descto":U    THEN ASSIGN pFieldValue = RowObject.perc-descto.
        WHEN "perc-sales-tax":U THEN ASSIGN pFieldValue = RowObject.perc-sales-tax.
        WHEN "perc-vat":U       THEN ASSIGN pFieldValue = RowObject.perc-vat.
        WHEN "pre-unit-for":U   THEN ASSIGN pFieldValue = RowObject.pre-unit-for.
        WHEN "preco-fornec":U   THEN ASSIGN pFieldValue = RowObject.preco-fornec.
        WHEN "preco-orig":U     THEN ASSIGN pFieldValue = RowObject.preco-orig.
        WHEN "preco-unit":U     THEN ASSIGN pFieldValue = RowObject.preco-unit.
        WHEN "qt-acum-dev":U    THEN ASSIGN pFieldValue = RowObject.qt-acum-dev.
        WHEN "qt-acum-nec":U    THEN ASSIGN pFieldValue = RowObject.qt-acum-nec.
        WHEN "qt-acum-rec":U    THEN ASSIGN pFieldValue = RowObject.qt-acum-rec.
        WHEN "qt-solic":U       THEN ASSIGN pFieldValue = RowObject.qt-solic.
        WHEN "saldo-emb":U      THEN ASSIGN pFieldValue = RowObject.saldo-emb.
        WHEN "saldo-gi":U       THEN ASSIGN pFieldValue = RowObject.saldo-gi.
        WHEN "valor-descto":U   THEN ASSIGN pFieldValue = RowObject.valor-descto.
        WHEN "valor-frete":U    THEN ASSIGN pFieldValue = RowObject.valor-frete.
        WHEN "valor-taxa":U     THEN ASSIGN pFieldValue = RowObject.valor-taxa.
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER   NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cdn-fabrican":U       THEN ASSIGN pFieldValue = RowObject.cdn-fabrican.
        WHEN "cod-cond-pag":U       THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente":U       THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-maq-origem":U     THEN ASSIGN pFieldValue = RowObject.cod-maq-origem.
        WHEN "cod-transp":U         THEN ASSIGN pFieldValue = RowObject.cod-transp.
        WHEN "codigo-icm":U         THEN ASSIGN pFieldValue = RowObject.codigo-icm.
        WHEN "cota-ordem":U         THEN ASSIGN pFieldValue = RowObject.cota-ordem.
        WHEN "int-1":U              THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U              THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "linha":U              THEN ASSIGN pFieldValue = RowObject.linha.
        WHEN "local-entrega":U      THEN ASSIGN pFieldValue = RowObject.local-entrega.
        WHEN "mo-codigo":U          THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "natureza":U           THEN ASSIGN pFieldValue = RowObject.natureza.
        WHEN "nr-alt-preco":U       THEN ASSIGN pFieldValue = RowObject.nr-alt-preco.
        WHEN "nr-contrato":U        THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        WHEN "nr-contrato-venda":U  THEN ASSIGN pFieldValue = RowObject.nr-contrato-venda.
        WHEN "nr-dias-taxa":U       THEN ASSIGN pFieldValue = RowObject.nr-dias-taxa.
        WHEN "nr-ord-orig":U        THEN ASSIGN pFieldValue = RowObject.nr-ord-orig.
        WHEN "nr-processo":U        THEN ASSIGN pFieldValue = RowObject.nr-processo.
        WHEN "nr-requisicao":U      THEN ASSIGN pFieldValue = RowObject.nr-requisicao.
        WHEN "nr-seq-contr":U       THEN ASSIGN pFieldValue = RowObject.nr-seq-contr.
        WHEN "nr-seq-contr-it":U    THEN ASSIGN pFieldValue = RowObject.nr-seq-contr-it.
        WHEN "num-id-documento":U   THEN ASSIGN pFieldValue = RowObject.num-id-documento.
        WHEN "num-ord-inv":U        THEN ASSIGN pFieldValue = RowObject.num-ord-inv.
        WHEN "num-pedido":U         THEN ASSIGN pFieldValue = RowObject.num-pedido.
        WHEN "num-processo-mp":U    THEN ASSIGN pFieldValue = RowObject.num-processo-mp.
        WHEN "num-seq-item":U       THEN ASSIGN pFieldValue = RowObject.num-seq-item.
        WHEN "numero-ordem":U       THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "op-codigo":U          THEN ASSIGN pFieldValue = RowObject.op-codigo.
        WHEN "op-seq":U             THEN ASSIGN pFieldValue = RowObject.op-seq.
        WHEN "ordem-servic":U       THEN ASSIGN pFieldValue = RowObject.ordem-servic.
        WHEN "origem":U             THEN ASSIGN pFieldValue = RowObject.origem.
        WHEN "origem-aprov":U       THEN ASSIGN pFieldValue = RowObject.origem-aprov.
        WHEN "pend-aprov":U         THEN ASSIGN pFieldValue = RowObject.pend-aprov.
        WHEN "prazo-entreg":U       THEN ASSIGN pFieldValue = RowObject.prazo-entreg.
        WHEN "prioridade-aprov":U   THEN ASSIGN pFieldValue = RowObject.prioridade-aprov.
        WHEN "seq-evento":U         THEN ASSIGN pFieldValue = RowObject.seq-evento.
        WHEN "seq-ped-venda":U      THEN ASSIGN pFieldValue = RowObject.seq-ped-venda.
        WHEN "sequencia":U          THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "sit-ordem-contrat":U  THEN ASSIGN pFieldValue = RowObject.sit-ordem-contrat.
        WHEN "situacao":U           THEN ASSIGN pFieldValue = RowObject.situacao.
        WHEN "tp-despesa":U         THEN ASSIGN pFieldValue = RowObject.tp-despesa.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ordem
  Parameters:  
               retorna valor do campo numero-ordem
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnumero-ordem = RowObject.numero-ordem.

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
        WHEN "codigo-ipi":U     THEN ASSIGN pFieldValue = RowObject.codigo-ipi.
        WHEN "cons-mrp":U       THEN ASSIGN pFieldValue = RowObject.cons-mrp.
        WHEN "cons-pmp":U       THEN ASSIGN pFieldValue = RowObject.cons-pmp.
        WHEN "expectativa":U    THEN ASSIGN pFieldValue = RowObject.expectativa.
        WHEN "frete":U          THEN ASSIGN pFieldValue = RowObject.frete.
        WHEN "gera-edi":U       THEN ASSIGN pFieldValue = RowObject.gera-edi.
        WHEN "impr-ficha":U     THEN ASSIGN pFieldValue = RowObject.impr-ficha.
        WHEN "ind-extrac":U     THEN ASSIGN pFieldValue = RowObject.ind-extrac.
        WHEN "log-1":U          THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U          THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-cot-aberta":U THEN ASSIGN pFieldValue = RowObject.log-cot-aberta.
        WHEN "log-leilao":U     THEN ASSIGN pFieldValue = RowObject.log-leilao.
        WHEN "ordem-emitida":U  THEN ASSIGN pFieldValue = RowObject.ordem-emitida.
        WHEN "reaj-tabela":U    THEN ASSIGN pFieldValue = RowObject.reaj-tabela.
        WHEN "taxa-financ":U    THEN ASSIGN pFieldValue = RowObject.taxa-financ.
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
  Purpose:     Reposiciona registro com base no °ndice ordem
  Parameters:  
               recebe valor do campo numero-ordem
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

    FIND FIRST bfordem-compra
         WHERE bfordem-compra.numero-ordem = pnumero-ordem NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfordem-compra THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfordem-compra)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE identifyChanges DBOProgram 
PROCEDURE identifyChanges :
/*------------------------------------------------------------------------------
  Purpose:     Identificar os campos alterados
  Parameters:  pDiferencas: lista dos campos alterados, separados por v°rgula
  Notes:       Identifica os campos alterados para executar regras de neg¢cio
               que est∆o atreladas ao campo alterado.
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pDiferencas AS CHARACTER NO-UNDO.

    {cdp/findordemcompra.i RowObject.numero-ordem}
    IF  AVAIL ordem-compra THEN
        BUFFER-COMPARE ordem-compra TO RowObject SAVE RESULT IN pDiferencas.

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

    OPEN QUERY {&QueryName}
        FOR EACH ordem-compra NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prepareSplitPurchaseRequisition DBOProgram 
PROCEDURE prepareSplitPurchaseRequisition :
/*------------------------------------------------------------------------------
  Purpose:     Prepara os dados para a execuá∆o do split da ordem de compra.
  Parameters:  pExecutaSplitOrdemCompra.: indica que o split da ordem de compra
                                          pode ser executada e para isso prepara
                                          os dados para realizaá∆o do split.
               tt-ordem.................: temp-table com os percentuais para o
                                          split da ordem de compra.
  Notes:       Esta procedure prepara os dados para execuá∆o do split da ordem
               de compra e deve ser executada ap¢s a procedure
               canExecuteSplitPurchaseRequisition. O tratamento de split Ç
               executado pela procedure executeSplitPurchaseRequisition.
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pExecutaSplitOrdemCompra AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-ordem.

    {cdp/findparamcompra.i}

    IF  pExecutaSplitOrdemCompra THEN DO:
    
        /**********************************************************/
        /*** PREPARAÄ«O DOS DADOS PARA SPLIT DA ORDEM DE COMPRA ***/
        /**********************************************************/
    
        ASSIGN i-num-ordem  = RowObject.numero-ordem
               i-num-parce  = 1
               i-sequencia  = 1.
    
        IF param-compra.perm-cot-for = YES THEN
            ASSIGN l-ativo = ?.
        ELSE
            ASSIGN l-ativo = NO.
    
        {cdp/findordemcompra.i i-num-ordem}

        ASSIGN c-cod-estabel = RowObject.cod-estabel.
    
        /* Selec∆o dos fornecedores do item */
        EMPTY TEMP-TABLE tt-fornec.
    
        /* Fornecedores relacionados ao Item X Fonecedor x Estabelecimento */
        FOR EACH item-fornec-estab
            WHERE item-fornec-estab.it-codigo = RowObject.it-codigo
              AND item-fornec-estab.cod-estabel = RowObject.cod-estabel NO-LOCK:

            CREATE tt-fornec.
            ASSIGN tt-fornec.cod-emitente = item-fornec-estab.cod-emitente
                   tt-fornec.it-codigo    = item-fornec-estab.it-codigo
                   tt-fornec.horiz-fixo   = item-fornec-estab.horiz-fixo
                   tt-fornec.ativo        = item-fornec-estab.ativo
                   tt-fornec.contr-forn   = item-fornec-estab.contr-forn
                   tt-fornec.fator-conver = item-fornec-estab.fator-conver
                   tt-fornec.num-casa-dec = item-fornec-estab.num-casa-dec
                   tt-fornec.perc-compra  = item-fornec-estab.perc-compra
                   tt-fornec.cot-aut      = item-fornec-estab.cot-aut
                   tt-fornec.cod-cond-pag = item-fornec-estab.cod-cond-pag
                   tt-fornec.unid-med-for = item-fornec-estab.unid-med-for
                   tt-fornec.lote-mul-for = item-fornec-estab.lote-mul-for
                   tt-fornec.lote-minimo  = item-fornec-estab.lote-minimo
                   tt-fornec.i-seq        = 1. /*registro criado a partir da tabela item-fornec-estab*/
        END.
    
        /*PROJETO CONVERS«O HTML - Alterado para n∆o buscar os fornecedores do item quando 
          existir algum na item-fornec-estab conforme regra da tela progress*/
        IF NOT CAN-FIND(FIRST tt-fornec) THEN DO:
            /* Fornecedores relacionados ao Item X Fonecedor */
            FOR EACH item-fornec
                WHERE item-fornec.it-codigo = RowObject.it-codigo NO-LOCK:

                CREATE tt-fornec.
                ASSIGN tt-fornec.cod-emitente = item-fornec.cod-emitente
                       tt-fornec.it-codigo    = item-fornec.it-codigo
                       tt-fornec.horiz-fixo   = item-fornec.horiz-fixo
                       tt-fornec.ativo        = item-fornec.ativo
                       tt-fornec.contr-forn   = item-fornec.contr-forn
                       tt-fornec.fator-conver = item-fornec.fator-conver
                       tt-fornec.num-casa-dec = item-fornec.num-casa-dec
                       tt-fornec.perc-compra  = item-fornec.perc-compra
                       tt-fornec.cot-aut      = item-fornec.cot-aut
                       tt-fornec.cod-cond-pag = item-fornec.cod-cond-pag
                       tt-fornec.unid-med-for = item-fornec.unid-med-for
                       tt-fornec.lote-mul-for = item-fornec.lote-mul-for
                       tt-fornec.lote-minimo  = item-fornec.lote-minimo
                       tt-fornec.i-seq        = 2. /*registro criado a partir da tabela item-fornec*/
            END.
        END.
        /* Fim selec∆o dos fornecedores do item */
    
        FOR EACH prazo-compra
           WHERE prazo-compra.numero-ordem = i-num-ordem NO-LOCK:
    
            ASSIGN de-qtidade = 0.
    
            FOR EACH b-tt-fornec USE-INDEX onde-compra
                WHERE b-tt-fornec.it-codigo = RowObject.it-codigo
                  AND b-tt-fornec.ativo <> l-ativo
                BY b-tt-fornec.i-seq /*foráa a ordenaá∆o dos registros da item-fornec-estab antes da item-fornec*/
                BY b-tt-fornec.perc-compra DESCENDING:
    
                {cdp/findemitente.i b-tt-fornec.cod-emitente}
    
                CREATE tt-ordem.
                ASSIGN tt-ordem.sequencia     = i-sequencia
                       tt-ordem.numero-ordem  = prazo-compra.numero-ordem
                       tt-ordem.parcela       = prazo-compra.parcela
                       tt-ordem.fornec        = b-tt-fornec.cod-emitente
                       tt-ordem.nome-fornec   = emitente.nome-abrev
                       tt-ordem.quantidade    = 0
                       tt-ordem.data-entrega  = prazo-compra.data-entrega
                       tt-ordem.contr-forn    = b-tt-fornec.contr-forn.
    
                IF b-tt-fornec.contr-forn = YES THEN DO:
                    ASSIGN l-ligado = NO.

                    IF b-tt-fornec.horiz-fixo <> 0 THEN DO:

                        ASSIGN da-horiz-fixo = TODAY + b-tt-fornec.horiz-fixo - 1.

                        IF da-horiz-fixo >= prazo-compra.data-entrega THEN
                            NEXT.
                    END.

                    ASSIGN l-busca-qtd = NO.
                    IF  b-tt-fornec.perc-compra > 0 THEN DO:
                        {cdp/cd9400.i2}
                        ASSIGN l-busca-qtd = YES.
                    END.
    
                    FOR EACH item-contrat
                       WHERE item-contrat.it-codigo    = b-tt-fornec.it-codigo
                         AND item-contrat.log-libera   = YES
                         AND item-contrat.ind-sit-item = 2 /* Emitido */
                         AND item-contrat.cod-emitente    = b-tt-fornec.cod-emitente NO-LOCK:
    
                        FIND FIRST contrato-for
                             WHERE contrato-for.nr-contrato = item-contrat.nr-contrato NO-LOCK NO-ERROR.

                        IF AVAIL contrato-for THEN DO:
    
                            IF  contrato-for.log-libera = YES
                            AND (    contrato-for.dt-ini-validade <= prazo-compra.data-entrega
                                AND contrato-for.dt-ter-validade >= prazo-compra.data-entrega) THEN DO:
    
                                FIND FIRST pedido-compr
                                     WHERE pedido-compr.nr-contrato = contrato-for.nr-contrato
                                       AND pedido-compr.end-entrega = RowObject.cod-estabel NO-LOCK NO-ERROR.

                                IF AVAIL pedido-compr THEN DO:
                                    IF (item-contrat.val-total <> 0 OR
                                        item-contrat.qtd-total <> 0 OR
                                        contrato-for.dec-1     <> 0 OR
                                        contrato-for.dec-2     <> 0) THEN
                                        RUN contractBalance. /* Verifica saldo do contrato */
                                    ELSE
                                        ASSIGN l-ligado = YES.
                                END.

                                IF  contrato-for.ind-sit-contrat <> 2 /* Emitido */ THEN
                                    ASSIGN l-ligado = NO.

                                IF  item-contrat.ind-tipo-control = 3 /*Programaªío*/ THEN 
                                    ASSIGN l-ligado = NO.
                            END.
                        END.
                    END.
    
                    ASSIGN tt-ordem.contr-forn = l-ligado.

                    IF  l-busca-qtd = NO THEN DO:
                        {cdp/cd9400.i2} 
                    END.
                END.
                ELSE DO:
                    IF b-tt-fornec.horiz-fixo <> 0 THEN DO:
                        ASSIGN da-horiz-fixo = today + b-tt-fornec.horiz-fixo - 1.
                        IF da-horiz-fixo >= prazo-compra.data-entrega
                            THEN next.
                    END.
                    {cdp/cd9400.i2}
                END.
    
                ASSIGN i-sequencia = i-sequencia + 1.
            END.
    
            {utp/ut-liter.i Outros * R}
            CREATE tt-ordem.
            ASSIGN tt-ordem.sequencia       = i-sequencia
                   tt-ordem.numero-ordem    = prazo-compra.numero-ordem
                   tt-ordem.parcela         = prazo-compra.parcela
                   tt-ordem.fornec          = 0
                   tt-ordem.nome-fornec     = RETURN-VALUE
                   tt-ordem.quantidade      = 0
                   tt-ordem.data-entrega    = prazo-compra.data-entrega
                   tt-ordem.contr-forn       = NO.
    
            IF prazo-compra.quantidade > de-qtidade THEN
                ASSIGN tt-ordem.quantidade = prazo-compra.quantidade - de-qtidade.
    
            ASSIGN i-sequencia              = i-sequencia + 1
                   pExecutaSplitOrdemCompra = YES. /* indica que o split pode ser executado sobre a ordem de compra */
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConfigRulesParam DBOProgram 
PROCEDURE setConfigRulesParam :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR ttParamConfigRules.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setInterfaceParameters DBOProgram 
PROCEDURE setInterfaceParameters :
/*------------------------------------------------------------------------------
  Purpose:     Recebe atravÇs da temp-table ttParametrosTela os parÉmetros
               necess†rios a execuá∆o das regras de neg¢cio do DBO.
  Parameters:  ttParametrosTela.: temp-table genÇrica contendo os parÉmetros
                                  setados em tela pelo usu†rio.
  Notes:       A inicializaá∆o dos parÉmetros Ç de SUMA IMPORT∂NCIA para que
               a execuá∆o das regras de neg¢cio n∆o ocorra de modo indevido.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR ttParametrosTela.

    /* Inicilizaá∆o dos parÉmetros */
    ASSIGN l-AtualizaParcelas       = YES
           l-ExportaOrdensMultiplas = NO.

    FOR EACH ttParametrosTela:
        CASE ttParametrosTela.parametro:
            /* Atualizaá∆o das parcelas da ordem de compra */
            /* Quando n∆o  */
            WHEN "atualiza-parcelas":U THEN
                ASSIGN l-AtualizaParcelas = ttParametrosTela.valor = "YES":U.
            /* Exportar alteraá‰es efetuadas para as Ordens M£ltiplas */
            WHEN "exporta-ordens-multiplas":U THEN
                ASSIGN l-ExportaOrdensMultiplas = ttParametrosTela.valor = "YES":U.
        END CASE.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTTDeliverySchedule DBOProgram 
PROCEDURE setTTDeliverySchedule :
/*------------------------------------------------------------------------------
  Purpose:     Recebe como parÉmetro a temp-table das parcelas para atualizaá∆o
               do banco de dados conforme alteraá‰es efetuadas na interface.
  Parameters:  ttDeliverySchedule.: temp-table com as parcelas de ordem de compra.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR ttDeliverySchedule.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateBtUpdateRequisition DBOProgram 
PROCEDURE validateBtUpdateRequisition :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-msg-param-1 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-msg-param-2 AS CHARACTER NO-UNDO.

    IF  RowObject.situacao <> 1
    AND RowObject.situacao <> 5 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="5987"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="''"}
        RETURN "NOK":U.                            
    END.

    /*** MULTIPLANTA ***/
    IF  param-global.modulo-mp THEN DO:
        
        RUN ccp/ccapi199.p (INPUT "Ordem-compra":U, INPUT ROWID(ordem-compra), OUTPUT l-erro).

        IF l-erro THEN DO:

            {utp/ut-liter.i Ordem}
            ASSIGN c-msg-param-1 = TRIM(RETURN-VALUE).
            {utp/ut-liter.i Gestor}
            ASSIGN c-msg-param-2 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="18200"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-msg-param-1 + '~~~~' + c-msg-param-2"}
            RETURN "NOK":U.
        END.
    END.
     /*******************/
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateContract DBOProgram 
PROCEDURE validateContract :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es referente a Contratos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    IF  pType = "Create":U
    OR  pType = "Update":U THEN DO:

        IF  RowObject.nr-contrato <> 0 THEN DO:
        
            /* Validaá‰es relacionadas ao contrato */
            {cdp/findcontratofor.i RowObject.nr-contrato}
            IF  NOT AVAIL contrato-for THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="15522"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="''"}
                RETURN "NOK":U.
            END.
            ELSE DO:
        
                IF NOT contrato-for.log-libera THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="15208"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="''"}
                    RETURN "NOK":U.
                END.
        
                /* Validaá‰es relacionadas ao item do contrato */
                {cdp/finditemcontrat.i contrato-for.nr-contrato RowObject.num-seq-item}
                IF NOT AVAIL item-contrat THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="15520"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="''"}
                    RETURN "NOK":U.
                END.
                ELSE DO:
        
                    IF item-contrat.ind-tipo-control <> 2 THEN DO: /* Ordem */
                        {method/svc/errors/inserr.i &ErrorNumber="8504"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="''"}
                        RETURN "NOK":U.
                    END.
                    IF item-contrat.ind-sit-item <> 2 THEN DO: /* Emitido */
                        {method/svc/errors/inserr.i &ErrorNumber="15896"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="''"}
                        RETURN "NOK":U.
                    END.
                    IF NOT item-contrat.log-libera THEN DO:
                        
                        {method/svc/errors/inserr.i &ErrorNumber="7838"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="''"}
                        RETURN "NOK":U.
                    END.
                    IF item-contrat.it-codigo <> RowObject.it-codigo THEN DO:
                        {method/svc/errors/inserr.i &ErrorNumber="8503"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="''"}
                        RETURN "NOK":U.
                    END.

                    /* Validaá‰es relacionadas a Matriz de Rateio do Contrato/Item x Conta Cont†bil*/
                    IF item.tipo-contr = 4 THEN DO: /* DÇbito Direto */
                        
                        ASSIGN l-consiste-conta = NO.
            
                        IF param-contrat.controle-rateio THEN DO:
            
                            IF contrato-for.ind-control-rec = 1 THEN DO: /* Total Nota */
        
                                IF (RowObject.ct-codigo + RowObject.sc-codigo) = "" THEN DO:
        
                                    IF CAN-FIND(FIRST matriz-rat-contr
                                                WHERE matriz-rat-contr.nr-contrato = item-contrat.nr-contrato
                                                  AND matriz-rat-contr.perc-rateio > 0) THEN DO:
                                        {utp/ut-liter.i "Conta e/ou Centro de Custo"}
                                        {method/svc/errors/inserr.i &ErrorNumber="158"
                                                                    &ErrorType="EMS"
                                                                    &ErrorSubType="ERROR"
                                                                    &ErrorParameters="return-value"}
                                        RETURN "NOK":U.
                                    END.
                                END.
                                ELSE DO:
                                    IF NOT CAN-FIND(FIRST matriz-rat-contr
                                                    WHERE matriz-rat-contr.nr-contrato = item-contrat.nr-contrato
                                                      AND matriz-rat-contr.ct-codigo  = RowObject.ct-codigo
                                                      AND matriz-rat-contr.sc-codigo  = RowObject.sc-codigo) THEN DO:

                                        IF CAN-FIND(FIRST matriz-rat-contr
                                                    WHERE matriz-rat-contr.nr-contrato = item-contrat.nr-contrato) THEN DO:
                                            {method/svc/errors/inserr.i &ErrorNumber="17715"
                                                                        &ErrorType="EMS"
                                                                        &ErrorSubType="ERROR"
                                                                        &ErrorParameters="''"}
                                            RETURN "NOK":U.
                                        END.
                                        ELSE 
                                            ASSIGN l-consiste-conta = YES.
                                    END.
                                END.
                            END.
                            ELSE IF contrato-for.ind-control-rec = 2 THEN DO: /* Item */
                    
                                IF (RowObject.ct-codigo + RowObject.sc-codigo) = "" THEN DO:
                    
                                    IF NOT CAN-FIND(FIRST matriz-rat-item
                                                     WHERE matriz-rat-item.nr-contrato  = item-contrat.nr-contrato
                                                       AND matriz-rat-item.num-seq-item = item-contrat.num-seq-item
                                                       AND matriz-rat-item.perc-rateio  > 0) THEN DO:
                    
                                        IF NOT CAN-FIND(FIRST matriz-rat-contr
                                                         WHERE matriz-rat-contr.nr-contrato = item-contrat.nr-contrato
                                                           AND matriz-rat-contr.perc-rateio > 0) THEN DO:
                                            {utp/ut-liter.i "Conta e/ou Centro de Custo"}
                                            {method/svc/errors/inserr.i &ErrorNumber="158"
                                                                        &ErrorType="EMS"
                                                                        &ErrorSubType="ERROR"
                                                                        &ErrorParameters="return-value"}
                                            RETURN "NOK":U.
                                        END.
                                        ELSE DO:
                                            {method/svc/errors/inserr.i &ErrorNumber="15221"
                                                                        &ErrorType="EMS"
                                                                        &ErrorSubType="INFORMATION"
                                                                        &ErrorParameters="''"}
                                        END.
                                    END.
                                END.
                                ELSE DO:
                                    IF not CAN-FIND(FIRST matriz-rat-item
                                                    WHERE matriz-rat-item.nr-contrato   = item-contrat.nr-contrato
                                                      AND matriz-rat-item.num-seq-item = item-contrat.num-seq-item
                                                      AND matriz-rat-item.ct-codigo    = RowObject.ct-codigo
                                                      AND matriz-rat-item.sc-codigo    = RowObject.sc-codigo) THEN DO:
        
                                        IF CAN-FIND(FIRST matriz-rat-contr
                                                    WHERE matriz-rat-contr.nr-contrato  = item-contrat.nr-contrato
                                                      AND matriz-rat-item.ct-codigo    = RowObject.ct-codigo
                                                      AND matriz-rat-item.sc-codigo    = RowObject.sc-codigo) THEN DO:
        
                                            IF CAN-FIND(FIRST matriz-rat-item
                                                        WHERE matriz-rat-item.nr-contrato   = item-contrat.nr-contrato
                                                          AND matriz-rat-item.num-seq-item = item-contrat.num-seq-item)
                                            OR CAN-FIND(FIRST matriz-rat-contr
                                                        WHERE matriz-rat-contr.nr-contrato = item-contrat.nr-contrato) THEN DO:
                                                {method/svc/errors/inserr.i &ErrorNumber="17715"
                                                                            &ErrorType="EMS"
                                                                            &ErrorSubType="ERROR"
                                                                            &ErrorParameters="''"}
                                                RETURN "NOK":U.
                                            END.
                                            ELSE
                                                ASSIGN l-consiste-conta = YES.
                                        END.
                                    END.
                                END.
                            END.
                        END.
                    END. /* Fim Validaá‰es Matriz Rateio Contrato/Item */
                END. /* Fim Validaá‰es relacionadas ao item do contrato */
            END. /* Fim Validaá‰es relacionadas ao contrato */
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDeliverySchedule DBOProgram 
PROCEDURE validateDeliverySchedule :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Validaá∆o relacionada a quantidade da ordem x total das parcelas */
    {cdp/finditemuniestab.i RowObject.it-codigo RowObject.cod-estabel}

    ASSIGN de-total-parcela = 0.

    FOR EACH ttDeliverySchedule
       WHERE ttDeliverySchedule.numero-ordem = RowObject.numero-ordem NO-LOCK:
        
        ASSIGN de-total-parcela = ttDeliverySchedule.quantidade.
           
        
        FIND FIRST ttParamConfigRules NO-ERROR.
    
        /* Validaá∆o Lote M°nimo */
        IF ttParamConfigRules.allowMinimumLot THEN DO:
            IF  de-total-parcela < item-uni-estab.lote-minimo THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="27647"
                                            &ErrorType="EMS"
                                            &ErrorSubType="WARNING"
                                            &ErrorParameters="string(de-total-parcela) + '~~~~' + string(item-uni-estab.lote-minimo)"}
                                            
            END.
        END.
        ELSE DO:
            IF  de-total-parcela < item-uni-estab.lote-minimo THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="27648"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="string(de-total-parcela) + '~~~~' + string(item-uni-estab.lote-minimo)"}
            END.
        END.
    
        /* Validaá∆o Lote M£ltiplo */
        IF ttParamConfigRules.allowDIFferentMultipleLot THEN DO:
            IF  item-uni-estab.lote-multipl <> 0 
            AND de-total-parcela <> INT64(de-total-parcela / item-uni-estab.lote-multipl) * item-uni-estab.lote-multipl THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="27643"
                                            &ErrorType="EMS"
                                            &ErrorSubType="WARNING"
                                            &ErrorParameters="string(de-total-parcela) + '~~~~' + string(item-uni-estab.lote-multipl)"}
            END.
        END.
        ELSE DO:
            IF  item-uni-estab.lote-multipl <> 0 
            AND de-total-parcela <> INT64(de-total-parcela / item-uni-estab.lote-multipl) * item-uni-estab.lote-multipl THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="27644"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="string(de-total-parcela) + '~~~~' + string(item-uni-estab.lote-multipl)"}
            END.
        END.
    END. 
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateInvestments DBOProgram 
PROCEDURE validateInvestments :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es referente a Investimentos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    DEFINE VARIABLE c-desc-ordem-inv        AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE l-avail-sub-div-ordem   AS LOGICAL       NO-UNDO.
    DEFINE VARIABLE c-ct-codigo-inv         AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE c-sc-codigo-inv         AS CHARACTER     NO-UNDO.

    IF  pType = "Create":U
    OR  pType = "Update":U THEN DO:

        IF CONNECTED("mginv":U) AND param-global.modulo-in AND RowObject.num-ord-inv <> 0 THEN DO:

            {cdp/findestabelec.i RowObject.cod-estabel}
            IF AVAIL estabelec THEN DO:
                RUN inp/in2112a.p (INPUT  estabelec.ep-codigo,
                                   INPUT  RowObject.num-ord-inv,
                                   OUTPUT c-desc-ordem-inv,
                                   OUTPUT l-avail-sub-div-ordem,
                                   OUTPUT c-ct-codigo-inv,
                                   OUTPUT c-sc-codigo-inv).

                IF NOT l-avail-sub-div-ordem THEN DO:
                    {utp/ut-table.i mginv ordem-inv 1}
                    {method/svc/errors/inserr.i &ErrorNumber="56"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="return-value"} 
                    RETURN "NOK":U.
                END.
            END.
        END.

        IF (RowObject.ct-codigo + RowObject.sc-codigo) <> "" AND 
           ((RowObject.ordem-servic <> 0 AND RowObject.num-ord-inv  = 0) OR 
            (RowObject.ordem-servic  = 0 AND RowObject.num-ord-inv <> 0) OR 
            (RowObject.ordem-servic  = 0 AND RowObject.num-ord-inv  = 0)) THEN DO:

            {inp/inapi060.i RowObject.cod-estabel RowObject.ct-codigo RowObject.sc-codigo RowObject.num-ord-inv no tt-erro1}

            IF RETURN-VALUE = "NOK":U THEN DO:
                FOR EACH tt-erro1:
                    RUN _insertErrorManual (INPUT tt-erro1.cd-erro,
                                            INPUT "EMS":U,
                                            INPUT "ERROR":U,
                                            INPUT tt-erro1.mensagem,
                                            INPUT "":U,
                                            INPUT tt-erro1.c-param).
                END.
            END.
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateProduction DBOProgram 
PROCEDURE validateProduction :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es referente a Produá∆o
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    IF  pType = "Create":U
    OR  pType = "Update":U THEN DO:

        IF param-global.modulo-cp AND RowObject.ordem-servic > 0 THEN DO:

            {cdp/findordprod.i RowObject.ordem-servic}
            IF NOT AVAIL ord-prod THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="1379"
                                            &ErrorType="EMS"
                                            &ErrorSubType="WARNING"
                                            &ErrorParameters="RETURN-VALUE"}
            END.
            ELSE DO:                
                /** Ordens de Manutená∆o Industrial (MI) **/
                IF param-global.modulo-mi THEN DO:            
                    /** Busca a Ordem de Manutená∆o **/
                    FOR FIRST ord-manut FIELDS(estado-om estado)
                        WHERE ord-manut.nr-ord-produ = ord-prod.nr-ord-produ NO-LOCK:

                        IF ord-manut.estado-om = 4 THEN DO:
                            IF ord-manut.estado    = 8 
                            OR (ord-manut.estado   = 7
                            AND NOT CAN-FIND(FIRST funcao 
                                            WHERE funcao.cd-funcao = "spp-ativa-ordem-term":U
                                              AND funcao.ativo     = YES NO-LOCK)) THEN DO:
                                {method/svc/errors/inserr.i &ErrorNumber="28341"
                                                            &ErrorType="EMS"
                                                            &ErrorSubType="ERROR"
                                                            &ErrorParameters="STRING(ord-prod.nr-ord-produ)"}
                                RETURN "NOK":U.
                            END.
                        END.        
                    END.
                END.
                IF NOT AVAIL ord-manut THEN DO:
                    /** Ordens de Manutená∆o Mecanica (MV) **/
                    IF ord-prod.origem = "MV":U THEN DO:                        
                        IF ord-prod.estado    = 8 
                        OR (ord-prod.estado   = 7
                        AND NOT CAN-FIND(FIRST funcao 
                                        WHERE funcao.cd-funcao = "spp-ativa-ordem-term":U
                                          AND funcao.ativo     = YES NO-LOCK)) THEN DO:
                            {method/svc/errors/inserr.i &ErrorNumber="28341"
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="ERROR"
                                                        &ErrorParameters="STRING(ord-prod.nr-ord-produ)"}
                            RETURN "NOK":U.
                        END.                        
                    END.  
                    /** Ordens de Produá∆o **/
                    ELSE DO: 
                        IF ord-prod.estado = 7 THEN DO: /* Finalizada */
                            {method/svc/errors/inserr.i &ErrorNumber="1882"
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="ERROR"
                                                        &ErrorParameters="return-value"}
                            RETURN "NOK":U.
                        END.    
                        IF  ord-prod.estado = 8 THEN DO: /* Terminada */
                            {method/svc/errors/inserr.i &ErrorNumber="1380"
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="ERROR"
                                                        &ErrorParameters="return-value"}
                            RETURN "NOK":U.
                        END.
                    END.
                END.                            
            END.
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validatePurchasePackage DBOProgram
PROCEDURE validatePurchasePackage :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es referente a Pacote de Compra
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    DEFINE VARIABLE i-cont-pedido AS INTEGER NO-UNDO.

    IF RowObject.nr-processo <> 0 THEN DO:
    
        IF  pType = "Create":U
        OR  pType = "Update":U THEN DO:

            {cdp/findproccompra.i RowObject.nr-processo}
            IF NOT AVAIL proc-compra THEN DO:
                
                {utp/ut-table.i mgind proc-compra 1}
                {method/svc/errors/inserr.i &ErrorNumber="56"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="return-value"} 
                                            
                                            
                RETURN "NOK":U.
            END.
            ELSE DO:

                IF  RowObject.num-pedido <> 0 THEN DO:

                    {cdp/findpedidocompr.i RowObject.num-pedido}
                    IF  AVAIL pedido-compr THEN DO:
                        IF  pedido-compr.nr-processo <> RowObject.nr-processo THEN DO:
    
                            IF  pedido-compr.nr-processo > 0 THEN DO:
                                {utp/ut-table.i movind pedido-compr 1}
                                
                                {method/svc/errors/inserr.i &ErrorNumber="18267"
                                                            &ErrorType="EMS"
                                                            &ErrorSubType="ERROR"
                                                            &ErrorParameters="return-value"}
                                RETURN "NOK":U.
                            END.
                            ELSE DO:
                                {utp/ut-table.i movind pedido-compr 1}
                                {method/svc/errors/inserr.i &ErrorNumber="18328"
                                                            &ErrorType="EMS"
                                                            &ErrorSubType="ERROR"
                                                            &ErrorParameters="return-value"}
                                RETURN "NOK":U.
                            END.
                        END.
                    END.
                END.

                IF  RowObject.cod-comprado <> proc-compra.cod-comprado THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="34171"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="string(proc-compra.nr-processo) + '~~~~' + proc-compra.cod-comprado"}
                    RETURN "NOK":U.
                END.

            END.
        END.
    END.
    /* Desvincular Ordem do Pacote de Compra */
    ELSE IF lookup("nr-processo":U,c-diferencas) <> 0
        AND RowObject.nr-processo = 0
        AND pType = "Update":U THEN DO:

        IF  RowObject.num-pedido > 0 THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="18893"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameter="''"}           
            RETURN "NOK":U.
        END.

        {cdp/findpedidocompr.i RowObject.num-pedido}
        IF  AVAIL pedido-compr
        AND pedido-compr.nr-processo <> 0 THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="18254"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameter="RowObject.numero-ordem"}
        END.


        IF   param-global.modulo-mp
        AND (   RowObject.num-pedido = 0
             OR CAN-FIND(FIRST pedido-compr
                         WHERE pedido-compr.num-pedido = RowObject.num-pedido
                           AND pedido-compr.situacao = 1 /* Impresso */)) THEN DO:

            RUN ccp/ccapi199.p(INPUT  "Ordem-compra":U, INPUT  RowObject.r-rowid, OUTPUT l-erro).

            IF l-erro THEN DO:

                {utp/ut-liter.i "Ordem_Compra" *}
                ASSIGN c-lbl-trad = RETURN-VALUE.
                {utp/ut-liter.i "Gestor" *}
                
               {method/svc/errors/inserr.i &ErrorNumber="18200" /*Ordem s¢ pode ser alterada no estabelecimento gestor.*/
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-lbl-trad + '~~~~' + RETURN-VALUE"}
            END.
        END.
    END.
    

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE c-msg-param-1     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-msg-param-2     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l-utiliza-ccusto  AS LOGICAL   NO-UNDO.

    {cdp/findparamglobal.i}
    {cdp/findparamcompra.i}
    {cdp/findparamcontrat.i}
    {cdp/findparamestoq.i}
    {cdp/findparammat.i}

    RUN identifyChanges (OUTPUT c-diferencas).

    {cdp/finditem.i RowObject.it-codigo}
    IF NOT AVAIL item THEN DO:
        {utp/ut-table.i mgind item 1}
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="return-value"} 
        RETURN "NOK":U.
    END.

    IF pType = "Create":U THEN DO:

        IF RowObject.numero-ordem = 0 THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="27627"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="''"}
            RETURN "NOK":U.
        END.

        IF  CAN-FIND(FIRST bfordem-compra
                     WHERE bfordem-compra.numero-ordem = RowObject.numero-ordem) THEN DO:
            {utp/ut-table.i movind ordem-compra 1}
            {method/svc/errors/inserr.i &ErrorNumber="35818"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
            RETURN "NOK":U.
        END.

        /************************************************************************/
        /* Tratamenta validaá∆o do n£mero da ordem de compra: Normal X M£ltipla */
        /************************************************************************/
        ASSIGN i-length         = LENGTH(STRING(RowObject.numero-ordem))
               i-seq-ordem      = INT(SUBSTR(STRING(RowObject.numero-ordem),i-length - 1,2))
               i-numero-ordem   = INT(SUBSTR(STRING(RowObject.numero-ordem),1,i-length))
               l-ordem-multipla = i-sequencia > 0. /* se possuir seqÅància informada trata-se de uma ordem m£ltipla */

        IF  RowObject.origem = 1 THEN DO: /* Manual */
            IF  i-numero-ordem < param-compra.prim-ord-man
            OR  i-numero-ordem > param-compra.ult-ord-man THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="842"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="''"}
                RETURN "NOK":U.
            END.
        END.

        IF  param-global.modulo-bh
        AND CAN-FIND(FIRST his-ord-compra
                     WHERE his-ord-compra.numero-ordem = RowObject.numero-ordem) THEN DO:
           {utp/ut-table.i movind his-ord-compra 1}
           {method/svc/errors/inserr.i &ErrorNumber="4521"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"
                                       &ErrorParameters="return-value"}
            RETURN "NOK":U.
        END.

        IF item.compr-fabric = 2 THEN DO: /* Fabricado */
            {method/svc/errors/inserr.i &ErrorNumber="1376"
                                        &ErrorType="EMS"
                                        &ErrorSubType="WARNING"
                                        &ErrorParameters="''"} 
        END.  
           
        RUN pi-valida-item-comprador.
        IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.

    END.

    IF  pType = "Create":U
    OR  pType = "Update":U THEN DO:

        {cdp/finditemuniestab.i RowObject.it-codigo RowObject.cod-estabel}
        IF NOT AVAIL item-uni-estab THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="25904"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="RowObject.it-codigo + '~~~~' + string(RowObject.cod-estabel)"}
            RETURN "NOK":U.
        END.
        ELSE DO:

            IF  item-uni-estab.cod-obsoleto = 3 /* Obsoleto Ordens Autom†ticas */
            OR  item-uni-estab.cod-obsoleto = 4 /* Obsoleto Todas as Ordens */ THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="1568"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="''"}
                                            
                RETURN "NOK":U.
            END.
        END.

        IF RowObject.qt-solic = 0 THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="1368"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="''"}
            RETURN "NOK":U.
        END.

        IF  AVAIL item
        AND item.fraciona = NO
        AND RowObject.qt-solic <> INT(RowObject.qt-solic) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="847"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="''"}
            RETURN "NOK":U.
        END.

        {cdp/findrequisitante.i RowObject.requisitante}
        IF NOT AVAIL requisitante THEN DO:
            {utp/ut-table.i mgind requisitante 1}
            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
            RETURN "NOK":U.
        END.

        {cdp/findcomprador.i RowObject.cod-comprado}
        IF NOT AVAIL comprador THEN DO:
            {utp/ut-table.i mgind comprador 1}
            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
            RETURN "NOK":U.
        END.

        IF  (param-global.modulo-in = NO OR param-global.modulo-cn = NO)
        AND RowObject.num-ord-inv  <> 0
        AND RowObject.nr-contrato  <> 0 THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="6572"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
            RETURN "NOK":U.
        END.

        {cdp/findtiporecdesp.i RowObject.tp-despesa}
        IF NOT AVAIL tipo-rec-desp THEN DO:
            {utp/ut-table.i mgadm tipo-rec-desp 3}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
            RETURN "NOK":U.
        END.
        ELSE DO:
            IF tipo-rec-desp.tipo = 1 THEN DO: /* Receita */
                {method/svc/errors/inserr.i &ErrorNumber="146"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="''"}
                RETURN "NOK":U.
            END.
        END.

        IF  param-global.modulo-en
        AND RowObject.op-codigo <> 0 THEN DO:
            {cdp/findoperacao.i RowObject.it-codigo "''" RowObject.op-codigo}
            IF NOT AVAIL operacao THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="26866"
                                            &ErrorType="EMS"
                                            &ErrorSubType="WARNING"
                                            &ErrorParameters="''"}
            END.

            IF  NOT AVAIL operacao
            AND RowObject.narrativa = "" THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="1414"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="''"}
                RETURN "NOK":U.
            END.
        END.

        IF  RowObject.it-codigo = ""
        AND RowObject.narrativa = "" THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="1414"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="''"}
            RETURN "NOK":U.
        END.

        /*** VALIDAÄÂES CONTRATOS ***/
        RUN validateContract (INPUT pType).
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        

        IF l-consiste-conta /* Valida conta cont†bil de acordo com Matriz de Rateio do Contrato/Item */
        OR item.tipo-contr = 1 /* F°sico */
        OR item.tipo-contr = 4 /* DÇbito Direto */
        OR RowObject.ct-codigo <> ""
        OR RowObject.sc-codigo <> "" THEN DO:       

            {cdp/findestabelec.i RowObject.cod-estabel}
            IF AVAIL estabelec THEN
                RUN cdp/cd9970.p (INPUT ROWID(estabelec), OUTPUT i-empresa).

            RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

            ASSIGN c-ct-codigo = RowObject.ct-codigo.
            RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        i-empresa,              /* EMPRESA EMS2 */
                                                           INPUT        "",                     /* PLANO DE CONTAS */
                                                           INPUT-OUTPUT c-ct-codigo,            /* CONTA */
                                                           INPUT        RowObject.data-atualiz, /* DATA TRANSACAO */
                                                           OUTPUT       v_des_cta_ctbl,         /* DESCRICAO CONTA */
                                                           OUTPUT       v_num_tip_cta_ctbl,     /* TIPO DA CONTA */
                                                           OUTPUT       v_num_sit_cta_ctbl,     /* SITUAÄ«O DA CONTA */
                                                           OUTPUT       v_ind_finalid_cta,      /* FINALIDADES DA CONTA */
                                                           OUTPUT TABLE tt_log_erro).           /* ERROS */ 

            IF VALID-HANDLE(h_api_cta_ctbl) THEN
                DELETE OBJECT h_api_cta_ctbl.


            IF CAN-FIND(tt_log_erro) THEN DO:
                                            
                FOR EACH tt_log_erro NO-LOCK:
                    {utp/ut-liter.i "C¢digo Erro Financeiro: "}
                    ASSIGN cErroAux = RETURN-VALUE + CHR(01) + STRING(tt_log_erro.ttv_num_cod_erro).
                    {method/svc/errors/inserr.i &ErrorNumber="52046" 
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters= "tt_log_erro.ttv_des_msg_erro + '~~~~' + tt_log_erro.ttv_des_msg_ajuda + '~~~~' + cErroAux"}  
                END.
                RETURN "NOK":U.
            END.
            ELSE DO:
                IF INT(v_num_sit_cta_ctbl) <> 3 OR
                  (INT(v_num_tip_cta_ctbl) <> 1 AND 
                   INT(v_num_tip_cta_ctbl) <> 4 AND 
                   INT(v_num_tip_cta_ctbl) <> 5) THEN DO:

                    {method/svc/errors/inserr.i &ErrorNumber="1071"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="''"}
                    RETURN "NOK":U.
                END.

                /* Verifica Estoque */
                ASSIGN ind       = 1
                       i-estoque = 0.

                DO WHILE ind <= 10:
                    ASSIGN v_cod_finalid = {adinc/i05ad049.i 4 ind}.

                    IF LOOKUP(v_cod_finalid, v_ind_finalid_cta) > 0 THEN DO:
                        ASSIGN i-estoque = ind.
                        LEAVE.
                    END.

                    ASSIGN ind = ind + 1.
                END.

                IF param-global.modulo-ce AND 
                   (i-estoque  = 0 OR
                   (i-estoque <> 1 AND 
                    i-estoque <> 2 AND 
                    i-estoque <> 3 AND 
                    i-estoque <> 5 AND 
                    i-estoque <> 6)) THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="445"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="''"}
                    RETURN "NOK":U.
                END.

                RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

                IF RowObject.sc-codigo = "" THEN DO:

                    RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT i-empresa,
                                                                       INPUT RowObject.cod-estabel,
                                                                       INPUT "",
                                                                       INPUT c-ct-codigo,
                                                                       INPUT RowObject.data-atualiz,
                                                                       OUTPUT l-utiliza-ccusto,
                                                                       OUTPUT TABLE tt_log_erro).
                    IF VALID-HANDLE(h_api_ccusto) THEN
                        DELETE OBJECT h_api_ccusto.

                    IF CAN-FIND(tt_log_erro) THEN DO:

                        FOR EACH tt_log_erro NO-LOCK:

                            {utp/ut-liter.i "C¢digo Erro Financeiro: "}
                            ASSIGN cErroAux = RETURN-VALUE + CHR(01) + STRING(tt_log_erro.ttv_num_cod_erro).

                            {method/svc/errors/inserr.i &ErrorNumber="52046" 
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="ERROR"
                                                        &ErrorParameters= "tt_log_erro.ttv_des_msg_erro + '~~~~' + tt_log_erro.ttv_des_msg_ajuda + '~~~~' + cErroAux"}  
                        END.
                        RETURN "NOK":U.
                    END.
                    ELSE DO:
                        IF l-utiliza-ccusto THEN DO:
                            {utp/ut-liter.i "Centro de Custo"}
                            {method/svc/errors/inserr.i &ErrorNumber="688"
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="ERROR"
                                                        &ErrorParameters="return-value"}
                             RETURN "NOK":U.
                        END.
                    END.
                END.
                ELSE DO:
                    RUN pi_busca_dados_ccusto IN h_api_ccusto (INPUT i-empresa,
                                                               INPUT "",
                                                               INPUT RowObject.sc-codigo,
                                                               INPUT RowObject.data-atualiz,
                                                               OUTPUT v_des_ccusto,
                                                               OUTPUT TABLE tt_log_erro).
                   
                    IF VALID-HANDLE(h_api_ccusto) THEN
                        DELETE OBJECT h_api_ccusto.

                    IF CAN-FIND(tt_log_erro) THEN DO:
                        FOR EACH tt_log_erro NO-LOCK:

                            {utp/ut-liter.i "C¢digo Erro Financeiro: "}
                            ASSIGN cErroAux = RETURN-VALUE + CHR(01) + STRING(tt_log_erro.ttv_num_cod_erro).

                            {method/svc/errors/inserr.i &ErrorNumber="52046" 
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="ERROR"
                                                        &ErrorParameters= "tt_log_erro.ttv_des_msg_erro + '~~~~' + tt_log_erro.ttv_des_msg_ajuda + '~~~~' + cErroAux"}  
                        END.
                        RETURN "NOK":U.
                    END.
                END.
                IF VALID-HANDLE(h_api_ccusto) THEN
                    DELETE OBJECT h_api_ccusto.
            END.
        END.
        {cdp/finddeposito.i RowObject.dep-almoxar}
        IF NOT AVAIL deposito THEN DO:
            {utp/ut-table.i mgind deposito 1}
            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
            RETURN "NOK":U.
        END.
    END.

    IF pType = "Update":U THEN DO:

        IF CAN-FIND (FIRST prazo-compra
                     WHERE prazo-compra.numero-ordem = RowObject.numero-ordem
                       AND prazo-compra.data-entrega < RowObject.data-emissao) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="6719"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="''"}
            RETURN "NOK":U.                            
        END.
    END.

    IF pType = "Delete":U THEN DO:

       IF  RowObject.situacao <> 1
       AND RowObject.situacao <> 3
       AND RowObject.situacao <> 5 THEN DO:
           {method/svc/errors/inserr.i &ErrorNumber="5987"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"
                                       &ErrorParameters="''"}
           RETURN "NOK":U.                            
       END.

       /*** CONTRATOS ***/
       IF ordem-compra.nr-contrato <> 0 THEN DO:
           {method/svc/errors/inserr.i &ErrorNumber="6686"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"
                                       &ErrorParameters="''"}
           RETURN "NOK":U.
       END.
       
       /*** MULTIPLANTA ***/
       IF param-global.modulo-mp THEN DO:

           RUN ccp/ccapi199.p (INPUT "Ordem-compra":U, INPUT ROWID(ordem-compra), OUTPUT l-erro).

           IF l-erro THEN DO:

               {utp/ut-liter.i Ordem}
               ASSIGN c-msg-param-1 = trim(RETURN-VALUE).
               {utp/ut-liter.i Gestor}
               ASSIGN c-msg-param-2 = trim(RETURN-VALUE).
               {method/svc/errors/inserr.i &ErrorNumber="18200"
                                           &ErrorType="EMS"
                                           &ErrorSubType="ERROR"
                                           &ErrorParameters="c-msg-param-1 + '~~~~' + c-msg-param-2"}
               RETURN "NOK":U.
           END.
       END.
       IF  CAN-FIND (FIRST funcao WHERE funcao.cd-funcao = "SPP-INTEGRA-PORTAL-ME":U AND funcao.ativo) THEN
           RUN setExecuteUpdate (INPUT NO).
    END.

    /* Validaá‰es Pacote de Compra */
    RUN validatePurchasePackage (INPUT pType).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    /* Validaá‰es Investimentos */
    RUN validateInvestments (INPUT pType).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    /* Validaá‰es Produá∆o */
    RUN validateProduction (INPUT pType).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE filterPurchaseRequisitions DBOProgram 
PROCEDURE filterPurchaseRequisitions :
/*:T------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pField AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pText  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE FOR ttRowid.     
    DEFINE OUTPUT PARAMETER TABLE FOR ttPurchaseRequisitions. 

    EMPTY TEMP-TABLE ttRowidAux.

    CASE pField:

        WHEN "item":U THEN DO:

            FOR EACH  ttRowid,
                FIRST ordem-compra FIELDS (it-codigo)
                WHERE ROWID(ordem-compra) = TO-ROWID(ttRowid.rRowid) NO-LOCK:
                
                IF ordem-compra.it-codigo = pText THEN DO:
                    CREATE ttRowidAux.
                    ASSIGN ttRowidAux.rRowid = string(ROWID(ordem-compra)).
                END.
            END.
        END.
        WHEN "site":U THEN DO:

            FOR EACH  ttRowid,
                FIRST ordem-compra FIELDS (cod-estabel)
                WHERE ROWID(ordem-compra) = TO-ROWID(ttRowid.rRowid) NO-LOCK:
                
                IF  ordem-compra.cod-estabel = pText THEN DO:
                    CREATE ttRowidAux.
                    ASSIGN ttRowidAux.rRowid = string(ROWID(ordem-compra)).
                END.
            END.
        END.
        WHEN "purchaseRequisition":U THEN DO:

            FOR EACH  ttRowid,
                FIRST ordem-compra FIELDS (numero-ordem)
                WHERE ROWID(ordem-compra) = TO-ROWID(ttRowid.rRowid) NO-LOCK:
                
                IF ordem-compra.numero-ordem = INT(pText) THEN DO:
                    CREATE ttRowidAux.
                    ASSIGN ttRowidAux.rRowid = string(ROWID(ordem-compra)).
                END.
            END.
        END.
        WHEN "buyer":U THEN DO:

            FOR EACH  ttRowid,
                FIRST ordem-compra FIELDS (cod-comprado)
                WHERE ROWID(ordem-compra) = TO-ROWID(ttRowid.rRowid) NO-LOCK:
                
                IF ordem-compra.cod-comprado = pText THEN DO:
                    CREATE ttRowidAux.
                    ASSIGN ttRowidAux.rRowid = string(ROWID(ordem-compra)).
                END.
            END.
        END.
        OTHERWISE DO:
            FOR EACH ttRowid:
                
                CREATE ttRowidAux.
                ASSIGN ttRowidAux.rRowid = string(ttRowid.rRowid).
            END.
        END.
    END CASE.

    RUN getPurchaseRequisitions (INPUT  TABLE ttRowidAux, OUTPUT TABLE ttPurchaseRequisitions).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE filterPurchaseRequisitions DBOProgram 
PROCEDURE pi-valida-item-comprador :
/*:T------------------------------------------------------------------------------
  Purpose:     Realiza a validaá∆o para verificar se o item est† relacionado ao 
               comprador
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-cod-grp-compra  LIKE item-uni-estab.cod-grp-compra NO-UNDO.
    DEFINE VARIABLE c-cod-comprado    LIKE item-uni-estab.cod-comprado   NO-UNDO.

    DEFINE VARIABLE l-permite-inclusao AS LOGICAL INITIAL YES NO-UNDO.

    {cdp/findusuarmater.i c-seg-usuario}

    IF AVAIL usuar-mater AND 
       SUBSTRING(usuar-mater.char-1,22,1) = "Y":U /*Apenas itens do comprador*/ THEN DO:

        FOR FIRST item-uni-estab FIELDS(it-codigo cod-estabel cod-grp-compra cod-comprado cod-obsoleto lote-minimo lote-multipl) 
             WHERE item-uni-estab.it-codigo   = RowObject.it-codigo 
               AND item-uni-estab.cod-estabel = RowObject.cod-estabel NO-LOCK: END.
        IF AVAIL item-uni-estab THEN DO:
            ASSIGN c-cod-grp-compra = item-uni-estab.cod-grp-compra
                   c-cod-comprado   = item-uni-estab.cod-comprado.
        END.
        ELSE DO:
            ASSIGN c-cod-grp-compra = &IF "{&mgind_dbtype}" = "progress":U &THEN 
                                         SUBSTR(item.char-2,188,12)
                                      &ELSE
                                         SUBSTR(item.char-2,88,12)
                                      &ENDIF
                   c-cod-comprado   = item.cod-comprado.
        END.
       
        IF param-compra.int-2 = 1 THEN DO: /*Por grupo de compras*/
           IF NOT CAN-FIND (FIRST gr-cmp-comprad 
                            WHERE gr-cmp-comprad.cod-grp-compra = c-cod-grp-compra
                              AND gr-cmp-comprad.cod-comprado = RowObject.cod-comprado) THEN
                ASSIGN l-permite-inclusao = NO.
        END.
        ELSE IF param-compra.int-2 = 2 /*Por comprador*/
            AND c-cod-comprado <> RowObject.cod-comprado THEN DO: 
                ASSIGN l-permite-inclusao = NO.
        END.
    END.

    IF NOT l-permite-inclusao THEN DO:
       {method/svc/errors/inserr.i &ErrorNumber="55086"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="RowObject.it-codigo + '~~~~' + 
                                                     RowObject.cod-comprado"}
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCancelaOrdemCompraME DBOProgram 
PROCEDURE piCancelaOrdemCompraME:
/*:T----------------------------------------------------------------------------
  Purpose: Realiza a alteraá∆o nas tabelas relacionadas a ordem de compra
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE v-narrativa AS CHARACTER NO-UNDO.

    IF  NOT CAN-FIND(FIRST ordem-compra-integr-me 
                     WHERE ordem-compra-integr-me.numero-ordem = RowObject.numero-ordem) THEN
        RETURN "NOK".
    
    {utp/ut-liter.i "Imposs°vel_excluir_fisicamente_ordens_de_compra_integradas_com_o_Mercado_Eletrìnico." *}
    ASSIGN v-narrativa = RETURN-VALUE.
        
    FOR FIRST bf{&TableName} EXCLUSIVE-LOCK 
        WHERE bf{&TableName}.numero-ordem = RowObject.numero-ordem:        
        ASSIGN bf{&TableName}.narrativa = trim(bf{&TableName}.narrativa + " " + v-narrativa)
               bf{&TableName}.situacao  = 4. /* Eliminada */
    END.

    /*** Alteraá∆o da situaá∆o das Parcelas da Ordem de Compra ***/
    IF NOT VALID-HANDLE(h-boin356fx) THEN DO:
        RUN inbo/boin356fx.p persistent set h-boin356fx.
        RUN openQueryStatic IN h-boin356fx (INPUT "Main":U).
    END.

    FOR EACH prazo-compra
       WHERE prazo-compra.numero-ordem = RowObject.numero-ordem NO-LOCK:

        EMPTY TEMP-TABLE ttPrazoCompraAux.
        CREATE ttPrazoCompraAux.
        BUFFER-COPY prazo-compra TO ttPrazoCompraAux.
        ASSIGN ttPrazoCompraAux.situacao = 4. /* Eliminada */

        RUN gotokey      IN h-boin356fx (INPUT ttPrazoCompraAux.numero-ordem, INPUT ttPrazoCompraAux.parcela).
        RUN setRecord    IN h-boin356fx(INPUT TABLE ttPrazoCompraAux).
        RUN updateRecord IN h-boin356fx.
        RUN getRowErrors IN h-boin356fx (OUTPUT TABLE RowErrors APPEND).
    END.

    /*** Alteraá∆o da situaá∆o na solicitaá∆o de compra ***/
    IF RowObject.nr-requisicao <> 0 THEN DO:
    
        IF NOT VALID-HANDLE(h-boin168fx) THEN DO:
            RUN inbo/boin168fx.p PERSISTENT SET h-boin168fx.
            RUN openQueryStatic in h-boin168fx (input "Main":U).
        END.
        
        FOR FIRST it-requisicao EXCLUSIVE-LOCK
            WHERE it-requisicao.nr-requisicao = RowObject.nr-requisicao
            AND   it-requisicao.sequencia     = RowObject.sequencia 
            AND   it-requisicao.it-codigo     = RowObject.it-codigo:

            RUN gotokey            IN h-boin168fx (INPUT it-requisicao.nr-requisicao, INPUT it-requisicao.sequencia, INPUT it-requisicao.it-codigo).
            RUN setExecuteUpdate   IN h-boin168fx (INPUT NO).
            RUN setReqIntegrMe     IN h-boin168fx (INPUT YES, v-narrativa).            
            RUN deleteRecord       IN h-boin168fx.
            RUN getRowErrors       IN h-boin168fx (OUTPUT TABLE RowErrors APPEND).
        END.
    END.

    IF VALID-HANDLE(h-boin356fx) THEN DO:
        DELETE PROCEDURE h-boin356fx.
        ASSIGN h-boin356fx = ?.
    END.

    IF VALID-HANDLE(h-boin168fx) THEN DO:
        DELETE PROCEDURE h-boin168fx.
        ASSIGN h-boin168fx = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
