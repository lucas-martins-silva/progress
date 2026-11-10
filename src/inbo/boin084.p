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
{include/i-prgvrs.i BOIN084 2.00.01.006 } /*** "010106" 17/06/2025 16:40:45 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin084 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
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
&GLOBAL-DEFINE DBOName deposito
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName deposito
&GLOBAL-DEFINE TableLabel deposito
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com defini»’o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com
      extens’o .i ---*/
{inbo/boin084.i RowObject}
{cdp/cdcfgmat.i}

&GLOBAL-DEFINE KeyField1 cod-depos /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */

/* &GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES */


/*--- Include com defini»’o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera»’o da defini»’o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»’o
      manual da query ---*/
{method/dboqry.i}
{cdp/cd0666.i}

&GLOBAL-DEFINE XMLReceiver YES
&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var ccod-depos-ini    as char no-undo.
def var ccod-depos-fim    as char no-undo.
def var c-nomeini         as char no-undo.
def var c-nomefim         as char no-undo.
def var c-sit             as char no-undo.

def temp-table tt-deposito
    field r-rowid   as rowid
    field indicador    as logical format "*/ "
    field cod-depos    like deposito.cod-depos
    field nome         like deposito.nome
    field ind-tipo-dep as char format "x(15)"
    field ind-processo like deposito.ind-processo
    field aloc         as char format "x(3)"
    field alocado      like deposito.alocado
    field prioridade   as int init 0
    index deposito is unique primary cod-depos
    index prioridade prioridade.

{inbo/boin172na.i tt-item}

DEFINE TEMP-TABLE tt-val-saldo NO-UNDO
        FIELD de-saldo-est       AS DECIMAL   FORMAT "->>>,>>>,>>9.99":U
        FIELD de-qt-alocada      AS DECIMAL   FORMAT "->>,>>9.99":U
        FIELD de-quant-segur     AS DECIMAL   FORMAT ">>>>,>>9.9999":U
        FIELD de-saldo-inic      AS DECIMAL   FORMAT "->>>,>>>,>>9.99":U.

DEFINE TEMP-TABLE RowErrorsFrotas no-undo
       field ErrorSequence as integer
       field ErrorNumber   as integer
       field ErrorDescription as char
       field ErrorParameters as char
       field ErrorType       as char
       field Errorhelp       as char
       field Errorsubtype    as char.

DEFINE TEMP-TABLE RowObjectExtra NO-UNDO
    FIELD r-Rowid        AS ROWID
    FIELD indDepCQ       AS CHAR
    FIELD logOrigExt     AS CHAR
    FIELD logAlocaQtdWms AS CHAR
    FIELD consSaldo      AS CHAR
    FIELD indTipoDep     AS CHAR
    FIELD alocado        AS CHAR
    FIELD indDepRej      AS CHAR
    FIELD logReciclagem  AS CHAR    
    FIELD indAcabado     AS CHAR
    FIELD logOrdensMrp   AS CHAR    
    FIELD logGeraWms     AS CHAR
    FIELD indProcesso    AS CHAR.

DEFINE VARIABLE c-sim AS CHAR NO-UNDO.
DEFINE VARIABLE c-nao AS CHAR NO-UNDO.
DEFINE VARIABLE c-lista-tipos-deposito AS CHAR NO-UNDO.

{utp/ut-liter.i "Sim" *}
ASSIGN c-sim = RETURN-VALUE.
{utp/ut-liter.i "NÆo" *}
ASSIGN c-nao = RETURN-VALUE.
ASSIGN c-lista-tipos-deposito = {ininc/i01in084.i 03}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD FN_logical DBOProgram 
FUNCTION FN_logical RETURNS CHARACTER
  ( p-log AS LOGICAL ) FORWARD.

/* _UIB-CODE-BLOCK-END */
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
         HEIGHT             = 21.13
         WIDTH              = 47.72.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCopyBuffer2TT DBOProgram 
