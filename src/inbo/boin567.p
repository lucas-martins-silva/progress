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
{include/i-prgvrs.i BOIN567 2.00.00.056 } /*** "010056" 09/06/2026 14:46:46 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin567 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : dbo.p
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
&GLOBAL-DEFINE DBOName BOIN567
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName dupli-imp
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin567.i RowObject}
{inbo/boin567.i tt-dupli-imp-ant}
{inbo/boin567.i tt-dupli-imp-new}

DEFINE NEW GLOBAL SHARED temp-table tt_integr_imptos_pgto_apb no-undo
    field ttv_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_nom_abrev_fornec             as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_des_imposto                  as character format "x(40)" label "Descr  Imposto" column-label "Descriá∆o"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federaá∆oo" column-label "UF"
    field tta_val_aliq_impto               as decimal format ">9.9999" decimals 4 initial 0.00 label "Al°quota" column-label "Aliq"
    field tta_val_imposto                  as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Imposto" column-label "Vl Imposto"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut†vel" column-label "Vl Rendto Tribut"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_log_impto_opcnal             as logical format "Sim/N∆o" initial no label "Imposto Opcional" column-label "Opcional".

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
define buffer b-dupli-imp    for dupli-imp.
define buffer b-docum-est    for docum-est.

def var i-cod-emitente    as int                         no-undo.
def var c-serie-docto     as char                        no-undo.
def var c-nro-docto       as char                        no-undo.
def var c-parcela         as char                        no-undo.
def var c-nat-operacao    as char                        no-undo.

def var c-parcela-ini     as char                        no-undo.
def var c-parcela-fin     as char                        no-undo.
def var i-codImpto-ini    like dupli-imp.int-1           no-undo.
def var i-codImpto-fin    like dupli-imp.int-1           no-undo.

def var l-enable-retencao as log                         no-undo.
def var c-lista-retencao  as char                        no-undo.
def var i-empresa         like param-global.empresa-prin no-undo.
def var h-cd1020          as handle                      no-undo.

DEF VAR l-valida-tipo-tax AS LOG NO-UNDO INIT YES.

{utp/ut-glob.i} /* Definicao variavel i-pais-impto-usuario */

/* define tt-cod-ir */
{cdp/cd8889.i}
run cdp/cd8889.p (output table tt-cod-ir).
{cdp/cd4400.i} /*pi-traduz-empresa-estab-pais*/

/* Automaá∆o das retená‰es no recebimento */
DEF VAR l-dt-venc-imp AS LOG NO-UNDO.

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
         HEIGHT             = 18.67
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDestroy DBOProgram 
PROCEDURE beforeDestroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-cd1020) THEN DO:
        DELETE PROCEDURE h-cd1020.
        ASSIGN h-cd1020 = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findDupliApagar DBOProgram 
PROCEDURE findDupliApagar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piCodEmitente  like dupli-apagar.cod-emitente  no-undo.
    def input param piSerieDocto   like dupli-apagar.serie-docto   no-undo.
    def input param piNroDocto     like dupli-apagar.nro-docto     no-undo.
    def input param piNatOperacao  like dupli-apagar.nat-operacao  no-undo.
    def input param piParcela      like dupli-apagar.parcela       no-undo.
    
    for first dupli-apagar 
        fields ( cod-emitente serie-docto nro-docto nat-operacao
                 parcela ep-codigo cod-estabel dt-emissao dt-trans 
                 dt-vencim vl-a-pagar tp-despesa nr-duplic )
        where dupli-apagar.cod-emitente = piCodEmitente
          and dupli-apagar.serie-docto  = piSerieDocto
          and dupli-apagar.nro-docto    = piNroDocto
          and dupli-apagar.nat-operacao = piNatOperacao
          and dupli-apagar.parcela      = piParcela no-lock.
    end.
    
    if  not avail dupli-apagar then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-table.i movind dupli-apagar 1} /* Busca o label da tabela */
        {method/svc/errors/inserr.i
                           &ErrorNumber="2"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"
                           &ErrorParameters=TRIM(RETURN-VALUE)}
        return "NOK":U.
    end.
    else           
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

    def input param piCodEmitente  like emitente.cod-emitente  no-undo.
    
    if  not avail emitente
    or  emitente.cod-emitente <> piCodEmitente then

        for first  emitente
            where emitente.cod-emitente = piCodEmitente no-lock.
        end.
    
    if  not avail emitente then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-table.i mgadm emitente 1} /* Busca o label da tabela */
        {method/svc/errors/inserr.i
                           &ErrorNumber="2"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"
                           &ErrorParameters=TRIM(RETURN-VALUE)}
        return "NOK":U.
    end.    
    else
        return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findEspecie DBOProgram 
PROCEDURE findEspecie :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piCodEsp  like espec-ap.cod-esp   no-undo.

    if  not avail espec-ap
    or  espec-ap.cod-esp <> piCodEsp then

        for first espec-ap fields ( cod-esp descricao tipo log-1 )
            where espec-ap.cod-esp = piCodEsp no-lock.
        end.
    if  not avail espec-ap then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-table.i mgadm espec-ap 1} /* Busca o label da tabela */
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters=TRIM(RETURN-VALUE)}
        return "NOK":U.
    end.
    else
        return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findEstabelec DBOProgram 
PROCEDURE findEstabelec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piEstab   like docum-est.cod-estabel no-undo.
    
    assign i-empresa = param-global.empresa-prin.

    if  not avail estabelec
    or  estabelec.cod-estabel <> piEstab then 
    
        for first estabelec
            where estabelec.cod-estabel = piEstab no-lock.
        end.
        
    if  not avail estabelec then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-table.i mgadm estabelec 1} /* Busca o label da tabela */
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters=TRIM(RETURN-VALUE)}
        RETURN "NOK":U.
    end.
    else do:
        run cdp/cd9970.p (input rowid(estabelec),
                          output i-empresa).

        RETURN "OK":U.        
    end.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNaturOper DBOProgram 
PROCEDURE findNaturOper :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piNatOperacao  like docum-est.nat-operacao  no-undo.
    
    if  not avail natur-oper
    or  natur-oper.nat-operacao <> piNatOperacao then
    
        for first natur-oper 
            where natur-oper.nat-operacao = piNatOperacao no-lock.
        end.
    
    if  not avail natur-oper then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-table.i mgind natur-oper 1} /* Busca o label da tabela */
        {method/svc/errors/inserr.i
                           &ErrorNumber="2"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"
                           &ErrorParameters=TRIM(RETURN-VALUE)}
        return "NOK":U.
    end.
    else
        return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findParamGlobal DBOProgram 
PROCEDURE findParamGlobal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    for first param-global no-lock.
    end.
    
    if  not avail param-global then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-table.i mgind param-global 1} /* Busca o label da tabela */
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters=TRIM(RETURN-VALUE)}
        return "NOK":U.
    end.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findTipoRecDesp DBOProgram 
