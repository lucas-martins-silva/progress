&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ABAPI008 2.00.00.021 } /*** 010021 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i abapi008 MAB}
&ENDIF


/*****************************************************************************
**
**       PROGRAMA: ABAPI008.p
**
**       DATA....: Janeiro de 2004
**
**       AUTOR...: Marcio Willwock - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Valida‡äes Cadastros MI em Frotas
**
*****************************************************************************/

/* ***************************  Definitions  ************************** */
/***************** Temp-Tables ******************/
{abp/ab9004.i}  /** RowErrors **/

/***************** Parƒmetros *******************/
define input parameter pRowid as rowid no-undo.

/***************** Vari veis *******************/
define variable cTexto as character no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 18.46
         WIDTH              = 41.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
{abp/abapi001.i2} /** Cria‡Æo de Erros **/

if this-procedure:persistent then
    return "OK":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-AlteraItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AlteraItem Procedure 
PROCEDURE AlteraItem :
/*------------------------------------------------------------------------------
  Purpose:     Altera‡Æo do c¢digo do item em Frotas
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-cod-item-anterior like item.it-codigo no-undo.
def input param p-cod-item-atual    like item.it-codigo no-undo.

/** Desabilita triggers de write das tabelas **/
on write of mab-tip-mater-item  override do: end.
on write of mab-item-abastec    override do: end.
on write of mab-item-lubrific   override do: end.
on write of mpn-histor-vida     override do: end.
on write of mpn-km-esperad      override do: end.
on write of mpn-movto-pneu      override do: end.
on write of mmv-param           override do: end.
on write of mmv-tar-plano-item  override do: end.
on write of mmv-movto-mater     override do: end.
on write of mgf-cust-item-estoq override do: end.
on write of mco-compon          override do: end.

/** Tipo de Material **/
for each mab-tip-mater-item where
    mab-tip-mater-item.it-codigo = p-cod-item-anterior
    exclusive-lock:
    assign mab-tip-mater-item.it-codigo = p-cod-item-atual.
end.
/** Item do Abastecimento **/
for each mab-item-abastec where
    mab-item-abastec.it-codigo = p-cod-item-anterior
    exclusive-lock:
    assign mab-item-abastec.it-codigo = p-cod-item-atual.
end.
/** Item da Lubrifica‡Æo **/
for each mab-item-lubrific where
    mab-item-lubrific.it-codigo = p-cod-item-anterior
    exclusive-lock:
    assign mab-item-lubrific.it-codigo = p-cod-item-atual.
end.
/** Hist¢rico de Vida Pneu **/
for each mpn-histor-vida where
    mpn-histor-vida.it-codigo = p-cod-item-anterior
    exclusive-lock:
    assign mpn-histor-vida.it-codigo = p-cod-item-atual.
end.
/** Quilometragem Esperada **/
for each mpn-km-esperad where
    mpn-km-esperad.it-codigo = p-cod-item-anterior
    exclusive-lock:
    assign mpn-km-esperad.it-codigo = p-cod-item-atual.
end.
/** Movimento de Pneus **/
for each mpn-movto-pneu where
    mpn-movto-pneu.it-codigo = p-cod-item-anterior
    exclusive-lock:
    assign mpn-movto-pneu.it-codigo = p-cod-item-atual.
end.
/** Parƒmetros Manuten‡Æo Mecƒnica **/
for each mmv-param where
    mmv-param.it-codigo = p-cod-item-anterior
    exclusive-lock:
    assign mmv-param.it-codigo = p-cod-item-atual.
end.
/** Item da Tarefa do Plano de Preven‡Æo **/
for each mmv-tar-plano-item where
    mmv-tar-plano-item.it-codigo = p-cod-item-anterior
    exclusive-lock:
    assign mmv-tar-plano-item.it-codigo = p-cod-item-atual.
end.
/** Movimento de Materiais **/
for each mmv-movto-mater where
    mmv-movto-mater.it-codigo = p-cod-item-anterior
    exclusive-lock:
    assign mmv-movto-mater.it-codigo = p-cod-item-atual.
end.
/** Custos do Item **/
for each mgf-cust-item-estoq where
    mgf-cust-item-estoq.it-codigo = p-cod-item-anterior
    exclusive-lock:
    assign mgf-cust-item-estoq.it-codigo = p-cod-item-atual.
end.
/** Componente **/
for each mco-compon where
    mco-compon.it-codigo = p-cod-item-anterior
    exclusive-lock:
    assign mco-compon.it-codigo = p-cod-item-atual.
end.

/** Amostra àleo **/
for each mao-amostra-oleo where
    mao-amostra-oleo.it-codigo = p-cod-item-anterior
    exclusive-lock:
    assign mao-amostra-oleo.it-codigo = p-cod-item-atual.
end.
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowErrors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowErrors Procedure 
PROCEDURE getRowErrors :
/*------------------------------------------------------------------------------
  Purpose:     getRowErrors
  Parameters:  sa¡da RowErrors = Erros de Valida‡Æo
  Notes:       Retorna os erros de valida‡äes das elimina‡äes dos cadastros de
               MI em Frotas
------------------------------------------------------------------------------*/
define output parameter table for RowErrors.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateCalendario) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCalendario Procedure 
PROCEDURE validateCalendario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input param p-cd-calen like calen-gener.cd-calen no-undo.

{utp/ut-liter.i "Calend rio Gen‚rico"}
assign cTexto = trim(return-value).

/** Relacionamento com Oficina Mecƒnica **/
FOR first mmv-ofici
    WHERE mmv-ofici.cod-calend = p-cd-calen NO-LOCK:
