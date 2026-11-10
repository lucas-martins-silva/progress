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
{include/i-prgvrs.i BOIN122 2.00.01.009 } /*** "010109" 01/12/2023 10:51:00  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin122 MUT}
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
&GLOBAL-DEFINE DBOName familia
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName familia
&GLOBAL-DEFINE TableLabel familia
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE KeyField1 fm-codigo /*:T Informar os campos da chave quando o Progress n’o conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m²todo Receive Message) */
/* &GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES */

/*--- Include com defini»’o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com
      extens’o .i ---*/
{inbo/boin122.i RowObject}

/*--- Include com defini»’o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera»’o da defini»’o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»’o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/*-------------Defini‡Æo para SetconstraintByFmCodigo------------*/

DEFINE VARIABLE cfm-codigo-ini LIKE familia.fm-codigo NO-UNDO.
DEFINE VARIABLE cfm-codigo-fim LIKE familia.fm-codigo NO-UNDO.
DEFINE VARIABLE cdescricao-ini LIKE familia.fm-codigo NO-UNDO.
DEFINE VARIABLE cdescricao-fim LIKE familia.fm-codigo NO-UNDO.
DEFINE VARIABLE creturn        AS CHARACTER NO-UNDO.

&IF '{&mgscm_version}' >= '2.06B' &THEN
DEFINE VARIABLE hDBOproxy       AS HANDLE NO-UNDO.
&ENDIF

/* Integra‡Æo EMS EAI2.0 Mensagem unica */
DEFINE NEW GLOBAL SHARED VARIABLE v_log_eai2_ativado AS LOGICAL NO-UNDO INITIAL NO.
DEFINE VARIABLE h-cdapi996     AS HANDLE NO-UNDO. 

/* Carrega a vari vel global v_log_eai2_ativado */
RUN cdp/cd0101i.p. 


{utp/ut-glob.i}

def var i-tp-contr-ini   like familia.tipo-con-est no-undo.
def var i-tp-contr-fim   like familia.tipo-con-est no-undo.

/******************************ATENCAO*************************************
 Pre-processador abaixo responsavel por distinguir o produto que
 esta executando o componente ( Magnus ou EMS ). 
 Se estiver definida a variavel bf-mat-comex 
 ( &if defined(bf-mat-comex) &then ), significa que o produto
 chamador e o Magnus se nÆo, EMS. Utilizado pelo produto Comercio Exterior
**************************************************************************/ 

{cdp/cdcfgmat.i} /* Definicao de pre-processadores - Magnus ou EMS */
{cdp/cdcfgman.i} /* Definicao de pre-processadores - Manufatura */
{cdp/cd7300.i1} /* MultiPlanta */
&if defined(bf_mat_tipo_ressup) &then
    def temp-table tt-familia like familia
        INDEX ch-codigo IS PRIMARY fm-codigo.    
    def temp-table tt-familia-mat like familia-mat
        INDEX ch-codigo IS PRIMARY fm-codigo.
&endif