PROCEDURE findTipoRecDesp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def input param piTpCodigo  like tipo-rec-desp.tp-codigo  no-undo.
    
    if  not avail tipo-rec-desp
    or  tipo-rec-desp.tp-codigo <> piTpCodigo then

        for first tipo-rec-desp fields ( tp-codigo descricao tipo ) 
            where tipo-rec-desp.tp-codigo = piTpCodigo no-lock.
        end.
    
    if  not avail tipo-rec-desp then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-tipo-receitadespesa AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Tipo_Receita/Despesa" *}
        ASSIGN c-lbl-liter-tipo-receitadespesa = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                           &ErrorNumber="2"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"
                           &ErrorParameters="c-lbl-liter-tipo-receitadespesa"}
        return "NOK":U.
    end.
    else
        return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findTipoTax DBOProgram 
PROCEDURE findTipoTax :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piCodTax  like tipo-tax.cod-tax  no-undo.

    IF  NOT l-valida-tipo-tax THEN
        RETURN "OK":U.

    if  not avail tipo-tax
    or  tipo-tax.cod-tax <> piCodTax then

        for first tipo-tax 
            fields ( cod-tax descricao cod-esp tax-perc tipo cod-classificacao)
            where tipo-tax.cod-tax = piCodTax no-lock.
        end.
   
    if  not avail tipo-tax then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-table.i mgdis tipo-tax 1} /* Busca o label da tabela */
        {method/svc/errors/inserr.i
                           &ErrorNumber="2"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"
                           &ErrorParameters=TRIM(RETURN-VALUE)}
        return "NOK":U.
    end.    
    else
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-esp":U THEN ASSIGN pFieldValue = RowObject.cod-esp.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nr-duplic":U THEN ASSIGN pFieldValue = RowObject.nr-duplic.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "nro-docto-imp":U THEN ASSIGN pFieldValue = RowObject.nro-docto-imp.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
        WHEN "parcela-imp":U THEN ASSIGN pFieldValue = RowObject.parcela-imp.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        WHEN "ind-tipo-imposto":U THEN ASSIGN pFieldValue = RowObject.ind-tipo-imposto.

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-venc-imp":U THEN ASSIGN pFieldValue = RowObject.dt-venc-imp.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "aliquota":U THEN ASSIGN pFieldValue = RowObject.aliquota.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "rend-trib":U THEN ASSIGN pFieldValue = RowObject.rend-trib.
        WHEN "vl-imposto":U THEN ASSIGN pFieldValue = RowObject.vl-imposto.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescriptionFields DBOProgram 
PROCEDURE getDescriptionFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param piFieldName    as char  no-undo.
    def output param piDescription  as char  no-undo.
    
    case piFieldName:
    
         when "c-nome-abrev":U    then assign piDescription = if  avail emitente 
                                                              then emitente.nome-abrev
                                                              else " ".
         when "c-denominacao":U   then assign piDescription = if  avail natur-oper 
                                                              then natur-oper.denominacao
                                                              else " ".
         when "c-desc-imposto":U  then assign piDescription = if  avail tipo-tax 
                                                              then tipo-tax.descricao
                                                              else " ".
         when "c-desc-especie":U  then assign piDescription = if  avail espec-ap
                                                              then espec-ap.descricao
                                                              else " ".
         when "c-desc-despesa":U  then assign piDescription = if  avail tipo-rec-desp
                                                              then tipo-rec-desp.descricao
                                                              else " ".
        otherwise return "NOK":U.
        
    end case.

    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEnableRetencao DBOProgram 
PROCEDURE getEnableRetencao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes: Esta procedure retornar† o estado que deve ser setado no campo cod-retencao
         com base nos dados do RowObject. Dever† ser usada somente na modificaá∆o do
         dupli-imp como Ç o caso do programa re1001c3.w (que chama esta procedure).
------------------------------------------------------------------------------*/
    def output param piEnableRetencao  as log  no-undo.

    run findTipoTax ( RowObject.int-1 ).
    
    if  avail tipo-tax THEN
        run findEspecie ( tipo-tax.cod-esp ).
    
    if  return-value = "NOK":U then
        return "NOK":U.
    assign piEnableRetencao =   avail tipo-tax
                            and (tipo-tax.tipo = 1 OR
                                 tipo-tax.tipo = 3)
                            and avail espec-ap
                            and (   espec-ap.tipo = 8
                                 or (    espec-ap.tipo = 1 
                                     and espec-ap.log-1 )). /* Retencao */
   
               
    /* Variavel utilizada na procedure validateRecord */
    assign l-enable-retencao = piEnableRetencao.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIndTipoImp DBOProgram 
PROCEDURE getIndTipoImp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM piCodEmitente  LIKE dupli-imp.cod-emitente     NO-UNDO.
    DEF INPUT  PARAM piSerieDocto   LIKE dupli-imp.serie-docto      NO-UNDO.
    DEF INPUT  PARAM piNroDocto     LIKE dupli-imp.nro-docto        NO-UNDO.
    DEF INPUT  PARAM piNatOperacao  LIKE dupli-imp.nat-operacao     NO-UNDO.
    DEF INPUT  PARAM piParcela      LIKE dupli-imp.parcela          NO-UNDO.
    DEF INPUT  PARAM piCodImposto   LIKE dupli-imp.int-1            NO-UNDO.
    DEF OUTPUT PARAM pIndTipoImpto  LIKE dupli-imp.ind-tipo-imposto NO-UNDO.

    FOR FIRST b-dupli-imp 
        WHERE b-dupli-imp.cod-emitente = piCodEmitente
          AND b-dupli-imp.serie-docto  = piSerieDocto
          AND b-dupli-imp.nro-docto    = piNroDocto
          AND b-dupli-imp.nat-operacao = piNatOperacao
          AND b-dupli-imp.parcela      = piParcela 
          AND b-dupli-imp.int-1        = piCodImposto NO-LOCK:
        ASSIGN pIndTipoImpto = b-dupli-imp.ind-tipo-imposto.
    END.

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-forn-imp":U THEN ASSIGN pFieldValue = RowObject.cod-forn-imp.
        WHEN "cod-retencao":U THEN ASSIGN pFieldValue = RowObject.cod-retencao.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "tp-codigo":U THEN ASSIGN pFieldValue = RowObject.tp-codigo.
        WHEN "tp-imposto":U THEN ASSIGN pFieldValue = RowObject.tp-imposto.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice dupli-imp
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo parcela
               retorna valor do campo cod-esp
               retorna valor do campo parcela-imp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE dupli-imp.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE dupli-imp.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE dupli-imp.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE dupli-imp.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pparcela LIKE dupli-imp.parcela NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-esp LIKE dupli-imp.cod-esp NO-UNDO.
    DEFINE OUTPUT PARAMETER pparcela-imp LIKE dupli-imp.parcela-imp NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           pparcela = RowObject.parcela
           pcod-esp = RowObject.cod-esp
           pparcela-imp = RowObject.parcela-imp.

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
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getParcelaImposto DBOProgram 
PROCEDURE getParcelaImposto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param piCodEmitente  like docum-est.cod-emitente no-undo.
    def input  param piSerieDocto   like docum-est.serie-docto  no-undo.
    def input  param piNroDocto     like docum-est.nro-docto    no-undo.
    def input  param piNatOperacao  like docum-est.nat-operacao no-undo.
    def input  param piParcela      like dupli-imp.parcela      no-undo.
    def output param piParcelaImp   like dupli-imp.parcela-imp  no-undo.

    def var i-cont-parcela as int init 1 no-undo.

    for each  b-dupli-imp 
        fields( cod-emitente serie-docto nro-docto
                nat-operacao parcela parcela-imp )
        where b-dupli-imp.cod-emitente = piCodEmitente
          and b-dupli-imp.serie-docto  = piSerieDocto
          and b-dupli-imp.nro-docto    = piNroDocto
          and b-dupli-imp.nat-operacao = piNatOperacao
          and b-dupli-imp.parcela      = piParcela no-lock:
          
        /* Calcula n£mero da pr¢xima parcela, sempre sequencial */
        assign i-cont-parcela = i-cont-parcela + 1.
    end.

    assign piParcelaImp = string(i-cont-parcela,"99").
        
    return "OK":U.

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
  Purpose:     Reposiciona registro com base no °ndice dupli-imp
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo parcela
               recebe valor do campo cod-esp
               recebe valor do campo parcela-imp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE dupli-imp.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE dupli-imp.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE dupli-imp.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE dupli-imp.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pparcela LIKE dupli-imp.parcela NO-UNDO.
    DEFINE INPUT PARAMETER pcod-esp LIKE dupli-imp.cod-esp NO-UNDO.
    DEFINE INPUT PARAMETER pparcela-imp LIKE dupli-imp.parcela-imp NO-UNDO.

    FIND FIRST bfdupli-imp WHERE 
        bfdupli-imp.serie-docto = pserie-docto AND 
        bfdupli-imp.nro-docto = pnro-docto AND 
        bfdupli-imp.cod-emitente = pcod-emitente AND 
        bfdupli-imp.nat-operacao = pnat-operacao AND 
        bfdupli-imp.parcela = pparcela AND 
        bfdupli-imp.cod-esp = pcod-esp AND 
        bfdupli-imp.parcela-imp = pparcela-imp NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdupli-imp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdupli-imp)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeFind DBOProgram 
