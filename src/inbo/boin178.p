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
{include/i-prgvrs.i BOIN178 2.00.01.028 } /*** "010128" 24/04/2026 17:21:45 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i BOIN178 MEN}
&ENDIF


/*--------------------------------------------------------------------------
    File       :
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
&GLOBAL-DEFINE DBOName item-fornec
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName item-fornec
&GLOBAL-DEFINE TableLabel item-fornec
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE KeyField1 it-codigo    /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE KeyField2 cod-emitente /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
/* &GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES */



/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/
{inbo/boin178.i RowObject}
{inbo/boin178.i tt-item-fornec-before}
{include/i-epc200.i boin178}
{cdp/cdcfgmat.i}

DEFINE TEMP-TABLE tt-passa-mp         NO-UNDO LIKE item-fornec.

define temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer   initial ?
    field ttv_des_msg_ajuda as character initial ?
    field ttv_des_msg_erro  as character initial ?.

/* Include uso de pre-processadores */
{cdp/cdcfgmat.i}

&if defined(bf_mat_despesa_fase_II) &then
    define temp-table tt-desp-item-fornec no-undo like desp-item-fornec.
&endif

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER b-emitente     FOR emitente.

/*---------------------------- EAI ------------------------------*/
def new global shared var v_log_eai_habilit as logical no-undo.
def var h-axssu006 as handle no-undo.
/*---------------------------------------------------------------*/

/** * Defini‡äes Multi-Planta * **/
def var i-tipo-movto  as integer no-undo.
def var l-cria        as logical no-undo.
def var c-comp-aux    as char    no-undo.
{mpp/mpapi011.i}
{cdp/cd7300.i1}
/** * Fim Defini‡äes Multi-Planta * **/

/*--------------  procedure AtualizaUnidMedItemFornec   -------------------*/
def var  c-seg-usuario  as  char   no-undo.
def buffer b-item-fornec for item-fornec.
def buffer bfitem for item.
def var l-create        as  log no-undo initial no. /* para distinguir entre create e update.*/
def var de-soma         as  decimal no-undo. /* utilizado na verificacao do percentual de compra */
def var i-x             as integer no-undo. /* contador utilizada na include cc0105.i1 */
def var de-indice       as decimal no-undo.
def var de-indice-old   as decimal no-undo.
def var de-prazo        as decimal no-undo. /* utilizada na include cc0105.i1 */
def var de-taxa-per     as decimal no-undo. /* utilizada na include cc0105.i1 */
def var l-alt-med       as logical no-undo.
def var l-alt-lote      as logical no-undo.
def var l-preco-bruto   as logical no-undo. /* utilizada na include cc0105.i1  e
                                               na procedure InicializaPrecoIpiQtde*/
def var l-erro-un       as logical.
/*---------------------------------------------------------------------*/

def var cItem          as char    no-undo.
def var cItemIni       as char    no-undo.
def var cItemFin       as char    no-undo.
def var cItemFornIni   as char    no-undo.
def var cItemFornFin   as char    no-undo.
def var h-boin082      as handle  no-undo.
def var r-rowid        as rowid   no-undo.
def var cItemDoForn    as char    no-undo.
DEF VAR c-cgc          LIKE emitente.cgc NO-UNDO.

/*--------------- InicializaPrecoIpiQtde --------------------*/
def var de-val-orig     as   decimal format ">>>>>>>>>>>>>>9,99":U.
def var da-data         like cotacao-item.data-cotacao.
def var de-preco-unit   like ordem-compra.preco-unit label "Preco Un" format "zzzzzzzz9.9999":U.
def var l-tabela-g      as   log init yes no-undo.
/*-----------------------------------------------------------*/

def var cit-codigo as char no-undo.
DEF VAR l-exec-cc0106 AS LOGICAL INITIAL FALSE NO-UNDO.

DEF  VAR h-boin178i AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin841 AS HANDLE      NO-UNDO.

/*-------Defini‡Æo das variav‚is do setConstraintByFornec--------*/

def var i-cod-emitente as int no-undo.

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
         HEIGHT             = 3.54
         WIDTH              = 43.86.
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


DEF TEMP-TABLE RowErrorsAux NO-UNDO LIKE RowErrors.

{method/svc/autentic/autentic.i
            &vUserName="c-seg-usuario"}