def var iDemanda    as int init ? no-undo.
def var iTipoEstSeg as int init ? no-undo.

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
         HEIGHT             = 2.13
         WIDTH              = 36.29.
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
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
   /*--- A partir da versao 2.02 do EMS deve sempre 
         existir a familia-mat para a familia ---*/
   &if defined(bf_mat_receb_fisico) &then
       if  avail familia then
           if  not can-find(first familia-mat 
                            where familia-mat.fm-codigo = familia.fm-codigo) then do:
               create familia-mat.
               assign familia-mat.fm-codigo = familia.fm-codigo.
           end.
   &endif
   
   return "OK":U.

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
    &IF '{&mgscm_version}' >= '2.06B' &THEN
        IF CONNECTED('mgscm') THEN DO: 
            FIND FIRST bf{&TableName}
                 WHERE bf{&TableName}.fm-codigo = RowObject.fm-codigo NO-LOCK NO-ERROR.
            IF AVAIL bf{&TableName} THEN DO:
                IF NOT VALID-HANDLE(hDBOproxy) THEN
                    RUN wmp/wmprx042.p PERSISTENT SET hDBOproxy.
                IF VALID-HANDLE(hDBOproxy) THEN DO:
                    RUN ReplicaFamilia IN hDBOproxy(INPUT 2,
                                                    INPUT bf{&TableName}.fm-codigo,
                                                    INPUT bf{&TableName}.descricao,
                                                    INPUT bf{&TableName}.un,
                                                    INPUT bf{&TableName}.tipo-con-est,
                                                    OUTPUT TABLE RowErrors).
                END.
            END.
            RUN destroy  IN hDBOproxy.
            RETURN "NOK":U.
        END.
    &ENDIF
    
     &IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
        IF v_log_eai2_ativado THEN DO:        
            FIND FIRST bf{&TableName} NO-LOCK 
                 WHERE bf{&TableName}.fm-codigo = RowObject.fm-codigo NO-ERROR.
            IF AVAILABLE bf{&TableName} THEN DO:
                IF NOT VALID-HANDLE(h-cdapi996) THEN
                    RUN cdp/cdapi996.p PERSISTENT SET h-cdapi996.
                    
                RUN pi-sendUpsert IN h-cdapi996 (INPUT ROWID(bf{&TableName}), OUTPUT TABLE RowErrors).
                
                IF VALID-HANDLE(h-cdapi996) THEN DO:
                    DELETE PROCEDURE h-cdapi996 NO-ERROR.
                    ASSIGN h-cdapi996 = ?.
                END.
                
                IF CAN-FIND(FIRST RowErrors) THEN
                    RETURN "NOK":U.
                
            END.
        END.
         
    &ENDIF
    
    
   
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

    if iDemanda <> ? then
        assign familia.demanda = iDemanda.
        
    if iTipoEstSeg <> ? then
        assign familia.tipo-est-seg = iTipoEstSeg.

    &IF '{&mgscm_version}' >= '2.06B' &THEN
        IF CONNECTED('mgscm') THEN DO: 
            FIND FIRST bf{&TableName}
                 WHERE bf{&TableName}.fm-codigo = RowObject.fm-codigo NO-LOCK NO-ERROR.
            IF AVAIL bf{&TableName} THEN DO:
                IF NOT VALID-HANDLE(hDBOproxy) THEN
                    RUN wmp/wmprx042.p PERSISTENT SET hDBOproxy.
                IF VALID-HANDLE(hDBOproxy) THEN DO:
                    RUN ReplicaFamilia IN hDBOproxy(INPUT 2,
                                                    INPUT bf{&TableName}.fm-codigo,
                                                    INPUT bf{&TableName}.descricao,
                                                    INPUT bf{&TableName}.un,
                                                    INPUT bf{&TableName}.tipo-con-est,
                                                    OUTPUT TABLE RowErrors).
                    IF RETURN-VALUE = 'NOK':U THEN DO:
                        FOR EACH RowErrors:
                            RUN utp/ut-msgs.p (INPUT "show":U,
                                               INPUT RowErrors.ErrorNumber,
                                               INPUT RowErrors.ErrorParameters).
                        END.
                        RUN destroy    IN hDBOproxy.
                        RETURN "NOK":U.
                    END.
                END.
            END.
            RUN destroy  IN hDBOproxy.
        END.
    &ENDIF
    
    &IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
        IF v_log_eai2_ativado THEN DO:        

            FIND FIRST bf{&TableName} NO-LOCK 
                 WHERE bf{&TableName}.fm-codigo = RowObject.fm-codigo NO-ERROR.
            IF AVAILABLE bf{&TableName} THEN DO:

                IF NOT VALID-HANDLE(h-cdapi996) THEN
                    RUN cdp/cdapi996.p PERSISTENT SET h-cdapi996.
                    
                RUN pi-sendUpsert IN h-cdapi996 (INPUT ROWID(bf{&TableName}), OUTPUT TABLE RowErrors).
                
                IF VALID-HANDLE(h-cdapi996) THEN DO:
                    DELETE PROCEDURE h-cdapi996 NO-ERROR.
                    ASSIGN h-cdapi996 = ?.
                END.
                
                IF CAN-FIND(FIRST RowErrors) THEN
                    RETURN "NOK":U.
            END.
        END.
         
    &ENDIF    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaDemanda DBOProgram 
PROCEDURE atualizaDemanda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pDemanda as int   no-undo.

assign iDemanda = pDemanda.    
    
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaTipoEstSeg DBOProgram 
PROCEDURE atualizaTipoEstSeg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pTipoEstSeg as int no-undo.

