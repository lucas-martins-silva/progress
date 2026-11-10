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
{include/i-prgvrs.i BOIN274 2.00.01.014 } /*** "010114" 13/08/2025 16:33:11 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin274 MUT}
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
&GLOBAL-DEFINE DBOName ordem-compra
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName ordem-compra
&GLOBAL-DEFINE TableLabel ordem-compra
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE KeyField1 numero-ordem /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
/* &GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES */

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{inbo/boin274.i RowObject}
{include/i-epc200.i boin274}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER b-prazo        FOR prazo-compra.

DEFINE BUFFER bfOrdem2TT     FOR {&TableName}.
def var c-pType         as char   no-undo.
def var c-descricao     as char   NO-UNDO.
def var l-achou         as log    no-undo.
def var inumped         as int    no-undo.

/*  Vari†veis de validaá∆o pedidos integrados ME   */
DEFINE VARIABLE isOrderIntegrMe                  AS LOGICAL NO-UNDO.
DEFINE VARIABLE h-ccPedidoCompraValidaIntegraMe  AS HANDLE  NO-UNDO.
/******************************ATENCAO*************************************
- Pre-processador abaixo responsavel por distinguir o produto que
 esta executando o componente ( Magnus ou EMS ). 
 Se estiver definida a variavel bf-mat-comex 
 ( &if defined(bf-mat-comex) &then ), significa que o produto
 chamador e o Magnus se n∆o, EMS. Utilizado pelo produto Comercio Exterior

- Define tambem releases do EMS

**************************************************************************/ 
{cdp/cdcfgmat.i} /* Definicao de pre-processadores - Magnus ou EMS */
{utp/ut-glob.i}

/* Vari†veis necess†rias aos setConstraint's */

    def var cRequisIni       as char no-undo.
    def var cRequisFim       as char no-undo.
    def var cCodEstabelIni   as char no-undo.
    def var cCodEstabelFim   as char no-undo.
    def var cCodComprado     as char no-undo.
    def var cCodCompradoIni  as char no-undo. 
    def var cCodCompradoFim  as char no-undo.   
    def var cItCodigo        as char no-undo.
    def var cItCodigoIni     as char no-undo.
    def var cItCodigoFim     as char no-undo.
    def var cCodGrpCompra    as char no-undo.
    def var daDataEmissaoIni as date no-undo.
    def var daDataEmissaoFim as date no-undo.
    def var daDataIni        as date no-undo.
    def var daDataFim        as date no-undo.
    def var iNumOrdem        as int  no-undo.
    def var iNumOrdemIni     as int  no-undo.
    def var iNumOrdemFim     as int  no-undo.
    def var iEmitente        as int  no-undo. 
    def var iEmitenteIni     as int  no-undo.
    def var iEmitenteFim     as int  no-undo.
    def var iNrProcesso      as int  no-undo.
    def var iNumPedido       as int  no-undo.
    def var lConfirmada      as log  no-undo.
    def var lNaoConfirmada   as log  no-undo.
    def var lCotacao         as log  no-undo.
    def var lEmCotacao       as log  no-undo.
    def var lRecebida        as log  no-undo.
    def var lEliminada       as log  no-undo.
    def var lCompra          as log  no-undo.
    def var lServico         as log  no-undo.
    def var lBenefic         as log  no-undo.
    def var rPedidoCompr     as rowid no-undo.
    def var iNatureza        as int  no-undo.
    def var iCodCondPag      as int  no-undo.
    def var iCodTransp       as int  no-undo.
    def var iOrdemServic     as int  no-undo.
    def var lCotada          as logical no-undo initial yes.
    def var lTermin          as logical no-undo initial yes.
    def var c-seg-usuario    as char no-undo.
    def var i-pais-impto-usuario as int no-undo.
    def var l-controla-drop-ship as log no-undo.
    def var l-ind-drop-shipment  as log no-undo.
    def var l-unid-negoc-mi      as log no-undo.
    def var hmmvunidnegoc        as handle no-undo.
    DEF VAR apiHandler           AS HANDLE NO-UNDO.
    def var c-ct-codigo          as char   no-undo.
    def var c-sc-codigo          as char   no-undo.

    DEF TEMP-TABLE tt-matriz NO-UNDO
        FIELD cod-unid-neg AS CHAR
        FIELD perc-rateio  AS DEC.

    &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
    DEF TEMP-TABLE tt-matriz-om NO-UNDO LIKE unid-negoc-om
        FIELD r-Rowid AS ROWID.
    &endif
    /* Compatibilidade CD0666.i */
    DEF TEMP-TABLE tt-erro-aux NO-UNDO
        FIELD i-sequen AS INT              
        FIELD cd-erro  AS INT
        FIELD mensagem AS CHAR FORMAT "x(255)".


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
         HEIGHT             = 19.79
         WIDTH              = 39.43.
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


{method/svc/autentic/autentic.i
            &vUserName="c-seg-usuario"
            &vUserCountryTax="i-pais-impto-usuario"}

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
    def var r-aux-oracle as rowid no-undo.

    &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
        DEFINE VARIABLE pUnid-negoc LIKE ordem-compra.cod-unid-negoc    NO-UNDO.
        DEFINE VARIABLE h_cdapi024  AS HANDLE                           NO-UNDO.
        DEFINE VARIABLE h-boin029   AS HANDLE                           NO-UNDO.
        DEFINE VARIABLE h-bomn250   AS HANDLE                           NO-UNDO.
        {cdp/cd9590.i}
    &ENDIF
    FIND FIRST param-global NO-LOCK NO-ERROR.
    /* Cria Unidade de Negocio Padrao para a Ordem */
    find first param-mat no-lock no-error.
    if  avail param-mat
    and param-mat.ind-unid-neg then
        run cdp/cd9760.p (input 1, /*Ordem Compra*/
                          input ordem-compra.it-codigo,
                          input rowid(ordem-compra)).

    /* UN MAT Compras */
    &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
        RUN cdp/cdapi024.p PERSISTENT SET h_cdapi024.

        ASSIGN l-unid-negoc-mi = NO.

        FOR FIRST ord-prod FIELDS(nr-ord-produ origem) WHERE
            ord-prod.nr-ord-produ = ordem-compra.ordem-servic NO-LOCK:
        END.

        FOR EACH tt-matriz-om EXCLUSIVE-LOCK:
            DELETE tt-matriz-om.
        END.
        
        IF ordem-compra.ordem-servic > 0 AND AVAIL ord-prod AND l-unidade-negocio THEN DO:
        
            IF ord-prod.origem = "MI" THEN  DO: /* Manutená∆o Industrial */
                IF CAN-FIND(FIRST unid-negoc-om WHERE
                          unid-negoc-om.num-ord-manut =  ord-prod.nr-ord-produ NO-LOCK) THEN
            
                ASSIGN l-unid-negoc-mi = YES.

                IF  NOT VALID-HANDLE(h-bomn250) THEN
                    RUN mnbo/bomn250.p PERSISTENT SET h-bomn250.
        
                IF VALID-HANDLE(h-bomn250) THEN DO:
                   RUN criattMatrizUnidNegoc IN h-bomn250 (INPUT ordem-compra.ordem-servic,
                                                            OUTPUT TABLE tt-matriz-om).
                END.
            END.
            ELSE DO:
                IF ord-prod.origem = "MV" THEN DO: /* FROTAS */

                    IF NOT VALID-HANDLE(hMMVUnidNegoc) THEN
                        RUN frbo/bofr134.p PERSISTENT SET hMmvUnidNegoc.

                    RUN canFindMatrizMMV IN hMMVUnidNegoc (INPUT ordem-compra.ordem-servic).

                    IF RETURN-VALUE = "OK":U THEN 
                        ASSIGN l-unid-negoc-mi = YES.

                    RUN criattMatrizUnidNegoc IN hMMVUnidNegoc (INPUT ordem-compra.ordem-servic,
                                                                OUTPUT TABLE tt-matriz-om).
                    
                    IF VALID-HANDLE(hMMVUnidNegoc)THEN
                        RUN destroy IN hMMVUnidNegoc.
                END.
            END.
                       
            FOR EACH unid-neg-ordem
                WHERE unid-neg-ordem.numero-ordem = ordem-compra.numero-ordem EXCLUSIVE-LOCK:
                DELETE unid-neg-ordem.
            END.
            
            FOR EACH tt-matriz-om:    
                CREATE unid-neg-ordem.
                ASSIGN unid-neg-ordem.cod_unid_negoc  = tt-matriz-om.cod-unid-negoc
                       unid-neg-ordem.numero-ordem  = ordem-compra.numero-ordem
                       unid-neg-ordem.perc-unid-neg = tt-matriz-om.val-perc-unid-negoc.
            END.
            IF CAN-FIND(FIRST unid-neg-ordem WHERE
                        unid-neg-ordem.numero-ordem = ordem-compra.numero-ordem NO-LOCK) THEN
                ASSIGN ordem-compra.cod-unid-negoc = "".
        END.
        
        IF  VALID-HANDLE( h-bomn250 ) THEN 
            DELETE PROCEDURE h-bomn250.

        ASSIGN h-bomn250 = ?.
        IF  ordem-compra.num-ord-inv <> 0 AND l-unid-negoc-mi = NO AND param-global.modulo-in  THEN DO:
            RUN ivbo/boiv029.p PERSISTENT SET h-boin029.
            RUN retornaMatrizUnidNegoc IN h-boin029 (INPUT RowObject.num-ord-inv,
                                                     OUTPUT TABLE tt-matriz,
                                                     OUTPUT TABLE tt-erro-aux).
            DELETE PROCEDURE h-boin029.
            
            FIND FIRST tt-erro-aux NO-LOCK NO-ERROR.
            IF  AVAIL tt-erro-aux THEN DO:
                FOR EACH tt-erro-aux:
                    CREATE RowErrors.
                    ASSIGN RowErrors.ErrorSequence    = tt-erro-aux.i-sequen
                           RowErrors.ErrorNumber      = tt-erro-aux.cd-erro
                           RowErrors.ErrorParameters  = ""
                           RowErrors.ErrorType        = ""
                           RowErrors.ErrorSubType     = "ERROR"
                           RowErrors.ErrorDescription = tt-erro-aux.mensagem
                           RowErrors.ErrorHelp        = tt-erro-aux.mensagem.
                END.
                RETURN "NOK":U.
            END.
            
            FOR EACH unid-neg-ordem EXCLUSIVE-LOCK
                WHERE unid-neg-ordem.numero-ordem = ordem-compra.numero-ordem:
                DELETE unid-neg-ordem.
            END.
            
            FOR EACH tt-matriz:
                FIND FIRST unid-neg-ordem EXCLUSIVE-LOCK
                     WHERE unid-neg-ordem.numero-ordem = ordem-compra.numero-ordem
                       AND unid-neg-ordem.cod_unid_negoc = tt-matriz.cod-unid-neg NO-ERROR.
                IF  NOT AVAIL unid-neg-ordem THEN DO:
                    CREATE unid-neg-ordem.
                    ASSIGN unid-neg-ordem.cod_unid_negoc = tt-matriz.cod-unid-neg
                           unid-neg-ordem.numero-ordem = ordem-compra.numero-ordem.
                END.
                ASSIGN unid-neg-ordem.perc-unid-neg = tt-matriz.perc-rateio.
            END.
        END.
        
        IF l-unid-negoc-mi = NO THEN DO:
            FIND FIRST unid-neg-ordem 
                 WHERE unid-neg-ordem.numero-ordem = ordem-compra.numero-ordem NO-LOCK NO-ERROR.
            IF NOT AVAIL unid-neg-ordem THEN DO:
                IF ordem-compra.ordem-servic > 0 THEN DO:
                    FOR FIRST ord-prod FIELDS (cod-unid-negoc) NO-LOCK
                        WHERE ord-prod.nr-ord-produ = ordem-compra.ordem-servic.
                        if l-mat-unid-negoc then
                            ASSIGN ordem-compra.cod-unid-negoc = ord-prod.cod-unid-negoc.
                        else
                            ASSIGN ordem-compra.cod-unid-negoc = "".
                    END.
                END.
                ELSE DO:
                    IF (ordem-compra.ct-codigo = "" OR ordem-compra.cod-unid-negoc = "") AND VALID-HANDLE (h_cdapi024) and l-mat-unid-negoc THEN
                        RUN RetornaUnidadeNegocioExternaliz IN h_cdapi024 (INPUT ordem-compra.cod-estabel,
                                                                           INPUT ordem-compra.it-codigo,
                                                                           INPUT ordem-compra.dep-almoxar,
                                                                          OUTPUT ordem-compra.cod-unid-negoc).
                END.
            END.
        END.
        IF VALID-HANDLE( h_cdapi024 ) THEN 
            RUN pi-finalizar IN h_cdapi024.
        
    &ENDIF

    assign  r-aux-oracle = rowid(ordem-compra).

    release ordem-compra.

    &IF "{&ems_dbtype}":U <> "progress":U &THEN     
    ROWID(ordem-compra).
    &ENDIF

    run repositionRecord in this-procedure (input r-aux-oracle).

    return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE alteraLocEntrParcela DBOProgram 
PROCEDURE alteraLocEntrParcela :
/*------------------------------------------------------------------------------
  Notes: Repassa os dados referentes ao cliente da Ordem de Compra para
         a parcela.
------------------------------------------------------------------------------*/
    def input param nr-ordem-compra like ordem-compra.numero-ordem no-undo.
    def input param c-nome-emit       as char no-undo.
    def input param nr-ped-venda      as char no-undo.
    def input param seq-ped-venda     as int  no-undo.

&if defined(bf_mat_custeio_item) &then
    for each  b-prazo fields(nome-abrev pedido-clien nr-sequencia)
        where b-prazo.numero-ordem = nr-ordem-compra exclusive-lock:
        assign b-prazo.nome-abrev   = c-nome-emit
               b-prazo.pedido-clien = nr-ped-venda
               b-prazo.nr-sequencia = seq-ped-venda.
    end. 
&endif

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
    RUN ccp/ccPedidoCompraValidaIntegraMe.p PERSISTENT SET h-ccPedidoCompraValidaIntegraMe.
    
    RUN verifica-pedido-compra-me IN h-ccPedidoCompraValidaIntegraMe (INPUT RowObject.num-pedido, OUTPUT isOrderIntegrMe).
    
    IF isOrderIntegrMe THEN DO:
        {method/svc/errors/inserr.i
                          &ErrorNumber="57880"
                          &ErrorType="EMS"
                          &ErrorSubType="ERROR"}

        RETURN "NOK":U.
    END.
    
    if can-find(ordem-compra where 
                ordem-compra.numero-ordem = rowObject.numero-ordem) then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-ordem-compra AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Ordem_Compra" *}
        ASSIGN c-lbl-liter-ordem-compra = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                           &ErrorNumber="24"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR" 
                           &ErrorParameters="c-lbl-liter-ordem-compra + ' ' + string(rowObject.numero-ordem)"}
        /*-----------------------------------------------------------------*/
        /* Include i-epc200.i2: Criacao de registro para temp-table tt-epc */
        for each tt-epc where tt-epc.cod-event = "validateCreatePedEmerg":
            delete tt-epc.
        end.
        {include/i-epc200.i2 &CodEvent='"validateCreatePedEmerg"'
                             &CodParameter='"OBJECT-HANDLE"'
                             &ValueParameter="string(this-procedure)"}
        /* Include i-epc201.i: Chamada do programa de EPC */
        {include/i-epc201.i "validateCreatePedEmerg"}
        if  return-value = "NOK":U then do:
            return "NOK":U.
        end.
        /*-----------------------------------------------------------------*/
    end.

    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    return "OK".
    
    FINALLY:
        DELETE PROCEDURE h-ccPedidoCompraValidaIntegraMe NO-ERROR.
        ASSIGN h-ccPedidoCompraValidaIntegraMe = ?.
    END FINALLY.
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
        
    RUN ccp/ccPedidoCompraValidaIntegraMe.p PERSISTENT SET h-ccPedidoCompraValidaIntegraMe.
    
    RUN verifica-pedido-compra-me IN h-ccPedidoCompraValidaIntegraMe (INPUT rowObject.num-pedido, OUTPUT isOrderIntegrMe).   
    
    IF isOrderIntegrMe THEN DO:
        {method/svc/errors/inserr.i
                          &ErrorNumber="57882"
                          &ErrorType="EMS"
                          &ErrorSubType="ERROR" 
                          &ErrorParameters="string(rowObject.numero-ordem)"}
                          
        RETURN "NOK":U.
    END.
    
    /* Elimina Unidade de Negocio da Ordem */
    for each  unid-neg-ordem
        where unid-neg-ordem.numero-ordem = ordem-compra.numero-ordem exclusive-lock:
        delete unid-neg-ordem.
    end.
    
    FINALLY:
        DELETE PROCEDURE h-ccPedidoCompraValidaIntegraMe NO-ERROR.
        ASSIGN h-ccPedidoCompraValidaIntegraMe = ?.
    END FINALLY.

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
    
    RUN altera-status-oc-integr-me IN apiHandler (INPUT ordem-compra.numero-ordem,
                                                  INPUT 3,
                                                  INPUT 1,
                                                  INPUT v_cod_usuar_corren).
    
    FINALLY:
        DELETE PROCEDURE apiHandler NO-ERROR.
    END FINALLY.
    