PROCEDURE initializeFind :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    run findParamGlobal.
    
    run findEmitente ( i-cod-emitente ).
    
    run findDupliApagar ( i-cod-emitente,
                          c-serie-docto,
                          c-nro-docto,
                          c-nat-operacao,
                          c-parcela ).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToDupli-Apagar DBOProgram 
PROCEDURE linkToDupli-Apagar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def input param pHandle as handle no-undo.

    run getKey in pHandle (output c-serie-docto,
                           output c-nro-docto,
                           output i-cod-emitente,
                           output c-nat-operacao,
                           output c-parcela).
    return "OK":U.
  
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
  
    open query qr{&tableName} for each {&tableName}
         no-lock
         indexed-reposition.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfDocEstZoom DBOProgram 
PROCEDURE openQueryOfDocEstZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   open query qr{&tableName} for each {&tableName}
        where {&tableName}.cod-emitente = i-cod-emitente
          and {&tableName}.serie-docto  = c-serie-docto
          and {&tableName}.nro-docto    = c-nro-docto
          and {&tableName}.nat-operacao = c-nat-operacao
          and {&tableName}.parcela     >= c-parcela-ini
          and {&tableName}.parcela     <= c-parcela-fin
          and {&tableName}.int-1       >= i-codImpto-ini
          and {&tableName}.int-1       <= i-codImpto-fin
          and ({&tableName}.ind-tipo-imposto = "Imposto de Renda Retido na Fonte":U OR
               {&tableName}.ind-tipo-imposto = "Imposto COFINS  PIS  CSLL Retido":U)
          no-lock indexed-reposition.

   return "OK":U.
            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfDupliApagar DBOProgram 
PROCEDURE openQueryOfDupliApagar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   open query qr{&tableName} for each {&tableName}
        where {&tableName}.cod-emitente = i-cod-emitente
          and {&tableName}.serie-docto  = c-serie-docto
          and {&tableName}.nro-docto    = c-nro-docto
          and {&tableName}.parcela      = c-parcela
          and {&tableName}.nat-operacao = c-nat-operacao
          no-lock
          indexed-reposition.

   return "OK":U.
            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recalculateImposto DBOProgram 
PROCEDURE recalculateImposto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param piAliquota like dupli-imp.aliquota   no-undo.
    def input param piRendTrib like dupli-imp.rend-trib  no-undo.

    if  avail RowObject then 
        assign RowObject.vl-imposto = piRendTrib * (piAliquota / 100).

    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recalculateImposto DBOProgram 
