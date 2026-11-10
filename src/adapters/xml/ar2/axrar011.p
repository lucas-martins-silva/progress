/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXRAR011 2.00.00.006 } /*** 010006 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i axrar011 MUT}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : AXSRAR001.p
    Purpose     : RECEBIMENTO MOVIMENTO ESTOQUE

    Syntax      :

    Description : ADAPTER DE RECEBIMENTO MOVIMENTO DE ESTOQUE
    Author(s)   : Eliza Fernandes Corràa - log1465
    CREATED     : 17/02/2004 09:00
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .P file was CREATEd with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* **********************  Definitions  *********************** */

/* PrÇ-Processadores*/
&GLOBAL-DEFINE XmlProdName       EMS2
&GLOBAL-DEFINE XmlProdVersion    204
&GLOBAL-DEFINE XmlApp            AR2 
&GLOBAL-DEFINE XmlTranName       InventoryTransaction
&GLOBAL-DEFINE XmlMinTranVersion 204.000
&GLOBAL-DEFINE XmlMaxTranVersion 299.999
&GLOBAL-DEFINE XmlListOfAction   add

{cep/ceapi001k.i} /* Temp-table tt-movto */
DEF VAR h-ceapi001k AS HANDLE NO-UNDO.
{cdp/cd0666.i}   /* Temp-table tt-erro */
{cdp/cdcfgmat.i}

/* ---  Knupp - Retorno da mensagem dos Movtos de Estoque  --- */
DEFINE VARIABLE h-axnar001  AS HANDLE              NO-UNDO.
DEFINE VARIABLE i-TransactionNumberExternal AS INT NO-UNDO.
DEFINE VARIABLE l-ft2100                    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE level                       AS INTEGER    NO-UNDO.

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
     FIELD ttv_des_msg_ajuda AS CHARACTER INITIAL ?
     FIELD ttv_des_msg_erro  AS CHARACTER INITIAL ?
     FIELD ttv_num_cod_erro  AS INTEGER   INITIAL ?
.



DEF VAR hGenXml          AS HANDLE        NO-UNDO. 
DEF VAR hMessageHandler  AS HANDLE        NO-UNDO.
DEF VAR hBusinessContent AS HANDLE        NO-UNDO.
DEF VAR lSuccessProcess  AS LOG           NO-UNDO.
DEF VAR iCount           AS INT           NO-UNDO.
DEF VAR cReturnValue     AS CHAR          NO-UNDO.
DEF VAR cTranAction      AS CHAR          NO-UNDO.
DEF VAR cTranEvent       AS CHAR          NO-UNDO.
DEF VAR cTranVersion     AS CHAR          NO-UNDO.
DEF VAR cErrorText       AS CHAR          NO-UNDO.
DEF VAR iId              AS INT INITIAL ? NO-UNDO.
def var l-integracao-his as log           no-undo.
/* DEF. VARIµVEIS USADAS EM xmlLoadMessageHandlerRec.i */
{xmlinc/xmlloadmessagehandlerrecdef.i}

/* DEFINE AS VARAIVEIS PARA USO DO xmlLoadGenXmlRec.i */
{xmlinc/xmlloadgenxmlrecdef.i}


/* DEFINE AS VARIAVEIS PARA USO DO xmlgettranssubsinfo */
{xmlinc/xmlgettranssubsinfo.i}

DEFINE TEMP-TABLE ttStack NO-UNDO
     FIELD ttID AS INTEGER
     FIELD ttPos AS INTEGER
     INDEX tt_id IS PRIMARY UNIQUE
           ttID  ASCENDING.


FUNCTION addStack RETURN INTEGER (INPUT val AS INTEGER).
     DEFINE VAR id AS INTEGER INITIAL 1 NO-UNDO.
     FIND LAST ttStack NO-ERROR.
     IF AVAIL(ttStack) THEN
          id = ttStack.ttID + 1.

     CREATE ttStack.
     ASSIGN ttStack.ttID = id.
     ASSIGN ttStack.ttPos = val.
END FUNCTION.


FUNCTION delStack RETURN INTEGER.
     FIND LAST ttStack NO-ERROR.
     IF AVAIL(ttStack) THEN
          DELETE ttStack.

     FIND LAST ttStack NO-ERROR.
END FUNCTION.


FUNCTION getStack RETURN INTEGER.
     IF AVAIL(ttStack) THEN
          RETURN ttStack.ttPos.
     ELSE
          RETURN 0.
END FUNCTION.