PROCEDURE afterCopyBuffer2TT :
CREATE RowObjectExtra.
    ASSIGN RowObjectExtra.r-Rowid = ROWID({&TableName})
           RowObjectExtra.indDepCQ       = FN_logical({&TableName}.ind-dep-cq      )
           RowObjectExtra.logOrigExt     = FN_logical({&TableName}.log-orig-ext    )
           RowObjectExtra.logAlocaQtdWms = FN_logical({&TableName}.log-aloca-qtd-wms)
           RowObjectExtra.consSaldo      = FN_logical({&TableName}.cons-saldo      )
           RowObjectExtra.indTipoDep     = ENTRY({&TableName}.ind-tipo-dep, c-lista-tipos-deposito)
           RowObjectExtra.alocado        = FN_logical({&TableName}.alocado         )
           RowObjectExtra.indDepRej      = FN_logical({&TableName}.ind-dep-rej     )
           RowObjectExtra.logReciclagem  = FN_logical({&TableName}.log-reciclagem  )
           RowObjectExtra.indAcabado     = FN_logical({&TableName}.ind-acabado     )
           RowObjectExtra.logOrdensMrp   = FN_logical({&TableName}.log-ordens-mrp  )           
           RowObjectExtra.logGeraWms     = FN_logical({&TableName}.log-gera-wms    )
           RowObjectExtra.indProcesso    = FN_logical({&TableName}.ind-processo    ).
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF CAN-FIND (FIRST funcao 
                 WHERE funcao.cd-funcao = "spp-integra-ems-his"
                 AND   funcao.ativo     = YES) THEN DO:
        &IF "{&bf_mat_versao_ems}":U >= "2.08":U &THEN
            IF program-name(3) MATCHES "*ceapi305*" THEN
                ASSIGN deposito.log-orig-ext = YES.
        &ELSE 
            &IF "{&bf_mat_versao_ems}":U >= "2.062":U &THEN
                IF program-name(3) MATCHES "*ceapi305*" THEN DO:
                     ASSIGN OVERLAY (deposito.char-1,2,1) = "S".             
                END.
    
            &ENDIF
        &ENDIF
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

DEFINE VARIABLE i-cont      AS INTEGER    NO-UNDO.
DEFINE VARIABLE lValida     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE h-abapi008  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDBOproxy   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hShowMsg    AS HANDLE     NO-UNDO.
DEFINE VARIABLE c-lbl-usuar AS CHAR       NO-UNDO.

FIND FIRST param-estoq NO-LOCK NO-ERROR.

IF CAN-FIND (FIRST funcao 
             WHERE funcao.cd-funcao = "spp-integra-ems-his"
             AND   funcao.ativo     = YES) THEN DO:

      &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
          IF (RowObject.log-orig-ext) THEN DO:
             RUN utp/ut-msgs.p (INPUT "msg", INPUT 35074, INPUT "").  
             RUN _insertErrorManual (INPUT "35074",
                                     INPUT "EMS":U,
                                     INPUT "ERROR":U,
                                     INPUT RETURN-VALUE,
                                     INPUT "",
                                     INPUT "":U).
             RETURN 'NOK'.
          END.                  
      &ELSE
         &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
            IF TRIM(SUBSTRING(RowObject.char-1,2,1)) = "S" THEN DO:
               RUN utp/ut-msgs.p (INPUT "msg", INPUT 35074, INPUT "").
               RUN _insertErrorManual (INPUT "35074",
                                       INPUT "EMS":U,
                                       INPUT "ERROR":U,
                                       INPUT RETURN-VALUE,
                                       INPUT "",
                                       INPUT "":U).
               RETURN 'NOK'.
            END.
         &ENDIF
      &ENDIF.
  END.