assign iTipoEstSeg = pTipoEstSeg.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCodigo DBOProgram 
PROCEDURE findCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    
    &if defined(bf-mat-comex) &then            
    &else     
       
        def input parameter pcfm-codigo as char no-undo.
        def output parameter pcreturn as char no-undo.
     
        RUN openQueryStatic (input "main":U).
     
        run goToKey (input pcfm-codigo).
    
            if return-value = "OK" then assign pcreturn = "".  /* esse ‚ o valor esperado nas interfaces 1.1 */
            if return-value = "NOK" then do:
            {utp/ut-table.i mgind {&TABLENAME} 1}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            assign pcreturn = return-value.
        end.
        
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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "class-fiscal":U THEN ASSIGN pFieldValue = RowObject.class-fiscal.
        WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
        WHEN "fm-codigo":U THEN ASSIGN pFieldValue = RowObject.fm-codigo.
        WHEN "deposito-pad":U THEN ASSIGN pFieldValue = RowObject.deposito-pad.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "niv-rest-icms":U THEN ASSIGN pFieldValue = RowObject.niv-rest-icms.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "cd-planejado":U THEN ASSIGN pFieldValue = RowObject.cd-planejado.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        &if defined(bf-mat-comex) &then            
            WHEN "classe-repro":U THEN ASSIGN pFieldValue = RowObject.classe-repro.        
            WHEN "criticidade":U THEN ASSIGN pFieldValue = RowObject.criticidade.                
            WHEN "politica":U THEN ASSIGN pFieldValue = RowObject.politica.        
            WHEN "tipo-contr":U THEN ASSIGN pFieldValue = RowObject.tipo-contr.        
            WHEN "tipo-requis":U THEN ASSIGN pFieldValue = RowObject.tipo-requis.        
            WHEN "cd-trib-icm":U THEN ASSIGN pFieldValue = RowObject.cd-trib-icm.
            WHEN "cd-trib-ipi":U THEN ASSIGN pFieldValue = RowObject.cd-trib-ipi.
            WHEN "cd-trib-iss":U THEN ASSIGN pFieldValue = RowObject.cd-trib-iss.        
            WHEN "localizacao":U THEN ASSIGN pFieldValue = RowObject.localizacao.                
            WHEN "u-char-1":U THEN ASSIGN pFieldValue = RowObject.u-char-1.
            WHEN "u-char-2":U THEN ASSIGN pFieldValue = RowObject.u-char-2.
        &else     
            WHEN "cod-lista-destino":U THEN ASSIGN pFieldValue = RowObject.cod-lista-destino.
            WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.        
            WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.                    
        &endif
        &IF DEFINED(bf_man_sfc_ref_oper) &THEN
            WHEN "cod-item-refugo":U THEN ASSIGN pFieldValue = RowObject.cod-item-refugo.
        &ENDIF
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
        WHEN "fator-conver":U THEN ASSIGN pFieldValue = RowObject.fator-conver.
        WHEN "fator-ponder[01]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[01].
        WHEN "fator-ponder[02]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[02].
        WHEN "fator-ponder[03]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[03].
        WHEN "fator-ponder[04]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[04].
        WHEN "fator-ponder[05]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[05].
        WHEN "fator-ponder[06]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[06].
        WHEN "fator-ponder[07]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[07].
        WHEN "fator-ponder[08]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[08].
        WHEN "fator-ponder[09]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[09].
        WHEN "fator-ponder[10]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[10].
        WHEN "fator-ponder[11]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[11].
        WHEN "fator-ponder[12]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[12].
        WHEN "fator-refugo":U THEN ASSIGN pFieldValue = RowObject.fator-refugo.
        WHEN "ind-cons-prv":U THEN ASSIGN pFieldValue = RowObject.ind-cons-prv.
        WHEN "lote-economi":U THEN ASSIGN pFieldValue = RowObject.lote-economi.
        WHEN "lote-minimo":U THEN ASSIGN pFieldValue = RowObject.lote-minimo.
        WHEN "lote-multipl":U THEN ASSIGN pFieldValue = RowObject.lote-multipl.
        WHEN "per-rest-icms":U THEN ASSIGN pFieldValue = RowObject.per-rest-icms.
        WHEN "perc-nqa":U THEN ASSIGN pFieldValue = RowObject.perc-nqa.
        WHEN "qt-max-ordem":U THEN ASSIGN pFieldValue = RowObject.qt-max-ordem.
        WHEN "quant-perda":U THEN ASSIGN pFieldValue = RowObject.quant-perda.
        WHEN "quant-segur":U THEN ASSIGN pFieldValue = RowObject.quant-segur.
        WHEN "sazonalidade[01]":U THEN ASSIGN pFieldValue = RowObject.sazonalidade[01].
        WHEN "sazonalidade[02]":U THEN ASSIGN pFieldValue = RowObject.sazonalidade[02].
        WHEN "sazonalidade[03]":U THEN ASSIGN pFieldValue = RowObject.sazonalidade[03].
        WHEN "sazonalidade[04]":U THEN ASSIGN pFieldValue = RowObject.sazonalidade[04].
        WHEN "sazonalidade[05]":U THEN ASSIGN pFieldValue = RowObject.sazonalidade[05].
        WHEN "sazonalidade[06]":U THEN ASSIGN pFieldValue = RowObject.sazonalidade[06].
        WHEN "sazonalidade[07]":U THEN ASSIGN pFieldValue = RowObject.sazonalidade[07].
        WHEN "sazonalidade[08]":U THEN ASSIGN pFieldValue = RowObject.sazonalidade[08].
        WHEN "sazonalidade[09]":U THEN ASSIGN pFieldValue = RowObject.sazonalidade[09].
        WHEN "sazonalidade[10]":U THEN ASSIGN pFieldValue = RowObject.sazonalidade[10].
        WHEN "sazonalidade[11]":U THEN ASSIGN pFieldValue = RowObject.sazonalidade[11].
        WHEN "sazonalidade[12]":U THEN ASSIGN pFieldValue = RowObject.sazonalidade[12].
        WHEN "tp-cons-prev":U THEN ASSIGN pFieldValue = RowObject.tp-cons-prev.
        WHEN "var-mob-maior":U THEN ASSIGN pFieldValue = RowObject.var-mob-maior.
        WHEN "var-mob-menor":U THEN ASSIGN pFieldValue = RowObject.var-mob-menor.
        WHEN "var-pre-perm":U THEN ASSIGN pFieldValue = RowObject.var-pre-perm.
        WHEN "var-qtd-perm":U THEN ASSIGN pFieldValue = RowObject.var-qtd-perm.
        WHEN "var-rep":U THEN ASSIGN pFieldValue = RowObject.var-rep.
        WHEN "var-req-maior":U THEN ASSIGN pFieldValue = RowObject.var-req-maior.
        WHEN "var-req-menor":U THEN ASSIGN pFieldValue = RowObject.var-req-menor.
        WHEN "var-transf":U THEN ASSIGN pFieldValue = RowObject.var-transf.
        WHEN "vl-max-inv":U THEN ASSIGN pFieldValue = RowObject.vl-max-inv.
        WHEN "vl-min-inv":U THEN ASSIGN pFieldValue = RowObject.vl-min-inv.
        WHEN "cap-est-fabr":U THEN ASSIGN pFieldValue = RowObject.cap-est-fabr.
        &if defined(bf-mat-comex) &then   
            WHEN "u-dec-1":U THEN ASSIGN pFieldValue = RowObject.u-dec-1.                
        &else    
            WHEN "qtd-batch-padrao":U THEN ASSIGN pFieldValue = RowObject.qtd-batch-padrao.        
        &ENDIF
        &IF DEFINED(bf_man_sfc_ref_oper) &THEN
            WHEN "val-relac-refugo-item":U THEN ASSIGN pFieldValue = RowObject.val-relac-refugo-item.
        &ENDIF
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescClassFiscal DBOProgram 
PROCEDURE getDescClassFiscal :
/*------------------------------------------------------------------------------
  Parameters: pc-class-fiscal      - recebe o c¢digo da Class Fiscal
              pc-desc-class-fiscal - retorna a descri‡Æo
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-class-fiscal      like classif-fisc.class-fiscal no-undo.
    def output param pc-desc-class-fiscal like classif-fisc.descricao    no-undo.

    for first classif-fisc fields (descricao)
        where classif-fisc.class-fiscal = pc-class-fiscal no-lock: end.
    
    if avail classif-fisc then
       assign pc-desc-class-fiscal = classif-fisc.descricao.    
    else do:
         assign pc-desc-class-fiscal = "".
         return "NOK":U.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescComprador DBOProgram 
PROCEDURE getDescComprador :
/*------------------------------------------------------------------------------
  Parameters: pc-cod-comprador  - recebe o c¢digo do Comprador
              pc-desc-comprador - retorna a descri‡Æo
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-cod-comprador   like comprador.cod-comprado no-undo.
    def output param pc-desc-comprador  like comprador.nome             no-undo.

    for first comprador fields (nome)
        where comprador.cod-comprado = pc-cod-comprador no-lock: end.
    
    if avail comprador then
       assign pc-desc-comprador = comprador.nome.    
    else do:
         assign pc-desc-comprador = "".
         return "NOK":U.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescDeposito DBOProgram 
PROCEDURE getDescDeposito :
/*------------------------------------------------------------------------------
  Parameters: pc-cod-depos  - recebe o c¢digo do Dep¢sito
              pc-desc-depos - retorna a descri‡Æo
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-cod-depos  like item.deposito-pad no-undo.
    def output param pc-desc-depos like deposito.nome              no-undo.

    for first deposito fields (nome)
        where deposito.cod-depos = pc-cod-depos no-lock: end.
    
    if avail deposito then
       assign pc-desc-depos = deposito.nome.    
    else do:
         assign pc-desc-depos = "".
         return "NOK":U.
    end.

    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescEstabelec DBOProgram 
PROCEDURE getDescEstabelec :
/*------------------------------------------------------------------------------
  Parameters: pc-cod-estabel  - recebe o c¢digo do Estabelecimento
              pc-desc-estabel - retorna a descri‡Æo
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-cod-estabel  like estabelec.cod-estabel no-undo.
    def output param pc-desc-estabel like estabelec.nome            no-undo.

    for first estabelec fields (nome)
        where estabelec.cod-estabel = pc-cod-estabel no-lock: end.
    
    if avail estabelec then
       assign pc-desc-estabel = estabelec.nome.    
    else do:
         assign pc-desc-estabel = "".
         return "NOK":U.
    end.

    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescFormula DBOProgram 
PROCEDURE getDescFormula :
/*------------------------------------------------------------------------------
  Parameters: pc-cod-fat-ponder  - recebe o c¢digo do Fator de Pondera‡Æo
              pc-desc-fat-ponder - retorna a descri‡Æo
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-cod-fat-ponder   as int  no-undo.
    def output param pc-desc-fat-ponder  as char no-undo.
    
    &if "{&bf_mat_versao_ems}" >= "2.03" &then
    for first fat-ponder fields (descricao)
        where fat-ponder.cod-fat-ponder = pc-cod-fat-ponder no-lock: end.
    
    if avail fat-ponder then
       assign pc-desc-fat-ponder = fat-ponder.descricao.    
    else do:
         assign pc-desc-fat-ponder = "".
         return "NOK":U.
    end.
    &endif
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescFrequencia DBOProgram 
PROCEDURE getDescFrequencia :
/*------------------------------------------------------------------------------
  Parameters: pc-cod-frequencia  - recebe o c¢digo da Frequencia
              pc-desc-frequencia - retorna a descri‡Æo
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-cod-frequencia   like frequencia.cd-freq   no-undo.
    def output param pc-desc-frequencia  like frequencia.descricao no-undo.

    for first frequencia fields (descricao)
        where frequencia.cd-freq = pc-cod-frequencia no-lock: end.
    
    if avail frequencia then
       assign pc-desc-frequencia = frequencia.descricao.    
    else do:
         assign pc-desc-frequencia = "".
         return "NOK":U.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescGrpCompra DBOProgram 
PROCEDURE getDescGrpCompra :
/*------------------------------------------------------------------------------
  Parameters: pc-cod-grp-compra  - recebe o c¢digo do Grupo de Compra
              pc-desc-grp-compra - retorna a descri‡Æo
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-cod-grp-compra   like grupo-compra.cod-grp-compra no-undo.
    def output param pc-desc-grp-compra  like grupo-compra.des-grp-compra  no-undo.

    for first grupo-compra fields (des-grp-compra)
        where grupo-compra.cod-grp-compra = pc-cod-grp-compra no-lock: end.
    
    if avail grupo-compra then
       assign pc-desc-grp-compra = grupo-compra.des-grp-compra.    
    else do:
         assign pc-desc-grp-compra = "".
         return "NOK":U.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescLocaliz DBOProgram 
PROCEDURE getDescLocaliz :
/*------------------------------------------------------------------------------
  Parameters: pc-cod-estabel  - recebe o c¢digo do Estabelecimento
              pc-cod-depos    - recebe o c¢digo do Dep¢sito
              pc-cod-localiz  - recebe o c¢digo da Localiza‡Æo
              pc-desc-localiz - retorna a descri‡Æo
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-cod-estabel  like localizacao.cod-estabel  no-undo.
    def input  param pc-cod-depos    like item.deposito-pad        no-undo.
    def input  param pc-cod-localiz  like localizacao.cod-localiz  no-undo.        
    def output param pc-desc-localiz like localizacao.descricao    no-undo.

    for first localizacao fields (descricao)
        where localizacao.cod-estabel = pc-cod-estabel 
          and localizacao.cod-depos   = pc-cod-depos
          and localizacao.cod-localiz = pc-cod-localiz no-lock: end.
    
    if avail localizacao then
       assign pc-desc-localiz = localizacao.descricao.    
    else do:
         assign pc-desc-localiz = "".
         return "NOK":U.
    end.

    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescMoeda DBOProgram 
PROCEDURE getDescMoeda :
/*------------------------------------------------------------------------------
  Parameters: pc-mo-codigo - recebe o c¢digo da Moeda
              pc-descricao - retorna a descri‡Æo
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-mo-codigo  like moeda.mo-codigo no-undo.
    def output param pc-descricao  like moeda.descricao no-undo.

    for first moeda fields (descricao)
        where moeda.mo-codigo = pc-mo-codigo no-lock: end.
    
    if avail  moeda then
       assign pc-descricao = moeda.descricao.    
    else do:
         assign pc-descricao = "".
         return "NOK":U.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescNatDespesa DBOProgram 
PROCEDURE getDescNatDespesa :
/*------------------------------------------------------------------------------
  Parameters: pc-nat-despesa      - recebe o c¢digo da Natureza
              pc-desc-nat-despesa - retorna a descri‡Æo
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-nat-despesa       like natureza-despesa.nat-despesa no-undo.
    def output param pc-desc-nat-despesa  like familia.descricao            no-undo.

    for first natureza-despesa fields (descricao)
        where natureza-despesa.nat-despesa = pc-nat-despesa no-lock: end.
    
    if avail natureza-despesa then
       assign pc-desc-nat-despesa = natureza-despesa.descricao.    
    else do:
         assign pc-desc-nat-despesa = "".
         return "NOK":U.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescUn DBOProgram 
PROCEDURE getDescUn :
/*------------------------------------------------------------------------------
  Parameters: pc-un         - recebe o c¢digo da UN
              pc-descricao  - retorna a descri‡Æo
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-un        like tab-unidade.un        no-undo.
    def output param pc-descricao like tab-unidade.descricao no-undo.

    for first tab-unidade fields (descricao)
        where tab-unidade.un = pc-un no-lock: end.
    
    if avail tab-unidade then
       assign pc-descricao = tab-unidade.descricao.    
    else do:
         assign pc-descricao = "".
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
        WHEN "ciclo-contag":U THEN ASSIGN pFieldValue = RowObject.ciclo-contag.
        WHEN "cod-servico":U THEN ASSIGN pFieldValue = RowObject.cod-servico.
        WHEN "codigo-orig":U THEN ASSIGN pFieldValue = RowObject.codigo-orig.
        WHEN "div-ordem":U THEN ASSIGN pFieldValue = RowObject.div-ordem.
        WHEN "ind-imp-desc":U THEN ASSIGN pFieldValue = RowObject.ind-imp-desc.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "moeda-padrao":U THEN ASSIGN pFieldValue = RowObject.moeda-padrao.
        WHEN "nivel":U THEN ASSIGN pFieldValue = RowObject.nivel.
        WHEN "nr-linha":U THEN ASSIGN pFieldValue = RowObject.nr-linha.
        WHEN "periodo-fixo":U THEN ASSIGN pFieldValue = RowObject.periodo-fixo.
        WHEN "perm-saldo-neg":U THEN ASSIGN pFieldValue = RowObject.perm-saldo-neg.
        WHEN "prioridade":U THEN ASSIGN pFieldValue = RowObject.prioridade.
        WHEN "rep-prod":U THEN ASSIGN pFieldValue = RowObject.rep-prod.
        WHEN "res-cq-comp":U THEN ASSIGN pFieldValue = RowObject.res-cq-comp.
        WHEN "res-cq-fabri":U THEN ASSIGN pFieldValue = RowObject.res-cq-fabri.
        WHEN "res-for-comp":U THEN ASSIGN pFieldValue = RowObject.res-for-comp.
        WHEN "res-int-comp":U THEN ASSIGN pFieldValue = RowObject.res-int-comp.
        WHEN "ressup-fabri":U THEN ASSIGN pFieldValue = RowObject.ressup-fabri.
        WHEN "tempo-segur":U THEN ASSIGN pFieldValue = RowObject.tempo-segur.
        WHEN "tipo-con-est":U THEN ASSIGN pFieldValue = RowObject.tipo-con-est.
        WHEN "tipo-insp":U THEN ASSIGN pFieldValue = RowObject.tipo-insp.
        WHEN "tp-adm-lote":U THEN ASSIGN pFieldValue = RowObject.tp-adm-lote.
        WHEN "var-preco":U THEN ASSIGN pFieldValue = RowObject.var-preco.
        WHEN "var-quantid":U THEN ASSIGN pFieldValue = RowObject.var-quantid.
        WHEN "horiz-fixo":U THEN ASSIGN pFieldValue = RowObject.horiz-fixo.
        WHEN "cd-formula":U THEN ASSIGN pFieldValue = RowObject.cd-formula.
        WHEN "cd-origem":U THEN ASSIGN pFieldValue = RowObject.cd-origem.
        &if defined(bf-mat-comex) &then   
        &else
            WHEN "classe-repro":U THEN ASSIGN pFieldValue = RowObject.classe-repro.        
            WHEN "cod-taxa":U THEN ASSIGN pFieldValue = RowObject.cod-taxa.            
            WHEN "criticidade":U THEN ASSIGN pFieldValue = RowObject.criticidade.
            WHEN "demanda":U THEN ASSIGN pFieldValue = RowObject.demanda.                
            WHEN "emissao-ord":U THEN ASSIGN pFieldValue = RowObject.emissao-ord.                
            WHEN "ind-calc-meta":U THEN ASSIGN pFieldValue = RowObject.ind-calc-meta.            
            WHEN "ind-prev-demanda":U THEN ASSIGN pFieldValue = RowObject.ind-prev-demanda.            
            WHEN "nivel-apr-compra":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-compra.
            WHEN "nivel-apr-manut":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-manut.
            WHEN "nivel-apr-requis":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-requis.
            WHEN "nivel-apr-solic":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-solic.            
            WHEN "politica":U THEN ASSIGN pFieldValue = RowObject.politica.            
            WHEN "reporte-mob":U THEN ASSIGN pFieldValue = RowObject.reporte-mob.            
            WHEN "sit-aloc":U THEN ASSIGN pFieldValue = RowObject.sit-aloc.            
            WHEN "tipo-contr":U THEN ASSIGN pFieldValue = RowObject.tipo-contr.
            WHEN "tipo-est-seg":U THEN ASSIGN pFieldValue = RowObject.tipo-est-seg.            
            WHEN "tipo-lote-ec":U THEN ASSIGN pFieldValue = RowObject.tipo-lote-ec.
            WHEN "tipo-requis":U THEN ASSIGN pFieldValue = RowObject.tipo-requis.
            WHEN "tipo-sched":U THEN ASSIGN pFieldValue = RowObject.tipo-sched.            
            WHEN "cd-trib-icm":U THEN ASSIGN pFieldValue = RowObject.cd-trib-icm.
            WHEN "cd-trib-ipi":U THEN ASSIGN pFieldValue = RowObject.cd-trib-ipi.
            WHEN "cd-trib-iss":U THEN ASSIGN pFieldValue = RowObject.cd-trib-iss.            
        &endif        
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ­ndice CODIGO
  Parameters:
               retorna valor dos campos do ­ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then   
    &else
        DEFINE OUTPUT PARAMETER pfm-codigo LIKE familia.fm-codigo NO-UNDO.
    
        /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
              retornada flag "NOK":U ---*/
        IF NOT AVAILABLE RowObject THEN
           RETURN "NOK":U.
    
        ASSIGN pfm-codigo = RowObject.fm-codigo.
    
        RETURN "OK":U.
    &endif
    
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
        WHEN "contr-qualid":U THEN ASSIGN pFieldValue = RowObject.contr-qualid.
        WHEN "curva-abc":U THEN ASSIGN pFieldValue = RowObject.curva-abc.
        WHEN "ind-inf-qtf":U THEN ASSIGN pFieldValue = RowObject.ind-inf-qtf.
        WHEN "invent-cla-a":U THEN ASSIGN pFieldValue = RowObject.invent-cla-a.
        WHEN "invent-cla-b":U THEN ASSIGN pFieldValue = RowObject.invent-cla-b.
        WHEN "invent-cla-c":U THEN ASSIGN pFieldValue = RowObject.invent-cla-c.
        WHEN "loc-unica":U THEN ASSIGN pFieldValue = RowObject.loc-unica.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "fraciona":U THEN ASSIGN pFieldValue = RowObject.fraciona.        
        WHEN "atu-conf":U THEN ASSIGN pFieldValue = RowObject.atu-conf.
        WHEN "baixa-estoq":U THEN ASSIGN pFieldValue = RowObject.baixa-estoq.                    
        &if defined(bf-mat-comex) &then   
            WHEN "demanda":U THEN ASSIGN pFieldValue = RowObject.demanda.        
            WHEN "emissao-ord":U THEN ASSIGN pFieldValue = RowObject.emissao-ord.        
            WHEN "reporte-mob":U THEN ASSIGN pFieldValue = RowObject.reporte-mob.        
            WHEN "tipo-est-seg":U THEN ASSIGN pFieldValue = RowObject.tipo-est-seg.        
            WHEN "tipo-lote-ec":U THEN ASSIGN pFieldValue = RowObject.tipo-lote-ec.        
            WHEN "tipo-sched":U THEN ASSIGN pFieldValue = RowObject.tipo-sched.        
            WHEN "u-log-1":U THEN ASSIGN pFieldValue = RowObject.u-log-1.                
        &else
            WHEN "conv-tempo-seg":U THEN ASSIGN pFieldValue = RowObject.conv-tempo-seg.        
            WHEN "log-atualiz-via-mmp":U THEN ASSIGN pFieldValue = RowObject.log-atualiz-via-mmp.
            WHEN "log-utiliza-batch-padrao":U THEN ASSIGN pFieldValue = RowObject.log-utiliza-batch-padrao.
        &endif  
        
        &IF DEFINED(bf_man_sfc_ref_oper) &THEN
            WHEN "log-control-estoq-refugo":U THEN ASSIGN pFieldValue = RowObject.log-control-estoq-refugo.
            WHEN "log-refugo-preco-fisc":U THEN ASSIGN pFieldValue = RowObject.log-refugo-preco-fisc.
        &ENDIF

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
    
        /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ­ndice CODIGO
  Parameters:
               recebe valor dos campos do ­ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pfm-codigo LIKE familia.fm-codigo NO-UNDO.

    FIND FIRST bffamilia WHERE
        bffamilia.fm-codigo = pfm-codigo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bffamilia THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bffamilia)).
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
           run openQueryMain.
        when 2 then
           run openQueryByFmCodigo.
    end. /*end case*/
   RETURN "OK":U.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDescricao DBOProgram 