END PROCEDURE.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE before_copyBuffer2TT DBOProgram 
PROCEDURE before_copyBuffer2TT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

        IF c-pType = "Create":U then DO:
           if can-find(bfOrdem2TT where 
                       bfOrdem2TT.numero-ordem = rowObject.numero-ordem) then do:
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-ordem-compra-2 AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Ordem_Compra" *}
               ASSIGN c-lbl-liter-ordem-compra-2 = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i
                                  &ErrorNumber="24"
                                  &ErrorType="EMS"
                                  &ErrorSubType="ERROR" 
                                  &ErrorParameters="c-lbl-liter-ordem-compra-2 + ' ' + string(rowObject.numero-ordem)"}
                /*-----------------------------------------------------------------*/
                /* Include i-epc200.i2: Criacao de registro para temp-table tt-epc */
                for each tt-epc where tt-epc.cod-event = "validateCreatePedEmerg":
                    delete tt-epc.
                end.
                {include/i-epc200.i2 &CodEvent='"validateCreatePedEmerg"'
                                     &CodParameter='"OBJECT-HANDLE"'
                                     &ValueParameter="string(this-procedure)"}
                /* Include i-epc201.i: Chamada do programa de EPC */
                {include/i-epc201.i "validateCreatePedEmerg"}
                if  return-value = "NOK":U then do:
                    return "NOK":U.
                end.
                /*-----------------------------------------------------------------*/
           end.
        END.

        /*--- Verifica ocorrància de erros ---*/
        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
            RETURN "NOK":U.

    return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaContaLancamentoBGC DBOProgram 
PROCEDURE eliminaContaLancamentoBGC :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/
    def input param table for RowObject.
    
    find first RowObject no-lock no-error.
    
    find ordem-compra where 
         ordem-compra.numero-ordem = RowObject.numero-ordem NO-LOCK NO-ERROR.
    
    /* M¢dulo de BGC - Elimina o lanáamento que existe no BGC para n∆o causar lanáamentos
       em duplicidade causando inconsistàncias */    
    run cdp/cdapi197.p (input rowid(ordem-compra), /*rowid ordem-compra*/
                        input ?,
                        input 1,                   /*funcao: 1*/
                        output table Rowerrors APPEND).   /* tt que retorna erro*/ 
    
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    ELSE 
        return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findEmitente DBOProgram 
PROCEDURE findEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    DEFINE INPUT PARAMETER pemitente     LIKE ordem-compra.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER psituacao     LIKE ordem-compra.situacao     NO-UNDO.
    DEFINE INPUT PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pcreturn     AS   char                      NO-UNDO.

    RUN openQueryStatic (input "Main":U).

    run goToEmitSitOrdem (input pemitente, input psituacao, input pnumero-ordem).

    if return-value = "OK" then assign pcreturn = "".  /* esse Ç o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa Ç a mensagem esperada nas interfaces 1.1  qdo n∆o acha o registro */
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findEmit_Ordem DBOProgram 
PROCEDURE findEmit_Ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    DEFINE INPUT PARAMETER pemitente     LIKE ordem-compra.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pcreturn     AS   char                      NO-UNDO.

    RUN openQueryStatic (input "Main":U).

    run goToEmitOrdem (input pemitente, input pnumero-ordem).

    if return-value = "OK" then assign pcreturn = "".  /* esse Ç o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa Ç a mensagem esperada nas interfaces 1.1  qdo n∆o acha o registro */
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findEstabel DBOProgram 
PROCEDURE findEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    DEFINE INPUT  PARAMETER pcod-estabel  LIKE ordem-compra.cod-estabel  NO-UNDO.
    DEFINE INPUT  PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pcreturn      AS   char                      NO-UNDO.

    RUN openQueryStatic (input "Main":U).

    run goToEstabel (input pcod-estabel, input pnumero-ordem).

    if return-value = "OK" then assign pcreturn = "".  /* esse Ç o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa Ç a mensagem esperada nas interfaces 1.1  qdo n∆o acha o registro */
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findEstCotacao DBOProgram 
PROCEDURE findEstCotacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param nrOrdem    as int  no-undo.
    def output param codEstabel as char no-undo.

    for first ordem-compra fields (cod-estabel)
        where ordem-compra.numero-ordem = nrOrdem no-lock: end.
    if avail ordem-compra then
        assign codEstabel = ordem-compra.cod-estabel.
    else do:
        assign codEstabel = ?.
        return "NOK":U.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findItem DBOProgram 
PROCEDURE findItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    &if defined(bf-mat-comex) &then            
    &else 
        DEFINE INPUT  PARAMETER pit-codigo    LIKE ordem-compra.it-codigo    NO-UNDO.
        DEFINE INPUT  PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.
        DEFINE OUTPUT PARAMETER pcreturn      AS   char                      NO-UNDO.

        RUN openQueryStatic (input "Main":U).

        run goToItem (input pit-codigo,input pnumero-ordem).

        if return-value = "OK" then assign pcreturn = "".  /* esse Ç o valor esperado nas interfaces 1.1 */
        if return-value = "NOK" then do:
            {utp/ut-table.i mgind {&TABLENAME} 1}
            run utp/ut-msgs.p (input "msg":U,
                               input 2,
                               input return-value).
            assign pcreturn =  return-value.  
            /* essa Ç a mensagem esperada nas interfaces 1.1  qdo n∆o acha o registro */
        end.
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findOrdem DBOProgram 
PROCEDURE findOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    DEFINE INPUT  PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pcreturn      AS   char                      NO-UNDO.

    RUN openQueryStatic (input "Main":U).

    run goToKey (input pnumero-ordem).

    if return-value = "OK" then assign pcreturn = "".  /* esse Ç o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa Ç a mensagem esperada nas interfaces 1.1  qdo n∆o acha o registro */
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findOrdemCompra DBOProgram 
PROCEDURE findOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    &if defined(bf-mat-comex) &then                
    &else 
        DEFINE INPUT  PARAMETER pcod-emitente LIKE ordem-compra.cod-emitente NO-UNDO.
        DEFINE INPUT  PARAMETER pit-codigo    LIKE ordem-compra.it-codigo    NO-UNDO.
        DEFINE OUTPUT PARAMETER pcreturn      AS   char                      NO-UNDO.

        RUN openQueryStatic (input "Main":U).

        run goToOrdemCompra (input pcod-emitente,
                             input pit-codigo).

        if return-value = "OK" then assign pcreturn = "".  /* esse Ç o valor esperado nas interfaces 1.1 */
        if return-value = "NOK" then do:
            {utp/ut-table.i mgind {&TABLENAME} 1}
            run utp/ut-msgs.p (input "msg":U,
                               input 2,
                               input return-value).
            assign pcreturn =  return-value.  
            /* essa Ç a mensagem esperada nas interfaces 1.1  qdo n∆o acha o registro */
        end.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findOrdNotDeletePurchase DBOProgram 
PROCEDURE findOrdNotDeletePurchase :
/*------------------------------------------------------------------------------
  Purpose: Verifica se para o pedido existe mais alguma ordem ainda nao eliminada,
           alem da passada como parametro.
  Parameters: N£mero do Pedido
              N£mero da Ordem
              Retorna Yes/No se encontrou registro
  Notes:       
------------------------------------------------------------------------------*/

        DEFINE INPUT  PARAMETER pPedido      like ordem-compra.num-pedido.
        DEFINE INPUT  PARAMETER pNumeroOrdem like ordem-compra.numero-ordem.
        DEFINE OUTPUT PARAMETER pFound   as   logical.

        assign pFound = can-find (first bf{&TableName} 
                                  where bf{&TableName}.num-pedido    = pPedido
                                    and bf{&TableName}.numero-ordem <> pNumeroOrdem
                                    and bf{&TableName}.situacao     <> 4).

        RETURN "OK":U.                          
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findSituacaoDiferenteEliminadaeRecebida DBOProgram 
PROCEDURE findSituacaoDiferenteEliminadaeRecebida :
/*------------------------------------------------------------------------------
  Purpose: Verifica se para a Ordem Serviáo informada (ordem-compra.ordem-servic) 
           existe alguma ordem de compra com situaá∆o diferente de eliminada 
           ou recebida    
  Parameters:  N£mero da Ordem de Serviáo
               Retorna Yes/No se encontrou registro
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then                
    &else 
        DEFINE INPUT  PARAMETER pOrdem   like ordem-compra.ordem-servic.
        DEFINE OUTPUT PARAMETER pFound   as   logical.

        assign pFound = can-find (first bf{&TableName} 
                                  where bf{&TableName}.ordem-servic  = pOrdem
                                  and   bf{&TableName}.situacao     <> 4
                                  and   bf{&TableName}.situacao     <> 6).

        RETURN "OK":U.                          
    &endif

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
        WHEN "nr-tab":U THEN ASSIGN pFieldValue = RowObject.nr-tab.
        WHEN "contato":U THEN ASSIGN pFieldValue = RowObject.contato.
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
        WHEN "dep-almoxar":U THEN ASSIGN pFieldValue = RowObject.dep-almoxar.
        WHEN "hora-atualiz":U THEN ASSIGN pFieldValue = RowObject.hora-atualiz.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "item-pai":U THEN ASSIGN pFieldValue = RowObject.item-pai.
        WHEN "requisitante":U THEN ASSIGN pFieldValue = RowObject.requisitante.
        &IF "{&mguni_version}" >= "2.071" &THEN
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        WHEN "cod-grp-compra":U THEN ASSIGN pFieldValue = RowObject.cod-grp-compra.
        &ENDIF
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-roteiro":U THEN ASSIGN pFieldValue = RowObject.cod-roteiro.
        WHEN "comentarios":U THEN ASSIGN pFieldValue = RowObject.comentarios.
        &if defined(bf_mat_contratos) &then
        &else 
            WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato. 
        &endif              
        &if defined(bf-mat-comex) &then                
            WHEN "narrativa[1]":U THEN ASSIGN pFieldValue = RowObject.narrativa[1].
            WHEN "narrativa[2]":U THEN ASSIGN pFieldValue = RowObject.narrativa[2].
            WHEN "narrativa[3]":U THEN ASSIGN pFieldValue = RowObject.narrativa[3].
            WHEN "narrativa[4]":U THEN ASSIGN pFieldValue = RowObject.narrativa[4].
            WHEN "narrativa[5]":U THEN ASSIGN pFieldValue = RowObject.narrativa[5].
            WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
            WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
            WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
            WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
            WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
            WHEN "cod-roteiro":U THEN ASSIGN pFieldValue = RowObject.cod-roteiro.
            WHEN "comentarios":U THEN ASSIGN pFieldValue = RowObject.comentarios.
            WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.  
            WHEN "origem":U THEN ASSIGN pFieldValue = RowObject.origem.              
            WHEN "natureza":U THEN ASSIGN pFieldValue = RowObject.natureza.        
            WHEN "sit-ord-mp":U THEN ASSIGN pFieldValue = RowObject.sit-ord-mp.        
            WHEN "u-char-1":U THEN ASSIGN pFieldValue = RowObject.u-char-1.                            
        &else 
            WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.        
            WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
            WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.            
            WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
            WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.            
        &endif
        &if "{&bf_mat_versao_ems}" >= "2.09" &then
            when "cod-ord-portal":U then assign pFieldValue = rowObject.cod-ord-portal.
        &endif
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDataPedido DBOProgram 
PROCEDURE getDataPedido :
DEF INPUT PARAMETER  pNumeroOrdem AS INT FORMAT "zzzzz999" NO-UNDO.
 DEF OUTPUT PARAMETER cData        AS DATE NO-UNDO.

    FIND ordem-compra 
        WHERE ordem-compra.numero-ordem = pNumeroOrdem 
        NO-LOCK NO-ERROR.
    IF AVAIL ordem-compra THEN 
        ASSIGN cData = ordem-compra.data-pedido.
    ELSE
        ASSIGN cData = ?.


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
        WHEN "data-atualiz":U THEN ASSIGN pFieldValue = RowObject.data-atualiz.
        WHEN "data-cotacao":U THEN ASSIGN pFieldValue = RowObject.data-cotacao.
        WHEN "data-emissao":U THEN ASSIGN pFieldValue = RowObject.data-emissao.
        WHEN "data-pedido":U THEN  ASSIGN pFieldValue = RowObject.data-pedido.
        &if defined(bf-mat-comex) &then                
        &else
            WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.        
            WHEN "dat-ordem":U THEN ASSIGN pFieldValue = RowObject.dat-ordem.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "valor-descto":U THEN ASSIGN pFieldValue = RowObject.valor-descto.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "ind-reajuste":U THEN ASSIGN pFieldValue = RowObject.ind-reajuste.
        WHEN "perc-descto":U THEN ASSIGN pFieldValue = RowObject.perc-descto.
        WHEN "pre-unit-for":U THEN ASSIGN pFieldValue = RowObject.pre-unit-for.
        WHEN "preco-fornec":U THEN ASSIGN pFieldValue = RowObject.preco-fornec.
        WHEN "preco-orig":U THEN ASSIGN pFieldValue = RowObject.preco-orig.
        WHEN "preco-unit":U THEN ASSIGN pFieldValue = RowObject.preco-unit.
        WHEN "qt-acum-dev":U THEN ASSIGN pFieldValue = RowObject.qt-acum-dev.
        WHEN "qt-acum-nec":U THEN ASSIGN pFieldValue = RowObject.qt-acum-nec.
        WHEN "qt-acum-rec":U THEN ASSIGN pFieldValue = RowObject.qt-acum-rec.
        WHEN "saldo-emb":U THEN ASSIGN pFieldValue = RowObject.saldo-emb.
        WHEN "saldo-gi":U THEN ASSIGN pFieldValue = RowObject.saldo-gi.
        WHEN "valor-frete":U THEN ASSIGN pFieldValue = RowObject.valor-frete.
        WHEN "valor-taxa":U THEN ASSIGN pFieldValue = RowObject.valor-taxa.
        WHEN "aliquota-icm":U THEN ASSIGN pFieldValue = RowObject.aliquota-icm.
        WHEN "aliquota-ipi":U THEN ASSIGN pFieldValue = RowObject.aliquota-ipi.
        WHEN "aliquota-iss":U THEN ASSIGN pFieldValue = RowObject.aliquota-iss.
        &if defined(bf-mat-comex) &then                
        &else
            WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.   
            WHEN "perc-sales-tax":U THEN ASSIGN pFieldValue = RowObject.perc-sales-tax.
            WHEN "qt-solic":U THEN ASSIGN pFieldValue = RowObject.qt-solic.
            WHEN "perc-vat":U THEN ASSIGN pFieldValue = RowObject.perc-vat.                             
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "num-ord-inv":U THEN ASSIGN pFieldValue = RowObject.num-ord-inv.
        WHEN "num-pedido":U THEN ASSIGN pFieldValue = RowObject.num-pedido.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "op-codigo":U THEN ASSIGN pFieldValue = RowObject.op-codigo.
        WHEN "op-seq":U THEN ASSIGN pFieldValue = RowObject.op-seq.
        WHEN "ordem-servic":U THEN ASSIGN pFieldValue = RowObject.ordem-servic.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "tp-despesa":U THEN ASSIGN pFieldValue = RowObject.tp-despesa.
        &IF "{&mguni_version}" < "2.071" &THEN
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "linha":U THEN ASSIGN pFieldValue = RowObject.linha.
        WHEN "prazo-entreg":U THEN ASSIGN pFieldValue = RowObject.prazo-entreg.
        WHEN "nr-alt-preco":U THEN ASSIGN pFieldValue = RowObject.nr-alt-preco.
        WHEN "nr-dias-taxa":U THEN ASSIGN pFieldValue = RowObject.nr-dias-taxa.
        WHEN "nr-ord-orig":U THEN ASSIGN pFieldValue = RowObject.nr-ord-orig.
        WHEN "nr-processo":U THEN ASSIGN pFieldValue = RowObject.nr-processo.
        WHEN "nr-requisicao":U THEN ASSIGN pFieldValue = RowObject.nr-requisicao.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        &if defined(bf_mat_contratos) &then
          when "nr-contrato" then ASSIGN pFieldValue = RowObject.nr-contrato.
        &endif        
        &if defined(bf-mat-comex) &then             
            WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
            WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.           
        &else
            WHEN "num-id-documento":U THEN ASSIGN pFieldValue = RowObject.num-id-documento.        
            WHEN "num-processo-mp":U THEN ASSIGN pFieldValue = RowObject.num-processo-mp.
            WHEN "num-seq-item":U THEN ASSIGN pFieldValue = RowObject.num-seq-item.            
            WHEN "cota-ordem":U THEN ASSIGN pFieldValue = RowObject.cota-ordem.
            WHEN "seq-evento":U THEN ASSIGN pFieldValue = RowObject.seq-evento.            
            WHEN "sit-ordem-contrat":U THEN ASSIGN pFieldValue = RowObject.sit-ordem-contrat.
            WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.            
            WHEN "origem":U THEN ASSIGN pFieldValue = RowObject.origem.
            WHEN "pend-aprov":U THEN ASSIGN pFieldValue = RowObject.pend-aprov. 
            WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.                       
            WHEN "natureza":U THEN ASSIGN pFieldValue = RowObject.natureza.            
            WHEN "nr-seq-contr":U THEN ASSIGN pFieldValue = RowObject.nr-seq-contr.            
            WHEN "cod-maq-origem":U THEN ASSIGN pFieldValue = RowObject.cod-maq-origem.
            WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-transp.
            WHEN "codigo-icm":U THEN ASSIGN pFieldValue = RowObject.codigo-icm.            
        &endif
        WHEN "cdn-tip-lote-pregao":U THEN ASSIGN pFieldValue = &IF "{&bf_mat_versao_ems}" < "2.07" &THEN
                                                                INT(SUBSTRING(rowObject.char-1,64,5)).
                                                               &ELSE
                                                                rowObject.cdn-tip-lote-pregao.
                                                               &ENDIF
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice COMPRADOR
  Parameters:
               retorna valor dos campos do °ndice COMPRADOR
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/

        DEFINE OUTPUT PARAMETER pcod-comprado LIKE ordem-compra.cod-comprado NO-UNDO.
        DEFINE OUTPUT PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

        /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
              retornada flag "NOK":U ---*/
        IF NOT AVAILABLE RowObject THEN
           RETURN "NOK":U.

        ASSIGN pcod-comprado = RowObject.cod-comprado.
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
        WHEN "cons-pmp":U THEN ASSIGN pFieldValue = RowObject.cons-pmp.
        WHEN "taxa-financ":U THEN ASSIGN pFieldValue = RowObject.taxa-financ.
        WHEN "frete":U THEN ASSIGN pFieldValue = RowObject.frete.
        WHEN "impr-ficha":U THEN ASSIGN pFieldValue = RowObject.impr-ficha.
        WHEN "ind-extrac":U THEN ASSIGN pFieldValue = RowObject.ind-extrac.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "reaj-tabela":U THEN ASSIGN pFieldValue = RowObject.reaj-tabela.
        WHEN "codigo-ipi":U THEN ASSIGN pFieldValue = RowObject.codigo-ipi.
        WHEN "cons-mrp":U THEN ASSIGN pFieldValue = RowObject.cons-mrp.
        &if defined(bf-mat-comex) &then             
            WHEN "codigo-icm":U THEN ASSIGN pFieldValue = RowObject.codigo-icm.                
        &else
            WHEN "ordem-emitida":U THEN ASSIGN pFieldValue = RowObject.ordem-emitida. 
            WHEN "expectativa":U THEN ASSIGN pFieldValue = RowObject.expectativa.   
            WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.                            
        &endif
        &if "{&bf_mat_versao_ems}" >= "2.09" &then
            when "log-congela-cotac":U then assign pFieldValue = rowObject.log-congela-cotac.
            when "log-integr-portal":U then assign pFieldValue = rowObject.log-integr-portal.
            when "log-envdo-integr":U  then assign pFieldValue = rowObject.log-envdo-integr.
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

        /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowidOrdemCompra DBOProgram 
