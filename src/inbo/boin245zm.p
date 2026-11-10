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
{include/i-prgvrs.i BOIN245ZM 2.00.00.064 } /*** "010064" 14/12/2023 16:32:19  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i BOIN245 MEN}
&ENDIF

/*--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) é um programa PROGRESS 
                 que contém a lógica de negócio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE KeyField1 nat-operacao /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
/* &GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES */

&GLOBAL-DEFINE DBOName BOIN245
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName natur-oper
&GLOBAL-DEFINE TableLabel Natureza de Opera‡Æo
&GLOBAL-DEFINE QueryName qr{&TableName} 
&GLOBAL-DEFINE ROW-NUM-DEFINED NO

{utp/ut-glob.i}
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}
{include/tt-edit.i}
{include/pi-edit.i}

&if defined (bf_dis_versao_ems) &then
&else
    &GLOBAL-DEFINE bf_dis_versao_ems 2.00
&endif

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin245.i RowObject}

{dibo/bodi159.i RowPedvenda}
{dibo/bodi159.i RowPedvendaAux}

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}

{cdp/cd7300.i1}
{cdp/cdapi204.i}

/*--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE BUFFER b-natur-oper FOR natur-oper.
def var h-boin245val     as handle no-undo.
def var h-bodi159        as handle no-undo.
DEF VAR h-acompanhamento AS HANDLE NO-UNDO.

def var cIniNatOperacao as char   no-undo.
def var cEndNatOperacao as char   no-undo.
def var cIniDenominacao as char   no-undo.
def var cEndDenominacao as char   no-undo.
def var iNatAtiva       as int    no-undo.
def var cIniCodCFOP     as char   no-undo.

def var i-sequencia          as int no-undo.
def var i-cod-mensagem-ant   as int no-undo.

def var l-atualizar-mensagem as log init yes no-undo.

def var l-atualizar-mp as log init yes no-undo.

def var c-InfAdic-cfop as char no-undo.
 
DEF VAR l-funcao-spp-ent-fut AS LOG NO-UNDO INITIAL NO.

ASSIGN l-funcao-spp-ent-fut = CAN-FIND(FIRST funcao
                                      WHERE funcao.cd-funcao = "spp-ent-fut":U
                                      AND   funcao.ativo).


/*Integra‡Æo EAI*/
define new global shared variable v_log_eai_habilit as log  no-undo.
define new global shared variable v-prog-version    as char no-undo.
define new global shared variable v-prog-obj        as char no-undo.

def var l-del as logical init no no-undo.
    
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
         HEIGHT             = 1.42
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

find param-global no-lock.

def temp-table RowErrorsAux like RowErrors.

def temp-table tt-natur-oper-eai no-undo like natur-oper.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

/* {inbo/boin245.i1} /* findCodigo e goToKey */  */

/*
**  BOIN245
**
**  Procedures goToKey e FindNatureza : estas procedures foram
**  transformadas em include pois este codigo e comum aos produtos EMS e
**  Magnus.
**
*/

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNatureza DBOProgram 
PROCEDURE findNatureza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  parameter c-nat-operacao as char no-undo.
    def output parameter c-return       as char no-undo.
 
    find natur-oper where
         natur-oper.nat-operacao = c-nat-operacao no-lock no-error.
    if  not avail natur-oper then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Natureza_de_Operação" *}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input RETURN-VALUE).
        assign c-return = return-value.
    end.
    else do:
        run _copyBuffer2TT.
    end.