for each estabelec fields (cod-estabel) no-lock:
    for first item 
      fields (cod-estabel deposito-pad)
      where item.cod-estabel  = estabelec.cod-estabel and
            item.deposito-pad = RowObject.cod-depos 
      no-lock:
        {utp/ut-field.i mgind ITEM cod-depos 1}
        RUN utp/ut-msgs.p (INPUT "msg", INPUT 3, INPUT RETURN-VALUE).
        RUN _insertErrorManual (INPUT "3",
                                INPUT "EMS":U,
                                INPUT "ERROR":U,
                                INPUT RETURN-VALUE,
                                INPUT "",
                                INPUT "":U).
        return 'NOK':U.
    end.
    if can-find (FIRST localizacao
                 where localizacao.cod-depos = RowObject.cod-depos
                   and localizacao.cod-estabel = estabelec.cod-estabel) then do:
       RUN utp/ut-msgs.p (INPUT "msg", INPUT 15830, INPUT "").
       RUN _insertErrorManual (INPUT "15830",
                               INPUT "EMS":U,
                               INPUT "ERROR":U,
                               INPUT RETURN-VALUE,
                               INPUT "",
                               INPUT "":U).
       RETURN 'NOK'.
    end. 
end.

for first contabiliza 
  fields (cod-depos) 
  where contabiliza.cod-depos = RowObject.cod-depos no-lock:
   {utp/ut-field.i mgind contabiliza cod-depos 1}
    RUN utp/ut-msgs.p (INPUT "msg", INPUT 3, INPUT RETURN-VALUE).
    RUN _insertErrorManual (INPUT "3",
                            INPUT "EMS":U,
                            INPUT "ERROR":U,
                            INPUT RETURN-VALUE,
                            INPUT "",
                            INPUT "":U).
    return 'NOK':U.
end.

for first param-cp 
  fields (dep-fabrica)
  where param-cp.dep-fabrica = RowObject.cod-depos no-lock:
   {utp/ut-field.i mgind contabiliza cod-depos 1}
   RUN utp/ut-msgs.p (INPUT "msg", INPUT 3, INPUT RETURN-VALUE).
   RUN _insertErrorManual (INPUT "3",
                           INPUT "EMS":U,
                           INPUT "ERROR":U,
                           INPUT RETURN-VALUE,
                           INPUT "",
                           INPUT "":U).
   return 'NOK':U.
end.

if  param-estoq.depos-pad = RowObject.cod-depos then do:
    {utp/ut-field.i mgind param-estoq cod-depos 1}
    RUN utp/ut-msgs.p (INPUT "msg", INPUT 3, INPUT RETURN-VALUE).
    RUN _insertErrorManual (INPUT "3",
                            INPUT "EMS":U,
                            INPUT "ERROR":U,
                            INPUT RETURN-VALUE,
                            INPUT "",
                            INPUT "":U).
    return 'NOK':U.
end.

IF CAN-find(FIRST lin-prod NO-LOCK
            WHERE lin-prod.deposito-pad = RowObject.cod-depos) THEN DO:
    {utp/ut-field.i mgind lin-prod deposito-pad 1}
    RUN utp/ut-msgs.p (INPUT "msg", INPUT 3, INPUT RETURN-VALUE).
    RUN _insertErrorManual (INPUT "3",
                            INPUT "EMS":U,
                            INPUT "ERROR":U,
                            INPUT RETURN-VALUE,
                            INPUT "",
                            INPUT "":U).

    return "NOK". 
END.

if can-find (first saldo-estoq 
             where saldo-estoq.cod-depos = RowObject.cod-depos) then do:
    RUN utp/ut-msgs.p (INPUT "msg", INPUT 6714, INPUT "").
    RUN _insertErrorManual (INPUT "6714",
                            INPUT "EMS":U,
                            INPUT "ERROR":U,
                            INPUT RETURN-VALUE,
                            INPUT "",
                            INPUT "":U).
    return "NOK". 
end. 

&if "{&bf_mat_versao_ems}" >= "2.062" &then
    IF CAN-FIND (first unid-negoc-depos
                 where unid-negoc-depos.cod-depos = RowObject.cod-depos) THEN DO:
        {utp/ut-field.i mgind contabiliza cod-depos 1}
        RUN utp/ut-msgs.p (INPUT "msg", INPUT 3, INPUT RETURN-VALUE).
        RUN _insertErrorManual (INPUT "3",
                                INPUT "EMS":U,
                                INPUT "ERROR":U,
                                INPUT RETURN-VALUE,
                                INPUT "",
                                INPUT "":U).
        return 'NOK':U.