END.
IF AVAIL mmv-ofici THEN DO:
    {utp/ut-liter.i "Oficina Mecƒnica (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                      trim(return-value)).
end.
/** Relacionamento com Plano Preven‡Æo **/
if can-find (first mmv-plano-prevent where
             mmv-plano-prevent.cod-calend = p-cd-calen) then do:
    {utp/ut-liter.i "Plano Preven‡Æo (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                      trim(return-value)).
end.

/*:T--- Verifica ocorrˆncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateCausaPadrao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCausaPadrao Procedure 
PROCEDURE validateCausaPadrao :
/*------------------------------------------------------------------------------
  Purpose:     validateCausaPadrao
  Parameters:  <none>
  Notes:       Valida‡äes cadastrais Frotas referentes a tabela "causa-padrao"
------------------------------------------------------------------------------*/
{utp/ut-liter.i "Causa PadrÆo"}
assign cTexto = trim(return-value).

/** Busca o Registro de Causa PadrÆo **/
for first causa-padrao fields(cd-causa-padr)
    where rowid(causa-padrao) = pRowid no-lock:
    /** Relacionamento com Pneu **/
    FOR first mpn-pneu
        where mpn-pneu.cd-causa-padr = causa-padrao.cd-causa-padr no-lock:
    END.
    IF AVAIL mpn-pneu THEN DO:
        {utp/ut-liter.i "Pneu"}
        run piCriaErro in this-procedure (input 6,
                                          input "EMS":U,
                                          input cTexto + '~~' +
                                                trim(return-value)).
    end.
    /** Relacionamento com Movimento de Pneus **/
    FOR first mpn-movto-pneu
        where mpn-movto-pneu.cd-causa-padr = causa-padrao.cd-causa-padr NO-LOCK:
    END.
    IF AVAIL mpn-movto-pneu THEN DO:
        {utp/ut-liter.i "Movimento de Pneus"}
        run piCriaErro in this-procedure (input 6,
                                          input "EMS":U,
                                          input cTexto + '~~' +
                                                trim(return-value)).
    end.
    /** Relacionamento com Servicos no Pneu **/
    if can-find(first mpn-serv
                where mpn-serv.cd-causa-padr = causa-padrao.cd-causa-padr no-lock) then do:
        {utp/ut-liter.i "Servicos no Pneu"}
        run piCriaErro in this-procedure (input 6,
                                          input "EMS":U,
                                          input cTexto + '~~' +
                                                trim(return-value)).
    end.
end.

/*:T--- Verifica ocorrˆncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateCentroCusto) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCentroCusto Procedure 
PROCEDURE validateCentroCusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-cc-codigo like centro-custo.cc-codigo no-undo.

{utp/ut-liter.i "Centro de Custo"}
assign cTexto = trim(return-value).

/** Relacionamento com Setor da Oficina **/
if can-find (first mmv-setor-ofici where
             mmv-setor-ofici.cc-codigo <> "" and
             mmv-setor-ofici.cc-codigo =  p-cc-codigo no-lock) then do:
    {utp/ut-liter.i "Setor da Oficina (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                      trim(return-value)).
end.
/** Relacionamento com Funcion rio Oficina **/
FOR first mmv-func-ofici
    WHERE mmv-func-ofici.cc-codigo <> ""
    and   mmv-func-ofici.cc-codigo =  p-cc-codigo NO-LOCK:
END.
IF  AVAIL mmv-func-ofici THEN DO:
    {utp/ut-liter.i "Funcion rio Oficina (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                      trim(return-value)).
end.
/** Relacionamento com Reporte Horas Funcion rio **/
FOR first mmv-movto-mdo
    WHERE mmv-func-ofici.cc-codigo <> ""
    AND   mmv-movto-mdo.cc-codigo  = p-cc-codigo no-lock:
END.
IF  AVAIL mmv-movto-mdo THEN DO:
    {utp/ut-liter.i "Reporte Horas Funcion rio (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                      trim(return-value)).
end.

/*:T--- Verifica ocorrˆncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateCidade) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCidade Procedure 
PROCEDURE validateCidade :
/*------------------------------------------------------------------------------
  Purpose:     validateUNIDADE
  Parameters:  <none>
  Notes:       Valida‡äes cadastrais Frotas referentes a tabela "cidade"
------------------------------------------------------------------------------*/
def input parameter pcidade like cidade.cidade no-undo.
def input parameter pestado like cidade.estado no-undo.
def input parameter ppais   like cidade.pais no-undo.
  

{utp/ut-liter.i "Cidade"}
assign cTexto = trim(return-value).

/** Relacionamento com Equipamento da Frota**/
FOR first mab-eqpto
    where mab-eqpto.cod-cidade   = pcidade 
    and   mab-eqpto.cod-estado   = pestado 
    and   mab-eqpto.cod-pais     = ppais   NO-LOCK:
END.
IF  AVAIL mab-eqpto THEN DO:
    {utp/ut-liter.i "Equipamento (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.



/** Relacionamento com Hist¢rico da Atividade **/
FOR first mab-histor-ativid
    where mab-histor-ativid.cod-cidade   = pcidade 
    and   mab-histor-ativid.cod-estado   = pestado 
    and   mab-histor-ativid.cod-pais     = ppais   NO-LOCK:
END.
IF  AVAIL mab-histor-ativid THEN DO:
    {utp/ut-liter.i "Hist¢rico da Atividade (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.




/** Relacionamento com Movimento da Infra‡Æo**/
if can-find(first mnd-movto-infracao
            where mnd-movto-infracao.cod-cidade   = pcidade 
            and   mnd-movto-infracao.cod-estado   = pestado 
            and   mnd-movto-infracao.cod-pais     = ppais   no-lock) then do:
    {utp/ut-liter.i "Movimento da Infra‡Æo (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Parƒmetros Frotas **/
if can-find(first mnd-param 
            where mnd-param.cdn-param = 3 
            and entry(1,mnd-param.des-valor,",") = pcidade 
            and entry(2,mnd-param.des-valor,",") = pestado 
            and entry(3,mnd-param.des-valor,",") = ppais  no-lock) then do:
    {utp/ut-liter.i "Parƒmetros Documentos Frotas"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.


/*:T--- Verifica ocorr¼ncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateConta) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateConta Procedure 
PROCEDURE validateConta :
/*------------------------------------------------------------------------------
  Purpose:     validateUNIDADE
  Parameters:  <none>
  Notes:       Valida‡äes cadastrais Frotas referentes a tabela "conta"
------------------------------------------------------------------------------*/
def input parameter pconta as character no-undo.

{utp/ut-liter.i "Conta"}
assign cTexto = trim(return-value).


/** Relacionamento com  Evento **/
if can-find(first mab-event
            where mab-event.ct-despesa = pconta no-lock) then do:
    {utp/ut-liter.i "Eventos (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.




/*:T--- Verifica ocorr¼ncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateContaContabil) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateContaContabil Procedure 
PROCEDURE validateContaContabil :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter pEmpresa     as character  no-undo.
define input parameter pConta       as character  no-undo.
define input parameter pCentroCusto as character  no-undo.

/* Devido ao projeto 105 esta valida‡Æo nÆo pode mais ser realizada usando o rowId portanto foi realizada 
 * a altera‡Æo para receber a empresa a conta e centro de custo e nÆo mais o rowid. 
 */

/************************************ INICIO DA VALIDACA°€O DAS CONTAS DE LUBRIFICA°€O ************************************/

{utp/ut-liter.i "Conta_Lubrifica‡Æo"}
ASSIGN cTexto = TRIM(RETURN-VALUE).

/** Relacionamento com Hist¢rico Atividade Equipamento **/
FOR FIRST mab-histor-ativid
    WHERE mab-histor-ativid.ep-codigo             = pEmpresa
    AND   mab-histor-ativid.cod-cta-ctbl-lubrific = pConta
    AND   mab-histor-ativid.cod-ccusto-lubrific   = pCentroCusto NO-LOCK:
    {utp/ut-liter.i "Hist¢rico_Atividade_Equipamento_(Frota)"}
    RUN piCriaErro IN THIS-PROCEDURE (INPUT 6,
                                      INPUT "EMS":U,
                                      INPUT cTexto + '~~' +
                                      TRIM(RETURN-VALUE)).
END.
/** Relacionamento com Ficha Abastecimento / Lubrifica‡Æo **/
FOR FIRST mab-abastec-lubrific
    WHERE mab-abastec-lubrific.ep-codigo           = pEmpresa
    AND mab-abastec-lubrific.cod-cta-ctbl-lubrific = pConta
    AND mab-abastec-lubrific.cod-ccusto-lubrific   = pCentroCusto NO-LOCK:
    {utp/ut-liter.i "Ficha_Abastecimento_/_Lubrifica‡Æo_(Frota)"}
    RUN piCriaErro IN THIS-PROCEDURE (INPUT 6,
                                      INPUT "EMS":U,
                                      INPUT cTexto + '~~' +
                                      TRIM(RETURN-VALUE)).
END.
/** Relacionamento com Item Abastecimento **/
FOR FIRST mab-item-abastec
    WHERE mab-item-abastec.ep-codigo    = pEmpresa
    AND   mab-item-abastec.cod-cta-ctbl = pConta
    AND   mab-item-abastec.cod-ccusto   = pCentroCusto NO-LOCK:
    {utp/ut-liter.i "Item_Abastecimento_(Frota)"}
    RUN piCriaErro IN THIS-PROCEDURE (INPUT 6,
                                      INPUT "EMS":U,
                                      INPUT cTexto + '~~' +
                                      TRIM(RETURN-VALUE)).
END.
/** Relacionamento com Item Lubrifica‡Æo **/
FOR FIRST mab-item-lubrific
    WHERE mab-item-lubrific.ep-codigo    = pEmpresa
    AND   mab-item-lubrific.cod-cta-ctbl = pConta
    AND   mab-item-lubrific.cod-ccusto   = pCentroCusto NO-LOCK:
    {utp/ut-liter.i "Item_Lubrifica‡Æo_(Frota)"}
    RUN piCriaErro IN THIS-PROCEDURE (INPUT 6,
                                      INPUT "EMS":U,
                                      INPUT cTexto + '~~' +
                                      TRIM(RETURN-VALUE)).
END.

/************************************ FINAL DA VALIDACA°€O DAS CONTAS DE LUBRIFICA°€O ************************************/

{utp/ut-liter.i "Conta"}
assign cTexto = trim(return-value).

/** Relacionamento com Hist¢rico Atividade Equipamento **/
FOR first mab-histor-ativid
    WHERE mab-histor-ativid.ep-codigo = pEmpresa
    AND   mab-histor-ativid.ct-codigo = pConta
    AND   mab-histor-ativid.cc-codigo = pCentroCusto NO-LOCK:
END.
IF  AVAIL mab-histor-ativid THEN DO:
    {utp/ut-liter.i "Hist¢rico Atividade Equipamento (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                      trim(return-value)).
end.


/** Relacionamento com Ficha Abastecimento / Lubrifica‡Æo **/
FOR first mab-abastec-lubrific
    WHERE mab-abastec-lubrific.ep-codigo = pEmpresa
    AND mab-abastec-lubrific.ct-codigo = pConta
    AND mab-abastec-lubrific.cc-codigo = pCentroCusto no-lock:
END.
IF  AVAIL mab-abastec-lubrific THEN DO:
    {utp/ut-liter.i "Ficha Abastecimento / Lubrifica‡Æo (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                      trim(return-value)).
end.


find first param-global no-lock no-error.
if avail param-global then
    if pEmpresa = param-global.empresa-prin then do:
        /** Relacionamento com Movimento de Pneus **/
        FOR first mpn-movto-pneu
            WHERE mpn-movto-pneu.ct-codigo = pConta
            AND   mpn-movto-pneu.cc-codigo = pCentroCusto NO-LOCK:
        END.
        IF AVAIL mpn-movto-pneu THEN DO:
            {utp/ut-liter.i "Movimento de Pneus (Frota)"}
            run piCriaErro in this-procedure (input 6,
                                              input "EMS":U,
                                              input cTexto + '~~' +
                                              trim(return-value)).
        end.
        /** Relacionamento com Parƒmetros do Pneu **/
        if can-find (first mpn-param where
                     mpn-param.ct-codigo = pConta and
                     mpn-param.cc-codigo = pCentroCusto) then do:
            {utp/ut-liter.i "Parƒmetros do Pneu (Frota)"}
            run piCriaErro in this-procedure (input 6,
                                              input "EMS":U,
                                              input cTexto + '~~' +
                                              trim(return-value)).
        end.
        /** Relacionamento com Componente **/
        if can-find (first mco-compon where
                     mco-compon.ct-codigo = pConta and
                     mco-compon.cc-codigo = pCentroCusto) then do:
            {utp/ut-liter.i "Componente (Frota)"}
            run piCriaErro in this-procedure (input 6,
                                              input "EMS":U,
                                              input cTexto + '~~' +
                                              trim(return-value)).
        end.
    end.
        
/** Relacionamento com Ordem Manuten‡Æo Mecƒnica **/
FOR first mmv-ord-manut
    WHERE mmv-ord-manut.ep-codigo-despes = pEmpresa
    AND   mmv-ord-manut.ct-codigo        = pConta
    AND   mmv-ord-manut.cc-codigo        = pCentroCusto NO-LOCK:
END.
IF  AVAIL mmv-ord-manut THEN DO:
    {utp/ut-liter.i "Ordem Manuten‡Æo Mecƒnica (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                      trim(return-value)).
end.
/** Relacionamento com Ordem Manuten‡Æo Mecƒnica **/
FOR first mmv-ord-manut
    WHERE mmv-ord-manut.ep-codigo-ordem = pEmpresa
    AND   mmv-ord-manut.ct-ordem        = pConta
    AND   mmv-ord-manut.cc-ordem        = pCentroCusto no-lock:
END.
IF  AVAIL mmv-ord-manut THEN DO:
    {utp/ut-liter.i "Ordem Manuten‡Æo Mecƒnica (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                      trim(return-value)).
end.

/** Relacionamento com Movimento de Evento **/
FOR first mab-movto-event
    where  mab-movto-event.ep-codigo = pEmpresa
    and   mab-movto-event.ct-despesa = pConta 
    AND   mab-movto-event.cc-despesa = pCentroCusto NO-LOCK:
END.
IF  AVAIL mab-movto-event THEN DO:
    {utp/ut-liter.i "Movimento de Eventos(Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.

/*:T--- Verifica ocorrˆncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateDeposito) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDeposito Procedure 
PROCEDURE validateDeposito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-cod-depos like deposito.cod-depos no-undo.

{utp/ut-liter.i "Dep¢sito"}
assign cTexto = trim(return-value).

/** Relacionamento com Posto Combust¡vel **/
FOR first mab-posto
    WHERE mab-posto.cod-depos = p-cod-depos NO-LOCK:
END.
IF  AVAIL mab-posto THEN DO:
    {utp/ut-liter.i "Posto Combust¡vel (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                      trim(return-value)).
end.
/** Relacionamento com Hist¢rico da Vida do Pneu **/
if can-find (first mpn-histor-vida where
             mpn-histor-vida.cod-depos = p-cod-depos) then do:
    {utp/ut-liter.i "Hist¢rico da Vida do Pneu (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                      trim(return-value)).
end.
/** Relacionamento com Movimento Pneus **/
FOR first mpn-movto-pneu
    WHERE mpn-movto-pneu.cod-depos = p-cod-depos NO-LOCK:
END.
IF  AVAIL mpn-movto-pneu THEN DO:
    {utp/ut-liter.i "Movimento Pneus (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                      trim(return-value)).
end.

/*:T--- Verifica ocorrˆncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateEmitente) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateEmitente Procedure 
PROCEDURE validateEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input param p-cod-emitente like emitente.cod-emitente no-undo.

{utp/ut-liter.i "Emitente"}
assign cTexto = trim(return-value).

/** Relacionamento com Posto Combust¡vel **/
FOR first mab-posto
    WHERE mab-posto.cod-emitente = p-cod-emitente NO-LOCK:
END.
IF  AVAIL mab-posto THEN DO:
    {utp/ut-liter.i "Posto Combust¡vel (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Equipamento Frota **/
FOR first mab-eqpto
    WHERE mab-eqpto.cod-emitente = p-cod-emitente no-lock:
END.
IF  AVAIL mab-eqpto THEN DO:
    {utp/ut-liter.i "Equipamento Frota"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Hist¢rico Vida Pneu **/
if can-find (first mpn-histor-vida where
             mpn-histor-vida.cod-emitente = p-cod-emitente no-lock) then do:
    {utp/ut-liter.i "Hist¢rico Vida Pneu (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Movimento de Pneus **/
FOR first mpn-movto-pneu
    WHERE mpn-movto-pneu.cod-emitente = p-cod-emitente no-lock:
END.
IF  AVAIL mpn-movto-pneu THEN DO:
    {utp/ut-liter.i "Movimento de Pneus (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Oficina Mecƒnica **/
FOR first mmv-ofici
    WHERE mmv-ofici.cod-emitente = p-cod-emitente no-lock:
END.
IF  AVAIL mmv-ofici THEN DO:
    {utp/ut-liter.i "Oficina Mecƒnica (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Movimento de Materiais **/
if can-find (first mmv-movto-mater where
             mmv-movto-mater.cod-emitente = p-cod-emitente no-lock) then do:
    {utp/ut-liter.i "Movimento de Materiais"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Hist¢rico Vida Componente **/
if can-find (first mco-histor-vida where
             mco-histor-vida.cod-emitente = p-cod-emitente no-lock) then do:
    {utp/ut-liter.i "Hist¢rico Vida Componente"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.


/** Relacionamento com Solicita‡Æo de Pagamento**/
if can-find(first mnd-solicit-pagto
            where mnd-solicit-pagto.cod-emitente = p-cod-emitente no-lock) then do:
    {utp/ut-liter.i "Solicita‡Æo de Pagamento (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.

/** Relacionamento com Movimenta‡Æo do Processo**/
if can-find(first mnd-movto-proces
            where mnd-movto-proces.cod-emitente = p-cod-emitente no-lock) then do:
    {utp/ut-liter.i "Movimenta‡Æo do Processo (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.

/*:T--- Verifica ocorrˆncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateEmpresa) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateEmpresa Procedure 
PROCEDURE validateEmpresa :
/*------------------------------------------------------------------------------
  Purpose:     validateEMPRESA
  Parameters:  <none>
  Notes:       Valida‡äes cadastrais Frotas referentes a tabela "empresa"
------------------------------------------------------------------------------*/
def input param p-ep-codigo like empresa.ep-codigo no-undo.

{utp/ut-liter.i "Empresa"}
assign cTexto = trim(return-value).

/** Relacionamento com Parƒmetros Frotas **/
&IF "{&mguni_version}" >= "2.071" &THEN
if can-find(first mab-param where
            mab-param.cdn-param = 30 and
            mab-param.des-valor = p-ep-codigo no-lock) then do:
&ELSE
if can-find(first mab-param where
            mab-param.cdn-param = 30 and
            int(mab-param.des-valor) = p-ep-codigo no-lock) then do:
&ENDIF

    {utp/ut-liter.i "Parƒmetros Frotas"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Equipamento **/
FOR first mab-eqpto
    WHERE mab-eqpto.ep-codigo = p-ep-codigo NO-LOCK:
END.
IF AVAIL mab-eqpto THEN DO:
    {utp/ut-liter.i "Equipamento (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.

/** Relacionamento com Posto Combust¡vel **/
FOR first mab-posto
    WHERE mab-posto.ep-codigo = p-ep-codigo no-lock:
END.
IF  AVAIL mab-posto THEN DO:
    {utp/ut-liter.i "Posto Combust¡vel (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Pneu **/
FOR first mpn-pneu
    WHERE mpn-pneu.ep-codigo-pneu = p-ep-codigo no-lock:
END.
IF  AVAIL mpn-pneu THEN DO:
    {utp/ut-liter.i "Pneu (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Parƒmetros de Manuten‡Æo Mecƒnica **/
if can-find(first mmv-param where
            mmv-param.ep-codigo = p-ep-codigo no-lock) then do:
    {utp/ut-liter.i "Parƒmetros de Manuten‡Æo Mecƒnica (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Funcion rio da Empresa **/
FOR first mmv-func-ofici
    WHERE mmv-func-ofici.ep-codigo = p-ep-codigo NO-LOCK:
END.
IF  AVAIL mmv-func-ofici THEN DO:
    {utp/ut-liter.i "Funcion rio da Empresa (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Parƒmetros Eventos **/
if can-find(first mgf-event-param where
            mgf-event-param.ep-codigo = p-ep-codigo no-lock) then do:
    {utp/ut-liter.i "Parƒmetros Eventos (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.

/*:T--- Verifica ocorrˆncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateEPI) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateEPI Procedure 
PROCEDURE validateEPI :
/*------------------------------------------------------------------------------
  Purpose:     validateEPI
  Parameters:  <none>
  Notes:       Valida‡äes cadastrais Frotas referentes a tabela "epi"
------------------------------------------------------------------------------*/
{utp/ut-liter.i "EPI"}
assign cTexto = trim(return-value).

/** Busca o Registro de EPI **/
for first epi fields(cd-epi)
    where rowid(epi) = pRowid no-lock:
    /** Relacionamento com Equipamentos Prote‡Æo da Tarefa do Plano Manuten‡Æo Mecƒnica **/
    if can-find(first mmv-tar-plano-epi
                where mmv-tar-plano-epi.cd-epi = epi.cd-epi no-lock) then do:
        {utp/ut-liter.i "Equipamentos Prote‡Æo da Tarefa do Plano Manuten‡Æo Mecƒnica"}
        run piCriaErro in this-procedure (input 6,
                                          input "EMS":U,
                                          input cTexto + '~~' +
                                                trim(return-value)).
    end.
end.

/*:T--- Verifica ocorrˆncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateEstabelecimento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateEstabelecimento Procedure 
PROCEDURE validateEstabelecimento :
/*------------------------------------------------------------------------------
  Purpose:     validateESTABELECIMENTO
  Parameters:  <none>
  Notes:       Valida‡äes cadastrais Frotas referentes a tabela "estabelec"
------------------------------------------------------------------------------*/
def input param p-cod-estabel like estabelec.cod-estabel no-undo.

{utp/ut-liter.i "Estabelecimento"}
assign cTexto = trim(return-value).

/** Relacionamento com Hist¢rico de Atividade do Equipamento **/
FOR first mab-histor-ativid
    WHERE mab-histor-ativid.cod-estabel = p-cod-estabel no-lock:
END.
IF AVAIL mab-histor-ativid THEN DO:
    {utp/ut-liter.i "Hist¢rico de Atividade do Equipamento (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Posto Combust¡vel **/
FOR first mab-posto
    WHERE mab-posto.cod-estabel = p-cod-estabel no-lock:
END.
IF  AVAIL mab-posto THEN DO:
    {utp/ut-liter.i "Posto Combust¡vel (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Pneu **/
FOR first mpn-pneu
    WHERE mpn-pneu.cod-estabel-inicial = p-cod-estabel
    OR    mpn-pneu.cod-estabel-atual   = p-cod-estabel no-lock:
END.
IF AVAIL mpn-pneu THEN DO:
    {utp/ut-liter.i "Pneu (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Movimento de Pneus **/
FOR first mpn-movto-pneu
    WHERE mpn-movto-pneu.cod-estabel-orig = p-cod-estabel no-lock:
END.
IF  AVAIL mpn-movto-pneu THEN DO:
    {utp/ut-liter.i "Movimento de Pneus (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Movimento de Pneus **/
FOR first mpn-movto-pneu
    WHERE mpn-movto-pneu.cod-estabel-dest = p-cod-estabel no-lock:
END.
IF  AVAIL mpn-movto-pneu THEN DO:
    {utp/ut-liter.i "Movimento de Pneus (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Oficina Mecƒnica **/
FOR first mmv-ofici
    WHERE mmv-ofici.cod-estabel = p-cod-estabel no-lock:
END.
IF  AVAIL mmv-ofici THEN DO:
    {utp/ut-liter.i "Oficina Mecƒnica (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Ordem Manuten‡Æo **/
FOR first mmv-ord-manut 
    where mmv-ord-manut.cod-estabel = p-cod-estabel no-lock:
END.
IF  AVAIL mmv-ord-manut THEN DO:
    {utp/ut-liter.i "Ordem Manuten‡Æo (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Custo do Evento **/
if can-find(first mgf-cust-event where
            mgf-cust-event.cod-estabel = p-cod-estabel no-lock) then do:
    {utp/ut-liter.i "Custo do Evento (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Custo do Item **/
if can-find(first mgf-cust-item-estoq where
            mgf-cust-item-estoq.cod-estabel = p-cod-estabel no-lock) then do:
    {utp/ut-liter.i "Custo do Item (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Componente **/
if can-find(first mco-compon where
            mco-compon.cod-estabel-inicial = p-cod-estabel or
            mco-compon.cod-estabel-atual   = p-cod-estabel no-lock) then do:
    {utp/ut-liter.i "Componente (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Movimento do Componente **/
if can-find(first mco-movto-compon where
            mco-movto-compon.cod-estabel = p-cod-estabel no-lock) then do:
    {utp/ut-liter.i "Movimento do Componente (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.



/** Relacionamento com Movimento da Infra‡Æo**/
if can-find(first mnd-movto-infracao
            where mnd-movto-infracao.cod-estabel = p-cod-estabel no-lock) then do:
    {utp/ut-liter.i "Movimento da Infra‡Æo (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.

/** Relacionamento com Solicita‡Æo de Pagamento**/
if can-find(first mnd-solicit-pagto
            where mnd-solicit-pagto.cod-estabel = p-cod-estabel no-lock) then do:
    {utp/ut-liter.i "Solicita‡Æo de Pagamento (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.



/*:T--- Verifica ocorrˆncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateFichaMetodo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFichaMetodo Procedure 
PROCEDURE validateFichaMetodo :
/*------------------------------------------------------------------------------
  Purpose:     validateFichaMetodo
  Parameters:  <none>
  Notes:       Valida‡äes cadastrais Frotas referentes a tabela "mnt-ficha-metodo"
------------------------------------------------------------------------------*/
{utp/ut-liter.i "Ficha de M‚todo"}
assign cTexto = trim(return-value).

/** Busca o Registro de Ficha de M‚todo **/
for first mnt-ficha-metodo fields(fi-codigo)
    where rowid(mnt-ficha-metodo) = pRowid no-lock:
    /** Relacionamento com Ficha de M‚todo da Tarefa do Plano Manuten‡Æo Mecƒnica **/
    if can-find(first mmv-tar-plano-ficha
                where mmv-tar-plano-ficha.fi-codigo = mnt-ficha-metodo.fi-codigo no-lock) then do:
        {utp/ut-liter.i "Ficha de M‚todo da Tarefa do Plano Manuten‡Æo Mecƒnica"}
        run piCriaErro in this-procedure (input 6,
                                          input "EMS":U,
                                          input cTexto + '~~' +
                                                trim(return-value)).
    end.
end.

/*:T--- Verifica ocorrˆncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateGrupoEstoque) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateGrupoEstoque Procedure 
PROCEDURE validateGrupoEstoque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-ge-codigo like grup-estoque.ge-codigo no-undo.

{utp/ut-liter.i "Grupo Estoque"}
assign cTexto = trim(return-value).

/** Relacionamento com Movimento de Materiais **/
if can-find (first mmv-movto-mater where
             mmv-movto-mater.ge-codigo = p-ge-codigo) then do:
    {utp/ut-liter.i "Movimento de Materiais (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                      trim(return-value)).
end.
/** Relacionamento com Grupo Estoque Pneus **/
if can-find (first mgf-grp-estoq where
             mgf-grp-estoq.ge-codigo = p-ge-codigo) then do:
    {utp/ut-liter.i "Grupo Estoque Pneus (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                      trim(return-value)).
end.

/*:T--- Verifica ocorrˆncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateItem Procedure 
PROCEDURE validateItem :
/*------------------------------------------------------------------------------
  Purpose:     validateITEM
  Parameters:  <none>
  Notes:       Valida‡äes cadastrais Frotas referentes a tabela "item"
------------------------------------------------------------------------------*/
def input param p-it-codigo like item.it-codigo no-undo.

{utp/ut-liter.i "Item"}
assign cTexto = trim(return-value).

/** Relacionamento com Tipo de Material **/
if can-find(first mab-tip-mater-item where
            mab-tip-mater-item.it-codigo = p-it-codigo no-lock) then do:
    {utp/ut-liter.i "Tipo de Material (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Item do Abastecimento **/
FOR first mab-item-abastec
    WHERE mab-item-abastec.it-codigo = p-it-codigo no-lock:
END.
IF  AVAIL mab-item-abastec THEN DO:
    {utp/ut-liter.i "Item do Abastecimento (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Item da Lubrifica‡Æo **/
FOR first mab-item-lubrific
    WHERE mab-item-lubrific.it-codigo = p-it-codigo NO-LOCK:
END.
IF  AVAIL mab-item-lubrific THEN DO:
    {utp/ut-liter.i "Item da Lubrifica‡Æo (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Hist¢rico de Vida Pneu **/
FOR first mpn-histor-vida
    WHERE mpn-histor-vida.it-codigo = p-it-codigo NO-LOCK:
END.
IF  AVAIL mpn-histor-vida THEN DO:
    {utp/ut-liter.i "Hist¢rico de Vida Pneu (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Quilometragem Esperada **/
if can-find(first mpn-km-esperad where
            mpn-km-esperad.it-codigo = p-it-codigo no-lock) then do:
    {utp/ut-liter.i "Quilometragem Esperada (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Parƒmetros Manuten‡Æo Mecƒnica **/
if can-find(first mmv-param where
            mmv-param.it-codigo = p-it-codigo no-lock) then do:
    {utp/ut-liter.i "Parƒmetros Manuten‡Æo Mecƒnica (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Item da Tarefa do Plano Preven‡Æo **/
if can-find(first mmv-tar-plano-item where
            mmv-tar-plano-item.it-codigo = p-it-codigo no-lock) then do:
    {utp/ut-liter.i "Item da Tarefa do Plano Preven‡Æo (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Custos do Item **/
if can-find(first mgf-cust-item-estoq where
            mgf-cust-item-estoq.it-codigo = p-it-codigo no-lock) then do:
    {utp/ut-liter.i "Custos do Item (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Componente **/
if can-find(first mco-compon where
            mco-compon.it-codigo = p-it-codigo no-lock) then do:
    {utp/ut-liter.i "Componente (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.


/** Amostra àleo **/
if can-find(first mao-amostra-oleo where
            mao-amostra-oleo.it-codigo = p-it-codigo no-lock) then do:
    {utp/ut-liter.i "Amostra àleo (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/*:T--- Verifica ocorrˆncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateMaoObra) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateMaoObra Procedure 
PROCEDURE validateMaoObra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter p-cd-mob-dir like tab-mob-dir.cd-mob-dir no-undo.

{utp/ut-liter.i "MÆo de Obra Direta"}
assign cTexto = trim(return-value).

/** Relacionamento com Funcion rio Oficina **/
FOR first mmv-func-ofici
    WHERE mmv-func-ofici.cd-mob-dir = p-cd-mob-dir NO-LOCK:
END.
IF  AVAIL mmv-func-ofici THEN DO:
    {utp/ut-liter.i "Funcion rio Oficina (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                      trim(return-value)).
end.

/*:T--- Verifica ocorrˆncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateNaturezaOperacao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateNaturezaOperacao Procedure 
PROCEDURE validateNaturezaOperacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input param p-nat-operacao like natur-oper.nat-operacao no-undo.

{utp/ut-liter.i "Natureza Opera‡Æo"}
assign cTexto = trim(return-value).

/** Relacionamento com Movimento Pneus **/
FOR first mpn-movto-pneu
    WHERE mpn-movto-pneu.nat-operacao = p-nat-operacao NO-LOCK:
END.
IF  AVAIL mpn-movto-pneu THEN DO:
    {utp/ut-liter.i "Movimento Pneus (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                      trim(return-value)).
end.

/*:T--- Verifica ocorrˆncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateSubConta) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateSubConta Procedure 
PROCEDURE validateSubConta :
/*------------------------------------------------------------------------------
  Purpose:     validateUNIDADE
  Parameters:  <none>
  Notes:       Valida‡äes cadastrais Frotas referentes a tabela "Centro Custo"
------------------------------------------------------------------------------*/
def input parameter psubconta AS CHARACTER no-undo.

{utp/ut-liter.i "Centro Custo"}
assign cTexto = trim(return-value).


/** Relacionamento com Equipamento **/
FOR first mab-eqpto
    where mab-eqpto.cod-ccusto-alter = psubconta no-lock:
END.
IF  AVAIL mab-eqpto THEN DO:
    {utp/ut-liter.i "Movimento de Eventos (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.

/** Relacionamento com Hist¢rico da Atividade **/
FOR first mab-histor-ativid
    where mab-histor-ativid.cod-ccusto-alter = psubconta no-lock:
END.
IF  AVAIL mab-histor-ativid THEN DO:
    {utp/ut-liter.i "Hist¢rico da Atividade (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.

/** Relacionamento com Movimento da Infra‡Æo **/
if can-find(first mnd-movto-infracao
            where mnd-movto-infracao.cc-codigo = psubconta no-lock) then do:
    {utp/ut-liter.i "Movimento de Infra‡Æo (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.

/** Relacionamento com Componente **/
if can-find(first mco-compon
            where mco-compon.cc-codigo-atual = psubconta no-lock) then do:
    {utp/ut-liter.i "Componente (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.

/** Relacionamento com Movimento de Componente **/
if can-find(first mco-movto-compon
            where mco-movto-compon.cc-codigo = psubconta no-lock) then do:
    {utp/ut-liter.i "Movimento de Componente (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.

/*:T--- Verifica ocorr¼ncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateTAG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateTAG Procedure 
PROCEDURE validateTAG :
/*------------------------------------------------------------------------------
  Purpose:     validateTAG
  Parameters:  <none>
  Notes:       Valida‡äes cadastrais Frotas referentes a tabela "tag"
------------------------------------------------------------------------------*/
{utp/ut-liter.i "TAG"}
assign cTexto = trim(return-value).

/** Busca o Registro de TAG **/
for first tag fields(cd-tag)
    where rowid(tag) = pRowid no-lock:
    /** Relacionamento com Equipamento da Manuten‡Æo Mecƒnica **/
    FOR first mab-eqpto
        where mab-eqpto.cd-tag = tag.cd-tag NO-LOCK:
    END.
    IF  AVAIL mab-eqpto THEN DO:
        {utp/ut-liter.i "Equipamento (Frota)"}
        run piCriaErro in this-procedure (input 6,
                                          input "EMS":U,
                                          input cTexto + '~~' +
                                                trim(return-value)).
    end.
    /** Relacionamento com Hist¢rico do Equipamento da Manuten‡Æo Mecƒnica **/
    FOR first mab-histor-ativid
        where mab-histor-ativid.cd-tag = tag.cd-tag NO-LOCK:
    END.
    IF  AVAIL mab-histor-ativid THEN DO:
        {utp/ut-liter.i "Hist¢rico do Equipamento (Frota)"}
        run piCriaErro in this-procedure (input 6,
                                          input "EMS":U,
                                          input cTexto + '~~' +
                                                trim(return-value)).
    end.
end.

/*:T--- Verifica ocorrˆncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateTipoFerramenta) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateTipoFerramenta Procedure 
PROCEDURE validateTipoFerramenta :
/*------------------------------------------------------------------------------
  Purpose:     validateTipoFerramenta
  Parameters:  <none>
  Notes:       Valida‡äes cadastrais Frotas referentes a tabela "tp-ferr"
------------------------------------------------------------------------------*/
{utp/ut-liter.i "Tipo Ferramenta"}
assign cTexto = trim(return-value).

/** Busca o Registro de Tipo Ferramenta **/
for first tp-ferr fields(cd-tp-ferr)
    where rowid(tp-ferr) = pRowid no-lock:
    /** Relacionamento com Ferramentas da Tarefa do Plano Manuten‡Æo Mecƒnica **/
    if can-find(first mmv-tar-plano-ferram
                where mmv-tar-plano-ferram.cd-tp-ferr = tp-ferr.cd-tp-ferr no-lock) then do:
        {utp/ut-liter.i "Ferramentas da Tarefa do Plano Manuten‡Æo Mecƒnica"}
        run piCriaErro in this-procedure (input 6,
                                          input "EMS":U,
                                          input cTexto + '~~' +
                                                trim(return-value)).
    end.
end.

/*:T--- Verifica ocorrˆncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateTipoManutencao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateTipoManutencao Procedure 
PROCEDURE validateTipoManutencao :
/*------------------------------------------------------------------------------
  Purpose:     validateTipoManutencao
  Parameters:  <none>
  Notes:       Valida‡äes cadastrais Frotas referentes a tabela "tipo-manut"
------------------------------------------------------------------------------*/
{utp/ut-liter.i "Tipo Manuten‡Æo"}
assign cTexto = trim(return-value).

/** Busca o Registro de Tipo de Manuten‡Æo **/
for first tipo-manut fields(cd-tipo)
    where rowid(tipo-manut) = pRowid no-lock:
    /** Relacionamento com Plano Manuten‡Æo Mecƒnica **/
    if can-find(first mmv-plano-prevent
                where mmv-plano-prevent.cd-tipo = tipo-manut.cd-tipo no-lock) then do:
        {utp/ut-liter.i "Plano Manuten‡Æo Mecƒnica"}
        run piCriaErro in this-procedure (input 6,
                                          input "EMS":U,
                                          input cTexto + '~~' +
                                                trim(return-value)).
    end.
    /** Relacionamento com Servi‡o **/
    if can-find(first mpn-serv
                where mpn-serv.cd-tipo = tipo-manut.cd-tipo no-lock) then do:
        {utp/ut-liter.i "Servi‡o"}
        run piCriaErro in this-procedure (input 6,
                                          input "EMS":U,
                                          input cTexto + '~~' +
                                                trim(return-value)).
    end.
    /** Relacionamento com Item Apontamento Lubrifica‡Æo **/
    FOR first mab-item-lubrific
        where mab-item-lubrific.cd-tipo = tipo-manut.cd-tipo NO-LOCK:
    END.
    IF  AVAIL mab-item-lubrific THEN DO:
        {utp/ut-liter.i "Item Apontamento Lubrifica‡Æo"}
        run piCriaErro in this-procedure (input 6,
                                          input "EMS":U,
                                          input cTexto + '~~' +
                                                trim(return-value)).
    end.
    /** Relacionamento com Movimento Evento **/
    if can-find(first mab-movto-event
                where mab-movto-event.cd-tipo = tipo-manut.cd-tipo no-lock) then do:
        {utp/ut-liter.i "Movimento Evento"}
        run piCriaErro in this-procedure (input 6,
                                          input "EMS":U,
                                          input cTexto + '~~' +
                                                trim(return-value)).
    end.
    /** Relacionamento com Reporte Horas Funcion rios Manuten‡Æo Mecƒnica **/
    FOR first mmv-movto-mdo
        where mmv-movto-mdo.cd-tipo = tipo-manut.cd-tipo NO-LOCK:
    END.
    IF  AVAIL mmv-movto-mdo THEN DO:
        {utp/ut-liter.i "Reporte Horas Funcion rios Manuten‡Æo Mecƒnica"}
        run piCriaErro in this-procedure (input 6,
                                          input "EMS":U,
                                          input cTexto + '~~' +
                                                trim(return-value)).
    end.
    /** Relacionamento com Ordem Manuten‡Æo Mecƒnica **/
    FOR first mmv-ord-manut
        where mmv-ord-manut.cd-tipo = tipo-manut.cd-tipo no-lock:
    END.
    IF  AVAIL mmv-ord-manut THEN DO:
        {utp/ut-liter.i "Ordem Manuten‡Æo Mecƒnica"}
        run piCriaErro in this-procedure (input 6,
                                          input "EMS":U,
                                          input cTexto + '~~' +
                                                trim(return-value)).
    end.
    /** Relacionamento com Tarefa da Ordem Manuten‡Æo Mecƒnica **/
    if can-find(first mmv-tar-ord-manut
                where mmv-tar-ord-manut.cd-tipo = tipo-manut.cd-tipo no-lock) then do:
        {utp/ut-liter.i "Tarefa da Ordem Manuten‡Æo Mecƒnica"}
        run piCriaErro in this-procedure (input 6,
                                          input "EMS":U,
                                          input cTexto + '~~' +
                                                trim(return-value)).
    end.
end.

/*:T--- Verifica ocorrˆncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateUF) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateUF Procedure 
PROCEDURE validateUF :
/*------------------------------------------------------------------------------
  Purpose:     validateUNIDADE
  Parameters:  <none>
  Notes:       Valida‡äes cadastrais Frotas referentes a tabela "unid-feder"
------------------------------------------------------------------------------*/
def input parameter pestado like unid-feder.estado  no-undo.
def input parameter ppais   like unid-feder.pais    no-undo.

{utp/ut-liter.i "Unidade Federativa"}
assign cTexto = trim(return-value).
    

/** Relacionamento com Motorista da Frota **/
FOR first mab-motoris
    where mab-motoris.cod-estado   = pestado 
    and   mab-motoris.cod-pais     = ppais   NO-LOCK:
END.
IF  AVAIL mab-motoris THEN DO:
    {utp/ut-liter.i "Motorista (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.

/** Relacionamento com Movimento da Infra‡Æo**/
if can-find(first mnd-movto-infracao
            where mnd-movto-infracao.cod-estado-habilit   = pestado 
            and   mnd-movto-infracao.cod-pais-habilit     = ppais   no-lock) then do:
    {utp/ut-liter.i "Movimento da Infra‡Æo (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.

/** Relacionamento com Solicita‡Æo de Pagamento**/
if can-find(first mnd-solicit-pagto
            where mnd-solicit-pagto.cod-estado   = pestado 
            and   mnd-solicit-pagto.cod-pais     = ppais   no-lock) then do:
    {utp/ut-liter.i "Solicita‡Æo de Pagamento (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.

/** Relacionamento com Movimenta‡Æo do Processo**/
if can-find(first mnd-movto-proces
            where mnd-movto-proces.cod-estado   = pestado 
            and   mnd-movto-proces.cod-pais     = ppais   no-lock) then do:
    {utp/ut-liter.i "Movimenta‡Æo do Processo (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.



/*:T--- Verifica ocorr¼ncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateUnidade) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateUnidade Procedure 
PROCEDURE validateUnidade :
/*------------------------------------------------------------------------------
  Purpose:     validateUNIDADE
  Parameters:  <none>
  Notes:       Valida‡äes cadastrais Frotas referentes a tabela "tab-unidade"
------------------------------------------------------------------------------*/
def input parameter pun like tab-unidade.un no-undo.

{utp/ut-liter.i "Unidade Medida"}
assign cTexto = trim(return-value).

/** Relacionamento com Equipamento da Manuten»’o Mec³nica **/
if can-find(first mab-tip-mater
            where mab-tip-mater.un = pun no-lock) then do:
    {utp/ut-liter.i "Tipo de Material (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.

/** Relacionamento com Modelo Equipamento/Componente **/
if can-find(first mab-model
            where mab-model.un = pun no-lock) then do:
    {utp/ut-liter.i "Modelo Equipamento/Componente(Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.

/** Relacionamento com Modelo Pneu **/
if can-find(first mpn-model
            where mpn-model.un = pun no-lock) then do:
    {utp/ut-liter.i "Modelo Pneu (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.
/** Relacionamento com Quantidade Transportada **/
if can-find(first mgf-quant-transp
            where mgf-quant-transp.un = pun no-lock) then do:
    {utp/ut-liter.i "Quantidade Transportada (Frota)"}
    run piCriaErro in this-procedure (input 6,
                                      input "EMS":U,
                                      input cTexto + '~~' +
                                            trim(return-value)).
end.

/*:T--- Verifica ocorr¼ncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

