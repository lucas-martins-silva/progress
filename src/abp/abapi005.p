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
{include/i-prgvrs.i ABAPI005 2.00.00.025 } /*** "010025" 16/05/2025 17:37:32 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i abapi005 MAB}
&ENDIF


/*****************************************************************************
**
**       PROGRAMA: ABAPI005.p
**
**       DATA....: Agosto de 2003
**
**       AUTOR...: Marcio Willwock - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Integraá∆o Frotas com EMS
**
*****************************************************************************/

/* ***************************  Definitions  ************************** */

{include/i-epc200.i ABAPI005} /* Temp table tt-epc */
{cep/ceapi001k.i}   /* Definicao de temp-table do movto-estoq */
{cdp/cd0666.i}   /** Temp-Table erros **/
{abp/abapi005.i} /** Temp-Tables de abastecimento **/
{abp/abapi003.i} /** Definiá∆o da ttDocumento **/
{abp/ab9004.i} /** Definiá∆o da Temp-table RowErrors **/
{cep/ceapi001j.i1} /** tt-movto-un **/

DEFINE TEMP-TABLE tt-movto-aux NO-UNDO LIKE tt-movto.

define temp-table ttTransacao no-undo
    field cod-depos   like tt-movto.cod-depos  
    field cod-estabel like tt-movto.cod-estabel
    field cod-refer   like tt-movto.cod-refer  
    field it-codigo   like tt-movto.it-codigo  
    field cod-localiz like tt-movto.cod-localiz
    field lote        like tt-movto.lote       
    field dt-trans    like tt-movto.dt-trans   
    field num-docto   like mab-abastec-lubrific.num-docto
    field r-rowid     as rowid
    field i-tipo      as integer.  /** 1 = Abastecimento  /  2 = Lubrificaá∆o **/

DEFINE INPUT  PARAMETER h-acomp AS HANDLE NO-UNDO.
define input  parameter table for tt-param.
define input  parameter table for ttDocumento.
define output parameter table for RowErrors.


DEFINE VARIABLE cTexto           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lEstabelecimento AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lAcumula         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-param7         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE h-ceapi001k      AS HANDLE     NO-UNDO.
/** Per°odo (cdapi005) **/
def var da-iniper-aber like param-estoq.ult-fech-dia no-undo.

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
         HEIGHT             = 12.58
         WIDTH              = 30.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
FOR FIRST mab-param-integr
    WHERE mab-param-integr.cdn-param = 7 NO-LOCK:
END.
IF AVAIL mab-param-integr AND mab-param-integr.des-valor <> "2" THEN
    ASSIGN l-param7 = YES.
ELSE 
    ASSIGN l-param7 = NO.


/** Inicia a API **/
run piInicializacao in this-procedure.

{abp/abapi001.i2} /** Criaá∆o de Erros **/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-cria-tt-movto-un) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-movto-un Procedure 
PROCEDURE pi-cria-tt-movto-un :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &IF DEFINED(bf_mnt_ems206b) &THEN
        FOR EACH tt-movto-un EXCLUSIVE-LOCK:
            DELETE tt-movto-un.
        END.
        /******************************
        Buscar o Hist¢rico da atividade conforme per°odo de abastecimento
        ******************************/
        FOR LAST  mab-histor-ativid
            WHERE mab-histor-ativid.ep-codigo     = mab-abastec-lubrific.ep-codigo
            AND   mab-histor-ativid.cod-eqpto     = mab-abastec-lubrific.cod-eqpto
            AND   mab-histor-ativid.dat-cadastro <= mab-abastec-lubrific.dat-movto NO-LOCK:
            /* Quando a unidade de neg¢cio do abastecimento for diferente do hist¢rio do equipamento da data do abastecimento
               100 % dos custo ir† para a unidade principal do equipamento, ou seja, n∆o ter† matriz de rateio */ 
            IF  mab-histor-ativid.cod-unid-negoc = mab-abastec-lubrific.cod-unid-negoc THEN DO:
                /******************************
                Buscar AS unidades de Neg¢cios existente na matriz de unidade de neg¢cio DO hist¢rico da atividade conforme per°odo de abastecimento
                ******************************/
                FOR EACH  mab-unid-negoc-histor-ativid
                    WHERE mab-unid-negoc-histor-ativid.ep-codigo    = mab-histor-ativid.ep-codigo
                    AND   mab-unid-negoc-histor-ativid.cod-eqpto    = mab-histor-ativid.cod-eqpto
                    AND   mab-unid-negoc-histor-ativid.dat-cadastro = mab-histor-ativid.dat-cadastro NO-LOCK:
                    /******************************
                    Realizar a criaá∆o da TEMP-TABLE "tt-movto-un" conforme unidade de Neg¢cio existente NO Hist¢rico da atividade.
                    Observaá∆o: Levar em consideraá∆o a REGRA DE RATEIO
                    ******************************/
                    CREATE tt-movto-un.
                    ASSIGN tt-movto-un.i-sequen      = 0
                           tt-movto-un.cod-unid-neg  = mab-unid-negoc-histor-ativid.cod-unid-negoc
                           tt-movto-un.perc-unid-neg = mab-unid-negoc-histor-ativid.val-perc-unid-negoc.
                END.
            END.
        END.
    &ENDIF

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piAtualizaDocumento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaDocumento Procedure 
PROCEDURE piAtualizaDocumento :
/*------------------------------------------------------------------------------
  Purpose:     piAtualizaDocumento
  Parameters:  <none>
  Notes:       Passa por registros consistidos para atualizar integraá∆o.
------------------------------------------------------------------------------*/
define buffer bfApont for mab-abastec-lubrific.
DEFINE VARIABLE l-atualiza AS LOGICAL    NO-UNDO.