PROCEDURE getRowidOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:  
    Procura o rowid da tabela ordem-compra a partir do c¢digo do ordem-compra
    que vem da tabela item-fornec.   
  Parameters:   
    ipar1 : pr-item-fornec  : rowid do registro da tabela item-fornec
    opar2 : pr-ordem-compra : rowid da tabela ordem-compra
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else    
        def input  param pr-item-fornec  as rowid no-undo.
        def output param pr-ordem-compra as rowid no-undo.    

        for first item-fornec fields(it-codigo cod-emitente) where
             rowid(item-fornec) = pr-item-fornec no-lock: end.

        if avail item-fornec then do:
            for last ordem-compra fields(cod-emitente it-codigo num-pedido) where 
                ordem-compra.cod-emitente = item-fornec.cod-emitente and   
                ordem-compra.it-codigo    = item-fornec.it-codigo   and
                ordem-compra.num-pedido <> 0 NO-LOCK: end.
             if avail ordem-compra then
                assign pr-ordem-compra = rowid(ordem-compra).
        end.

        return "OK":U.
    &endif

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
    def output param i-cod-pais as int no-undo.

    assign i-cod-pais = i-pais-impto-usuario.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToEmitOrdem DBOProgram 
PROCEDURE goToEmitOrdem :
/*------------------------------------------------------------------------------
  Purpose:   Reposiciona registro com base no °ndice ITEM
  Parameters:
               recebe valor dos campos do °ndice ORDEM
               retorna status do processo
  Notes: procedure findEmit_ordem
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else
        DEFINE INPUT PARAMETER pemitente     LIKE ordem-compra.cod-emitente NO-UNDO.
        DEFINE INPUT PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

        for first bfordem-compra fields(numero-ordem cod-emitente) WHERE
            bfordem-compra.numero-ordem = pnumero-ordem and
            bfordem-compra.cod-emitente = pemitente 
            NO-LOCK: end.

        /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
        IF NOT AVAILABLE bfordem-compra THEN
            RETURN "NOK":U.

        /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
              existam erros ser† retornada flag "NOK":U ---*/
        RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfordem-compra)).
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.

        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToEmitSitOrdem DBOProgram 
PROCEDURE goToEmitSitOrdem :
/*------------------------------------------------------------------------------
  Purpose:   Reposiciona registro com base no °ndice ITEM
  Parameters:
               recebe valor dos campos do °ndice ORDEM
               retorna status do processo
  Notes: procedure findEmitente
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else
        DEFINE INPUT PARAMETER pemitente     LIKE ordem-compra.cod-emitente NO-UNDO.
        DEFINE INPUT PARAMETER psituacao     LIKE ordem-compra.situacao     NO-UNDO.
        DEFINE INPUT PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

        for first bfordem-compra fields(numero-ordem cod-emitente situacao) WHERE
            bfordem-compra.numero-ordem = pnumero-ordem and
            bfordem-compra.cod-emitente = pemitente     and
            bfordem-compra.situacao     = psituacao
            NO-LOCK: end.

        /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
        IF NOT AVAILABLE bfordem-compra THEN
            RETURN "NOK":U.

        /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
              existam erros ser† retornada flag "NOK":U ---*/
        RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfordem-compra)).
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.

        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToEstabel DBOProgram 
PROCEDURE goToEstabel :
/*------------------------------------------------------------------------------
  Purpose:   Reposiciona registro com base no °ndice ITEM
  Parameters:
               recebe valor dos campos do °ndice ORDEM
               retorna status do processo
  Notes:  procedure findEstabel
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else
        DEFINE INPUT PARAMETER pcod-estabel  LIKE ordem-compra.cod-estabel  NO-UNDO.
        DEFINE INPUT PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

        for first bfordem-compra fields(numero-ordem cod-estabel) WHERE
            bfordem-compra.numero-ordem = pnumero-ordem and
            bfordem-compra.cod-estabel  = pcod-estabel 
            NO-LOCK: end.

        /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
        IF NOT AVAILABLE bfordem-compra THEN
            RETURN "NOK":U.

        /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
              existam erros ser† retornada flag "NOK":U ---*/
        RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfordem-compra)).
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.

        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToItem DBOProgram 
PROCEDURE goToItem :
/*------------------------------------------------------------------------------
  Purpose:   Reposiciona registro com base no °ndice ITEM
  Parameters:
               recebe valor dos campos do °ndice ORDEM
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else
        DEFINE INPUT PARAMETER pit-codigo    LIKE ordem-compra.it-codigo    NO-UNDO.
        DEFINE INPUT PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

        for first bfordem-compra fields(numero-ordem it-codigo) WHERE
            bfordem-compra.numero-ordem = pnumero-ordem and
            bfordem-compra.it-codigo    = pit-codigo 
            NO-LOCK: end.

        /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
        IF NOT AVAILABLE bfordem-compra THEN
            RETURN "NOK":U.

        /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
              existam erros ser† retornada flag "NOK":U ---*/
        RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfordem-compra)).
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.

        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice ORDEM
  Parameters:
               recebe valor dos campos do °ndice ORDEM
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

    for FIRST bfordem-compra fields(numero-ordem) WHERE
        bfordem-compra.numero-ordem = pnumero-ordem
        NO-LOCK: end.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToOrdemCompra DBOProgram 
PROCEDURE goToOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:   Reposiciona no £ltimo  registro. Utiliza o °ndice COMPRA-FORN.  
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else    
        DEFINE INPUT PARAMETER pcod-emitente LIKE ordem-compra.cod-emitente NO-UNDO.
        DEFINE INPUT PARAMETER pit-codigo    LIKE ordem-compra.it-codigo    NO-UNDO.

        for last bfordem-compra fields(cod-emitente it-codigo num-pedido) WHERE
            bfordem-compra.cod-emitente = pcod-emitente and
            bfordem-compra.it-codigo    = pit-codigo    and
            bfordem-compra.num-pedido   <> 0
            NO-LOCK: end.

        /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
        IF NOT AVAILABLE bfordem-compra THEN
            RETURN "NOK":U.

        /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
              existam erros ser† retornada flag "NOK":U ---*/
        RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfordem-compra)).
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.

        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkTogr-cmp-comprad DBOProgram 
PROCEDURE linkTogr-cmp-comprad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else 
        DEFINE INPUT PARAM ph-gr-cmp-comprad AS HANDLE NO-UNDO.

        RUN getKey IN ph-gr-cmp-comprad (OUTPUT ccodcomprado,
                                             OUTPUT  ccodgrpcompra).

        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToOrdemServic DBOProgram 
PROCEDURE linkToOrdemServic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then             
    &else    
        def input param hOrdemServic as handle no-undo.

        RUN GetKey IN hOrdemServic (output iOrdemServic).

        RETURN "OK":U.
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToPedido DBOProgram 
PROCEDURE linkToPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then             
    &else    
        DEFINE INPUT PARAM ph-pedido-compr AS HANDLE NO-UNDO.

        RUN getKey IN ph-pedido-compr (OUTPUT inumpedido).

        RETURN "OK":U.
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToProcesso DBOProgram 
PROCEDURE linkToProcesso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then             
    &else    
        def input param hproc as handle no-undo.

        RUN GetKey IN hproc (output inrprocesso).

        RETURN "OK":U.
    &endif
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

           &if defined(bf-mat-comex) &then             
           &else    
               when 3 then
                  RUN openQueryStatic (input "byItCodigoByNumeroOrdem":U).             

               when 4 then
                  RUN openQueryStatic (input "PerfilUsuarByNrOrdem":U). 

               when 5 then
                  RUN openQueryStatic (input "PerfilUsuarByNrOrdem":U).  

               when 6 then
                  RUN openQueryStatic (input "PerfilUsuarByItCodigo":U). 

               when 8 then
                  RUN openQueryStatic (input "NrProcesso":U).

               when 10 then
                  RUN openQueryStatic (input "ItCodigo":U). 

               when 11 then
                  RUN openQueryStatic (input "ByNumeroOrdem":U). 

               when 12 then
                  RUN openQueryStatic (input "FiltroOrdensPendCompr":U).      

               when 13 then
                  RUN openQueryStatic (input "FiltroOrdensGrpCompra":U).                         

               when 14 then
                  RUN openQueryStatic (input "CodComprado":U). 

               when 15 then
                  RUN openQueryStatic (input "FiltroPedidosOrdens":U).               

               when 16 then
                  RUN openQueryStatic (input "ManutOrdensPedido":U).    

               when 17 then
                  RUN openQueryStatic (input "CodEmitente":U). 

               when 18 then
                  RUN openQueryStatic (input "NumPedido":U). 

               when 19 then
                  RUN openQueryStatic (input "SelecaoSolicOrdem":U). 

               when 20 then
                  RUN openQueryStatic (input "PesquisaByNumeroOrdem":U). 

               when 21 then
                  RUN openQueryStatic (input "PesquisaByItCodigo":U). 

               when 22 then
                  RUN openQueryStatic (input "ParamComprasItem":U).               

               when 23 then
                  RUN openQueryStatic (input "PerfilUsuarByCodEmitente":U).               

               when 24 then
                  RUN openQueryStatic (input "ParamComprasItem1":U).               

               when 25 then
                  RUN openQueryStatic (input "ParamComprasItem2":U).               

               when 26 then
                  RUN openQueryStatic (input "ParamComprasItem3":U).

           &endif                                     
    end case.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByItcodigoByNumeroOrdem DBOProgram 
PROCEDURE openQueryByItcodigoByNumeroOrdem :
/*------------------------------------------------------------------------------
  Purpose:  Busca conjunto de registros da tabela ordem-compra.
            Os registros s∆o ordenados pela C¢digo do Item e depois pelo
            N£mero da Ordem.

  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else    
        open query {&QUERYNAME} for each {&TABLENAME} NO-LOCK
                                          BY ordem-compra.it-codigo
                                          BY ordem-compra.numero-ordem INDEXED-REPOSITION.

        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByItcodigoByNumeroOrdem2 DBOProgram 
PROCEDURE openQueryByItcodigoByNumeroOrdem2 :
/*------------------------------------------------------------------------------
  Purpose: Seleciona o conjunto de registros que faáam parte de um pedido,
           que n∆o tenham sido eliminados e n∆o possuam contrato.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else    
        open query {&QUERYNAME} for each {&TABLENAME} use-index pedido where                                     
                                         {&TABLENAME}.num-pedido   = iNumPedido and                                     
                                         {&TABLENAME}.situacao     = 2          and 
                                         &if defined(bf_mat_contratos) &then
                                           {&TABLENAME}.nr-contrato  =  0
                                         &else
                                           {&TABLENAME}.nr-contrato  =  ""
                                         &endif
                                         /*BY {&tablename}.it-codigo
                                         BY {&TABLENAME}.numero-ordem*/
                                         INDEXED-REPOSITION.
        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNumeroOrdem DBOProgram 