find first param-global no-lock no-error.
find first param-cq     no-lock no-error.
find first param-compra no-lock no-error.

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
    assign l-create = yes. /* utilizado na procedure atualizaUnidMedItemFornec para
                              informar quando ‚ create(yes) ou update(no).*/
    run atualizaUnidMedItemFornec.

    &if "{&bf_mat_versao_ems}":U >= "2.062":U  &then
        if v_log_eai_habilit then do:
            run adapters/xml/su2/axssu006.p persistent set h-axssu006 (output table tt_log_erro).
            run PITransUpsert in h-axssu006 (input rowid(item-fornec), input "add" ,output table tt_log_erro).
            for each tt_log_erro no-lock:
                create RowErrors.
                assign RowErrors.ErrorNumber      = 17006
                       RowErrors.ErrorDescription = tt_log_erro.ttv_des_msg_erro
                       RowErrors.ErrorHelp        = tt_log_erro.ttv_des_msg_ajuda
                       RowErrors.ErrorSubType     = "WARNING":U.
            end.
            delete procedure h-axssu006.
        end.
    &endif

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




    IF  NOT VALID-HANDLE(h-boin841) THEN
        RUN inbo/boin841.p PERSISTENT SET h-boin841.

    RUN openQueryStatic IN h-boin841("main":U).
    RUN emptyRowErrors IN h-boin841.

    FOR EACH item-fornec-umd NO-LOCK
        WHERE item-fornec-umd.it-codigo     = RowObject.it-codigo
        AND   item-fornec-umd.cod-emitente  = RowObject.cod-emitente:

        RUN gotoKey IN h-boin841 (INPUT item-fornec-umd.it-codigo,
                                  INPUT item-fornec-umd.cod-emitente,
                                  INPUT item-fornec-umd.unid-med-for).

        IF RETURN-VALUE <> "NOK" THEN
            RUN deleteRecord IN h-boin841.
        RUN getRowErrors IN h-boin841 (OUTPUT TABLE RowErrors APPEND).
    END.

    DELETE PROCEDURE h-boin841.


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

    /**** atualiza relacionamentos item x fornec x estab *****/

    assign l-create = no. /* utilizado na procedure atualizaUnidMedItemFornec para
                             informar quando ‚ create(yes) ou update(no).*/

    /* s¢ executa a atualizaUnidMedItemFornec caso nÆo seja executado pelo cc0106 (boin00948) */
    IF NOT l-exec-cc0106 THEN
        run atualizaUnidMedItemFornec.

    &if "{&bf_mat_versao_ems}":U >= "2.062":U  &then
        if v_log_eai_habilit then do:
            run adapters/xml/su2/axssu006.p persistent set h-axssu006 (output table tt_log_erro).
            run PITransUpsert in h-axssu006 (input rowid(item-fornec), input "upd" ,output table tt_log_erro).
            for each tt_log_erro no-lock:
                create RowErrors.
                assign RowErrors.ErrorNumber      = 17006
                       RowErrors.ErrorDescription = tt_log_erro.ttv_des_msg_erro
                       RowErrors.ErrorHelp        = tt_log_erro.ttv_des_msg_ajuda
                       RowErrors.ErrorSubType     = "WARNING":U.

            end.
            delete procedure h-axssu006.
        end.
    &endif

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaUnidMedItemFornec DBOProgram
PROCEDURE atualizaUnidMedItemFornec :
/*------------------------------------------------------------------------------
  Purpose:      Verifica se a unidade  de medida/lote foi modificada. Se for,
                converte para a nova un e atualiza os registros relacionados.
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

    IF  NOT AVAIL param-global THEN
        FIND FIRST param-global NO-LOCK NO-ERROR.

    IF  NOT AVAIL ITEM
    OR  (AVAIL ITEM AND ITEM.it-codigo <> RowObject.it-codigo) THEN
        FIND item WHERE item.it-codigo = RowObject.it-codigo NO-LOCK NO-ERROR.

    /*-----------------------------------------------------------------*/
    /* Include i-epc200.i2: Criacao de registro para temp-table tt-epc */
    for each tt-epc where tt-epc.cod-event = "atualiza_cc_item_fornec":
        delete tt-epc.
    end.
    {include/i-epc200.i2 &CodEvent='"atualiza_cc_item_fornec"'
                         &CodParameter='"OBJECT-HANDLE"'
                         &ValueParameter="string(this-procedure)"}
    {include/i-epc200.i2 &CodEvent='"atualiza_cc_item_fornec"'
                         &CodParameter='"rowid-item-fornec"'
                         &ValueParameter="string(rowid(item-fornec))"}
    /* Include i-epc201.i: Chamada do programa de EPC */
    {include/i-epc201.i "atualiza_cc_item_fornec"}
    if  return-value = "NOK":U then do:
        undo, return "NOK":U.
    end.
    /*-----------------------------------------------------------------*/
    /*-----------------------------------------------------------------*/

    assign l-alt-med  = no
           l-alt-lote = no.

        if  (param-global.modulo-pl /* or param-global.modulo-02 */ )
            and l-create = yes then
            assign l-alt-lote = yes.

    find first tt-item-fornec-before no-lock no-error.
    if avail tt-item-fornec-before then do:

        if  item.tipo-contr <> 4 OR
           (item.tipo-contr  = 4 and item.it-codigo <> "") then
            if  RowObject.fator-conver <> tt-item-fornec-before.fator-conver
            or  RowObject.unid-med-for <> tt-item-fornec-before.unid-med-for
            or  RowObject.num-casa-dec <> tt-item-fornec-before.num-casa-dec
            then
                assign l-alt-med = yes.

        if  (param-global.modulo-pl /* or param-global.modulo-02 */ )
            and l-create = no then do:
            if  RowObject.classe-repro <> tt-item-fornec-before.classe-repro then
                assign l-alt-lote = yes.
            if  l-alt-lote = no then do:
                if  RowObject.lote-minimo <> tt-item-fornec-before.lote-minimo then
                    assign l-alt-lote = yes.
            end.
            if  l-alt-lote = no then do:
                if  RowObject.lote-mul-for <> tt-item-fornec-before.lote-mul-for then
                    assign l-alt-lote = yes.
            end.
            if  l-alt-lote = no then do:
                if  RowObject.perc-compra <> tt-item-fornec-before.perc-compra then
                    assign l-alt-lote = yes.
            end.
        end.
    end.

    if  l-alt-lote then do:
        run cdp/cd7000.p (input 2, item-fornec.it-codigo, "":U).    /* usado para planejamento */
    end.

    /****************** valida unidade de medida ***************************
    if item.tipo-contr = 4 then do:
        if can-find(first it-requisicao
                where it-requisicao.it-codigo = item.it-codigo
                 and  it-requisicao.un <> item.un) then do:
            {method/svc/errors/inserr.i &ErrorNumber="8639"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Item'"}
            assign l-erro-un = yes.
    end.

    if can-find(first prazo-compra
                where prazo-compra.it-codigo = item.it-codigo
                 and  prazo-compra.un        <> item.un
                 and  prazo-compra.situacao  <> 4)    then do:
            {method/svc/errors/inserr.i &ErrorNumber="8637"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Item'"}
        assign l-erro-un = yes.
    end.

    find first cotacao-item
         where cotacao-item.cod-emitente =  RowObject.cod-emitente
           and cotacao-item.it-codigo    =  RowObject.item-do-forn
           and cotacao-item.un           <> RowObject.unid-med-for
               no-lock no-error.
    if avail cotacao-item then
        find ordem-compra
             where ordem-compra.numero-ordem = cotacao-item.numero-ordem
               and ordem-compra.cod-emitente = cotacao-item.cod-emitente
               and ordem-compra.situacao <> 4  no-lock no-error.
        if avail ordem-compra then do:
            {method/svc/errors/inserr.i &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="'Item'"}
            assign l-erro-un = yes.
        end.
    end.
    ***********************************************************************/

    /* Quando modifica a unidade de um item tem que atualizar o hist¢rico antigo */

    if  l-alt-med then do: /* -- Conversao para nova unidade medida do fornecedor -- */

          assign de-indice = if avail item-fornec then
                             item-fornec.fator-conver / if  item-fornec.num-casa-dec = 0 then 1
                                                        else exp(10, item-fornec.num-casa-dec)
                             else 1.
                 l-preco-bruto = if avail param-compra then (param-compra.ipi-sobre-preco = 1)
                             else no.

         ASSIGN de-indice-old = IF AVAIL tt-item-fornec-before THEN
                                tt-item-fornec-before.fator-conver / IF tt-item-fornec-before.num-casa-dec = 0 THEN 1
                                                                     ELSE EXP(10, tt-item-fornec-before.num-casa-dec)
                                ELSE 1.

          for each ordem-compra
             where ordem-compra.cod-emitente = item-fornec.cod-emitente
               and ordem-compra.it-codigo    = item-fornec.it-codigo exclusive-lock:

              assign ordem-compra.pre-unit-for = ordem-compra.preco-unit / de-indice.
              {ccp/cc0105.i1 "ordem-compra"}   /*Recalcula preco unitario bruto do item atraves do
                                                 preco unitario calculado*/
              for each prazo-compra where
                       prazo-compra.numero-ordem = ordem-compra.numero-ordem and
                       prazo-compra.it-codigo   = ordem-compra.it-codigo exclusive-lock:
                  assign prazo-compra.qtd-do-forn  = prazo-compra.quantidade * de-indice
                         prazo-compra.qtd-sal-forn = prazo-compra.quant-saldo * de-indice
                         prazo-compra.qtd-rej-forn = prazo-compra.quant-rejeit * de-indice
                         prazo-compra.qtd-rec-forn = prazo-compra.quant-receb * de-indice.
              end.
              for each evento-ped
                 where evento-ped.numero-ordem = ordem-compra.numero-ordem
                   and evento-ped.it-codigo    = ordem-compra.it-codigo exclusive-lock:

                  assign evento-ped.qtd-prevista  = evento-ped.qtd-prevista * de-indice
                         evento-ped.qtd-realizada = evento-ped.qtd-realizada * de-indice
                         evento-ped.val-antecip   = evento-ped.val-antecip * de-indice
                         evento-ped.val-pago      = evento-ped.val-pago * de-indice
                         evento-ped.val-previsto  = evento-ped.val-previsto * de-indice
                         evento-ped.val-realizado = evento-ped.val-realizado * de-indice.
              end.
          end.

          for each cotacao-item
             where cotacao-item.cod-emitente = item-fornec.cod-emitente
               and cotacao-item.it-codigo    = item-fornec.it-codigo exclusive-lock:

              assign cotacao-item.pre-unit-for = cotacao-item.preco-unit / de-indice
                     cotacao-item.un           = item-fornec.unid-med-for.
              {ccp/cc0105.i1 "cotacao-item"}    /*Recalcula preco unitario bruto do item atraves do
                                                 preco unitario calculado*/
          end.

          for each item-contrat
             where item-contrat.it-codigo    = item-fornec.it-codigo
               and item-contrat.cod-emitente = item-fornec.cod-emitente exclusive-lock:

             assign item-contrat.pre-unit-for   = (item-contrat.pre-unit-for * de-indice-old) / de-indice
                    item-contrat.un             = item-fornec.unid-med-for
                    /*item-contrat.sld-val-receb  = (item-contrat.sld-val-receb * de-indice-old) / de-indice
                    item-contrat.sld-val-liber  = (item-contrat.sld-val-liber * de-indice-old) / de-indice
                    item-contrat.sld-val        = (item-contrat.sld-val * de-indice-old) / de-indice*/
                    item-contrat.sld-qtd-receb  = (item-contrat.sld-qtd-receb * de-indice) / de-indice-old
                    item-contrat.sld-qtd-liber  = (item-contrat.sld-qtd-liber * de-indice) / de-indice-old
                    item-contrat.sld-qtd        = (item-contrat.sld-qtd * de-indice) / de-indice-old
                    item-contrat.val-taxa       = (item-contrat.val-taxa * de-indice-old) / de-indice
                    item-contrat.valor-descto   = (item-contrat.valor-descto * de-indice-old) / de-indice
                    item-contrat.val-frete      = (item-contrat.val-frete * de-indice-old) / de-indice.

              assign item-contrat.preco-fornec = item-contrat.pre-unit-for.

              if  l-preco-bruto = no then do:
                  if  item-contrat.taxa-financ then do:
                      if  not item-contrat.codigo-ipi then assign
                          item-contrat.preco-fornec = item-contrat.preco-fornec / (1 + (item-contrat.aliquota-ipi / 100)).
                  end.
                  else do:
                      if not item-contrat.codigo-ipi then assign
                         item-contrat.preco-fornec = item-contrat.preco-fornec / (1 + (item-contrat.aliquota-ipi / 100)).
                      if  item-contrat.val-taxa <> 0 then do:
                          find cond-pagto where
                               cond-pagto.cod-cond-pag = item-contrat.cod-cond-pag no-lock no-error.
                          if avail cond-pagto and cond-pagto.prazos[1] <> 0 then do:
                              de-prazo = 0.
                              do i-x = 1 to cond-pagto.num-parcelas:
                                 de-prazo = de-prazo + (cond-pagto.prazos[i-x] *
                                               cond-pagto.per-pg-dup[i-x]).
                              end.
                              assign de-prazo    = de-prazo / 100
                                     de-taxa-per = exp(exp(1 + item-contrat.val-taxa / 100,
                                                         1 / 30),de-prazo)
                                     item-contrat.preco-fornec = item-contrat.preco-fornec / de-taxa-per.
                          end.
                      end.
                  end.
                  if  item-contrat.perc-desconto > 0 then assign
                      item-contrat.preco-fornec = item-contrat.preco-fornec / (1 - (item-contrat.perc-desconto / 100)).
              end.
              else do:
                  if  item-contrat.perc-desconto  > 0 then assign
                      item-contrat.preco-fornec = item-contrat.preco-fornec / (1 - (item-contrat.perc-desconto / 100)).
                  if  item-contrat.codigo-ipi   =  no
                  and item-contrat.aliquota-ipi <> 0 then assign
                      item-contrat.preco-fornec = item-contrat.preco-fornec / (1 + (item-contrat.aliquota-ipi / 100)).
                  if  item-contrat.taxa-financ =  no
                  and item-contrat.val-taxa  <> 0 then do:
                      find cond-pagto where
                           cond-pagto.cod-cond-pag = item-contrat.cod-cond-pag no-lock no-error.
                      if avail cond-pagto and cond-pagto.prazos[1] <> 0 then do:
                          de-prazo = 0.
                          do  i-x = 1 to cond-pagto.num-parcelas:
                              assign de-prazo = de-prazo + (cond-pagto.prazos[i-x] *
                                                cond-pagto.per-pg-dup[i-x]).
                          end.
                          assign de-prazo    = de-prazo / 100
                                 de-taxa-per = exp(exp(1 + item-contrat.val-taxa / 100,
                                                       1 / 30),de-prazo)
                                 item-contrat.preco-fornec = item-contrat.preco-fornec / de-taxa-per.
                      end.
                  end.
              end.

              /**Atualiza medições**/
              FOR EACH medicao-contrat
                 WHERE medicao-contrat.nr-contrato   = item-contrat.nr-contrato
                   AND medicao-contrat.num-seq-item  = item-contrat.num-seq-item EXCLUSIVE-LOCK:

                  ASSIGN medicao-contrat.qtd-medicao      = (medicao-contrat.qtd-medicao * de-indice) / de-indice-old
                         medicao-contrat.qtd-prevista     = (medicao-contrat.qtd-prevista * de-indice) / de-indice-old.

              END.
          end.

          for each componente where
                   componente.cod-emitente = item-fornec.cod-emitente and
                   componente.it-codigo    = item-fornec.it-codigo exclusive-lock:
              assign componente.qt-do-forn = componente.quantidade * de-indice.
          end.
          for each recebimento where
                   recebimento.cod-emitente = item-fornec.cod-emitente and
                   recebimento.it-codigo    = item-fornec.it-codigo exclusive-lock:
              assign recebimento.qtd-rec-forn = recebimento.quant-receb * de-indice
                     recebimento.qtd-rej-forn = recebimento.quant-rejeit * de-indice.

              find first prazo-compra no-lock
                  where  prazo-compra.numero-ordem = recebimento.numero-ordem no-error.
              if  avail prazo-compra and prazo-compra.situacao = 6 /* Recebida */ then
                  next.

              assign recebimento.pre-unit-for = recebimento.preco-unit / de-indice.
          end.
          for each item-doc-est where
                   item-doc-est.cod-emitente = item-fornec.cod-emitente and
                   item-doc-est.it-codigo    = item-fornec.it-codigo exclusive-lock:

              assign item-doc-est.qt-do-forn    = item-doc-est.quantidade * de-indice
                     item-doc-est.preco-unit[1] = (item-doc-est.preco-unit[1] * de-indice-old) / de-indice  /*preco unitario do fornecedor*/
                     item-doc-est.un            = item-fornec.unid-med-for.

              for each rat-ordem
                 where rat-ordem.serie-docto = item-doc-est.serie-docto
                 and   rat-ordem.nro-docto   = item-doc-est.nro-docto
                 and   rat-ordem.cod-emitente = item-doc-est.cod-emitente
                 and   rat-ordem.nat-operacao = item-doc-est.nat-operacao
                 and   rat-ordem.sequencia   = item-doc-est.sequencia exclusive-lock:
                    assign rat-ordem.qtidade-forn = rat-ordem.quantidade * de-indice.
              end.
              for each pd-pd-it-nfe
                 where pd-pd-it-nfe.serie-docto  = item-doc-est.serie-docto
                 and   pd-pd-it-nfe.nro-docto    = item-doc-est.nro-docto
                 and   pd-pd-it-nfe.cod-emitente = item-doc-est.cod-emitente
                 and   pd-pd-it-nfe.nat-operacao = item-doc-est.nat-operacao
                 and   pd-pd-it-nfe.sequencia    = item-doc-est.sequencia exclusive-lock:
                    assign pd-pd-it-nfe.qt-do-forn = pd-pd-it-nfe.quantidade * de-indice.
              end.
              for each pd-cc-it-nfe
                 where pd-cc-it-nfe.serie-docto  = item-doc-est.serie-docto
                 and   pd-cc-it-nfe.nro-docto    = item-doc-est.nro-docto
                 and   pd-cc-it-nfe.cod-emitente = item-doc-est.cod-emitente
                 and   pd-cc-it-nfe.nat-operacao = item-doc-est.nat-operacao
                 and   pd-cc-it-nfe.sequencia    = item-doc-est.sequencia exclusive-lock:
                    assign pd-cc-it-nfe.qt-do-forn = pd-cc-it-nfe.quantidade * de-indice.
              end.
          end.
    end.

    /*********** Multi-Planta **************/
    assign c-transacao = "MAT001".
    {cdp/cd7300.i5 "001" c-transacao}
    assign i-tipo-movto = if l-create = yes then 1 else 2.
      if  param-global.modulo-mp and
          avail item-fornec and
          tt-replica-msg.log-replica-msg  = yes then do:
          create tt-dados-env.
          assign tt-dados-env.num-sequencia  = i-seq
                 tt-dados-env.cod-tipo-reg   = 47
                 tt-dados-env.ind-tipo-movto = i-tipo-movto
                 tt-dados-env.identif-msg    = item-fornec.it-codigo + " , " +
                                               string(item-fornec.cod-emitente).
          create tt-passa-mp.
          buffer-copy item-fornec to tt-passa-mp.
          raw-transfer tt-passa-mp to tt-dados-env.conteudo-msg.
          empty temp-table tt-passa-mp.

          /* raw-transfer item-fornec to tt-dados-env.conteudo-msg. */
          assign i-seq = i-seq + 1.
      end.
    {cdp/cd7300.i6 "001" c-transacao}
    /********** Fim Multi-Planta ***********/

    return "OK":U.
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
    /* A Trigger da tabela item-fornec esta sendo desabilitada porque ela est 
    disparando ut-msgs com show, que ‚ proibido no ambiente web pois causa um erro fatal no
    agente WebSpeed.
    Toda a validacao feita na Trigger que foi transferida para a bo   */


    DISABLE TRIGGERS FOR DUMP OF item-fornec.

    /*** Se o comando acima nÆo funcionar, usar esse que est  em coment rio ****
        /* Ignora as Triggers */
        ON WRITE OF item-fornec OVERRIDE DO:
        END.
    ***/

    find first RowErrors no-error.
    if not avail RowErrors then do:
        /** Inicio da elimina‡Æo em cascata **/
        if not valid-handle (h-boin082) then
            run inbo/boin082.p persistent set h-boin082.

        for each cotacao-item where
                 cotacao-item.cod-emitente = item-fornec.cod-emitente and
                 cotacao-item.it-codigo    = item-fornec.it-codigo and
                 cotacao-item.cot-aprovada = no no-lock:
            assign r-rowid = rowid(cotacao-item).
            run openQueryStatic in h-boin082 ("Main":U).

            RUN repositionRecord in h-boin082 (input r-rowid).
            RUN deleteRecord     in h-boin082 .
             if return-value = "NOK":U then do:
                  RUN getRowErrors  in h-boin082 (OUTPUT TABLE RowErrors) .
             end.
        end.
        if valid-handle (h-boin082) then do:
            delete procedure h-boin082.
                             h-boin082 = ?.
        end.

        find first RowErrors no-lock no-error.
        if not avail RowErrors then do:
              /********** In¡cio Multi-Planta ****************/
              assign c-transacao = "MAT001".
              {cdp/cd7300.i5 "001" c-transacao}
              if  param-global.modulo-mp and
                  tt-replica-msg.log-replica-msg  = yes then do:
                  create tt-dados-env.
                  assign tt-dados-env.num-sequencia  = i-seq
                         tt-dados-env.cod-tipo-reg   = 47
                         tt-dados-env.ind-tipo-movto = 3
                         tt-dados-env.identif-msg    = item-fornec.it-codigo + " , " +
                                                       string(item-fornec.cod-emitente).
                  create tt-passa-mp.
                  buffer-copy item-fornec to tt-passa-mp.
                  raw-transfer tt-passa-mp to tt-dados-env.conteudo-msg.
                  empty temp-table tt-passa-mp.

                  /* raw-transfer item-fornec to tt-dados-env.conteudo-msg. */
                  assign i-seq = i-seq + 1.
              end.
              {cdp/cd7300.i6 "001" c-transacao}
              /************* Fim-Multi-Planta ***************/
        end.
    end.

    /**** Elimina relacionamento item x fornec x estab *****/
    for each item-fornec-estab where
        item-fornec-estab.it-codigo = item-fornec.it-codigo and
        item-fornec-estab.cod-emitente = item-fornec.cod-emitente exclusive-lock:
        delete item-fornec-estab.
    end.

    /**** Elimina despesas relacionadas ao item-fornec, somente
          a partir da versÆo 2.04B ****/
    &if defined(bf_mat_despesa_compra_inter) &then
        for each  desp-item-fornec
            where desp-item-fornec.it-codigo = item-fornec.it-codigo
              and desp-item-fornec.cod-emitente = item-fornec.cod-emitente exclusive-lock:

            &if defined(bf_mat_despesa_fase_II) &then
                /**************** MULTI-PLANTA ****************/
                assign c-transacao = "MAT001".
                {cdp/cd7300.i5 "001" c-transacao}
                if  param-global.modulo-mp and
                    tt-replica-msg.log-replica-msg  = yes then do:
                    create tt-dados-env.
                    assign tt-dados-env.num-sequencia  = i-seq
                           tt-dados-env.cod-tipo-reg   = 297
                           tt-dados-env.ind-tipo-movto = 3
                           tt-dados-env.identif-msg    = string(desp-item-fornec.it-codigo)    + " , ":U +
                                                         string(desp-item-fornec.cod-emitente) + " , ":U +
                                                         string(desp-item-fornec.num-seq-desp) + " , ":U +
                                                         string(desp-item-fornec.cod-despesa).
                    create tt-desp-item-fornec.
                    buffer-copy desp-item-fornec to tt-desp-item-fornec.
                    raw-transfer tt-desp-item-fornec to tt-dados-env.conteudo-msg.
                    empty temp-table tt-desp-item-fornec.

                    assign i-seq = i-seq + 1.
                end.
                {cdp/cd7300.i6 "001" c-transacao}
                /**************** MULTI-PLANTA ****************/
            &endif

            delete desp-item-fornec.
        end.
    &endif

    /*---------------------     Fim da Valida‡Æo da Trigger    ------------------*/

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    &if "{&bf_mat_versao_ems}":U >= "2.062":U  &then
        if v_log_eai_habilit then do:
            run adapters/xml/su2/axssu006.p persistent set h-axssu006 (output table tt_log_erro).
            run PITransDelete in h-axssu006 (input rowid(item-fornec), output table tt_log_erro).

            for each tt_log_erro no-lock:
                create RowErrors.
                assign RowErrors.ErrorNumber      = 17006
                       RowErrors.ErrorDescription = tt_log_erro.ttv_des_msg_erro
                       RowErrors.ErrorHelp        = tt_log_erro.ttv_des_msg_ajuda
                       RowErrors.ErrorSubType     = "WARNING":U.
            end.
            delete procedure h-axssu006.
        end.
    &endif

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDestroy DBOProgram
PROCEDURE beforeDestroy :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    return "OK":U.
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
    if item-fornec.ativo = no then do:
        for each item-fornec-estab where
            item-fornec-estab.it-codigo    = RowObject.it-codigo and
            item-fornec-estab.cod-emitente = RowObject.cod-emitente EXCLUSIVE-LOCK:
            assign item-fornec-estab.ativo = no.
        end.
    end.

    for each tt-item-fornec-before:
        delete tt-item-fornec-before.
    end.
    create tt-item-fornec-before.
    buffer-copy item-fornec to tt-item-fornec-before.
    find first tt-item-fornec-before no-lock no-error.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExecuteValidateStatusFornec DBOProgram
PROCEDURE ExecuteValidateStatusFornec :
/*------------------------------------------------------------------------------
  Purpose: Verificar a situacao do fonecedor para validar alteracoes na parcela
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    def var h-boin356vl as handle no-undo.


    if not valid-handle (h-boin356vl) then
        run inbo/boin356vl.p persistent set h-boin356vl.

    run validateStatusFornec in h-boin356vl ( ?,
                                              rowObject.cod-emitente ).
    run getRowErrors in h-boin356vl (output table RowErrorsAux).
    for each RowErrorsAux:
        create RowErrors.
        buffer-copy RowErrorsAux to RowErrors.
    end.
    empty temp-table RowErrorsAux.

    if valid-handle (h-boin356vl) then do:
        delete procedure h-boin356vl.
                         h-boin356vl = ?.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findOrdem_compra DBOProgram
PROCEDURE findOrdem_compra :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    def input parameter c-it-codigo as char no-undo.
    def input parameter pi-cod-emitente as inte no-undo.
    def output parameter cReturn as char no-undo.

    run openQueryStatic ("Main":U).

    run goToKey (input c-it-codigo, input pi-cod-emitente).

    if return-value = "NOK":U then do:
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="'{&TableName}'"}
    end.
    else
      cReturn = "":U.


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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "numero-nota":U THEN ASSIGN pFieldValue = RowObject.numero-nota.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
        WHEN "serie-nota":U THEN ASSIGN pFieldValue = RowObject.serie-nota.
        WHEN "cd-referencia":U THEN ASSIGN pFieldValue = RowObject.cd-referencia.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "item-do-forn":U THEN ASSIGN pFieldValue = RowObject.item-do-forn.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "unid-med-for":U THEN ASSIGN pFieldValue = RowObject.unid-med-for.
        WHEN "cod-unid-calc-cofins":U THEN ASSIGN pFieldValue = RowObject.cod-unid-calc-cofins.
        WHEN "cod-unid-calc-pis":U THEN ASSIGN pFieldValue = RowObject.cod-unid-calc-pis.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "fator-conver":U THEN ASSIGN pFieldValue = RowObject.fator-conver.
        WHEN "perc-dev-forn":U THEN ASSIGN pFieldValue = RowObject.perc-dev-forn.
        WHEN "perc-pont-forn":U THEN ASSIGN pFieldValue = RowObject.perc-pont-forn.
        WHEN "qt-max-ordem":U THEN ASSIGN pFieldValue = RowObject.qt-max-ordem.
        WHEN "rendimento":U THEN ASSIGN pFieldValue = RowObject.rendimento.
        WHEN "lote-minimo":U THEN ASSIGN pFieldValue = RowObject.lote-minimo.
        WHEN "lote-mul-for":U THEN ASSIGN pFieldValue = RowObject.lote-mul-for.
        WHEN "niv-qua-ac":U THEN ASSIGN pFieldValue = RowObject.niv-qua-ac.
        WHEN "concentracao":U THEN ASSIGN pFieldValue = RowObject.concentracao.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "criticidade":U THEN ASSIGN pFieldValue = RowObject.criticidade.
        WHEN "hora-fim":U THEN ASSIGN pFieldValue = RowObject.hora-fim.
        WHEN "hora-ini":U THEN ASSIGN pFieldValue = RowObject.hora-ini.
        WHEN "horiz-fixo":U THEN ASSIGN pFieldValue = RowObject.horiz-fixo.
        WHEN "ind-pont":U THEN ASSIGN pFieldValue = RowObject.ind-pont.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "num-casa-dec":U THEN ASSIGN pFieldValue = RowObject.num-casa-dec.
        WHEN "ped-fornec":U THEN ASSIGN pFieldValue = RowObject.ped-fornec.
        WHEN "perc-compra":U THEN ASSIGN pFieldValue = RowObject.perc-compra.
        WHEN "tempo-ressup":U THEN ASSIGN pFieldValue = RowObject.tempo-ressup.
        WHEN "tp-inspecao":U THEN ASSIGN pFieldValue = RowObject.tp-inspecao.
        WHEN "aval-insp[1]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[1].
        WHEN "aval-insp[17]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[17].
        WHEN "aval-insp[18]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[18].
        WHEN "aval-insp[19]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[19].
        WHEN "aval-insp[20]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[20].
        WHEN "aval-insp[21]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[21].
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "aval-insp[24]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[24].
        WHEN "aval-insp[25]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[25].
        WHEN "aval-insp[26]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[26].
        WHEN "aval-insp[27]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[27].
        WHEN "aval-insp[28]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[28].
        WHEN "aval-insp[29]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[29].
        WHEN "aval-insp[30]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[30].
        WHEN "classe-repro":U THEN ASSIGN pFieldValue = RowObject.classe-repro.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-mensagem":U THEN ASSIGN pFieldValue = RowObject.cod-mensagem.
        WHEN "conceito":U THEN ASSIGN pFieldValue = RowObject.conceito.
        WHEN "niv-inspecao":U THEN ASSIGN pFieldValue = RowObject.niv-inspecao.
        WHEN "aval-insp[22]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[22].
        WHEN "aval-insp[23]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[23].
        WHEN "aval-insp[2]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[2].
        WHEN "aval-insp[3]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[3].
        WHEN "aval-insp[4]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[4].
        WHEN "aval-insp[5]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[5].
        WHEN "aval-insp[6]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[6].
        WHEN "aval-insp[7]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[7].
        WHEN "aval-insp[8]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[8].
        WHEN "aval-insp[9]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[9].
        WHEN "aval-insp[10]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[10].
        WHEN "aval-insp[11]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[11].
        WHEN "aval-insp[12]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[12].
        WHEN "aval-insp[13]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[13].
        WHEN "aval-insp[14]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[14].
        WHEN "aval-insp[15]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[15].
        WHEN "aval-insp[16]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[16].
        WHEN "cdn-fornec-pregao":U THEN ASSIGN pFieldValue = &IF "{&bf_mat_versao_ems}" < "2.07" &THEN
                                                                INT(SUBSTRING(rowObject.char-1,46,5)).
                                                             &ElSE
                                                                rowObject.cdn-fornec-pregao.
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
  Purpose:     Retorna valores dos campos do ¡ndice ONDE-COMPRA
  Parameters:
               retorna valor dos campos do ¡ndice ONDE-COMPRA
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE item-fornec.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE item-fornec.cod-emitente NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo.
    ASSIGN pcod-emitente = RowObject.cod-emitente.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cot-aut":U THEN ASSIGN pFieldValue = RowObject.cot-aut.
        WHEN "reaj-tabela":U THEN ASSIGN pFieldValue = RowObject.reaj-tabela.
        WHEN "ativo":U THEN ASSIGN pFieldValue = RowObject.ativo.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.

        &IF "{&bf_mat_versao_ems}" >= "2.08" &THEN
        WHEN "log-cod-barra-obrig":U THEN ASSIGN pFieldValue = RowObject.log-cod-barra-obrig.
        &ENDIF

        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "usa-contrato":U THEN ASSIGN pFieldValue = RowObject.usa-contrato.
        WHEN "contr-forn":U THEN ASSIGN pFieldValue = RowObject.contr-forn.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowidOrdemCompra DBOProgram
PROCEDURE getRowidOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:  Procura o rowid da tabela ordem-compra a partir do c¢digo do ordem-compra
            que vem da tabela item-fornec.
  Parameters:   ipar1 : r-item-fornec  : rowid do registro da tabela item-fornec
                opar2 : r-ordem-compra : rowid da tabela ordem-compra
  Notes:
------------------------------------------------------------------------------*/

    def input  param r-item-fornec  as rowid no-undo.
    def output param r-ordem-compra as rowid no-undo.

    find first item-fornec where
         rowid(item-fornec) = r-item-fornec no-lock no-error.

    if avail item-fornec then do:
        find last  ordem-compra
             where ordem-compra.cod-emitente = item-fornec.cod-emitente
               and ordem-compra.it-codigo    = item-fornec.it-codigo
               AND ordem-compra.num-pedido <> 0 NO-LOCK NO-ERROR.
        if avail ordem-compra then
            assign r-ordem-compra = rowid(ordem-compra).
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice ONDE-COMPRA
  Parameters:
               recebe valor dos campos do ¡ndice ONDE-COMPRA
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE item-fornec.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE item-fornec.cod-emitente NO-UNDO.

    FIND FIRST bfitem-fornec WHERE
        bfitem-fornec.it-codigo = pit-codigo AND
        bfitem-fornec.cod-emitente = pcod-emitente
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-fornec THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-fornec)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InicializaNumeroNotaNomeAbrevRealForn DBOProgram
PROCEDURE InicializaNumeroNotaNomeAbrevRealForn :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa os valores de Numero da nota, Nome Abrev, Real e Forn a partir do
               cod-emitente da tabela item-fornec.
  Parameters:
               ipar1 : r-item-fornec     -   rowid do registro da tabela item-fornec
               opar2 : p-c-numero-nota   -   retorna o valor numero da nota da tabela recebimento cforme r-rowid da tabela item-fornec
               opar3 : p-c-nome-abrev    -   retorna o valor nome abrev da tabela emitente cforme r-rowid tabela item-fornec
               opar4 : p-i-r-real        -   retorna o valor r-real a partir do r-rowid da tabela item-fornec
               opar5 : p-i-r-forn        -   retorna o valor r-forn a partir do r-rowid da tabela item-fornec

  Notes:
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM r-item-fornec   AS ROWID NO-UNDO.
    DEF OUTPUT PARAM p-c-numero-nota AS CHAR  NO-UNDO.
    DEF OUTPUT PARAM p-c-nome-abrev  AS CHAR  NO-UNDO.
    DEF OUTPUT PARAM p-i-r-real      AS INT   NO-UNDO.
    DEF OUTPUT PARAM p-i-r-forn      AS INT   NO-UNDO.

    FOR FIRST item-fornec FIELDS(cod-emitente)
        WHERE ROWID(item-fornec) = r-item-fornec NO-LOCK: END.
    if avail item-fornec then
        FOR FIRST ordem-compra FIELDS(cod-emitente num-pedido numero-ordem
                                      data-emissao data-pedido)
            WHERE ordem-compra.cod-emitente = item-fornec.cod-emitente NO-LOCK: END.
        if avail ordem-compra then
            FOR FIRST emitente FIELDS(nome-abrev)
                WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK: END.
            if avail emitente then
                ASSIGN p-c-nome-abrev = IF AVAIL emitente THEN emitente.nome-abrev ELSE "":U.

    FOR LAST  recebimento FIELDS(data-movto numero-nota)
        WHERE recebimento.num-pedido   = ordem-compra.num-pedido
          AND recebimento.numero-ordem = ordem-compra.numero-ordem NO-LOCK: END.
    IF  AVAILABLE recebimento THEN
        ASSIGN p-i-r-real = recebimento.data-movto - ordem-compra.data-emissao
               p-i-r-forn = recebimento.data-movto - ordem-compra.data-pedido
               p-c-numero-nota = recebimento.numero-nota.
    ELSE
        ASSIGN p-i-r-real = 0
               p-i-r-forn = 0
               p-c-numero-nota = "0".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InicializaPrecoIpiQtde DBOProgram
