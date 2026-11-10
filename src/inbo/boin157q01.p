&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram
/*********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN157Q01 2.00.00.058 } /*** "010058" 17/06/2025 16:40:46 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN157Q01 MUT}
&ENDIF


/*--------------------------------------------------------------------------
    File       : boin157q01.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      : Alterado no cadastro de mensagens o campo tipo-msg:
                 De 1 (erro) para 2 (advertància)
                    - 7337; 45
                    55

  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName inventario
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName inventario
&GLOBAL-DEFINE TableLabel inventario
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{inbo/boin157q01.i RowObject}

/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/ 
&Scoped-define SECOND-TABLE-IN-QUERY-{&QueryName} item
&Scoped-define REPOSITION-PROCEDURE-KEY-PHRASE TRUE NO-LOCK, ~
     FIRST item WHERE item.it-codigo  = {&tablename}.it-codigo NO-LOCK

{include/i-estab-security.i}
/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/

/* ContÇm prÇ-processor que identica se o programa est† sendo executado na Grendene */
{cdp/cdcfgren.i}

{utp/ut-glob.i}

/* Temp-table contendo registros selecionados no browser de digitaá∆o do invent†rio */
DEFINE TEMP-TABLE ttInventario NO-UNDO
       FIELD lote          LIKE inventario.lote
       FIELD cod-refer     LIKE saldo-estoq.cod-refer
       FIELD val-apurado-1 AS DECIMAL FORMAT ">>>>,>>>,>>9.99"
       FIELD val-apurado-2 AS DECIMAL FORMAT ">>>>,>>>,>>9.99"
       FIELD val-apurado-3 AS DECIMAL FORMAT ">>>>,>>>,>>9.99"
       FIELD valor-mat     LIKE inventario.valor-mat-m[1]
       FIELD valor-ggf     LIKE inventario.valor-ggf-m[1]
       FIELD valor-mob     LIKE inventario.valor-mob-m[1]
       FIELD dt-val-lote   LIKE inventario.dt-ult-entra
       FIELD r-rowid       AS ROWID.

/* Definiá∆o de temp-table de erro. Utilizada no browser pois temp-table rowErrors s¢ armazena um registro 
   em cada iteraá∆o */
DEFINE TEMP-TABLE BrowserErrors NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
/* {method/dboqry.i} */
/*DEFINE QUERY {&QueryName} FOR {&TableName}, item SCROLLING. */

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER b-movto        FOR movto-estoq.
DEFINE BUFFER c-movto        FOR movto-estoq.
DEFINE BUFFER b-saldo        FOR saldo-estoq.
DEFINE BUFFER b-invent       FOR inventario.
DEFINE BUFFER b-inventario   FOR inventario.

/************* Multiplanta ********************/
DEFINE VARIABLE i-tipo-movto AS INTEGER NO-UNDO.
{cdp/cd7300.i1}

{mcinc/mcapi281.i}
/* def temp-table tt-dados-env-SMC     like tt-dados-env. */
/* def temp-table tt-replica-msg-SMC   like tt-replica-msg. */
/* def temp-table tt-control-env-SMC   like tt-control-env. */
/* def temp-table tt-integracao-SMC    like tt-integracao. */
/************Fim*****************************/
{cdp/cdcfgmat.i}

/* Vari†veis */
DEFINE VARIABLE da-dt-saldo       AS DATE      NO-UNDO.
DEFINE VARIABLE c-cod-estabel-ini AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-estabel-fim AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-fm-codigo-ini   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-fm-codigo-fim   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-depos-ini   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-depos-fim   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-localiz-ini AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-localiz-fim AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lote-ini        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lote-fim        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-it-codigo-ini   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-it-codigo-fim   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-refer-ini   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-refer-fim   AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-ge-codigo-ini   AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-ge-codigo-fim   AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-nr-ficha-ini    AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-nr-ficha-fim    AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-classificacao   AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-contagem        AS INTEGER   NO-UNDO.
DEFINE VARIABLE l-nao-digitada    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-ok-atualizar    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-atualizada      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-digitada        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-inventariada    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-conf-obsoleto   AS LOGICAL   NO-UNDO.

DEFINE VARIABLE l-loc-unica-mult  AS LOG INIT NO NO-UNDO.

DEFINE VARIABLE l-valid-values    AS LOG INIT YES NO-UNDO.

DEFINE VARIABLE iNumOldFicha      AS INTEGER NO-UNDO.
DEFINE VARIABLE iNumNewFicha      LIKE inventario.nr-ficha  NO-UNDO.
DEFINE VARIABLE i-dif             AS INTEGER  NO-UNDO.

DEF TEMP-TABLE tt-inventario-tela NO-UNDO
      FIELD nr-ficha    like inventario.nr-ficha
      FIELD cod-estabel like inventario.cod-estabel
      FIELD it-codigo   like inventario.it-codigo
      FIELD lote        like inventario.lote
      FIELD cod-refer   like inventario.cod-refer
      FIELD cod-depos   like inventario.cod-depos
      FIELD cod-localiz like inventario.cod-localiz
      FIELD val-apurado like inventario.val-apurado[1]
      FIELD valor-mat   like inventario.valor-mat-m[1]
      FIELD valor-mob   like inventario.valor-mob-m[1]
      FIELD valor-ggf   like inventario.valor-ggf-m[1]
      FIELD dt-valid    like inventario.dt-ult-entra
      FIELD situacao    as char.

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
         HEIGHT             = 2.01
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if RowObject.cod-confte-contag-1 = "" then
        assign RowObject.cod-confte-contag-1 = v_cod_usuar_corren.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findEstabelec DBOProgram 