PROCEDURE openQueryByNumeroOrdem :
/*------------------------------------------------------------------------------
  Purpose: Busca conjunto de registros da tabela ordem-compra que tenham o c¢digo
           do item igual ao do parÉmetro recebido pelo setConstraint, com situaá∆o 
           da ordem diferente de Eliminada e Recebida . Tendo como faixa o n£mero
           da ordem. 
           Os registros s∆o ordenados pela N£mero da Ordem.

  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else    
        open query {&QUERYNAME} for each {&TABLENAME} where
                                         {&tablename}.it-codigo     = cItCodigo     and
                                         {&TABLENAME}.numero-ordem >= iNumOrdemIni and
                                         {&TABLENAME}.numero-ordem <= iNumOrdemFim and
                                         {&TABLENAME}.situacao     <> 4               and  
                                         {&TABLENAME}.situacao     <> 6  NO-LOCK
                                         by {&tablename}.it-codigo
                                         BY {&TABLENAME}.numero-ordem
                                         INDEXED-REPOSITION.
        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNumeroOrdem2 DBOProgram 
PROCEDURE openQueryByNumeroOrdem2 :
/*------------------------------------------------------------------------------
  Purpose: Seleciona o conjunto de registros que faáam parte de um pedido,
           que n∆o tenham sido eliminados e n∆o possuam contrato.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else    
        open query {&QUERYNAME} for each {&TABLENAME} where                                     
                                         {&TABLENAME}.num-pedido   = iNumPedido and                                     
                                         {&TABLENAME}.situacao     = 2          and 
                                         &if defined(bf_mat_contratos) &then
                                           {&TABLENAME}.nr-contrato  =  0
                                         &else
                                           {&TABLENAME}.nr-contrato  =  ""
                                         &endif
                                         /*BY {&TABLENAME}.numero-ordem*/
                                         INDEXED-REPOSITION.
        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByPedido DBOProgram 
PROCEDURE openQueryByPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QueryName} for each {&TableName} where
                             {&TableName}.num-pedido = iNumPed 
                             NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.                                
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodComprado DBOProgram 
PROCEDURE openQueryCodComprado :
/*------------------------------------------------------------------------------
  Purpose: Busca conjunto de registros da tabela ordem-compra tendo como faixa o
           c¢digo do item, o n£mero da ordem, a data de emiss∆o e o requisistante, 
           e a situaá∆o da ordem ser† diferente de Confirmada, Eliminada  e Recebida . 
           Os registros s∆o ordenados pelo N£mero da Ordem.

  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else    
        open query {&QUERYNAME} for each {&TABLENAME} where
                                         {&TABLENAME}.cod-comprado   = cCodComprado  and
                                         {&tablename}.it-codigo     >= cItCodigoIni  and
                                         {&tablename}.it-codigo     <= cItCodigoFim  and
                                         {&TABLENAME}.numero-ordem  >= iNumOrdemIni  and
                                         {&TABLENAME}.numero-ordem  <= iNumOrdemFim  and
                                         {&TABLENAME}.data-emissao  >= daDataIni     and
                                         {&TABLENAME}.data-emissao  <= daDataFim     and
                                         {&TABLENAME}.requisitante  >= cRequisIni    and
                                         {&TABLENAME}.requisitante  <= cRequisFim    and
                                         {&TABLENAME}.situacao      <> 2             and
                                         {&TABLENAME}.situacao      <> 4             and
                                         {&TABLENAME}.situacao      <> 6             no-lock
                                         INDEXED-REPOSITION .

        RETURN "OK":U.                                         
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodEmitente DBOProgram 
PROCEDURE openQueryCodEmitente :
/*------------------------------------------------------------------------------
  Purpose:   Busca conjunto de registros da tabela ordem-compra de acordo o 
             c¢digo do emitente, natureza e condiá∆o de pagamento  existentes 
             na tabela pedido-compr posicionada pelo setConstraint. Conjunto de
             registros com situaá∆o da ordem Cotada e n£mero do pedido igual a zero.
             Os registros s∆o ordenados pelo N£mero da Ordem.

  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then             
    &else    
        open query {&QUERYNAME} FOR EACH {&TABLENAME} WHERE
                                         {&TABLENAME}.cod-emitente = pedido-compr.cod-emitente AND
                                         {&TABLENAME}.situacao     = 3                         AND
                                         {&TABLENAME}.num-pedido   = 0                         AND
                                         {&TABLENAME}.natureza     = pedido-compr.natureza     AND
                                         {&TABLENAME}.cod-cond-pag = pedido-compr.cod-cond-pag 
                                          NO-LOCK INDEXED-REPOSITION.
        RETURN "OK":U.                                      
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroOrdensGrpCompra DBOProgram 
PROCEDURE openQueryFiltroOrdensGrpCompra :
/*------------------------------------------------------------------------------
  Purpose: Busca conjunto de registros da tabela ordem-compra que tenham o c¢digo
           do grupo de compra igual ao do parÉmetro recebido pelo setConstraint. 
           Busca conjunto de registros com situaá∆o da ordem diferente de Confirmada,
           Eliminada, Recebida e c¢digo do comprador igual a "" (branco). 
           Tendo como faixa o c¢digo do item,  o n£mero da ordem, data de emiss∆o
           e requisitante - parÉmetros vindos de uma tela que filtra as ordens do
           grupo de compra.
           Os registros s∆o ordenados pelo N£mero da Ordem.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else    
        open query {&QUERYNAME} for each {&TABLENAME} where
                                  &if '{&bf_mat_versao_ems}' >= '2.071' &then
                                    {&TABLENAME}.cod-grp-compra = cCodGrpCompra  and
                                  &else
                                    &if "{&DBtype}" <> "progress" &then
                                      substr({&TABLENAME}.char-2,88,12)  = cCodGrpCompra  and                      
                                    &else
                                      substr({&TABLENAME}.char-2,188,12) = cCodGrpCompra  and
                                    &endif
                                  &endif
                                         {&tablename}.it-codigo     >= cItCodigoIni   and
                                         {&tablename}.it-codigo     <= cItCodigoFim   and
                                         {&TABLENAME}.numero-ordem  >= iNumOrdemIni   and
                                         {&TABLENAME}.numero-ordem  <= iNumOrdemFim   and
                                         {&TABLENAME}.data-emissao  >= daDataIni      and
                                         {&TABLENAME}.data-emissao  <= daDataFim      and
                                         {&TABLENAME}.requisitante  >= cRequisIni     and
                                         {&TABLENAME}.requisitante  <= cRequisFim     and
                                         {&TABLENAME}.situacao      <> 2              and
                                         {&TABLENAME}.situacao      <> 4              and
                                         {&TABLENAME}.situacao      <> 6              and
                                         {&TABLENAME}.cod-comprado   = ""             NO-LOCK
                                         &if "{&DBtype}" = "progress" &then   
                                            INDEXED-REPOSITION
                                         &endif.
        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroOrdensPendCompr DBOProgram 
PROCEDURE openQueryFiltroOrdensPendCompr :
/*------------------------------------------------------------------------------
  Purpose: Busca conjunto de registros da tabela ordem-compra que tenham o c¢digo
           do comprador igual ao do parÉmetro recebido pelo setConstraint. Busca
           conjunto de registros com situaá∆o da ordem igual a N∆o Confirmada e 
           Em Cotaá∆o. 
           Tendo como faixa o c¢digo do item,  o n£mero da ordem, data de emiss∆o 
           e o c¢digo do estabelecimento - parÉmetros vindos de uma tela que filtra 
           as ordens da pendància do comprador.
           Os registros s∆o ordenados pelo N£mero da Ordem.

  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else    
        open query {&queryname} for each {&TABLENAME} WHERE
                                          {&TABLENAME}.cod-comprado = cCodComprado      AND
                                          /* Filtro */
                                          {&TABLENAME}.numero-ordem >= iNumOrdemIni     AND
                                          {&TABLENAME}.numero-ordem <= iNumOrdemFim     AND
                                          {&TABLENAME}.cod-estabel  >= cCodEstabelIni   AND
                                          {&TABLENAME}.cod-estabel  <= cCodEstabelFim   AND
                                          {&TABLENAME}.data-emissao >= daDataEmissaoIni AND
                                          {&TABLENAME}.data-emissao <= daDataEmissaoFim AND
                                          {&tablename}.it-codigo    >= cItCodigoIni     AND
                                          {&tablename}.it-codigo    <= cItCodigoFim     AND
                                          /* Filtro */
                                         ({&TABLENAME}.situacao = 5 or {&TABLENAME}.situacao = 1) 
                                          NO-LOCK INDEXED-REPOSITION.
        RETURN "OK":U.                                          
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroPedidosOrdens DBOProgram 
PROCEDURE openQueryFiltroPedidosOrdens :
/*------------------------------------------------------------------------------
  Purpose:  Busca conjunto de registros da tabela ordem-compra que tenham o c¢digo
            do comprador igual ao do parÉmetro recebido pelo setConstraint. Busca 
            conjunto de registros com situaá∆o da ordem igual Cotada. 
            Tendo como faixa o c¢digo do item e o n£mero da ordem - parÉmetros vindos 
            de uma tela que filtra as ordens do pedido.
            Os registros s∆o ordenados pelo N£mero da Ordem.

  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else    
        open query {&QUERYNAME} FOR EACH {&TABLENAME} WHERE
                                          {&TABLENAME}.cod-comprado = cCodComprado  and
                                          {&TABLENAME}.situacao     = 3             and
                                          {&TABLENAME}.numero-ordem >= iNumOrdemIni and
                                          {&TABLENAME}.numero-ordem <= iNumOrdemFim and
                                          {&tablename}.it-codigo    >= cItCodigoIni and
                                          {&tablename}.it-codigo    <= cItCodigoFim
                                           NO-LOCK INDEXED-REPOSITION.

        RETURN "OK":U.                                       
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItCodigo DBOProgram 
PROCEDURE openQueryItCodigo :
/*------------------------------------------------------------------------------
  Purpose: Busca conjunto de registros da tabela ordem-compra de acordo com os 
           parÉmetros que levam o c¢digo do item e c¢digo do comprador, e com 
           situaá∆o igual a N∆o Confirmada ou igual a Em Cotaá∆o.
           Os registros s∆o ordenados pelo N£mero da Ordem.

  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then             
    &else    
        open query {&QUERYNAME} for each {&TABLENAME} where
                                         {&tablename}.it-codigo    = cItCodigo AND 
                                         {&TABLENAME}.cod-comprado = cCodComprado AND 
                                        ({&TABLENAME}.situacao     = 1 OR {&TABLENAME}.situacao = 5) 
                                         NO-LOCK INDEXED-REPOSITION.

        RETURN "OK":U.
    &endif

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
    OPEN QUERY {&QueryName} FOR EACH ordem-compra NO-LOCK indexed-reposition.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryManutOrdensPedido DBOProgram 
PROCEDURE openQueryManutOrdensPedido :
/*------------------------------------------------------------------------------
  Purpose: Busca conjunto de registros da tabela ordem-compra que tenham o n£mero
           do pedido igual ao do parÉmetro recebido pelo setConstraint, registros
           que sofrer∆o manutená‰es.
           Os registros s∆o ordenados pelo N£mero da Ordem.

  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then             
    &else    
        open query {&QUERYNAME} FOR EACH {&TABLENAME} WHERE
                                         {&TABLENAME}.num-pedido = iNumPedido NO-LOCK
                                      BY {&TABLENAME}.num-pedido
                                      BY {&TABLENAME}.numero-ordem 
                                      &if ("&emsdbtype") = "progress" &then 
                                        INDEXED-REPOSITION
                                      &endif.

        RETURN "OK":U.                                   
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNrProcesso DBOProgram 
PROCEDURE openQueryNrProcesso :
/*------------------------------------------------------------------------------
  Purpose: Busca conjunto de registros da tabela ordem-compra que tenham o n£mero 
           do processo igual ao do parÉmetro recebido pelo setConstraint.
           Os registros s∆o ordenados pela N£mero da Ordem.

  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else    
        open query {&QUERYNAME} for each {&TABLENAME} no-lock where
                                         {&TABLENAME}.nr-processo  = iNrProcesso 
                                         INDEXED-REPOSITION.

        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNumPedido DBOProgram 
PROCEDURE openQueryNumPedido :
/*------------------------------------------------------------------------------
  Purpose: Busca conjunto de registros da tabela ordem-compra de acordo com o 
           n£mero do pedido  existente na tabela pedido-compr posicionada pelo 
           setConstraint. Busca conjunto de registros com situaá∆o da ordem 
           diferente de Eliminada.
           Os registros s∆o ordenados pelo N£mero da Ordem.

  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else    
        open query {&QUERYNAME} FOR EACH {&TABLENAME} WHERE
                                         {&TABLENAME}.num-pedido = pedido-compr.num-pedido AND
                                         {&TABLENAME}.situacao <> 4 
                                         NO-LOCK INDEXED-REPOSITION.

        RETURN "OK":U.  
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNumPedido2 DBOProgram 
PROCEDURE openQueryNumPedido2 :
/*------------------------------------------------------------------------------
  Purpose: Busca conjunto de registros da tabela ordem-compra que tenham o n£mero
           do pedido igual ao do parÉmetro recebido pelo setConstraint, registros
           que sofrer∆o manutená‰es.
           Os registros s∆o ordenados pelo N£mero da Ordem.

  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else    
        open query {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK
                                WHERE    {&TABLENAME}.num-pedido = iNumPedido       
                                          BY {&TABLENAME}.numero-ordem
                                         INDEXED-REPOSITION.

        RETURN "OK":U.                                   
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOrdemPedido DBOProgram 
PROCEDURE openQueryOrdemPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

if  lNaoconfirmada and
    lCotada        and
    lConfirmada    and
    lEliminada     and
    lCotacao       and
    lTermin        then  
     open query {&QueryName} for each {&TableName} NO-LOCK where
                               {&TableName}.num-pedido = iNumPedido            
                               INDEXED-REPOSITION.
else                              
     open query {&QueryName} for each {&TableName} NO-LOCK where
                               {&TableName}.num-pedido = iNumPedido            and
                             (({&TableName}.situacao   = 1 and lNaoconfirmada) or
                              ({&TableName}.situacao   = 2 and lCotada)        or
                              ({&TableName}.situacao   = 3 and lConfirmada)    or
                              ({&TableName}.situacao   = 4 and lEliminada)     or
                              ({&TableName}.situacao   = 5 and lCotacao)       or
                              ({&TableName}.situacao   = 6 and lTermin))       
                             by {&TABLENAME}.num-pedido
                             by {&TableName}.numero-ordem 
                             INDEXED-REPOSITION.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOrdemServic DBOProgram 
PROCEDURE openQueryOrdemServic :
/*------------------------------------------------------------------------------
  Purpose:   Busca conjunto de registros da tabela ordem-compra de acordo o 
             n£mero da ordem de serviáo.
             Os registros s∆o ordenados pelo N£mero da Ordem.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then             
    &else    
        open query {&QUERYNAME} FOR EACH {&TABLENAME} WHERE
                                         {&TABLENAME}.ordem-servic = iOrdemServic 
                                          no-lock by {&tablename}.numero-ordem INDEXED-REPOSITION.
        RETURN "OK":U.                                      
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryParamComprasItem DBOProgram 
PROCEDURE openQueryParamComprasItem :
/*------------------------------------------------------------------------------
  Purpose: Busca conjunto de registros da tabela ordem-compra que tenham o 
           c¢digo do item igual ao do parÉmetro recebido pelo setConstraint.
           Tem tambÇm faixa de data do pedido  junto com o tipo de natureza 
           da ordem - parÉmetros vindos de uma tela de parametriza as ordens 
           de compras do item.  
           Os registros s∆o ordenados pelo N£mero da Ordem.

  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then             
    &else    
        open query {&QUERYNAME} for each {&TABLENAME} WHERE 
                                         {&tablename}.it-codigo     = cItCodigo        AND 
                                       (({&TABLENAME}.natureza      = 1 AND lCompra)   OR 
                                        ({&TABLENAME}.natureza      = 2 AND lServico)  OR 
                                        ({&TABLENAME}.natureza      = 3 AND lBenefic)) AND 
                                       (({&TABLENAME}.data-pedido  >= daDataIni)       AND
                                        ({&TABLENAME}.data-pedido  <= daDataFim))  NO-LOCK 
                                        INDEXED-REPOSITION.
        RETURN "OK":U.                                    
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryParamComprasItem1 DBOProgram 
PROCEDURE openQueryParamComprasItem1 :
&if defined(bf-mat-comex) &then             
    &else   
        open query {&QUERYNAME} for each {&TABLENAME} where
                                         {&tablename}.it-codigo = cItCodigo 
                                        &if ("&emsdbtype") = "Progress" &then
                                           no-lock indexed-reposition
                                        &else
                                           no-lock.
                                        &endif
        RETURN "OK":U.                                    
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryParamComprasItem2 DBOProgram 
PROCEDURE openQueryParamComprasItem2 :
&if defined(bf-mat-comex) &then             
    &else    
        open query {&QUERYNAME} for each {&TABLENAME} where 
                                         {&tablename}.it-codigo    = cItCodigo  and 
                                       (({&TABLENAME}.data-pedido  < daDataFim  or
                                         {&TABLENAME}.data-pedido  = daDataFim) or
                                         {&TABLENAME}.data-pedido  = ?) and
                                       (({&TABLENAME}.natureza      = 1 and lCompra)   or
                                        ({&TABLENAME}.natureza      = 2 and lServico)  or
                                        ({&TABLENAME}.natureza      = 3 and lBenefic)) 
                                      &if ("&emsdbtype") = "Progress" &then 
                                        no-lock  indexed-reposition
                                      &else                                 
                                        no-lock.                            
                                      &endif                                
        RETURN "OK":U.                                    
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryParamComprasItem3 DBOProgram 
PROCEDURE openQueryParamComprasItem3 :
&if defined(bf-mat-comex) &then             
    &else    
        open query {&QUERYNAME} for each {&TABLENAME} where
                                         {&tablename}.it-codigo     = cItCodigo        and 
                                       (({&TABLENAME}.natureza      = 1 and  lCompra)   or 
                                        ({&TABLENAME}.natureza      = 2 and  lServico)  or 
                                        ({&TABLENAME}.natureza      = 3 and  lBenefic)) and
                                    &if ("&emsdbtype") <> "Progress" &then
                                       (({&TABLENAME}.data-pedido  > daDataIni)    or
                                        ({&TABLENAME}.data-pedido  = daDataIni))   and
                                       (({&TABLENAME}.data-pedido  < daDataFim)    or
                                        ({&TABLENAME}.data-pedido  = daDataFim)) no-lock.
                                    &else
                                       (({&TABLENAME}.data-pedido >= daDataIni)  and
                                        ({&TABLENAME}.data-pedido  <= daDataFim))  
                                       no-lock indexed-reposition.
                                    &endif
        RETURN "OK":U.                                    
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPerfilUsuarByCodEmitente DBOProgram 
PROCEDURE openQueryPerfilUsuarByCodEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else    
        open query {&QUERYNAME} for each {&TABLENAME} no-lock where
                                         {&TABLENAME}.cod-emitente = iEmitente 
                                         BY {&TABLENAME}.cod-emitente
                                         BY {&TABLENAME}.numero-ordem 
                                         INDEXED-REPOSITION.
        RETURN "OK":U.
    &endif                                           



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPerfilUsuarByItCodigo DBOProgram 
PROCEDURE openQueryPerfilUsuarByItCodigo :
/*------------------------------------------------------------------------------
  Purpose:  Busca conjunto de registros da tabela ordem-compra. Usando o c¢digo 
            do emitente para o controle do "perfil do usu†rio".
            Os registros s∆o ordenados pelo C¢digo do Item e N£mero da Ordem.

  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then             
    &else    
        open query {&QUERYNAME} for each {&TABLENAME} no-lock where
                                         {&TABLENAME}.cod-emitente = iEmitente 
                                         BY ordem-compra.cod-emitente
                                         BY ordem-compra.numero-ordem 
                                         /*BY ordem-compra.it-codigo*/
                                         INDEXED-REPOSITION.
        RETURN "OK":U.
    &endif                                           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPerfilUsuarByNrOrdem DBOProgram 