PROCEDURE recalculaDupliImp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p-serie-docto  like dupli-apagar.serie-docto  no-undo.
    def input  param p-nro-docto    like dupli-apagar.nro-docto    no-undo.
    def input  param p-cod-emitente like dupli-apagar.cod-emitente no-undo.
    def input  param p-nat-operacao like dupli-apagar.nat-operacao no-undo.
    def input  param p-parcela      like dupli-apagar.parcela      no-undo.    
    def input  param p-vl-apagar    like dupli-apagar.vl-a-pagar   no-undo.    
    def output param p-recalcula    as   logical                   no-undo.

    DEF VAR h-reapi406 AS HANDLE NO-UNDO.
    DEF VAR h-reapi416 AS HANDLE NO-UNDO.
    DEF VAR h-reapi426 AS HANDLE NO-UNDO.
    
    if not can-find(first bf{&TableName} where 
                          bf{&TableName}.serie-docto  = p-serie-docto  and            
                          bf{&TableName}.nro-docto    = p-nro-docto    and            
                          bf{&TableName}.cod-emitente = p-cod-emitente and            
                          bf{&TableName}.nat-operacao = p-nat-operacao and            
                          bf{&TableName}.parcela      = p-parcela)     then 
       return "OK":U.

    IF NOT VALID-HANDLE(h-reapi406) THEN
        RUN rep/reapi406.p PERSISTENT SET h-reapi406.
    
    IF NOT VALID-HANDLE(h-reapi416) THEN
        RUN rep/reapi416.p PERSISTENT SET h-reapi416.

    IF NOT VALID-HANDLE(h-reapi426) THEN
        RUN rep/reapi426.p PERSISTENT SET h-reapi426.
    
    for each bf{&TableName} where
             bf{&TableName}.serie-docto  = p-serie-docto  and 
             bf{&TableName}.nro-docto    = p-nro-docto    and 
             bf{&TableName}.cod-emitente = p-cod-emitente and 
             bf{&TableName}.nat-operacao = p-nat-operacao and 
             bf{&TableName}.parcela      = p-parcela      exclusive-lock:  

        EMPTY TEMP-TABLE tt-dupli-imp-ant NO-ERROR.
        EMPTY TEMP-TABLE tt-dupli-imp-new NO-ERROR.

        /*REINF*/
        IF bf{&TableName}.ind-tipo-imposto = "Inst Nacional Seguro Social (INSS)":U OR
           bf{&TableName}.ind-tipo-imposto = "GILRAT":U OR
           bf{&TableName}.ind-tipo-imposto = "SENAR":U OR
           bf{&TableName}.ind-tipo-imposto = "Imposto de Renda Retido na Fonte":U   OR 
           bf{&TableName}.ind-tipo-imposto = "Imposto COFINS  PIS  CSLL Retido":U   THEN DO: 
            CREATE tt-dupli-imp-ant.
            BUFFER-COPY bf{&TableName} TO tt-dupli-imp-ant.
        END.

        assign bf{&TableName}.rend-trib  = p-vl-apagar.
               bf{&TableName}.vl-imposto = bf{&TableName}.rend-trib * (bf{&TableName}.aliquota / 100).

        /*REINF*/
        IF bf{&TableName}.ind-tipo-imposto = "Inst Nacional Seguro Social (INSS)":U OR
           bf{&TableName}.ind-tipo-imposto = "GILRAT":U OR
           bf{&TableName}.ind-tipo-imposto = "SENAR":U OR
           bf{&TableName}.ind-tipo-imposto = "Imposto de Renda Retido na Fonte":U   OR 
           bf{&TableName}.ind-tipo-imposto = "Imposto COFINS  PIS  CSLL Retido":U   THEN DO: 
            CREATE tt-dupli-imp-new.
            BUFFER-COPY bf{&TableName} TO tt-dupli-imp-new.
        END.

        IF bf{&TableName}.ind-tipo-imposto = "Inst Nacional Seguro Social (INSS)":U THEN DO:
            RUN updateInfoAdc IN h-reapi406 (INPUT TABLE tt-dupli-imp-ant,
                                             INPUT TABLE tt-dupli-imp-new).
        END.
        ELSE IF (bf{&TableName}.ind-tipo-imposto = "Imposto de Renda Retido na Fonte":U OR 
                 bf{&TableName}.ind-tipo-imposto = "Imposto COFINS  PIS  CSLL Retido":U) THEN DO:
            RUN updateInfoAdc IN h-reapi416 (INPUT TABLE tt-dupli-imp-ant,
                                             INPUT TABLE tt-dupli-imp-new).
        END.
        IF bf{&TableName}.ind-tipo-imposto = "Inst Nacional Seguro Social (INSS)":U OR
           bf{&TableName}.ind-tipo-imposto = "GILRAT":U OR
           bf{&TableName}.ind-tipo-imposto = "SENAR":U THEN DO: 
            RUN updateInfoAdc IN h-reapi426 (INPUT TABLE tt-dupli-imp-ant,
                                             INPUT TABLE tt-dupli-imp-new).
        END.
    end.

    IF VALID-HANDLE(h-reapi406) THEN DO:
        DELETE PROCEDURE h-reapi406.
        ASSIGN h-reapi406 = ?. 
    END.

    IF VALID-HANDLE(h-reapi416) THEN DO:
        DELETE PROCEDURE h-reapi416.
        ASSIGN h-reapi416 = ?. 
    END.
    
    IF VALID-HANDLE(h-reapi426) THEN DO:
        DELETE PROCEDURE h-reapi426.
        ASSIGN h-reapi426 = ?. 
    END.

    assign p-recalcula = yes.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDtVencImp DBOProgram 
PROCEDURE setDtVencImp :
/*------------------------------------------------------------------------------
  Purpose:     seta variavel para gravar ou n∆o a data de vencimento calculada
  Parameters:  pl-dt-venc-imp   
  Notes:       executada pela geraá∆o automatica dos impostos pelo re9343.p
------------------------------------------------------------------------------*/

    def input param pl-dt-venc-imp as log no-undo.

    assign l-dt-venc-imp = pl-dt-venc-imp.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfDocEstZoom DBOProgram 
PROCEDURE setConstraintOfDocEstZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param piCodEmitente  like docum-est.cod-emitente no-undo.
    def input param piSerieDocto   like docum-est.serie-docto  no-undo.
    def input param piNroDocto     like docum-est.nro-docto    no-undo.
    def input param piNatOperacao  like docum-est.nat-operacao no-undo.
    def input param piParcelaini   as int format 99            no-undo.
    def input param piParcelafin   as int format 99            no-undo.
    def input param piCodImptoini  like dupli-imp.int-1        no-undo.
    def input param piCodImptofin  like dupli-imp.int-1        no-undo.

    assign i-cod-emitente = piCodEmitente
           c-serie-docto  = piSerieDocto
           c-nro-docto    = piNroDocto           
           c-nat-operacao = piNatOperacao
           c-parcela-ini  = string(piParcelaini,"99")
           c-parcela-fin  = string(piParcelafin,"99") 
           i-codImpto-ini = piCodImptoini
           i-codImpto-fin = piCodImptofin.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfDupliApagar DBOProgram 