END PROCEDURE.
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice natureza
  Parameters:  
               recebe valor do campo nat-operacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnat-operacao LIKE natur-oper.nat-operacao NO-UNDO.

    FIND FIRST bfnatur-oper WHERE
        bfnatur-oper.nat-operacao = pnat-operacao NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfnatur-oper THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfnatur-oper)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if l-atualizar-mp then do:
    
        {cdp/cd7300.i13 "001" "'DIS003'"}
    
        if  param-global.modulo-mp and
            tt-replica-msg.log-replica-msg then do:
            create tt-natur-oper-aux.
            buffer-copy RowObject except r-Rowid to tt-natur-oper-aux.
            create tt-dados-env.
            assign tt-dados-env.num-sequencia  = i-sequencia
                   tt-dados-env.cod-tipo-reg   = 10
                   tt-dados-env.ind-tipo-movto = 1
                   tt-dados-env.identif-msg    = RowObject.nat-operacao.
            raw-transfer tt-natur-oper-aux to tt-dados-env.conteudo-msg.
            assign i-sequencia = i-sequencia + 1.
        end.
    
        {cdp/cd7300.i14 "001" "'DIS003'"}
    
    end.

     /* Integra‡Æo EAI */
    &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then 
        if v_log_eai_habilit then do:
         
           if can-find(first tt-natur-oper-eai) then
            empty temp-table tt-natur-oper-eai no-error.

         create tt-natur-oper-eai.
         buffer-copy RowObject except r-rowid to tt-natur-oper-eai no-error.
                                                   
         run adapters/xml/vd2/axsvd002.p (input "add":U,
                                               input v-prog-obj,
                                               input v-prog-version,
                                               input table tt-natur-oper-eai,
                                               output table RowErrors).
           empty temp-table tt-natur-oper-eai no-error. 

          return (if can-find(first RowErrors) then "NOK":U
                else "OK":U).
       end.
   &endif.
     
    return "OK".

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

 /* Integra‡Æo EAI */
 &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
   if v_log_eai_habilit then do:
      if l-del then do:
       
          run adapters/xml/vd2/axsvd002.p (input "del":U,
                                               input v-prog-obj,
                                               input v-prog-version,
                                               input table tt-natur-oper-eai,
                                               output table RowErrors).
          assign l-del = no.

          if can-find(first tt-natur-oper-eai) then
                empty temp-table tt-natur-oper-eai no-error.

          return (if can-find(first RowErrors) then "NOK":U
                    else "OK":U).
       end.
   end.
  
 &endif
    
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

    def var i-qtde-registros as int no-undo.

    if l-atualizar-mp then do:

        {cdp/cd7300.i13 "001" "'DIS003'"}
    
        if  param-global.modulo-mp and
            tt-replica-msg.log-replica-msg then do:
            create tt-natur-oper-aux.
            buffer-copy RowObject except r-Rowid to tt-natur-oper-aux.
            create tt-dados-env.
            assign tt-dados-env.num-sequencia  = i-sequencia
                   tt-dados-env.cod-tipo-reg   = 10
                   tt-dados-env.ind-tipo-movto = 2
                   tt-dados-env.identif-msg    = RowObject.nat-operacao.
            raw-transfer tt-natur-oper-aux to tt-dados-env.conteudo-msg.
            assign i-sequencia = i-sequencia + 1.
        end.
    
        {cdp/cd7300.i14 "001" "'DIS003'"}

    end.

    if  RowObject.cod-mensagem <> i-cod-mensagem-ant and
        l-atualizar-mensagem then do:
        if  not session:remote then do:
            run utp/ut-acomp.p persistent set h-acompanhamento.
            run pi-inicializar in h-acompanhamento("Alterando as Mensagens do Pedido.").
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Verificando_os_Pedidos" *}
            run pi-acompanhar in h-acompanhamento(RETURN-VALUE).
        end.

        for each ped-venda use-index ch-natoper
            where ped-venda.cod-sit-ped  < 2
            and ped-venda.nat-operacao = RowObject.nat-operacao
            and ped-venda.cod-mensagem = i-cod-mensagem-ant exclusive-lock:
            
            if  not session:remote THEN
                /* Inicio -- Projeto Internacional */
                DO:
                DEFINE VARIABLE c-lbl-liter-nome-abreviado AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Nome_Abreviado" *}
                ASSIGN c-lbl-liter-nome-abreviado = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-pedido AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Pedido" *}
                ASSIGN c-lbl-liter-pedido = TRIM(RETURN-VALUE).
                run pi-acompanhar in h-acompanhamento(c-lbl-liter-nome-abreviado + ": " + ped-venda.nome-abrev + " | " + 
                                                      c-lbl-liter-pedido + ": " + ped-venda.nr-pedcli + ".").
                END. 
            assign ped-venda.cod-mensagem = RowObject.cod-mensagem.
        end.

        if  not session:remote then do:
            if  valid-handle(h-acompanhamento) then do:
                run pi-finalizar in h-acompanhamento.
                assign h-acompanhamento = ?.
            end.
        end.
    end.

    /* Integra‡Æo EAI */
    &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then 
        if v_log_eai_habilit then do:
      
          if can-find(first tt-natur-oper-eai) then
            empty temp-table tt-natur-oper-eai no-error.

         create tt-natur-oper-eai.
         buffer-copy RowObject except r-rowid to tt-natur-oper-eai no-error.
           
         run adapters/xml/vd2/axsvd002.p (input "upd":U,
                                               input v-prog-obj,
                                               input v-prog-version,
                                               input table tt-natur-oper-eai,
                                               output table RowErrors).
          empty temp-table tt-natur-oper-eai no-error. 
         
          return (if can-find(first RowErrors) then "NOK":U
                else "OK":U).

     end.
    
     &endif.
     
    return "OK".
                      
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

    if l-atualizar-mp then do:
  
      {cdp/cd7300.i13 "001" "'DIS003'"}
  
      if  param-global.modulo-mp and
          tt-replica-msg.log-replica-msg then do: 
          create tt-natur-oper-aux.
          buffer-copy RowObject except r-rowid to tt-natur-oper-aux.
          create tt-dados-env.                  
          assign tt-dados-env.num-sequencia  = i-sequencia
                 tt-dados-env.cod-tipo-reg   = 10
                 tt-dados-env.ind-tipo-movto = 3
                 tt-dados-env.identif-msg    = RowObject.nat-operacao
                 i-sequencia                 = i-sequencia + 1.
          raw-transfer tt-natur-oper-aux to tt-dados-env.conteudo-msg.
      end.
  
      {cdp/cd7300.i14 "001" "'DIS003'"}
  
   end.

    /* Integra‡Æo EAI */
    &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then 
        if v_log_eai_habilit then do:
         
         create tt-natur-oper-eai.
         buffer-copy RowObject except r-rowid to tt-natur-oper-eai no-error.
                   
         assign l-del = yes.
           
        end.
    &endif.
    
    return "OK".

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

    assign i-cod-mensagem-ant = natur-oper.cod-mensagem.

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE convertOperationType DBOProgram 
PROCEDURE convertOperationType :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input        param p-resultado        as int no-undo. /* (1) campos da tabela (0,2,3...) tipo opera‡Æo */
    def input-output param p-tipo-operacao    as int no-undo.
    def input-output param p-tipo-entrega     as int no-undo. /* char-1,1,5 */
    def input-output param p-nota-faturamento as log no-undo. /* natur-oper.ind-entfut */
    def input-output param p-nota-remessa     as log no-undo. /* natur-oper.ind-est-qtd */
    
    /**************************************************************
    ** Tipos de Opera‡äes Entrega Futura/ Faturamento Antecipado
    **
    **   1 - Nenhum/Faturamento Presente
    **   2 - Faturamento Antecipado
    **   3 - Remessa de Faturamento Antecipado
    **   4 - Faturamento com Entrega Futura
    **   5 - Remessa de Entrega Futura
    **   Outros Valores - Nenhum/Faturamento Presente
    **
    **************************************************************/

    if  p-resultado = 1 then do:
        case p-tipo-operacao:
            when 1 then
                   assign p-tipo-entrega     = 1
                          p-nota-faturamento = no
                          p-nota-remessa     = no.
            when 2 then
                   assign p-tipo-entrega     = 1
                          p-nota-faturamento = yes
                          p-nota-remessa     = no.
            when 3 then
                   assign p-tipo-entrega     = 1
                          p-nota-faturamento = no
                          p-nota-remessa     = yes.
            when 4 then
                   assign p-tipo-entrega     = 2
                          p-nota-faturamento = yes
                          p-nota-remessa     = no.
            when 5 then
                   assign p-tipo-entrega     = 2
                          p-nota-faturamento = no
                          p-nota-remessa     = yes.
            otherwise
                   assign p-tipo-entrega     = 1
                          p-nota-faturamento = no
                          p-nota-remessa     = no.
        end case.
    end.
    else do:
        if  p-tipo-entrega = 1 then do:

            if  not p-nota-faturamento and
                not p-nota-remessa then
                assign p-tipo-operacao = 1.

            if  p-nota-faturamento and
                not p-nota-remessa then
                assign p-tipo-operacao = 2.

            if  not p-nota-faturamento and
                p-nota-remessa then
                assign p-tipo-operacao = 3.

        end.
        else do:
            if  p-tipo-entrega = 2 then do:

                /******************************************
                ** Assume 1 apenas por conven‡Æo, a com- **
                ** bina‡Æo abaixo nÆo existe nesse caso  **
                *******************************************/
                if  not p-nota-faturamento and
                    not p-nota-remessa then
                    assign p-tipo-operacao = 1.

                if  p-nota-faturamento and
                    not p-nota-remessa then
                    assign p-tipo-operacao = 4.

                if  not p-nota-faturamento and
                    p-nota-remessa then
                    assign p-tipo-operacao = 5.

            end.
            else
                assign p-tipo-operacao = 1.
        end.
    end.

    return "OK":U.

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
        WHEN "cd-registro":U THEN ASSIGN pFieldValue = RowObject.cd-registro.
        WHEN "cd-vinc-ipi":U THEN ASSIGN pFieldValue = RowObject.cd-vinc-ipi.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        
        &if defined(bf-mat-comex) &then            
            WHEN "narrativa":U THEN ASSIGN pFieldValue = string(RowObject.narrativa[1] + RowObject.narrativa[2] + RowObject.narrativa[3]).
            WHEN "cd-trib-icm":U THEN ASSIGN pFieldValue = RowObject.cd-trib-icm.
            WHEN "cd-trib-ipi":U THEN ASSIGN pFieldValue = RowObject.cd-trib-ipi.
            WHEN "cd-trib-iss":U THEN ASSIGN pFieldValue = RowObject.cd-trib-iss.
            WHEN "mercado":U THEN ASSIGN pFieldValue = RowObject.mercado.
        &else
            WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
            WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
            WHEN "ct-cusven":U THEN ASSIGN pFieldValue = RowObject.ct-cusven.
            WHEN "ct-recven":U THEN ASSIGN pFieldValue = RowObject.ct-recven.
            WHEN "ct-transven":U THEN ASSIGN pFieldValue = RowObject.ct-transven.
            WHEN "sc-cusven":U THEN ASSIGN pFieldValue = RowObject.sc-cusven.
            WHEN "sc-recven":U THEN ASSIGN pFieldValue = RowObject.sc-recven.
            WHEN "sc-transven":U THEN ASSIGN pFieldValue = RowObject.sc-transven.
            &if defined (bf_dis_desc_bonif) &then
                WHEN "cod-natur-oper-bonif":U THEN ASSIGN pFieldValue = RowObject.cod-natur-oper-bonif.
            &endif
        &endif
        WHEN "cod-esp":U THEN ASSIGN pFieldValue = RowObject.cod-esp.
        WHEN "denominacao":U THEN ASSIGN pFieldValue = RowObject.denominacao.
        WHEN "especie-doc":U THEN ASSIGN pFieldValue = RowObject.especie-doc.
        &if {&bf_dis_versao_ems} >= 2.03 &then
        WHEN "form-cfop":U THEN ASSIGN pFieldValue = RowObject.form-cfop.
        WHEN "log-nota-comercio":U THEN ASSIGN pFieldValue = RowObject.log-nota-comercio.
        WHEN "modelo-cupom":U THEN ASSIGN pFieldValue = RowObject.modelo-cupom.
        &endif
        WHEN "modelo-docto":U THEN ASSIGN pFieldValue = RowObject.modelo-docto.
        WHEN "nat-comp":U THEN ASSIGN pFieldValue = RowObject.nat-comp.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nat-vinculada":U THEN ASSIGN pFieldValue = RowObject.nat-vinculada.
        WHEN "tp-base-icm":U THEN ASSIGN pFieldValue = RowObject.tp-base-icm.
        WHEN "cod-cfop":U THEN ASSIGN pFieldValue = 
                                        &if defined(bf_dis_formato_CFOP) &then
                                             natur-oper.cod-cfop
                                        &else
                                             trim(substr(natur-oper.char-1,45,10))
                                        &ENDIF .


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
        &if defined(bf-mat-comex) &then            
        &else
            WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
            WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "aliq-icm-com":U THEN ASSIGN pFieldValue = RowObject.aliq-icm-com.
        WHEN "aliquota-icm":U THEN ASSIGN pFieldValue = RowObject.aliquota-icm.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        &if {&bf_dis_versao_ems} >= 2.03 &then
        WHEN "dest-red-icms":U THEN ASSIGN pFieldValue = RowObject.dest-red-icms.
        &endif
        WHEN "icms-subs-trib":U THEN ASSIGN pFieldValue = RowObject.icms-subs-trib.
        WHEN "per-des-icms":U THEN ASSIGN pFieldValue = RowObject.per-des-icms.
        WHEN "per-fin-soc[1]":U THEN ASSIGN pFieldValue = RowObject.per-fin-soc[1].
        WHEN "per-fin-soc[2]":U THEN ASSIGN pFieldValue = RowObject.per-fin-soc[2].
        WHEN "per-sub-tri":U THEN ASSIGN pFieldValue = RowObject.per-sub-tri.
        &if {&bf_dis_versao_ems} >= 2.03 &then
        WHEN "perc-desc-zf":U THEN ASSIGN pFieldValue = RowObject.perc-desc-zf.
        &endif
        WHEN "perc-PIS[1]":U THEN ASSIGN pFieldValue = RowObject.perc-PIS[1].
        WHEN "perc-PIS[2]":U THEN ASSIGN pFieldValue = RowObject.perc-PIS[2].
        WHEN "perc-red-icm":U THEN ASSIGN pFieldValue = RowObject.perc-red-icm.
        WHEN "perc-red-ipi":U THEN ASSIGN pFieldValue = RowObject.perc-red-ipi.
        WHEN "perc-red-iss":U THEN ASSIGN pFieldValue = RowObject.perc-red-iss.
        &if {&bf_dis_versao_ems} >= 2.03 &then
        WHEN "var-val-it-terc":U THEN ASSIGN pFieldValue = RowObject.var-val-it-terc.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.
    CASE pFieldName:
        WHEN "cd-situacao":U THEN ASSIGN pFieldValue = RowObject.cd-situacao.
        WHEN "cod-mensagem":U THEN ASSIGN pFieldValue = RowObject.cod-mensagem.
        &if defined(bf-mat-comex) &then            
            WHEN "ct-cusven":U THEN ASSIGN pFieldValue = RowObject.ct-cusven.
            WHEN "ct-recven":U THEN ASSIGN pFieldValue = RowObject.ct-recven.
            WHEN "ct-transven":U THEN ASSIGN pFieldValue = RowObject.ct-transven.
            WHEN "sc-cusven":U THEN ASSIGN pFieldValue = RowObject.sc-cusven.
            WHEN "sc-recven":U THEN ASSIGN pFieldValue = RowObject.sc-recven.
            WHEN "sc-transven":U THEN ASSIGN pFieldValue = RowObject.sc-transven.
        &else
            WHEN "merc-base-icms":U THEN ASSIGN pFieldValue = RowObject.merc-base-icms.
            WHEN "mercado":U THEN ASSIGN pFieldValue = RowObject.mercado.
            WHEN "cd-trib-icm":U THEN ASSIGN pFieldValue = RowObject.cd-trib-icm.
            WHEN "cd-trib-ipi":U THEN ASSIGN pFieldValue = RowObject.cd-trib-ipi.
            WHEN "cd-trib-iss":U THEN ASSIGN pFieldValue = RowObject.cd-trib-iss.
            WHEN "cod-canal-venda":U THEN ASSIGN pFieldValue = RowObject.cod-canal-venda.
            WHEN "oper-terc":U THEN ASSIGN pFieldValue = RowObject.oper-terc.
            WHEN "preco-saida":U THEN ASSIGN pFieldValue = RowObject.preco-saida.
            WHEN "tipo":U THEN ASSIGN pFieldValue = RowObject.tipo.
            WHEN "tipo-trib":U THEN ASSIGN pFieldValue = RowObject.tipo-trib.
        &endif
        
        &if {&bf_dis_versao_ems} >= 2.03 &then
        WHEN "ind-entreg-futur":U THEN ASSIGN pFieldValue = RowObject.ind-entreg-futur.
        WHEN "ind-nota-propria":U THEN ASSIGN pFieldValue = RowObject.ind-nota-propria.
        &endif
        &if {&bf_dis_versao_ems} >= 2.04 &then
        WHEN "ind-situacao":U THEN ASSIGN pFieldValue = RowObject.ind-situacao.
        &endif
        &if {&bf_dis_versao_ems} >= 2.03 &then
        WHEN "ind-venda-ambulante":U THEN ASSIGN pFieldValue = RowObject.ind-venda-ambulante.
        &endif
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        &if defined (bf_mat_natur_compra_re) &then
        WHEN "tipo-compra":U THEN ASSIGN pFieldValue = RowObject.tipo-compra.
        &endif
        
        WHEN "tp-oper-terc":U THEN ASSIGN pFieldValue = RowObject.tp-oper-terc.
        WHEN "tp-rec-desp":U THEN ASSIGN pFieldValue = RowObject.tp-rec-desp.
        WHEN "uso":U THEN ASSIGN pFieldValue = RowObject.uso.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice natureza
  Parameters:  
               retorna valor do campo nat-operacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE natur-oper.nat-operacao NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnat-operacao = RowObject.nat-operacao.

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
        &if {&bf_dis_versao_ems} >= 2.03 &then
        WHEN "alt-vl-it-terc":U THEN ASSIGN pFieldValue = RowObject.alt-vl-it-terc.
        &endif
        &if defined(bf-mat-comex) &then            
            WHEN "merc-base-icms":U THEN ASSIGN pFieldValue = RowObject.merc-base-icms.
            WHEN "oper-terc":U THEN ASSIGN pFieldValue = RowObject.oper-terc.
            WHEN "preco-saida":U THEN ASSIGN pFieldValue = RowObject.preco-saida.
            WHEN "tipo":U THEN ASSIGN pFieldValue = RowObject.tipo.
        &else
            WHEN "auto-ct":U THEN ASSIGN pFieldValue = RowObject.auto-ct.
            WHEN "atual-estat":U THEN ASSIGN pFieldValue = RowObject.atual-estat.
            WHEN "baixa-ship":U THEN ASSIGN pFieldValue = RowObject.baixa-ship.
            WHEN "nota-rateio":U THEN ASSIGN pFieldValue = RowObject.nota-rateio.
        &endif

        
        WHEN "atualiza-of":U THEN ASSIGN pFieldValue = RowObject.atualiza-of.
        WHEN "auto-ce":U THEN ASSIGN pFieldValue = RowObject.auto-ce.
        WHEN "auto-cr":U THEN ASSIGN pFieldValue = RowObject.auto-cr.
        
        WHEN "auto-est":U THEN ASSIGN pFieldValue = RowObject.auto-est.
        WHEN "baixa-estoq":U THEN ASSIGN pFieldValue = RowObject.baixa-estoq.
        
        WHEN "calc-auto":U THEN ASSIGN pFieldValue = RowObject.calc-auto.
        WHEN "consum-final":U THEN ASSIGN pFieldValue = RowObject.consum-final.
        &if defined(bf_dis_ciap) &then
        WHEN "credito-ciap":U THEN ASSIGN pFieldValue = RowObject.credito-ciap.
        &endif
        WHEN "credito-subs":U THEN ASSIGN pFieldValue = RowObject.credito-subs.
        WHEN "emite-duplic":U THEN ASSIGN pFieldValue = RowObject.emite-duplic.
        &if {&bf_dis_versao_ems} >= 2.03 &then
        WHEN "gera-prev-cr":U THEN ASSIGN pFieldValue = RowObject.gera-prev-cr.
        &endif
        WHEN "imp-nota":U THEN ASSIGN pFieldValue = RowObject.imp-nota.
        WHEN "ind-contabilizacao":U THEN ASSIGN pFieldValue = RowObject.ind-contabilizacao.
        WHEN "ind-entfut":U THEN ASSIGN pFieldValue = RowObject.ind-entfut.
        WHEN "ind-est-crz":U THEN ASSIGN pFieldValue = RowObject.ind-est-crz.
        WHEN "ind-est-mof":U THEN ASSIGN pFieldValue = RowObject.ind-est-mof.
        WHEN "ind-est-qtd":U THEN ASSIGN pFieldValue = RowObject.ind-est-qtd.
        WHEN "ind-gera-of":U THEN ASSIGN pFieldValue = RowObject.ind-gera-of.
        WHEN "ind-imprenda":U THEN ASSIGN pFieldValue = RowObject.ind-imprenda.
        WHEN "ind-it-icms":U THEN ASSIGN pFieldValue = RowObject.ind-it-icms.
        WHEN "ind-it-sub-dif":U THEN ASSIGN pFieldValue = RowObject.ind-it-sub-dif.
        WHEN "ind-tipo-vat":U THEN ASSIGN pFieldValue = RowObject.ind-tipo-vat.
        WHEN "ipi-icm-out":U THEN ASSIGN pFieldValue = RowObject.ipi-icm-out.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        &if defined(bf_dis_ciap) &then
        WHEN "log-acum-ciap":U THEN ASSIGN pFieldValue = RowObject.log-acum-ciap.
        &endif
        &if {&bf_dis_versao_ems} >= 2.03 &then
        WHEN "log-atual-cotas":U THEN ASSIGN pFieldValue = RowObject.log-atual-cotas.
        WHEN "log-base-ipi":U THEN ASSIGN pFieldValue = RowObject.log-base-ipi.
        WHEN "log-biss":U THEN ASSIGN pFieldValue = RowObject.log-biss.
        WHEN "log-emit-remito":U THEN ASSIGN pFieldValue = RowObject.log-emit-remito.
        WHEN "log-frete-bipi":U THEN ASSIGN pFieldValue = RowObject.log-frete-bipi.
        WHEN "log-gera-cre-subst":U THEN ASSIGN pFieldValue = RowObject.log-gera-cre-subst.
        WHEN "log-icms-out-subst":U THEN ASSIGN pFieldValue = RowObject.log-icms-out-subst.
        WHEN "log-ipi-bicms":U THEN ASSIGN pFieldValue = RowObject.log-ipi-bicms.
        WHEN "log-ipi-out-bsubst":U THEN ASSIGN pFieldValue = RowObject.log-ipi-out-bsubst.
        WHEN "log-ipi-out-tot":U THEN ASSIGN pFieldValue = RowObject.log-ipi-out-tot.
        &endif
        &if defined (bf_dis_desc_bonif) &then
        WHEN "log-natureza-bonif":U THEN ASSIGN pFieldValue = RowObject.log-natureza-bonif.
        &endif
        &if '{&bf_dis_versao_ems}':U >= '2.071':U &then 
        WHEN "log-vda-ret":U THEN ASSIGN pFieldValue = RowObject.log-vda-ret. 
        &endif
        &if defined (bf_mat_oper_triangular) &then
        WHEN "log-oper-triang":U THEN ASSIGN pFieldValue = RowObject.log-oper-triang.
        &endif
        &if {&bf_dis_versao_ems} >= 2.03 &then
        WHEN "log-remito-gera-prevcr":U THEN ASSIGN pFieldValue = RowObject.log-remito-gera-prevcr.
        WHEN "log-ret-inss-fonte":U THEN ASSIGN pFieldValue = RowObject.log-ret-inss-fonte.
        WHEN "log-vl-it-terc":U THEN ASSIGN pFieldValue = RowObject.log-vl-it-terc.
        &endif
        WHEN "manut-icm":U THEN ASSIGN pFieldValue = RowObject.manut-icm.
        WHEN "manut-ipi":U THEN ASSIGN pFieldValue = RowObject.manut-ipi.
        WHEN "nat-ativa":U THEN ASSIGN pFieldValue = RowObject.nat-ativa.
        
        WHEN "subs-trib":U THEN ASSIGN pFieldValue = RowObject.subs-trib.
        WHEN "terceiros":U THEN ASSIGN pFieldValue = RowObject.terceiros.
        WHEN "transf":U THEN ASSIGN pFieldValue = RowObject.transf.
        WHEN "usa-nota-ent":U THEN ASSIGN pFieldValue = RowObject.usa-nota-ent.
        WHEN "usa-pick":U THEN ASSIGN pFieldValue = RowObject.usa-pick.
        WHEN "venda-ativo":U THEN ASSIGN pFieldValue = RowObject.venda-ativo.
        &if {&bf_dis_versao_ems} >= 2.062 &then
            WHEN "log-ipi-contrib-retid":U THEN ASSIGN pFieldValue = RowObject.log-ipi-contrib-retid.
            WHEN "log-ipi-outras-contrib-retid":U THEN ASSIGN pFieldValue = RowObject.log-ipi-outras-contrib-retid.
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



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescCFOP DBOProgram 
PROCEDURE getDescCFOP :
/*------------------------------------------------------------------------------
  Purpose:     Retorna a descri‡Æo do CFOP
  Parameters:  
               recebe Cod-cfop 
               retorna Des-cfop
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pItCod-cfop AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAMETER pDesc-cfop AS CHARACTER NO-UNDO.
    
    &IF DEFINED(bf_dis_formato_CFOP) &THEN
        FIND FIRST cfop-natur WHERE cfop-natur.cod-cfop = pItCod-cfop NO-LOCK NO-ERROR.
        IF AVAIL cfop-natur THEN DO:
            ASSIGN pDesc-cfop = cfop-natur.des-cfop. 
            RETURN "OK":U.
        END.
        ELSE
           RETURN "NOK":U.
    &ELSE
        find first ped-curva where ped-curva.it-codigo = pItCod-cfop and
                                   ped-curva.vl-aberto = 620 no-lock no-error.
        if avail ped-curva then do:    
           assign pDesc-cfop = ped-curva.nome.
           RETURN "OK":U.
        end.
        else
           RETURN "NOK":U.
    &ENDIF
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getInfAdicCFOP DBOProgram 
PROCEDURE getInfAdicCFOP :
/*------------------------------------------------------------------------------
  Purpose:     Retorna as informa‡äes adicionais do CFOP
  Parameters:  
               recebe Cod-cfop 
               retorna  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pItCod-cfop AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAMETER pInfAdic-cfop AS CHARACTER NO-UNDO.
    def var l-pri as logical init "yes" no-undo.
    
    &if defined(bf_dis_formato_CFOP) &then
        find cfop-natur where cfop-natur.cod-cfop = pItCod-cfop no-lock no-error.
        if  avail cfop-natur then     
            assign c-InfAdic-cfop = cfop-natur.dsl-inform-adic.
    &else
        find first ped-curva 
             where ped-curva.it-codigo = pItCod-cfop 
               and ped-curva.vl-aberto = 620 no-lock no-error.
        if  avail ped-curva then
            assign c-InfAdic-cfop = ped-curva.char-1 + ped-curva.char-2.
    &endif.
    
    assign c-InfAdic-cfop = replace (c-InfAdic-cfop,chr(10)," ").
    run pi-print-editor(c-InfAdic-cfop,60).
    for each tt-editor:
    IF tt-editor.conteudo <> " " then
        if l-pri = yes then
            assign pInfAdic-cfop = tt-editor.conteudo.
        else
            assign pInfAdic-cfop = pInfAdic-cfop + chr(10) + tt-editor.conteudo.    
    assign l-pri = no.    
    end. 
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDataCFOP DBOProgram 
PROCEDURE getDataCFOP :
/*------------------------------------------------------------------------------
  Purpose:     Retorna a Data do CFOP
  Parameters:  
               recebe      - 
               retorna Data-cfop
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pData-cfop AS CHAR NO-UNDO.
    
    find para-ped no-lock no-error.
    if avail para-ped then 
        find param-of where param-of.cod-estabel = para-ped.estab-padrao no-lock no-error.
    else
        find first param-of no-lock no-error.
       
    if avail param-of then do:
        &if defined(bf_dis_formato_CFOP) &then
            assign pData-cfop = string(param-of.dat-format-cfop).
        &ELSE 
            assign pData-cfop = string(param-of.data-2).
        &endif
        if  pData-cfop = ? then              
            assign pData-cfop = "01/01/2003". 

    end.  
    ELSE 
        assign pData-cfop = "01/01/2003".
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inputUpdates DBOProgram 
PROCEDURE inputUpdates :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-atualizar-mensagem as log no-undo.

    assign l-atualizar-mensagem = p-atualizar-mensagem.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizarMP DBOProgram 
PROCEDURE atualizarMP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-atualizar-mp as log no-undo.

    assign l-atualizar-mp = p-atualizar-mp.

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

    def input param i-abertura as int no-undo.

    case i-abertura:
        when 1 or when 2 then
               run openQueryStatic (input "RangePage1":U).
        when 3 then
               run openQueryStatic (input "RangePage2":U).
        when 4 then do:
               run openQueryStatic (input "RangePage2":U).
               run openQueryStatic (input "RangePage1":U).
        end.
        when 5 then do:
               run openQueryStatic (input "RangePage1":U).
               run openQueryStatic (input "RangePage2":U).
        end.
    end case.

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

  open query qr{&tableName} for each {&tableName} no-lock
       indexed-reposition.
       
  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangePage1 DBOProgram 
PROCEDURE openQueryRangePage1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName}
         where {&tableName}.nat-operacao >= cIniNatOperacao
           and {&tableName}.nat-operacao <= cEndNatOperacao
           no-lock 
           indexed-reposition.

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangePage2 DBOProgram 
PROCEDURE openQueryRangePage2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName}
         where {&tableName}.denominacao >= cIniDenominacao
           and {&tableName}.denominacao <= cEndDenominacao no-lock
           by {&tableName}.denominacao by {&tableName}.nat-operacao
           indexed-reposition.

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySituacionPage1 DBOProgram 
PROCEDURE openQuerySituacionPage1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    open query qr{&tableName} for each {&tableName}
         where {&tableName}.nat-operacao >= cIniNatOperacao
           and {&tableName}.nat-operacao <= cEndNatOperacao
           and (({&tableName}.nat-ativa = yes and iNatAtiva = 1)
           or  ({&tableName}.nat-ativa = no  and iNatAtiva = 1)
           or  ({&tableName}.nat-ativa = yes and iNatAtiva = 2)
           or  ({&tableName}.nat-ativa = no  and iNatAtiva = 3)) no-lock
           indexed-reposition.

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySituacionPage2 DBOProgram 
PROCEDURE openQuerySituacionPage2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName}
         where {&tableName}.denominacao >= cIniDenominacao
           and {&tableName}.denominacao <= cEndDenominacao 
           and (({&tableName}.nat-ativa = yes and iNatAtiva = 1)
           or  ({&tableName}.nat-ativa = no  and iNatAtiva = 1)
           or  ({&tableName}.nat-ativa = yes and iNatAtiva = 2)
           or  ({&tableName}.nat-ativa = no  and iNatAtiva = 3)) no-lock
           by {&tableName}.denominacao by {&tableName}.nat-operacao
           indexed-reposition.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySituacionPage3 DBOProgram 
PROCEDURE openQuerySituacionPage3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query qr{&tableName} for each {&tableName} where
           &if defined(bf_dis_formato_CFOP) &then
               {&tableName}.cod-cfop = cIniCodCFOP 
           &else
               trim(substr({&tableName}.char-1,45,10)) = cIniCodCFOP 
           &endif    
           and (({&tableName}.nat-ativa = yes and iNatAtiva = 1)
           or  ({&tableName}.nat-ativa = no  and iNatAtiva = 1)
           or  ({&tableName}.nat-ativa = yes and iNatAtiva = 2)
           or  ({&tableName}.nat-ativa = no  and iNatAtiva = 3)) no-lock 
           by {&tableName}.nat-operacao
           indexed-reposition.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE outputOperationTypeList DBOProgram 
PROCEDURE outputOperationTypeList :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param i-tipo-lista           as int  no-undo. /* (1)Combo-Box (2)Radio-Set */
    def output param c-lista-tipo-operacoes as char no-undo.

    if  i-tipo-lista = 1 then
        assign c-lista-tipo-operacoes =
               "Nenhum,Faturamento Antecipado,Remessa de Faturamento Antecipado,Faturamento com Entrega Futura,Remessa de Entrega Futura".
    if  i-tipo-lista = 2 then
        assign c-lista-tipo-operacoes =
               "Nenhum,1,Faturamento Antecipado,2,Remessa de Faturamento Antecipado,3,Faturamento com Entrega Futura,4,Remessa de Entrega Futura,5".

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnTipo DBOProgram 
PROCEDURE returnTipo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param p-chave as rowid no-undo.
    def output param p-tipo  as char  no-undo.
    
    run repositionRecord(input p-chave).

    &if defined(bf-mat-comex) &then            
        IF RowObject.tipo = YES THEN
            p-tipo = "Entrada".
        IF Rowobject.tipo = NO THEN
            p-tipo = "Sa¡da".
    &else
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao001 = {ininc/i06in245.i 04 rowObject.tipo}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN  p-tipo = RETURN-VALUE.
        &else
            ASSIGN p-tipo = {ininc/i06in245.i 04 rowObject.tipo}.
        &endif
    &endif
    
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnTribicm DBOProgram 
PROCEDURE returnTribicm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param p-chave   as rowid no-undo.
    def output param p-tribicm as char  no-undo.
    
    run repositionRecord(input p-chave).
    
    &if defined(bf-mat-comex) &then            
       IF rowObject.cd-trib-icm = "T" THEN
           ASSIGN p-tribicm = "Tribut".
       IF rowObject.cd-trib-icm = "I" THEN
           ASSIGN p-tribicm = "Isen".
       IF rowObject.cd-trib-icm = "O" THEN
           ASSIGN p-tribicm = "Outros".
       IF rowObject.cd-trib-icm = "R" THEN
           ASSIGN p-tribicm = "Reduz".
       IF rowObject.cd-trib-icm = "V" THEN
           ASSIGN p-tribicm = "Trib p/ Brindes".
       IF rowObject.cd-trib-icm = "F" THEN
           ASSIGN p-tribicm = "Financiam".
    &else
    
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao002 = {ininc/i01in245.i 04 rowObject.cd-trib-icm}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN  p-tribicm = RETURN-VALUE.
        &else
            ASSIGN p-tribicm = {ininc/i01in245.i 04 rowObject.cd-trib-icm}.
        &endif
    &endif
    
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnTribipi DBOProgram 
PROCEDURE returnTribipi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param p-chave   as rowid no-undo.
    def output param p-tribipi as char  no-undo.
    
    run repositionRecord(input p-chave).
    
    &if defined(bf-mat-comex) &then            
        IF Rowobject.cd-trib-ipi = "T" THEN
            ASSIGN p-tribipi = "Tributa‡Æo".
        IF Rowobject.cd-trib-ipi = "I" THEN
            ASSIGN p-tribipi = "Isento".
        IF Rowobject.cd-trib-ipi = "O" THEN
            ASSIGN p-tribipi = "Outros".
        IF Rowobject.cd-trib-ipi = "R" THEN
            ASSIGN p-tribipi = "Reduzido".
    &else
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao003 = {ininc/i10in172.i 04 rowObject.cd-trib-ipi}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao003)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN  p-tribipi = RETURN-VALUE.
        &else
            ASSIGN p-tribipi = {ininc/i10in172.i 04 rowObject.cd-trib-ipi}.
        &endif
    &endif    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint1 DBOProgram 