PROCEDURE PIUpsert:

     /* OBTEM A PARTE DA MENSAGEM QUE ESTµ ABAIXO DO ELEMENTO BusinessContent */
     RUN getBusinessContent IN hMessageHandler (OUTPUT hBusinessContent).

     /* LIMPA AS TEMP-TABLES INTERNAS DA API XML */
     RUN reset IN hGenXml.

     /* CARREGA A ESTRUTURA FILHA DE BusinessContent */
     RUN loadXml IN hGenXml (hBusinessContent).

     /* ELIMINA A MENSAGEM OBTIDA NO MêTODO getBusinessContent */
     DELETE OBJECT hBusinessContent NO-ERROR.

     assign l-integracao-his = can-find(first funcao 
                                        where funcao.cd-funcao = "spp-integra-ems-his"
                                          and funcao.ativo).

     /* ********* LEITURA DA MENSAGEM - BEGIN ********* */
    /* Cria o registro na temp-table */
    addStack(1).
	FOR EACH  tt-movto:
		DELETE  tt-movto.
	END.
					
     RUN searchTag IN hGenXml (INPUT "ListOfInventoryTransaction", INPUT getStack(), OUTPUT iId).
          if (iId <> ?) THEN DO:
               addStack(iId).

                    RUN getFirstSonId IN hGenXml (INPUT getStack(), OUTPUT iId).

                    DO WHILE iId <> ?:
                    addStack(iId).
                    
                    CREATE tt-movto.
                         
                    RUN pi-cria-tt-movto.
                     
                   ASSIGN iId = getStack().
                   delStack().
                   RUN getNextSonId IN hGenXml (INPUT getStack(), INPUT iId, OUTPUT iId).
               END.     
             delStack().
          END.
          ELSE DO:
              CREATE tt-movto.
              RUN pi-cria-tt-movto.
          END.
     delStack().

     IF cTranAction = "add":U THEN DO:

        /* neste caso foi enviado um XML sem movimentos */
        /* tag <ListOfInventoryTransaction> vazia entao */
        /* deve criar ao menos uma tt-movto para        */
        /* retornar erro para o EAI                     */
        if not can-find(first tt-movto) then do: 
            create tt-movto.
            run pi-cria-tt-movto.
        end.

        &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
        
            if l-integracao-his then do:
                			
                RUN cep/ceapi304.p (INPUT-OUTPUT TABLE tt-movto,
                                    INPUT-OUTPUT TABLE tt-erro) NO-ERROR.

                IF ERROR-STATUS:ERROR THEN DO: /* Erros ocorridos durante execuá∆o do programa */
                    DO iCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
                       cErrorText = cErrorText + ERROR-STATUS:GET-MESSAGE(iCount).
                    END.
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-liter.i "Erro_de_integraá∆o._Erro_ao_executar_o_programa_'cep/ceapi304.p'_pelo_programa_adapters/xml/ar2/axrar001.p._Durante_sua_execuá∆o_ocorreu_o(s)_seguinte(s)_erro(s)_de_Progress" *}
                    RUN setError IN hMessageHandler (INPUT 0,
                                                     INPUT "enviroment_error":U,
                                                     INPUT RETURN-VALUE + ': ' + cErrorText).
                    CREATE tt_log_erro.
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-liter.i "Erro_de_integraá∆o._Erro_ao_executar_o_programa_'cep/ceapi304.p'_pelo_programa_adapters/xml/ar2/axrar001.p._Durante_sua_execuá∆o_ocorreu_o(s)_seguinte(s)_erro(s)_de_Progress" *}
                    ASSIGN tt_log_erro.ttv_num_cod_erro = 0
                           tt_log_erro.ttv_des_msg_erro = RETURN-VALUE + ': ' + cErrorText.
                END.
                ELSE DO: /* Erros ocorridos durante efetivaá∆o do registro */
                   FOR EACH tt-erro:
                        RUN setError IN hMessageHandler (INPUT tt-erro.cd-erro,
                                                         INPUT "business_error":U,  /* Erro de neg¢cio */
                           	                           INPUT tt-erro.mensagem).
                        CREATE tt_log_erro.
                        ASSIGN tt_log_erro.ttv_num_cod_erro = tt-erro.cd-erro
                               tt_log_erro.ttv_des_msg_erro = tt-erro.mensagem.
                   END.
                END.
            END.
        &ENDIF
    

        /* validaá∆o inclu°da */
        REPEAT WHILE PROGRAM-NAME(level) <> ?.
            IF  PROGRAM-NAME(level) matches("*ft2100*") OR 
                PROGRAM-NAME(level) matches("*ft2010*") THEN DO:
                ASSIGN l-ft2100 = YES.                        
                LEAVE.
            END.
            level = level + 1.
        END.
        
        IF NOT l-ft2100 THEN   /*validaá∆o inclu°da atÇ aqui */
           IF SEARCH("cep/ceapi001k.r":U) <> ? THEN DO:
    
                 DO TRANSACTION ON ERROR UNDO, RETRY:
                     /* Geracao de movimento de estoque */
                     /* RUN cep/ceapi001.p (INPUT-OUTPUT TABLE tt-movto,
                                         INPUT-OUTPUT TABLE tt-erro,
                                         INPUT YES) NO-ERROR. */
                                         
                      RUN cep/ceapi001k.p persistent set h-ceapi001k.
                      run pi-execute IN h-ceapi001k (input-output table tt-movto,
                                                     input-output table tt-erro,
                                                     input yes) no-error.
                                                   
                      if  valid-handle (h-ceapi001k) then do: 
                          delete procedure h-ceapi001k.
                          assign h-ceapi001k = ?.
                      end.                                         
                 END.
        