PROCEDURE InicializaPrecoIpiQtde :
/*------------------------------------------------------------------------------
  Purpose:   Retorna os valores pre‡o,I.P.I. e quantidade dependendo do
             rowid passado pela tabela item-fornec.
  Parameters:
     ipar1 : r-item-fornec    = Recebe valor do r-rowid do registro da tabela it
     ipar2 : i-moeda-g        = Recebe o valor do codigo da moeda cforme parƒmet
     ipar3 : da-conv-g        = Recebe o valor da data para conversÆo cforme par
     opar4 : p-d-preco-unit   = Retorna o valor do campo Pre‡o para o browse.
     opar5 : p-d-valor-ipi    = Retorna o valor do campo I.P.I para o browse.
     opar6 : p-de-quanitidade = Retorna o valor do campo Qtde  para o browse.


  Notes:
------------------------------------------------------------------------------*/
    DEF INPUT  PARAMETER r-item-fornec    AS ROWID   NO-UNDO.
    DEF INPUT  PARAMETER i-moeda-g        AS INTEGER NO-UNDO.
    DEF INPUT  PARAMETER da-conv-g        AS DATE    NO-UNDO.
    DEF OUTPUT PARAMETER p-d-preco-unit   AS DECIMAL NO-UNDO.
    DEF OUTPUT PARAMETER p-d-valor-ipi    AS DECIMAL NO-UNDO.
    DEF OUTPUT PARAMETER p-de-quantidade  AS DECIMAL NO-UNDO.

    FOR FIRST item-fornec FIELDS(cod-emitente it-codigo)
        WHERE ROWID(item-fornec) = r-item-fornec NO-LOCK: END.
    if avail item-fornec then
        FOR FIRST ordem-compra FIELDS(cod-cond-pag)
            WHERE ordem-compra.cod-emitente = item-fornec.cod-emitente NO-LOCK: END.

        IF  AVAIL ordem-compra THEN DO:
            FOR FIRST param-compra FIELDS(ipi-sobre-preco)
                WHERE param-compra.cod-cond-pag = ordem-compra.cod-cond-pag NO-LOCK: END.
                IF  AVAIL param-compra THEN
                    ASSIGN l-preco-bruto = (param-compra.ipi-sobre-preco = 1).
                ELSE
                    ASSIGN l-preco-bruto = NO.
        END.

    FOR LAST  ordem-compra FIELDS(preco-unit aliquota-ipi perc-descto
                                  data-cotacao mo-codigo numero-ordem)
        WHERE ordem-compra.cod-emitente = item-fornec.cod-emitente
          AND ordem-compra.it-codigo    = item-fornec.it-codigo
          AND ordem-compra.num-pedido   > 0 NO-LOCK: END.

    IF  AVAIL ordem-compra THEN DO:
        IF l-preco-bruto = NO THEN DO:
           ASSIGN p-d-valor-ipi = (ordem-compra.preco-unit
                              *  ordem-compra.aliquota-ipi)
                              / (100 + ordem-compra.aliquota-ipi).
        END.
        ELSE DO:
            IF  ordem-compra.perc-descto > 0 THEN
                ASSIGN de-val-orig = (ordem-compra.preco-unit * 100)
                                   / (100 - ordem-compra.perc-descto).
            ELSE
                ASSIGN de-val-orig = ordem-compra.preco-unit.

            ASSIGN p-d-valor-ipi = (de-val-orig
                               * ordem-compra.aliquota-ipi)
                               / (100 + ordem-compra.aliquota-ipi).
        END.

        ASSIGN p-d-preco-unit = ordem-compra.preco-unit - p-d-valor-ipi
               da-data        = IF l-tabela-g THEN ordem-compra.data-cotacao
                                ELSE da-conv-g.

        IF ordem-compra.mo-codigo = i-moeda-g THEN
            de-preco-unit = ordem-compra.preco-unit.
        ELSE DO:
            RUN "cdp/cd0812.p" (INPUT ordem-compra.mo-codigo,
                                INPUT i-moeda-g,
                                INPUT ordem-compra.preco-unit,
                                INPUT da-data,
                                OUTPUT de-preco-unit).
            RUN "cdp/cd0812.p" (INPUT ordem-compra.mo-codigo,
                                INPUT i-moeda-g,
                                INPUT p-d-valor-ipi,
                                INPUT da-data,
                                OUTPUT p-d-valor-ipi).
            RUN "cdp/cd0812.p" (INPUT ordem-compra.mo-codigo,
                                INPUT i-moeda-g,
                                INPUT p-d-preco-unit,
                                INPUT da-data,
                                OUTPUT p-d-preco-unit).
        END.
    END.

    IF de-preco-unit = ? THEN de-preco-unit = 0.
    IF p-d-valor-ipi = ? THEN p-d-valor-ipi = 0.
    IF p-d-preco-unit = ? THEN p-d-preco-unit = 0.

    ASSIGN p-de-quantidade = 0.

    FOR EACH  prazo-compra FIELDS(quantidade)
        WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
        ASSIGN p-de-quantidade = p-de-quantidade + prazo-compra.quantidade.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToItem DBOProgram