PROCEDURE setConstraintOfDupliApagar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param piCodEmitente  like docum-est.cod-emitente no-undo.
    def input  param piSerieDocto   like docum-est.serie-docto  no-undo.
    def input  param piNroDocto     like docum-est.nro-docto    no-undo.
    def input  param piNatOperacao  like docum-est.nat-operacao no-undo.
    def input  param piParcela      like dupli-imp.parcela      no-undo.

    assign i-cod-emitente = piCodEmitente
           c-serie-docto  = piSerieDocto
           c-nro-docto    = piNroDocto           
           c-nat-operacao = piNatOperacao
           c-parcela      = piParcela.
     
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaults DBOProgram 
PROCEDURE setDefaults :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var l-erro       as log   no-undo.
    def var da-venc-imp  as date  no-undo.
	def var c-ind-tip-impto as char no-undo.
    DEF VAR c-pais        LIKE docum-est.pais        NO-UNDO.
    DEF VAR c-cod-estabel LIKE docum-est.cod-estabel NO-UNDO.
    DEF VAR c-cod-empresa LIKE estabelec.ep-codigo   NO-UNDO.

    IF NOT VALID-HANDLE(h-cd1020) 
        OR (VALID-HANDLE(h-cd1020) AND h-cd1020:FILE-NAME <> "cdp/cd1020.p":U) THEN
        RUN cdp/cd1020.p PERSISTENT SET h-cd1020. /* Calculo Data Vencto Imposto */

    run findTipoTax ( RowObject.int-1 ).

    if  return-value = "NOK":U then
        return "NOK":U.
        
    assign RowObject.cod-esp      = if  RowObject.cod-esp = "" 
                                    AND AVAIL tipo-tax
                                    then tipo-tax.cod-esp
                                    else RowObject.cod-esp
           RowObject.cod-retencao = if  RowObject.cod-retencao = 0
                                    AND AVAIL tipo-tax
                                    then tipo-tax.cod-classificacao
                                    else RowObject.cod-retencao
           da-venc-imp            = if  avail dupli-apagar 
                                    then dupli-apagar.dt-vencim
                                    else ?.

    run findEspecie ( RowObject.cod-esp ).

    if  return-value = "NOK":U then
        return "NOK":U.

    IF NOT AVAIL dupli-apagar THEN
        run findDupliApagar ( RowObject.cod-emitente,
                              RowObject.serie-docto ,
                              RowObject.nro-docto   ,
                              RowObject.nat-operacao,
                              RowObject.parcela).

    if  return-value = "NOK":U then
        return "NOK":U.
    
    IF  AVAIL tipo-tax THEN
        RUN CalculateDtVenctoImposto IN h-cd1020 ( INPUT dupli-apagar.ep-codigo   ,
                                                   INPUT dupli-apagar.cod-estabel ,
                                                   INPUT dupli-apagar.cod-emitente,
                                                   INPUT dupli-apagar.dt-trans    ,
                                                   INPUT dupli-apagar.dt-emissao    ,
                                                   INPUT dupli-apagar.dt-vencim   ,
                                                   INPUT espec-ap.tipo            ,
                                                   INPUT tipo-tax.cod-tax         ,
                                                   OUTPUT l-erro                  ,
                                                   OUTPUT da-venc-imp ).

    if  l-erro then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-data-vencimento-imposto AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "data_vencimento_imposto" *}
        ASSIGN c-lbl-liter-data-vencimento-imposto = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-calendario-comercial AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Calend†rio_Comercial" *}
        ASSIGN c-lbl-liter-calendario-comercial = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                           &ErrorNumber="30124"
                           &ErrorType="EMS":U
                           &ErrorSubType="WARNING":U
                           &ErrorParameters="c-lbl-liter-data-vencimento-imposto + '~~~~' + c-lbl-liter-calendario-comercial"}
    end.

    IF  RowObject.aliquota = 0  THEN
        assign RowObject.aliquota    = tipo-tax.tax-perc WHEN AVAIL tipo-tax.

    if not l-dt-venc-imp then
       assign RowObject.dt-venc-imp = da-venc-imp.

    if  avail dupli-apagar then do:

        // Se for IR e o valor do imposto estiver zerado, a al°quota deve ser zerada tambÇm para n∆o ocorrer rec†lculo indevido do imposto
		IF RowObject.ind-tipo-imposto = "Imposto de Renda Retido na Fonte":U AND
           RowObject.vl-imposto       = 0 THEN
		    ASSIGN RowObject.aliquota = 0.

        IF RowObject.vl-imposto = 0 THEN
            assign RowObject.rend-trib  = dupli-apagar.vl-a-pagar
                   RowObject.vl-imposto = dupli-apagar.vl-a-pagar * (RowObject.aliquota / 100).

        ASSIGN RowObject.tp-codigo  = dupli-apagar.tp-despesa.
               
        if RowObject.nro-docto-imp = "" then 
            assign RowObject.nro-docto-imp = dupli-apagar.nr-duplic.
            
        if  substr(RowObject.char-1,1,5) = "" then do:
            IF AVAIL tipo-tax AND tipo-tax.serie <> "" THEN
                ASSIGN OVERLAY(RowObject.char-1,1,5) = tipo-tax.serie.
            ELSE
                assign OVERLAY(RowObject.char-1,1,5) = dupli-apagar.serie-docto.
        END.
    end. 

    if RowObject.ind-tipo-imposto = "":u then do:

        for first b-docum-est fields (cod-estabel pais)
            where b-docum-est.cod-emitente = RowObject.cod-emitente
              and b-docum-est.serie-docto  = RowObject.serie-docto
              and b-docum-est.nro-docto    = RowObject.nro-docto
              and b-docum-est.nat-operacao = RowObject.nat-operacao no-lock:
            ASSIGN c-pais        = b-docum-est.pais
                   c-cod-estabel = b-docum-est.cod-estabel.
        end.

        /* Removido clausula FIELDS (ep-codigo)*/
        for first estabelec no-lock
            where estabelec.cod-estabel = c-cod-estabel:
            assign c-cod-empresa = estabelec.ep-codigo.
        end.

        run pi-traduz-empresa-estab-pais (input-output c-cod-empresa,
                                          input-output c-cod-estabel,
                                          input-output c-pais).     

        RUN buscaTipoImposto in this-procedure(INPUT c-pais,
                                               INPUT "",
                                               INPUT RowObject.int-1,
                                               INPUT RowObject.cod-retencao,
                                               OUTPUT c-ind-tip-impto).

		assign RowObject.ind-tipo-imposto = c-ind-tip-impto.								   
										
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDtVencto DBOProgram 
PROCEDURE validateDtVencto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        
    if  avail dupli-apagar 
    and RowObject.dt-venc-imp < dupli-apagar.dt-emissao then do:
        /* Data de vencimento menor que data de emiss∆o */
        {method/svc/errors/inserr.i
                            &ErrorNumber="634"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="string(RowObject.dt-venc-imp)"}
    end.  

    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDuplicata DBOProgram 