PROCEDURE openQueryPerfilUsuarByNrOrdem :
/*------------------------------------------------------------------------------
  Purpose: Busca conjunto de registros da tabela ordem-compra. Usando o c¢digo 
           do emitente para o controle do "perfil do usu†rio".
           Os registros s∆o ordenados pelo N£mero da Ordem.

  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then             
    &else    
        open query {&QUERYNAME} for each {&TABLENAME} where    
                                         {&TABLENAME}.cod-emitente = iEmitente no-lock
                                         BY {&TABLENAME}.cod-emitente
                                         BY {&TABLENAME}.numero-ordem 
                                         INDEXED-REPOSITION.
        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPerfilUsuarNumeroOrdem DBOProgram 
PROCEDURE openQueryPerfilUsuarNumeroOrdem :
/*------------------------------------------------------------------------------
  Purpose:  Busca conjunto de registros da tabela ordem-compra a partir do valor
            da ordem de compra recebido pelo setConstraint. Usando o c¢digo 
            do emitente para o controle do "perfil do usu†rio".
            Os registros s∆o ordenados pelo N£mero da Ordem.

  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then             
    &else    
        open query {&QUERYNAME} for each {&TABLENAME} where
                                         {&TABLENAME}.cod-emitente  = iEmitente and
                                         {&TABLENAME}.numero-ordem >= iNumOrdemIni
                                         no-lock INDEXED-REPOSITION.
        RETURN "OK":U.                                     
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPesquisaByItCodigo DBOProgram 
PROCEDURE openQueryPesquisaByItCodigo :
/*------------------------------------------------------------------------------
  Purpose: Busca conjunto de registros da tabela ordem-compra para o programa de
           pesquisa, tendo como faixa o n£mero da ordem, o c¢digo do estabelecimento,
           o c¢digo do item, e o c¢digo do emitente (este para controle de perfil 
           do usu†rio) junto com o tipo de situaá∆o da ordem .
           Os registros s∆o ordenados pelo C¢digo do Item.

  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else    
        /* Quando for Parametrizado para mostrar todas as situaá‰es das ordens de compra
           ser† aberta a query da ordem de compra sem olhar a situacao. Este alteraá∆o tem
           como objetivo melhorar a performance diminuindo o nr de acessos a base  */
        IF  lNaoConfirmada
        AND lConfirmada
        AND lCotacao
        AND lEliminada
        AND lEmCotacao
        AND lRecebida THEN
            open query {&QUERYNAME}
                FOR EACH {&TABLENAME} WHERE
                         {&TABLENAME}.numero-ordem <= iNumOrdemFim     AND
                         {&TABLENAME}.numero-ordem >= iNumOrdemIni     AND
                         {&TABLENAME}.cod-estabel  <= cCodEstabelFim   AND
                         {&TABLENAME}.cod-estabel  >= cCodEstabelIni   AND
                         {&tablename}.it-codigo    >= cItCodigoIni     AND
                         {&tablename}.it-codigo    <= cItCodigoFim     AND 
                         {&TABLENAME}.cod-emitente >= iEmitenteIni     AND 
                         {&TABLENAME}.cod-emitente <= iEmitenteFim     NO-LOCK
                         by {&tablename}.it-codigo INDEXED-REPOSITION.
        ELSE
            open query {&QUERYNAME} 
                FOR EACH {&TABLENAME} WHERE
                         {&TABLENAME}.numero-ordem <= iNumOrdemFim     AND
                         {&TABLENAME}.numero-ordem >= iNumOrdemIni     AND
                         {&TABLENAME}.cod-estabel  <= cCodEstabelFim   AND
                         {&TABLENAME}.cod-estabel  >= cCodEstabelIni   AND
                         {&tablename}.it-codigo    >= cItCodigoIni     AND
                         {&tablename}.it-codigo    <= cItCodigoFim     AND 
                         {&TABLENAME}.cod-emitente >= iEmitenteIni     AND 
                         {&TABLENAME}.cod-emitente <= iEmitenteFim     AND 
                       (({&TABLENAME}.situacao = 1 and lNaoConfirmada) OR 
                        ({&TABLENAME}.situacao = 2 and lConfirmada)    OR 
                        ({&TABLENAME}.situacao = 3 and lCotacao)       OR 
                        ({&TABLENAME}.situacao = 4 and lEliminada)     OR 
                        ({&TABLENAME}.situacao = 5 and lEmCotacao)     OR 
                        ({&TABLENAME}.situacao = 6 and lRecebida))     NO-LOCK
                         by {&tablename}.it-codigo INDEXED-REPOSITION.

        RETURN "OK":U.
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPesquisaByNumeroOrdem DBOProgram 
PROCEDURE openQueryPesquisaByNumeroOrdem :
/*------------------------------------------------------------------------------
  Purpose:  Busca conjunto de registros da tabela ordem-compra para o programa de
            pesquisa, tendo como faixa o n£mero da ordem, o c¢digo do estabelecimento,
            o c¢digo do item, e o c¢digo do emitente (este para controle de perfil
            do usu†rio) junto com o tipo de situaá∆o da ordem .
            Os registros s∆o ordenados pelo N£mero da Ordem.

  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else

        /* Quando for Parametrizado para mostrar todas as situaá‰es das ordens de compra
           ser† aberta a query da ordem de compra sem olhar a situacao. Este alteraá∆o tem
           como objetivo melhorar a performance diminuindo o nr de acessos a base  */
        IF  lNaoConfirmada
        AND lConfirmada
        AND lCotacao
        AND lEliminada
        AND lEmCotacao
        AND lRecebida THEN DO:
            /* Se o usu†rio informar a faixa inicial e final de itens que deseja pesquisar 
               e deixar a OC com a seleá∆o aberta ser† utilizado o °ndice ITEM melhorando os 
               acessos a base */
            IF  inumOrdemIni = 0
            AND inumOrdemFim >= 99999999
            AND (   ( cItCodigoIni > "" AND substr(cItCodigoFim,1,8) < "ZZZZZZZZ")
                 OR ( cItCodigoIni = cItCodigoFim)) THEN
                open query {&QUERYNAME} 
                    FOR EACH {&TABLENAME} USE-INDEX ITEM WHERE
                             {&TABLENAME}.numero-ordem <= iNumOrdemFim      AND
                             {&TABLENAME}.numero-ordem >= iNumOrdemIni      AND
                             {&TABLENAME}.cod-estabel  <= cCodEstabelFim    AND
                             {&TABLENAME}.cod-estabel  >= cCodEstabelIni    AND
                             {&tablename}.it-codigo    >= cItCodigoIni      AND
                             {&tablename}.it-codigo    <= cItCodigoFim      AND
                             {&TABLENAME}.cod-emitente >= iEmitenteIni      AND 
                             {&TABLENAME}.cod-emitente <= iEmitenteFim 
                             by {&TABLENAME}.numero-ordem INDEXED-REPOSITION.
            ELSE
                open query {&QUERYNAME} 
                    FOR EACH {&TABLENAME} WHERE
                             {&TABLENAME}.numero-ordem <= iNumOrdemFim      AND
                             {&TABLENAME}.numero-ordem >= iNumOrdemIni      AND
                             {&TABLENAME}.cod-estabel  <= cCodEstabelFim    AND
                             {&TABLENAME}.cod-estabel  >= cCodEstabelIni    AND
                             {&tablename}.it-codigo    >= cItCodigoIni      AND
                             {&tablename}.it-codigo    <= cItCodigoFim      AND
                             {&TABLENAME}.cod-emitente >= iEmitenteIni      AND 
                             {&TABLENAME}.cod-emitente <= iEmitenteFim 
                             by {&TABLENAME}.numero-ordem INDEXED-REPOSITION.

        END.
        ELSE DO:
            /* Se o usu†rio informar o item e deixar a OC com a seleá∆o aberta
               ser† utilizado o °ndice ITEM melhorando os acessos a base */
            IF  inumOrdemIni = 0
            AND inumOrdemFim >= 99999999
            AND (   ( cItCodigoIni <> "" AND cItCodigoFim <> "ZZZZZZZZZZZZZZZZ")
                 OR ( cItCodigoIni = cItCodigoFim)) THEN
                open query {&QUERYNAME} FOR EACH {&TABLENAME} WHERE
                                                 {&TABLENAME}.numero-ordem <= iNumOrdemFim      AND
                                                 {&TABLENAME}.numero-ordem >= iNumOrdemIni      AND
                                                 {&TABLENAME}.cod-estabel  <= cCodEstabelFim    AND
                                                 {&TABLENAME}.cod-estabel  >= cCodEstabelIni    AND
                                                 {&tablename}.it-codigo    >= cItCodigoIni      AND
                                                 {&tablename}.it-codigo    <= cItCodigoFim      AND
                                                 {&TABLENAME}.cod-emitente >= iEmitenteIni      AND 
                                                 {&TABLENAME}.cod-emitente <= iEmitenteFim      AND 
                                                (({&TABLENAME}.situacao = 1 and lNaoConfirmada) OR 
                                                 ({&TABLENAME}.situacao = 2 and lConfirmada)    OR 
                                                 ({&TABLENAME}.situacao = 3 and lCotacao)       OR 
                                                 ({&TABLENAME}.situacao = 4 and lEliminada)      OR 
                                                 ({&TABLENAME}.situacao = 5 and lEmCotacao)      OR 
                                                 ({&TABLENAME}.situacao = 6 and lRecebida))      NO-LOCK
                                                 by {&TABLENAME}.numero-ordem INDEXED-REPOSITION.
            ELSE
                open query {&QUERYNAME} FOR EACH {&TABLENAME} WHERE
                                                 {&TABLENAME}.numero-ordem <= iNumOrdemFim      AND
                                                 {&TABLENAME}.numero-ordem >= iNumOrdemIni      AND
                                                 {&TABLENAME}.cod-estabel  <= cCodEstabelFim    AND
                                                 {&TABLENAME}.cod-estabel  >= cCodEstabelIni    AND
                                                 {&tablename}.it-codigo    >= cItCodigoIni      AND
                                                 {&tablename}.it-codigo    <= cItCodigoFim      AND
                                                 {&TABLENAME}.cod-emitente >= iEmitenteIni      AND 
                                                 {&TABLENAME}.cod-emitente <= iEmitenteFim      AND 
                                                (({&TABLENAME}.situacao = 1 and lNaoConfirmada) OR 
                                                 ({&TABLENAME}.situacao = 2 and lConfirmada)    OR 
                                                 ({&TABLENAME}.situacao = 3 and lCotacao)       OR 
                                                 ({&TABLENAME}.situacao = 4 and lEliminada)      OR 
                                                 ({&TABLENAME}.situacao = 5 and lEmCotacao)      OR 
                                                 ({&TABLENAME}.situacao = 6 and lRecebida))      NO-LOCK
                                                 by {&TABLENAME}.numero-ordem INDEXED-REPOSITION.

        END.


        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRelacionamento DBOProgram 
PROCEDURE openQueryRelacionamento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&if defined(bf-mat-comex) &then             
&else    
    open query {&QUERYNAME} FOR EACH {&TABLENAME} WHERE
                                     {&TABLENAME}.cod-emitente = iEmitente     and
                                     {&TABLENAME}.natureza     = iNatureza     and
                                     {&TABLENAME}.cod-cond-pag = iCodCondPag   and
                                     {&TABLENAME}.nr-processo  = iNrProcesso   and
                                     {&TABLENAME}.cod-transp   = iCodTransp    and
                                     {&TABLENAME}.num-pedido   = 0             and
                                     {&TABLENAME}.situacao     = 3             and
                                     {&TABLENAME}.expectativa  = no            and 
                                     {&TABLENAME}.numero-ordem >= iNumOrdemIni and
                                     {&TABLENAME}.numero-ordem <= iNumOrdemFim
                                     NO-LOCK INDEXED-REPOSITION.                                              