PROCEDURE linkToItem :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  Handle do DBO pai.
  Notes:
------------------------------------------------------------------------------*/
    def input parameter ph-item as handle no-undo.

    RUN GetKey in ph-item (output cItem).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToItemDoForn DBOProgram
PROCEDURE linkToItemDoForn :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  Handle do DBO pai.
  Notes:
------------------------------------------------------------------------------*/
    def input parameter ph-item as handle no-undo.

    RUN GetKey in ph-item (output cItemDoForn).

    RETURN "OK":U.
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
    define input parameter iAbertura as integer no-undo.
    case iAbertura:
        when 1 then
            run openQueryStatic ("Main":U).
        when 2 then
            run openQueryStatic ("ByItem":U).
        when 3 then
            run openQueryStatic ("ByItem":U).
        when 4 then
            run openQueryStatic ("ByFornec":U).
        when 5 then
            run openQueryStatic ("ByFornecItem":U).

    end case.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByFornec DBOProgram
PROCEDURE openQueryByFornec :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    open query {&QueryName} for each {&TableName} where
                 {&TableName}.cod-emitente  = i-cod-emitente no-lock INDEXED-REPOSITION.
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByFornecItem DBOProgram
PROCEDURE openQueryByFornecItem :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
        open query {&QueryName} for each {&TableName} no-lock where
                                         {&tablename}.it-codigo = cItem
                                         by {&TableName}.cod-emitente INDEXED-REPOSITION.
        return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByItem DBOProgram