PROCEDURE validateDuplicata :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if  not avail RowObject then
        return "NOK":U.
        
    for first b-dupli-imp 
        fields ( cod-emitente serie-docto nro-docto
                 nat-operacao parcela     cod-esp )           
        where b-dupli-imp.cod-emitente = RowObject.cod-emitente
          and b-dupli-imp.serie-docto  = RowObject.serie-docto
          and b-dupli-imp.nro-docto    = RowObject.nro-docto
          and b-dupli-imp.nat-operacao = RowObject.nat-operacao
          and b-dupli-imp.parcela      = RowObject.parcela
          and b-dupli-imp.cod-esp      = RowObject.cod-esp
          and b-dupli-imp.parcela-imp  = RowObject.parcela-imp
         no-lock.
    end.
     
    if  avail b-dupli-imp then do:
        /* Ja existe ocorrencia em Impostos da duplicata com a chave informada */
        /* Inicio -- Projeto Internacional */
        {utp/ut-table.i movind dupli-imp 1} /* Busca o label da tabela */
        {method/svc/errors/inserr.i
                           &ErrorNumber="7"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"
                           &ErrorParameters=TRIM(RETURN-VALUE)}
    end.
    

    for first b-dupli-imp 
        fields ( cod-emitente serie-docto nro-docto
                 nat-operacao parcela     cod-esp )           
        where b-dupli-imp.cod-emitente = RowObject.cod-emitente
          and b-dupli-imp.serie-docto  = RowObject.serie-docto
          and b-dupli-imp.nro-docto    = RowObject.nro-docto
          and b-dupli-imp.nat-operacao = RowObject.nat-operacao
          and b-dupli-imp.parcela      = RowObject.parcela
          and b-dupli-imp.cod-esp      = RowObject.cod-esp
          AND b-dupli-imp.cod-retencao = rowObject.cod-retencao
         no-lock.
    end.


    for first lin-i-ap 
        fields ( ep-codigo cod-estabel cod-fornec 
                 cod-esp serie nr-docto parcela )
        where lin-i-ap.ep-codigo   = i-empresa
          and lin-i-ap.cod-estabel = dupli-apagar.cod-estabel
          and lin-i-ap.cod-fornec  = dupli-apagar.cod-emitente
          and lin-i-ap.cod-esp     = RowObject.cod-esp
          and lin-i-ap.serie       = substr(RowObject.char-1,1,5)
          and lin-i-ap.nr-docto    = RowObject.nro-docto-imp
          and lin-i-ap.parcela     = RowObject.parcela-imp  no-lock.
    end.
        
    if  avail lin-i-ap then do:
        /* Titulos no contas a pagar nao foram atualizados */
        {method/svc/errors/inserr.i
                            &ErrorNumber="5402"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"}
    end.
    
    for first tit-ap 
        fields ( ep-codigo cod-estabel cod-fornec 
                 cod-esp serie nr-docto parcela )
        where tit-ap.ep-codigo   = i-empresa
          and tit-ap.cod-estabel = dupli-apagar.cod-estabel
          and tit-ap.cod-fornec  = dupli-apagar.cod-emitente
          and tit-ap.cod-esp     = RowObject.cod-esp
          and tit-ap.serie       = substr(RowObject.char-1,1,5)
          and tit-ap.nr-docto    = RowObject.nro-docto-imp
          and tit-ap.parcela     = RowObject.parcela-imp  no-lock.
    end.                                                      
    
    if  avail tit-ap then do:
        /* Titulo ja existe no contas a pagar */
        {method/svc/errors/inserr.i
                            &ErrorNumber="17507"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"}
    end.

    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateImposto DBOProgram 
PROCEDURE validateImposto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piCodTax  like tipo-tax.cod-tax  no-undo.
    def input param piCodEsp  like espec-ap.cod-esp  no-undo.
    
    run findTipoTax ( piCodTax ).

    run findEspecie ( piCodEsp ).

    /*--- Tipo de Imposto deve ser Retencao 
          ou do Tipo Taxado ---*/
    if  avail tipo-tax
    and tipo-tax.tipo = 2 then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-ou-do-tipo-taxado AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "ou_do_Tipo_Taxado" *}
        ASSIGN c-lbl-liter-ou-do-tipo-taxado = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="7267"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="c-lbl-liter-ou-do-tipo-taxado"}
    end.    
  
    /*--- Se a especie for normal a mesma devera ser de retencao (INSS) ---*/
    if  avail espec-ap 
    and espec-ap.tipo  = 1 
    and not espec-ap.log-1 then do:
        {method/svc/errors/inserr.i
                            &ErrorNumber="17369"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="string(RowObject.cod-esp)"}
    end.
  
    if  avail tipo-tax 
    and avail espec-ap
    and tipo-tax.tipo = 1 then    /* Imposto do Tipo Retencao */

        if  ( espec-ap.log-1     and espec-ap.tipo <> 1 )      /* Especie INSS com tipo diferenre de Normal */
        or  ( not espec-ap.log-1 and espec-ap.tipo <> 8 ) then /* Nao e INSS com tipo diferente de Retencao */
        do:
            {method/svc/errors/inserr.i
                                &ErrorNumber="17368"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="string(RowObject.cod-esp)"}
        end.
  
    if  avail tipo-tax
    and avail espec-ap 
    and tipo-tax.tipo = 3 then   /* Imposto do Tipo Taxado */

        if  espec-ap.tipo <> 1            /* Especie com tipo diferente de Normal */ 
        or  NOT espec-ap.log-1     then do:   /* Especie INSS nao marcada como Retencao */
            {method/svc/errors/inserr.i
                                &ErrorNumber="17369"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="string(RowObject.cod-esp)"}
        end.    
        
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
        
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/

    for first b-docum-est
        fields ( cod-emitente serie-docto nro-docto nat-operacao ce-atual cod-estabel)
        where b-docum-est.cod-emitente = RowObject.cod-emitente
          and b-docum-est.serie-docto  = RowObject.serie-docto
          and b-docum-est.nro-docto    = RowObject.nro-docto
          and b-docum-est.nat-operacao = RowObject.nat-operacao no-lock: end.

    if  avail b-docum-est
    and b-docum-est.ce-atual then do:
        {method/svc/errors/inserr.i
                    &ErrorNumber="19515" /*Nota fiscal j† atualizada*/
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" }
    end.

    if  pType <> "Delete":U then do:
   
        run findParamGlobal.
        
        run findEstabelec ( b-docum-est.cod-estabel ).
        
        run findDupliApagar ( RowObject.cod-emitente,
                              RowObject.serie-docto,
                              RowObject.nro-docto,
                              RowObject.nat-operacao,
                              RowObject.parcela ).
        
        if  return-value = "NOK":U then
            return "NOK":U.
        
        /*if  pType = "Update":U then do:*/
        RUN getEnableRetencao (OUTPUT l-enable-retencao).
        IF NOT l-enable-retencao AND l-valida-tipo-tax THEN ASSIGN RowObject.cod-retencao = 0.
        if  return-value = "NOK":U then
            return "NOK":U.
        /*END.*/

        if  pType = "Create":U then do:
    
            /* Seta Defaults para os dados que nao foram pedidos em tela. */
            run setDefaults.
       
            if  return-value = "NOK":U then
                return "NOK":U.
             
            run validateDuplicata.
    
            run validateImposto ( RowObject.int-1,   /* Codigo Imposto */
                                  RowObject.cod-esp ).
        end.
      
        /*--- Valida Serie do Documento ---*/
        if  substr(RowObject.char-1,1,5) <> "" then do:
            find first serie
                where serie.serie = substr(RowObject.char-1,1,5) no-lock no-error.
    
            if  not avail serie then do:
                /* Serie invalida */
                {method/svc/errors/inserr.i
                                    &ErrorNumber="1116"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"}
            end.
        end.
        
        run findTipoRecDesp ( RowObject.tp-codigo ).
            
        if  avail tipo-rec-desp 
        and tipo-rec-desp.tipo = 1 then do:
            /* Tipo despesa invalido */
            {method/svc/errors/inserr.i
                                &ErrorNumber="4995"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"}
        end.
      
        run validateDtVencto.

        /*if  RowObject.vl-imposto = 0 then do:
            /* Valor do imposto deve ser diferente de zero */
            {method/svc/errors/inserr.i
                                &ErrorNumber="4199"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"}
        end. 
            
        if  RowObject.aliquota = 0 then do:
            /* Aliquota nao pode ser zero */
            {method/svc/errors/inserr.i
                                &ErrorNumber="1074"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"}
        end. */

        FIND FIRST tt_integr_imptos_pgto_apb 
             WHERE tt_integr_imptos_pgto_apb.tta_cod_imposto       = STRING(rowObject.int-1)
               AND tt_integr_imptos_pgto_apb.tta_cod_classif_impto = string(RowObject.cod-retencao,"9999") NO-ERROR.

        find first tt-cod-ir
             where tt-cod-ir.c-cod = string(RowObject.cod-retencao,"9999")
             no-lock no-error.

        if  not avail tt-cod-ir and
            NOT AVAIL tt_integr_imptos_pgto_apb AND
            l-enable-retencao = yes THEN DO:      
           /* Tipo de rendimento invalido. */
            {method/svc/errors/inserr.i
                              &ErrorNumber="843"
                              &ErrorType="EMS"
                              &ErrorSubType="Warning":U
                              &ErrorParameters="string(RowObject.cod-retencao)"}
        end.

        if  avail dupli-apagar
        and (   RowObject.vl-imposto > RowObject.rend-trib
             or RowObject.vl-imposto > dupli-apagar.vl-a-pagar ) then
        do:
            /* Valor do imposto nao pode ser maior que a base de calculo */
            {method/svc/errors/inserr.i
                                &ErrorNumber="15972"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"}
        end.
    end.
    
    /*--- Verifica ocorrància de erros ---*/
    IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaTipoTax DBOProgram 
PROCEDURE validaTipoTax :
/*------------------------------------------------------------------------------
  Purpose:     Verificar se deve validar se o imposto est† cadastrado na tabela 
               tipo-tax (cd0182). No projeto de melhorias nos impostos retidos
               (IRM1564) foi dispensado o cadastro do imposto no EMS 2 (cd0182), 
               portanto nao deve ser mais validado contra a tabela tipo-tax.
  Parameters:  pl-valida-tipo-tax: indica se deve validar a tipo-tax.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pl-valida-tipo-tax AS LOG NO-UNDO.

    ASSIGN l-valida-tipo-tax = pl-valida-tipo-tax.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE aftercreateRecord DBOProgram 
PROCEDURE aftercreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE h-reapi406 AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-reapi416 AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-reapi426 AS HANDLE NO-UNDO.

    IF RowObject.ind-tipo-imposto = "Inst Nacional Seguro Social (INSS)":U OR 
       RowObject.ind-tipo-imposto = "GILRAT":U OR
       RowObject.ind-tipo-imposto = "SENAR":U  THEN DO:

        IF RowObject.ind-tipo-imposto = "Inst Nacional Seguro Social (INSS)" THEN DO:
            IF NOT VALID-HANDLE(h-reapi406) THEN
                RUN rep/reapi406.p PERSISTENT SET h-reapi406.
    
            RUN createInfoAdc IN h-reapi406 (INPUT TABLE RowObject).
    
            IF VALID-HANDLE(h-reapi406) THEN DO:
                DELETE PROCEDURE h-reapi406.
                ASSIGN h-reapi406 = ?. 
            END.
        END.

        IF NOT VALID-HANDLE(h-reapi426) THEN
            RUN rep/reapi426.p PERSISTENT SET h-reapi426.

        RUN createInfoAdc IN h-reapi426 (INPUT TABLE RowObject).

        IF VALID-HANDLE(h-reapi426) THEN DO:
            DELETE PROCEDURE h-reapi426.
            ASSIGN h-reapi426 = ?. 
        END.
    END.
    ELSE IF RowObject.ind-tipo-imposto = "Imposto de Renda Retido na Fonte":U OR 
            RowObject.ind-tipo-imposto = "Imposto COFINS  PIS  CSLL Retido":U THEN DO:

        IF NOT VALID-HANDLE(h-reapi416) THEN
            RUN rep/reapi416.p PERSISTENT SET h-reapi416.

        RUN createInfoAdc IN h-reapi416 (INPUT TABLE RowObject).

        IF VALID-HANDLE(h-reapi416) THEN DO:
            DELETE PROCEDURE h-reapi416.
            ASSIGN h-reapi416 = ?. 
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeupdateRecord DBOProgram 
PROCEDURE beforeupdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
------------------------------------------------------------------------------*/
    
    DEFINE BUFFER bf2dupli-imp FOR {&TableName}.
    EMPTY TEMP-TABLE tt-dupli-imp-ant NO-ERROR.

    /*REINF sÛ existe para INSS*/
    IF RowObject.ind-tipo-imposto = "Inst Nacional Seguro Social (INSS)":U OR
       RowObject.ind-tipo-imposto = "Imposto de Renda Retido na Fonte":U   OR 
       RowObject.ind-tipo-imposto = "Imposto COFINS  PIS  CSLL Retido":U   THEN DO: 
        FOR FIRST bf2dupli-imp NO-LOCK
            WHERE bf2dupli-imp.serie-docto  = RowObject.serie-docto 
              AND bf2dupli-imp.nro-docto    = RowObject.nro-docto   
              AND bf2dupli-imp.cod-emitente = RowObject.cod-emitente 
              AND bf2dupli-imp.nat-operacao = RowObject.nat-operacao 
              AND bf2dupli-imp.parcela      = RowObject.parcela     
              AND bf2dupli-imp.cod-esp      = RowObject.cod-esp     
              AND bf2dupli-imp.parcela-imp  = RowObject.parcela-imp:

            CREATE tt-dupli-imp-ant.
            BUFFER-COPY bf2dupli-imp TO tt-dupli-imp-ant.
    
        END.

    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterupdateRecord DBOProgram 
PROCEDURE afterupdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE h-reapi406 AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-reapi416 AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-reapi426 AS HANDLE NO-UNDO.

    IF RowObject.ind-tipo-imposto = "Inst Nacional Seguro Social (INSS)":U OR 
       RowObject.ind-tipo-imposto = "GILRAT":U OR
       RowObject.ind-tipo-imposto = "SENAR":U  THEN DO:

        IF RowObject.ind-tipo-imposto = "Inst Nacional Seguro Social (INSS)" THEN DO: /* INSS */
            IF NOT VALID-HANDLE(h-reapi406) THEN
                RUN rep/reapi406.p PERSISTENT SET h-reapi406.
    
            RUN updateInfoAdc IN h-reapi406 (INPUT TABLE tt-dupli-imp-ant,
                                             INPUT TABLE RowObject).
    
            IF VALID-HANDLE(h-reapi406) THEN DO:
                DELETE PROCEDURE h-reapi406.
                ASSIGN h-reapi406 = ?. 
            END.
        END.

        IF NOT VALID-HANDLE(h-reapi426) THEN
            RUN rep/reapi426.p PERSISTENT SET h-reapi426.

        RUN updateInfoAdc IN h-reapi426 (INPUT TABLE tt-dupli-imp-ant,
                                         INPUT TABLE RowObject).

        IF VALID-HANDLE(h-reapi426) THEN DO:
            DELETE PROCEDURE h-reapi426.
            ASSIGN h-reapi426 = ?. 
        END.
    END.
    ELSE IF RowObject.ind-tipo-imposto = "Imposto de Renda Retido na Fonte":U OR 
            RowObject.ind-tipo-imposto = "Imposto COFINS  PIS  CSLL Retido":U THEN DO:

        IF NOT VALID-HANDLE(h-reapi416) THEN
            RUN rep/reapi416.p PERSISTENT SET h-reapi416.

        RUN updateInfoAdc IN h-reapi416 (INPUT TABLE tt-dupli-imp-ant,
                                         INPUT TABLE RowObject).

        IF VALID-HANDLE(h-reapi416) THEN DO:
            DELETE PROCEDURE h-reapi416.
            ASSIGN h-reapi416 = ?. 
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterdeleteRecord DBOProgram 
PROCEDURE afterdeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE h-reapi406 AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-reapi416 AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-reapi426 AS HANDLE NO-UNDO.

    IF RowObject.ind-tipo-imposto = "Inst Nacional Seguro Social (INSS)":U OR 
       RowObject.ind-tipo-imposto = "GILRAT":U OR
       RowObject.ind-tipo-imposto = "SENAR":U  THEN DO:
    
        IF RowObject.ind-tipo-imposto = "Inst Nacional Seguro Social (INSS)" THEN DO:
            IF NOT VALID-HANDLE(h-reapi406) THEN
                RUN rep/reapi406.p PERSISTENT SET h-reapi406.
    
            RUN deleteInfoAdc IN h-reapi406 (INPUT TABLE RowObject).
    
            IF VALID-HANDLE(h-reapi406) THEN DO:
                DELETE PROCEDURE h-reapi406.
                ASSIGN h-reapi406 = ?. 
            END.
        END.

        IF NOT VALID-HANDLE(h-reapi426) THEN
            RUN rep/reapi426.p PERSISTENT SET h-reapi426.

        RUN deleteInfoAdc IN h-reapi426 (INPUT TABLE RowObject).

        IF VALID-HANDLE(h-reapi426) THEN DO:
            DELETE PROCEDURE h-reapi426.
            ASSIGN h-reapi426 = ?. 
        END.
    END.
    ELSE IF RowObject.ind-tipo-imposto = "Imposto de Renda Retido na Fonte":U OR 
        RowObject.ind-tipo-imposto = "Imposto COFINS  PIS  CSLL Retido":U THEN DO:

        IF NOT VALID-HANDLE(h-reapi416) THEN
            RUN rep/reapi416.p PERSISTENT SET h-reapi416.

        RUN deleteInfoAdc IN h-reapi416 (INPUT TABLE RowObject).

        IF VALID-HANDLE(h-reapi416) THEN DO:
            DELETE PROCEDURE h-reapi416.
            ASSIGN h-reapi406 = ?. 
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaTipoImposto DBOProgram 
PROCEDURE buscaTipoImposto :
/*------------------------------------------------------------------------------
  Purpose: salvar o tipo de imposto cadastrado no EMS5    
  Parameters:  
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-pais           AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM p-uf             AS CHARACTER NO-UNDO.   
	DEFINE INPUT PARAM p-cod-imposto    AS INTEGER   NO-UNDO.
	DEFINE INPUT PARAM p-cod-retencao   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAM p-ind-tip-impto AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE h-dbo-imposto       AS HANDLE   NO-UNDO.
    DEFINE VARIABLE h-reg-imposto       AS HANDLE   NO-UNDO.
    DEFINE VARIABLE hCampoDBO           AS HANDLE   NO-UNDO.
    DEFINE VARIABLE h-dbo-classif-impto AS HANDLE  NO-UNDO.
    DEFINE VARIABLE lGILRAT             AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lSENAR              AS LOGICAL NO-UNDO.
    
	assign  p-uf   = "".
		   
    IF  NOT VALID-HANDLE(h-dbo-imposto) THEN
        RUN prgint/utb/utb944wb.py PERSISTENT SET h-dbo-imposto NO-ERROR.

    IF VALID-HANDLE(h-dbo-imposto) THEN DO:

        /*--- monta a query  ---*/
        RUN setQueryWhere IN h-dbo-imposto  ( "imposto.cod_pais            = '":U + STRING(p-pais)        + "'":U +
                                            " AND imposto.cod_unid_federac = '":U + STRING(p-uf)          + "'":U +
                                            " AND imposto.cod_imposto      = '":U + STRING(p-cod-imposto) + "'":U). /*cod-imposto*/

        /*--- abre a query dinamica e posiciona no primeiro registro ---*/
        RUN openQueryDynamic IN h-dbo-imposto.
    
        /*RUN pi_reposition_record IN h-dbo-imposto (INPUT v_rec_imposto).*/
        RUN getFirst IN h-dbo-imposto.

        /*--- busca handle do registro para ler os dados da tabela impostos (ems5) ---*/
        RUN getRecordInHandle IN h-dbo-imposto(OUTPUT h-reg-imposto).
    
        /* busca o tipo de imposto para eSocial */
        ASSIGN hCampoDBO       = h-reg-imposto:BUFFER-FIELD("ind_tip_impto":U)
               p-ind-tip-impto = hCampoDBO:BUFFER-VALUE NO-ERROR.
    END.
    
   IF p-ind-tip-impto = "Inst Nacional Seguro Social (INSS)" THEN DO:
     
      RUN prgint/utb/utb944wc.py PERSISTENT SET h-dbo-classif-impto NO-ERROR.
    
      
      RUN setQueryWhere IN h-dbo-classif-impto ("classif_impto.cod_imposto = '":U + STRING(p-cod-imposto)                   + "'":U + /*c¢digo do imposto*/
                                                " and classif_impto.cod_classif_impto = '":U + STRING(p-cod-retencao) + "'":U +  /*dupli-imp.cod-retencao*/
                                                " and classif_impto.cod_pais = '":U + STRING(p-pais)                          + "'":U +      
                                                " and classif_impto.cod_unid_federac = '":U + STRING(p-uf)                + "'":U).
      RUN openQueryDynamic IN h-dbo-classif-impto.
      RUN getFirst IN h-dbo-classif-impto.
    
      RUN getRecordInHandle IN h-dbo-classif-impto(OUTPUT h-reg-imposto).
      
      ASSIGN hCampoDBO = h-reg-imposto:BUFFER-FIELD("log_gilrat":U)
             lGILRAT   = hCampoDBO:BUFFER-VALUE NO-ERROR.
              
      ASSIGN hCampoDBO = h-reg-imposto:BUFFER-FIELD("log_senar":U)
            lSENAR    = hCampoDBO:BUFFER-VALUE NO-ERROR.

      IF lGILRAT THEN DO: 
          ASSIGN p-ind-tip-impto = "GILRAT":U.
      END.

      IF lSENAR THEN DO:
          ASSIGN p-ind-tip-impto = "SENAR":U.
      END.

    END. /*fim if*/
	
    IF VALID-HANDLE(h-dbo-imposto) THEN DO:
        DELETE PROCEDURE h-dbo-imposto.
        ASSIGN h-dbo-imposto = ?.
    END.
	
	DELETE PROCEDURE h-dbo-classif-impto NO-ERROR.
    ASSIGN h-dbo-classif-impto = ? NO-ERROR.
	
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