end.
&endif

     /******Valida‡Æo para Frotas*****/
     do i-cont = 1 to 5:
        if i-cont <> 3
        and i-cont <> 4 then do:
            run cdp/cd9902.p (input i-cont).
            if return-value = "OK":U then do:
                assign lValida = yes.
                leave.
            end.
        end.
    end.
    if lValida then do:
        /** Passa o rowid para API de Frotas **/
        run abp/abapi008.p persistent set h-abapi008 (input rowid(RowObject)).
        /** Valida»„es **/
        run validateDeposito in h-abapi008 (INPUT RowObject.cod-depos).
        if return-value = "NOK":U then do:
            for each RowErrorsFrotas exclusive-lock:
                delete RowErrorsFrotas.
            end.
            /** Busca os erros ocorridos em frotas **/
            run getRowErrors in h-abapi008 (output table RowErrorsFrotas).
            assign i-cont = 0.
            /** Se ocorreram erros no produto padr’o, busca a œltima sequ¼ncia **/
            for last tt-erro no-lock:
                assign i-cont = tt-erro.i-sequen.
            end.
            /** Percorre os erros ocorridos em frotas **/
            for each RowErrorsFrotas no-lock:
                /** Cria os erros no produto padr’o **/
                create tt-erro.
                assign tt-erro.i-sequen = i-cont + 1
                       tt-erro.cd-erro  = RowErrorsFrotas.ErrorNumber
                       tt-erro.mensagem = RowErrorsFrotas.ErrorDescription
                       i-cont           = tt-erro.i-sequen.
            end.
            empty temp-table RowErrorsFrotas.
            /** Mostra os Erros ocorridos **/
            FOR EACH tt-erro:
                RUN utp/ut-msgs.p (INPUT "msg":U,
                                   INPUT tt-erro.cd-erro,
                                   INPUT "").
                RUN _insertErrorManual (INPUT tt-erro.cd-erro,
                                        INPUT "EMS":U,
                                        INPUT "ERROR":U,
                                        INPUT RETURN-VALUE,
                                        INPUT "",
                                        INPUT "":U).
            END.
            /** Elimina a API da mem½ria **/
            if valid-handle(h-abapi008) then
                delete procedure h-abapi008.
            return "NOK":U.
        end.
        /** Elimina a API da mem½ria **/
        if valid-handle(h-abapi008) then
            delete procedure h-abapi008.
    end.
    /***********************************************************/

&IF '{&mgscm_version}' >= '2.06B' &THEN
    IF CONNECTED('mgscm') THEN DO: 
        IF NOT VALID-HANDLE(hDBOproxy) THEN
            RUN wmp/wmprx037.p PERSISTENT SET hDBOproxy.
        RUN eliminaDeposito IN hDBOproxy(INPUT RowObject.cod-depos,
                                         OUTPUT TABLE RowErrors).
        IF CAN-FIND(FIRST RowErrors
                    WHERE RowErrors.ErrorType <> 'INTERNAL':U) THEN DO:
            RUN destroy IN hDBOproxy.
            RETURN "NOK".
        END.
        RUN destroy IN hDBOproxy.
    END.
&ENDIF

/*ELIMINA DIRETAMENTE O RELACIONAMENTO USUµRIO X DEPàSITO (CD1760)*/
FOR EACH usuar-depos EXCLUSIVE-LOCK
   WHERE usuar-depos.cod-depos = RowObject.cod-depos: 
    DELETE usuar-depos.