for each  ttDocumento
    where ttDocumento.lIntegrar no-lock:

    ASSIGN l-atualiza = YES.

    {utp/ut-liter.i "Atualizando Status Ficha" *}
    if VALID-HandLE(h-acomp) then run pi-acompanhar in h-acomp(RETURN-VALUE + ": ":U + STRING(ttDocumento.num-docto)).
    /** Busca Temp-Table de Integraá∆o **/
    for each  ttTransacao
        where ttTransacao.num-docto = ttDocumento.num-docto no-lock:
        /** Busca Temp-Table de Movimentos **/
        for first tt-movto-aux
            where tt-movto-aux.referencia  = STRING(ttTransacao.r-rowid) no-lock:
            if ttTransacao.i-tipo = 1 then do:
                /** Busca Apontamentos de Abastecimento **/
                for first mab-item-abastec
                    where rowid(mab-item-abastec) = ttTransacao.r-rowid exclusive-lock:
                    /** Atualiza n£mero da transaá∆o da movto-estoq **/
                    assign mab-item-abastec.nr-trans = tt-movto-aux.nr-trans.
                end.
                /** Valida registro para o Oracle **/
                validate mab-item-abastec.
            end.
            else do:
                /** Busca Apontamento de Lubrificaá∆o **/
                for first mab-item-lubrific
                    where rowid(mab-item-lubrific) = ttTransacao.r-rowid exclusive-lock:
                    /** Atualiza n£mero da transaá∆o da movto-estoq **/
                    assign mab-item-lubrific.nr-trans = tt-movto-aux.nr-trans.
                end.
                /** Valida registro em Oracle **/
                validate mab-item-lubrific.
            end.
        end.
    end.
    /************************************************************************************
    ** S¢ atualiza ficha se todos os itens estiverem integrados
    ************************************************************************************/
    /** Busca Posto de Abastecimento **/
    for first mab-posto
        where mab-posto.cod-posto = ttDocumento.cod-posto no-lock:
    end.
    if avail mab-posto then do:
        /** Se Posto for pr¢prio, baixa estoque **/
        if mab-posto.idi-posto    = 1 then do:
            /** Busca Apontamentos de Lubrificaªío **/
            for each  mab-item-lubrific
                where mab-item-lubrific.num-docto = ttDocumento.num-docto no-lock:
                /** Tipo de Material deve estar integrando com o estoque conforme a data do documento **/
                for first mab-tip-mater
                    where mab-tip-mater.cod-tip-mater = mab-item-lubrific.cod-tip-mater no-lock:
                    /****************************************
                    ** Caso n∆o tenha sido integrado, n∆o integra a ficha
                    *****************************************/
                    if mab-tip-mater.log-integr and mab-tip-mater.dat-livre-1 <= ttDocumento.dat-movto and
                       mab-item-lubrific.nr-trans = 0 then
                        ASSIGN l-atualiza = NO.
                end.
                
            end.
        end.
        /** Busca Apontamentos de Abastecimento **/
        for each mab-item-abastec
            where mab-item-abastec.num-docto = ttDocumento.num-docto no-lock:
            /** Busca Posto do Abastecimento **/
            if mab-posto.cod-posto <> mab-item-abastec.cod-posto then do:
                for first mab-posto
                    where mab-posto.cod-posto = mab-item-abastec.cod-posto no-lock:
                end.
            end.
            /** Verifica se posto Ç pr¢prio **/
            if avail mab-posto and mab-posto.idi-posto = 1 then do:
                /** Tipo de Material deve estar integrando com o estoque conforme a data do documento **/
                for first mab-tip-mater
                    where mab-tip-mater.cod-tip-mater = mab-item-abastec.cod-tip-mater no-lock:
                    /****************************************
                    ** Caso n∆o tenha sido integrado, n∆o integra a ficha
                    *****************************************/
                    if mab-tip-mater.log-integr and mab-tip-mater.dat-livre-1 <= ttDocumento.dat-movto and
                       mab-item-abastec.nr-trans = 0 then
                        ASSIGN l-atualiza = NO.
                end.
            end.
        end.
    end.
    /** Verifica se est† tudo integrado para integrar a ficha **/
    IF l-atualiza = YES THEN DO:
        for first bfApont
            where rowid(bfApont) = ttDocumento.r-rowid exclusive-lock:
            /* 1  N∆o integrada
               2  Integrada */
            assign bfApont.idi-integr = 2.
        end.
    end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piCriaMovimento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaMovimento Procedure 