PROCEDURE setConstraint1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter p-nat-ini as char no-undo.

    run setConstraintRangePage1(input p-nat-ini,
                                input "zzzzzz":U).

    return "OK":U.

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

    def input parameter p-nat-inicial as char no-undo.
    def input parameter p-nat-final   as char no-undo.
    def input parameter p-denom-ini   as char no-undo.
    def input parameter p-denom-fim   as char no-undo.

    run setConstraintRangePage1(input p-nat-inicial,
                                input p-nat-final).
    run setConstraintRangePage2(input p-denom-ini,
                                input p-denom-fim).

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangePage1 DBOProgram 
PROCEDURE setConstraintRangePage1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pcIniNatOperacao as char no-undo.
def input param pcEndNatOperacao as char no-undo.

    assign cIniNatOperacao = pcIniNatOperacao
           cEndNatOperacao = pcEndNatOperacao.          

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangePage2 DBOProgram 
PROCEDURE setConstraintRangePage2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pcIniDenominacao as char no-undo.
def input param pcEndDenominacao as char no-undo.

    assign cIniDenominacao = pcIniDenominacao
           cEndDenominacao = pcEndDenominacao.           

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintSituacionPage1 DBOProgram 
PROCEDURE setConstraintSituacionPage1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pcIniNatOperacao as char no-undo.
def input param pcEndNatOperacao as char no-undo.
def input param piNatAtiva       as int  no-undo.

    assign cIniNatOperacao = pcIniNatOperacao
           cEndNatOperacao = pcEndNatOperacao
           iNatAtiva       = piNatAtiva.          

   return "OK":U.