END.

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
    IF CAN-FIND (FIRST funcao 
                 WHERE funcao.cd-funcao = "spp-integra-ems-his"
                   AND   funcao.ativo     = YES) THEN DO:

        &IF "{&bf_mat_versao_ems}":U >= "2.08":U &THEN
            IF program-name(3) MATCHES "*ceapi305*" THEN
                ASSIGN deposito.log-orig-ext = YES.
        &ELSE 
            &IF "{&bf_mat_versao_ems}":U >= "2.062":U &THEN
                IF program-name(3) MATCHES "*ceapi305*" THEN DO:
                     ASSIGN OVERLAY (deposito.char-1,2,1) = "S".             
                END.
    
            &ENDIF
        &ENDIF
        
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cria-TT-Deposito DBOProgram 
PROCEDURE cria-TT-Deposito :
/*------------------------------------------------------------------------------
  Purpose:    Este procedimento tem por objetivo criar uma temp-table da tabela
              dep¢sito, seguindo algumas faixas de dados.
  Parameters: o-par1: temp-table tt-deposito
  Notes:      Este procedimento foi criado primeiramente para ser utilizado no
              programa de aloca‡Æo, WCP0315, mas nada impede de ser utilizado
              em outros programas.
------------------------------------------------------------------------------*/
define output parameter table for tt-deposito.
def var c-lista-tipos-deposito as char no-undo.

   do on error undo, return error:

      for each tt-deposito: 
         delete tt-deposito.
      end.

      assign c-lista-tipos-deposito = {ininc/i01in084.i 03}.

      for each deposito
         where deposito.alocado = yes no-lock :

         if deposito.ind-dep-cq  or
            deposito.ind-dep-rej then next.      

            create tt-deposito.
            assign tt-deposito.r-rowid      = rowid(deposito)
                   tt-deposito.cod-depos    = deposito.cod-depos
                   tt-deposito.nome         = deposito.nome
                   tt-deposito.aloc         = if deposito.alocado = YES then "SIM" else "NÇO"
                   tt-deposito.alocado      = deposito.alocado
                   tt-deposito.ind-tipo-dep = entry(deposito.ind-tipo-dep,c-lista-tipos-deposito)
                   tt-deposito.ind-processo = deposito.ind-processo
                   tt-deposito.indicador    = yes.
      end.
   end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findDeposito DBOProgram 
PROCEDURE findDeposito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
   
    def input parameter pccod-depos as char no-undo.
    def output parameter pcreturn as char no-undo.
 
    RUN openQueryStatic (input "main":U).
 
    run goToKey (input pccod-depos).

        if return-value = "OK" then assign pcreturn = "".  /* esse ‚ o valor esperado nas interfaces 1.1 */
        if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign pcreturn = return-value.
    end.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findDepositoAlocacao DBOProgram 
PROCEDURE findDepositoAlocacao :
DEFINE INPUT PARAMETER pcod-depos LIKE deposito.cod-depos NO-UNDO.

    FIND FIRST bfdeposito WHERE
        bfdeposito.cod-depos = pcod-depos AND
        bfdeposito.alocado = yes
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdeposito THEN
        RETURN "NOK":U.

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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "nome":U THEN ASSIGN pFieldValue = RowObject.nome.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "permissao[01]":U THEN ASSIGN pFieldValue = RowObject.permissao[01].
        WHEN "permissao[02]":U THEN ASSIGN pFieldValue = RowObject.permissao[02].
        WHEN "permissao[03]":U THEN ASSIGN pFieldValue = RowObject.permissao[03].
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "ind-tipo-dep":U THEN ASSIGN pFieldValue = RowObject.ind-tipo-dep.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ­ndice DEPOSITO
  Parameters:
               retorna valor dos campos do ­ndice DEPOSITO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-depos LIKE deposito.cod-depos NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-depos = RowObject.cod-depos.

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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "ind-acabado":U THEN ASSIGN pFieldValue = RowObject.ind-acabado.
        WHEN "ind-dep-cq":U THEN ASSIGN pFieldValue = RowObject.ind-dep-cq.
        WHEN "ind-dep-rej":U THEN ASSIGN pFieldValue = RowObject.ind-dep-rej.
        WHEN "ind-disp-saldo":U THEN ASSIGN pFieldValue = RowObject.ind-disp-saldo.
        WHEN "ind-processo":U THEN ASSIGN pFieldValue = RowObject.ind-processo.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        &IF "{&mgscm_version}" >= "2.05" &THEN
            WHEN "log-gera-wms":U THEN ASSIGN pFieldValue = RowObject.log-gera-wms.
            WHEN "log-aloca-qtd-wms":U THEN ASSIGN pFieldValue = RowObject.log-aloca-qtd-wms.
        &ENDIF
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "alocado":U THEN ASSIGN pFieldValue = RowObject.alocado.
        WHEN "cons-saldo":U THEN ASSIGN pFieldValue = RowObject.cons-saldo.
        WHEN "log-wms-externo":U THEN ASSIGN pFieldValue = RowObject.log-wms-externo.
        WHEN "log-aloca-saldo-wms-ext":U THEN ASSIGN pFieldValue = RowObject.log-aloca-saldo-wms-ext.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNomeDepos DBOProgram 