PROCEDURE openQueryByItem :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
        open query {&QueryName} for each {&TableName} where
                                         {&tablename}.it-codigo = cItem
                                         no-lock INDEXED-REPOSITION.
        return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodEmitente DBOProgram
PROCEDURE openQueryCodEmitente :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
        open query {&QueryName} for each {&TableName} where
                                         {&tablename}.it-codigo = cItem and
                                         {&TableName}.cod-emitente = i-cod-emitente
                                         no-lock INDEXED-REPOSITION.
        return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram
PROCEDURE openQueryDefault :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH item-fornec NO-LOCK INDEXED-REPOSITION.

return 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaByItCodigo DBOProgram
PROCEDURE openQueryFaixaByItCodigo :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
        open query {&QueryName} for each {&TableName} where
                                         {&tablename}.it-codigo    >= cItemIni and
                                         {&tablename}.it-codigo    <= cItemFin and
                                         {&TableName}.cod-emitente =  i-cod-emitente
                                         no-lock by it-codigo INDEXED-REPOSITION.
        return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixabyItemForn DBOProgram
PROCEDURE openQueryFaixabyItemForn :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
        open query {&QueryName} for each {&TableName} where
                                         {&tablename}.item-do-forn >= cItemFornIni and
                                         {&tablename}.item-do-forn <= cItemFornFin and
                                         {&TableName}.cod-emitente =  i-cod-emitente
                                         no-lock by item-do-forn INDEXED-REPOSITION.
        return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItemDoForn DBOProgram
PROCEDURE openQueryItemDoForn :
/*-----------------------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
------------------------------------------------------------------------*/
   open query {&QueryName} for each {&TableName} where
              {&tablename}.item-do-forn  = cItemDoForn no-lock INDEXED-REPOSITION.
    return "OK":U.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH item-fornec NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER prItem AS ROWID NO-UNDO.

    FOR FIRST ITEM FIELDS(it-codigo)
        WHERE ROWID(ITEM) = prItem NO-LOCK: END.
    IF  AVAIL ITEM THEN
        RUN setConstraintByItem (ITEM.it-codigo).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint3 DBOProgram
PROCEDURE setConstraint3 :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER prItem AS ROWID NO-UNDO.

    FOR FIRST ITEM FIELDS(it-codigo)
        WHERE ROWID(ITEM) = prItem NO-LOCK: END.
    IF  AVAIL ITEM THEN
        RUN setConstraintByItem (ITEM.it-codigo).

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
    DEF INPUT PARAMETER prEmitente AS ROWID NO-UNDO.

    RUN setConstraintByFornec (prEmitente).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByFornec DBOProgram
PROCEDURE setConstraintByFornec :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEF INPUT PARAM prEmit  AS ROWID NO-UNDO.

    FOR FIRST emitente FIELDS(cod-emitente)
        WHERE ROWID(emitente) = prEmit NO-LOCK: END.
    IF  AVAIL emitente THEN
        ASSIGN i-cod-emitente = emitente.cod-emitente.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByItem DBOProgram
PROCEDURE setConstraintByItem :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  pcItem : C¢digo do Item.
  Notes:
------------------------------------------------------------------------------*/
    def input param pcItem as char no-undo.

    assign cItem  = pcItem.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodEmitente DBOProgram
PROCEDURE setConstraintCodEmitente :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEF INPUT PARAM piCodEmitente AS INT   NO-UNDO.
    DEF INPUT PARAM pritem        AS ROWID NO-UNDO.

    FOR FIRST ITEM FIELDS(it-codigo)
        WHERE ROWID(ITEM) = prItem NO-LOCK: END.
    IF  AVAIL ITEM THEN
        ASSIGN cItem = ITEM.it-codigo.
    ASSIGN i-cod-emitente = piCodEmitente.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaByItCodigo DBOProgram
PROCEDURE setConstraintFaixaByItCodigo :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    def input param piCodEmitente  as int   no-undo.
    def input param pcitemIni      as char no-undo.
    def input param pcitemFin      as char no-undo.

    assign cItemIni       = pcitemIni
           cItemFin       = pcitemFin.
           i-cod-emitente = piCodEmitente.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaByItemForn DBOProgram
PROCEDURE setConstraintFaixaByItemForn :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    def input param piCodEmitente    as int   no-undo.
    def input param pcitemfornIni    as char no-undo.
    def input param pcitemfornFin    as char no-undo.

    assign cItemFornIni   = pcitemfornIni
           cItemFornFin   = pcitemfornFin.
           i-cod-emitente = piCodEmitente.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItemDoForn DBOProgram
PROCEDURE setConstraintItemDoForn :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  pcItemdoForn : C¢digo do Item do Fornecedor.
  Notes:
------------------------------------------------------------------------------*/
    def input param pcItemdoForn as char no-undo.

    assign cItemDoForn  = pcItemdoForn.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setExecCC0106 DBOProgram