PROCEDURE openQueryByDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then   
    &else
        OPEN QUERY {&QueryName} FOR EACH familia WHERE 
                   familia.descricao >= cdescricao-ini 
               AND familia.descricao <= cdescricao-fim NO-LOCK 
               BY  familia.descricao INDEXED-REPOSITION.
      
        RETURN "OK":U.
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByFmCodigo DBOProgram 
PROCEDURE openQueryByFmCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

      OPEN QUERY {&QueryName} FOR EACH familia WHERE 
                 familia.fm-codigo >= cfm-codigo-ini 
             AND familia.fm-codigo <= cfm-codigo-fim NO-LOCK 
             BY  familia.fm-codigo 
             BY ROWID(familia) INDEXED-REPOSITION.
    
    RETURN "OK":U.
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

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

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

    OPEN QUERY {&QueryName} FOR EACH familia NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryWMS DBOProgram 
PROCEDURE openQueryWMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH familia NO-LOCK where 
    familia.fm-codigo    >= cfm-codigo-ini and
    familia.fm-codigo    <= cfm-codigo-fim and
    familia.tipo-con-est >= i-tp-contr-ini and
    familia.tipo-con-est <= i-tp-contr-fim INDEXED-REPOSITION.

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
   def input parameter pcfm-codigo-ini as char.
   def input parameter pcfm-codigo-fim as char.
   
   run setConstraintByFmCodigo(pcfm-codigo-ini, "ZZZZZZZZZZZZ" /*pcfm-codigo-fim*/ ).
   
 return "OK":U.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByFmCodigo DBOProgram 