&endif                                     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySelecaoSolicOrdem DBOProgram 
PROCEDURE openQuerySelecaoSolicOrdem :
/*------------------------------------------------------------------------------
  Purpose: Busca conjunto de registros da tabela ordem-compra a partir de uma 
           faixa de n£mero da ordem, c¢digo do comprador, c¢digo do item e data 
           de emiss∆o que servem para selecionar as ordens de uma solicitaá∆o de 
           ordem .
           Os registros s∆o ordenados pelo N£mero da Ordem.

  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else    
        open query {&QUERYNAME} FOR EACH {&TABLENAME} WHERE
                                         {&TABLENAME}.numero-ordem <= iNumOrdemFim  AND
                                         {&TABLENAME}.numero-ordem >= iNumOrdemIni  AND
                                         {&TABLENAME}.cod-comprado <= cCodCompradoFim AND
                                         {&TABLENAME}.cod-comprado >= cCodCompradoIni AND
                                         {&tablename}.it-codigo    >= cItCodigoIni      AND
                                         {&tablename}.it-codigo    <= cItCodigoFim      AND
                                         {&TABLENAME}.data-emissao <= daDataFim     AND
                                         {&TABLENAME}.data-emissao >= daDataIni NO-LOCK
                                         INDEXED-REPOSITION. 
        RETURN "OK":U.                                     
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryZoomOrdemCotacaoItem DBOProgram 
PROCEDURE openQueryZoomOrdemCotacaoItem :
/*------------------------------------------------------------------------------
  Purpose: Busca conjunto de registros da tabela ordem-compra de acordo com o 
           item para qual a cotaá∆o ser† cadastrada, e tambÇm s¢ mostra registros
           da ordem a partir de uma faixa de numero da ordem e com situaá∆o
           N∆o Confirmada , Cotada e Em Cotaá∆o.
           Os registros s∆o ordenados pelo N£mero da Ordem.

  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then             
    &else    
        open query {&QUERYNAME} for each {&TABLENAME} where
                                         {&tablename}.it-codigo     = cItCodigoIni and
                                         {&TABLENAME}.numero-ordem >= iNumOrdemIni and
                                         {&TABLENAME}.numero-ordem <= iNumOrdemFim and
                                         {&TABLENAME}.situacao <> 4                and
                                         {&TABLENAME}.situacao <> 6                and
                                         {&TABLENAME}.situacao <> 2  NO-LOCK
                                         BY {&tablename}.it-codigo
                                         BY {&TABLENAME}.numero-ordem INDEXED-REPOSITION.

        RETURN "OK":U.                                     
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-deleta-unid-neg-ordem DBOProgram 
PROCEDURE pi-deleta-unid-neg-ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p_opcao          as int                          no-undo.
    def output param p_avail          as log                          no-undo.
    
    if p_opcao = 1 then do: /*procura*/
        if can-find (first unid-neg-ordem where
                           unid-neg-ordem.numero-ordem = rowObject.numero-ordem) then do:
            assign p_avail = yes.
        end.
        else do:
            assign p_avail = no.
        end.
    end.
    else do: /*deleta*/
        for each unid-neg-ordem exclusive-lock where
                 unid-neg-ordem.numero-ordem = rowObject.numero-ordem:
            delete unid-neg-ordem.
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

 
&IF DEFINED(EXCLUDE-pi-goToOrdem) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-goToOrdem Procedure
PROCEDURE goToOrdem:

/*------------------------------------------------------------------------------
		Purpose:  																	  
		Notes:  																	  
------------------------------------------------------------------------------*/
  
    DEFINE INPUT PARAMETER prow_id AS ROWID NO-UNDO.
  
    /*Reposiciona a query atraves do e rowid e verifica a existencia de error.
      Caso exista error, ser· retornado a flag "NOK" */
     
    RUN repositionRecord in THIS-PROCEDURE(INPUT prow_id).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
     
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RetornaEnvioPregao DBOProgram 
PROCEDURE RetornaEnvioPregao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM pi-numero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAM pl-env-pregao AS LOG NO-UNDO.

    FIND FIRST ordem-compra NO-LOCK
         WHERE ordem-compra.numero-ordem = pi-numero-ordem NO-ERROR.
    IF AVAIL ordem-compra THEN DO:
        FIND FIRST cotacao-item NO-LOCK
            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem              
              AND cotacao-item.cod-emitente = 0 NO-ERROR.
        IF AVAIL cotacao-item THEN DO:
            IF cotacao-item.ind-via-envio = 17 THEN
                ASSIGN pl-env-pregao = YES.
            ELSE 
                ASSIGN pl-env-pregao = NO.
        END.
        ELSE DO:
            FIND FIRST cotacao-item NO-LOCK
                WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem                  
                  AND cotacao-item.cod-emitente = ordem-compra.cod-emitente NO-ERROR.
            IF AVAIL cotacao-item THEN DO:
                IF cotacao-item.ind-via-envio = 17 THEN
                    ASSIGN pl-env-pregao = YES.
                ELSE 
                    ASSIGN pl-env-pregao = NO.
            END.
            ELSE
                ASSIGN pl-env-pregao = NO.
        END.
    END.
    ELSE
        ASSIGN pl-env-pregao = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaMoedaPadrao DBOProgram 
PROCEDURE retornaMoedaPadrao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input  parameter pcod-emitente as int no-undo.
    define output parameter pi-moeda      as int no-undo.

    find first dist-emitente where
               dist-emitente.cod-emitente = pcod-emitente no-lock no-error.
    if  avail dist-emitente then
        assign pi-moeda = dist-emitente.mo-fatur.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RetornaOrdemPregao DBOProgram 
PROCEDURE RetornaOrdemPregao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM pi-numero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAM pl-ret-pregao AS LOG NO-UNDO.

    FIND FIRST ordem-compra NO-LOCK
         WHERE ordem-compra.numero-ordem = pi-numero-ordem NO-ERROR.
    IF AVAIL ordem-compra AND
             ordem-compra.situacao = 3 THEN DO:
        FIND FIRST cotacao-item NO-LOCK
            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
              AND cotacao-item.data-cotacao = ordem-compra.data-cotacao
              AND cotacao-item.cod-emitente = ordem-compra.cod-emitente NO-ERROR.
        IF AVAIL cotacao-item THEN DO:
            IF cotacao-item.ind-orig-entrada = 17 THEN
                ASSIGN pl-ret-pregao = YES.
            ELSE 
                ASSIGN pl-ret-pregao = NO.
        END.
        ELSE
            ASSIGN pl-ret-pregao = NO.
    END.
    ELSE
        ASSIGN pl-ret-pregao = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint10 DBOProgram 
PROCEDURE setConstraint10 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    &if defined(bf-mat-comex) &then             
    &else    
        def input parameter piNumOrdem  as int  no-undo.
        def input parameter pcCodComprado as char no-undo.

        run setConstraintItCodigo (piNumOrdem,
                                   pcCodComprado).
        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint11 DBOProgram 
PROCEDURE setConstraint11 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    &if defined(bf-mat-comex) &then             
    &else    
        def input param piNumOrdemIni   as int  no-undo.
        def input param piNumOrdemFim   as int  no-undo.
        def input param pcRowidItem     as char no-undo.

        run setConstraintNumeroOrdem   (piNumOrdemIni,
                                        piNumOrdemFim,
                                        pcRowidItem).

        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint12 DBOProgram 
PROCEDURE setConstraint12 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    &if defined(bf-mat-comex) &then             
    &else    
        def input param pcCodComprado     as char no-undo.
        def input param piNumOrdemIni     as int  no-undo.
        def input param piNumOrdemFim     as int  no-undo. 
        def input param pcCodEstabelIni   as char no-undo.
        def input param pcCodEstabelFim   as char no-undo.
        def input param pdaDataEmissaoIni as date no-undo.
        def input param pdaDataEmissaoFim as date no-undo.
        def input param pcItCodigoIni     as char no-undo.
        def input param pcItCodigoFim     as char no-undo.

        run setConstraintFiltroOrdensPendCompr (pcCodComprado,
                                                piNumOrdemIni,
                                                piNumOrdemFim,
                                                pcCodEstabelIni,
                                                pcCodEstabelFim,
                                                pdaDataEmissaoIni,
                                                pdaDataEmissaoFim,
                                                pcItCodigoIni,
                                                pcItCodigoFim).
        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint13 DBOProgram 
PROCEDURE setConstraint13 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    &if defined(bf-mat-comex) &then             
    &else    
        def input parameter pcCodGrpCompra as char no-undo.
        def input parameter piNumOrdemIni  as int  no-undo.
        def input parameter piNumOrdemFim  as int  no-undo.
        def input parameter pcItCodigoIni  as char no-undo.
        def input parameter pcItCodigoFim  as char no-undo.
        def input parameter pdaDataIni     as date no-undo.
        def input parameter pdaDataFim     as date no-undo.
        def input parameter pcRequisIni    as char no-undo.
        def input parameter pcRequisFim    as char no-undo.

        run setConstraintFiltroOrdensGrpCompra (pcCodGrpCompra,
                                                piNumOrdemIni,
                                                piNumOrdemFim,
                                                pcItCodigoIni,
                                                pcItCodigoFim,
                                                pdaDataIni,
                                                pdaDataFim,
                                                pcRequisIni,
                                                pcRequisFim).

        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint14 DBOProgram 
PROCEDURE setConstraint14 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    &if defined(bf-mat-comex) &then             
    &else    
        def input parameter pcCodComprado as char no-undo.
        def input parameter piNumOrdemIni as int  no-undo.
        def input parameter piNumOrdemFim as int  no-undo.
        def input parameter pcItCodigoIni as char no-undo.
        def input parameter pcItCodigoFim as char no-undo.
        def input parameter pdaDataIni    as date no-undo.
        def input parameter pdaDataFim    as date no-undo.
        def input parameter pcRequisIni   as char no-undo.
        def input parameter pcRequisFim   as char no-undo.

        run setConstraintCodComprado (pcCodComprado,
                                      piNumOrdemIni,
                                      piNumOrdemFim,
                                      pcItCodigoIni,
                                      pcItCodigoFim,
                                      pdaDataIni,
                                      pdaDataFim,
                                      pcRequisIni,
                                      pcRequisFim).
        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint15 DBOProgram 
PROCEDURE setConstraint15 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    &if defined(bf-mat-comex) &then             
    &else    
        def input param pcCodComprado as char no-undo.
        def input param piNumOrdemIni as int  no-undo.
        def input param piNumOrdemFim as int  no-undo.
        def input param pcItCodigoIni as char no-undo.
        def input param pcItCodigoFim as char no-undo.

        run setConstraintFiltroPedidosOrdens (pcCodComprado,
                                              piNumOrdemIni,
                                              piNumOrdemFim,
                                              pcItCodigoIni,
                                              pcItCodigoFim).

       RETURN "OK":U.          
   &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint16 DBOProgram 
PROCEDURE setConstraint16 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    &if defined(bf-mat-comex) &then             
    &else    
        def input param piNumPedido as int no-undo.

        run setConstraintManutOrdensPedido (piNumPedido).

        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint17 DBOProgram 
PROCEDURE setConstraint17 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    &if defined(bf-mat-comex) &then             
    &else    
        def input param prPedidoCompr as rowid no-undo.

        run setConstraintOFPedidoCompr (prPedidoCompr).

        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint19 DBOProgram 
PROCEDURE setConstraint19 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    &if defined(bf-mat-comex) &then             
    &else    
        def input param piNumOrdemIni    as int  no-undo.
        def input param piNumOrdemFim    as int  no-undo.
        def input param pcItCodigoIni    as char no-undo.
        def input param pcItCodigoFim    as char no-undo.
        def input param pdaDataIni       as date no-undo.
        def input param pdaDataFim       as date no-undo.
        def input param pcCodCompradoIni as char no-undo. 
        def input param pcCodCompradoFim as char no-undo.

         run setConstraintSelecaoSolicOrdem(piNumOrdemIni,
                                            piNumOrdemFim,
                                            pcItCodigoIni,
                                            pcItCodigoFim ,
                                            pdaDataIni ,
                                            pdaDataFim ,
                                            pcCodCompradoIni, 
                                            pcCodCompradoFim).  
        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint20 DBOProgram 
PROCEDURE setConstraint20 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */


    &if defined(bf-mat-comex) &then             
    &else    
        def input param piNumOrdemIni   as int  no-undo.
        def input param piNumOrdemFim   as int  no-undo.
        def input param pcItCodigoIni   as char no-undo.
        def input param pcItCodigoFim   as char no-undo.
        def input param pcEstabelIni    as char no-undo. 
        def input param pcEstabelFim    as char no-undo.  
        def input param plConfirmada    as log  no-undo.
        def input param plNaoConfirmada as log  no-undo.
        def input param plCotacao       as log  no-undo.
        def input param plEmCotacao     as log  no-undo.
        def input param plRecebida      as log  no-undo.
        def input param plEliminada     as log  no-undo.
        def input param plEmitenteIni   as int  no-undo. /* p/ perfil do usuario */
        def input param plEmitenteFim   as int  no-undo. /* p/ perfil do usuario */

        run setConstraintPesquisaOrdem (piNumOrdemIni,
                                        piNumOrdemFim,
                                        pcItCodigoIni,
                                        pcItCodigoFim, 
                                        pcEstabelIni, 
                                        pcEstabelFim,
                                        plConfirmada,
                                        plNaoConfirmada,
                                        plCotacao,
                                        plEmCotacao,
                                        plRecebida,
                                        plEliminada,
                                        plEmitenteIni,
                                        plEmitenteFim).

        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint21 DBOProgram 
PROCEDURE setConstraint21 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    &if defined(bf-mat-comex) &then             
    &else    
        def input parameter prItem     as rowid no-undo.
        def input parameter plCompra   as log   no-undo.
        def input parameter plServico  as log   no-undo.
        def input parameter plBenefic  as log   no-undo.
        def input parameter pdaDataIni as date  no-undo.
        def input parameter pdaDataFim as date  no-undo.

        run setConstraintParamComprasItem (prItem, 
                                           plCompra,
                                           plServico,
                                           plBenefic,
                                           pdaDataIni,
                                           pdaDataFim).

        RETURN "U":U.
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint4 DBOProgram 
PROCEDURE setConstraint4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    &if defined(bf-mat-comex) &then             
    &else    
        def input parameter piEmitente as int no-undo.

        run setConstraintPerfilUsuar (piEmitente).

        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint5 DBOProgram 
PROCEDURE setConstraint5 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    &if defined(bf-mat-comex) &then             
    &else    
        def input parameter piEmitente as int no-undo.
        def input parameter piNumOrdem as int no-undo.

        run setConstraintPerfilUsuar (piEmitente).
        run setConstraintNumeroOrdem (piNumOrdem,
                                      piNumOrdem,
                                      ?).

        RETURN "OK":U.        
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint6 DBOProgram 
PROCEDURE setConstraint6 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    &if defined(bf-mat-comex) &then             
    &else    
        def input parameter pNrProcesso as int no-undo.

        run setConstraintNrProcesso (input pNrProcesso).

        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodComprado DBOProgram 