PROCEDURE setExecCC0106 :
/*------------------------------------------------------------------------------
  Purpose:     Esta procedure informa que a execu‡Æo est  sendo feita via cc0106a (boin00948).
               Isso se faz necess rio para nÆo executar a procedure atualizaUnidMedItemFornec.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    ASSIGN l-exec-cc0106 = TRUE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaItemFornecAtivo DBOProgram
PROCEDURE validaItemFornecAtivo :
/*------------------------------------------------------------------------------
  Purpose: Verifica se o relacionamento Item x Fornecedor está ativo
           para a associação de ordens de compra a pedidos.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    define input parameter pcItCodigo    as character no-undo.
    define input parameter piCodEmitente as integer   no-undo.

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = pcItCodigo NO-ERROR.

    IF AVAILABLE ITEM AND ITEM.tipo-contr <> 4 THEN DO:
        FIND FIRST item-fornec
             WHERE item-fornec.it-codigo    = pcItCodigo
               AND item-fornec.cod-emitente = piCodEmitente NO-LOCK NO-ERROR.

        IF AVAIL item-fornec THEN DO:
            IF NOT item-fornec.ativo THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="2155"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="' '"}
            END.
        END.
        ELSE DO:
            {method/svc/errors/inserr.i &ErrorNumber="3306"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="' '"}
        END.
    END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCOFINS DBOProgram
PROCEDURE validateCOFINS :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
def input  parameter i-cod-emitente    as int                                  no-undo.
def input  parameter c-rs-trib-cofins  as char                                 no-undo.
def input  parameter d-aliq-cofins     as dec  format ">>,>>":u      initial 0 no-undo.
def input  parameter d-val-uni-cofins  as dec  format ">>>>,>>>>>":u initial 0 no-undo.

    FIND {&TableName} WHERE
         {&tablename}.it-codigo    = item.it-codigo AND
         {&TableName}.cod-emitente = i-cod-emitente
         EXCLUSIVE-LOCK NO-ERROR.

    IF  AVAIL {&TableName} THEN DO:
        &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
            ASSIGN {&tablename}.idi-tributac-cofins = int(c-rs-trib-cofins)
                   {&TableName}.val-aliq-cofins     = d-aliq-cofins
                   {&tableName}.val-unit-cofins     = d-val-uni-cofins.
            RELEASE {&TableName}.
            RETURN "OK":U.
        &ELSE
            ASSIGN OVERLAY({&TableName}.CHAR-1,8,1)   = STRING(c-rs-trib-cofins,"x(1)":U)
                   OVERLAY({&TableName}.char-1,9,5)   = STRING(DEC(d-aliq-cofins), ">9.99":U)
                   OVERLAY({&TableName}.char-1,24,10) = STRING(DEC(d-val-uni-cofins), ">>>9.99999":U).
            RELEASE {&TableName}.
            RETURN "OK":U.
        &ENDIF
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateUM DBOProgram
PROCEDURE validateUM :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
define input parameter it-codigo    like item-fornec-umd.it-codigo          no-undo.
define input parameter cod-emitente like item-fornec-umd.cod-emitente       no-undo.
define input parameter unid-med-for like item-fornec-umd.unid-med-for       no-undo.

    IF CAN-FIND(FIRST {&TableName}
                            WHERE {&TableName}.it-codigo    = it-codigo
                            AND   {&TableName}.cod-emitente = cod-emitente
                            AND   {&TableName}.unid-med-for = unid-med-for
                            and   {&TableName}.ativo) THEN DO:

        DEFINE VARIABLE c-lbl-liter-item-x-un AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Item_X_UN" *}
        ASSIGN c-lbl-liter-item-x-un = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-unidade-de-medida AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Unidade_de_Medida" *}
        ASSIGN c-lbl-liter-unidade-de-medida = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="32682"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="c-lbl-liter-item-x-un + '~~~~' + c-lbl-liter-unidade-de-medida"}

    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validatePIS DBOProgram
PROCEDURE validatePIS :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    def input  parameter i-cod-emitente as int                                  no-undo.
    def input  parameter c-rs-trib-pis  as char                                 no-undo.
    def input  parameter d-aliq-pis     as dec  format ">>,>>":u      initial 0 no-undo.
    def input  parameter d-val-uni-pis  as dec  format ">>>>,>>>>>":u initial 0 no-undo.

    FIND {&TableName} WHERE
         {&tablename}.it-codigo    = item.it-codigo AND
         {&TableName}.cod-emitente = i-cod-emitente
         EXCLUSIVE-LOCK NO-ERROR.

    IF  AVAIL {&TableName} THEN DO:
        &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
             ASSIGN {&tablename}.idi-tributac-pis = int(c-rs-trib-pis)
                    {&TableName}.val-aliq-pis     = d-aliq-pis
                    {&tableName}.val-unit-pis     = d-val-uni-pis.
             RELEASE {&TableName}.
             RETURN "OK":U.
        &ELSE
             ASSIGN OVERLAY({&TableName}.CHAR-1,1,1) = STRING(c-rs-trib-pis,"x(1)":U)
                    OVERLAY({&TableName}.char-1,2,5) = STRING(DEC(d-aliq-pis), ">9.99":U)
                    OVERLAY({&TableName}.char-1,14,10) = STRING(DEC(d-val-uni-pis), ">>>9.99999":U).
             RELEASE {&TableName}.
             RETURN "OK":U.
        &ENDIF
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
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

    FIND FIRST rowObject NO-ERROR.
    if avail rowObject then do:

        if  pType = "Create":U then do:
            if can-find(first b-item-fornec
                        where b-item-fornec.it-codigo    = rowObject.it-codigo
                          AND b-item-fornec.cod-emitente = rowObject.cod-emitente) then do:

                    {utp/ut-liter.i "Item_Fornecedor" *} /* Verifica se ja existe item fornecedor cadastrado */
                    {method/svc/errors/inserr.i &ErrorNumber="4242"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters=TRIM(RETURN-VALUE)}
            end.
        END.

        if  pType = "Create":U or pType = "Update":U then do:
            IF rowObject.fator-conver = 0 THEN DO:
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-fator-de-conversao AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Fator_de_ConversÆo" *}
               ASSIGN c-lbl-liter-fator-de-conversao = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i &ErrorNumber="17340"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="c-lbl-liter-fator-de-conversao"}

            END.

            IF NOT CAN-FIND(FIRST mguni.moeda
                            WHERE moeda.mo-codigo = INTEGER(SUBSTRING(rowObject.char-2,3,2))) THEN DO:
                 /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-moeda-padrao AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Moeda_PadrÆo" *}
                    ASSIGN c-lbl-liter-moeda-padrao = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i &ErrorNumber="7381"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="c-lbl-liter-moeda-padrao"}
            END.

            if rowObject.item-do-forn = "" then do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-item-do-fornecedor AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Item_do_Fornecedor" *}
                    ASSIGN c-lbl-liter-item-do-fornecedor = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i &ErrorNumber="265"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="c-lbl-liter-item-do-fornecedor"}
            end.


            if rowObject.cod-cond-pag <> 0 then do:
                if not can-find(first cond-pagto
                                where cond-pagto.cod-cond-pag = rowObject.cod-cond-pag) then do:
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-table.i mgadm cond-pagto 1} /* Busca o label da tabela */
                    {method/svc/errors/inserr.i &ErrorNumber="2"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters=TRIM(RETURN-VALUE)}
                end.
            end.

            if not can-find(first emitente
                            where emitente.cod-emitente = rowObject.cod-emitente
                            and   emitente.identific    <> 1) then do:
                FIND FIRST b-emitente WHERE b-emitente.cod-emitente = rowObject.cod-emitente NO-LOCK NO-ERROR.
                IF AVAIL b-emitente THEN
                    ASSIGN c-cgc = b-emitente.cgc.
                ELSE ASSIGN c-cgc = "".

                {method/svc/errors/inserr.i &ErrorNumber="51594"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="string(RowObject.cod-emitente) + '~~~~' + string(c-cgc)"}
            END.

            if not can-find(first tab-unidade
                            where tab-unidade.un = rowObject.unid-med-for) then do:
                {method/svc/errors/inserr.i &ErrorNumber="846"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U}

            end.

            /*In¡cio Valida‡Æo do Percentual de Compra*/
            assign de-soma = 0
                   de-soma = RowObject.perc-compra. /*grava o novo percentual*/

            for each b-item-fornec fields(it-codigo cod-emitente ativo perc-compra) no-lock
                where b-item-fornec.it-codigo = RowObject.it-codigo /*item-fornec.it-codigo*/
                  and b-item-fornec.ativo
                  and rowid(b-item-fornec) <> rowid(item-fornec): /*desconsidera o percentual antigo do
                                                                    registro que est  sendo modificado*/
                assign de-soma = de-soma + b-item-fornec.perc-compra.
            END.
            if  (RowObject.perc-compra = 0 and RowObject.contr-forn)
            or  de-soma > 100 then do:
                {method/svc/errors/inserr.i &ErrorNumber="1189"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U}
            end.
            /*Fim Valida‡Æo Percentual de Compra*/

            /*valida se a classe reprogramação contem um valor entre 1 e 4*/
            if  RowObject.classe-repro <> 1
            and RowObject.classe-repro <> 2
            and RowObject.classe-repro <> 3
            and RowObject.classe-repro <> 4 then do:
                {method/svc/errors/inserr.i &ErrorNumber="56085"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U}
            end.

            /*valida se a Tributação PIS contem um valor entre 1 e 4*/
            if  RowObject.idi-tributac-pis <> 1
            and RowObject.idi-tributac-pis <> 2
            and RowObject.idi-tributac-pis <> 3
            and RowObject.idi-tributac-pis <> 4 then do:
                {method/svc/errors/inserr.i &ErrorNumber="56086"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U}
            end.

            /*valida se a Tributação COFINS contem um valor entre 1 e 4*/
            if  RowObject.idi-tributac-cofins <> 1
            and RowObject.idi-tributac-cofins <> 2
            and RowObject.idi-tributac-cofins <> 3
            and RowObject.idi-tributac-cofins <> 4 then do:
                {method/svc/errors/inserr.i &ErrorNumber="56087"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U}
            end.

            /*Valida‡Æo para o campo Embalagem  */
            &if '{&bf_mat_versao_ems}' >= '2.062' &then /* INICIO PREPROCESSADOR VERSAO*/
                IF  (param-global.log-modul-eq = YES) AND (param-global.MODULO-07 = YES) AND (RowObject.cod-embal <> "") THEN DO:
                    IF NOT CAN-FIND (FIRST eq-item-embal-embarq
                                     WHERE eq-item-embal-embarq.it-codigo = RowObject.it-codigo
                                     AND   eq-item-embal-embarq.cod-embal = RowObject.cod-embal NO-LOCK) THEN DO:
                        /* Inicio -- Projeto Internacional */
                        {utp/ut-table.i mgdis eq-item-embal-embarq 1} /* Busca o label da tabela */
                        {method/svc/errors/inserr.i &ErrorNumber="2"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U
                                                    &ErrorParameters=TRIM(RETURN-VALUE) + '~~~~' + 'CD0128'}
                    END.
                END.

                IF  param-global.modulo-07 THEN DO:
                    IF  NOT VALID-HANDLE(h-boin178i) THEN
                        RUN inbo/boin178i.p PERSISTENT SET h-boin178i.
                    RUN openQueryStatic IN h-boin178i("main":U).
                    RUN emptyRowErrors IN h-boin178i.
                    RUN setRecord IN h-boin178i(INPUT TABLE rowObject).
                    RUN validateFabricPais IN h-boin178i.
                    RUN getRowErrors IN h-boin178i(OUTPUT TABLE rowErrors APPEND).
                    DELETE PROCEDURE h-boin178i NO-ERROR.
                    ASSIGN h-boin178i = ?.
                END.

            &endif   /* FIM PREPROCESSADOR VERSAO*/
        end.

        if pType = "Create":U then do:
            &if defined (bf_mat_bloqueio_fornec) &then
                run ExecuteValidateStatusFornec.
            &endif
        end.

        if pType = "Update":U then do:
            &if defined (bf_mat_bloqueio_fornec) &then
                for first b-item-fornec fields (ativo)
                    where rowid(b-item-fornec) = RowObject.r-rowid no-lock: end.
                /**valida a situacao do fornecedor antes de modificar para ativo**/
                if (avail b-item-fornec
                and b-item-fornec.ativo <> rowObject.ativo
                and rowObject.ativo) then
                    run ExecuteValidateStatusFornec.
            &endif

            if  (   RowObject.fator-conver <> {&TableName}.fator-conver
                or  RowObject.num-casa-dec <> {&TableName}.num-casa-dec)
            and can-find(first ordem-compra
                         where ordem-compra.it-codigo    = RowObject.it-codigo
                         and   ordem-compra.cod-emitente = RowObject.cod-emitente
                         and   ordem-compra.situacao     = 2 /*Confirmada*/ ) then do:

                if can-find (first funcao
                             where funcao.cd-funcao = "spp-ValidaConvItem":U
                             and   funcao.ativo) then do:
                    {method/svc/errors/inserr.i &ErrorNumber="34110"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="RowObject.it-codigo + '~~~~' + string(RowObject.cod-emitente)"}
                end.
                else do:
                    {method/svc/errors/inserr.i &ErrorNumber="34111"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="WARNING":U
                                                &ErrorParameters="RowObject.it-codigo + '~~~~' + string(RowObject.cod-emitente)"}
                end.
            end.


            IF CAN-FIND(FIRST item-fornec-umd
                            WHERE item-fornec-umd.it-codigo    = RowObject.it-codigo
                            AND   item-fornec-umd.cod-emitente = RowObject.cod-emitente
                            AND   item-fornec-umd.unid-med-for = RowObject.unid-med-for
                            AND   item-fornec-umd.log-ativo) THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-item-x-un AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Item_X_UN" *}
                ASSIGN c-lbl-liter-item-x-un = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-unidade-de-medida AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Unidade_de_Medida" *}
                ASSIGN c-lbl-liter-unidade-de-medida = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="32682"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="c-lbl-liter-item-x-un + '~~~~' + c-lbl-liter-unidade-de-medida"}
            END.
        end.

        IF pType = "Delete":U THEN DO:
            FOR FIRST ITEM FIELDS(tipo-contr)
                WHERE ITEM.it-codigo = {&tablename}.it-codigo NO-LOCK: END.
            IF  AVAIL ITEM
            AND item.tipo-contr <> 4 /* Debito Direto */ THEN do:

                /** *************    Valida‡Æo da Trigger   ************** **/
                IF  CAN-FIND(FIRST item-contrat
                             WHERE item-contrat.it-codigo    = item-fornec.it-codigo
                               AND item-contrat.cod-emitente = item-fornec.cod-emitente) THEN DO:
                        {method/svc/errors/inserr.i &ErrorNumber="6801"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="''"}
                END.

                IF CAN-FIND(FIRST cotacao-item
                            WHERE cotacao-item.cod-emitente = item-fornec.cod-emitente
                              AND cotacao-item.it-codigo    = item-fornec.it-codigo
                              AND cotacao-item.cot-aprovada ) THEN DO:
                        {method/svc/errors/inserr.i &ErrorNumber="6802"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="''"}
                END.
                /** Fim das valida‡äes de elimina‡Æo **/
            END.
        END.



        IF RowObject.cod-unid-calc-pis     <> "":U AND
           SUBSTRING(RowObject.char-2,1,1) <> "":U AND
           SUBSTRING(RowObject.char-2,1,1) = "S":U THEN DO:

            IF NOT CAN-FIND(FIRST tab-unidade
                            WHERE tab-unidade.un = RowObject.cod-unid-calc-pis) THEN DO:
                {utp/ut-liter.i "Unidade_Medida_PIS" *}

                {method/svc/errors/inserr.i &ErrorNumber="47"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="TRIM(RETURN-VALUE)"}
            END.
        END.

        IF RowObject.cod-unid-calc-cofins  <> "":U AND
           SUBSTRING(RowObject.char-2,2,1) <> "":U AND
           SUBSTRING(RowObject.char-2,2,1) = "S":U THEN DO:

            IF NOT CAN-FIND(FIRST tab-unidade
                            WHERE tab-unidade.un = RowObject.cod-unid-calc-cofins) THEN DO:

                {utp/ut-liter.i "Unidade_Medida_COFINS" *}

                {method/svc/errors/inserr.i &ErrorNumber="47"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="TRIM(RETURN-VALUE)"}
            END.
        END.

    end.
    /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaContratoCotacaoItem DBOProgram