PROCEDURE setConstraintByFmCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 def input parameter pcfm-codigo-ini as char.
 def input parameter pcfm-codigo-fim as char.
 
 assign cfm-codigo-ini = pcfm-codigo-ini
        cfm-codigo-fim = pcfm-codigo-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDescricao DBOProgram 
PROCEDURE setConstraintDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then   
    &else
        def input parameter pcdescricao-ini as char.
        def input parameter pcdescricao-fim as char.
        
        assign cdescricao-ini = pcdescricao-ini
               cdescricao-fim = pcdescricao-fim.
       
        RETURN "OK":U.
    &endif           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintWMS DBOProgram 
PROCEDURE setConstraintWMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pit-codigo-ini  as char no-undo.
def input param pit-codigo-fim  as char no-undo.
def input param ptp-contr-ini   as int  no-undo.
def input param ptp-contr-fim   as int  no-undo.

assign cfm-codigo-ini = pit-codigo-ini
       cfm-codigo-fim = pit-codigo-fim
       i-tp-contr-ini = ptp-contr-ini
       i-tp-contr-fim = ptp-contr-fim.

return "OK":U.

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
    &if defined(bf-mat-comex) &then   
    &else
        DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
   
        /*--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
              executadas ---*/
        /*--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
        /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do
              include: method/svc/errors/inserr.i ---*/
        /*--- Inclua aqui as valida‡äes ---*/

        /*** As valida‡äes da familia e familia-mat estao sendo 
             feitas na boin122va.p ***/

        /*--- Verifica ocorrˆncia de erros ---*/
        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
            RETURN "NOK":U.
    
        RETURN "OK":U.
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