END PROCEDURE.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintSituacionPage2 DBOProgram 
PROCEDURE setConstraintSituacionPage2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pcIniDenominacao as char no-undo.
def input param pcEndDenominacao as char no-undo.
def input param piNatAtiva       as int  no-undo.

    assign cIniDenominacao = pcIniDenominacao
           cEndDenominacao = pcEndDenominacao
           iNatAtiva       = piNatAtiva.                          

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintSituacionPage3 DBOProgram 
PROCEDURE setConstraintSituacionPage3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pcIniCodCFOP as char no-undo.
def input param piNatAtiva   as int  no-undo.

    assign cIniCodCFOP     = pcIniCodCFOP
           iNatAtiva       = piNatAtiva.                          
           

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

    run inbo/boin245val.p persistent set h-boin245val.

    if  pType = "Delete" THEN
        run validateDelete in h-boin245val(input  table RowObject,
                                           output table RowErrors).
    ELSE DO:
        /* CHAMADA EPC - GRENDENE - Validar natureza complementar */
        /* Elimina natureza complementar digitada se natur-oper.nat-operacao for de transferˆncia */
        /* A natureza complementar ‚ gravada no campo char_3 da tabela gr_tab_geral e recuperada */
        /* na chamada abaixo (afterCreateUpdateRecord) */
        {method/svc/custom/custom.i &Event = "BeforeCreateUpdateRecord"}

        /* Executa getRecord pois a temp-table pode ter sido modificada na epc */        
        RUN getRecord IN THIS-PROCEDURE (OUTPUT TABLE RowObject).
        FIND FIRST RowObject NO-ERROR.

        run validateCreateUpdate in h-boin245val(input  table RowObject,
                                                 input  pType,
                                                 output table RowErrors).

        /* CHAMADA EPC - GRENDENE - Validar natureza complementar */
        {method/svc/custom/custom.i &Event = "AfterCreateUpdateRecord"}

        /* Executa getRecord pois a temp-table pode ter sido modificada na epc */        
        RUN getRecord IN THIS-PROCEDURE (OUTPUT TABLE RowObject).
        FIND FIRST RowObject NO-ERROR.
    END.

    IF  pType = "CREATE" OR 
        pType = "Update" THEN DO:

        IF  l-funcao-spp-ent-fut THEN DO:

            FIND FIRST para-ped NO-LOCK NO-ERROR.
            IF  AVAIL para-ped  
                &if '{&bf_dis_versao_ems}' >= '2.071' &THEN
                AND para-ped.Log-aloca-autom-ref = YES
                &else
                AND SUBSTR(para-ped.Char-1,19,1)  = "y" 
                &ENDIF THEN DO:
                
                &if '{&bf_dis_versao_ems}' <= '2.07'&THEN DO:
                    IF  (INT(substr(rowobject.char-1,1,5)) = 0   AND 
                                    rowobject.ind-entfut   = YES AND 
                                    rowobject.ind-est-qtd  = NO) AND          /*faturamento entrega futura*/
                             substr(RowObject.char-2,125,6) = "" THEN 
                        /* Inicio -- Projeto Internacional */
                        DO:
                        DEFINE VARIABLE c-lbl-liter-a-natureza-de-operaoo-de-remes AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "A_natureza_de_operação_de_Remessa_de_Entrega_Futura_deve_ser_informada" *}
                        ASSIGN c-lbl-liter-a-natureza-de-operaoo-de-remes = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-inserr-a-natureza-de-operaoo-de-rem AS CHARACTER NO-UNDO.
                        ASSIGN c-lbl-inserr-a-natureza-de-operaoo-de-rem = c-lbl-liter-a-natureza-de-operaoo-de-remes + '.'.
                        {method/svc/errors/inserr.i &ErrorNumber       = 17006
                                                    &ErrorType       = "EMS"
                                                    &ErrorSubType    = "ERROR"
                                                    &ErrorParameters = 'c-lbl-inserr-a-natureza-de-operaoo-de-rem'}
                        END. 
                END.
                &else DO:
                    IF  (INT(substr(rowobject.char-1,1,5))   = 0   AND 
                                    rowobject.ind-entfut     = YES AND 
                                    rowobject.ind-est-qtd    = NO) AND          /*faturamento entrega futura*/
                          /* substr(RowObject.cod-natur-ref) = ""*/
                                    RowObject.cod-natur-ref = ""  THEN 
                        /* Inicio -- Projeto Internacional */
                        DO:
                        DEFINE VARIABLE c-lbl-liter-a-natureza-de-operaoo-de-remes-2 AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "A_natureza_de_operação_de_Remessa_de_Entrega_Futura_deve_ser_informada" *}
                        ASSIGN c-lbl-liter-a-natureza-de-operaoo-de-remes-2 = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-inserr-a-natureza-de-operaoo-de-rem-2 AS CHARACTER NO-UNDO.
                        ASSIGN c-lbl-inserr-a-natureza-de-operaoo-de-rem-2 = c-lbl-liter-a-natureza-de-operaoo-de-remes-2 + '.'.
                        {method/svc/errors/inserr.i &ErrorNumber       = 17006
                                                  &ErrorType       = "EMS"
                                                  &ErrorSubType    = "ERROR"
                                                  &ErrorParameters = 'c-lbl-inserr-a-natureza-de-operaoo-de-rem-2'}
                        END. 
                END.  
                &ENDif
            END.
        
            &if '{&bf_dis_versao_ems}' <= '2.07'&THEN DO:
                IF  substr(RowObject.char-2,125,6) <> "" THEN DO:
                    FIND bfnatur-oper WHERE 
                         bfnatur-oper.nat-operacao = substr(RowObject.char-2,125,6) NO-LOCK NO-ERROR.
                    IF  AVAIL bfnatur-oper  THEN DO:
                        IF  NOT( INT(substr(bfnatur-oper.char-1,1,5))  = 0    AND 
                                            bfnatur-oper.ind-entfut    = NO   AND
                                            bfnatur-oper.ind-est-qtd   = yes) THEN 
    
                            /* Inicio -- Projeto Internacional */
                            DO:
                            DEFINE VARIABLE c-lbl-liter-a-natureza-de-operaoo-deve-ser AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "A_natureza_de_operação_deve_ser_de_remessa_de_entrega_futura" *}
                            ASSIGN c-lbl-liter-a-natureza-de-operaoo-deve-ser = TRIM(RETURN-VALUE).
                            {method/svc/errors/inserr.i &ErrorNumber     = 17006
                                                     &ErrorType       = "EMS"
                                                     &ErrorSubType    = "ERROR"
                                                     &ErrorParameters = 'c-lbl-liter-a-natureza-de-operaoo-deve-ser'}
                            END. 
    
                    END.
                    ELSE
                        /* Inicio -- Projeto Internacional */
                        DO:
                        DEFINE VARIABLE c-lbl-liter-a-natureza-de-operaoo-noo-est AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "A_natureza_de_operação_não_está_cadastrada" *}
                        ASSIGN c-lbl-liter-a-natureza-de-operaoo-noo-est = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-inserr-a-natureza-de-operaoo-noo-es AS CHARACTER NO-UNDO.
                        ASSIGN c-lbl-inserr-a-natureza-de-operaoo-noo-es = c-lbl-liter-a-natureza-de-operaoo-noo-est + '.'.
                        {method/svc/errors/inserr.i &ErrorNumber       = 17006
                                                    &ErrorType       = "EMS"
                                                    &ErrorSubType    = "ERROR"
                                                    &ErrorParameters = 'c-lbl-inserr-a-natureza-de-operaoo-noo-es'}
                        END. 
                                                    
                END.
            END.
            &ELSE DO:
              /* IF  substr(RowObject.cod-natur-ref) <> "" THEN DO: */
                 IF  RowObject.cod-natur-ref <> "" THEN DO:
                    FIND bfnatur-oper WHERE 
                         bfnatur-oper.nat-operacao = substr(RowObject.char-2,125,6) NO-LOCK NO-ERROR.
                    IF  AVAIL bfnatur-oper  THEN DO:
                        IF  NOT( INT(substr(bfnatur-oper.char-1,1,5)) = 0    AND 
                                            bfnatur-oper.ind-entfut   = no   AND
                                            bfnatur-oper.ind-est-qtd  = yes) THEN 
                            /* Inicio -- Projeto Internacional */
                            DO:
                            DEFINE VARIABLE c-lbl-liter-a-natureza-de-operaoo-deve-ser-2 AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "A_natureza_de_operação_deve_ser_de_remessa_de_entrega_futura" *}
                            ASSIGN c-lbl-liter-a-natureza-de-operaoo-deve-ser-2 = TRIM(RETURN-VALUE).
                            {method/svc/errors/inserr.i &ErrorNumber     = 17006
                                                        &ErrorType       = "EMS"
                                                        &ErrorSubType    = "ERROR"
                                                        &ErrorParameters = 'c-lbl-liter-a-natureza-de-operaoo-deve-ser-2'}
                            END. 
                    END.
                    ELSE
                        /* Inicio -- Projeto Internacional */
                        DO:
                        DEFINE VARIABLE c-lbl-liter-a-natureza-de-operaoo-noo-est-2 AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "A_natureza_de_operação_não_está_cadastrada" *}
                        ASSIGN c-lbl-liter-a-natureza-de-operaoo-noo-est-2 = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-inserr-a-natureza-de-operaoo-noo-es-2 AS CHARACTER NO-UNDO.
                        ASSIGN c-lbl-inserr-a-natureza-de-operaoo-noo-es-2 = c-lbl-liter-a-natureza-de-operaoo-noo-est-2 + '.'.
                        {method/svc/errors/inserr.i &ErrorNumber       = 17006
                                                    &ErrorType       = "EMS"
                                                    &ErrorSubType    = "ERROR"
                                                    &ErrorParameters = 'c-lbl-inserr-a-natureza-de-operaoo-noo-es-2'}
                        END. 
                END.
             END.
            &endif
        END.
    END.
    delete procedure h-boin245val.

    /*--- Verifica ocorrˆncia de erros ---*/
    IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
                  
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExportCFOP DBOProgram 
PROCEDURE ExportCFOP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM pc-nat-operacao LIKE natur-oper.nat-operacao NO-UNDO.

    &if defined(bf_dis_formato_CFOP) &then
        DEF INPUT PARAM pc-old-cfop     LIKE natur-oper.cod-cfop   NO-UNDO.
        DEF INPUT PARAM pc-new-cfop     LIKE natur-oper.cod-cfop   NO-UNDO.
    &else
        DEF INPUT PARAM pc-old-cfop     LIKE natur-oper.char-1     NO-UNDO.
        DEF INPUT PARAM pc-new-cfop     LIKE natur-oper.char-1     NO-UNDO.
    &endif
    
    DEF INPUT PARAM pd-dt-ini       AS DATE NO-UNDO.
    DEF INPUT PARAM pd-dt-fim       AS DATE NO-UNDO.
    DEF INPUT PARAM pl-export-equal AS LOG  NO-UNDO.
        
    DEF VAR h-acomp AS HANDLE NO-UNDO.

    IF  NOT SESSION:REMOTE THEN DO:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
        RUN pi-inicializar IN h-acomp(INPUT "Exportando CFOP: Natur Oper -> DOC-FISCAL").
    END.

    BLOCK_exporta:
    DO TRANS:

        FOR EACH  doc-fiscal 
            WHERE doc-fiscal.nat-operacao = pc-nat-operacao
              AND doc-fiscal.dt-docto    >= pd-dt-ini
              AND doc-fiscal.dt-docto    <= pd-dt-fim EXCLUSIVE-LOCK 
            ON STOP  UNDO BLOCK_exporta, RETURN "NOK":U
            ON ERROR UNDO BLOCK_exporta, RETURN "NOK":U:
    
        IF  pl-export-equal 
            AND &IF defined(bf_dis_formato_CFOP) &THEN
                doc-fiscal.cod-cfop <> pc-old-cfop THEN
                &else
                trim(substr(doc-fiscal.char-1,1,10)) <> pc-old-cfop THEN
                &endif
                NEXT.
    
            IF  NOT SESSION:REMOTE THEN
                /* Inicio -- Projeto Internacional */
                DO:
                {utp/ut-liter.i "Documento" *}
                RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + ": " + doc-fiscal.nr-doc-fis).
                END. 

            &IF defined(bf_dis_formato_CFOP) &THEN
            ASSIGN doc-fiscal.cod-cfop = pc-new-cfop.
                &ELSE
                ASSIGN OVERLAY (doc-fiscal.char-1,1,10) = pc-new-cfop.
            &endif
            
        END.

        IF  NOT SESSION:REMOTE THEN
            RUN pi-finalizar IN h-acomp.

    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidateExport DBOProgram 