PROCEDURE getNomeDepos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE  INPUT PARAM p-cod-depos   AS CHAR NO-UNDO.
DEFINE OUTPUT PARAM p-nome-depos  AS CHAR NO-UNDO.

FIND FIRST deposito
     WHERE deposito.cod-depos = p-cod-depos NO-LOCK NO-ERROR.

IF AVAIL deposito THEN
    ASSIGN p-nome-depos = deposito.nome.
ELSE 
    ASSIGN p-nome-depos = "".

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowObjectExtra DBOProgram 
PROCEDURE getRowObjectExtra :
DEFINE OUTPUT PARAMETER TABLE FOR RowObjectExtra.
        
        
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ­ndice DEPOSITO
  Parameters:
               recebe valor dos campos do ­ndice DEPOSITO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-depos LIKE deposito.cod-depos NO-UNDO.

    FIND FIRST bfdeposito WHERE
        bfdeposito.cod-depos = pcod-depos
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdeposito THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdeposito)).
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
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then 
           run openQueryStatic ("Main").
        when 2 then
           run openQueryStatic ("ByCodDepos").   
        end. /*end case*/
   RETURN "OK":U.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByCodDepos DBOProgram 
PROCEDURE openQueryByCodDepos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  open query {&QUERYNAME} for each {&TABLENAME}  where
             {&TABLENAME}.cod-depos >= ccod-depos-ini AND
             {&TABLENAME}.cod-depos <= ccod-depos-fim AND
             lookup(string({&tablename}.ind-tipo-dep),c-sit) = 0 
             NO-LOCK USE-INDEX DEPOSITO INDEXED-REPOSITION.

  return "OK":U.           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram 
PROCEDURE openQueryDefault :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH deposito NO-LOCK INDEXED-REPOSITION.

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
    OPEN QUERY {&QueryName} FOR EACH deposito NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangeNome DBOProgram 