PROCEDURE sendMessageMultiPlanta:
    
    DEF INPUT PARAM i-tipo-movto AS INTEGER NO-UNDO.
    DEF INPUT PARAM c-transacao  AS CHAR    NO-UNDO.

    {cdp/cd7300.i5 "001" c-transacao}

    if  param-global.modulo-mp
    AND (AVAIL tt-replica-msg
         AND   tt-replica-msg.log-replica-msg  = yes) then do: 
        for each tt-familia:
            delete tt-familia.
        end. 
        if avail familia then do:
            create tt-familia.
            buffer-copy familia to tt-familia.
            create tt-dados-env.
            assign tt-dados-env.num-sequencia  = i-seq
                   tt-dados-env.cod-tipo-reg   = 30
                   tt-dados-env.ind-tipo-movto = i-tipo-movto
                   tt-dados-env.identif-msg    = familia.fm-codigo.
         
            raw-transfer tt-familia to tt-dados-env.conteudo-msg.
        
            assign i-seq = i-seq + 1.
        end.

        &if defined(bf_mat_tipo_ressup) &then
        for each tt-familia-mat:
            delete tt-familia-mat.
        end.    
        find familia-mat 
            WHERE familia-mat.fm-codigo = familia.fm-codigo no-lock no-error.

        if avail familia-mat then do:
            create tt-familia-mat.
            buffer-copy familia-mat to tt-familia-mat.
            create tt-dados-env.
            assign tt-dados-env.num-sequencia  = i-seq
                   tt-dados-env.cod-tipo-reg   = 269
                   tt-dados-env.ind-tipo-movto = i-tipo-movto
                   tt-dados-env.identif-msg    = familia-mat.fm-codigo.
            raw-transfer tt-familia-mat to tt-dados-env.conteudo-msg.
            assign i-seq = i-seq + 1.                                     
        end.
        &endif
    end.
    {cdp/cd7300.i7 "001" c-transacao}
    return "OK".
END PROCEDURE.