PROCEDURE piCriaMovimento :
/*------------------------------------------------------------------------------
  Purpose:     piCriaMovimento
  Parameters:  entrada cRefer  = C¢digo da Referància 
               entrada cItem   = C¢digo do Item
               entrada cLocal  = C¢digo Localizaá∆o
               entrada cLote   = C¢digo Lote
               entrada deQuant = Quantidade do Item
               entrada iTipo   = Tipo de Apontamento (Abastec/Lubrific)
               entrada rRowid  = Rowid da tabela (Abastec/Lubrific)
  Notes:       Criaá∆o da Temp-Table da API de Estoque
------------------------------------------------------------------------------*/
define input parameter cRefer  like mab-item-lubrific.cod-refer   no-undo.
define input parameter cItem   like mab-item-lubrific.it-codigo   no-undo.
define input parameter cLocal  like mab-item-lubrific.cod-localiz no-undo.
define input parameter cLote   like mab-item-lubrific.lote        no-undo.
define input parameter deQuant like mab-item-lubrific.val-quant   no-undo.
define input parameter cCtaCod like mab-item-lubrific.cod-cta-ctbl   no-undo.
define input parameter cCCentroCod like mab-item-lubrific.cod-ccusto no-undo.
define input parameter iTipo   as   integer                       no-undo.
define input parameter rRowid  as   rowid                         no-undo.

DEFINE BUFFER bf-mab-posto FOR mab-posto.

/** N∆o deve-se criar requisiá‰es no EMS para quantidades zeradas, 
    esta situaá∆o pode ocorrer na amostragem de ¢leo por exemplo **/
if deQuant = 0 then
    return "OK":U.

create tt-epc.
assign tt-epc.cod-event     = "VALIDA-EMPRESA"
       tt-epc.cod-parameter = "cod-estabel"
       tt-epc.val-parameter = string(mab-posto.cod-estabel).
{include/i-epc201.i  "VALIDA-EMPRESA"}
IF RETURN-VALUE = "NOK" THEN DO:
    FOR EACH tt-epc 
        WHERE tt-epc.cod-event = "VALIDA-EMPRESA"
        AND   tt-epc.cod-parameter = "EPC-ERROR" NO-LOCK:
        run piCriaErro (17006, 'EMS':U, tt-epc.val-parameter).
    END.
    RETURN "NOK":U.
END.

/** Data Transaá∆o, deve-se verificar o per°odo fechado **/
if lEstabelecimento then do:
    if NOT avail estab-mat or estab-mat.cod-estabel <> mab-posto.cod-estabel then do: /*Xavier na UC*/
        for first estab-mat
            where estab-mat.cod-estabel = mab-posto.cod-estabel no-lock:
        end.
    end.
    /** N∆o existe estabelecimento material **/
    if not avail estab-mat then do:
        {utp/ut-table.i mgind estab-mat 1}
        assign cTexto = return-value + "~~" + string(mab-posto.cod-estabel).
        run piCriaErro (2, 'EMS':U, cTexto).
    end.
    else do:
        assign da-iniper-aber = estab-mat.mensal-ate + 1.
    end.
end.
FOR FIRST bf-mab-posto
    WHERE bf-mab-posto.cod-posto = mab-abastec-lubrific.cod-posto NO-LOCK:
END.
/** Criaá∆o da tt-movto **/
create tt-movto.
assign tt-movto.cod-versao-integracao = 001
       tt-movto.cod-prog-orig         = "ABAPI005":U
       tt-movto.usuario               = mab-abastec-lubrific.cod-usuar
       tt-movto.it-codigo             = cItem
       tt-movto.cod-depos             = IF AVAIL bf-mab-posto AND iTipo = 2 THEN bf-mab-posto.cod-depos ELSE mab-posto.cod-depos
       tt-movto.cod-emitente          = 0
       tt-movto.cod-estabel           = IF AVAIL bf-mab-posto AND iTipo = 2 THEN bf-mab-posto.cod-estabel ELSE mab-posto.cod-estabel
       tt-movto.cod-refer             = cRefer
       tt-movto.referencia            = STRING(rRowid)  /** Neste campo faz-se referància ao item abastecido ou lubrificado **/
       tt-movto.esp-docto             = 28 /** Requisiá∆o **/
       tt-movto.cod-localiz           = cLocal
       tt-movto.lote                  = cLote
       tt-movto.nro-docto             = string(mab-abastec-lubrific.num-docto)
       tt-movto.quantidade            = deQuant
       tt-movto.ct-codigo             = mab-abastec-lubrific.ct-codigo
       tt-movto.sc-codigo             = mab-abastec-lubrific.cc-codigo
       tt-movto.tipo-trans            = 2  /** Sa°da **/
       tt-movto.nro-docto             = string(mab-abastec-lubrific.num-docto)
       tt-movto.serie-docto           = ""
       tt-movto.tipo-valor            = 2  /** Valorizado **/
       tt-movto.dt-nf-saida           = ?. /* Para REQ, data da nota fiscal deve ser nula */

       /*  IRM001380 - Contabilizaá∆o Item Abastecimento/Lubrificaá∆o */
       FOR FIRST mab-param
           WHERE mab-param.cdn-param = 55 no-lock:
           IF  mab-param.des-valor = "1":U then do:
               /* sobrepoe os campos "tt-movto.ct-codigo" e "tt-movto.sc-codigo" j† gravados*/
               ASSIGN tt-movto.ct-codigo = cCtaCod /* Conta Lubrificacao */
                      tt-movto.sc-codigo = cCCentroCod. /* Centro de Custo Lubricacao */
           END.
       END.

&IF DEFINED(bf_mnt_ems206b) &THEN
    assign tt-movto.cod-unid-negoc = mab-abastec-lubrific.cod-unid-negoc.
&ENDIF

/*------------------------------------------------------------------------------
  Criaá∆o da Narrativa do Movimento
----------------------------------------------
Movimento de Estoque criado para a ficha de abastecimento e Lubrificaá∆o:
Documento..: mab-abastec-lubrific.num-docto
Equipamento: mab-abastec-lubrific.ep-codigo + " - " + mab-abastec-lubrific.cod-eqpto
Data.......: mab-abastec-lubrific.dat-movto
Usu†rio....: mab-abastec-lubrific.cod-usuario
Posto......: mab-abastec-lubrific.cod-posto ou mab-item-abastec.cod-posto
Dep¢sito...: mab-posto.cod-depos
Estabelec..: mab-posto.cod-estabel
Item.......: mab-item-abastec.it-codigo ou mab-item-lubrific.it-codigo
Referància.: mab-item-abastec.cod-refer ou mab-item-lubrific.cod-refer
Localizaá∆o: mab-item-abastec.cod-localiz ou mab-item-lubrific.cod-localiz
Lote.......: mab-item-abastec.lote ou mab-item-lubrific.lote
Quantidade.: mab-item-abastec.val-quant ou mab-item-lubrific.val-quant
-----------------------------------------------   
------------------------------------------------------------------------------*/

/**************************************
Conforme a FO 1321.979 a descriá∆o do movimento de estoque est† sendo alterada para que n∆o gere informaá‰es
'desnecess†ria'. Ser† criado em outro momento um parÉmetro no sistema de frotas habilitando (ou n∆o) a criaá∆o desta narrativa
**************************************/
IF NOT(l-param7) THEN DO:
    {utp/ut-liter.i "Movimento de Estoque criado para a ficha de abastecimento e Lubrificaá∆o (Frotas)"}
    ASSIGN tt-movto.descricao-db = RETURN-VALUE.
END.
ELSE DO:
    {utp/ut-liter.i "Movimento de Estoque criado para a ficha de abastecimento e Lubrificaá∆o (Frotas)"}
    ASSIGN tt-movto.descricao-db = RETURN-VALUE + ": " + CHR(10) + CHR(10).
    {utp/ut-liter.i "Documento"}
    ASSIGN tt-movto.descricao-db = tt-movto.descricao-db + RETURN-VALUE + "......: " + STRING(mab-abastec-lubrific.num-docto) + CHR(10).
    {utp/ut-liter.i "Equipamento"}
    ASSIGN tt-movto.descricao-db = tt-movto.descricao-db + RETURN-VALUE + "....: " + STRING(mab-abastec-lubrific.ep-codigo) + " - " + mab-abastec-lubrific.cod-eqpto + CHR(10).
    {utp/ut-liter.i "Data"}
    ASSIGN tt-movto.descricao-db = tt-movto.descricao-db + RETURN-VALUE + "...........: " + STRING(mab-abastec-lubrific.dat-movto,"99/99/9999") + CHR(10).
    {utp/ut-liter.i "Usu†rio"}
    ASSIGN tt-movto.descricao-db = tt-movto.descricao-db + RETURN-VALUE + "........: " + STRING(mab-abastec-lubrific.cod-usuar) + CHR(10).
    {utp/ut-liter.i "Posto"}
    ASSIGN tt-movto.descricao-db = tt-movto.descricao-db + RETURN-VALUE + "..........: " + STRING(mab-posto.cod-posto) + CHR(10).
    {utp/ut-liter.i "Dep¢sito"}
    ASSIGN tt-movto.descricao-db = tt-movto.descricao-db + RETURN-VALUE + ".......: " + STRING(mab-posto.cod-depos) + CHR(10).
    {utp/ut-liter.i "Estabelecimento"}
    ASSIGN tt-movto.descricao-db = tt-movto.descricao-db + RETURN-VALUE + ": " + STRING(mab-posto.cod-estabel) + CHR(10).
    {utp/ut-liter.i "Item"}
    ASSIGN tt-movto.descricao-db = tt-movto.descricao-db + RETURN-VALUE + "...........: " + STRING(cItem) + CHR(10).
    {utp/ut-liter.i "Referància"}
    ASSIGN tt-movto.descricao-db = tt-movto.descricao-db + RETURN-VALUE + ".....: " + STRING(cRefer) + CHR(10).
    {utp/ut-liter.i "Localizaá∆o"}
    ASSIGN tt-movto.descricao-db = tt-movto.descricao-db + RETURN-VALUE + "....: " + STRING(cLocal) + CHR(10).
    {utp/ut-liter.i "Lote"}
    ASSIGN tt-movto.descricao-db = tt-movto.descricao-db + RETURN-VALUE + "...........: " + STRING(cLote) + CHR(10).
    {utp/ut-liter.i "Quantidade"}
    ASSIGN tt-movto.descricao-db = tt-movto.descricao-db + RETURN-VALUE + ".....: " + STRING(deQuant) + CHR(10).