PROCEDURE ValidateExport :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pd-dt-cfop       AS DATE NO-UNDO.
    DEF INPUT PARAM pd-dt-ini-export AS DATE NO-UNDO.
    DEF INPUT PARAM pd-dt-fim-export AS DATE NO-UNDO.

    RUN emptyRowErrors IN THIS-PROCEDURE.

    IF  pd-dt-ini-export < pd-dt-cfop THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-a-data-inicial-noo-pode-ser-me AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "A_data_inicial_não_pode_ser_menor_que" *}
        ASSIGN c-lbl-liter-a-data-inicial-noo-pode-ser-me = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                                &ErrorNumber="25997"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lbl-liter-a-data-inicial-noo-pode-ser-me + ' ' + STRING(pd-dt-cfop)"}
    END.

    IF  pd-dt-fim-export < pd-dt-ini-export THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-a-data-final-noo-pode-ser-meno AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "A_data_final_não_pode_ser_menor_que_a_data_inicial" *}
        ASSIGN c-lbl-liter-a-data-final-noo-pode-ser-meno = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                        &ErrorNumber="25997"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="c-lbl-liter-a-data-final-noo-pode-ser-meno"}
    END.

    IF  CAN-FIND(FIRST param-of 
                 WHERE param-of.dt-congela >= pd-dt-ini-export) THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-data-inicial AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Data_Inicial" *}
        ASSIGN c-lbl-liter-data-inicial = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                                &ErrorNumber="16476"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lbl-liter-data-inicial"}
    END.

    RETURN (IF  CAN-FIND(FIRST RowErrors 
                         WHERE RowErrors.ErrorSubType = "Error":U) THEN "NOK":U
            ELSE "OK":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTipoCompra DBOProgram 
PROCEDURE getTipoCompra :
/*------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/

    define input  parameter pc-cod-cfop as char no-undo.
    define output parameter pi-tip-comp as int  no-undo.

    &if defined(bf_dis_formato_CFOP) &then
        find first cfop-natur where cfop-natur.cod-cfop = pc-cod-cfop no-lock no-error.
        if  avail cfop-natur then do:
            if      cfop-natur.idi-tip-cfop = 4 then assign pi-tip-comp = 5.
            else if cfop-natur.idi-tip-cfop = 5 then assign pi-tip-comp = 6.
            else if cfop-natur.idi-tip-cfop = 6 then assign pi-tip-comp = 4.
            else pi-tip-comp = cfop-natur.idi-tip-cfop.
            return "OK":U.
        end.
    &else
        find first ped-curva
             where ped-curva.it-codigo = pc-cod-cfop
               and ped-curva.vl-aberto = 620 no-lock no-error.
        if  avail ped-curva then do:
            if      ped-curva.int-1 = 4 then assign pi-tip-comp = 5.
            else if ped-curva.int-1 = 5 then assign pi-tip-comp = 6.
            else if ped-curva.int-1 = 6 then assign pi-tip-comp = 4.
            else pi-tip-comp = ped-curva.int-1.
            return "OK":U.
        end.
    &endif
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-integraRIxEMS DBOProgram 
PROCEDURE pi-integraRIxEMS :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER p-integra-ems AS LOGICAL NO-UNDO.

    ASSIGN p-integra-ems = NO.

    ASSIGN p-integra-ems = {cdp/cd9870.i2 "EMS"}.
   
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VerificaCodModeloNFe DBOProgram 
PROCEDURE VerificaCodModeloNFe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAM l-modeloNFe AS LOGICAL NO-UNDO.

   /*--- Nota Fiscal Eletronica ---*/
   /*Campo para versäes 204 a 207*/
    &if '{&bf_dis_versao_ems}' >= '2.04' AND '{&bf_dis_versao_ems}' < '2.07' &THEN
          IF SUBSTR(RowObject.char-2,120,2)  = "55" OR
             SUBSTR(RowObject.char-2,120,2)  = "65" OR
             SUBSTR(RowObject.char-2,120,2)  = "57" OR
             SUBSTR(RowObject.char-2,120,2)  = "67" OR  THEN 
              ASSIGN l-modeloNFe = YES.
          ELSE 
              ASSIGN l-modeloNFe = NO.

    &endif
    /*Campo para versäes 204 a 207*/
    &if '{&bf_dis_versao_ems}' >= '2.07' &THEN
        IF RowObject.cod-model-nf-eletro  = "55" OR
           RowObject.cod-model-nf-eletro  = "65" OR
           RowObject.cod-model-nf-eletro  = "57" OR
           RowObject.cod-model-nf-eletro  = "67" THEN 
            ASSIGN l-modeloNFe = YES.
        ELSE 
              ASSIGN l-modeloNFe = NO.
    &endif
    
    RETURN "OK":U.
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