PROCEDURE openQueryRangeNome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME}  where
                                     {&TABLENAME}.nome >= c-nomeini AND
                                     {&TABLENAME}.nome <= c-nomefim AND
                                     lookup(string({&tablename}.ind-tipo-dep),c-sit) = 0
                                     NO-LOCK BY {&TABLENAME}.nome INDEXED-REPOSITION.             

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-Calcula-Saldo DBOProgram 
PROCEDURE pi-Calcula-Saldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM c-cod-refer        AS CHAR NO-UNDO.
    DEF INPUT PARAM c-cod-estabel-par  AS CHAR NO-UNDO.
    DEF INPUT PARAM l-dep-cq-par       AS LOG  NO-UNDO.
    DEF INPUT PARAM i-cb-deposito-par  AS INT  NO-UNDO. 
    DEFINE INPUT PARAMETER TABLE FOR tt-deposito.
    DEFINE INPUT PARAMETER TABLE FOR tt-item.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-val-saldo.
    
    FIND FIRST param-global NO-LOCK NO-ERROR.
    FIND FIRST para-ped NO-LOCK NO-ERROR.
    FIND FIRST tt-deposito NO-LOCK NO-ERROR.
    FIND FIRST tt-item NO-LOCK NO-ERROR.

    FOR EACH tt-val-saldo:
        DELETE tt-val-saldo.
    END.
    
    CREATE tt-val-saldo.
    ASSIGN tt-val-saldo.de-saldo-est   = 0
           tt-val-saldo.de-qt-alocada  = 0
           tt-val-saldo.de-quant-segur = 0
           tt-val-saldo.de-saldo-inic  = 0.

    IF  param-global.modulo-ce THEN DO:
        IF  NOT AVAIL tt-deposito THEN DO:
            FOR  EACH deposito NO-LOCK 
                WHERE deposito.ind-dep-rej = NO 
                  AND deposito.cons-saldo  = YES
                  AND ((deposito.ind-dep-cq = YES
                  AND   l-dep-cq-par = YES)
                   OR   deposito.ind-dep-cq = NO)
                  AND ((deposito.ind-tipo-dep = i-cb-deposito-par
                  AND   i-cb-deposito-par <= 2)
                   OR   i-cb-deposito-par = 3),
                 EACH saldo-estoq USE-INDEX ITEM 
                WHERE saldo-estoq.it-codigo   = tt-item.it-codigo     
                  AND saldo-estoq.cod-refer   = c-cod-refer
                  AND saldo-estoq.cod-depos   = deposito.cod-depos
                  AND saldo-estoq.cod-estabel = c-cod-estabel-par NO-LOCK:
                
                IF  tt-item.tipo-con-est >= 3 /*refer e lote*/ AND
                    saldo-estoq.dt-vali-lote < TODAY THEN
                    NEXT.
    
                ASSIGN tt-val-saldo.de-saldo-inic = tt-val-saldo.de-saldo-inic + saldo-estoq.qtidade-atu
                       tt-val-saldo.de-qt-alocada = tt-val-saldo.de-qt-alocada + saldo-estoq.qt-alocada.
            END.
        END.
        ELSE DO:
            FOR  EACH tt-deposito,
                 EACH deposito NO-LOCK 
                WHERE deposito.cod-depos    = tt-deposito.cod-depos 
                  AND deposito.cons-saldo   = YES
                  AND deposito.ind-dep-rej  = NO
                  AND ((deposito.ind-dep-cq = YES
                  AND   l-dep-cq-par = YES)
                   OR   deposito.ind-dep-cq = NO)
                  AND ((deposito.ind-tipo-dep = i-cb-deposito-par
                  AND   i-cb-deposito-par    <= 2)
                   OR   i-cb-deposito-par     = 3),
                 EACH saldo-estoq USE-INDEX ITEM
                WHERE saldo-estoq.it-codigo   = tt-item.it-codigo
                  AND saldo-estoq.cod-refer   = c-cod-refer
                  AND saldo-estoq.cod-depos   = deposito.cod-depos
                  AND saldo-estoq.cod-estabel = c-cod-estabel-par  NO-LOCK:
                
                IF  tt-item.tipo-con-est >= 3 /*refer e lote*/ AND
                    saldo-estoq.dt-vali-lote < TODAY THEN
                    NEXT.
                    
                ASSIGN tt-val-saldo.de-saldo-inic = tt-val-saldo.de-saldo-inic + saldo-estoq.qtidade-atu
                       tt-val-saldo.de-qt-alocada = tt-val-saldo.de-qt-alocada + saldo-estoq.qt-alocada.
            END.
        END.
    
        ASSIGN tt-val-saldo.de-quant-segur = IF  tt-item.tipo-est-seg = 2 THEN 
                                                (tt-item.consumo-prev / 30) * tt-item.tempo-segur
                                             ELSE 
                                                 tt-item.quant-segur.
    
        IF  NOT(tt-item.fraciona) AND tt-val-saldo.de-quant-segur <> INTEGER(tt-val-saldo.de-quant-segur) THEN
            ASSIGN tt-val-saldo.de-quant-segur = TRUNCATE(tt-val-saldo.de-quant-segur,0) + 1.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-exclusao-eai DBOProgram 