END.

/** Item **/
if not avail item or item.it-codigo <> cItem then
    for first item fields(un it-codigo)
        where item.it-codigo = cItem no-lock:
    end.
if avail item then
    assign tt-movto.un = item.un.

/** Verifica se data de movimento est† no per°odo em aberto **/
if mab-abastec-lubrific.dat-movto < da-iniper-aber then
    assign tt-movto.dt-trans    = da-iniper-aber.
else 
    assign tt-movto.dt-trans    = mab-abastec-lubrific.dat-movto.

/** Criaá∆o da temp-table de ligaá∆o entre 
    apontamentos e movimentos no estoque **/
create ttTransacao.
assign ttTransacao.cod-depos   = tt-movto.cod-depos  
       ttTransacao.cod-estabel = tt-movto.cod-estabel
       ttTransacao.cod-refer   = tt-movto.cod-refer  
       ttTransacao.it-codigo   = tt-movto.it-codigo  
       ttTransacao.cod-localiz = tt-movto.cod-localiz
       ttTransacao.lote        = tt-movto.lote       
       ttTransacao.dt-trans    = tt-movto.dt-trans
       ttTransacao.num-docto   = mab-abastec-lubrific.num-docto
       ttTransacao.r-rowid     = rRowid
       ttTransacao.i-tipo      = iTipo.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piInicializacao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piInicializacao Procedure 
PROCEDURE piInicializacao :
/*------------------------------------------------------------------------------
  Purpose:     piInicializacao
  Parameters:  <none>
  Notes:       Inicializa a API
------------------------------------------------------------------------------*/
find first tt-param NO-LOCK no-error.
/** Validaá‰es Iniciais **/
run piValidaInicial in this-procedure.
if return-value = "OK":U then do:
    /** Processa Integraá∆o com EMS **/
    run piProcessaIntegracao in this-procedure.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piPrincipal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPrincipal Procedure 
PROCEDURE piPrincipal :
/*------------------------------------------------------------------------------
  Purpose:     piPrincipal
  Parameters:  entrada estabIni = C¢digo Estabelecimento Inicial
               entrada estabFim = C¢digo Estabelecimento Final
  Notes:       Procedure com o c¢digo principal para acessar as informaá‰es
------------------------------------------------------------------------------*/
define input parameter estabIni    like mab-posto.cod-estabel no-undo.
define input parameter estabFim    like mab-posto.cod-estabel no-undo.
define input parameter depositoIni like mab-posto.cod-depos no-undo.
define input parameter depositoFim like mab-posto.cod-depos no-undo.


/** Busca Posto de Abastecimento **/
for first mab-posto
    where mab-posto.cod-posto = mab-abastec-lubrific.cod-posto no-lock:
end.
if avail mab-posto then do:
    /** Se Posto for pr¢prio e estiver na faixa de estabelecimentos, baixa estoque **/
    if mab-posto.idi-posto    = 1           and 
       mab-posto.cod-estabel >= estabIni    and 
       mab-posto.cod-estabel <= estabFim    and 
       mab-posto.cod-depos   >= depositoIni and
       mab-posto.cod-depos   <= depositoFim then do:
        /** Busca Apontamentos de Lubrificaá∆o **/
        for each  mab-item-lubrific
            where mab-item-lubrific.num-docto = mab-abastec-lubrific.num-docto no-lock:
            /** Item j† integrado n∆o realiza nova requisiá∆o **/
            IF mab-item-lubrific.nr-trans <> 0 and mab-item-lubrific.nr-trans <> ? THEN NEXT.
            /** Tipo de material deve ter flag de integraá∆o **/
            for first mab-tip-mater
                where mab-tip-mater.cod-tip-mater = mab-item-lubrific.cod-tip-mater 
                and   mab-tip-mater.log-integr no-lock:

                IF mab-abastec-lubrific.dat-movto < mab-tip-mater.dat-livre-1 THEN NEXT.
                /** Criaá∆o da tt-movto **/
                run piCriaMovimento in this-procedure (input mab-item-lubrific.cod-refer  ,
                                                       input mab-item-lubrific.it-codigo  ,
                                                       input mab-item-lubrific.cod-localiz,
                                                       input mab-item-lubrific.lote       ,
                                                       input mab-item-lubrific.val-quant  ,
                                                       input mab-item-lubrific.cod-cta-ctbl,
                                                       input mab-item-lubrific.cod-ccusto ,
                                                       input 2,  /** Lubrificaá∆o **/
                                                       input rowid(mab-item-lubrific)).
            end.
        end.
    end.
    /** Busca Apontamentos de Abastecimento **/
    for each mab-item-abastec
        where mab-item-abastec.num-docto = mab-abastec-lubrific.num-docto no-lock:
        /** Item jˇ integrado n∆o realiza nova requisiá∆o **/
        IF mab-item-abastec.nr-trans <> 0 and mab-item-abastec.nr-trans <> ? THEN NEXT.
        /** Busca Posto do Abastecimento **/
        if mab-posto.cod-posto <> mab-item-abastec.cod-posto then do:
            for first mab-posto
                where mab-posto.cod-posto = mab-item-abastec.cod-posto no-lock:
            end.
        end.
        /** Verifica se posto est† na faixa de seleá∆o dos estabelecimentos **/
        if avail mab-posto                      and 
           mab-posto.idi-posto    = 1           and
           mab-posto.cod-estabel >= estabIni    and
           mab-posto.cod-estabel <= estabFim    and 
           mab-posto.cod-depos   >= depositoIni and
           mab-posto.cod-depos   <= depositoFim then do:
            /** Tipo de material deve ter flag de integraá∆o **/
            for first mab-tip-mater
                where mab-tip-mater.cod-tip-mater = mab-item-abastec.cod-tip-mater 
                and   mab-tip-mater.log-integr  no-lock:
                /** Validaá∆o para saber se a Data de Movimento Ç menor que a data do in°cio do controle **/
                IF mab-abastec-lubrific.dat-movto < mab-tip-mater.dat-livre-1 THEN NEXT.
                /** Criaá∆o da tt-movto **/
                run piCriaMovimento in this-procedure (input mab-item-abastec.cod-refer  ,
                                                       input mab-item-abastec.it-codigo  ,
                                                       input mab-item-abastec.cod-localiz,
                                                       input mab-item-abastec.lote       ,
                                                       input mab-item-abastec.val-quant  ,
                                                       input mab-item-abastec.cod-cta-ctbl,
                                                       input mab-item-abastec.cod-ccusto ,
                                                       input 1,   /** Abastecimento **/
                                                       input rowid(mab-item-abastec)).
            end.
        end.
    end.
end.


return "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piProcessaIntegracao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piProcessaIntegracao Procedure 
PROCEDURE piProcessaIntegracao :
/*------------------------------------------------------------------------------
  Purpose:     piProcessaIntegracao
  Parameters:  <none>
  Notes:       Inicia a integraá∆o entre frotas e EMS
------------------------------------------------------------------------------*/
/** Verificaá∆o do Per°odo aberto **/
FOR FIRST param-estoq NO-LOCK:
    /** Verifica Tipo Fechamento **/
    IF param-estoq.tp-fech = 2 THEN
        ASSIGN lEstabelecimento = YES.
    /** Fechamento Ènico **/
    IF NOT lEstabelecimento THEN DO:
        ASSIGN da-iniper-aber = param-estoq.mensal-ate + 1.
    END.
END.