PROCEDURE setConstraintCodComprado :
/*------------------------------------------------------------------------------
  Purpose: Carrega vari†veis para openQueryCodComprado .
  Parameters:
            ipar1 : pcCodComprado : C¢digo do comprador
            ipar2 : piNumOrdemIni : N£mero da ordem inicial 
            ipar3 : piNumOrdemFim : N£mero da ordem final
            ipar4 : pcItCodigoIni : C¢digo do item inicial 
            ipar5 : pcItCodigoFim : C¢digo do item final
            ipar6 : pdaDataIni    : Data de emiss∆o inicial
            ipar7 : pdaDataFim    : Data de emiss∆o final
            ipar8 : pcRequisIni   : Requisitante inicial
            ipar9 : pcRequisFim   : Requisitante final
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else    
        def input parameter pcCodComprado as char no-undo.
        def input parameter piNumOrdemIni as int  no-undo.
        def input parameter piNumOrdemFim as int  no-undo.
        def input parameter pcItCodigoIni as char no-undo.
        def input parameter pcItCodigoFim as char no-undo.
        def input parameter pdaDataIni    as date no-undo.
        def input parameter pdaDataFim    as date no-undo.
        def input parameter pcRequisIni   as char no-undo.
        def input parameter pcRequisFim   as char no-undo.

        assign iNumOrdemIni = piNumOrdemIni
               iNumOrdemFim = piNumOrdemFim
               cItCodigoIni = pcItCodigoIni
               cItCodigoFim = pcItCodigoFim
               daDataIni    = pdaDataIni
               daDataFim    = pdaDataFim
               cRequisIni   = pcRequisIni
               cRequisFim   = pcRequisFim
               cCodComprado = pcCodComprado.

        RETURN "OK":U.
    &endif               
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroOrdensGrpCompra DBOProgram 
PROCEDURE setConstraintFiltroOrdensGrpCompra :
/*------------------------------------------------------------------------------
  Purpose: Carrega vari†veis para openQueryFiltroOrdensGrpCompra .
  Parameters:
            ipar1 : pcCodGrpCompra: C¢digo do grupo de compra
            ipar2 : piNumOrdemIni : N£mero da ordem inicial 
            ipar3 : piNumOrdemFim : N£mero da ordem final
            ipar4 : pcItCodigoIni : C¢digo do item inicial 
            ipar5 : pcItCodigoFim : C¢digo do item final
            ipar6 : pdaDataIni    : Data de emiss∆o inicial
            ipar7 : pdaDataFim    : Data de emiss∆o final
            ipar8 : pcRequisIni   : Requisitante inicial
            ipar9 : pcRequisFim   : Requisitante final 
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else    
        def input parameter pcCodGrpCompra as char no-undo.
        def input parameter piNumOrdemIni  as int  no-undo.
        def input parameter piNumOrdemFim  as int  no-undo.
        def input parameter pcItCodigoIni  as char no-undo.
        def input parameter pcItCodigoFim  as char no-undo.
        def input parameter pdaDataIni     as date no-undo.
        def input parameter pdaDataFim     as date no-undo.
        def input parameter pcRequisIni    as char no-undo.
        def input parameter pcRequisFim    as char no-undo.   

         assign iNumOrdemIni  = piNumOrdemIni
                iNumOrdemFim  = piNumOrdemFim
                cItCodigoIni  = pcItCodigoIni
                cItCodigoFim  = pcItCodigoFim
                daDataIni     = pdaDataIni
                daDataFim     = pdaDataFim
                cRequisIni    = pcRequisIni
                cRequisFim    = pcRequisFim
                cCodGrpCompra = pcCodGrpCompra.

        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroOrdensPendCompr DBOProgram 
PROCEDURE setConstraintFiltroOrdensPendCompr :
/*------------------------------------------------------------------------------
  Purpose:  Carrega vari†veis para openQueryFiltroOrdensPendCompr .

  ParÉmetros:
            ipar1 : pcCodComprado       : C¢digo do comprador
            ipar2 : piNumOrdemIni       : N£mero da ordem inicial 
            ipar3 : piNumOrdemFim       : N£mero da ordem final
            ipar4 : pcCodEstabelIni     : C¢digo do estabelecimento inicial
            ipar5 : pcCodEstabelFim     : C¢digo do estabelecimento final
            ipar6 : pdaDataEmissaoIni   : Data de emiss∆o inicial
            ipar7 : pdaDataEmissaoFim   : Data de emiss∆o final
            ipar8 : pcItCodigoIni       : C¢digo do item inicial 
            ipar9 : pcItCodigoFim       : C¢digo do item final

  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else    
        def input param pcCodComprado     as char no-undo.
        def input param piNumOrdemIni     as int  no-undo.
        def input param piNumOrdemFim     as int  no-undo. 
        def input param pcCodEstabelIni   as char no-undo.
        def input param pcCodEstabelFim   as char no-undo.
        def input param pdaDataEmissaoIni as date no-undo.
        def input param pdaDataEmissaoFim as date no-undo.
        def input param pcItCodigoIni     as char no-undo.
        def input param pcItCodigoFim     as char no-undo.

        assign cCodComprado     = pcCodComprado
               iNumOrdemIni     = piNumOrdemIni
               iNumOrdemFim     = piNumOrdemFim
               cCodEstabelIni   = pcCodEstabelIni
               cCodEstabelFim   = pcCodEstabelFim
               daDataEmissaoIni = pdaDataEmissaoIni
               daDataEmissaoFim = pdaDataEmissaoFim
               cItCodigoIni     = pcItCodigoIni
               cItCodigoFim     = pcItCodigoFim.

        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroPedidosOrdens DBOProgram 
PROCEDURE setConstraintFiltroPedidosOrdens :
/*------------------------------------------------------------------------------
  Purpose:   Carrega vari†veis para openQueryFiltroPedidosOrdens, e passando 
             o primeiro e o £ltimo parÉmetro em branco ser† utilizado para 
             carregar vari†veis para o openQueryZoomOrdemCotacaoItem .
  Parameters:
           ipar1 : pcCodComprado        : C¢digo do comprador
           ipar2 : piNumOrdemIni        : N£mero da ordem inicial 
           ipar3 : piNumOrdemFim        : N£mero da ordem final
           ipar4 : pcItCodigoIni        : C¢digo do item  inicial
           ipar5 : pcItCodigoFim        : C¢digo do item final


  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then             
    &else    
        def input param pcCodComprado as char no-undo.
        def input param piNumOrdemIni as int  no-undo.
        def input param piNumOrdemFim as int  no-undo.
        def input param pcItCodigoIni as char no-undo.
        def input param pcItCodigoFim as char no-undo.

        assign cCodComprado  = pcCodComprado
               iNumOrdemIni  = piNumOrdemIni
               iNumOrdemFim  = piNumOrdemFim
               cItCodigoIni  = pcItCodigoIni
               cItCodigoFim  = pcItCodigoFim.

        RETURN "OK":U.             
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItCodigo DBOProgram 
PROCEDURE setConstraintItCodigo :
/*------------------------------------------------------------------------------
  Purpose:   Carrega vari†veis para openQueryItCodigo .
  Parameters: 
            ipar1 : piNumOrdem    : N£mero da ordem 
            ipar2 : pcCodComprado : C¢digo do comprador
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else    
        def input parameter piNumOrdem    as int  no-undo.
        def input parameter pcCodComprado as char no-undo.

        assign iNumOrdem     = piNumOrdem
               cCodComprado  = pcCodComprado.

        for first ordem-compra fields (numero-ordem it-codigo) where
             ordem-compra.numero-ordem = iNumOrdem
             no-lock: end.
        assign cItCodigo = if avail ordem-compra then
                                    ordem-compra.it-codigo
                                    else ?.

        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintmain DBOProgram 
PROCEDURE setconstraintmain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintManutOrdensPedido DBOProgram 
PROCEDURE setConstraintManutOrdensPedido :
/*------------------------------------------------------------------------------
  Purpose: Carrega vari†veis para openQueryManutOrdensPedido .
  Parameters: 
             ipar1 : piNumPedido : N£mero do pedido 
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else    
        def input param piNumPedido as int no-undo.

        assign iNumPedido = piNumPedido.

        RETURN "OK":U.    
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNrProcesso DBOProgram 
PROCEDURE setConstraintNrProcesso :
/*------------------------------------------------------------------------------
  Purpose:  Carrega vari†veis para openQueryNrProcesso .
  Parameters: 
             ipar1 : piNrProcesso : N£mero do processo 
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else    
        def input parameter pNrProcesso as int no-undo.

        assign iNrProcesso = pNrProcesso.

        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNumeroOrdem DBOProgram 
PROCEDURE setConstraintNumeroOrdem :
/*------------------------------------------------------------------------------
  Purpose:  Carrega vari†veis para openQueryByNumeroOrdem .
  Parameters: 
            ipar1 : piNumOrdemIni : N£mero da ordem inicial 
            ipar2 : piNumOrdemFim : N£mero da ordem final
            ipar3 : prRowidItem   : Rowid do item  
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then             
    &else    
        def input param piNumOrdemIni   as int   no-undo.
        def input param piNumOrdemFim   as int   no-undo.
        def input param prRowidItem     as rowid no-undo.

        assign iNumOrdemIni = piNumOrdemIni
               iNumOrdemFim = piNumOrdemFim.

        for first item fields(it-codigo) where 
            rowid(item) = prRowidItem no-lock: end.
        if avail item then cItCodigo = item.it-codigo.

        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNumPedido DBOProgram 
PROCEDURE setConstraintNumPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*Par∆metros:
           ipar1  : piNumOrdem : Numero da ordem corrente da interface.
*/

    &if defined(bf-mat-comex) &then    
    &else
        def input param piNumPedido as int no-undo.

        assign iNumPed = piNumPedido.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOFPedidoCompr DBOProgram 
PROCEDURE setConstraintOFPedidoCompr :
/*------------------------------------------------------------------------------
  Purpose: Carrega vari†veis para openQueryNumPedido e openQueryCodEmitente .
  Parameters: 
            ipar1 : prNumPedido : Rowid do pedido-compr 
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then             
    &else    
        def input param prPedidoCompr as rowid no-undo.

        assign rPedidoCompr = prPedidoCompr.

        find pedido-compr where
             rowid(pedido-compr) = rPedidoCompr 
             no-lock no-error.

        RETURN "OK":U.         
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOrdemPedido DBOProgram 
PROCEDURE setConstraintOrdemPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

        def input parameter p-i-num-pedido   as int   no-undo.
        def input parameter p-c-naocon       as char  no-undo.
        def input parameter p-c-cotada       as char  no-undo.
        def input parameter p-c-confir       as char  no-undo.
        def input parameter p-c-elimin       as char  no-undo.
        def input parameter p-c-em-cotacao   as char  no-undo.
        def input parameter p-c-termin       as char  no-undo.

        assign  iNumPedido     = p-i-num-pedido
                lNaoConfirmada = if p-c-naocon      = "yes" then YES else NO
                lConfirmada    = if p-c-confir      = "yes" then YES else NO
                lCotada        = if p-c-cotada      = "yes" then YES else NO
                lEliminada     = if p-c-elimin      = "yes" then YES else NO
                lEmCotacao     = if p-c-em-cotacao  = "yes" then YES else NO
                lTermin        = if p-c-termin      = "yes" then YES else NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOrdemServic DBOProgram 
PROCEDURE setConstraintOrdemServic :
/*------------------------------------------------------------------------------
  Purpose: Carrega vari†veis para openQueryOrdemServic.
  Parameters: ipar1 : piOrdemServic : N£mero da Ordem Serviáo
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then             
    &else    
        def input parameter piOrdemServic as int no-undo.

        assign iOrdemServic = piOrdemServic. 

        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintParamComprasItem DBOProgram 
PROCEDURE setConstraintParamComprasItem :
/*------------------------------------------------------------------------------
  Purpose:  Carrega vari†veis para openQueryParamComprasItem.
  Parameters:  
            ipar1 : prItem     : Rowid do item 
            ipar2 : plCompra   : Indica a natureza de compra
            ipar3 : plServico  : Indica a natureza de compra
            ipar4 : plBenefic  : Indica a natureza de compra
            ipar5 : pdaDataIni : Data de emiss∆o inicial
            ipar6 : pdaDataFim : Data de emiss∆o final  
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else    
        def input parameter prItem     as rowid no-undo.
        def input parameter plCompra   as log   no-undo.
        def input parameter plServico  as log   no-undo.
        def input parameter plBenefic  as log   no-undo.
        def input parameter pdaDataIni as date  no-undo.
        def input parameter pdaDataFim as date  no-undo.

        assign lCompra   = plCompra
               lServico  = plServico
               lBenefic  = plBenefic
               daDataIni = pdaDataIni
               daDataFim = pdaDataFim.

        for first item fields(it-codigo) where 
             rowid(item) = prItem no-lock: end.
        if avail item then
           assign cItCodigo = item.it-codigo.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPerfilUsuar DBOProgram 
PROCEDURE setConstraintPerfilUsuar :
/*------------------------------------------------------------------------------
  Purpose: Carrega vari†veis para openQueryPerfilUsuarByItCodigo e openQueryPerfilUsuarByINrOrdem.
  Parameters:  <none>
            ipar1 : piEmitente : C¢digo do emitente

  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then             
    &else    
        def input parameter piEmitente as int no-undo.

        assign iEmitente = piEmitente. 

        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPesquisaOrdem DBOProgram 
PROCEDURE setConstraintPesquisaOrdem :
/*------------------------------------------------------------------------------
  Purpose: Carrega vari†veis para openQueryPesquisaByItCodigo e openQueryPesquisaByNumeroOrdem.
  Parameters: 
            ipar1 : piNumOrdemIni   : N£mero da ordem inicial
            ipar2 : piNumOrdemFim   : N£mero da ordem final
            ipar3 : pcItCodigoIni   : C¢digo do item inicial
            ipar4 : pcItCodigoFim   : C¢digo do item final
            ipar5 : pcEstabelIni    : C¢digo do estabelecimento inicial
            ipar6 : pcEstabelFim    : C¢digo do estabelecimento final
            ipar7 : plConfirmada         : Indica situaá∆o da ordem
            ipar8 : plNaoConfirmada      : Indica situaá∆o da ordem
            ipar9 : plCotacao            : Indica situaá∆o da ordem
            ipar10: plEmCotacao          : Indica situaá∆o da ordem
            ipar11: plRecebida           : Indica situaá∆o da ordem
            ipar13: plEliminada          : Indica situaá∆o da ordem
            ipar14: plEmitenteIni        : C¢digo do emitente inicial
            ipar15: plEmitenteFim        : C¢digo do emitente final
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then             
    &else    
        def input param piNumOrdemIni   as int  no-undo.
        def input param piNumOrdemFim   as int  no-undo.
        def input param pcItCodigoIni   as char no-undo.
        def input param pcItCodigoFim   as char no-undo.
        def input param pcEstabelIni    as char no-undo. 
        def input param pcEstabelFim    as char no-undo.  
        def input param plConfirmada    as log  no-undo.
        def input param plNaoConfirmada as log  no-undo.
        def input param plCotacao       as log  no-undo.
        def input param plEmCotacao     as log  no-undo.
        def input param plRecebida      as log  no-undo.
        def input param plEliminada     as log  no-undo.
        def input param plEmitenteIni   as int  no-undo. /* p/ perfil do usuario */
        def input param plEmitenteFim   as int  no-undo. /* p/ perfil do usuario */

        assign iNumOrdemIni   = piNumOrdemIni
               iNumOrdemFim   = piNumOrdemFim
               cItCodigoIni   = pcItCodigoIni
               cItCodigoFim   = pcItCodigoFim 
               cCodEstabelIni = pcEstabelIni 
               cCodEstabelFim = pcEstabelFim
               lConfirmada    = plConfirmada
               lNaoConfirmada = plNaoConfirmada
               lCotacao       = plCotacao
               lEmCotacao     = plEmCotacao
               lRecebida      = plRecebida
               lEliminada     = plEliminada
               iEmitenteIni   = plEmitenteIni
               iEmitenteFim   = plEmitenteFim
               .  

        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRelacionamento DBOProgram 