/* .alc : esta instrucao imprimira erros de find 
          executados pela api CEAPI001J que nao 
          tenham encontrado registros, mesmo que
          tenham sido utilizadas as clausulas
          "no-error", portanto deve ser retirada
                 IF ERROR-STATUS:ERROR THEN DO: /* Erros ocorridos durante execuªío do programa */
                     DO iCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
                        cErrorText = cErrorText + ERROR-STATUS:GET-MESSAGE(iCount).
                     END.
                     RUN setError IN hMessageHandler (INPUT 0,
                                                      INPUT "enviroment_error":U,
                                                      INPUT "Erro de integraªío. Erro ao executar o programa 'cep/ceapi001j.p' pelo programa adapters/xml/ar2/axrar001.p. Durante sua execuªío ocorreu o(s) seguinte(s) erro(s) de Progress: " + cErrorText).
                     CREATE tt_log_erro.
                     ASSIGN tt_log_erro.ttv_num_cod_erro = 0
                            tt_log_erro.ttv_des_msg_erro = "Erro de integraªío. Erro ao executar o programa 'cep/ceapi001j.p' pelo programa adapters/xml/ar2/axrar001.p. Durante sua execuªío ocorreu o(s) seguinte(s) erro(s) de Progress: " + cErrorText.
                 END.
*/
                FOR EACH tt-erro:
                     RUN setError IN hMessageHandler (INPUT tt-erro.cd-erro,
                                                      INPUT "business_error":U,  /* Erro de negΩcio */
                                                      INPUT tt-erro.mensagem).
                     CREATE tt_log_erro.
                     ASSIGN tt_log_erro.ttv_num_cod_erro = tt-erro.cd-erro
                            tt_log_erro.ttv_des_msg_erro = tt-erro.mensagem.
                END.
           END.
           ELSE DO: /* Programa de efetivaá∆o n∆o localizado */
                 /* Inicio -- Projeto Internacional */
                 {utp/ut-liter.i "Erro_de_integraá∆o._N∆o_foi_poss°vel_localizar_o_programa_'cep/ceapi001k.p'_a_ser_executado_pelo_programa_adapters/xml/ar2/axrar011.p" *}
                 RUN setError IN hMessageHandler (INPUT 0,
                                                  INPUT "enviroment_error":U,
                                                  INPUT RETURN-VALUE + '.').
                 CREATE tt_log_erro.
                 /* Inicio -- Projeto Internacional */
                 {utp/ut-liter.i "Erro_de_integraá∆o._N∆o_foi_poss°vel_localizar_o_programa_'cep/ceapi001k.p'_a_ser_executado_pelo_programa_adapters/xml/ar2/axrar011.p" *}
                 ASSIGN tt_log_erro.ttv_num_cod_erro = 0
                        tt_log_erro.ttv_des_msg_erro = RETURN-VALUE + '.'.
           END.
     END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

PROCEDURE receiveMessage:

/*PARAMETERS - BEGIN*/
DEFINE INPUT PARAM hInputXML AS HANDLE NO-UNDO.
DEFINE OUTPUT PARAM hOutputXML AS HANDLE NO-UNDO.
/*PARAMETERS - END*/