/** Seleá∆o por faixa **/
IF AVAIL tt-param THEN DO:
    /** Verifica parÉmetro para acumular quantidades do item **/
    ASSIGN lAcumula = tt-param.lAcumula.
    /** Busca Fichas de Abastecimento e Lubrificaá∆o **/
    FOR EACH  mab-abastec-lubrific 
        WHERE mab-abastec-lubrific.dat-movto  <= tt-param.dataMovimento 
        AND   mab-abastec-lubrific.idi-integr  = 1 
        AND   mab-abastec-lubrific.log-consist NO-LOCK:

        &IF DEFINED(bf_mnt_ems206b) &THEN
            IF l-usa-unid-negoc THEN DO:
                IF NOT (mab-abastec-lubrific.cod-unid-negoc >= tt-param.unidNegocIni  AND
                        mab-abastec-lubrific.cod-unid-negoc <= tt-param.unidNegocFim) THEN NEXT.
            END.
        &ENDIF

        CREATE ttDocumento.
        BUFFER-COPY mab-abastec-lubrific TO ttDocumento.

        FOR EACH tt-movto EXCLUSIVE-LOCK:
            DELETE tt-movto.
        END.
        /** Busca as informaá‰es **/
        RUN piPrincipal IN THIS-PROCEDURE (INPUT tt-param.estabInicial,
                                           INPUT tt-param.estabFinal,
                                           INPUT tt-param.depositoIni,
                                           INPUT tt-param.depositoFim).
        IF NOT CAN-FIND(FIRST tt-movto) THEN NEXT.

        {utp/ut-liter.i "Integrando Ficha" *}
        IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp(RETURN-VALUE + ": ":U + STRING(mab-abastec-lubrific.num-docto)).

        /** Integraá∆o com EMS **/
        RUN cep/ceapi001k.p PERSISTENT SET h-ceapi001k.

        IF VALID-HANDLE(h-ceapi001k) THEN DO:
            IF l-usa-unid-negoc THEN DO:
                RUN pi-cria-tt-movto-un  IN THIS-PROCEDURE.
                RUN pi-valida-movto-uneg IN h-ceapi001k (INPUT TABLE tt-movto-un).
            END.

            RUN pi-execute IN h-ceapi001k (INPUT-OUTPUT TABLE tt-movto,
                                           INPUT-OUTPUT TABLE tt-erro,
                                           INPUT YES).
            DELETE PROCEDURE h-ceapi001k.
        END.

        ASSIGN ttDocumento.r-rowid  = ROWID(mab-abastec-lubrific)
               ttDocumento.lIntegrar = YES.

        /** Guarda o movimento gerado em TT auxiliar 
            para atualizaá∆o posterior **/
        FOR EACH tt-movto NO-LOCK:
            CREATE tt-movto-aux.
            BUFFER-COPY tt-movto TO tt-movto-aux.
        END.

        /** Verifica se existem erros **/
        FOR EACH tt-erro:
            RUN piCriaErro(tt-erro.cd-erro, 'EMS':U, '').
            {utp/ut-liter.i Ficha *}
            ASSIGN RowErrors.ErrorDescription = RETURN-VALUE + ": " + 
                                                STRING(ttDocumento.num-docto,">>>>>>>>9") + " - " + 
                                                tt-erro.mensagem
                   ttDocumento.lIntegrar       = NO.
            IF   tt-erro.cd-erro = 1137 THEN DO:
                 ASSIGN RowErrors.ErrorSubType = "ERROR":U.                
            END.
        END.
    END.
END.
/** Integraá∆o das APIs **/
ELSE DO:
    FOR EACH ttDocumento EXCLUSIVE-LOCK:
        FOR FIRST mab-abastec-lubrific
            WHERE ROWID(mab-abastec-lubrific)      = ttDocumento.r-rowid 
            AND   mab-abastec-lubrific.idi-integr  = 1 NO-LOCK:
            
            {utp/ut-liter.i "Integrando Ficha" *}
            IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp(RETURN-VALUE + ": ":U + STRING(mab-abastec-lubrific.num-docto) ).

            FOR EACH tt-movto EXCLUSIVE-LOCK:
                DELETE tt-movto.
            END.

            /** Busca as informaá‰es **/
            RUN piPrincipal IN THIS-PROCEDURE (INPUT "":U,
                                               INPUT "ZZZ":U,
                                               INPUT "":U,
                                               INPUT "ZZZ":U).
            IF NOT CAN-FIND(FIRST tt-movto) THEN NEXT.

            /** Integraá∆o com EMS **/
            RUN cep/ceapi001k.p PERSISTENT SET h-ceapi001k.

            IF VALID-HANDLE(h-ceapi001k) THEN DO:
                IF l-usa-unid-negoc THEN DO:
                    RUN pi-cria-tt-movto-un  IN THIS-PROCEDURE.
                    RUN pi-valida-movto-uneg IN h-ceapi001k (INPUT TABLE tt-movto-un).
                END.

                RUN pi-execute IN h-ceapi001k (INPUT-OUTPUT TABLE tt-movto,
                                               INPUT-OUTPUT TABLE tt-erro,
                                               INPUT YES).
                DELETE PROCEDURE h-ceapi001k.
            END.

            IF RETURN-VALUE = "NOK":u THEN 
                 ASSIGN ttDocumento.lIntegrar = NO.
            ELSE ASSIGN ttDocumento.lIntegrar = YES.

            /** Guarda o movimento gerado em TT auxiliar 
                para atualizaá∆o posterior **/
            FOR EACH tt-movto NO-LOCK:
                CREATE tt-movto-aux.
                BUFFER-COPY tt-movto TO tt-movto-aux.
            END.

            /** Verifica se existem erros **/
            FOR EACH tt-erro:
                RUN piCriaErro(tt-erro.cd-erro, 'EMS':U, '').
                {utp/ut-liter.i Ficha *}
                ASSIGN RowErrors.ErrorDescription = RETURN-VALUE + ": " + 
                                                    STRING(ttDocumento.num-docto,">>>>>>>>9") + " - " + 
                                                    tt-erro.mensagem
                       ttDocumento.lIntegrar       = NO.
                IF   tt-erro.cd-erro = 1137 THEN DO:
                     ASSIGN RowErrors.ErrorSubType = "ERROR":U.                
                END.
                       
            END.
        END.
    END.