PROCEDURE pi-valida-exclusao-eai :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM c-depos LIKE deposito.cod-depos NO-UNDO.

    FIND FIRST ITEM
         WHERE ITEM.deposito-pad = c-depos NO-LOCK NO-ERROR.
    IF AVAIL ITEM THEN
        RETURN "NOK":U.
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
  def input param pccod-depos-ini  as char no-undo.
  
   
       run setConstraintCodDepos(input pccod-depos-ini,
                                 input pccod-depos-ini,
                                 input "").  /* passei esse valor em branco para que 
                                                a query nÆo se limite por ind-tipo-depos */
   
  return "OK":U.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodDepos DBOProgram 
PROCEDURE setConstraintCodDepos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 def input parameter pcod-depos-ini   as  char.
 def input parameter pcod-depos-fim   as  char.
 def input parameter pc-sit           as  char.
     
         assign ccod-depos-ini = pcod-depos-ini
                ccod-depos-fim = pcod-depos-fim
                c-sit          = pc-sit.
                
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintRangeNome DBOProgram 
PROCEDURE setconstraintRangeNome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pc-nomeini like deposito.nome no-undo.
def input param pc-nomefim like deposito.nome no-undo.
def input param pc-sit     as char            no-undo.

assign c-nomeini = pc-nomeini
       c-nomefim = pc-nomefim
       c-sit     = pc-sit.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDeleteFrotas DBOProgram 
PROCEDURE validateDeleteFrotas :
/*------------------------------------------------------------------------------
  Purpose: Valida as tabelas de Frotas    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

define variable h-abapi008 as handle  no-undo.
define variable iErro      as integer no-undo.
define variable lValida    as logical no-undo.
define variable i-cont     as integer no-undo.



assign lValida = no.
do i-cont = 1 to 5:
    if i-cont <> 3
    and i-cont <> 4 then do:
        run cdp/cd9902.p (input i-cont).
        if return-value = "OK":U then do:
            assign lValida = yes.
            leave.
        end.
    end.
end.
if lValida then do:
    /** Passa o rowid para API de Frotas **/
    run abp/abapi008.p persistent set h-abapi008 (input RowObject.r-rowid).
    /** Valida‡äes de Frotas **/
    run validateDeposito in h-abapi008 (INPUT RowObject.cod-depos).
    if return-value = "NOK":U then do:
        for each RowErrorsFrotas exclusive-lock:
            delete RowErrorsFrotas.
        end.
        /** Busca os erros ocorridos em frotas **/
        run getRowErrors in h-abapi008 (output table RowErrorsFrotas).
        assign iErro = 0.
        /** Se ocorreram erros noproduto padrÆo, busca a £ltima sequˆncia **/
        for last RowErrors no-lock:
            assign iErro = RowErrors.ErrorSequence.
        end.
        /** Percorre os erros ocorridos em frotas **/
        for each RowErrorsFrotas no-lock:
            /** Cria os erros no produto padrÆo **/
            create RowErrors.
            buffer-copy RowErrorsFrotas except ErrorSequence to RowErrors
                assign RowErrors.ErrorSequence = iErro + 1
                       iErro                   = RowErrors.ErrorSequence.
        end.
        for each RowErrorsFrotas exclusive-lock:
            delete RowErrorsFrotas.
        end.
    end.
    /** Elimina a API da mem¢ria **/
    if valid-handle(h-abapi008) then
        delete procedure h-abapi008.
end.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de valida»’o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    FIND FIRST rowObject NO-ERROR. 

    /*--- Utilize o par³metro pType para identificar quais as valida»„es a serem
          executadas ---*/
    /*--- Os valores poss­veis para o par³metro s’o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav²s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida»„es ---*/

    if pType = "DELETE":U then do:
       run validateDeleteFrotas in this-procedure.
    end.


    /*--- Verifica ocorr¼ncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION FN_logical DBOProgram 
FUNCTION FN_logical RETURNS CHARACTER
  ( p-log AS LOGICAL ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    RETURN  IF(p-log) THEN c-sim ELSE c-nao.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