/*LOCAL VARIABLES - BEGIN*/
/*LOCAL VARIABLES - END*/


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

     /* VERIFICA SE MessageHandler.p ESTA NA MEMORIA */
     {xmlinc/xmlloadmessagehandlerrec.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue" &MHReturnError="hOutputXML"}

     IF cReturnValue <> "OK" THEN DO:
          RETURN cReturnValue.
     END.

     /* INTERPRETA, ARMAZENA E VALIDA A MENSAGEM QUE RECEBE */
     RUN parseMessage IN hMessageHandler (INPUT  hInputXml, INPUT "{&XmlTranName}", 
                                          INPUT "{&XmlMaxTranVersion}", 
                                          INPUT "{&XmlMinTranVersion}", 
                                          INPUT "{&XmlListOfEvents}",
                                          OUTPUT lSuccessProcess,
                                          OUTPUT cTranAction, 
                                          OUTPUT cTranEvent,
                                          OUTPUT cTranVersion,
                                          OUTPUT hOutputXML ).

     /* SE NÄO PROCESSOU CORRETAMENTE RETORNA ERRO */
     IF NOT lSuccessProcess OR RETURN-VALUE <> "OK" THEN 
     /* DAR TRATAMENTO CONVENIENTE ANTES DE RETORNAR */
          RETURN RETURN-VALUE.

     /* VERIFICA SE APIXML ESTA NA MEMORIA */
     {xmlinc/xmlloadgenxmlrec.i &GenXml="hGenXml" &GXReturnValue="cReturnValue" &GXReturnError="hOutputXML"}

     /* VERIFICA SE O ut-genxml FOI INICIADO CORRETAMENTE */
     IF cReturnValue <> "OK"
     THEN DO:
          /* ELIMINA A MENSAGEM OBTIDA NO M?TODO getBusinessContent */
          DELETE OBJECT hBusinessContent NO-ERROR.

          RETURN cReturnValue.
     END.

     RUN PIUpsert.

     
     /* ---  Knupp - Mensagem de retorno das movimentacoes de Estoque  --- */
     if hMessageHandler:GET-SIGNATURE("setExtraInformation":U) <> "":U 
    and(not l-integracao-his) 
    and CAN-FIND(FIRST tt-movto WHERE tt-movto.nr-trans <> 0) then do:
            run adapters/xml/ar2/axnar001.p persistent set  h-axnar001  (input table tt-movto,
                                                                         input "axnar001",
                                                                         input "001",
                                                                         input "ADD",
                                                                         input i-TransactionNumberExternal,
                                                                         output table tt_log_erro).
            
            for each tt_log_erro no-lock:
                run utp/ut-msgs.p (input "msg", 
                                   input 17006  ,
                                   input tt_log_erro.ttv_des_msg_erro  ).
        
                RUN setError IN hMessageHandler (INPUT 17009,
                                                 INPUT "business_error":U, 
                                                 INPUT tt_log_erro.ttv_des_msg_erro).
            end.
            IF VALID-HANDLE(h-axnar001) THEN
                DELETE PROCEDURE h-axnar001.
      END.

    /* --- Knupp - Seta para o Adapter que a transacao contem Erro --- */
    IF CAN-FIND(FIRST tt_log_erro) THEN 
            ASSIGN lSuccessProcess = NO
                   cReturnValue   = "NOK".

  /* Obtem mensagem de retorno (erro ou confirmacao) */
  RUN getReturnMessage IN hMessageHandler (OUTPUT hOutputXML). 

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.

PROCEDURE pi-cria-tt-movto:

    ASSIGN tt-movto.cod-versao-integracao = 1
           tt-movto.cod-prog-orig         = "AXRAR001":U.
	
    RUN searchTag IN hGenXml (INPUT "TransactionInformation", INPUT getStack(), OUTPUT iId).
    if (iId <> ?) THEN DO:
         addStack(iId).
           RUN getSonDec  IN hGenXml (INPUT getStack(), INPUT "TransactionType":U, OUTPUT tt-movto.tipo-trans).
           IF tt-movto.tipo-trans <> 1 AND tt-movto.tipo-trans <> 2 THEN
              ASSIGN tt-movto.tipo-trans = 1.

           /* ------   Busca o Numero Externo da Solicitacao de Compras vindo do SGT   ----- */
           RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "TransactionNumberExternal":U, OUTPUT i-TransactionNumberExternal).

           if l-integracao-his then
               assign tt-movto.referencia = string("HIS" + string(i-TransactionNumberExternal,"999999999")).

           RUN getSonDate IN hGenXml (INPUT getStack(), INPUT "TransactionDate":U, OUTPUT tt-movto.dt-trans).
           IF tt-movto.dt-trans = ? OR STRING(tt-movto.dt-trans) = "" THEN
              ASSIGN tt-movto.dt-trans = TODAY.
              
         delStack().
    END.
    
    RUN searchTag IN hGenXml (INPUT "Location", INPUT getStack(), OUTPUT iId).
    if (iId <> ?) THEN DO:
         addStack(iId).

              RUN searchTag IN hGenXml (INPUT "Site", INPUT getStack(), OUTPUT iId).
              if (iId <> ?) THEN DO:
                   addStack(iId).

                        RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "SiteID", OUTPUT tt-movto.cod-estabel).
                   delStack().
              END.

              RUN searchTag IN hGenXml (INPUT "Warehouse", INPUT getStack(), OUTPUT iId).
              if (iId <> ?) THEN DO:
                   addStack(iId).

                        RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "WarehouseID", OUTPUT tt-movto.cod-depos).
                   delStack().
              END.

              RUN searchTag IN hGenXml (INPUT "BinLocation", INPUT getStack(), OUTPUT iId).
              if (iId <> ?) THEN DO:
                   addStack(iId).

                        RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "BinLocationID", OUTPUT tt-movto.cod-localiz).
                        IF tt-movto.cod-localiz = ? THEN ASSIGN tt-movto.cod-localiz = "".
                   delStack().
              END.

              RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "LotOrSerialNumber", OUTPUT tt-movto.lote).
              IF tt-movto.lote = ? THEN ASSIGN tt-movto.lote = "".
              
              RUN getSonDate IN hGenXml (INPUT getStack(), INPUT "LotValidityDate", OUTPUT tt-movto.dt-vali-lote).
         delStack().
    END.

    RUN searchTag IN hGenXml (INPUT "Item", INPUT getStack(), OUTPUT iId).
    if (iId <> ?) THEN DO:
         addStack(iId).

              RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "ItemCode", OUTPUT tt-movto.it-codigo).
              RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "DirectDebitItemDescription", OUTPUT tt-movto.descricao-db).
              IF tt-movto.descricao-db = ? THEN ASSIGN tt-movto.descricao-db = "".

              RUN searchTag IN hGenXml (INPUT "Reference", INPUT getStack(), OUTPUT iId).
              if (iId <> ?) THEN DO:
                   addStack(iId).

                   find first item no-lock
                         where item.it-codigo = tt-movto.it-codigo no-error.
                    if avail item then do:
                        if item.tipo-con-est = 4 THEN
                             RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "ReferenceCode", OUTPUT tt-movto.cod-refer).
                        else
                            assign tt-movto.cod-refer = "".
                    end.
                        
                        
                   delStack().
              END.
         delStack().
    END.

    RUN searchTag IN hGenXml (INPUT "Vendor", INPUT getStack(), OUTPUT iId).
    if (iId <> ?) THEN DO:
         addStack(iId).

              RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "VendorID", OUTPUT tt-movto.cod-emitente).
         delStack().
    END.

    RUN searchTag IN hGenXml (INPUT "GeneralLedgerAccount", INPUT getStack(), OUTPUT iId).
    if (iId <> ?) THEN DO:
         addStack(iId).

              RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "AccountNumber",              OUTPUT tt-movto.ct-codigo).      
              RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "SubAccountNumber",           OUTPUT tt-movto.sc-codigo).
                    
              RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "BusinessUnitCode",           OUTPUT tt-movto.cod-unid-negoc).
         delStack().
    END.
    
    RUN searchTag IN hGenXml (INPUT "ApplicationAccount", INPUT getStack(), OUTPUT iId).
    if (iId <> ?) THEN DO:
         addStack(iId).

              RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "AccountNumber",            OUTPUT tt-movto.ct-db).    
              RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "SubAccountNumber",         OUTPUT tt-movto.sc-db).    
 
         delStack().
    END.
    

    RUN searchTag IN hGenXml (INPUT "FiscalOperation", INPUT getStack(), OUTPUT iId).
    if (iId <> ?) THEN DO:
         addStack(iId).

              RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "FiscalOperationCode", OUTPUT  tt-movto.nat-operacao).
              
         delStack().
    END.

    RUN searchTag IN hGenXml (INPUT "UnitOfMeasure", INPUT getStack(), OUTPUT iId).
    if (iId <> ?) THEN DO:
         addStack(iId).

              RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "UnitOfMeasureID", OUTPUT tt-movto.un).

              IF tt-movto.un = "" OR tt-movto.un = ? THEN DO:
                 FOR FIRST ITEM FIELDS(un) WHERE ITEM.it-codigo = tt-movto.it-codigo NO-LOCK :
                     ASSIGN tt-movto.un = ITEM.un.
                 END.
              END.
              
         delStack().
    END.

    RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "Quantity", OUTPUT tt-movto.quantidade).
    IF tt-movto.quantidade = ? THEN ASSIGN tt-movto.quantidade = 0.

    RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "NetWeight", OUTPUT tt-movto.peso-liquido).
    IF tt-movto.peso-liquido = ? THEN ASSIGN tt-movto.peso-liquido = 0.

    RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "ValueType", OUTPUT  tt-movto.tipo-valor).
    IF tt-movto.tipo-valor <> 1 AND tt-movto.tipo-valor <> 2 THEN 
       ASSIGN tt-movto.tipo-valor = 1.

    RUN searchTag IN hGenXml (INPUT "Document", INPUT getStack(), OUTPUT iId).
    if (iId <> ?) THEN DO:
         addStack(iId).

              RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "DocumentType", OUTPUT  tt-movto.esp-docto).
              IF tt-movto.esp-docto = ? THEN ASSIGN tt-movto.esp-docto = 6.

              RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "DocumentSeries", OUTPUT  tt-movto.serie-docto).
              IF tt-movto.serie-docto = ? THEN ASSIGN tt-movto.serie-docto = "".

              RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "DocumentNumber", OUTPUT  tt-movto.nro-docto).
              IF tt-movto.nro-docto = ? THEN ASSIGN tt-movto.nro-docto = "".

              RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "DocumentSequence", OUTPUT tt-movto.sequen-nf).
              IF tt-movto.sequen-nf = ? THEN ASSIGN tt-movto.sequen-nf = 0.

              RUN searchTag IN hGenXml (INPUT "CurrentCurrencyDocumentValuesAndTaxes", INPUT getStack(), OUTPUT iId).
              if (iId <> ?) THEN DO:
                   addStack(iId).

                        RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "DocumentValue", OUTPUT  tt-movto.valor-nota).
                        IF tt-movto.valor-nota = ? THEN ASSIGN tt-movto.valor-nota = 0.

                        RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "ServicesAndProductsCirculationTaxValue", OUTPUT tt-movto.valor-icm).
                        IF tt-movto.valor-icm  = ? THEN ASSIGN tt-movto.valor-icm = 0.

                        RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "IndustrializedProductTaxValue", OUTPUT tt-movto.valor-ipi).
                        IF tt-movto.valor-ipi  = ? THEN ASSIGN tt-movto.valor-ipi = 0.

                        RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "ServiceTaxValue", OUTPUT tt-movto.valor-iss).
                        RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "SocialSecurityContributionTaxValue", OUTPUT tt-movto.valor-ggf-p[1]).
                        RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "SocialIntegrationProgramTaxValue", OUTPUT tt-movto.valor-mob-p[1]).
                   delStack().
              END.

              RUN searchTag IN hGenXml (INPUT "FASBDocumentValuesAndTaxes", INPUT getStack(), OUTPUT iId).
              if (iId <> ?) THEN DO:
                   addStack(iId).

                         RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "DocumentValue":U,                          OUTPUT tt-movto.vl-nota-fasb[1]).
                          IF tt-movto.vl-nota-fasb[1] = ? THEN ASSIGN  tt-movto.vl-nota-fasb[1] = 0.
                         RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "ServicesAndProductsCirculationTaxValue":U, OUTPUT tt-movto.vl-icm-fasb[1]).
                          IF tt-movto.vl-icm-fasb[1] = ? THEN ASSIGN  tt-movto.vl-icm-fasb[1] = 0.
                         RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "IndustrializedProductTaxValue":U,          OUTPUT tt-movto.vl-ipi-fasb[1]).
                          IF tt-movto.vl-ipi-fasb[1] = ? THEN ASSIGN  tt-movto.vl-ipi-fasb[1] = 0.
                         RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "ServiceTax":U,                             OUTPUT tt-movto.vl-iss-fasb[1]).
                          IF tt-movto.vl-iss-fasb[1] = ? THEN ASSIGN  tt-movto.vl-iss-fasb[1] = 0.
                         RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "SocialSecurityContributionTaxValue":U,     OUTPUT tt-movto.valor-ggf-p[2]).
                         RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "SocialIntegrationProgramTaxValue":U,       OUTPUT tt-movto.valor-mob-p[2]).

                   delStack().
              END.

              
             

              RUN searchTag IN hGenXml (INPUT "CMIDocumentValuesAndTaxes", INPUT getStack(), OUTPUT iId).
              if (iId <> ?) THEN DO:
                   addStack(iId).

                        RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "DocumentValue":U, OUTPUT tt-movto.vl-nota-fasb[2]).
                        IF tt-movto.vl-nota-fasb[2] = ? THEN ASSIGN  tt-movto.vl-nota-fasb[2] = 0.
                        RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "ServicesAndProductsCirculationTaxValue":U, OUTPUT tt-movto.vl-icm-fasb[2]).
                          IF tt-movto.vl-icm-fasb[2] = ? THEN ASSIGN  tt-movto.vl-icm-fasb[2] = 0.
                        RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "IndustrializedProductTaxValue":U, OUTPUT tt-movto.vl-ipi-fas[2]).
                          IF tt-movto.vl-ipi-fasb[2] = ? THEN ASSIGN  tt-movto.vl-ipi-fasb[2] = 0.
                        RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "ServiceTax":U, OUTPUT tt-movto.vl-iss-fasb[2]).
                          IF tt-movto.vl-iss-fasb[2] = ? THEN ASSIGN  tt-movto.vl-iss-fasb[2] = 0.
                        RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "SocialSecurityContributionTaxValue":U, OUTPUT tt-movto.valor-ggf-p[3]).
                        RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "SocialIntegrationProgramTaxValue":U, OUTPUT tt-movto.valor-mob-p[3]).
                   delStack().
              END.
         delStack().
    END.
    
    RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "PurchaseOrderNumber", OUTPUT  tt-movto.numero-ordem).
    RUN searchTag IN hGenXml (INPUT "ManufacturingOrder", INPUT getStack(), OUTPUT iId).
    if (iId <> ?) THEN DO:
         addStack(iId).

              RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "ManufacturingOrderNumber",   OUTPUT tt-movto.nr-ord-produ).
              IF tt-movto.nr-ord-produ = ? THEN ASSIGN  tt-movto.nr-ord-produ = 0.

              RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "ReportNumber", OUTPUT tt-movto.nr-report).
              IF tt-movto.nr-report = ? THEN ASSIGN tt-movto.nr-report = 0.

         delStack().
    END.
    
    RUN searchTag IN hGenXml (INPUT "OrderOperation", INPUT getStack(), OUTPUT iId).
    if (iId <> ?) THEN DO:
         addStack(iId).

              RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "OrderOperationCode",           OUTPUT tt-movto.op-codigo).
              RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "OrderOperationSequenceNumber", OUTPUT tt-movto.op-seq).   
              RUN searchTag IN hGenXml (INPUT "ManufactureRoute", INPUT getStack(), OUTPUT iId).
              if (iId <> ?) THEN DO:
                   addStack(iId).

                        RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "RouteID", OUTPUT tt-movto.cod-roteiro).
                        
                   delStack().
              END.

              RUN searchTag IN hGenXml (INPUT "ParentItem", INPUT getStack(), OUTPUT iId).
              if (iId <> ?) THEN DO:
                   addStack(iId).

                        RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "ParentItemCode", OUTPUT tt-movto.item-pai).
                        
                   delStack().
              END.

         delStack().
    END.

    RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "ReferenceOrderNumber",        OUTPUT tt-movto.nr-ord-refer).
    RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "ProjectControlOrderNumber",   OUTPUT tt-movto.num-ord-inv).
    if tt-movto.num-ord-inv = ? then assign tt-movto.num-ord-inv = 0.

    RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "SummarizedRequisitionNumber", OUTPUT tt-movto.nr-req-sum).

    RUN searchTag IN hGenXml (INPUT "TargetTransaction", INPUT getStack(), OUTPUT iId).
    if (iId <> ?) THEN DO:
         addStack(iId).

              RUN searchTag IN hGenXml (INPUT "TargetSite", INPUT getStack(), OUTPUT iId).
              if (iId <> ?) THEN DO:
                   addStack(iId).

                        RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "SiteID", OUTPUT  tt-movto.cod-estabel-des).
                   delStack().
              END.

              RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "TargetOrderNumber", OUTPUT tt-movto.num-ord-des).
              RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "TargetSequenceNumber", OUTPUT tt-movto.num-seq-des).
         delStack().
    END.    

    RUN getSonDate IN hGenXml (INPUT getStack(), INPUT "IssueDocumentDate", OUTPUT  tt-movto.dt-nf-saida).
    
    RUN searchTag IN hGenXml (INPUT "TransactionValues", INPUT getStack(), OUTPUT iId).
    if (iId <> ?) THEN DO:
         addStack(iId).
              ASSIGN iCount = 1.
              
              RUN searchTag IN hGenXml (INPUT "ListOfBatchAverageValues", INPUT getStack(), OUTPUT iId).
              if (iId <> ?) THEN DO:
                   addStack(iId).
                        
                        RUN getFirstSonId IN hGenXml (INPUT getStack(), OUTPUT iId).

                        DO WHILE iId <> ?:
                        addStack(iId).
                             
                             /*Criacao de valores para manter as relacoes*/
                             RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "MaterialValue", OUTPUT tt-movto.valor-mat-m[iCount]).
                             IF tt-movto.valor-mat-m[iCount] = ? THEN ASSIGN tt-movto.valor-mat-m[iCount] = 0.

                             RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "LaborValue", OUTPUT tt-movto.valor-mob-m[iCount]).
                             IF tt-movto.valor-mob-m[iCount] = ? THEN ASSIGN tt-movto.valor-mob-m[iCount] = 0.

                             RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "OverHeadValue", OUTPUT tt-movto.valor-ggf-m[iCount]).
                             IF tt-movto.valor-ggf-m[iCount] = ? THEN ASSIGN tt-movto.valor-ggf-m[iCount] = 0.

                             ASSIGN iId = getStack().

                             ASSIGN iCount = iCount + 1.

                             delStack().
                             RUN getNextSonId IN hGenXml (INPUT getStack(), INPUT iId, OUTPUT iId).
                        END.

                   delStack().
              END.

              RUN searchTag IN hGenXml (INPUT "ListOfOnLineAverageValues", INPUT getStack(), OUTPUT iId).
              if (iId <> ?) THEN DO:
                   addStack(iId).
                        
                        RUN getFirstSonId IN hGenXml (INPUT getStack(), OUTPUT iId).

                        DO WHILE iId <> ?:
                        addStack(iId).

                             RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "MaterialValue", OUTPUT  tt-movto.valor-mat-m[iCount]).
                             IF tt-movto.valor-mat-m[iCount] = ? THEN ASSIGN tt-movto.valor-mat-m[iCount] = 0.

                             RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "LaborValue", OUTPUT  tt-movto.valor-mob-m[iCount]).
                             IF tt-movto.valor-mob-m[iCount] = ? THEN ASSIGN tt-movto.valor-mob-m[iCount] = 0.

                             RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "OverHeadValue", OUTPUT tt-movto.valor-ggf-m[iCount]).
                             IF tt-movto.valor-ggf-m[iCount] = ? THEN ASSIGN tt-movto.valor-ggf-m[iCount] = 0.

                             ASSIGN iId = getStack().
                             ASSIGN iCount = iCount + 1.

                             delStack().
                             RUN getNextSonId IN hGenXml (INPUT getStack(), INPUT iId, OUTPUT iId).
                        END.

                   delStack().
              END.
              RUN searchTag IN hGenXml (INPUT "ListOfStandardCostValues", INPUT getStack(), OUTPUT iId).
              if (iId <> ?) THEN DO:
                   addStack(iId).

                        RUN getFirstSonId IN hGenXml (INPUT getStack(), OUTPUT iId).

                        DO WHILE iId <> ?:
                        addStack(iId).
                             
                             RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "MaterialValue", OUTPUT tt-movto.valor-mat-m[iCount]).
                             IF tt-movto.valor-mat-m[iCount] = ? THEN ASSIGN tt-movto.valor-mat-m[iCount] = 0.
                             
                             RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "LaborValue", OUTPUT tt-movto.valor-mob-m[iCount]).
                             IF tt-movto.valor-mob-m[iCount] = ? THEN ASSIGN tt-movto.valor-mob-m[iCount] = 0.

                             RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "OverHeadValue", OUTPUT tt-movto.valor-ggf-m[iCount]).
                             IF tt-movto.valor-ggf-m[iCount] = ? THEN ASSIGN tt-movto.valor-ggf-m[iCount] = 0.

                             ASSIGN iId = getStack().

                            ASSIGN iCount = iCount + 1.

                             delStack().
                             RUN getNextSonId IN hGenXml (INPUT getStack(), INPUT iId, OUTPUT iId).
                        END.

                   delStack().
              END.

         delStack().
    END.

END PROCEDURE.
/****** INTERNAL PROCEDURES - END*/