PROCEDURE findEstabelec :
/*------------------------------------------------------------------------------
  Purpose:     Procura estabelecimento pelo campo cod-estabel
  Parameters:  cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pCodEstabel LIKE inventario.cod-estabel NO-UNDO.

    IF NOT AVAIL estabelec
       OR  estabelec.cod-estabel <> pCodEstabel THEN

    FOR FIRST estabelec
        FIELDS ( cod-estabel   custo-contab )
        WHERE estabelec.cod-estabel = pCodEstabel NO-LOCK.
    END.

    IF  NOT AVAIL estabelec THEN DO:
         /* estabelecimento n∆o cadastrado */
        {method/svc/errors/inserr.i
                            &ErrorNumber="2061"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"}
        RETURN "NOK":U.
    END.
    ELSE         
        RETURN "OK":U.        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findEstabMat DBOProgram 
PROCEDURE findEstabMat :
/*------------------------------------------------------------------------------
  Purpose:     Procura estabelecimento industriais pelo campo cod-estabel
  Parameters:  cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pCodEstabel LIKE inventario.cod-estabel NO-UNDO.

    IF NOT AVAIL estab-mat
       OR  estab-mat.cod-estabel <> pCodEstabel THEN

    FOR FIRST estab-mat
        FIELDS ( cod-estabel    mensal-ate )
        WHERE estab-mat.cod-estabel = pCodEstabel NO-LOCK.
    END.

    RETURN "OK":U.        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findItem DBOProgram 
PROCEDURE findItem :
/*------------------------------------------------------------------------------
  Purpose:     Procura item pelo campo it-codigo
  Parameters:  it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pItCodigo LIKE inventario.it-codigo NO-UNDO.

    IF NOT AVAIL item
       OR  item.it-codigo <> pItCodigo THEN

    FOR FIRST item
        FIELDS ( cod-localiz   cod-obsoleto   data-ult-sai
                 data-ult-ent  it-codigo      fraciona
                 loc-unica     tipo-con-est   tipo-contr
                 un )
        WHERE item.it-codigo = pItCodigo NO-LOCK.
    END.

    
    IF  NOT AVAIL item THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-item AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Item" *}
        ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="47"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-item"}
        RETURN "NOK":U.
    END.
    ELSE         
        RETURN "OK":U.        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findItemUniEstab DBOProgram 
PROCEDURE findItemUniEstab :
/*------------------------------------------------------------------------------
  Purpose:     Procura item-uni-estab pelos campo it-codigo
  Parameters:  it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pItCodigo LIKE inventario.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pCodEstab LIKE inventario.it-codigo NO-UNDO.
                                                            
    FOR FIRST item-uni-estab FIELDS(loc-unica cod-localiz data-ult-ent cod-obsoleto it-codigo)
        WHERE item-uni-estab.it-codigo   = pItCodigo AND 
              item-uni-estab.cod-estabel = pCodEstab NO-LOCK: END.
   
    RETURN "OK":U.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findItemEstab DBOProgram 
PROCEDURE findItemEstab :
/*------------------------------------------------------------------------------
  Purpose:     Procura item-estab pelos campos it-codigo e cod-estabel
  Parameters:  it-codigo e cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pItCodigo   LIKE inventario.it-codigo   NO-UNDO.
    DEFINE INPUT PARAMETER pCodEstabel LIKE inventario.cod-estabel NO-UNDO.

    IF NOT AVAIL item-estab
        OR ( AVAIL item-estab AND item-estab.it-codigo   <> pItCodigo   )
        OR ( AVAIL item-estab AND item-estab.cod-estabel <> pCodEstabel ) THEN

    FOR FIRST item-estab
        FIELDS ( it-codigo          cod-estabel       val-unit-mat-m[1]  
                 val-unit-mat-o[1]  val-unit-mat-p[1] val-unit-mob-m[1]
                 val-unit-mob-o[1]  val-unit-mob-p[1] val-unit-ggf-m[1]
                 val-unit-ggf-o[1]  val-unit-ggf-p[1])
        WHERE item-estab.it-codigo   = pItCodigo 
          AND item-estab.cod-estabel = pCodEstabel NO-LOCK.
    END.

    RETURN "OK":U.        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findSaldoEstoq BOProgram 
PROCEDURE findSaldoEstoq :
/*------------------------------------------------------------------------------
  Purpose:     Procura saldo-estoq 
  Parameters:  cod-estabel,cod-depos,cod-localiz,lote,it-codigo, flag para lock na tabela
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pCodEstabel LIKE inventario.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pCodDepos   LIKE inventario.cod-depos   NO-UNDO.
    DEFINE INPUT PARAMETER pCodLocaliz LIKE inventario.cod-localiz NO-UNDO.
    DEFINE INPUT PARAMETER pLote       LIKE inventario.lote        NO-UNDO.
    DEFINE INPUT PARAMETER pItCodigo   LIKE inventario.it-codigo   NO-UNDO.
    DEFINE INPUT PARAMETER pCodRefer   LIKE inventario.cod-refer   NO-UNDO.
    DEFINE INPUT PARAMETER pLock       AS LOGICAL                  NO-UNDO.
    
    IF NOT AVAIL saldo-estoq
            OR saldo-estoq.cod-estabel <> pCodEstabel
            OR saldo-estoq.cod-depos   <> pCodDepos
            OR saldo-estoq.cod-localiz <> pCodLocaliz
            OR saldo-estoq.lote        <> pLote
            OR saldo-estoq.it-codigo   <> pItCodigo
            OR saldo-estoq.cod-refer   <> pCodRefer THEN DO:

        IF pLock THEN DO:
            FIND FIRST saldo-estoq
                 WHERE saldo-estoq.cod-estabel = pCodEstabel
                   AND saldo-estoq.cod-depos   = pCodDepos
                   AND saldo-estoq.cod-localiz = pCodLocaliz
                   AND saldo-estoq.lote        = pLote
                   AND saldo-estoq.it-codigo   = pItCodigo 
                   AND saldo-estoq.cod-refer   = pCodRefer NO-ERROR. /* Sem exclusive-lock, pois travou o programa na WEB */
        END.
        ELSE DO:
            FOR FIRST saldo-estoq
                FIELDS ( cod-estabel     cod-depos     cod-localiz  
                         cod-refer       it-codigo     lote
                         dt-vali-lote )
                WHERE saldo-estoq.cod-estabel = pCodEstabel
                  AND saldo-estoq.cod-depos   = pCodDepos
                  AND saldo-estoq.cod-localiz = pCodLocaliz
                  AND saldo-estoq.lote        = pLote
                  AND saldo-estoq.it-codigo   = pItCodigo
                  AND saldo-estoq.cod-refer   = pCodRefer NO-LOCK.
            END.
        END.
    END.

    RETURN "OK":U.        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findTabUnidade DBOProgram 
PROCEDURE findTabUnidade :
/*------------------------------------------------------------------------------
  Purpose:     Procura tab-unidade pelo campo un
  Parameters:  un
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pUn LIKE item.un   NO-UNDO.

    IF NOT AVAIL tab-unidade
        OR tab-unidade.un <> pUn THEN

    FOR FIRST tab-unidade
        FIELDS ( un    descricao )
        WHERE tab-unidade.un = pUn NO-LOCK.
    END.

    IF  NOT AVAIL tab-unidade THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-unidade-de-medida AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Unidade_de_Medida" *}
        ASSIGN c-lbl-liter-unidade-de-medida = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-unidade-de-medida"}
        RETURN "NOK":U.
    END.
    ELSE         
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-atualiza":U THEN ASSIGN pFieldValue = RowObject.dt-atualiza.
        WHEN "dt-saldo":U THEN ASSIGN pFieldValue = RowObject.dt-saldo.
        WHEN "dt-ult-entra":U THEN ASSIGN pFieldValue = RowObject.dt-ult-entra.
        WHEN "dt-ult-saida":U THEN ASSIGN pFieldValue = RowObject.dt-ult-saida.
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
        WHEN "valor-ggf-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[2].
        WHEN "valor-ggf-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[3].
        WHEN "valor-ggf-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[1].
        WHEN "valor-ggf-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[2].
        WHEN "valor-ggf-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[3].
        WHEN "valor-mat-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[1].
        WHEN "valor-mat-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[2].
        WHEN "valor-mat-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[3].
        WHEN "valor-mat-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[1].
        WHEN "valor-mat-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[2].
        WHEN "valor-mat-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[3].
        WHEN "valor-mob-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[1].
        WHEN "valor-mob-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[2].
        WHEN "valor-mob-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[3].
        WHEN "valor-mob-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[1].
        WHEN "valor-mob-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[2].
        WHEN "valor-mob-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[3].
        WHEN "valor-mob-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[1].
        WHEN "valor-mob-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[2].
        WHEN "valor-mob-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[3].
        WHEN "valor-mat-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[3].
        WHEN "valor-mat-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[1].
        WHEN "valor-mat-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[2].
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "qtidade-atu":U THEN ASSIGN pFieldValue = RowObject.qtidade-atu.
        WHEN "val-apurado[1]":U THEN ASSIGN pFieldValue = RowObject.val-apurado[1].
        WHEN "val-apurado[2]":U THEN ASSIGN pFieldValue = RowObject.val-apurado[2].
        WHEN "val-apurado[3]":U THEN ASSIGN pFieldValue = RowObject.val-apurado[3].
        WHEN "valor-contab":U THEN ASSIGN pFieldValue = RowObject.valor-contab.
        WHEN "valor-final":U THEN ASSIGN pFieldValue = RowObject.valor-final.
        WHEN "valor-ggf-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[1].
        WHEN "valor-ggf-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[2].
        WHEN "valor-ggf-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[3].
        WHEN "valor-ggf-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[1].
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
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-ficha":U THEN ASSIGN pFieldValue = RowObject.nr-ficha.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice DATA-INVENT
  Parameters:
               retorna valor dos campos do °ndice DATA-INVENT
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pdt-saldo LIKE inventario.dt-saldo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE inventario.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-depos LIKE inventario.cod-depos NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-localiz LIKE inventario.cod-localiz NO-UNDO.
    DEFINE OUTPUT PARAMETER plote LIKE inventario.lote NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE inventario.it-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pdt-saldo = RowObject.dt-saldo.
    ASSIGN pcod-estabel = RowObject.cod-estabel.
    ASSIGN pcod-depos = RowObject.cod-depos.
    ASSIGN pcod-localiz = RowObject.cod-localiz.
    ASSIGN plote = RowObject.lote.
    ASSIGN pit-codigo = RowObject.it-codigo.

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
        WHEN "impressa":U THEN ASSIGN pFieldValue = RowObject.impressa.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
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



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLocalizacao DBOProgram 
PROCEDURE getLocalizacao :
/*------------------------------------------------------------------------------
  Purpose:     Retorna localizacao (Item X Estabelecimento)
  Parameters:  it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pItCodigo LIKE inventario.it-codigo   NO-UNDO.
    DEFINE INPUT  PARAMETER pCodEstab LIKE inventario.it-codigo   NO-UNDO.
    DEFINE OUTPUT PARAMETER pLocaliz  LIKE inventario.cod-localiz NO-UNDO.
    
    RUN findItemUniEstab IN THIS-PROCEDURE (INPUT pItCodigo,
                                            INPUT pCodEstab).

    assign pLocaliz = if avail item-uni-estab then item-uni-estab.cod-localiz
                       else "".
    
    RETURN "OK":U.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice DATA-INVENT
  Parameters:
               recebe valor dos campos do °ndice DATA-INVENT
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdt-saldo LIKE inventario.dt-saldo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE inventario.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-depos LIKE inventario.cod-depos NO-UNDO.
    DEFINE INPUT PARAMETER pcod-localiz LIKE inventario.cod-localiz NO-UNDO.
    DEFINE INPUT PARAMETER plote LIKE inventario.lote NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE inventario.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer LIKE inventario.cod-refer NO-UNDO.
    IF l-estab-security-active THEN DO:
        FIND FIRST bfinventario WHERE
            bfinventario.dt-saldo = pdt-saldo AND
            bfinventario.cod-estabel = pcod-estabel AND
            bfinventario.cod-depos = pcod-depos AND
            bfinventario.cod-localiz = pcod-localiz AND
            bfinventario.lote = plote AND
            bfinventario.it-codigo = pit-codigo AND
            bfinventario.cod-refer = pcod-refer AND
            CAN-FIND(FIRST {&ESTAB-SEC-TT} WHERE {&ESTAB-SEC-TT-FIELD} = bf{&TableName}.cod-estabel) NO-LOCK NO-ERROR.
    END.
    ELSE DO:
        FIND FIRST bfinventario WHERE
            bfinventario.dt-saldo = pdt-saldo AND
            bfinventario.cod-estabel = pcod-estabel AND
            bfinventario.cod-depos = pcod-depos AND
            bfinventario.cod-localiz = pcod-localiz AND
            bfinventario.lote = plote AND
            bfinventario.it-codigo = pit-codigo AND
            bfinventario.cod-refer = pcod-refer NO-LOCK NO-ERROR.
    END.
        
    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfinventario THEN
        RETURN "NOK":U.

    
    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfinventario)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

   
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyDataFicha DBOProgram
PROCEDURE goToKeyDataFicha:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdt-saldo LIKE inventario.dt-saldo NO-UNDO.
    DEFINE INPUT PARAMETER pnr-ficha LIKE inventario.nr-ficha NO-UNDO.
    
    IF l-estab-security-active THEN DO:
        FIND FIRST bfinventario WHERE
            bfinventario.dt-saldo = pdt-saldo AND
            bfinventario.nr-ficha = pnr-ficha AND
            CAN-FIND(FIRST {&ESTAB-SEC-TT} WHERE {&ESTAB-SEC-TT-FIELD} = bf{&TableName}.cod-estabel) NO-LOCK NO-ERROR.
    END.
    ELSE DO:
         FIND FIRST bfinventario WHERE
            bfinventario.dt-saldo = pdt-saldo AND
            bfinventario.nr-ficha = pnr-ficha NO-LOCK NO-ERROR.
    END.
    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfinventario THEN
        RETURN "NOK":U.
    
    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfinventario)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
END PROCEDURE.
    
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByEDFD DBOProgram 
PROCEDURE openQueryByEDFD :
/*------------------------------------------------------------------------------
  Purpose:  Query exibe por E(stabelecimento), D(ep¢sito), F(am°lia), D(escriá∆o do Item)   
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
        
       &SCOPED-DEFINE OPEN-QUERY-{&QueryName}-IN OPEN QUERY {&TableName}~
        FOR EACH {&ESTAB-SEC-TT} NO-LOCK,~
        EACH {&TableName} NO-LOCK                                    ~
            WHERE {&TableName}.dt-saldo     = da-dt-saldo            ~
              AND {&TableName}.cod-estabel >= c-cod-estabel-ini      ~
              AND {&TableName}.cod-estabel <= c-cod-estabel-fim      ~
              AND {&TableName}.cod-depos   >= c-cod-depos-ini        ~
              AND {&TableName}.cod-depos   <= c-cod-depos-fim        ~
              AND {&TableName}.cod-localiz >= c-cod-localiz-ini      ~
              AND {&TableName}.cod-localiz <= c-cod-localiz-fim      ~
              AND {&TableName}.lote        >= c-lote-ini             ~
              AND {&TableName}.lote        <= c-lote-fim             ~
              AND {&tablename}.it-codigo   >= c-it-codigo-ini        ~
              AND {&tablename}.it-codigo   <= c-it-codigo-fim        ~
              AND {&TableName}.nr-ficha    >= i-nr-ficha-ini         ~
              AND {&TableName}.nr-ficha    <= i-nr-ficha-fim,        ~
                                                                     ~
             EACH item NO-LOCK                                       ~
            WHERE item.it-codigo  = {&tablename}.it-codigo           ~
              AND item.fm-codigo >= c-fm-codigo-ini                  ~
              AND item.fm-codigo <= c-fm-codigo-fim                  ~
              AND item.ge-codigo >= i-ge-codigo-ini                  ~
              AND item.ge-codigo <= i-ge-codigo-fim                  ~
                                                                     ~
               BY {&TableName}.cod-estabel                           ~
               BY {&TableName}.cod-depos                             ~
               BY item.fm-codigo                                     ~
               BY item.desc-item.
       &SCOPED-DEFINE OPEN-QUERY-{&QueryName}-AT OPEN QUERY {&TableName}~
        FOR EACH {&ESTAB-SEC-TT} NO-LOCK,~
        EACH {&TableName} WHERE {&TableName}.cod-estabel = {&ESTAB-SEC-TT-FIELD} ~
              AND {&TableName}.dt-saldo     = da-dt-saldo            ~
              AND {&TableName}.cod-estabel >= c-cod-estabel-ini      ~
              AND {&TableName}.cod-estabel <= c-cod-estabel-fim      ~
              AND {&TableName}.cod-depos   >= c-cod-depos-ini        ~
              AND {&TableName}.cod-depos   <= c-cod-depos-fim        ~
              AND {&TableName}.cod-localiz >= c-cod-localiz-ini      ~
              AND {&TableName}.cod-localiz <= c-cod-localiz-fim      ~
              AND {&TableName}.lote        >= c-lote-ini             ~
              AND {&TableName}.lote        <= c-lote-fim             ~
              AND {&tablename}.it-codigo   >= c-it-codigo-ini        ~
              AND {&tablename}.it-codigo   <= c-it-codigo-fim        ~
              AND {&TableName}.nr-ficha    >= i-nr-ficha-ini         ~
              AND {&TableName}.nr-ficha    <= i-nr-ficha-fim NO-LOCK, ~
                                                                     ~
             EACH item NO-LOCK                                       ~
            WHERE item.it-codigo  = {&tablename}.it-codigo           ~
              AND item.fm-codigo >= c-fm-codigo-ini                  ~
              AND item.fm-codigo <= c-fm-codigo-fim                  ~
              AND item.ge-codigo >= i-ge-codigo-ini                  ~
              AND item.ge-codigo <= i-ge-codigo-fim                  ~
                                                                     ~
               BY {&TableName}.cod-estabel                           ~
               BY {&TableName}.cod-depos                             ~
               BY item.fm-codigo                                     ~
               BY item.desc-item.
   
   {include/i-estab-openquery.i}
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByEDLD DBOProgram 
PROCEDURE openQueryByEDLD :
/*------------------------------------------------------------------------------
  Purpose:  Query exibe por E(stabelecimento), D(ep¢sito), L(ocalizaá∆o), D(escriá∆o) do Item   
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

 &SCOPED-DEFINE OPEN-QUERY-{&QueryName}-IN OPEN QUERY {&QueryName} ~
        FOR EACH {&ESTAB-SEC-TT} NO-LOCK, ~
        EACH {&TableName} NO-LOCK                                 ~
           WHERE {&TableName}.dt-saldo     = da-dt-saldo          ~
             AND {&TableName}.cod-estabel >= c-cod-estabel-ini    ~
             AND {&TableName}.cod-estabel <= c-cod-estabel-fim    ~
             AND {&TableName}.cod-depos   >= c-cod-depos-ini      ~
             AND {&TableName}.cod-depos   <= c-cod-depos-fim      ~
             AND {&TableName}.cod-localiz >= c-cod-localiz-ini    ~
             AND {&TableName}.cod-localiz <= c-cod-localiz-fim    ~
             AND {&TableName}.lote        >= c-lote-ini           ~
             AND {&TableName}.lote        <= c-lote-fim           ~
             AND {&tablename}.it-codigo   >= c-it-codigo-ini      ~
             AND {&tablename}.it-codigo   <= c-it-codigo-fim      ~
             AND {&TableName}.nr-ficha    >= i-nr-ficha-ini       ~
             AND {&TableName}.nr-ficha    <= i-nr-ficha-fim,      ~
        EACH item NO-LOCK                                         ~
            WHERE item.it-codigo  = {&tablename}.it-codigo        ~
              AND item.fm-codigo >= c-fm-codigo-ini               ~
              AND item.fm-codigo <= c-fm-codigo-fim               ~
              AND item.ge-codigo >= i-ge-codigo-ini               ~
              AND item.ge-codigo <= i-ge-codigo-fim               ~
               BY {&TableName}.cod-estabel                        ~
               BY {&TableName}.cod-depos                          ~
               BY {&TableName}.cod-localiz                        ~
               BY item.desc-item.
  &SCOPED-DEFINE OPEN-QUERY-{&QueryName}-AT OPEN QUERY {&QueryName} ~
        FOR EACH {&ESTAB-SEC-TT} NO-LOCK, ~
        EACH {&TableName} WHERE {&TableName}.cod-estabel = {&ESTAB-SEC-TT-FIELD} ~
             AND {&TableName}.dt-saldo     = da-dt-saldo          ~
             AND {&TableName}.cod-estabel >= c-cod-estabel-ini    ~
             AND {&TableName}.cod-estabel <= c-cod-estabel-fim    ~
             AND {&TableName}.cod-depos   >= c-cod-depos-ini      ~
             AND {&TableName}.cod-depos   <= c-cod-depos-fim      ~
             AND {&TableName}.cod-localiz >= c-cod-localiz-ini    ~
             AND {&TableName}.cod-localiz <= c-cod-localiz-fim    ~
             AND {&TableName}.lote        >= c-lote-ini           ~
             AND {&TableName}.lote        <= c-lote-fim           ~
             AND {&tablename}.it-codigo   >= c-it-codigo-ini      ~
             AND {&tablename}.it-codigo   <= c-it-codigo-fim      ~
             AND {&TableName}.nr-ficha    >= i-nr-ficha-ini       ~
             AND {&TableName}.nr-ficha    <= i-nr-ficha-fim NO-LOCK,  ~
        EACH item NO-LOCK                                         ~
            WHERE item.it-codigo  = {&tablename}.it-codigo        ~
              AND item.fm-codigo >= c-fm-codigo-ini               ~
              AND item.fm-codigo <= c-fm-codigo-fim               ~
              AND item.ge-codigo >= i-ge-codigo-ini               ~
              AND item.ge-codigo <= i-ge-codigo-fim               ~
               BY {&TableName}.cod-estabel                        ~
               BY {&TableName}.cod-depos                          ~
               BY {&TableName}.cod-localiz                        ~
               BY item.desc-item.
   {include/i-estab-openquery.i}
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByEDLI DBOProgram 
PROCEDURE openQueryByEDLI :
/*------------------------------------------------------------------------------
  Purpose:  Query exibe por E(stabelecimento), D(ep¢sito), L(ocalizaá∆o), I(tem)   
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
 /* Verifica se o programa est† sendo executado na Grendene */
    &IF DEFINED(CUSTOM_GRENDENE) &THEN 
        IF  c-it-codigo-ini = c-it-codigo-fim THEN
            &SCOPED-DEFINE OPEN-QUERY-{&QueryName}-IN OPEN QUERY {&QueryName} ~
                FOR EACH {&ESTAB-SEC-TT} NO-LOCK, ~
                    EACH {&TableName} NO-LOCK                                    ~
                        WHERE {&TableName}.dt-saldo     = da-dt-saldo            ~
                            AND {&TableName}.cod-estabel >= c-cod-estabel-ini    ~
                            AND {&TableName}.cod-estabel <= c-cod-estabel-fim    ~
                            AND {&TableName}.cod-depos   >= c-cod-depos-ini      ~
                            AND {&TableName}.cod-depos   <= c-cod-depos-fim      ~
                            AND {&TableName}.cod-localiz >= c-cod-localiz-ini    ~
                            AND {&TableName}.cod-localiz <= c-cod-localiz-fim    ~
                            AND {&TableName}.lote        >= c-lote-ini           ~
                            AND {&TableName}.lote        <= c-lote-fim           ~
                            AND {&tablename}.it-codigo   >= c-it-codigo-ini      ~
                            AND {&tablename}.it-codigo   <= c-it-codigo-fim      ~
                            AND {&TableName}.nr-ficha    >= i-nr-ficha-ini       ~
                            AND {&TableName}.nr-ficha    <= i-nr-ficha-fim,       ~
                        FIRST item NO-LOCK                                       ~
                        WHERE item.it-codigo  = {&tablename}.it-codigo           ~
                            AND item.fm-codigo >= c-fm-codigo-ini                ~
                            AND item.fm-codigo <= c-fm-codigo-fim                ~
                            AND item.ge-codigo >= i-ge-codigo-ini                ~
                            AND item.ge-codigo <= i-ge-codigo-fim                ~
                            BY {&TableName}.dt-saldo                             ~
                            BY {&TableName}.cod-estabel                          ~
                            BY {&TableName}.cod-depos                            ~
                            BY {&TableName}.cod-localiz                          ~
                            BY {&TableName}.lote                                 ~
                            BY {&TableName}.cod-refer                            ~
                            BY {&tablename}.it-codigo                            ~
                            .
            &SCOPED-DEFINE OPEN-QUERY-{&QueryName}-AT OPEN QUERY {&QueryName} ~
                FOR EACH {&ESTAB-SEC-TT} NO-LOCK, ~
                    EACH {&TableName} WHERE {&TableName}.cod-estabel = {&ESTAB-SEC-TT-FIELD} ~
                            AND {&TableName}.dt-saldo     = da-dt-saldo          ~
                            AND {&TableName}.cod-estabel >= c-cod-estabel-ini    ~
                            AND {&TableName}.cod-estabel <= c-cod-estabel-fim    ~
                            AND {&TableName}.cod-depos   >= c-cod-depos-ini      ~
                            AND {&TableName}.cod-depos   <= c-cod-depos-fim      ~
                            AND {&TableName}.cod-localiz >= c-cod-localiz-ini    ~
                            AND {&TableName}.cod-localiz <= c-cod-localiz-fim    ~
                            AND {&TableName}.lote        >= c-lote-ini           ~
                            AND {&TableName}.lote        <= c-lote-fim           ~
                            AND {&tablename}.it-codigo   >= c-it-codigo-ini      ~
                            AND {&tablename}.it-codigo   <= c-it-codigo-fim      ~
                            AND {&TableName}.nr-ficha    >= i-nr-ficha-ini       ~
                            AND {&TableName}.nr-ficha    <= i-nr-ficha-fim NO-LOCK, ~
                        FIRST item NO-LOCK                                       ~
                        WHERE item.it-codigo  = {&tablename}.it-codigo           ~
                            AND item.fm-codigo >= c-fm-codigo-ini                ~
                            AND item.fm-codigo <= c-fm-codigo-fim                ~
                            AND item.ge-codigo >= i-ge-codigo-ini                ~
                            AND item.ge-codigo <= i-ge-codigo-fim                ~
                            BY {&TableName}.dt-saldo                             ~
                            BY {&TableName}.cod-estabel                          ~
                            BY {&TableName}.cod-depos                            ~
                            BY {&TableName}.cod-localiz                          ~
                            BY {&TableName}.lote                                 ~
                            BY {&TableName}.cod-refer                            ~
                            BY {&tablename}.it-codigo                            ~
                            .                
                            {include/i-estab-openquery.i}
        ELSE
            &SCOPED-DEFINE OPEN-QUERY-{&QueryName}-IN OPEN QUERY {&QueryName} ~
                FOR EACH {&ESTAB-SEC-TT} NO-LOCK, ~
                EACH {&TableName} NO-LOCK                            ~
                WHERE {&TableName}.dt-saldo     = da-dt-saldo        ~
                  AND {&TableName}.cod-estabel >= c-cod-estabel-ini  ~
                  AND {&TableName}.cod-estabel <= c-cod-estabel-fim  ~
                  AND {&TableName}.cod-depos   >= c-cod-depos-ini    ~
                  AND {&TableName}.cod-depos   <= c-cod-depos-fim    ~
                  AND {&TableName}.cod-localiz >= c-cod-localiz-ini  ~
                  AND {&TableName}.cod-localiz <= c-cod-localiz-fim  ~
                  AND {&TableName}.lote        >= c-lote-ini         ~
                  AND {&TableName}.lote        <= c-lote-fim         ~
                  AND {&tablename}.it-codigo   >= c-it-codigo-ini    ~
                  AND {&tablename}.it-codigo   <= c-it-codigo-fim    ~
                  AND {&TableName}.nr-ficha    >= i-nr-ficha-ini     ~
                  AND {&TableName}.nr-ficha    <= i-nr-ficha-fim,     ~
                FIRST item NO-LOCK                                   ~
                WHERE item.it-codigo  = {&tablename}.it-codigo       ~
                  AND item.fm-codigo >= c-fm-codigo-ini              ~
                  AND item.fm-codigo <= c-fm-codigo-fim              ~
                  AND item.ge-codigo >= i-ge-codigo-ini              ~
                  AND item.ge-codigo <= i-ge-codigo-fim              ~
                   BY {&TableName}.dt-saldo                          ~
                   BY {&TableName}.cod-estabel                       ~
                   BY {&TableName}.cod-depos                         ~
                   BY {&TableName}.cod-localiz                       ~
                   BY {&TableName}.lote                              ~
                   BY {&TableName}.cod-refer                         ~
                   BY {&tablename}.it-codigo                         ~
                   .
            &SCOPED-DEFINE OPEN-QUERY-{&QueryName}-AT OPEN QUERY {&QueryName} ~
                FOR EACH {&ESTAB-SEC-TT} NO-LOCK, ~
                EACH {&TableName} WHERE {&TableName}.cod-estabel = {&ESTAB-SEC-TT-FIELD}
                  AND {&TableName}.dt-saldo     = da-dt-saldo        ~
                  AND {&TableName}.cod-estabel >= c-cod-estabel-ini  ~
                  AND {&TableName}.cod-estabel <= c-cod-estabel-fim  ~
                  AND {&TableName}.cod-depos   >= c-cod-depos-ini    ~
                  AND {&TableName}.cod-depos   <= c-cod-depos-fim    ~
                  AND {&TableName}.cod-localiz >= c-cod-localiz-ini  ~
                  AND {&TableName}.cod-localiz <= c-cod-localiz-fim  ~
                  AND {&TableName}.lote        >= c-lote-ini         ~
                  AND {&TableName}.lote        <= c-lote-fim         ~
                  AND {&tablename}.it-codigo   >= c-it-codigo-ini    ~
                  AND {&tablename}.it-codigo   <= c-it-codigo-fim    ~
                  AND {&TableName}.nr-ficha    >= i-nr-ficha-ini     ~
                  AND {&TableName}.nr-ficha    <= i-nr-ficha-fim NO-LOCK,     ~
                FIRST item NO-LOCK                                   ~
                WHERE item.it-codigo  = {&tablename}.it-codigo       ~
                  AND item.fm-codigo >= c-fm-codigo-ini              ~
                  AND item.fm-codigo <= c-fm-codigo-fim              ~
                  AND item.ge-codigo >= i-ge-codigo-ini              ~
                  AND item.ge-codigo <= i-ge-codigo-fim              ~
                   BY {&TableName}.dt-saldo                          ~
                   BY {&TableName}.cod-estabel                       ~
                   BY {&TableName}.cod-depos                         ~
                   BY {&TableName}.cod-localiz                       ~
                   BY {&TableName}.lote                              ~
                   BY {&TableName}.cod-refer                         ~
                   BY {&tablename}.it-codigo                         ~
                   .
                   {include/i-estab-openquery.i}
    &ELSE
        &SCOPED-DEFINE OPEN-QUERY-{&QueryName}-IN OPEN QUERY {&QueryName} ~
                FOR EACH {&ESTAB-SEC-TT} NO-LOCK, ~
                EACH {&TableName} NO-LOCK                            ~
                WHERE {&TableName}.dt-saldo     = da-dt-saldo        ~
                  AND {&TableName}.cod-estabel >= c-cod-estabel-ini  ~
                  AND {&TableName}.cod-estabel <= c-cod-estabel-fim  ~
                  AND {&TableName}.cod-depos   >= c-cod-depos-ini    ~
                  AND {&TableName}.cod-depos   <= c-cod-depos-fim    ~
                  AND {&TableName}.cod-localiz >= c-cod-localiz-ini  ~
                  AND {&TableName}.cod-localiz <= c-cod-localiz-fim  ~
                  AND {&TableName}.lote        >= c-lote-ini         ~
                  AND {&TableName}.lote        <= c-lote-fim         ~
                  AND {&tablename}.it-codigo   >= c-it-codigo-ini    ~
                  AND {&tablename}.it-codigo   <= c-it-codigo-fim    ~
                  AND {&TableName}.nr-ficha    >= i-nr-ficha-ini     ~
                  AND {&TableName}.nr-ficha    <= i-nr-ficha-fim,     ~
                FIRST item NO-LOCK                                   ~
                WHERE item.it-codigo  = {&tablename}.it-codigo       ~
                  AND item.fm-codigo >= c-fm-codigo-ini              ~
                  AND item.fm-codigo <= c-fm-codigo-fim              ~
                  AND item.ge-codigo >= i-ge-codigo-ini              ~
                  AND item.ge-codigo <= i-ge-codigo-fim              ~
                   BY {&TableName}.dt-saldo                          ~
                   BY {&TableName}.cod-estabel                       ~
                   BY {&TableName}.cod-depos                         ~
                   BY {&TableName}.cod-localiz                       ~
                   BY {&TableName}.lote                              ~
                   BY {&TableName}.cod-refer                         ~
                   BY {&tablename}.it-codigo                         ~
                   .
        &SCOPED-DEFINE OPEN-QUERY-{&QueryName}-AT OPEN QUERY {&QueryName} ~
                FOR EACH {&ESTAB-SEC-TT} NO-LOCK, ~
                EACH {&TableName} WHERE {&TableName}.cod-estabel = {&ESTAB-SEC-TT-FIELD}  ~
                  AND {&TableName}.dt-saldo     = da-dt-saldo        ~
                  AND {&TableName}.cod-estabel >= c-cod-estabel-ini  ~
                  AND {&TableName}.cod-estabel <= c-cod-estabel-fim  ~
                  AND {&TableName}.cod-depos   >= c-cod-depos-ini    ~
                  AND {&TableName}.cod-depos   <= c-cod-depos-fim    ~
                  AND {&TableName}.cod-localiz >= c-cod-localiz-ini  ~
                  AND {&TableName}.cod-localiz <= c-cod-localiz-fim  ~
                  AND {&TableName}.lote        >= c-lote-ini         ~
                  AND {&TableName}.lote        <= c-lote-fim         ~
                  AND {&tablename}.it-codigo   >= c-it-codigo-ini    ~
                  AND {&tablename}.it-codigo   <= c-it-codigo-fim    ~
                  AND {&TableName}.nr-ficha    >= i-nr-ficha-ini     ~
                  AND {&TableName}.nr-ficha    <= i-nr-ficha-fim NO-LOCK,     ~
                FIRST item NO-LOCK                                   ~
                WHERE item.it-codigo  = {&tablename}.it-codigo       ~
                  AND item.fm-codigo >= c-fm-codigo-ini              ~
                  AND item.fm-codigo <= c-fm-codigo-fim              ~
                  AND item.ge-codigo >= i-ge-codigo-ini              ~
                  AND item.ge-codigo <= i-ge-codigo-fim              ~
                   BY {&TableName}.dt-saldo                          ~
                   BY {&TableName}.cod-estabel                       ~
                   BY {&TableName}.cod-depos                         ~
                   BY {&TableName}.cod-localiz                       ~
                   BY {&TableName}.lote                              ~
                   BY {&TableName}.cod-refer                         ~
                   BY {&tablename}.it-codigo                         ~
                   .
        {include/i-estab-openquery.i}
    &ENDIF

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNrFicha DBOProgram 
PROCEDURE openQueryByNrFicha :
/*------------------------------------------------------------------------------
  Purpose: Query por ordem de ficha
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  /* Verifica se o programa est† sendo executado na Grendene */
    &IF DEFINED(CUSTOM_GRENDENE) &THEN 
        /* Quando for selecionado um £nico item usa °ndice espec°fico na abertura
           da query */
        IF  c-it-codigo-ini = c-it-codigo-fim THEN
            &SCOPED-DEFINE OPEN-QUERY-{&QueryName}-IN OPEN QUERY {&QueryName}~
                FOR EACH {&ESTAB-SEC-TT} NO-LOCK,~
                EACH {&TableName} NO-LOCK                                            ~
                             WHERE {&TableName}.dt-saldo     = da-dt-saldo           ~
                               AND {&TableName}.cod-estabel >= c-cod-estabel-ini     ~
                               AND {&TableName}.cod-estabel <= c-cod-estabel-fim     ~
                               AND {&TableName}.cod-depos   >= c-cod-depos-ini       ~
                               AND {&TableName}.cod-depos   <= c-cod-depos-fim       ~
                               AND {&TableName}.cod-localiz >= c-cod-localiz-ini     ~
                               AND {&TableName}.cod-localiz <= c-cod-localiz-fim     ~
                               AND {&TableName}.lote        >= c-lote-ini            ~
                               AND {&TableName}.lote        <= c-lote-fim            ~
                               AND {&tablename}.it-codigo   >= c-it-codigo-ini       ~
                               AND {&tablename}.it-codigo   <= c-it-codigo-fim       ~
                               AND {&TableName}.nr-ficha    >= i-nr-ficha-ini        ~
                               AND {&TableName}.nr-ficha    <= i-nr-ficha-fim,        ~
                              FIRST item NO-LOCK                                     ~
                              WHERE item.it-codigo  = {&tablename}.it-codigo         ~
                                AND item.fm-codigo >= c-fm-codigo-ini                ~
                                AND item.fm-codigo <= c-fm-codigo-fim                ~
                                AND item.ge-codigo >= i-ge-codigo-ini                ~
                                AND item.ge-codigo <= i-ge-codigo-fim                ~
                                 BY {&tableName}.dt-saldo                            ~
                                 BY {&TableName}.nr-ficha                            ~
                                 .
            &SCOPED-DEFINE OPEN-QUERY-{&QueryName}-IN OPEN QUERY {&QueryName}~
                FOR EACH {&ESTAB-SEC-TT} NO-LOCK,~
                EACH {&TableName} WHERE {&TableName}.cod-estabel = {&ESTAB-SEC-TT-FIELD}  ~
                               AND {&TableName}.dt-saldo     = da-dt-saldo           ~
                               AND {&TableName}.cod-estabel >= c-cod-estabel-ini     ~
                               AND {&TableName}.cod-estabel <= c-cod-estabel-fim     ~
                               AND {&TableName}.cod-depos   >= c-cod-depos-ini       ~
                               AND {&TableName}.cod-depos   <= c-cod-depos-fim       ~
                               AND {&TableName}.cod-localiz >= c-cod-localiz-ini     ~
                               AND {&TableName}.cod-localiz <= c-cod-localiz-fim     ~
                               AND {&TableName}.lote        >= c-lote-ini            ~
                               AND {&TableName}.lote        <= c-lote-fim            ~
                               AND {&tablename}.it-codigo   >= c-it-codigo-ini       ~
                               AND {&tablename}.it-codigo   <= c-it-codigo-fim       ~
                               AND {&TableName}.nr-ficha    >= i-nr-ficha-ini        ~
                               AND {&TableName}.nr-ficha    <= i-nr-ficha-fim,        ~
                              FIRST item NO-LOCK                                     ~
                              WHERE item.it-codigo  = {&tablename}.it-codigo         ~
                                AND item.fm-codigo >= c-fm-codigo-ini                ~
                                AND item.fm-codigo <= c-fm-codigo-fim                ~
                                AND item.ge-codigo >= i-ge-codigo-ini                ~
                                AND item.ge-codigo <= i-ge-codigo-fim                ~
                                 BY {&tableName}.dt-saldo                            ~
                                 BY {&TableName}.nr-ficha                            ~
                                 .                     
                {include/i-estab-openquery.i}
        ELSE   
            &SCOPED-DEFINE OPEN-QUERY-{&QueryName}-IN OPEN QUERY {&QueryName}~
                FOR EACH {&ESTAB-SEC-TT} NO-LOCK,~
                EACH {&TableName} NO-LOCK                                         ~
                             WHERE {&TableName}.dt-saldo     = da-dt-saldo        ~
                               AND {&TableName}.cod-estabel >= c-cod-estabel-ini  ~
                               AND {&TableName}.cod-estabel <= c-cod-estabel-fim  ~
                               AND {&TableName}.cod-depos   >= c-cod-depos-ini    ~
                               AND {&TableName}.cod-depos   <= c-cod-depos-fim    ~
                               AND {&TableName}.cod-localiz >= c-cod-localiz-ini  ~
                               AND {&TableName}.cod-localiz <= c-cod-localiz-fim  ~
                               AND {&TableName}.lote        >= c-lote-ini         ~
                               AND {&TableName}.lote        <= c-lote-fim         ~
                               AND {&tablename}.it-codigo   >= c-it-codigo-ini    ~
                               AND {&tablename}.it-codigo   <= c-it-codigo-fim    ~
                               AND {&TableName}.nr-ficha    >= i-nr-ficha-ini     ~
                               AND {&TableName}.nr-ficha    <= i-nr-ficha-fim,     ~
                              FIRST item NO-LOCK                                  ~
                              WHERE item.it-codigo  = {&tablename}.it-codigo      ~
                                AND item.fm-codigo >= c-fm-codigo-ini             ~
                                AND item.fm-codigo <= c-fm-codigo-fim             ~
                                AND item.ge-codigo >= i-ge-codigo-ini             ~
                                AND item.ge-codigo <= i-ge-codigo-fim             ~
                                 BY {&tableName}.dt-saldo                         ~
                                 BY {&TableName}.nr-ficha                         ~
                                 .
             &SCOPED-DEFINE OPEN-QUERY-{&QueryName}-AT OPEN QUERY {&QueryName}~
                FOR EACH {&ESTAB-SEC-TT} NO-LOCK,~
                EACH {&TableName} WHERE {&TableName}.cod-estabel = {&ESTAB-SEC-TT-FIELD}  ~
                               AND {&TableName}.dt-saldo     = da-dt-saldo        ~
                               AND {&TableName}.cod-estabel >= c-cod-estabel-ini  ~
                               AND {&TableName}.cod-estabel <= c-cod-estabel-fim  ~
                               AND {&TableName}.cod-depos   >= c-cod-depos-ini    ~
                               AND {&TableName}.cod-depos   <= c-cod-depos-fim    ~
                               AND {&TableName}.cod-localiz >= c-cod-localiz-ini  ~
                               AND {&TableName}.cod-localiz <= c-cod-localiz-fim  ~
                               AND {&TableName}.lote        >= c-lote-ini         ~
                               AND {&TableName}.lote        <= c-lote-fim         ~
                               AND {&tablename}.it-codigo   >= c-it-codigo-ini    ~
                               AND {&tablename}.it-codigo   <= c-it-codigo-fim    ~
                               AND {&TableName}.nr-ficha    >= i-nr-ficha-ini     ~
                               AND {&TableName}.nr-ficha    <= i-nr-ficha-fim NO-LOCK,     ~
                              FIRST item NO-LOCK                                  ~
                              WHERE item.it-codigo  = {&tablename}.it-codigo      ~
                                AND item.fm-codigo >= c-fm-codigo-ini             ~
                                AND item.fm-codigo <= c-fm-codigo-fim             ~
                                AND item.ge-codigo >= i-ge-codigo-ini             ~
                                AND item.ge-codigo <= i-ge-codigo-fim             ~
                                 BY {&tableName}.dt-saldo                         ~
                                 BY {&TableName}.nr-ficha                         ~
                                 .                                                     
                                {include/i-estab-openquery.i}WHERE {&TableName}.cod-estabel = {&ESTAB-SEC-TT-FIELD}  ~
    &ElSE
        /* Se o programa n∆o for executado na Grendene, abre a query normalmente */
        &SCOPED-DEFINE OPEN-QUERY-{&QueryName}-IN OPEN QUERY {&QueryName}~
        FOR EACH {&ESTAB-SEC-TT} NO-LOCK,~
        EACH {&TableName} NO-LOCK                                       ~
                 WHERE {&TableName}.dt-saldo     = da-dt-saldo          ~
                   AND {&TableName}.cod-estabel >= c-cod-estabel-ini    ~
                   AND {&TableName}.cod-estabel <= c-cod-estabel-fim    ~
                   AND {&TableName}.cod-depos   >= c-cod-depos-ini      ~
                   AND {&TableName}.cod-depos   <= c-cod-depos-fim      ~
                   AND {&TableName}.cod-localiz >= c-cod-localiz-ini    ~
                   AND {&TableName}.cod-localiz <= c-cod-localiz-fim    ~
                   AND {&TableName}.lote        >= c-lote-ini           ~
                   AND {&TableName}.lote        <= c-lote-fim           ~
                   AND {&tablename}.it-codigo   >= c-it-codigo-ini      ~
                   AND {&tablename}.it-codigo   <= c-it-codigo-fim      ~
                   AND {&TableName}.nr-ficha    >= i-nr-ficha-ini       ~
                   AND {&TableName}.nr-ficha    <= i-nr-ficha-fim,       ~
                  FIRST item NO-LOCK                                    ~
                  WHERE item.it-codigo  = {&tablename}.it-codigo        ~
                    AND item.fm-codigo >= c-fm-codigo-ini               ~
                    AND item.fm-codigo <= c-fm-codigo-fim               ~
                    AND item.ge-codigo >= i-ge-codigo-ini               ~
                    AND item.ge-codigo <= i-ge-codigo-fim               ~
                     BY {&tableName}.dt-saldo                           ~
                     BY {&TableName}.nr-ficha                           ~
                     .
        &SCOPED-DEFINE OPEN-QUERY-{&QueryName}-AT OPEN QUERY {&QueryName}~
        FOR EACH {&ESTAB-SEC-TT} NO-LOCK,~
        EACH {&TableName} WHERE {&TableName}.cod-estabel = {&ESTAB-SEC-TT-FIELD}  ~
                   AND {&TableName}.dt-saldo     = da-dt-saldo          ~
                   AND {&TableName}.cod-estabel >= c-cod-estabel-ini    ~
                   AND {&TableName}.cod-estabel <= c-cod-estabel-fim    ~
                   AND {&TableName}.cod-depos   >= c-cod-depos-ini      ~
                   AND {&TableName}.cod-depos   <= c-cod-depos-fim      ~
                   AND {&TableName}.cod-localiz >= c-cod-localiz-ini    ~
                   AND {&TableName}.cod-localiz <= c-cod-localiz-fim    ~
                   AND {&TableName}.lote        >= c-lote-ini           ~
                   AND {&TableName}.lote        <= c-lote-fim           ~
                   AND {&tablename}.it-codigo   >= c-it-codigo-ini      ~
                   AND {&tablename}.it-codigo   <= c-it-codigo-fim      ~
                   AND {&TableName}.nr-ficha    >= i-nr-ficha-ini       ~
                   AND {&TableName}.nr-ficha    <= i-nr-ficha-fim NO-LOCK,       ~
                  FIRST item NO-LOCK                                    ~
                  WHERE item.it-codigo  = {&tablename}.it-codigo        ~
                    AND item.fm-codigo >= c-fm-codigo-ini               ~
                    AND item.fm-codigo <= c-fm-codigo-fim               ~
                    AND item.ge-codigo >= i-ge-codigo-ini               ~
                    AND item.ge-codigo <= i-ge-codigo-fim               ~
                     BY {&tableName}.dt-saldo                           ~
                     BY {&TableName}.nr-ficha                           ~
                     .             
                    {include/i-estab-openquery.i} 
    &ENDIF

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-delete-by-data-ficha DBOProgram
PROCEDURE pi-delete-by-data-ficha:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdt-saldo   AS DATE    NO-UNDO.
    DEFINE INPUT PARAMETER pi-nr-ficha AS INTEGER NO-UNDO.
    
    FIND FIRST bf{&TableName} EXCLUSIVE-LOCK
         WHERE bf{&TableName}.dt-saldo = pdt-saldo
           AND bf{&TableName}.nr-ficha = pi-nr-ficha  NO-ERROR.
               
    IF NOT AVAILABLE bf{&TableName} THEN RETURN "NOK":U.
    
    DELETE bf{&TableName}.
    RELEASE bf{&TableName}.
    
    RETURN "OK":U.
END PROCEDURE.
    
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSelecInvent DBOProgram 
PROCEDURE piSelecInvent :
/*------------------------------------------------------------------------------
  Purpose:  
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pDtSaldo       LIKE inventario.dt-saldo    NO-UNDO.
DEFINE INPUT PARAMETER pCdnAgrup      LIKE inventario.cdn-agrup   NO-UNDO.
DEFINE INPUT PARAMETER pItCodigoIni   LIKE inventario.it-codigo   NO-UNDO.
DEFINE INPUT PARAMETER pItCodigoFim   LIKE inventario.it-codigo   NO-UNDO.
DEFINE INPUT PARAMETER pGeCodigoIni   LIKE ITEM.ge-codigo         NO-UNDO.
DEFINE INPUT PARAMETER pGeCodigoFim   LIKE ITEM.ge-codigo         NO-UNDO.
DEFINE INPUT PARAMETER pFmCodigoIni   LIKE ITEM.fm-codigo         NO-UNDO.
DEFINE INPUT PARAMETER pFmCodigoFim   LIKE ITEM.fm-codigo         NO-UNDO.
DEFINE INPUT PARAMETER pCodReferIni   LIKE inventario.cod-refer   NO-UNDO.
DEFINE INPUT PARAMETER pCodReferFim   LIKE inventario.cod-refer   NO-UNDO.
DEFINE INPUT PARAMETER pLoteIni       LIKE inventario.lote        NO-UNDO.
DEFINE INPUT PARAMETER pLoteFim       LIKE inventario.lote        NO-UNDO.
DEFINE INPUT PARAMETER pCodLocalizIni LIKE inventario.cod-localiz NO-UNDO.
DEFINE INPUT PARAMETER pCodLocalizFim LIKE inventario.cod-localiz NO-UNDO.
DEFINE INPUT PARAMETER pCodDeposIni   LIKE inventario.cod-depos   NO-UNDO.
DEFINE INPUT PARAMETER pCodDeposFim   LIKE inventario.cod-depos   NO-UNDO.
DEFINE INPUT PARAMETER pCodEstabelIni LIKE inventario.cod-estabel NO-UNDO.
DEFINE INPUT PARAMETER pCodEstabelFim LIKE inventario.cod-estabel NO-UNDO.
DEFINE INPUT PARAMETER pNrFichaIni    LIKE inventario.nr-ficha    NO-UNDO.
DEFINE INPUT PARAMETER pNrFichaFim    LIKE inventario.nr-ficha    NO-UNDO.

DEFINE INPUT PARAMETER pNaoDigitada   AS LOGICAL                  NO-UNDO.
DEFINE INPUT PARAMETER pInventariar   AS LOGICAL                  NO-UNDO.
DEFINE INPUT PARAMETER pInventarioOK  AS LOGICAL                  NO-UNDO.

DEFINE INPUT PARAMETER pContagem      AS INTEGER                  NO-UNDO.
DEFINE INPUT PARAMETER pClassificacao AS INTEGER                  NO-UNDO.

DEFINE OUTPUT PARAM TABLE FOR tt-inventario-tela.

empty temp-table tt-inventario-tela no-error.

if pClassificacao = 1 then
    FOR EACH {&TableName} NO-LOCK 
       WHERE {&TableName}.dt-saldo     = pDtSaldo
         AND {&TableName}.cdn-agrup    = pCdnAgrup
         AND {&TableName}.cod-estabel >= pCodEstabelIni
         AND {&TableName}.cod-estabel <= pCodEstabelFim
         AND {&TableName}.cod-depos   >= pCodDeposIni
         AND {&TableName}.cod-depos   <= pCodDeposFim
         AND {&TableName}.cod-localiz >= pCodLocalizIni
         AND {&TableName}.cod-localiz <= pCodLocalizFim
         AND {&TableName}.lote        >= pLoteIni
         AND {&TableName}.lote        <= pLoteFim
         AND {&TableName}.cod-refer   >= pCodReferIni
         AND {&TableName}.cod-refer   <= pCodReferFim
         AND {&tablename}.it-codigo   >= pItCodigoIni
         AND {&tablename}.it-codigo   <= pItCodigoFim
         AND {&TableName}.nr-ficha    >= pNrFichaIni
         AND {&TableName}.nr-ficha    <= pNrFichaFim,
       EACH item NO-LOCK
       WHERE item.it-codigo  = {&tablename}.it-codigo
         AND item.fm-codigo >= pFmCodigoIni
         AND item.fm-codigo <= pFmCodigoFim
         AND item.ge-codigo >= pGeCodigoIni
         AND item.ge-codigo <= pGeCodigoFim
       BY {&TableName}.nr-ficha:
       IF l-estab-security-active 
       AND NOT CAN-FIND(FIRST {&ESTAB-SEC-TT} 
                    WHERE {&ESTAB-SEC-TT-FIELD} = {&TableName}.cod-estabel) THEN
           NEXT. 

          IF NOT ({&TableName}.situacao = 2 AND pNaoDigitada)  AND
             NOT ({&TableName}.situacao = 3 AND pInventarioOK) AND
             NOT ({&TableName}.situacao = 4 AND pInventariar)  THEN NEXT.

          run pi-cria-tt-inventario-tela.
    
    end.

else if pClassificacao = 2 then
    FOR EACH {&TableName} NO-LOCK 
       WHERE {&TableName}.dt-saldo     = pDtSaldo
         AND {&TableName}.cdn-agrup    = pCdnAgrup
         AND {&TableName}.cod-estabel >= pCodEstabelIni
         AND {&TableName}.cod-estabel <= pCodEstabelFim
         AND {&TableName}.cod-depos   >= pCodDeposIni
         AND {&TableName}.cod-depos   <= pCodDeposFim
         AND {&TableName}.cod-localiz >= pCodLocalizIni
         AND {&TableName}.cod-localiz <= pCodLocalizFim
         AND {&TableName}.lote        >= pLoteIni
         AND {&TableName}.lote        <= pLoteFim
         AND {&TableName}.cod-refer   >= pCodReferIni
         AND {&TableName}.cod-refer   <= pCodReferFim
         AND {&tablename}.it-codigo   >= pItCodigoIni
         AND {&tablename}.it-codigo   <= pItCodigoFim
         AND {&TableName}.nr-ficha    >= pNrFichaIni
         AND {&TableName}.nr-ficha    <= pNrFichaFim,
       EACH item NO-LOCK
       WHERE item.it-codigo  = {&tablename}.it-codigo
         AND item.fm-codigo >= pFmCodigoIni
         AND item.fm-codigo <= pFmCodigoFim
         AND item.ge-codigo >= pGeCodigoIni
         AND item.ge-codigo <= pGeCodigoFim
       BY {&TableName}.cod-estabel
       BY {&TableName}.cod-depos
       BY {&TableName}.cod-localiz
       BY item.it-codigo
       BY {&TableName}.lote:
       IF l-estab-security-active 
       AND NOT CAN-FIND(FIRST {&ESTAB-SEC-TT} 
                    WHERE {&ESTAB-SEC-TT-FIELD} = {&TableName}.cod-estabel) THEN
           NEXT.

        IF NOT ({&TableName}.situacao = 2 AND pNaoDigitada)  AND
           NOT ({&TableName}.situacao = 3 AND pInventarioOK) AND
           NOT ({&TableName}.situacao = 4 AND pInventariar)  THEN NEXT.

        run pi-cria-tt-inventario-tela.
    end.

else 
   FOR EACH {&TableName} NO-LOCK 
       WHERE {&TableName}.dt-saldo     = pDtSaldo
         AND {&TableName}.cdn-agrup    = pCdnAgrup
         AND {&TableName}.cod-estabel >= pCodEstabelIni
         AND {&TableName}.cod-estabel <= pCodEstabelFim
         AND {&TableName}.cod-depos   >= pCodDeposIni
         AND {&TableName}.cod-depos   <= pCodDeposFim
         AND {&TableName}.cod-localiz >= pCodLocalizIni
         AND {&TableName}.cod-localiz <= pCodLocalizFim
         AND {&TableName}.lote        >= pLoteIni
         AND {&TableName}.lote        <= pLoteFim
         AND {&TableName}.cod-refer   >= pCodReferIni
         AND {&TableName}.cod-refer   <= pCodReferFim
         AND {&tablename}.it-codigo   >= pItCodigoIni
         AND {&tablename}.it-codigo   <= pItCodigoFim
         AND {&TableName}.nr-ficha    >= pNrFichaIni
         AND {&TableName}.nr-ficha    <= pNrFichaFim,
       EACH item NO-LOCK
       WHERE item.it-codigo  = {&tablename}.it-codigo
         AND item.fm-codigo >= pFmCodigoIni
         AND item.fm-codigo <= pFmCodigoFim
         AND item.ge-codigo >= pGeCodigoIni
         AND item.ge-codigo <= pGeCodigoFim
       BY {&TableName}.cod-estabel
       BY {&TableName}.cod-depos
       BY item.it-codigo
       BY {&TableName}.cod-localiz
       BY {&TableName}.lote:
       IF l-estab-security-active 
       AND NOT CAN-FIND(FIRST {&ESTAB-SEC-TT} 
                    WHERE {&ESTAB-SEC-TT-FIELD} = {&TableName}.cod-estabel) THEN
           NEXT.

        IF NOT ({&TableName}.situacao = 2 AND pNaoDigitada)  AND
           NOT ({&TableName}.situacao = 3 AND pInventarioOK) AND
           NOT ({&TableName}.situacao = 4 AND pInventariar)  THEN NEXT.

        run pi-cria-tt-inventario-tela.
   end.

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-inventario-tela DBOProgram 
PROCEDURE pi-cria-tt-inventario-tela :
/*------------------------------------------------------------------------------
  Purpose:     Browser do programa cep/ce0712.w
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

   create tt-inventario-tela.
   assign tt-inventario-tela.nr-ficha    = {&TableName}.nr-ficha
          tt-inventario-tela.cod-estabel = {&TableName}.cod-estabel
          tt-inventario-tela.it-codigo   = {&tablename}.it-codigo
          tt-inventario-tela.lote        = {&TableName}.lote
          tt-inventario-tela.cod-refer   = {&TableName}.cod-refer
          tt-inventario-tela.cod-depos   = {&TableName}.cod-depos
          tt-inventario-tela.cod-localiz = {&TableName}.cod-localiz
          tt-inventario-tela.val-apurado = {&TableName}.val-apurado[1]
          tt-inventario-tela.valor-mat   = {&TableName}.valor-mat-m[1]
          tt-inventario-tela.valor-mob   = {&TableName}.valor-mob-m[1]
          tt-inventario-tela.valor-ggf   = {&TableName}.valor-ggf-m[1]
          tt-inventario-tela.dt-valid    = {&TableName}.dt-ult-entra
   .
   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
       DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
       ASSIGN cAuxTraducao001 = {ininc/i01in157.i 04 {&TableName}.
       run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                           INPUT "",
                           INPUT "").
       ASSIGN tt-inventario-tela.situacao    = RETURN-VALUE.situacao} no-error.
   &else
       ASSIGN tt-inventario-tela.situacao    = {ininc/i01in157.i 04 {&TableName}.situacao} no-error.
   &endif
    

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryInclui DBOProgram 
PROCEDURE openQueryInclui :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query para inclus∆o de registros utilizada por wce0712c.w
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    &SCOPED-DEFINE OPEN-QUERY-{&QueryName}-IN OPEN QUERY {&QueryName} ~
        FOR  EACH {&ESTAB-SEC-TT} NO-LOCK,~
             EACH {&TableName} NO-LOCK ~
            WHERE {&TableName}.dt-saldo = da-dt-saldo, ~
           FIRST item ~
           WHERE item.it-codigo = {&tablename}.it-codigo NO-LOCK ~
             .

    &SCOPED-DEFINE OPEN-QUERY-{&QueryName}-AT OPEN QUERY {&QueryName} ~
        FOR EACH {&ESTAB-SEC-TT} NO-LOCK,~
            EACH {&TableName} NO-LOCK ~
           WHERE {&TableName}.cod-estabel = {&ESTAB-SEC-TT-FIELD} ~
             AND {&TableName}.dt-saldo = da-dt-saldo, ~
           FIRST item ~
           WHERE item.it-codigo = {&tablename}.it-codigo NO-LOCK ~
            .

    {include/i-estab-openquery.i}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDataSaldo DBOProgram 
PROCEDURE setConstraintDataSaldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pDtSaldo       LIKE inventario.dt-saldo    NO-UNDO.    

    ASSIGN da-dt-saldo = pDtSaldo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDigInvent DBOProgram 
PROCEDURE setConstraintDigInvent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pDtSaldo       LIKE inventario.dt-saldo    NO-UNDO.
    DEFINE INPUT PARAMETER pCodEstabelIni LIKE inventario.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pCodEstabelFim LIKE inventario.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pGeCodigoIni   AS INTEGER                  NO-UNDO.
    DEFINE INPUT PARAMETER pGeCodigoFim   AS INTEGER                  NO-UNDO.
    DEFINE INPUT PARAMETER pFmCodigoIni   AS CHARACTER                NO-UNDO.
    DEFINE INPUT PARAMETER pFmCodigoFim   AS CHARACTER                NO-UNDO.
    DEFINE INPUT PARAMETER pCodDeposIni   LIKE inventario.cod-depos   NO-UNDO.
    DEFINE INPUT PARAMETER pCodDeposFim   LIKE inventario.cod-depos   NO-UNDO.
    DEFINE INPUT PARAMETER pCodLocalizIni LIKE inventario.cod-localiz NO-UNDO.
    DEFINE INPUT PARAMETER pCodLocalizFim LIKE inventario.cod-localiz NO-UNDO.
    DEFINE INPUT PARAMETER pLoteIni       LIKE inventario.lote        NO-UNDO.
    DEFINE INPUT PARAMETER pLoteFim       LIKE inventario.lote        NO-UNDO.
    DEFINE INPUT PARAMETER pItCodigoIni   LIKE inventario.it-codigo   NO-UNDO.
    DEFINE INPUT PARAMETER pItCodigoFim   LIKE inventario.it-codigo   NO-UNDO.
    DEFINE INPUT PARAMETER pNrFichaIni    LIKE inventario.nr-ficha    NO-UNDO.
    DEFINE INPUT PARAMETER pNrFichaFim    LIKE inventario.nr-ficha    NO-UNDO.
    DEFINE INPUT PARAMETER pDigitacao     AS INTEGER                  NO-UNDO.
    DEFINE INPUT PARAMETER pNaoDigitada   AS LOGICAL                  NO-UNDO.
    DEFINE INPUT PARAMETER pOkAtualizar   AS LOGICAL                  NO-UNDO.
    DEFINE INPUT PARAMETER pAtualizada    AS LOGICAL                  NO-UNDO.
    DEFINE INPUT PARAMETER pDigitada      AS LOGICAL                  NO-UNDO.
    DEFINE INPUT PARAMETER pInventariada  AS LOGICAL                  NO-UNDO.
    DEFINE INPUT PARAMETER pItemObsoleto  AS LOGICAL                  NO-UNDO.

    ASSIGN da-dt-saldo       = pDtSaldo
           c-cod-estabel-ini = pCodEstabelIni
           c-cod-estabel-fim = pCodEstabelFim
           i-ge-codigo-ini   = pGeCodigoIni
           i-ge-codigo-fim   = pGeCodigoFim
           c-fm-codigo-ini   = pFmCodigoIni
           c-fm-codigo-fim   = pFmCodigoFim
           c-cod-depos-ini   = pCodDeposIni
           c-cod-depos-fim   = pCodDeposFim
           c-cod-localiz-ini = pCodLocalizIni
           c-cod-localiz-fim = pCodLocalizFim
           c-lote-ini        = pLoteIni
           c-lote-fim        = pLoteFim
           c-it-codigo-ini   = pItCodigoIni
           c-it-codigo-fim   = pItCodigoFim
           i-nr-ficha-ini    = pNrFichaIni
           i-nr-ficha-fim    = pNrFichaFim
           i-contagem        = pDigitacao
           l-nao-digitada    = pNaoDigitada
           l-ok-atualizar    = pOkAtualizar
           l-atualizada      = pAtualizada
           l-digitada        = pDigitada
           l-inventariada    = pInventariada
           l-conf-obsoleto   = pItemObsoleto.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintValidValues DBOProgram 
PROCEDURE setConstraintValidValues :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-not-valid-values  AS LOGICAL NO-UNDO.

    ASSIGN l-valid-values = p-not-valid-values.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintInclui DBOProgram 
PROCEDURE setConstraintInclui :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pContagem AS INTEGER NO-UNDO.

    ASSIGN i-contagem = pContagem.

    RETURN "OK":U.
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
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConfObsoleto DBOProgram 
PROCEDURE setConfObsoleto  :
/*------------------------------------------------------------------------------
  Purpose:  Seta variavel l-conf-obsoleto   
          
  Parameters:  
  Notes:   
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pConfObsoleto AS LOG NO-UNDO.
    DEFINE OUTPUT PARAMETER pLogObsoleto  AS LOG NO-UNDO.

    /* Seta como YES p/ n∆o retornar a mensagem 1779 da procedure validateRecord */
    ASSIGN l-conf-obsoleto = pConfObsoleto.

    IF NOT AVAIL RowObject THEN
       RETURN "NOK":U.

    RUN findItemUniEstab IN THIS-PROCEDURE (INPUT RowObject.it-codigo,
                                            INPUT ROwObject.cod-estabel).

    ASSIGN pLogObsoleto = IF AVAIL item-uni-estab AND 
                                   item-uni-estab.cod-obsoleto = 4 THEN YES
                          ELSE NO. 

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram
PROCEDURE validateRecord :
/*-----------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE da-fim-per-inv LIKE inventario.dt-saldo NO-UNDO.
    DEFINE VARIABLE da-mensal-ate  LIKE inventario.dt-saldo NO-UNDO.

    DEFINE VARIABLE i-cont         AS INTEGER NO-UNDO.
    

    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
                                       
    RUN findEstabelec IN THIS-PROCEDURE (INPUT RowObject.cod-estabel).

    RUN findItem      IN THIS-PROCEDURE (INPUT RowObject.it-codigo).

    RUN findItemEstab IN THIS-PROCEDURE (INPUT RowObject.it-codigo,
                                         INPUT RowObject.cod-estabel).

    RUN findItemUniEstab IN THIS-PROCEDURE (INPUT RowObject.it-codigo,
                                            INPUT ROwObject.cod-estabel).
											
	FIND FIRST param-estoq NO-LOCK NO-ERROR.
											
    IF  pType = "Update":U THEN DO:
        /* VERIFICA DATA FINAL DO PERIODO DO INVENTARIO  - RETORNA ULTIMO DIA DO MES */
        ASSIGN da-fim-per-inv = IF  MONTH(RowObject.dt-saldo) = 12 THEN DATE(01,01,YEAR(RowObject.dt-saldo) + 1) - 1
                                                                   ELSE DATE(MONTH(RowObject.dt-saldo) + 1,01,
                                                                   YEAR(RowObject.dt-saldo)) - 1.

        IF AVAIL item THEN DO:
            IF item.tipo-con-est >= 3  AND
               i-contagem         = 1  AND
               RowObject.lote     = "" THEN DO:
                {method/svc/errors/inserr.i
                                    &ErrorNumber="4478" /* Item e' controlado por Lote ou Referencia - Lote nao deve ser branco */
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"}
            END.
        END.

        /* Conforme ce0702 - busca valores antes da atualizaá∆o */
        FOR FIRST b-invent WHERE b-invent.dt-saldo    = RowObject.dt-saldo    AND
                                 b-invent.cod-estabel = RowObject.cod-estabel AND
                                 b-invent.cod-depos   = RowObject.cod-depos   AND
                                 b-invent.cod-localiz = RowObject.cod-localiz AND
                                 b-invent.lote        = RowObject.lote        AND
                                 b-invent.it-codigo   = RowObject.it-codigo   AND 
                                 b-invent.cod-refer   = RowObject.cod-refer   NO-LOCK: END.
        IF RowObject.situacao = 1 THEN DO:
            {method/svc/errors/inserr.i
                                &ErrorNumber="4493" /*Invent†rio j† atualizado */
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"}
        END.
        ELSE IF RowObject.situacao = 3 THEN DO:
            {method/svc/errors/inserr.i
                                &ErrorNumber="4494" /*Invent†rio j† est† OK */
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"}
        END.
        ELSE IF AVAIL b-invent AND 
               ( (RowObject.situacao = 4 AND b-invent.valor-final <> 0) OR
                 (RowObject.situacao = 4 AND b-invent.val-apurado[1] = 0 AND b-invent.val-apurado[2] = 0) OR
                 (RowObject.situacao = 4 AND b-invent.val-apurado[3] = 0) ) THEN DO:
            {method/svc/errors/inserr.i
                                &ErrorNumber="4495" /*Invent†rio j† est† OK para atualizar */
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"}
        END.
   END.

    IF pType = "CREATE":U
    OR pType = "UPDATE":U THEN DO:
        
        IF pType = "CREATE":U THEN DO:
        
            FIND FIRST bf{&TableName} WHERE 
                 bf{&TableName}.dt-saldo = RowObject.dt-saldo AND
                 bf{&TableName}.nr-ficha = RowObject.nr-ficha NO-LOCK NO-ERROR.
                
                IF AVAIL bf{&TableName} THEN DO:
                    IF NOT AVAIL ttInventario OR ttInventario.r-rowid <> ROWID(bf{&TableName}) THEN DO:
                        /* J† existe ocorrància do registro */
                        /* Inicio -- Projeto Internacional */   
                         DEFINE VARIABLE c-lbl-liter-ficha-para-data AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "ficha_para_data" *}
                        ASSIGN c-lbl-liter-ficha-para-data = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i
                                            &ErrorNumber="57524"
                                            &ErrorType="EMS"
                                            &ErrorParameters="' ' + c-lbl-liter-ficha-para-data + ' '"
                                            &ErrorSubType="WARNING"}
                     
                   END.
                END. 
                        
            FIND bf{&TableName}
                 WHERE bf{&TableName}.dt-saldo    = RowObject.dt-saldo
                   AND bf{&TableName}.cod-estabel = RowObject.cod-estabel
                   AND bf{&TableName}.cod-depos   = RowObject.cod-depos
                   AND bf{&TableName}.cod-localiz = RowObject.cod-localiz
                   AND bf{&TableName}.lote        = RowObject.lote
                   AND bf{&tablename}.it-codigo   = RowObject.it-codigo
                   AND bf{&TableName}.cod-refer   = RowObject.cod-refer NO-LOCK NO-ERROR.
            IF AVAIL bf{&TableName} THEN DO:
                /* J† existe ocorrància do registro */
                                           
                /* Inicio -- Projeto Internacional */
                {method/svc/errors/inserr.i
                                    &ErrorNumber="30528"
                                    &ErrorType="EMS"
                                    &ErrorParameters="string(bf{&TableName}.nr-ficha)"
                                    &ErrorSubType="ERROR"}
                                    
                    RETURN "NOK".
            END.
                          
            IF  RowObject.cdn-agrup <> 0 
            AND RowObject.cdn-agrup <> ? THEN DO:
                IF NOT CAN-FIND(FIRST agrup-invent 
                                WHERE agrup-invent.cdn-agrup = RowObject.cdn-agrup) THEN DO:                
                    {utp/ut-liter.i "Agrupador_Invent†rio"}
                    {method/svc/errors/inserr.i
                                &ErrorNumber="2"
                                &ErrorParameters="RETURN-VALUE"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"}
                    
                END.
            END.
            
        END.

        IF RowObject.dt-saldo = ? THEN DO:
            /* data de saldo para inventariar deve ser diferente de branco */
            {method/svc/errors/inserr.i
                                &ErrorNumber="4370"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"}
        END.

        IF NOT CAN-FIND(FIRST deposito WHERE 
                              deposito.cod-depos = RowObject.cod-depos) THEN DO:
            /* Dep¢sito n∆o cadastrado */
            {method/svc/errors/inserr.i
                                &ErrorNumber="530"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"}
        END.

        &if defined(bf_mat_fech_estab) &then
            IF param-estoq.tp-fech = 2 THEN DO:

                IF AVAIL estabelec THEN
                   RUN findEstabMat IN THIS-PROCEDURE (INPUT estabelec.cod-estabel).

                IF  AVAIL estab-mat THEN
                    ASSIGN da-mensal-ate = estab-mat.mensal-ate.
            END.
            ELSE
                ASSIGN da-mensal-ate = param-estoq.mensal-ate.
        &else
            ASSIGN da-mensal-ate = param-estoq.mensal-ate.
        &endif

        FIND FIRST b-movto 
             WHERE b-movto.it-codigo   = RowObject.it-codigo
               AND b-movto.cod-estabel = RowObject.cod-estabel 
               AND b-movto.esp-docto   = 1
               AND b-movto.dt-trans    > da-mensal-ate
               AND b-movto.dt-trans   <= da-fim-per-inv NO-LOCK NO-ERROR.

        IF  NOT AVAIL b-movto AND AVAIL item THEN DO:
            FIND FIRST c-movto 
                 WHERE c-movto.it-codigo   = RowObject.it-codigo
                   AND c-movto.cod-estabel = RowObject.cod-estabel 
                   AND c-movto.esp-docto   = 21
                   AND c-movto.dt-trans    > da-mensal-ate
                   AND c-movto.dt-trans   <= da-fim-per-inv NO-LOCK NO-ERROR.

            IF NOT AVAIL c-movto 
                AND (avail item and item.tipo-contr = 2)
                AND l-valid-values

                AND (NOT AVAIL item-estab

                     OR (AVAIL item-estab
                          AND  item-estab.val-unit-mat-m[1] +
                               item-estab.val-unit-mob-m[1] +
                               item-estab.val-unit-ggf-m[1] = 0
                          AND  AVAIL estabelec 
                          AND estabelec.custo-contab = 1)
                     OR (AVAIL item-estab 
                          AND  item-estab.val-unit-mat-o[1] +
                               item-estab.val-unit-mob-o[1] +
                               item-estab.val-unit-ggf-o[1] = 0
                          AND  AVAIL estabelec 
                          AND  estabelec.custo-contab = 2)
                     OR (AVAIL item-estab
                          AND  item-estab.val-unit-mat-p[1] +
                               item-estab.val-unit-mob-p[1] +
                               item-estab.val-unit-ggf-p[1] = 0 
                          AND  AVAIL estabelec 
                          AND estabelec.custo-contab = 3) )

                AND ( (i-contagem = 1
                       AND RowObject.val-apurado[1] <> RowObject.qtidade-atu)
                   OR (i-contagem = 2
                       AND  RowObject.val-apurado[2] <> RowObject.qtidade-atu)
                   OR (i-contagem = 3
                       AND  RowObject.val-apurado[3] <> RowObject.qtidade-atu)
                   OR (i-contagem = 4
                       AND (RowObject.val-apurado[1] <> RowObject.qtidade-atu
                        OR  RowObject.val-apurado[2] <> RowObject.qtidade-atu
                        OR  RowObject.val-apurado[3] <> RowObject.qtidade-atu) ) )  

                AND (  ( i-contagem = 4 and ( RowObject.valor-mat-m[1] + 
                                              RowObject.valor-ggf-m[1] + 
                                              RowObject.valor-mob-m[1] = 0 ))  OR
                      
                       ( i-contagem < 4 and ( RowObject.valor-mat-m[i-contagem] + 
                                              RowObject.valor-mob-m[i-contagem] +
                                              RowObject.valor-ggf-m[i-contagem] = 0 )) 
                     ) THEN DO:

                 /* Um dos valores deve ser maior que zero */
                {method/svc/errors/inserr.i
                                    &ErrorNumber="4554"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"}
            END.

            IF i-contagem < 4 THEN
            IF NOT AVAIL c-movto
                AND (avail item and item.tipo-contr = 2)
                AND (NOT AVAIL item-estab
                     OR (AVAIL item-estab
                          AND  item-estab.val-unit-mat-m[1] +
                               item-estab.val-unit-mob-m[1] +
                               item-estab.val-unit-ggf-m[1] = 0 ))
                AND RowObject.val-apurado[i-contagem] <> RowObject.qtidade-atu 
                AND (RowObject.valor-mat-m[i-contagem] + RowObject.valor-mob-m[i-contagem] + RowObject.valor-ggf-m[i-contagem] <> 0)  THEN 
                /* Conforme ce0702 - pi-assign */
                ASSIGN RowObject.valor-mat-m[1] = RowObject.valor-mat-m[i-contagem]
                       RowObject.valor-mob-m[1] = RowObject.valor-mob-m[i-contagem]
                       RowObject.valor-ggf-m[1] = RowObject.valor-ggf-m[i-contagem].
        END.

        IF AVAIL item-uni-estab THEN DO:

            IF  item-uni-estab.loc-unica AND NOT l-loc-unica-mult
            AND item-uni-estab.cod-localiz <> RowObject.cod-localiz  THEN DO:
                
                /* Item Possui Localizacao Unica Diferente da Localizacao Informada */
                {method/svc/errors/inserr.i
                                    &ErrorNumber="4898"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"}
            END.
                
            IF  item-uni-estab.cod-obsoleto = 4 AND NOT l-conf-obsoleto THEN DO:
                {method/svc/errors/inserr.i
                                    &ErrorNumber="1779"
                                    &ErrorType="EMS"
                                    &ErrorSubType="WARNING"}
            END.
        END.
        
        IF  AVAIL item THEN DO:
            
            IF item.tipo-contr = 4 THEN DO:
                /* Item n∆o pode ser consignado/debito direto */
                {method/svc/errors/inserr.i
                                    &ErrorNumber="4508"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"}
            END.

            IF item.tipo-con-est <> 4 /*Validaá∆o da API de Invent†rio*/
            AND RowObject.cod-refer <> "" THEN DO:
                {method/svc/errors/inserr.i
                                    &ErrorNumber="16540"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"}
            END.
            IF  item.tipo-con-est = 4
            AND item.tipo-contr <> 4 THEN DO:
                FIND FIRST referencia
                     WHERE referencia.cod-refer = RowObject.cod-refer NO-LOCK NO-ERROR.

                IF NOT AVAIL referencia THEN DO:
                    /* Referància n∆o cadastrada */
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="4539"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}
                END.
            END. 
            IF  item.tipo-con-est = 4 THEN DO:
                FIND FIRST ref-item
                     WHERE ref-item.it-codigo = RowObject.it-codigo
                       AND ref-item.cod-refer = RowObject.cod-refer NO-LOCK NO-ERROR.
                IF NOT AVAIL ref-item THEN DO:
                    /*Referància n∆o relacionado ao item (cd1506)*/
                    {method/svc/errors/inserr.i
                                            &ErrorNumber="33928"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters = "RowObject.cod-refer + '~~~~' + RowObject.it-codigo" }
                END.
            END.


            DEF VAR c-return AS CHAR NO-UNDO.
            RUN piRetornaValor (INPUT "Update", INPUT "dt-vali-lote", OUTPUT c-return).

            if item.tipo-con-est >= 3 and RowObject.lote = "" then do:
                 /* Item controlado por lote ou referància. cod do lote deve ser informada */
                {method/svc/errors/inserr.i
                                    &ErrorNumber="2158"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"}
            end.
            
            IF  item.tipo-con-est >= 3 
            AND ( RowObject.dt-ult-entra = ? AND c-return = ?) THEN DO:
                /* Item controlado por lote ou referància. data validade do lote deve ser informada */
                {method/svc/errors/inserr.i
                                    &ErrorNumber="4542"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"}
            END.

            /*API Invent†rio - Valida data de Validade do Lote*/
            IF  item.tipo-con-est >= 3 
            AND (c-return <> ? AND c-return <> "")
            AND (RowObject.dt-ult-entra <> date(c-return)) THEN DO:
                DEFINE VARIABLE c-lbl-liter-valid-lote AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "de_validade_do_lote" *}
                ASSIGN c-lbl-liter-valid-lote = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                    &ErrorNumber="15370"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="'' + c-lbl-liter-valid-lote + ''"}
            END.

            FIND FIRST localizacao 
                 WHERE localizacao.cod-estabel = RowObject.cod-estabel 
                   AND localizacao.cod-depos   = RowObject.cod-depos
                   AND localizacao.cod-localiz = RowObject.cod-localiz NO-LOCK NO-ERROR.

            IF NOT AVAIL localizacao AND NOT l-loc-unica-mult THEN DO:
                /* localizaá∆o n∆o cadastrada para o dep¢sito/estabelecimento */
                {method/svc/errors/inserr.i
                                    &ErrorNumber="16001"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"}
            END.
            
            IF  item.tipo-con-est = 1 
            AND RowObject.lote <> " " THEN DO:
                /* Item n∆o controlado por Lote ou Referància - Lote deve ser Branco */
                {method/svc/errors/inserr.i
                                    &ErrorNumber="17880"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"}
            END.
                
            IF  item.tipo-con-est = 2
            AND RowObject.lote = " " THEN DO:
                /* Item controlado por Serie. Deve ser informada */
                {method/svc/errors/inserr.i
                                    &ErrorNumber="8829"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"}
            END.
            
        END.
                      
        IF  i-contagem > 1 
        AND i-contagem < 4 THEN
            IF RowObject.val-apurado[i-contagem - 1] = ? THEN DO:
            /* Contagem anterior n∆o foi digitada */
            {method/svc/errors/inserr.i
                                &ErrorNumber="4496"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"}
            END.

        CASE i-contagem:
            WHEN 1 OR
            WHEN 2 OR
            WHEN 3 THEN DO:
                /* Contagem n∆o pode ser desconhecido */
                IF RowObject.val-apurado[i-contagem] = ? THEN DO:
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="56778"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}
                END.

                IF  TRUNCATE(RowObject.val-apurado[i-contagem],0) <> RowObject.val-apurado[i-contagem]
                AND (AVAIL item 
                    AND NOT item.fraciona) THEN DO:
                    /* Item n∆o aceita quantidade fracionada */
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="4559"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}
                END.

                /*API Invent†rio - Contagem n∆o pode ser negativa*/
                IF (RowObject.val-apurado[i-contagem] < 0) THEN DO:
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="1790"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}
                END.

                IF (RowObject.val-apurado[i-contagem] <> 1  AND
                    RowObject.val-apurado[i-contagem] <> 0) AND
                    (avail item and item.tipo-con-est = 2) THEN DO:
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="17875"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}
                END.
            END.
            WHEN 4 THEN DO:
                DO i-cont = 1 TO 3:
                    IF RowObject.val-apurado[1] <> RowObject.val-apurado[2] THEN DO:
                        IF RowObject.val-apurado[i-cont] = ? THEN DO:
                            {method/svc/errors/inserr.i
                                                &ErrorNumber="56778"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"}
                        END.
                    END.
                    ELSE DO:
                        IF param-estoq.cons-invent = 2 AND /* Contagem */
                           i-cont < 3 THEN DO:
                            IF RowObject.val-apurado[i-cont] = ? THEN DO:
                                {method/svc/errors/inserr.i
                                                    &ErrorNumber="56778"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"}
                            END.
                        END.
                    END.

                    IF  TRUNCATE(RowObject.val-apurado[i-cont],0) <> RowObject.val-apurado[i-cont]
                    AND (AVAIL item 
                        AND NOT item.fraciona) THEN DO:
                        /* Item n∆o aceita quantidade fracionada */
                        {method/svc/errors/inserr.i
                                            &ErrorNumber="4559"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"}
                    END.

                    IF RowObject.val-apurado[1] <> RowObject.val-apurado[2] THEN DO:                    
                        IF (RowObject.val-apurado[i-cont] <> 1  AND
                            RowObject.val-apurado[i-cont] <> 0) AND
                            (avail item and item.tipo-con-est = 2) THEN DO:
                            {method/svc/errors/inserr.i
                                                &ErrorNumber="17875"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"}
                        END.
                    END.
                    ELSE DO:
                        IF param-estoq.cons-invent = 2 AND /* Contagem */
                           i-cont < 3 THEN DO:
                            IF (RowObject.val-apurado[i-cont] <> 1  AND
                                RowObject.val-apurado[i-cont] <> 0) AND
                                (avail item and item.tipo-con-est = 2) THEN DO:
                                {method/svc/errors/inserr.i
                                                    &ErrorNumber="17875"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"}
                            END.
                        END.
                    END.
                END.
            END.
        END CASE.


        IF NOT AVAIL item-estab THEN DO:
            CREATE item-estab.
            ASSIGN item-estab.it-codigo    = RowObject.it-codigo
                   item-estab.cod-estabel  = RowObject.cod-estabel
                   item-estab.deposito-pad = RowObject.cod-depos.
            /* RUN pi-cria-tt-dados-smc IN THIS-PROCEDURE. Ver comentario na implementaá∆o da procedure, abaixo */
        END.

        ASSIGN RowObject.dt-ult-saida  = IF AVAIL item 
                                             THEN item.data-ult-sai
                                             ELSE ?.
    END.

    IF AVAIL item-uni-estab AND item-uni-estab.loc-unica THEN
         FIND FIRST saldo-estoq
             WHERE saldo-estoq.cod-estabel = RowObject.cod-estabel
               AND saldo-estoq.cod-depos   = RowObject.cod-depos
               AND saldo-estoq.cod-localiz = item-uni-estab.cod-localiz
               AND saldo-estoq.lote        = RowObject.lote
               AND saldo-estoq.it-codigo   = RowObject.it-codigo 
               AND saldo-estoq.cod-refer   = RowObject.cod-refer EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
    ELSE   
         FIND FIRST saldo-estoq
             WHERE saldo-estoq.cod-estabel = RowObject.cod-estabel
               AND saldo-estoq.cod-depos   = RowObject.cod-depos
               AND saldo-estoq.cod-localiz = RowObject.cod-localiz
               AND saldo-estoq.lote        = RowObject.lote
               AND saldo-estoq.it-codigo   = RowObject.it-codigo 
               AND saldo-estoq.cod-refer   = RowObject.cod-refer EXCLUSIVE-LOCK NO-WAIT NO-ERROR.

    IF LOCKED(saldo-estoq) THEN DO WHILE LOCKED(saldo-estoq):
        {method/svc/errors/inserr.i
                            &ErrorNumber="27617"
                            &ErrorType="EMS"
                            &ErrorParameters = "RowObject.it-codigo + '~~~~' + 'saldo-estoq'"
                            &ErrorSubType="ERROR"}
        RETURN "NOK":U.
    END.
   
    IF NOT CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
       
       IF pType = "CREATE":U THEN DO:
          FIND FIRST bf{&TableName} WHERE 
                    bf{&TableName}.dt-saldo = RowObject.dt-saldo AND
                    bf{&TableName}.nr-ficha = RowObject.nr-ficha NO-LOCK NO-ERROR.
                
          IF AVAIL bf{&TableName} THEN DO:
             IF NOT AVAIL ttInventario OR ttInventario.r-rowid <> ROWID(bf{&TableName}) THEN DO:
                            /* J† existe ocorrància do registro */
                    
                RUN geraNumeroFicha(OUTPUT iNumNewFicha).
                                            
                {method/svc/errors/inserr.i 
                                    &ErrorNumber="57523"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="INFORMATION":U
                                    &ErrorParameters="TRIM(STRING(iNumOldFicha)) + '~~~~' + STRING(iNumNewFicha)"}
                                                                 
             END.
          END. 
       END. 
       IF pType <> "CREATE":U THEN DO:
          /* Atualiza saldo - quando pType = "CREATE", a procedure piCalculaSaldo Ç chamada diretamente do programa (ce0712) */
          RUN piCalculaSaldo (INPUT pType, INPUT RowObject.r-rowid).
       END.
       
       RUN piAtualizaSaldoEstoq IN THIS-PROCEDURE (INPUT RowObject.cod-refer).
    END.
   
    /*--- Verifica ocorrància de erros ---*/
    
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
       RETURN "NOK":U.

    RELEASE saldo-estoq.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraNumeroFicha DBOProgram 
PROCEDURE geraNumeroFicha :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pNrFicha AS INTEGER NO-UNDO.
  
  FIND LAST bf{&TableName} USE-INDEX nr-ficha WHERE
            bf{&TableName}.dt-saldo = RowObject.dt-saldo NO-LOCK NO-ERROR.

        IF AVAIL bf{&TableName} THEN DO:
            IF bf{&TableName}.nr-ficha < 9999999 THEN DO:
                
                ASSIGN iNumOldFicha = RowObject.nr-ficha.
                ASSIGN i-dif = bf{&TableName}.nr-ficha - RowObject.nr-ficha.
                
                    ASSIGN pNrFicha = RowObject.nr-ficha + i-dif + 1.
                    ASSIGN RowObject.nr-ficha = pNrFicha.
            END.
            ELSE DO:
                {method/svc/errors/inserr.i
                                    &ErrorNumber="4491"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"}
            END.
        END.


END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setLocUnica DBOProgram 
PROCEDURE setLocUnica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-loc-unica-mult AS LOG NO-UNDO.

assign l-loc-unica-mult = p-loc-unica-mult.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCalculaSaldo DBOProgram 
PROCEDURE piCalculaSaldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-acao  AS CHAR  NO-UNDO.
    DEF INPUT PARAM p-rowid AS ROWID NO-UNDO.

    DEF VAR i-cont  AS INT NO-UNDO.
    DEF VAR l-flag  AS LOG NO-UNDO.

    /* Atualiza saldo */
    RUN cep/ce0799.p (INPUT p-rowid).

    FOR FIRST bf{&TableName} WHERE 
        ROWID(bf{&TableName}) = p-rowid EXCLUSIVE-LOCK: END.

    IF NOT AVAIL bf{&TableName} THEN
       RETURN "NOK":U.

    IF p-acao <> "CREATE":U THEN do:
       IF NOT AVAIL RowObject THEN
          RETURN "NOK":U.
       BUFFER-COPY RowObject USING val-apurado qtidade-atu valor-final TO bf{&TableName}.
    END.
       
    IF NOT AVAIL param-estoq THEN
       FOR FIRST param-estoq NO-LOCK: END.

    IF i-contagem = 1 THEN DO:
        IF  bf{&TableName}.val-apurado[1] = bf{&TableName}.qtidade-atu 
        AND param-estoq.cons-invent  = 1 THEN
            ASSIGN bf{&TableName}.valor-final = bf{&TableName}.val-apurado[1]
                   bf{&TableName}.situacao    = (IF NOT CAN-FIND(FIRST RowErrors 
                                                             WHERE RowErrors.ErrorSubType = "ERROR":U) THEN 3
                                                              ELSE bf{&TableName}.situacao).
        ELSE DO:
            ASSIGN bf{&TableName}.valor-final = 0.
                   bf{&TableName}.situacao    = (IF NOT CAN-FIND(FIRST RowErrors 
                                                             WHERE RowErrors.ErrorSubType = "ERROR":U) THEN 4
                                                              ELSE bf{&TableName}.situacao).

            IF  (bf{&TableName}.val-apurado[1] = bf{&TableName}.val-apurado[2]) 
            OR  (bf{&TableName}.val-apurado[1] = bf{&TableName}.val-apurado[3]) THEN 
                ASSIGN bf{&TableName}.valor-final = bf{&TableName}.val-apurado[1].
            ELSE
                IF  bf{&TableName}.val-apurado[2] <> ? 
                AND bf{&TableName}.val-apurado[2] = bf{&TableName}.val-apurado[3] THEN  
                    ASSIGN bf{&TableName}.valor-final = bf{&TableName}.val-apurado[2].
                ELSE
                    IF bf{&TableName}.val-apurado[3] <> ? THEN
                        ASSIGN bf{&TableName}.valor-final = bf{&TableName}.val-apurado[3].
        END.
        
    END.
    ELSE DO:
        IF i-contagem = 2 THEN DO:
            IF  bf{&TableName}.val-apurado[2] = bf{&TableName}.qtidade-atu 
            AND param-estoq.cons-invent  = 1 THEN
                ASSIGN bf{&TableName}.valor-final = bf{&TableName}.val-apurado[2]
                       bf{&TableName}.situacao    = (IF NOT CAN-FIND(FIRST RowErrors 
                                                                 WHERE RowErrors.ErrorSubType = "ERROR":U) THEN 3
                                                                  ELSE bf{&TableName}.situacao).

            ELSE DO:
                ASSIGN bf{&TableName}.valor-final = 0
                       bf{&TableName}.situacao    = (IF NOT CAN-FIND(FIRST RowErrors 
                                                                 WHERE RowErrors.ErrorSubType = "ERROR":U) THEN 4
                                                                  ELSE bf{&TableName}.situacao).
                IF  bf{&TableName}.val-apurado[2] = bf{&TableName}.val-apurado[1]
                OR  bf{&TableName}.val-apurado[2] = bf{&TableName}.val-apurado[3] THEN
                    ASSIGN bf{&TableName}.valor-final = bf{&TableName}.val-apurado[2].
                ELSE 
                    IF bf{&TableName}.val-apurado[3] <> ? THEN 
                        ASSIGN bf{&TableName}.valor-final = bf{&TableName}.val-apurado[3].
            END.
        END.
        ELSE DO:
            IF i-contagem = 3 THEN DO:
                IF  bf{&TableName}.val-apurado[3] = bf{&TableName}.qtidade-atu 
                AND param-estoq.cons-invent  = 1 THEN
                    ASSIGN bf{&TableName}.valor-final = bf{&TableName}.val-apurado[3]
                           bf{&TableName}.situacao    = (IF NOT CAN-FIND(FIRST RowErrors 
                                                                     WHERE RowErrors.ErrorSubType = "ERROR":U) THEN 3
                                                                      ELSE bf{&TableName}.situacao).

                ELSE
                    IF bf{&TableName}.val-apurado[1] <> bf{&TableName}.val-apurado[2] THEN
                        ASSIGN bf{&TableName}.valor-final = bf{&TableName}.val-apurado[3]
                               bf{&TableName}.situacao    = (IF NOT CAN-FIND(FIRST RowErrors 
                                                                         WHERE RowErrors.ErrorSubType = "ERROR":U) THEN 4
                                                                          ELSE bf{&TableName}.situacao).
            END.
        END.
    END.

    IF  i-contagem > 1 AND
        i-contagem < 4 THEN DO:
         DO i-cont = 1 TO i-contagem:
                IF  bf{&TableName}.val-apurado[i-cont] = bf{&TableName}.qtidade-atu 
                AND param-estoq.cons-invent = 1 THEN
                    ASSIGN bf{&TableName}.valor-final = bf{&TableName}.val-apurado[i-cont]
                           bf{&TableName}.situacao    = (IF NOT CAN-FIND(FIRST RowErrors 
                                                                     WHERE RowErrors.ErrorSubType = "ERROR":U) THEN 3
                                                                      ELSE bf{&TableName}.situacao).
         END.
    END.
    
    ELSE IF i-contagem = 4 THEN DO:
        IF param-estoq.cons-invent = 1 THEN DO: /* Saldo */
            DO i-cont = 1 TO 3:
                IF  bf{&TableName}.val-apurado[i-cont] = bf{&TableName}.qtidade-atu
                AND bf{&TableName}.val-apurado[i-cont] <> ? THEN
                    ASSIGN l-flag                = YES
                           bf{&TableName}.valor-final = bf{&TableName}.val-apurado[i-cont]
                           bf{&TableName}.situacao    = (IF NOT CAN-FIND(FIRST RowErrors 
                                                                     WHERE RowErrors.ErrorSubType = "ERROR":U) THEN 3
                                                                      ELSE bf{&TableName}.situacao).
            END.
            IF NOT l-flag THEN DO:
                ASSIGN bf{&TableName}.valor-final = 0
                       bf{&TableName}.situacao    = (IF NOT CAN-FIND(FIRST RowErrors 
                                                                 WHERE RowErrors.ErrorSubType = "ERROR":U) THEN 4
                                                                  ELSE bf{&TableName}.situacao).
            END.
        END.
    END.

    IF AVAIL param-estoq THEN DO:
         IF  param-estoq.cons-invent      = 1 
        AND bf{&TableName}.situacao       = 3 
        AND bf{&TableName}.val-apurado[2] = ? 
        AND bf{&TableName}.val-apurado[3] = ? 
        AND bf{&TableName}.val-apurado[1] = bf{&TableName}.qtidade-atu THEN DO:
            /* Invent†rio est† OK */
            {method/svc/errors/inserr.i
                               &ErrorNumber="15346"
                               &ErrorType="EMS"
                               &ErrorSubType="INFORMATION"}
        END.
        IF  param-estoq.cons-invent   = 1 
        AND bf{&TableName}.situacao   = 3 
        AND bf{&TableName}.val-apurado[1] <> bf{&TableName}.val-apurado[2]
        AND bf{&TableName}.val-apurado[3]  = ? 
        AND bf{&TableName}.val-apurado[2]  = bf{&TableName}.qtidade-atu THEN DO:
            /* Invent†rio est† OK */
            {method/svc/errors/inserr.i
                               &ErrorNumber="15346"
                               &ErrorType="EMS"
                               &ErrorSubType="INFORMATION"}
        END.
        IF  bf{&TableName}.situacao = 4 
           AND bf{&TableName}.val-apurado[2] <> ? 
           AND bf{&TableName}.val-apurado[3]  = ?
           AND bf{&TableName}.val-apurado[1] <> bf{&TableName}.val-apurado[2] THEN DO:
               /* Valor apurado na 2a contagem n∆o confere com a 1a */
               {method/svc/errors/inserr.i
                                  &ErrorNumber="4555"
                                  &ErrorType="EMS"
                                  &ErrorSubType="WARNING"}
        END.
        IF  bf{&TableName}.situacao = 4 
           AND bf{&TableName}.val-apurado[3] <> ? 
           AND bf{&TableName}.val-apurado[1] <> bf{&TableName}.val-apurado[3] THEN DO:
               /* Valor apurado na 3a contagem n∆o confere com a 1a */
               {method/svc/errors/inserr.i
                                  &ErrorNumber="7337" 
                                  &ErrorType="EMS"
                                  &ErrorSubType="WARNING"}
        END.
    END.

    IF p-acao <> "CREATE":U THEN 
       BUFFER-COPY bf{&TableName} USING qtidade-atu valor-final situacao TO RowObject.

    RETURN "OK":U.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaTableName DBOProgram 
PROCEDURE piAtualizaTableName :
/*------------------------------------------------------------------------------
  Purpose:     Transfere os dados da temp-table que contem as alteraá‰es (wce07121.p) para
               a temp-table RowObject, para executar updateRecord na sequencia.
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT        PARAMETER pDigitacao AS INTEGER NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttInventario.
    DEFINE OUTPUT       PARAMETER TABLE FOR BrowserErrors.

    FOR EACH ttInventario:

        RUN repositionRecord IN THIS-PROCEDURE (INPUT ttInventario.r-rowid).
        RUN getRecord        IN THIS-PROCEDURE (OUTPUT TABLE RowObject).

        FIND FIRST RowObject NO-LOCK NO-ERROR.
        IF AVAIL RowObject THEN DO:

            FIND bf{&TableName}
                 WHERE bf{&TableName}.dt-saldo    = RowObject.dt-saldo
                   AND bf{&TableName}.cod-estabel = RowObject.cod-estabel
                   AND bf{&TableName}.cod-depos   = RowObject.cod-depos
                   AND bf{&TableName}.cod-localiz = RowObject.cod-localiz
                   AND bf{&TableName}.lote        = ttInventario.lote
                   AND bf{&tablename}.it-codigo   = RowObject.it-codigo NO-LOCK NO-ERROR.
            IF AVAIL bf{&TableName} THEN DO:
                IF ttInventario.r-rowid <> ROWID(bf{&TableName}) THEN DO:
                    /* J† existe ocorrància do registro */
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-lote AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "lote" *}
                    ASSIGN c-lbl-liter-lote = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="1"
                                        &ErrorType="EMS"
                                        &ErrorParameters="' ' + c-lbl-liter-lote + ' '"
                                        &ErrorSubType="ERROR"}
                END.
            END.
            IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                /* Se ocorreu erro, grava na nova temp-table de erro */
                FIND FIRST RowErrors NO-ERROR.
                IF AVAIL RowErrors THEN DO:
                    FOR EACH RowErrors:
                        CREATE BrowserErrors.
                        BUFFER-COPY RowErrors TO BrowserErrors NO-ERROR.
                        DELETE RowErrors. /* Elimina registros de RowErrors para evitar duplicidade de registros quando usuario selecionar mais de um registro no browser */
                    END.
                END.
            END.
            ELSE DO:
                ASSIGN RowObject.lote           = ttInventario.lote
                       RowObject.cod-refer      = ttInventario.cod-refer   
                       RowObject.val-apurado[1] = ttInventario.val-apurado-1
                       RowObject.val-apurado[2] = ttInventario.val-apurado-2
                       RowObject.val-apurado[3] = ttInventario.val-apurado-3
                       RowObject.dt-ult-entra   = ttInventario.dt-val-lote.

                /* Eliza - 09/2005 - atualiza valor da contagem que est† sendo digitada */
                if pDigitacao < 4 then 
                   assign RowObject.valor-mat-m[pDigitacao] = ttInventario.valor-mat
                          RowObject.valor-ggf-m[pDigitacao] = ttInventario.valor-ggf
                          RowObject.valor-mob-m[pDigitacao] = ttInventario.valor-mob.
                else 
                    assign RowObject.valor-mat-m[1] = ttInventario.valor-mat
                           RowObject.valor-ggf-m[1] = ttInventario.valor-ggf
                           RowObject.valor-mob-m[1] = ttInventario.valor-mob.
                /* ***** */

                RUN updateRecord IN THIS-PROCEDURE.

                FIND FIRST RowErrors 
                     WHERE RowErrors.ErrorSubType <> "ERROR" NO-ERROR.
                IF AVAIL RowErrors THEN
                    DELETE ttInventario. /* Elimina ttInventario se o erro n∆o for do tipo ERROR */
                                         /* para que o browser n∆o seja marcado novamente  */

                /* Se ocorreu erro, grava na nova temp-table de erro */
                FIND FIRST RowErrors NO-ERROR.
                IF AVAIL RowErrors THEN DO:
                    FOR EACH RowErrors:
                        CREATE BrowserErrors.
                        BUFFER-COPY RowErrors TO BrowserErrors NO-ERROR.
                        DELETE RowErrors. /* Elimina registros de RowErrors para evitar duplicidade de registros quando usuario selecionar mais de um registro no browser */
                    END.
                END.
                ELSE
                    DELETE ttInventario. /* Elimina ttInventairo se n∆o ocorreu erros */
            END.
        END.
    END.

    RETURN "OK":U.        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaSaldoEstoq DBOProgram 
PROCEDURE piAtualizaSaldoEstoq :
/*------------------------------------------------------------------------------
  Purpose:     Atualiza tabela saldo-estoq
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pCodRefer LIKE saldo-estoq.cod-refer NO-UNDO.

    DEFINE BUFFER b-saldo-dt-fab FOR saldo-estoq     LABEL "b-saldo-dt-fab for saldo-estoq":U.

    IF NOT AVAIL saldo-estoq THEN DO:
        FIND FIRST b-saldo-dt-fab NO-LOCK
             WHERE b-saldo-dt-fab.it-codigo = RowObject.it-codigo
               AND b-saldo-dt-fab.lote      = RowObject.lote
               AND b-saldo-dt-fab.cod-refer = RowObject.cod-refer NO-ERROR.

        IF AVAIL item-uni-estab AND item-uni-estab.loc-unica THEN DO:
            CREATE saldo-estoq.
            ASSIGN saldo-estoq.it-codigo   = RowObject.it-codigo
                   saldo-estoq.cod-localiz = item-uni-estab.cod-localiz
                   saldo-estoq.cod-estabel = RowObject.cod-estabel
                   saldo-estoq.cod-depos   = RowObject.cod-depos
                   saldo-estoq.lote        = RowObject.lote
                   saldo-estoq.cod-refer   = RowObject.cod-refer.
           IF AVAIL item
           AND item.tipo-con-est >= 3 AND RowObject.dt-ult-entra <> ? THEN
           ASSIGN saldo-estoq.dt-vali-lote = RowObject.dt-ult-entra
                  saldo-estoq.dt-fabric    = IF AVAILABLE b-saldo-dt-fab THEN b-saldo-dt-fab.dt-fabric ELSE TODAY.
        END.
        ELSE DO:
            CREATE saldo-estoq.
            ASSIGN saldo-estoq.it-codigo   = RowObject.it-codigo
                   saldo-estoq.cod-localiz = RowObject.cod-localiz
                   saldo-estoq.cod-estabel = RowObject.cod-estabel
                   saldo-estoq.cod-depos   = RowObject.cod-depos
                   saldo-estoq.lote        = RowObject.lote
                   saldo-estoq.cod-refer   = RowObject.cod-refer.
           IF AVAIL item
           AND item.tipo-con-est >= 3 AND RowObject.dt-ult-entra <> ? THEN
           ASSIGN saldo-estoq.dt-vali-lote = RowObject.dt-ult-entra
                  saldo-estoq.dt-fabric    = IF AVAILABLE b-saldo-dt-fab THEN b-saldo-dt-fab.dt-fabric ELSE TODAY.
        END.
    END.
    ELSE IF AVAIL item
         AND item.tipo-con-est = 4 THEN
            ASSIGN saldo-estoq.cod-refer = RowObject.cod-refer.


    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* Procedure em coment†rio com autorizaá∆o da analista Eliane, pois a Grendene
 *    nao utilizar† multi-planta neste momento, atÇ porque existe muitas mensagens com "show". 
 *    
 * &ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados-smc Procedure 
 * PROCEDURE pi-cria-tt-dados-smc :
 * /*------------------------------------------------------------------------------
 *   Purpose:     
 *   Notes:       
 * ------------------------------------------------------------------------------*/
 *     /*****[ Geraá∆o de Transaá∆o Multiplanta Especifica do SMC ]******/
 *     FOR EACH tt-smc-item-estab:
 *         DELETE tt-smc-item-estab.
 *     END.
 *     ASSIGN c-transacao  = "SMC024"
 *            i-tipo-movto = 1.
 *     {cdp/cd7300.i5 "001" c-transacao "-SMC"}
 * 
 *     IF  param-global.modulo-mp
 *     AND tt-replica-msg-SMC.log-replica-msg = YES THEN DO:
 *         CREATE  tt-smc-item-estab.
 *         BUFFER-COPY item-estab to tt-smc-item-estab.
 *         CREATE  tt-dados-env-SMC.
 *         ASSIGN  tt-dados-env-SMC.num-sequencia  = i-seq
 *                 tt-dados-env-SMC.cod-tipo-reg   = 281
 *                 tt-dados-env-SMC.ind-tipo-movto = i-tipo-movto
 *                 tt-dados-env-SMC.identif-msg    = item-estab.cod-estabel + " , " +
 *                                                   item-estab.it-codigo.
 *         RAW-TRANSFER tt-smc-item-estab TO tt-dados-env-SMC.conteudo-msg.
 *         ASSIGN i-seq = i-seq + 1.
 *     END.
 * 
 *     {cdp/cd7300.i6 "001" c-transacao "-SMC"}
 *     /***[Fim da Geraá∆o de Transaá∆o Multiplanta Especifica do SMC]***/
 * END PROCEDURE.
 * 
 * /* _UIB-CODE-BLOCK-END */
 * &ANALYZE-RESUME*/

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEliminaRegistro Procedure
PROCEDURE piEliminaRegistro :
/*------------------------------------------------------------------------------
  Purpose: Elimina Registro (Apenas altera a situacao para 2 "N∆o Atualiza")
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST {&TableName}
         WHERE {&TableName}.dt-saldo = RowObject.dt-saldo
           AND {&TableName}.nr-ficha = RowObject.nr-ficha EXCLUSIVE-LOCK NO-ERROR. 

    IF {&TableName}.situacao <> 1 THEN
        ASSIGN {&TableName}.situacao       = 2
               {&TableName}.val-apurado    = ?
               {&TableName}.valor-mat-m[1] = 0
               {&TableName}.valor-mob-m[1] = 0
               {&TableName}.valor-ggf-m[1] = 0
               {&TableName}.valor-final    = 0.
    ELSE DO:
        /* Contagem n∆o pode ser eliminada, pois o registro j† foi atualizado */
        {method/svc/errors/inserr.i
                            &ErrorNumber="4977"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"}
        RETURN "NOK":U.
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piHabilitaCampos Procedure
PROCEDURE piHabilitaCampos :
/*------------------------------------------------------------------------------
  Purpose: Habilita/Desabilita campos
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pType  AS CHAR    NO-UNDO.
    DEFINE INPUT  PARAMETER pField AS CHAR    NO-UNDO.
    DEFINE OUTPUT PARAMETER pFlag  AS LOGICAL NO-UNDO.

    DEFINE VARIABLE da-fim-per-inv LIKE inventario.dt-saldo NO-UNDO.
    DEFINE VARIABLE da-mensal-ate  LIKE inventario.dt-saldo NO-UNDO.
    
    RUN findItem         IN THIS-PROCEDURE (INPUT RowObject.it-codigo).
    RUN findItemUniEstab IN THIS-PROCEDURE (INPUT RowObject.it-codigo,
                                            INPUT ROwObject.cod-estabel).

    IF NOT AVAIL param-estoq THEN
      FIND FIRST param-estoq NO-LOCK NO-ERROR.
    
    IF pType = "Update":U THEN 
        FIND FIRST b-saldo
             WHERE b-saldo.it-codigo = RowObject.it-codigo
               AND b-saldo.lote      = RowObject.lote NO-LOCK NO-ERROR.

    CASE pField:
        WHEN "cod-localiz" THEN DO:        /* Tratamento para campo Localizaá∆o */
            IF pType = "Create":U THEN DO:
                IF  AVAIL item-uni-estab
                AND item-uni-estab.loc-unica THEN
                    ASSIGN pFlag = NO.
                ELSE
                    ASSIGN pFlag = YES.
            END. 
        END.

        WHEN "lote" THEN DO:       /* Tratamento para campo lote */
            IF pType = "Update":U THEN DO:
                IF  AVAIL item
                AND item.tipo-con-est > 1
                AND RowObject.lote    = "" THEN
                    ASSIGN pFlag = YES.
                ELSE
                    ASSIGN pFlag = NO.
                    
            END.
            ELSE IF pType = "Create":U THEN DO:
                IF  AVAIL item THEN DO:
                    IF item.tipo-con-est > 1 THEN
                        ASSIGN pFlag = YES.
                    ELSE
                        ASSIGN pFlag = NO.
                END.
            END.
        END.
        WHEN "dt-ult-entra" THEN DO:       /* Tratamento para campo data validate lote */

            DEF VAR c-return AS CHAR NO-UNDO.
            RUN piRetornaValor (INPUT "Update", INPUT "dt-vali-lote", OUTPUT c-return).
            
            IF pType = "Update":U THEN DO:
                IF  AVAIL item
                AND item.tipo-con-est >= 3 THEN DO:
                    IF (( RowObject.dt-ult-entra = ? AND c-return = ? AND RowObject.lote = "" ) OR NOT AVAIL b-saldo) THEN
                        ASSIGN pFlag = YES.
                END.
                ELSE ASSIGN pFlag = NO.
            END.
            ELSE IF pType = "Create":U THEN DO:
                IF  AVAIL item THEN DO:
                    IF item.tipo-con-est >= 3 THEN 
                        ASSIGN pFlag = YES.
                        
                    ELSE
                        ASSIGN pFlag = NO. 
                END.
            END.
        END.

        WHEN "cod-refer" THEN DO:   /* Tratamento para campo cod-refer */
            
            IF pType = "Update":U THEN DO:
                IF  AVAIL item
                AND item.tipo-con-est = 4
                AND RowObject.lote    = "" THEN
                    ASSIGN pFlag = YES.              
                ELSE
                    ASSIGN pFlag = NO.
            END.
            ELSE IF pType = "Create":U THEN DO:
                IF  AVAIL item THEN DO:
                    IF item.tipo-con-est = 4 THEN
                        ASSIGN pFlag = YES.  
                    ELSe
                        ASSIGN pFlag = NO.
                END.
            END.
        END.       

        WHEN "valor-mat-m[1]" OR WHEN "valor-ggf-m[1]" OR WHEN "valor-mob-m[1]" THEN DO:
            IF pType = "Update":U
            OR pType = "Create":U THEN DO:

                /* VERIFICA DATA FINAL DO PERIODO DO INVENTARIO  - RETORNA ULTIMO DIA DO MES */
                ASSIGN da-fim-per-inv = IF  MONTH(RowObject.dt-saldo) = 12 THEN DATE(01,01,YEAR(RowObject.dt-saldo) + 1) - 1
                                                                      ELSE DATE(MONTH(RowObject.dt-saldo) + 1,01,
                                                                           YEAR(RowObject.dt-saldo)) - 1.

                RUN findEstabelec IN THIS-PROCEDURE (INPUT RowObject.cod-estabel).

                RUN findItemEstab IN THIS-PROCEDURE (INPUT RowObject.it-codigo,
                                                     INPUT RowObject.cod-estabel).

                IF avail item and item.tipo-contr = 2 AND
                (NOT AVAIL item-estab OR
                (AVAIL item-estab AND  
                       item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1] = 0 AND
                 AVAIL estabelec AND
                       estabelec.custo-contab = 1) OR
                (AVAIL item-estab AND 
                       item-estab.val-unit-mat-o[1] + item-estab.val-unit-mob-o[1] = 0 AND
                 AVAIL estabelec AND
                       estabelec.custo-contab = 2) OR
                (AVAIL item-estab AND
                       item-estab.val-unit-mat-p[1] + item-estab.val-unit-mob-p[1] = 0 AND
                 AVAIL estabelec AND
                       estabelec.custo-contab = 3)) THEN DO:

                    IF  AVAIL param-estoq THEN DO:
                        &if defined(bf_mat_fech_estab) &then
                            IF  param-estoq.tp-fech = 2 THEN DO:

                                IF AVAIL estabelec THEN
                                   RUN findEstabMat IN THIS-PROCEDURE (INPUT estabelec.cod-estabel).
                                IF AVAIL estab-mat THEN
                                    ASSIGN da-mensal-ate = estab-mat.mensal-ate.
                            END.
                            ELSE
                                ASSIGN da-mensal-ate = param-estoq.mensal-ate.
                        &else
                            ASSIGN da-mensal-ate = param-estoq.mensal-ate.
                        &endif
                    END.

                    FIND FIRST b-movto 
                         WHERE b-movto.it-codigo   = RowObject.it-codigo
                           AND b-movto.cod-estabel = RowObject.cod-estabel
                           AND b-movto.esp-docto   = 1 
                           AND b-movto.dt-trans    > da-mensal-ate
                           AND b-movto.dt-trans   <= da-fim-per-inv NO-LOCK NO-ERROR.

                    FIND FIRST c-movto 
                         WHERE c-movto.it-codigo   = RowObject.it-codigo
                           AND c-movto.cod-estabel = RowObject.cod-estabel
                           AND c-movto.esp-docto   = 21 
                           AND c-movto.dt-trans    > da-mensal-ate
                           AND c-movto.dt-trans   <= da-fim-per-inv NO-LOCK NO-ERROR.
                           
                    IF NOT AVAIL c-movto AND NOT AVAIL b-movto THEN
                        ASSIGN pFlag = YES.
                    ELSE
                        ASSIGN pFlag = NO.
                END.     
                ELSE
                    ASSIGN pFlag = NO.
                    
            END.
        END.

        WHEN "un" THEN DO:   /* Tratamento para campo un */
            IF pType = "Update":U
            OR pType = "Create":U THEN DO:

                FIND FIRST param-mat NO-LOCK NO-ERROR.
                IF AVAIL param-mat THEN DO:
                    IF param-mat.ind-sit-un = 1 THEN            /* Informa un */
                        ASSIGN pFlag = YES.
                    ELSE                             /* Default Item */
                        ASSIGN pFlag = NO.
                END.
                ELSE DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-parametros-area-materiais AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "ParÉmetros_µrea_Materiais" *}
                    ASSIGN c-lbl-liter-parametros-area-materiais = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="47"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-parametros-area-materiais"}
                END.
            END.
        END.

         WHEN "dt-vali-lote" THEN DO:  
            IF pType = "Create":U THEN DO:

                FOR FIRST saldo-estoq WHERE 
                          saldo-estoq.it-codigo = RowObject.it-codigo AND
                          saldo-estoq.lote      = RowObject.lote      NO-LOCK: END.

                ASSIGN pFlag = if not avail saldo-estoq and
                                  avail item and item.tipo-con-est >= 3 then YES
                                else NO.
            END.
         END.

         WHEN "it-codigo" THEN DO: 
             IF pType = "Create":U THEN DO:
                 FOR FIRST saldo-estoq 
                     WHERE saldo-estoq.it-codigo = RowObject.it-codigo 
                     AND saldo-estoq.lote = RowObject.lote 
                     AND saldo-estoq.qtidade-atu > 0 NO-LOCK: END.

                 RUN findItemEstab IN THIS-PROCEDURE (INPUT RowObject.it-codigo,
                                                      INPUT RowObject.cod-estabel).
                 ASSIGN pFlag = if not avail saldo-estoq AND not avail item-estab 
                                then YES
                                else NO.
             END.
         END.

    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piInicializa DBOProgram 
PROCEDURE piInicializa :
/*------------------------------------------------------------------------------
  Purpose:  Inicializa parÉmetros de estoque
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    FIND FIRST param-estoq NO-LOCK NO-ERROR.
    IF NOT AVAIL param-estoq THEN DO:
        {method/svc/errors/inserr.i
                            &ErrorNumber="1059"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"}
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDesalocaReserva DBOProgram 
PROCEDURE piDesalocaReserva :
/*------------------------------------------------------------------------------
  Purpose:  
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pCodEstabel LIKE inventario.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pCodDepos   LIKE inventario.cod-depos   NO-UNDO.
    DEFINE INPUT PARAMETER pCodLocaliz LIKE inventario.cod-localiz NO-UNDO.
    DEFINE INPUT PARAMETER pLote       LIKE inventario.lote        NO-UNDO.
    DEFINE INPUT PARAMETER pItCodigo   LIKE inventario.it-codigo   NO-UNDO.
    DEFINE INPUT PARAMETER pRefer      LIKE inventario.cod-refer   NO-UNDO.
    DEFINE INPUT PARAMETER pQtdAtu     AS DECIMAL                  NO-UNDO.

    find first saldo-estoq where 
               saldo-estoq.cod-estabel = pCodEstabel and
               saldo-estoq.cod-depos   = pCodDepos   and
               saldo-estoq.cod-localiz = pCodLocaliz and
               saldo-estoq.lote        = pLote       and
               saldo-estoq.it-codigo   = pItCodigo   and
               saldo-estoq.cod-refer   = pRefer      no-lock no-error.

    if avail saldo-estoq then 
       run cpp/cp9045.p (input rowid(saldo-estoq),
                         input pQtdAtu,
                         input no).

    return "OK":U.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaReferSaldo DBOProgram 
PROCEDURE piValidaReferSaldo :
/*------------------------------------------------------------------------------
  Purpose:  
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/

    def input  param p-it-codigo like inventario.it-codigo.
    def output param p-flag      as log init no.

    find first param-estoq no-lock no-error.

    for first item fields( cod-localiz   cod-obsoleto   data-ult-sai
                           data-ult-ent  it-codigo      fraciona
                           loc-unica     tipo-con-est   tipo-contr un )
        where item.it-codigo = p-it-codigo no-lock: end.

    if avail item and item.tipo-con-est = 4 then /* Controlado por Referencia */
       if  substr(param-estoq.char-2,1,1) = "#" then do:

           assign p-flag = yes.
           for first saldo-estoq fields (it-codigo lote cod-refer)
               where saldo-estoq.it-codigo = RowObject.it-codigo
               and   saldo-estoq.lote      = RowObject.lote exclusive-lock: end.

            if  avail saldo-estoq and saldo-estoq.cod-refer <> RowObject.cod-refer then do:
                /* Referencia informada nao confere com a referencia do lote. */
                {method/svc/errors/inserr.i
                    &ErrorNumber="1785"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"}
            end.
       end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaData DBOProgram 
PROCEDURE piRetornaData :
/*------------------------------------------------------------------------------
  Purpose:  
  Parameters:
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT   PARAMETER pItCodigo LIKE inventario.it-codigo  NO-UNDO.
    DEFINE OUTPUT  PARAMETER pFlag     AS LOG                     NO-UNDO.
    DEFINE OUTPUT  PARAMETER pData     AS DATE                    NO-UNDO.
    
    RUN findItem   IN THIS-PROCEDURE (INPUT pItCodigo).

    if avail item then do:
       assign pFlag = if item.tipo-con-est >= 3 then yes else no
              pData = item.data-ult-sai.
    end.
    
    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaFicha DBOProgram 
PROCEDURE piRetornaFicha :
/*------------------------------------------------------------------------------
  Purpose:  Retorna pr¢xima ficha p/digitaá∆o do invent†rio e temp-table de erro
  Parameters:  dt-saldo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pDtSaldo AS DATE    NO-UNDO.
    DEFINE OUTPUT PARAMETER pNrFicha AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF pDtSaldo = ? THEN DO:
        /* data de saldo para inventariar deve ser diferente de branco */
        {method/svc/errors/inserr.i
                            &ErrorNumber="4370"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"}
    END.
    ELSE DO:
        FIND LAST bf{&TableName} USE-INDEX nr-ficha WHERE
                  bf{&TableName}.dt-saldo = pDtSaldo NO-LOCK NO-ERROR.

        IF AVAIL bf{&TableName} THEN DO:
            IF bf{&TableName}.nr-ficha < 9999999 THEN
                ASSIGN pNrFicha = bf{&TableName}.nr-ficha + 1.
            ELSE DO:
                {method/svc/errors/inserr.i
                                    &ErrorNumber="4491"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"}
            END.
        END.
        ELSE ASSIGN pNrFicha = 1.
        
    END.

    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaValor DBOProgram 
PROCEDURE piRetornaValor :
/*------------------------------------------------------------------------------
  Purpose:  Retorna conteudo do campo informado em input parameter
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pType  AS CHAR NO-UNDO.
    DEFINE INPUT  PARAMETER pField AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAMETER pValue AS CHAR NO-UNDO.

    DEFINE VARIABLE da-vali-lote LIKE saldo-estoq.dt-vali-lote         NO-UNDO.
    DEFINE VARIABLE c-cod-refer  LIKE saldo-estoq.cod-refer    INIT "" NO-UNDO.

    IF pType = "Update":U THEN DO:
        RUN findItem         IN THIS-PROCEDURE (INPUT RowObject.it-codigo).
        RUN findItemUniEstab IN THIS-PROCEDURE (INPUT RowObject.it-codigo,
                                                INPUT ROwObject.cod-estabel).

        IF AVAIL item-uni-estab AND item-uni-estab.loc-unica THEN DO:
            RUN findSaldoEstoq IN THIS-PROCEDURE (INPUT RowObject.cod-estabel,
                                                  INPUT RowObject.cod-depos,
                                                  INPUT item-uni-estab.cod-localiz,
                                                  INPUT RowObject.lote,
                                                  INPUT RowObject.it-codigo,
                                                  INPUT RowObject.cod-refer,
                                                  INPUT NO).
        END.
        ELSE DO:
            RUN findSaldoEstoq IN THIS-PROCEDURE (INPUT RowObject.cod-estabel,
                                                  INPUT RowObject.cod-depos,
                                                  INPUT RowObject.cod-localiz,
                                                  INPUT RowObject.lote,
                                                  INPUT RowObject.it-codigo,
                                                  INPUT RowObject.cod-refer,
                                                  INPUT NO).
        END.

        IF AVAIL item and
                 item.tipo-con-est >= 3 THEN DO: 
            
                IF AVAIL saldo-estoq THEN
                    ASSIGN da-vali-lote = saldo-estoq.dt-vali-lote
                           c-cod-refer  = saldo-estoq.cod-refer.
                ELSE DO:
                    
                    FIND FIRST b-saldo 
                         WHERE b-saldo.lote      = RowObject.lote
                           AND b-saldo.it-codigo = RowObject.it-codigo NO-LOCK NO-ERROR.
                    IF AVAIL b-saldo THEN
                        ASSIGN da-vali-lote = b-saldo.dt-vali-lote
                               c-cod-refer  = b-saldo.cod-refer.
                    ELSE DO:
                        FIND FIRST b-invent
                             WHERE b-invent.it-codigo = RowObject.it-codigo
                               AND b-invent.lote      = RowObject.lote NO-LOCK NO-ERROR.
                        IF AVAIL b-invent THEN
                            ASSIGN da-vali-lote = b-invent.dt-ult-entra.
                    END.
                END.
        END.

        CASE pField:
            WHEN "dt-vali-lote":U THEN
                ASSIGN pValue = TRIM(STRING(da-vali-lote,"99/99/9999")).
            WHEN "cod-refer":U THEN
                ASSIGN pValue = c-cod-refer.
        END CASE.
    END.

    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaSaldo DBOProgram 
PROCEDURE piVerificaSaldo :
/*------------------------------------------------------------------------------
  Purpose:  
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pHabilita AS LOG INIT NO NO-UNDO.
    
        RUN findItem         IN THIS-PROCEDURE (INPUT RowObject.it-codigo).
        RUN findItemUniEstab IN THIS-PROCEDURE (INPUT RowObject.it-codigo,
                                                INPUT ROwObject.cod-estabel).

        IF AVAIL item-uni-estab AND item-uni-estab.loc-unica THEN DO:
            RUN findSaldoEstoq IN THIS-PROCEDURE (INPUT RowObject.cod-estabel,
                                                  INPUT RowObject.cod-depos,
                                                  INPUT item-uni-estab.cod-localiz,
                                                  INPUT RowObject.lote,
                                                  INPUT RowObject.it-codigo,
                                                  INPUT RowObject.cod-refer,
                                                  INPUT NO).
        END.
        ELSE DO:
            RUN findSaldoEstoq IN THIS-PROCEDURE (INPUT RowObject.cod-estabel,
                                                  INPUT RowObject.cod-depos,
                                                  INPUT RowObject.cod-localiz,
                                                  INPUT RowObject.lote,
                                                  INPUT RowObject.it-codigo,
                                                  INPUT RowObject.cod-refer,
                                                  INPUT NO).
        END.

        IF NOT AVAIL saldo-estoq THEN DO:

           FOR FIRST saldo-estoq 
               WHERE saldo-estoq.lote      = RowObject.lote AND
                     saldo-estoq.it-codigo = Rowobject.it-codigo NO-LOCK: END.

           IF NOT AVAIL saldo-estoq AND
                  AVAIL ITEM AND item.tipo-con-est = 4 THEN
                  ASSIGN pHabilita = YES.
            ELSE ASSIGN pHabilita = NO.
        END.
  
     
    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSelecionaRegistros DBOProgram
PROCEDURE piSelecionaRegistros :
/*------------------------------------------------------------------------------
  Purpose:  
  Parameters:  
  Notes:  Esta procedure Ç executada por generateBrowse.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pRowid AS ROWID   NO-UNDO.
    DEFINE OUTPUT PARAMETER pExibe AS LOGICAL NO-UNDO.

    RUN findItem IN THIS-PROCEDURE (INPUT {&TableName}.it-codigo).

    ASSIGN pExibe = NO.

    IF RETURN-VALUE = "OK":U THEN DO:
        IF param-estoq.cons-invent = 1 THEN DO:
            IF l-digitada AND
               {&TableName}.situacao = 4 AND
               ({&TableName}.val-apurado[1] <> ? AND
                {&TableName}.val-apurado[1] <> {&TableName}.qtidade-atu AND
                {&TableName}.val-apurado[2] = ? AND
                {&TableName}.val-apurado[3] = ?) OR
                ({&TableName}.val-apurado[1] <> ? AND
                 {&TableName}.val-apurado[2] <> ? AND
                 ({&TableName}.val-apurado[1] <> {&TableName}.qtidade-atu AND
                  {&TableName}.val-apurado[2] <> {&TableName}.qtidade-atu) AND
                 {&TableName}.val-apurado[3] = ?) THEN
                ASSIGN pExibe = YES.
            ELSE 
                IF l-nao-digitada AND
                   {&TableName}.situacao = 2 THEN
                    ASSIGN pExibe = YES.
            ELSE 
                IF l-atualizada AND 
                   {&TableName}.situacao = 1 THEN
                    ASSIGN pExibe = YES.
            ELSE 
                IF l-ok-atualizar AND
                   {&TableName}.situacao = 4 THEN
                    ASSIGN pExibe = YES.
            ELSE 
                IF l-inventariada AND
                   {&TableName}.situacao = 3 THEN
                    ASSIGN pExibe = YES.
        END.
        ELSE IF param-estoq.cons-invent = 2 THEN DO:
                IF l-digitada  AND
                   ({&TableName}.situacao = 4 AND
                   ({&TableName}.val-apurado[1] <> {&TableName}.val-apurado[2] AND
                    {&TableName}.val-apurado[1] <> ?) OR
                   ({&TableName}.val-apurado[1] <> ? AND
                    {&TableName}.val-apurado[2] = ?  AND
                    {&TableName}.val-apurado[3] = ?)) THEN
                    ASSIGN pExibe = YES.
                ELSE 
                    IF l-nao-digitada AND
                       {&TableName}.situacao = 2 THEN
                        ASSIGN pExibe = YES.
                ELSE 
                    IF l-atualizada AND
                       {&TableName}.situacao = 1 THEN
                        ASSIGN pExibe = YES.
                ELSE 
                    IF l-ok-atualizar AND
                        ({&TableName}.situacao = 4 AND
                        (({&TableName}.val-apurado[1] = {&TableName}.val-apurado[2] AND
                          {&TableName}.val-apurado[1] <> ?)OR
                         ({&TableName}.val-apurado[2] = {&TableName}.val-apurado[3] AND
                          {&TableName}.val-apurado[2] <> ?) OR
                          {&TableName}.val-apurado[1] <> ? AND
                          {&TableName}.val-apurado[2] <> ? AND
                          {&TableName}.val-apurado[3] <> ?)) THEN
                        ASSIGN pExibe = YES.
                ELSE 
                    IF l-inventariada AND
                       {&TableName}.situacao = 3 THEN
                        ASSIGN pExibe = YES.
        END.        
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