END.

/** Se n∆o retornou erro, ent∆o atualiza documentos **/
RUN piAtualizaDocumento IN THIS-PROCEDURE.

IF CAN-FIND(FIRST RowErrors) THEN
    RETURN "NOK":U.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piValidaInicial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaInicial Procedure 
PROCEDURE piValidaInicial :
/*------------------------------------------------------------------------------
  Purpose:     piValidaInicial
  Parameters:  <none>
  Notes:       Validaá‰es Iniciais para atualizaá‰es de apontamentos
------------------------------------------------------------------------------*/
DEFINE VARIABLE cIni AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFim AS CHARACTER  NO-UNDO.

/** Limpa os erros **/
FOR EACH RowErrors EXCLUSIVE-LOCK:
    DELETE RowErrors.
END.

/*Parametro 11 (ab0101) - Consiste Ficha*/
{utp/ut-liter.i "Abastecimento"}
if not can-find(first mab-param 
                where mab-param.cdn-param = 11 no-lock) then do:
    /** C¢digo deve estar cadastrado **/
    assign cTexto = return-value + '~~' + '11' + '~~' + ' '.
    run piCriaErro (28474, 'EMS':U, cTexto).
end.
else do:
    /** Busca ParÉmetros de Abastecimento **/
    for first mab-param fields(des-valor des-param cdn-param)
        where mab-param.cdn-param = 11 no-lock:
        /** C¢digo deve estar cadastrado **/
        if mab-param.des-valor = "" then do:
            assign cTexto = return-value + '~~' + string(mab-param.cdn-param) + '~~' + mab-param.des-param.
            run piCriaErro (28474, 'EMS':U, cTexto).
        end.
    end.
end.

/*Parametro 8 (ab0116) - Integra com Estoque*/
{utp/ut-liter.i "Integraá∆o"}
if not can-find(first mab-param-integr 
                where mab-param-integr.cdn-param = 8 no-lock) then do:
    /** C¢digo deve estar cadastrado **/
    assign cTexto = return-value + '~~' + '8' + '~~' + ' '.
    run piCriaErro (28474, 'EMS':U, cTexto).
end.
else do:
    /** Busca ParÉmetros de Abastecimento **/
    for first mab-param-integr fields(des-valor des-param cdn-param)
        where mab-param-integr.cdn-param = 8 no-lock:
        /** C¢digo deve estar cadastrado **/
        if mab-param-integr.des-valor = "" then do:
            assign cTexto = return-value + '~~' + string(mab-param-integr.cdn-param) + '~~' + mab-param-integr.des-param.
            run piCriaErro (28474, 'EMS':U, cTexto).
        end.
    end.
end.

/** ParÉmetros n∆o informados **/
if avail tt-param then do:
    /** Data Final maior que atual **/
    if tt-param.dataMovimento > today then do:
        {utp/ut-liter.i "Movimento"}
        assign cIni = return-value.
        {utp/ut-liter.i "Atual"}
        assign cTexto = cIni + '~~' + string(tt-param.dataMovimento,'99/99/9999') + '~~' +
                        return-value + '~~' + string(today,'99/99/9999').
        run piCriaErro (28411, 'EMS':U, cTexto).
    end.
    /** Estabelecimento Inicial menor que final **/
    if tt-param.estabInicial > tt-param.estabFinal then do:
        {utp/ut-liter.i "Estabelecimento Inicial"}
        assign cIni = return-value.
        {utp/ut-liter.i "Estabelecimento Final"}
        assign cFim = return-value.
        assign cTexto = cIni + '~~' + cFim.
        run piCriaErro (1208, 'EMS':U, cTexto).
    end.

    /** Estabelecimento Inicial menor que final **/
    if tt-param.depositoIni > tt-param.depositoFim then do:
        {utp/ut-liter.i "Dep¢sito Inicial"}
        assign cIni = return-value.
        {utp/ut-liter.i "Dep¢sito Final"}
        assign cFim = return-value.
        assign cTexto = cIni + '~~' + cFim.
        run piCriaErro (1208, 'EMS':U, cTexto).
    end.
end.

if can-find(first RowErrors) then
    return "NOK":U.


return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