PROCEDURE setConstraintRelacionamento :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then             
    &else    
        def input parameter piEmit        as int  no-undo.
        def input parameter piNatureza    as int  no-undo.
        def input parameter piCodCondPag  as int  no-undo.
        def input parameter piNrProcesso  as int  no-undo.
        def input parameter piCodTransp   as int  no-undo.
        def input parameter piNumOrdemIni as int  no-undo.
        def input parameter piNumOrdemFim as int  no-undo.

        assign 
        iEmitente    = piEmit 
        iNatureza    = piNatureza
        iCodCondPag  = piCodCondPag
        iNrProcesso  = piNrProcesso
        iCodTransp   = piCodTransp
        iNumOrdemIni = piNumOrdemIni
        iNumOrdemFim = piNumOrdemFim.

        RETURN "OK":U.
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintSelecaoSolicOrdem DBOProgram 
PROCEDURE setConstraintSelecaoSolicOrdem :
/*------------------------------------------------------------------------------
  Purpose:   Carrega vari†veis para openQuerySelecaoSolicOrdem.
  Parameters:
            ipar1 : piNumOrdemIni    : N£mero da ordem inicial
            ipar2 : piNumOrdemFim    : N£mero da ordem final
            ipar3 : pcItCodigoIni    : C¢digo do item inicial
            ipar4 : pcItCodigoFim    : C¢digo do item final
            ipar5 : pdaDataIni       : Data de emiss∆o inicial
            ipar6 : pdaDataFim       : Data de emiss∆o final
            ipar7 : pcCodCompradoIni : C¢digo do comprador inicial
            ipar8 : pcCodCompradoFim : C¢digo do comprador final
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then             
    &else    
        def input param piNumOrdemIni    as int  no-undo.
        def input param piNumOrdemFim    as int  no-undo.
        def input param pcItCodigoIni    as char no-undo.
        def input param pcItCodigoFim    as char no-undo.
        def input param pdaDataIni       as date no-undo.
        def input param pdaDataFim       as date no-undo.
        def input param pcCodCompradoIni as char no-undo. 
        def input param pcCodCompradoFim as char no-undo.

            assign iNumOrdemIni     = piNumOrdemIni
                   iNumOrdemFim     = piNumOrdemFim
                   cItCodigoIni     = pcItCodigoIni
                   cItCodigoFim     = pcItCodigoFim 
                   daDataIni        = pdaDataIni 
                   daDataFim        = pdaDataFim 
                   cCodCompradoIni = pcCodCompradoIni 
                   cCodCompradoFim = pcCodCompradoFim.  

        RETURN "OK":U.
    &endif               
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateLocalEntrega DBOProgram 
PROCEDURE validateLocalEntrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------------------------*/
    def input-output param table for RowObject.
    def input param p-nome-abrev like emitente.nome-abrev no-undo.
    def input param p-l-cad-ped-pend as log               no-undo.
    FIND FIRST param-global NO-LOCK NO-ERROR.
    FIND FIRST para-ped     NO-LOCK NO-ERROR.
    /*** Drop Shipment ***/
    &IF "{&BF_MAT_VERSAO_EMS}" >= "2.042" &THEN
        assign l-controla-drop-ship = no.
        
        &if  defined(bf_mat_custeio_item) &then
             assign l-controla-drop-ship = yes.
        &endif

        if l-controla-drop-ship then do:
            find first RowObject no-error.
        
            if  not avail RowObject then
                return "NOK":U.
        
            find first estabelec no-lock 
                 where estabelec.cod-estabel = rowObject.cod-estabel no-error.
            if avail estabelec and rowObject.num-ord-inv > 0 AND param-global.modulo-in then do:
                 run inp/in2112a.p (input estabelec.ep-codigo,
                                    input rowObject.num-ord-inv,
                                    output c-descricao,
                                    output l-achou,
                                    output c-ct-codigo,
                                    output c-sc-codigo).

                 if l-achou = no then
                   /* Inicio -- Projeto Internacional */
                   DO:
                   DEFINE VARIABLE c-lbl-liter-ordem-de-investimento AS CHARACTER NO-UNDO.
                   {utp/ut-liter.i "Ordem_de_Investimento" *}
                   ASSIGN c-lbl-liter-ordem-de-investimento = TRIM(RETURN-VALUE).
                   {method/svc/errors/inserr.i
                                      &ErrorNumber="56"
                                      &ErrorType="EMS"
                                      &ErrorSubType="ERROR" 
                                      &ErrorParameters="c-lbl-liter-ordem-de-investimento"}
                   END. 
            end.
        end.

        /*** Drop Shipment ***/
        &IF "{&BF_MAT_VERSAO_EMS}" >= "2.05" &THEN
            /** Verifica se o usu†rio logado est† configurada para pa°s diferente de Brasil. **/
            run ccp/ccapi035.p (output l-ind-drop-shipment).
            assign l-controla-drop-ship = l-ind-drop-shipment.
        &ENDIF
        
        if  l-controla-drop-ship then do:
            if  RowObject.local-entrega = 1 /* estabelecimento entrega */
            then do:
                 /*--- Quando for parametrizado para buscar o local de entrega 
                       do estabelecimento de entrega, serao zerados os campos de
                       endereco de entrega do pedido de compra ---*/
                 assign RowObject.cod-entrega   = ""
                        RowObject.nr-pedcli     = ""
                        RowObject.seq-ped-venda = 0
                        RowObject.int-2         = 0.
        
                if  not can-find(first estabelec 
                                 where estabelec.cod-estabel = RowObject.estab-entrega no-lock) then do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-estabelecimento-entrega AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Estabelecimento_Entrega" *}
                    ASSIGN c-lbl-liter-estabelecimento-entrega = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i &ErrorNumber="2" /* n∆o encontrado estabelecimento entrega para a chave informada */
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="c-lbl-liter-estabelecimento-entrega"}
                end.
        
            end.
            else if RowObject.local-entrega = 2 /* emitente */ then do:
        
                assign RowObject.estab-entrega = "".
        
                IF  rowObject.int-2 = 0 THEN
                    ASSIGN p-nome-abrev = "".
        
                if  p-nome-abrev <> "" then
                    if can-find(first emitente 
                                where emitente.nome-abrev = p-nome-abrev 
                                  and emitente.identific  = 2 no-lock) then do:
                        {method/svc/errors/inserr.i &ErrorNumber="895"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U
                                                    &ErrorParameters="' '"} 
                     end.
        
                if  RowObject.nr-pedcli <> "" 
                and RowObject.nr-pedcli <> "0" then do:
        
                    find first ped-venda 
                         where ped-venda.nome-abrev = p-nome-abrev 
                           and ped-venda.nr-pedcli  = rowObject.nr-pedcli no-lock no-error.
        
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
                        
                        /* Pedido n∆o aprovado no WF de desconto */
                        IF  para-ped.log-usa-aprovac-workflow 
                        AND ped-venda.log-aprov-workflow = NO THEN DO:
                            {method/svc/errors/inserr.i
                                        &ErrorNumber="52327"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=" ped-venda.nr-pedcli + '~~~~' + ped-venda.nome-abrev"}
                        END. 

                        if  ped-venda.cod-sit-ped = 2 then do:
                                {method/svc/errors/inserr.i &ErrorNumber="6271"
                                                            &ErrorType="EMS":U
                                                            &ErrorSubType="ERROR":U} 
        
                        end.
                        if  ped-venda.cod-sit-ped = 3 and 
                            not p-l-cad-ped-pend then do:
                                /* No UIB - erro 1363 */
                                {method/svc/errors/inserr.i &ErrorNumber="18338"
                                                            &ErrorType="EMS":U
                                                            &ErrorSubType="ERROR":U}                               
                        end.
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
                        where ped-item.nome-abrev = p-nome-abrev and
                              ped-item.nr-pedcli = rowObject.nr-pedcli  and
                              ped-item.nr-sequencia = rowObject.seq-ped-venda no-lock: end.
                    if not avail ped-item then do:
                            {method/svc/errors/inserr.i &ErrorNumber="6269"
                                                        &ErrorType="EMS":U
                                                        &ErrorSubType="ERROR":U}  
                    end. 
                end.    
        
                if  RowObject.cod-entrega <> "" then do:
        
                    if  not can-find(first loc-entr 
                                     where loc-entr.cod-entrega = RowObject.cod-entrega
                                       and loc-entr.nome-abrev =  p-nome-abrev no-lock) then do:
                            /* Inicio -- Projeto Internacional */
                            DEFINE VARIABLE c-lbl-liter-local-entrega AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "Local_Entrega" *}
                            ASSIGN c-lbl-liter-local-entrega = TRIM(RETURN-VALUE).
                            {method/svc/errors/inserr.i &ErrorNumber="2" /* n∆o encontrado local entrega para a chave informada */
                                                        &ErrorType="EMS":U
                                                        &ErrorSubType="ERROR":U
                                                        &ErrorParameters="c-lbl-liter-local-entrega"}
                    end.
        
                    for first pedido-compr fields(cod-emit-terc)
                        where pedido-compr.num-pedido = RowObject.num-pedido no-lock: end.
        
                    if  avail pedido-compr
                    and not can-find(first emitente 
                                     where emitente.cod-emitente = RowObject.int-2 no-lock) then do:
                            /* Inicio -- Projeto Internacional */
                            DEFINE VARIABLE c-lbl-liter-emitente-entrega AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "Emitente_Entrega" *}
                            ASSIGN c-lbl-liter-emitente-entrega = TRIM(RETURN-VALUE).
                            {method/svc/errors/inserr.i &ErrorNumber="2" /* n∆o encontrado emitente entrega para a chave informada */
                                                        &ErrorType="EMS":U
                                                        &ErrorSubType="ERROR":U
                                                        &ErrorParameters="c-lbl-liter-emitente-entrega"}
                    end.
                end.
        
                if  RowObject.num-pedido > 0 then do:
        
                    /* Quando o local de entrega do pedido for 'Estabelec' e o da Ordem for 'Emitente'
                       devem ser preenchidas as informacoes referentes ao Local de Entrega */
                    if  can-find(first pedido-compr
                                 where pedido-compr.num-pedido = RowObject.num-pedido
                                   and pedido-compr.local-entrega = 1 /* Estabelec */ no-lock)
                    then do:
                        if  (   RowObject.cod-entrega = ""
                             or RowObject.cod-entrega = "0")
                        and (   RowObject.nr-pedcli = "" 
                             or RowObject.nr-pedcli = "0") then do:
                            {method/svc/errors/inserr.i &ErrorNumber="26380" /* Deve ser informado Pedido ou Local de Entrega */
                                                        &ErrorType="EMS":U
                                                        &ErrorSubType="ERROR":U}        
                        end.
                    end.
                end.                
            end.
        end.
    &endif

    return (if  can-find(first RowErrors
                         where RowErrors.ErrorSubType = "Error":U) then "NOK":U
           else "OK":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaRelacEmbarque DBOProgram 
PROCEDURE validaRelacEmbarque :
/*------------------------------------------------------------------------------
  Notes: Verifica se a ordem est† relacionada a um embarque.
------------------------------------------------------------------------------*/
    def input param nr-ordem-compra like ordem-compra.numero-ordem no-undo.
    DEF VAR c-label-tabela   AS CHAR   NO-UNDO.
    DEF VAR c-label-relac    AS CHAR   NO-UNDO.
    DEF VAR c-label-estab    AS CHAR   NO-UNDO.
    DEF VAR c-label-embarque AS CHAR   NO-UNDO.
    DEF VAR c-params         AS CHAR   NO-UNDO.
    DEF VAR c-return         AS CHAR   NO-UNDO.
    DEF VAR h-bocx225        AS HANDLE NO-UNDO.
    DEF VAR c-estabel        AS CHAR   NO-UNDO.
    DEF VAR c-embarque       AS CHAR   NO-UNDO.
    
    {utp/ut-liter.i Ordem_de_Compra * L}
        ASSIGN c-label-tabela = RETURN-VALUE.
    {utp/ut-liter.i Ordens_Embarque * L}
        ASSIGN c-label-relac = RETURN-VALUE.
    {utp/ut-liter.i Estabelecimento * L}
        ASSIGN c-label-estab = RETURN-VALUE.
    {utp/ut-liter.i Embarque * L}
        ASSIGN c-label-embarque = RETURN-VALUE.

    FIND FIRST param-global NO-LOCK NO-ERROR.
    IF param-global.modulo-07 AND CONNECTED("mgcex":U) THEN DO:
    
        RUN cxbo/bocx225.p PERSISTENT SET h-bocx225.   
        RUN findOrdensEmbarque IN h-bocx225 (INPUT  nr-ordem-compra,
                                             OUTPUT c-return).

        IF c-return = "" THEN DO:

            RUN getCharField IN h-bocx225 (INPUT "cod-estabel",
                                           OUTPUT c-estabel).
    
            RUN getCharField IN h-bocx225 (INPUT "embarque",
                                           OUTPUT c-embarque).
            
            ASSIGN c-params = " (" + c-label-estab + " " + c-estabel + " " + c-label-embarque + " " + c-embarque + ")".

            {method/svc/errors/inserr.i &ErrorNumber="5"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=" c-label-tabela + '~~~~' + c-label-relac + c-params"}
        END.
    
        IF  VALID-HANDLE( h-bocx225 ) THEN 
                DELETE PROCEDURE h-bocx225.
    END.
    
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
    &if defined(bf-mat-comex) &then             
    &else    
        DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

        assign c-pType = pType.

        /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
              executadas ---*/
        /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
        /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do
              include: method/svc/errors/inserr.i ---*/
        /*--- Inclua aqui as validaá‰es ---*/
        
        RUN ccp/ccPedidoCompraValidaIntegraMe.p PERSISTENT SET h-ccPedidoCompraValidaIntegraMe.
    
        RUN verifica-pedido-compra-me IN h-ccPedidoCompraValidaIntegraMe (INPUT RowObject.num-pedido, OUTPUT isOrderIntegrMe).
        
        IF pType = "Create":U then DO:
        
            IF isOrderIntegrMe THEN DO:
                {method/svc/errors/inserr.i
                                  &ErrorNumber="57880"
                                  &ErrorType="EMS"
                                  &ErrorSubType="ERROR"}

                RETURN "NOK":U.
            END.

           if can-find(ordem-compra where 
                       ordem-compra.numero-ordem = rowObject.numero-ordem) then do:
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-ordem-compra-3 AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Ordem_Compra" *}
               ASSIGN c-lbl-liter-ordem-compra-3 = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i
                                  &ErrorNumber="24"
                                  &ErrorType="EMS"
                                  &ErrorSubType="ERROR" 
                                  &ErrorParameters="c-lbl-liter-ordem-compra-3 + ' ' + string(rowObject.numero-ordem)"}
                /*-----------------------------------------------------------------*/
                /* Include i-epc200.i2: Criacao de registro para temp-table tt-epc */
                for each tt-epc where tt-epc.cod-event = "validateCreatePedEmerg":
                    delete tt-epc.
                end.
                {include/i-epc200.i2 &CodEvent='"validateCreatePedEmerg"'
                                     &CodParameter='"OBJECT-HANDLE"'
                                     &ValueParameter="string(this-procedure)"}
                /* Include i-epc201.i: Chamada do programa de EPC */
                {include/i-epc201.i "validateCreatePedEmerg"}

                if  return-value = "NOK":U then do:
                    return "NOK":U.
                end.
                /*-----------------------------------------------------------------*/
           end.
        END.
        
        IF pType = "Delete":U THEN DO:
            IF isOrderIntegrMe THEN DO:
                {method/svc/errors/inserr.i
                                  &ErrorNumber="57882"
                                  &ErrorType="EMS"
                                  &ErrorSubType="ERROR" 
                                  &ErrorParameters="string({&TableName}.numero-ordem)"}

                RETURN "NOK":U.
            END.              
        END.

        /*--- Verifica ocorrància de erros ---*/
        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
            RETURN "NOK":U.

        RETURN "OK":U.
    &endif
    
    FINALLY:
        DELETE PROCEDURE h-ccPedidoCompraValidaIntegraMe NO-ERROR.
        ASSIGN h-ccPedidoCompraValidaIntegraMe = ?.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram  
PROCEDURE openQueryDefault :
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.
                                      
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaContaCCExecOrc DBOProgram  
PROCEDURE buscaContaCCExecOrc :
/*------------------------------------------------------------------------------
  Purpose:    Busca Conta e Centro de Custo que est∆o na ordem antes da alteraá∆o
              para estorno no BGC 
  Parameters: pi-numero-ordem - N£mero da ordem de compra
              pc-ct-codigo    - Conta Cont†bil
              pc-sc-codigo    - Centro de custo
              pc-unid-netoc   - Unidade de Neg¢cio
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pi-numero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-ct-codigo    LIKE ordem-compra.ct-codigo    NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-sc-codigo    LIKE ordem-compra.sc-codigo    NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-unid-negoc   LIKE ordem-compra.cod-unid-negoc NO-UNDO.

    FOR FIRST bf{&TableName} 
        WHERE bf{&TableName}.numero-ordem = pi-numero-ordem NO-LOCK:
        ASSIGN pc-ct-codigo  = bf{&TableName}.ct-codigo
               pc-sc-codigo  = bf{&TableName}.sc-codigo
               pc-unid-negoc = bf{&TableName}.cod-unid-negoc.
    END.
                                      
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