PROCEDURE verificaContratoCotacaoItem :
/*------------------------------------------------------------------------------
  Purpose:   Verifica se o Item possui ordem de compra com contrato e/ou cota‡Æo para este Fornecedor.
             Se possuir, emite um aviso e pergunta se deseja continuar ou nÆo.
  Parameters: ipar1  : p-rowid    : recebe rowid item-fornec
              opar2  : RowErrors  : retorna temp-table de erro.
  Notes:
------------------------------------------------------------------------------*/

   DEF INPUT  PARAM p-rowid AS ROWID.
   DEF OUTPUT PARAMETER TABLE FOR RowErrors.

   FOR FIRST item-fornec FIELDS(cod-emitente it-codigo)
       WHERE ROWID(item-fornec) = p-rowid NO-LOCK: END.
   IF  AVAIL item-fornec
   AND CAN-FIND(FIRST ITEM WHERE ITEM.it-codigo = item-fornec.it-codigo) THEN DO:
       FOR FIRST ordem-compra FIELDS(nr-contrato)
            WHERE ordem-compra.it-codigo = item-fornec.it-codigo
              AND ordem-compra.cod-emitente = item-fornec.cod-emitente
            &if defined(bf_mat_contratos) &then
              AND ordem-compra.nr-contrato > 0
            &else
              AND ordem-compra.nr-contrato > ""
            &endif
            NO-LOCK: END.
       IF  AVAIL ordem-compra
       AND CAN-FIND(FIRST contrato-for
                    WHERE contrato-for.nr-contrato = ordem-compra.nr-contrato
                      AND contrato-for.cod-emitente = item-fornec.cod-emitente) THEN DO:
           {method/svc/errors/inserr.i &ErrorNumber="16059"
                                       &ErrorType="EMS":U
                                       &ErrorSubType="INFORMATION":U}
       END.

       IF  CAN-FIND (FIRST cotacao-item
                     WHERE cotacao-item.it-codigo    = item-fornec.it-codigo
                       AND cotacao-item.cod-emitente = item-fornec.cod-emitente) THEN DO:
           {method/svc/errors/inserr.i &ErrorNumber="1191"
                                       &ErrorType="EMS":U
                                       &ErrorSubType="INFORMATION":U
                                       &ErrorParameters="'{&TableName}'"}
       END.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaUnidMedItemFornec DBOProgram
PROCEDURE verificaUnidMedItemFornec :
/*------------------------------------------------------------------------------
  Purpose: Verifica se o Item possui solicita‡äes de Compras e/ou Ordens de Compras
           com unidades de medida diferentes. Caso exista, ele retorna erro e nao permite
           inclusao/modifica‡Æo.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
   DEF INPUT  PARAM prItem      AS ROWID. /* recebe rowid item */
   DEF INPUT  PARAM prItemForn  AS ROWID. /* rowid item-fornec */

   FOR FIRST item FIELDS(tipo-contr it-codigo un)
       WHERE ROWID(item) = prItem NO-LOCK: END.
   FOR FIRST item-fornec FIELDS(cod-emitente it-codigo unid-med-for)
       WHERE ROWID(item-fornec) = prItemForn NO-LOCK: END.
   IF  AVAIL ITEM
   AND item.tipo-contr = 4 THEN DO :
       IF  CAN-FIND(FIRST it-requisicao
                    WHERE it-requisicao.it-codigo = item.it-codigo
                      AND it-requisicao.un <> item.un) THEN DO:
           {method/svc/errors/inserr.i &ErrorNumber="7916"
                                       &ErrorType="EMS":U
                                       &ErrorSubType="ERROR":U
                                       &ErrorParameters="' '"}
       END.

       IF  CAN-FIND(FIRST prazo-compra
                    WHERE prazo-compra.it-codigo  =  item.it-codigo
                      AND prazo-compra.un         <> item.un
                      AND prazo-compra.situacao   <> 4 /*Eliminada*/) THEN DO:
           {method/svc/errors/inserr.i &ErrorNumber="7917"
                                       &ErrorType="EMS":U
                                       &ErrorSubType="ERROR":U
                                       &ErrorParameters="' '"}
       END.

       IF  CAN-FIND (FIRST cotacao-item
                     WHERE cotacao-item.cod-emitente = item-fornec.cod-emitente
                       AND cotacao-item.it-codigo    = item-fornec.it-codigo
                       AND cotacao-item.un          <> item-fornec.unid-med-for) then do:
           {method/svc/errors/inserr.i &ErrorNumber="7918"
                                       &ErrorType="EMS":U
                                       &ErrorSubType="ERROR":U
                                       &ErrorParameters="' '"}
       END.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

