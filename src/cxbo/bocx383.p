&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/
{include/i-prgvrs.i BOCX383 2.00.00.080 } /*** "010080" 16/09/2026 15:58:58 ***/
/* ***************************  Definitions  **************************** */

{cdp/cdcfgmat.i} /*:T--- Preprocessadores ---*/

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX383
&GLOBAL-DEFINE DBOVersion
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName decla-import
&GLOBAL-DEFINE TableLabel
&GLOBAL-DEFINE QueryName qr{&TableName}

{cxbo/bocx383.i RowObject}             /*:T--- Include com definiá∆o da temptable RowObject ---*/
{cxbo/bocx383.i tt-decla-import-aux}
{cxbo/bocx395.i tt-decla-import-cotac}
{cxbo/bocx00507.i tt-decla-import-ord-trib}
{cxbo/bocx00488.i tt-duimp-item}

{method/dboqry.i} /*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/

{utp/ut-glob.i} /*:T--- Variaveis Globais ---*/

DEFINE VARIABLE c-return                       AS   CHARACTER                       NO-UNDO.
DEFINE VARIABLE c-cod-desp                     AS   CHARACTER                       NO-UNDO.
DEFINE VARIABLE c-char-1                       AS   CHARACTER                       NO-UNDO.
DEFINE VARIABLE c-char-2                       AS   CHARACTER                       NO-UNDO.
DEFINE VARIABLE c-class-fiscal                 AS   CHARACTER                       NO-UNDO.
DEFINE VARIABLE c-classfis                     AS   CHARACTER                       NO-UNDO.
DEFINE VARIABLE c-lbl-traducao                 AS   CHARACTER                       NO-UNDO.
DEFINE VARIABLE d-dt-ult-prazo                 AS   DATE                            NO-UNDO.
DEFINE VARIABLE d-dt-embarque                  AS   DATE                            NO-UNDO.
DEFINE VARIABLE d-val-despes                   AS   DECIMAL                         NO-UNDO.
DEFINE VARIABLE d-val-despes-tot               AS   DECIMAL                         NO-UNDO.
DEFINE VARIABLE h-bocx404                      AS   HANDLE                          NO-UNDO.
DEFINE VARIABLE h-bocx386                      AS   HANDLE                          NO-UNDO.
DEFINE VARIABLE h-bocx403                      AS   HANDLE                          NO-UNDO.
DEFINE VARIABLE h-bocx402                      AS   HANDLE                          NO-UNDO.
DEFINE VARIABLE h-bocx395                      AS   HANDLE                          NO-UNDO.
DEFINE VARIABLE h-bocx383a                     AS   HANDLE                          NO-UNDO.
DEFINE VARIABLE h-bocx393                      AS   HANDLE                          NO-UNDO.
DEFINE VARIABLE h-bocx390                      AS   HANDLE                          NO-UNDO.
DEFINE VARIABLE h-bocx406                      AS   HANDLE                          NO-UNDO.
DEFINE VARIABLE h-acomp                        AS   HANDLE                          NO-UNDO.
DEFINE VARIABLE h-boin082                      AS   HANDLE                          NO-UNDO.
DEFINE VARIABLE h-boin178i                     AS   HANDLE                          NO-UNDO.
DEFINE VARIABLE h-bocx407                      AS   HANDLE                          NO-UNDO.
DEFINE VARIABLE h-bocx220na                    AS   HANDLE                          NO-UNDO.
DEFINE VARIABLE h-bocx00507                    AS   HANDLE                          NO-UNDO.
DEFINE VARIABLE h-bocx00506                    AS   HANDLE                          NO-UNDO.
DEFINE VARIABLE h-bocx00512                    AS   HANDLE                          NO-UNDO.
DEFINE VARIABLE h-bocx00488                    AS   HANDLE                          NO-UNDO.
DEFINE VARIABLE i-cont-seq                     AS   INTEGER                         NO-UNDO.
DEFINE VARIABLE i-reg-retornados               AS   INTEGER                         NO-UNDO.
DEFINE VARIABLE i-cod-desp                     AS   INTEGER                         NO-UNDO.
DEFINE VARIABLE i                              AS   INTEGER                         NO-UNDO.
DEFINE VARIABLE i-ult-prazo                    AS   INTEGER                         NO-UNDO.
DEFINE VARIABLE i-cod-ven-par                  AS   INTEGER                         NO-UNDO.
DEFINE VARIABLE i-cod-itiner                   AS   INTEGER                         NO-UNDO.
DEFINE VARIABLE i-seq-item                     AS   INTEGER                         NO-UNDO.
DEFINE VARIABLE l-atualiza-data                AS   LOGICAL INITIAL NO              NO-UNDO.
DEFINE VARIABLE l-adic-informadas              AS   LOGICAL INITIAL NO              NO-UNDO.
DEFINE VARIABLE l-im0099                       AS   LOGICAL INITIAL NO              NO-UNDO.
DEFINE VARIABLE l-desemb-parc                  AS   LOGICAL                         NO-UNDO.
DEFINE VARIABLE l-atualiza-situacao-integracao AS   LOGICAL                         NO-UNDO.
DEFINE VARIABLE l-automatica                   AS   LOGICAL INITIAL NO              NO-UNDO.
DEFINE VARIABLE l-utz-taxa-siscomex            AS   LOGICAL                         NO-UNDO.
DEFINE VARIABLE l-im7000                       AS   LOGICAL INITIAL NO              NO-UNDO.
DEFINE VARIABLE i-cod-emitente-desp            LIKE emitente.cod-emitente           NO-UNDO.
DEFINE VARIABLE i-cod-cond-pag                 LIKE emitente.cod-cond-pag           NO-UNDO.
DEFINE VARIABLE i-num-di-ems                   LIKE decla-import.num-di-ems         NO-UNDO.
DEFINE VARIABLE c-cod-natur-oper-old           LIKE {&TABLENAME}.cod-natur-oper     NO-UNDO.
DEFINE VARIABLE c-cod-estab-ini                LIKE decla-import.cod-estab          NO-UNDO.
DEFINE VARIABLE c-cod-estab-fim                LIKE decla-import.cod-estab          NO-UNDO.
DEFINE VARIABLE d-num-di-ems-ini               LIKE decla-import.num-di-ems         NO-UNDO.
DEFINE VARIABLE d-num-di-ems-fim               LIKE decla-import.num-di-ems         NO-UNDO.
DEFINE VARIABLE c-cod-di-siscomex-ini          LIKE decla-import.cod-di-siscomex    NO-UNDO.
DEFINE VARIABLE c-cod-di-siscomex-fim          LIKE decla-import.cod-di-siscomex    NO-UNDO.
DEFINE VARIABLE d-cdd-siscomex-dts-ini         LIKE decla-import.cdd-siscomex-dts   NO-UNDO.
DEFINE VARIABLE d-cdd-siscomex-dts-fim         LIKE decla-import.cdd-siscomex-dts   NO-UNDO.
DEFINE VARIABLE d-dat-di-ini                   LIKE decla-import.dat-di             NO-UNDO.
DEFINE VARIABLE d-dat-di-fim                   LIKE decla-import.dat-di             NO-UNDO.
DEFINE VARIABLE d-num-di-ems                   LIKE decla-import.num-di-ems         NO-UNDO.
DEFINE VARIABLE i-num-seq-retif                LIKE decla-import.num-seq-retif      NO-UNDO.
DEFINE VARIABLE l-log-ativo                    LIKE decla-import.log-ativo          NO-UNDO.
DEFINE VARIABLE i-cdn-pto-nacionaliz-histor    LIKE despes-adic.cdn-pto-contr       NO-UNDO.
DEFINE VARIABLE d-peso-liq-total-di            LIKE decla-import.val-peso-liq-di    NO-UNDO. /* vari†veis de c†lculo do peso. */
DEFINE VARIABLE d-peso-brut-merc-total-di      LIKE decla-import.val-peso-brut-merc NO-UNDO. /* vari†veis de c†lculo do peso. */
DEFINE VARIABLE de-cdd-siscomex-dts            LIKE decla-import.cdd-siscomex-dts   NO-UNDO.
DEFINE VARIABLE i-tp-nacionaliz                AS INTEGER                           NO-UNDO.
DEFINE VARIABLE l-nt2024002   AS LOGICAL     NO-UNDO.
ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-nt2024002":U AND funcao.ativo).

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bf-nve-item    FOR nve-item.
DEFINE BUFFER b-docum-est    FOR docum-est.
{cxbo/bocx407.i tt-decla-import-embarq}
{cxbo/bocx402.i tt-decla-import-adic-itens}
{cxbo/bocx402.i tt-decla-import-adic-itens-aux}
{cxbo/bocx404.i tt-decla-import-ord}
{cxbo/bocx404.i tt-decla-import-ord-aux}
{cxbo/bocx386.i tt-decla-import-embal}
{cxbo/bocx386.i tt-decla-import-embal-aux}
{cxbo/bocx403.i tt-decla-import-adic}
{cxbo/bocx403.i tt-decla-import-adic-aux}
{cxbo/bocx393.i tt-decla-import-adic-nve}
{cxbo/bocx393.i tt-decla-import-adic-nve-aux}
{cxbo/bocx390.i tt-despes-adic}
{cxbo/bocx390.i tt-despes-adic-aux}
{cxbo/bocx406.i tt-despes-decla-import}
{cxbo/bocx220.i tt-embarque-imp}
{cxbo/bocx00506.i tt-decla-import-adic-trib}
{cxbo/bocx00506.i tt-decla-import-adic-trib-aux}
{cxbo/bocx00512.i tt-decla-imp-adic-it-trib}
{cxbo/bocx00512.i tt-decla-imp-adic-it-trib-aux}
{cxbo/bocx00507.i tt-decla-import-ord-trib-aux}

DEFINE TEMP-TABLE tt-decla-import-embarq-nat NO-UNDO LIKE decla-import-embarq
    FIELD r-Rowid      AS ROWID
    FIELD nat-operacao LIKE natur-oper.nat-operacao.

DEFINE TEMP-TABLE tt-decla-import-ord-aux2 NO-UNDO LIKE tt-decla-import-ord-aux
    FIELD cod-classif-fisc AS CHAR.

DEFINE TEMP-TABLE tt-docum-est NO-UNDO
    field embarque                   LIKE docum-est.embarque
    field cod-estabel                LIKE docum-est.cod-estabel
    field nro-docto                  LIKE docum-est.nro-docto
    field serie-docto                LIKE docum-est.serie-docto
    field cod-emitente               LIKE docum-est.cod-emitente
    field nat-operacao               LIKE docum-est.nat-operacao
    field idi-nf-simples-remes       LIKE docum-est.idi-nf-simples-remes
    field dt-emissao                 LIKE docum-est.dt-emissao
    field usuario                    LIKE docum-est.usuario
    field ce-atual                   LIKE docum-est.ce-atual
    field embarque-ori               LIKE docum-est.embarque
    field cod-tipo-nf-cred-deb       LIKE docum-est.cod-tipo-nf-cred-deb
    field cod-finalidade             LIKE docum-est.cod-finalidade
    field char-1                     LIKE docum-est.char-1
    FIELD observacao                 AS CHAR
    field r-rowid as rowid
.

{imp/im0410a.i}    /* Definiá‰es necess†rias para o folder Impostos */
{cxbo/bocx225e.i1} /* variˇveis atributo livre ordens-embarque */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnBuscaMoeda DBOProgram
FUNCTION fnBuscaMoeda RETURNS CHARACTER
  ( i-moeda AS INTEGER )  FORWARD.

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
         HEIGHT             = 26.21
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    /*SE FOR UMA RETIFICAÄ«O EXECUTA PROCEDURA PARA DESATIVAR AS ANTIGAS*/
    IF  RowObject.num-seq-retif <> 0
    AND RowObject.num-seq-retif <> 99 THEN
        RUN pi-desativa-retificacao-antiga.

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
    FOR EACH decla-import-embal EXCLUSIVE-LOCK
       WHERE decla-import-embal.num-di-ems = RowObject.num-di-ems
         AND decla-import-embal.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
        DELETE decla-import-embal.
    END.

    FOR EACH decla-import-proc EXCLUSIVE-LOCK
       WHERE decla-import-proc.num-di-ems = RowObject.num-di-ems
         AND decla-import-proc.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
        DELETE decla-import-proc.
    END.

    /* verifica se n∆o existe retificaá∆o para di que esta sendo excluida, caso n∆o tenha retificaá∆o, ativa a primeira DI*/
    IF NOT CAN-FIND(FIRST decla-import
                    WHERE decla-import.num-di-ems = RowObject.num-di-ems
                      AND (decla-import.num-seq-retif > 0 AND decla-import.num-seq-retif < 99)
                      AND decla-import.cdd-siscomex-dts = RowObject.cdd-siscomex-dts) THEN DO:

        FOR FIRST bf{&TABLENAME} EXCLUSIVE-LOCK
                WHERE bf{&TABLENAME}.num-di-ems = RowObject.num-di-ems
                  AND bf{&TABLENAME}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
            ASSIGN bf{&TABLENAME}.log-ativo = YES.
        END.
    END.

    FOR EACH decla-import-trib EXCLUSIVE-LOCK
       WHERE decla-import-trib.num-di-ems    = RowObject.num-di-ems
         AND decla-import-trib.num-seq-retif = RowObject.num-seq-retif
         AND decla-import-trib.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
        DELETE decla-import-trib.
    END.

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

    IF  l-atualiza-data THEN DO:

        IF  CAN-FIND(FIRST decla-import-cotac
                     WHERE decla-import-cotac.num-di-ems       = RowObject.num-di-ems
                       AND decla-import-cotac.cdd-siscomex-dts = RowObject.cdd-siscomex-dts) THEN DO:

            {utp/ut-liter.i "As_cotaá‰es_das_moedas_relacionadas_a_Declaraá∆o_de_Importaá∆o_foram_eliminadas._Para_atualizar_favor_utilizar_o_programa_IM7000C" *}
            {method/svc/errors/inserr.i &ErrorNumber="15825"
                                        &ErrorType="EMS"
                                        &ErrorParameters="TRIM(RETURN-VALUE) + '.' + '~~~~' +  TRIM(RETURN-VALUE) + '.'"}
        END.

        FOR EACH decla-import-cotac EXCLUSIVE-LOCK
            WHERE decla-import-cotac.num-di-ems = RowObject.num-di-ems
              AND decla-import-cotac.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
            DELETE decla-import-cotac.
        END.

        RELEASE decla-import-cotac.
    END.

    IF  RowObject.cod-di-siscomex <> "" THEN DO:

        FOR EACH  decla-import-embarq NO-LOCK
            WHERE decla-import-embarq.num-di-ems = RowObject.num-di-ems
              AND decla-import-embarq.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:

            FOR FIRST embarque-imp EXCLUSIVE-LOCK
                WHERE embarque-imp.cod-estabel = decla-import-embarq.cod-estab
                AND   embarque-imp.embarque    = decla-import-embarq.cod-embarq:

                ASSIGN embarque-imp.declaracao-import = RowObject.cod-di-siscomex
                       embarque-imp.data-DI           = RowObject.dat-di
                       embarque-imp.int-2             = RowObject.num-di-ems
                       embarque-imp.cod-via-transp    = RowObject.idi-via-transp-di.
            END.
        END.
        RELEASE embarque-imp.
    END.

    /*SE FOR UMA RETIFICAÄ«O EXECUTA PROCEDURA PARA DESATIVAR AS ANTIGAS*/
    IF  RowObject.num-seq-retif <> 0
    AND RowObject.num-seq-retif < 99 THEN
        RUN pi-desativa-retificacao-antiga.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualiza-sitRatCalc-DI DBOProgram
PROCEDURE atualiza-sitRatCalc-DI :
/*------------------------------------------------------------------------------
  Purpose: Atualizar a situacao dos rateios e calculos dos impostos da DI
           "Rateio Despesa Nacionalizacao", "Rateio Despesas Complementares", "Calculo Impostos"
  Parameters:  Os parametros para alteracao devem ser passados como "yes" ou "no",
               em formato de string, caso nao queira alterar um dos campos passar "".
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-di-ems    AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-cdd-siscomex-dts AS DECIMAL NO-UNDO.
    DEFINE INPUT PARAMETER l-rat-desp-nac  AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER l-rat-desp-comp AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER l-calc-impostos AS CHAR NO-UNDO.

    FIND FIRST decla-import
         WHERE decla-import.num-di-ems = p-num-di-ems
           AND decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts
         EXCLUSIVE-LOCK NO-ERROR.


    IF AVAIL decla-import THEN DO:

        /*Rateio Despesas Nacionalizacao*/
        IF l-rat-desp-nac = "yes":U OR l-rat-desp-nac = "no":U THEN
            ASSIGN decla-import.log-pend-rat = LOGICAL(l-rat-desp-nac).

        /*Rateio Despesas Complementares*/
        IF l-rat-desp-comp = "yes":U OR l-rat-desp-comp = "no":U THEN
            &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN
                ASSIGN decla-import.log-pend-despes-compltar = LOGICAL(l-rat-desp-comp)
            &ELSE
                ASSIGN OVERLAY(decla-import.cod-livre-1,1,1) = IF l-rat-desp-comp = "yes":U THEN "S":U ELSE "N":U.
            &ENDIF

        /*Calculo Impostos*/
        IF l-calc-impostos = "yes":U OR l-calc-impostos = "no":U THEN
            &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN
                ASSIGN decla-import.log-pend-impto = LOGICAL(l-calc-impostos).
            &ELSE
                ASSIGN  decla-import.log-livre-2 = LOGICAL(l-calc-impostos).
            &ENDIF
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:
  Notes:
------------------------------------------------------------------------------*/
    /*--- Ao gerar a DI, o campo log-livre-1 que indica que j† gerou nota deve estar com NO.
          Quando a nota de nacionalizaá∆o for gerada, este passa para YES ---*/

    ASSIGN RowObject.log-livre-1              = NO
           OVERLAY(RowObject.cod-livre-1,1,1) = 'N':U.

    RETURN "OK":U.

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

    FOR FIRST bf{&TableName} NO-LOCK
        WHERE bf{&TABLENAME}.num-di-ems    = RowObject.num-di-ems
        AND   bf{&TABLENAME}.num-seq-retif = RowObject.num-seq-retif
        AND   bf{&TABLENAME}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:

        ASSIGN c-cod-natur-oper-old  = bf{&TABLENAME}.cod-natur-operac.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaMoedaNegociacao DBOProgram
PROCEDURE buscaMoedaNegociacao :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pNumDiSis LIKE {&TABLENAME}.cod-di-siscomex NO-UNDO.
    DEFINE OUTPUT PARAMETER pMoeda    LIKE decla-import-adic.cdn-moeda  NO-UNDO.

    FOR FIRST decla-import NO-LOCK
        WHERE decla-import.cod-di-siscomex = pNumDiSis,
        FIRST decla-import-adic NO-LOCK
        WHERE decla-import-adic.num-di-ems = decla-import.num-di-ems
          AND decla-import-adic.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:

        ASSIGN pMoeda = decla-import-adic.cdn-moeda.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaUltimaRetificacao DBOProgram
PROCEDURE buscaUltimaRetificacao :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pNumDiEms  LIKE {&TABLENAME}.num-di-ems NO-UNDO.
    DEFINE INPUT  PARAMETER pCddSiscomexDTS LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.
    DEFINE OUTPUT PARAMETER pUltimaSeq AS   INTEGER                 NO-UNDO.

    FIND LAST decla-import NO-LOCK
        WHERE decla-import.num-di-ems = pNumDiEms
          AND decla-import.cdd-siscomex-dts = pCddSiscomexDTS
          AND decla-import.num-seq-retif < 99 NO-ERROR.

    IF AVAIL decla-import THEN
        ASSIGN pUltimaSeq = decla-import.num-seq-retif.
    ELSE
        ASSIGN pUltimaSeq = 0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE converteValorMoeda DBOProgram
PROCEDURE converteValorMoeda :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-num-di-ems    LIKE decla-import-ord.num-di-ems    NO-UNDO.
    DEFINE INPUT  PARAMETER pcdd-siscomex-dts LIKE decla-import-ord.cdd-siscomex-dts NO-UNDO.
    DEFINE INPUT  PARAMETER p-moeda-origem  LIKE despes-decla-import.cdn-moeda  NO-UNDO.
    DEFINE INPUT  PARAMETER p-moeda-destino LIKE despes-decla-import.cdn-moeda  NO-UNDO.
    DEFINE INPUT  PARAMETER p-valorConverte LIKE despes-decla-import.val-despes NO-UNDO.
    DEFINE INPUT  PARAMETER p-data          LIKE decla-import.dat-di            NO-UNDO.
    DEFINE OUTPUT PARAMETER p-valor         LIKE despes-decla-import.val-despes NO-UNDO.

    IF p-valorConverte <> ? AND p-valorConverte <> 0 THEN DO:

        IF CAN-FIND(FIRST decla-import-cotac
                    WHERE decla-import-cotac.num-di-ems = p-num-di-ems
                    AND   decla-import-cotac.cdd-siscomex-dts = pcdd-siscomex-dts
                    AND   decla-import-cotac.val-cotac  > 0) THEN DO:

            IF CAN-FIND(FIRST decla-import-cotac
                        WHERE decla-import-cotac.num-di-ems = p-num-di-ems
                        AND   decla-import-cotac.cdd-siscomex-dts = pcdd-siscomex-dts
                        AND   decla-import-cotac.cdn-moeda  = p-moeda-origem
                        AND   decla-import-cotac.val-cotac  > 0) THEN DO:

                IF CAN-FIND(FIRST decla-import-cotac
                            WHERE decla-import-cotac.num-di-ems = p-num-di-ems
                            AND   decla-import-cotac.cdd-siscomex-dts = pcdd-siscomex-dts
                            AND   decla-import-cotac.cdn-moeda  = p-moeda-destino
                            AND   decla-import-cotac.val-cotac  > 0) THEN DO:

                    RUN imp/im0400h.p (INPUT p-num-di-ems,
                                       INPUT pcdd-siscomex-dts,
                                       INPUT p-moeda-origem,
                                       INPUT p-moeda-destino,
                                       INPUT p-valorConverte,
                                       INPUT p-data,
                                       OUTPUT p-valor).
                END.
                ELSE DO:

                    RUN cdp/cd0812.p (INPUT p-moeda-origem,
                                      INPUT p-moeda-destino,
                                      INPUT p-valorConverte,
                                      INPUT p-data,
                                      OUTPUT p-valor).
                END.
            END.
            ELSE DO:

                RUN cdp/cd0812.p (INPUT p-moeda-origem,
                                  INPUT p-moeda-destino,
                                  INPUT p-valorConverte,
                                  INPUT p-data,
                                  OUTPUT p-valor).
            END.
        END.
        ELSE DO:

            RUN cdp/cd0812.p (INPUT p-moeda-origem,
                              INPUT p-moeda-destino,
                              INPUT p-valorConverte,
                              INPUT p-data,
                              OUTPUT p-valor).
        END.

        IF p-valor = ? THEN DO:

            {utp/ut-liter.i "Moeda" *}
            {method/svc/errors/inserr.i &ErrorNumber="37520"
                                        &ErrorType="EMS"
                                        &ErrorParameters="TRIM(RETURN-VALUE)      + ' '    +
                                                          STRING(p-moeda-origem)  + '~~~~' + ' ' +
                                                          TRIM(RETURN-VALUE)      + ' '    +
                                                          STRING(p-moeda-destino) + '~~~~' + STRING(p-data)"}
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaAdicao DBOProgram
PROCEDURE criaAdicao :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-decla-import-ord.
    DEFINE INPUT PARAMETER p-num-adic LIKE decla-import-ord.num-adic NO-UNDO.

    DEFINE VAR i-num-adic LIKE decla-import-adic.num-adic NO-UNDO.

    FOR FIRST tt-decla-import-ord: END.

    FIND LAST tt-decla-import-adic
        WHERE tt-decla-import-adic.num-di-ems       = tt-decla-import-ord.num-di-ems
          AND tt-decla-import-adic.cdd-siscomex-dts = tt-decla-import-ord.cdd-siscomex-dts NO-ERROR.

    IF AVAIL tt-decla-import-adic THEN
        ASSIGN i-num-adic = tt-decla-import-adic.num-adic + 1.
    ELSE
        ASSIGN i-num-adic = 1.

    IF p-num-adic <> 0
    AND tt-decla-import-ord.cdd-siscomex-dts = 0 THEN //Desconsidera DUIMP
        ASSIGN i-num-adic = p-num-adic.

    IF NOT CAN-FIND(FIRST tt-decla-import-adic
                    WHERE tt-decla-import-adic.num-di-ems = tt-decla-import-ord.num-di-ems
                    AND   tt-decla-import-adic.num-adic   = i-num-adic
                    AND   tt-decla-import-adic.cdd-siscomex-dts = tt-decla-import-ord.cdd-siscomex-dts) THEN DO:

        CREATE tt-decla-import-adic.
        FOR FIRST bf{&TABLENAME} NO-LOCK
            WHERE bf{&TABLENAME}.num-di-ems = tt-decla-import-ord.num-di-ems
              AND bf{&TABLENAME}.cdd-siscomex-dts = tt-decla-import-ord.cdd-siscomex-dts: END.

        FOR FIRST embarque-imp NO-LOCK
            WHERE embarque-imp.cod-estabel = tt-decla-import-ord.cod-estab
            AND   embarque-imp.embarque    = tt-decla-import-ord.cod-embarq : END.

        FOR FIRST item NO-LOCK
            WHERE item.it-codigo = tt-decla-import-ord.cod-item: END.

        IF NOT VALID-HANDLE(h-boin082) THEN
            RUN inbo/boin082.p  persistent set h-boin082.

        ASSIGN c-return = ''.
        RUN findCotacaoAprovada IN h-boin082 (INPUT tt-decla-import-ord.num-ordem, OUTPUT c-return).

        IF c-return = "" THEN DO:
            RUN getIntfield  IN h-boin082 (INPUT "mo-codigo":U, OUTPUT tt-decla-import-adic.cdn-moeda).
            RUN getCharField IN h-boin082 (INPUT "char-1":U,    OUTPUT c-char-1).
        END.

        FIND FIRST ordens-embarque
             WHERE ordens-embarque.embarque     = decla-import-ord.cod-embarq
               AND ordens-embarque.cod-estabel  = decla-import-ord.cod-estab
               AND ordens-embarque.numero-ordem = decla-import-ord.num-ordem
               AND ordens-embarque.parcela      = decla-import-ord.num-parcela NO-LOCK NO-ERROR.

        FIND FIRST processo-imp
             WHERE processo-imp.cod-estabel = tt-decla-import-ord.cod-estab
               AND processo-imp.nr-proc-imp = ordens-embarque.nr-proc-imp NO-LOCK NO-ERROR.

        IF AVAIL ordens-embarque THEN
            FOR FIRST licenciam-import-oc FIELDS(numero-ordem parcela dat-livre-1) NO-LOCK
                WHERE licenciam-import-oc.numero-ordem = ordens-embarque.numero-ordem
                  AND licenciam-import-oc.parcela      = ordens-embarque.parcela:

                ASSIGN tt-decla-import-adic.dat-livre-1 = licenciam-import-oc.dat-livre-1.
            END. /* for first licenciam-import-oc */

        IF AVAIL item AND item.tipo-contr = 4 AND c-return = "" AND SUBSTRING(c-char-1,81,20) <> "" THEN
            ASSIGN tt-decla-import-adic.cod-classif-fisc = SUBSTRING(c-char-1,81,20).
        ELSE
            ASSIGN tt-decla-import-adic.cod-classif-fisc = item.class-fiscal.

        ASSIGN tt-decla-import-adic.num-di-ems                  = tt-decla-import-ord.num-di-ems
               tt-decla-import-adic.num-adic                    = i-num-adic
               tt-decla-import-adic.cdd-siscomex-dts            = tt-decla-import-ord.cdd-siscomex-dts
               tt-decla-import-adic.cdn-agent                   = bf{&TABLENAME}.cdn-agent-carg-import
               tt-decla-import-adic.cod-aladi                   = tt-decla-import-ord.cod-aladi
               tt-decla-import-adic.cdn-banco                   = embarque-imp.cod-banco
               tt-decla-import-adic.cdn-classif-fisc-ex         = INT(item.dec-1)
               tt-decla-import-adic.cdn-corretor                = embarque-imp.cdn-corretor-cambio-import
               tt-decla-import-adic.cdn-fabrican                = tt-decla-import-ord.cdn-fabrican
               tt-decla-import-adic.cdn-fornec                  = tt-decla-import-ord.cdn-fornec
               tt-decla-import-adic.cod-naladi-ncca             = tt-decla-import-ord.cod-naladi-ncca
               tt-decla-import-adic.cdn-naladi-sist-harmon      = tt-decla-import-ord.cdn-naladi-sist-harmon
               tt-decla-import-adic.cod-nbm                     = tt-decla-import-ord.cod-nbm
               tt-decla-import-adic.cod-incoterm                = embarque-imp.cod-incoterm
               tt-decla-import-adic.cod-licenc-import           = tt-decla-import-ord.cod-licenc-import
               tt-decla-import-adic.cod-rof                     = embarque-imp.nr-rof
               tt-decla-import-adic.cod-tip-recip               = tt-decla-import-ord.cod-tip-recip
               tt-decla-import-adic.idi-ind-pagto               = tt-decla-import-ord.idi-ind-pagto
               tt-decla-import-adic.idi-metod-val               = tt-decla-import-ord.idi-metod-val
               tt-decla-import-adic.idi-tributac-cofins         = tt-decla-import-ord.idi-tributac-cofins
               tt-decla-import-adic.idi-tributac-icms           = tt-decla-import-ord.idi-tributac-icms
               tt-decla-import-adic.idi-tributac-impto-import   = tt-decla-import-ord.idi-tributac-impto-import
               tt-decla-import-adic.idi-tributac-ipi            = tt-decla-import-ord.idi-tributac-ipi
               tt-decla-import-adic.idi-tributac-pis            = tt-decla-import-ord.idi-tributac-pis
               tt-decla-import-adic.log-cofins-unid             = tt-decla-import-ord.log-cofins-unid
               tt-decla-import-adic.log-emite-fabrican          = tt-decla-import-ord.log-emite-fabrican
               tt-decla-import-adic.log-ipi-unid                = tt-decla-import-ord.log-ipi-unid
               tt-decla-import-adic.log-pis-unid                = tt-decla-import-ord.log-pis-unid
               tt-decla-import-adic.log-suspens-impto-import    = tt-decla-import-ord.log-suspens-impto-import
               tt-decla-import-adic.log-suspens-ipi-import      = tt-decla-import-ord.log-suspens-ipi-import
               &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN
                   tt-decla-import-adic.log-suspens-icms           = tt-decla-import-ord.log-suspens-icms
                   tt-decla-import-adic.log-suspens-pis            = tt-decla-import-ord.log-suspens-pis
                   tt-decla-import-adic.log-suspens-cofins         = tt-decla-import-ord.log-suspens-cofins
               &ELSE
                   OVERLAY(tt-decla-import-adic.cod-livre-1,1,1) = SUBSTRING(tt-decla-import-ord.cod-livre-1,1,1)
                   OVERLAY(tt-decla-import-adic.cod-livre-1,2,1) = SUBSTRING(tt-decla-import-ord.cod-livre-1,2,1)
                   OVERLAY(tt-decla-import-adic.cod-livre-1,3,1) = SUBSTRING(tt-decla-import-ord.cod-livre-1,3,1)
               &ENDIF
               tt-decla-import-adic.qtd-capac-recip             = tt-decla-import-ord.qtd-capac-recip
               tt-decla-import-adic.log-nec-licenc              = IF AVAIL param-imp AND SUBSTRING(param-imp.char-1,167,1) = "S":U THEN YES ELSE ITEM.log-necessita-li
               tt-decla-import-adic.idi-natur-cambial           = &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN
                                                                      embarque-imp.idi-natur-cambial
                                                                  &ELSE
                                                                      embarque-imp.int-1
                                                                  &ENDIF
               tt-decla-import-adic.val-aliq-cofins             = tt-decla-import-ord.val-aliq-cofins
               tt-decla-import-adic.val-aliq-icms               = tt-decla-import-ord.val-aliq-icms
               tt-decla-import-adic.val-aliq-ii                 = tt-decla-import-ord.val-aliq-ii
               tt-decla-import-adic.val-aliq-ipi                = tt-decla-import-ord.val-aliq-ipi
               tt-decla-import-adic.val-aliq-pis                = tt-decla-import-ord.val-aliq-pis
               tt-decla-import-adic.val-perc-reduc-cofins       = tt-decla-import-ord.val-perc-reduc-cofins
               tt-decla-import-adic.val-perc-reduc-icms         = tt-decla-import-ord.val-perc-reduc-icms
               tt-decla-import-adic.val-perc-reduc-impto-import = tt-decla-import-ord.val-perc-reduc-impto-import
               tt-decla-import-adic.val-perc-reduc-ipi          = tt-decla-import-ord.val-perc-reduc-ipi
               tt-decla-import-adic.val-perc-reduc-pis          = tt-decla-import-ord.val-perc-reduc-pis
               tt-decla-import-adic.val-unit-pis                = tt-decla-import-ord.val-unit-pis
               tt-decla-import-adic.val-unit-cofins             = tt-decla-import-ord.val-unit-cofins
               tt-decla-import-adic.val-unit-ipi                = tt-decla-import-ord.val-unit-ipi.
               /*tt-decla-import-adic.val-peso-liq                = tt-decla-import-adic.val-peso-liq + tt-decla-import-ord.val-peso-liq .*/

        /*busca moeda frete e busca moeda seguro*/
        FOR EACH despes-decla-import
           WHERE despes-decla-import.num-di-ems = tt-decla-import-ord.num-di-ems
             AND despes-decla-import.cdd-siscomex-dts = tt-decla-import-ord.cdd-siscomex-dts NO-LOCK:

            FIND FIRST desp-imp
                 WHERE desp-imp.cod-desp = despes-decla-import.cdn-despes NO-LOCK NO-ERROR.

            IF AVAIL desp-imp THEN DO:

                IF desp-imp.inc-val-frete THEN
                    ASSIGN tt-decla-import-adic.cdn-moed-frete  = despes-decla-import.cdn-moeda.
                    /*pegar desp-imp.cdn-moeda e jogar no tt-decla-import-adic.cdn-moed-frete e tt-decla-import-adic-itens.cdn-moed-frete */
                IF desp-imp.inc-val-seguro THEN
                    /*pegar desp-imp.cdn-moeda e jogar no tt-decla-import-adic.cdn-moed-seguro e tt-decla-import-adic-itens.cdn-moed-seguro */
                    ASSIGN tt-decla-import-adic.cdn-moed-seguro = despes-decla-import.cdn-moeda.
            END.
        END.

        IF l-nt2024002 then
            RUN pi-GeraDeclaImportAdicTrib(INPUT tt-decla-import-ord.num-di-ems,
                                           INPUT tt-decla-import-ord.cdd-siscomex-dts,
                                           INPUT tt-decla-import-ord.num-ordem,
                                           INPUT tt-decla-import-ord.num-parcela,
                                           INPUT tt-decla-import-adic.num-adic).

    END.
    ELSE DO:

        FOR FIRST tt-decla-import-adic
            WHERE tt-decla-import-adic.num-di-ems = tt-decla-import-ord.num-di-ems
            AND   tt-decla-import-adic.num-adic   = i-num-adic
            AND   tt-decla-import-adic.cdd-siscomex-dts = tt-decla-import-ord.cdd-siscomex-dts: END.
    END.

    RUN criaItemAdicao(INPUT tt-decla-import-adic.num-adic).

    IF VALID-HANDLE(h-boin082) THEN
        DELETE PROCEDURE h-boin082.
    ASSIGN h-boin082 = ?.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaItemAdicao DBOProgram
PROCEDURE criaItemAdicao :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-adic LIKE decla-import-adic.num-adic NO-UNDO.

    DEFINE VARIABLE l-quebra-nve       AS   LOGICAL                         NO-UNDO.
    DEFINE VARIABLE p-nova-adic-quebra LIKE decla-import-adic.num-adic      NO-UNDO.
    DEFINE VARIABLE i-seq              LIKE decla-import-adic-itens.num-seq NO-UNDO.

    DEFINE BUFFER b-tt-decla-import-adic FOR tt-decla-import-adic.

    FOR FIRST tt-decla-import-ord: END.

    ASSIGN l-quebra-nve = NO.

    IF  NOT l-im7000
    AND CAN-FIND(FIRST nve-item
                 WHERE nve-item.cod-item = tt-decla-import-ord.cod-item) THEN DO:

        IF CAN-FIND(FIRST tt-decla-import-adic-itens
                    WHERE tt-decla-import-adic-itens.num-adic = p-num-adic) THEN DO:

            FOR FIRST tt-decla-import-adic-itens NO-LOCK
                WHERE tt-decla-import-adic-itens.num-adic = p-num-adic :

                IF CAN-FIND(FIRST nve-item
                            WHERE nve-item.cod-item = tt-decla-import-adic-itens.cod-item) THEN DO:
                    /*LENDO AS NVE DO ITEM QUE ESTA SENDO INCLUIDO X ITENS QUE JA TEM NA ADIÄ«O*/
                    FOR EACH nve-item NO-LOCK
                        WHERE nve-item.cod-item = tt-decla-import-adic-itens.cod-item :

                        IF NOT CAN-FIND(FIRST bf-nve-item
                                        WHERE bf-nve-item.cod-item    = tt-decla-import-ord.cod-item
                                        AND   bf-nve-item.idi-niv     = nve-item.idi-niv
                                        AND   bf-nve-item.cod-ident   = nve-item.cod-ident
                                        AND   bf-nve-item.cod-atributo   = nve-item.cod-atributo
                                        AND   bf-nve-item.cdn-especif = nve-item.cdn-especif) THEN DO:
                            ASSIGN l-quebra-nve = YES.
                        END.
                    END.
                    /*LENDO AS NVE DOS ITENS QUE JA TEM NA ADIÄ«O X DO ITEM QUE ESTA SENDO INCLUIDO */
                    FOR EACH nve-item NO-LOCK
                        WHERE nve-item.cod-item = tt-decla-import-ord.cod-item :

                        IF NOT CAN-FIND(FIRST bf-nve-item
                                        WHERE bf-nve-item.cod-item    = tt-decla-import-adic-itens.cod-item
                                        AND   bf-nve-item.idi-niv     = nve-item.idi-niv
                                        AND   bf-nve-item.cod-ident   = nve-item.cod-ident
                                        AND   bf-nve-item.cod-atributo   = nve-item.cod-atributo
                                        AND   bf-nve-item.cdn-especif = nve-item.cdn-especif) THEN DO:
                            ASSIGN l-quebra-nve = YES.
                        END.
                    END.
                END.
                ELSE DO:
                    ASSIGN l-quebra-nve = YES.
                END.
            END.
        END.
    END.

    IF l-quebra-nve THEN DO:

        RUN pi-quebra-nve(OUTPUT p-nova-adic-quebra).

        IF p-nova-adic-quebra <> 0 THEN DO:
            RUN criaItemAdicaoQuebra(INPUT p-nova-adic-quebra).
        END.
        ELSE DO:
            RUN criaAdicao(INPUT TABLE tt-decla-import-ord, INPUT 0).
        END.
    END.
    ELSE DO:
        RUN criaItemAdicaoQuebra(INPUT p-num-adic).
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaItemAdicaoQuebra DBOProgram
PROCEDURE criaItemAdicaoQuebra :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-adic LIKE decla-import-adic.num-adic NO-UNDO.

    DEFINE VARIABLE i-seq        LIKE decla-import-adic-itens.num-seq NO-UNDO.
    DEFINE VARIABLE c-cClassTrib as char                              NO-UNDO.

    FOR FIRST tt-decla-import-ord: END.

    IF NOT AVAIL param-imp THEN
        FOR FIRST param-imp NO-LOCK: END.

    FIND LAST tt-decla-import-adic-itens
        WHERE tt-decla-import-adic-itens.num-di-ems = tt-decla-import-ord.num-di-ems
        AND   tt-decla-import-adic-itens.num-adic   = p-num-adic
        AND   tt-decla-import-adic-itens.cdd-siscomex-dts = tt-decla-import-ord.cdd-siscomex-dts NO-ERROR.

    IF AVAIL tt-decla-import-adic-itens THEN
        ASSIGN i-seq = tt-decla-import-adic-itens.num-seq + 1.
    ELSE
        ASSIGN i-seq = 1.

    FOR FIRST tt-decla-import-adic
        WHERE tt-decla-import-adic.num-di-ems = tt-decla-import-ord.num-di-ems
        AND   tt-decla-import-adic.num-adic   = p-num-adic
        AND   tt-decla-import-adic.cdd-siscomex-dts = tt-decla-import-ord.cdd-siscomex-dts:

        CREATE tt-decla-import-adic-itens.
        ASSIGN i-seq-item                             = i-seq-item + 1
               tt-decla-import-adic-itens.num-di-ems  = tt-decla-import-ord.num-di-ems
               tt-decla-import-adic-itens.num-adic    = p-num-adic
               tt-decla-import-adic-itens.num-seq     = i-seq
               tt-decla-import-adic-itens.cdd-siscomex-dts = tt-decla-import-ord.cdd-siscomex-dts
               tt-decla-import-adic-itens.num-livre-1 = i-seq-item.

        FOR FIRST item-mat NO-LOCK
            WHERE item-mat.it-codigo = tt-decla-import-ord.cod-item: END.

        RUN criaNveAdic (INPUT p-num-adic, INPUT item-mat.it-codigo).

        ASSIGN tt-decla-import-adic-itens.cdn-moeda                   = tt-decla-import-adic.cdn-moeda
               tt-decla-import-adic-itens.cdn-moed-frete              = tt-decla-import-adic.cdn-moed-frete
               tt-decla-import-adic-itens.cdn-moed-seguro             = tt-decla-import-adic.cdn-moed-seguro
               tt-decla-import-adic-itens.cod-embarq                  = tt-decla-import-ord.cod-embarq
               tt-decla-import-adic-itens.cod-estab                   = tt-decla-import-ord.cod-estab
               tt-decla-import-adic-itens.cod-item                    = tt-decla-import-ord.cod-item
               tt-decla-import-adic-itens.cod-natur-operac            = tt-decla-import-ord.cod-natur-operac
               tt-decla-import-adic-itens.dsl-especif                 = SUBSTRING(item-mat.char-2,24,150)
               tt-decla-import-adic-itens.idi-tributac-cofins         = tt-decla-import-ord.idi-tributac-cofins
               tt-decla-import-adic-itens.idi-tributac-icms           = tt-decla-import-ord.idi-tributac-icms
               tt-decla-import-adic-itens.idi-tributac-impto-import   = tt-decla-import-ord.idi-tributac-impto-import
               tt-decla-import-adic-itens.idi-tributac-ipi            = tt-decla-import-ord.idi-tributac-ipi
               tt-decla-import-adic-itens.idi-tributac-pis            = tt-decla-import-ord.idi-tributac-pis
               tt-decla-import-adic-itens.log-cofins-unid             = tt-decla-import-ord.log-cofins-unid
               tt-decla-import-adic-itens.log-ipi-unid                = tt-decla-import-ord.log-ipi-unid
               tt-decla-import-adic-itens.log-pis-unid                = tt-decla-import-ord.log-pis-unid
               tt-decla-import-adic-itens.log-suspens-impto-import    = tt-decla-import-ord.log-suspens-impto-import
               tt-decla-import-adic-itens.log-suspens-ipi-import      = tt-decla-import-ord.log-suspens-ipi-import
               tt-decla-import-adic-itens.num-ordem                   = tt-decla-import-ord.num-ordem
               tt-decla-import-adic-itens.num-parcela                 = tt-decla-import-ord.num-parcela
               tt-decla-import-adic-itens.qtd-adic[1]                 = tt-decla-import-ord.qtd-item
               tt-decla-import-adic-itens.qtd-adic[2]                 = tt-decla-import-ord.qtd-fornec
               tt-decla-import-adic-itens.cdn-moed-acresc             = &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN param-imp.cdn-moed-dolar &ELSE param-imp.int-2 &ENDIF
               tt-decla-import-adic-itens.val-aliq-cofins             = tt-decla-import-ord.val-aliq-cofins
               tt-decla-import-adic-itens.val-aliq-icms               = tt-decla-import-ord.val-aliq-icms
               tt-decla-import-adic-itens.val-aliq-ii                 = tt-decla-import-ord.val-aliq-ii
               tt-decla-import-adic-itens.val-aliq-ipi                = tt-decla-import-ord.val-aliq-ipi
               tt-decla-import-adic-itens.val-aliq-pis                = tt-decla-import-ord.val-aliq-pis
               tt-decla-import-adic-itens.val-perc-reduc-cofins       = tt-decla-import-ord.val-perc-reduc-cofins
               tt-decla-import-adic-itens.val-perc-reduc-icms         = tt-decla-import-ord.val-perc-reduc-icms
               tt-decla-import-adic-itens.val-perc-reduc-impto-import = tt-decla-import-ord.val-perc-reduc-impto-import
               tt-decla-import-adic-itens.val-perc-reduc-ipi          = tt-decla-import-ord.val-perc-reduc-ipi
               tt-decla-import-adic-itens.val-perc-reduc-pis          = tt-decla-import-ord.val-perc-reduc-pis
               tt-decla-import-adic-itens.log-suspens-impto-import    = tt-decla-import-ord.log-suspens-impto-import
               tt-decla-import-adic-itens.log-suspens-ipi-import      = tt-decla-import-ord.log-suspens-ipi-import
               tt-decla-import-adic-itens.val-unit-pis                = tt-decla-import-ord.val-unit-pis
               tt-decla-import-adic-itens.val-unit-cofins             = tt-decla-import-ord.val-unit-cofins
               tt-decla-import-adic-itens.val-unit-ipi                = tt-decla-import-ord.val-unit-ipi
               /*tt-decla-import-adic-itens.cdn-moed-vucv[1]          =
               tt-decla-import-adic-itens.cdn-moed-vucv[2]          = */ .

        ASSIGN tt-decla-import-ord.num-adic = tt-decla-import-adic-itens.num-adic
               /*VALORES DEVEM SER ACUMULADOS AP‡S A CRIAÄ«O DO ADIC-ITEM*/
               tt-decla-import-adic.qtd-ncm = tt-decla-import-adic.qtd-ncm + tt-decla-import-adic-itens.qtd-adic[1].

        IF l-nt2024002 then do:
            run pi-BuscacClassTribItem (input tt-decla-import-adic.num-di-ems,
                                        input tt-decla-import-adic.num-adic,
                                        input tt-decla-import-adic.cdd-siscomex-dts,
                                        output c-cClassTrib).
            IF c-cClassTrib <> "" THEN
                assign tt-decla-import-adic-itens.dsl-especif = "<":U + trim(c-cClassTrib) + "> ":U + tt-decla-import-adic-itens.dsl-especif.

            RUN pi-GeraDeclaImpAdicItemTrib(INPUT tt-decla-import-adic-itens.num-di-ems,
                                            INPUT tt-decla-import-adic-itens.cdd-siscomex-dts,
                                            INPUT tt-decla-import-adic.num-adic,
                                            INPUT tt-decla-import-adic-itens.num-seq).
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaNveAdic DBOProgram
PROCEDURE criaNveAdic :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-adic  LIKE decla-import-adic.num-adic NO-UNDO.
    DEFINE INPUT PARAMETER p-it-codigo LIKE item-mat.it-codigo         NO-UNDO.

    FOR EACH nve-item NO-LOCK
        WHERE nve-item.cod-item = p-it-codigo :

        IF NOT CAN-FIND(FIRST tt-decla-import-adic-nve
                        WHERE tt-decla-import-adic-nve.num-di-ems   = tt-decla-import-adic-itens.num-di-ems
                        AND   tt-decla-import-adic-nve.num-adic     = p-num-adic
                        AND   tt-decla-import-adic-nve.cdn-especif  = nve-item.cdn-especif
                        AND   tt-decla-import-adic-nve.cod-atributo = nve-item.cod-atributo
                        AND   tt-decla-import-adic-nve.cod-ident    = nve-item.cod-ident
                        AND   tt-decla-import-adic-nve.idi-niv      = nve-item.idi-niv
                        AND   tt-decla-import-adic-nve.cdd-siscomex-dts = tt-decla-import-adic-itens.cdd-siscomex-dts) THEN DO:

            CREATE tt-decla-import-adic-nve.
            ASSIGN tt-decla-import-adic-nve.cdn-especif   = nve-item.cdn-especif
                   tt-decla-import-adic-nve.cod-atributo  = nve-item.cod-atributo
                   tt-decla-import-adic-nve.cod-ident     = nve-item.cod-ident
                   tt-decla-import-adic-nve.idi-niv       = nve-item.idi-niv
                   tt-decla-import-adic-nve.num-adic      = p-num-adic
                   tt-decla-import-adic-nve.num-di-ems    = tt-decla-import-adic-itens.num-di-ems
                   tt-decla-import-adic-nve.cdd-siscomex-dts = tt-decla-import-adic-itens.cdd-siscomex-dts.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findBySiscomexAndEms DBOProgram
PROCEDURE findBySiscomexAndEms :
/*------------------------------------------------------------------------------
  Purpose:     MÇtodo utilizado para posicionar a Di tanto atravÇs do c¢digo do
               Siscomex quanto atravÇs do c¢digo do EMS
  Parameters:
               recebe valor do campo cod-di-siscomex ou num-di-ems
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-di LIKE decla-import.cod-di-siscomex NO-UNDO.

    IF CAN-FIND(FIRST decla-import
                WHERE decla-import.cod-di-siscomex = pcod-di)THEN
        FIND LAST bfdecla-import
            WHERE bfdecla-import.cod-di-siscomex = pcod-di NO-LOCK NO-ERROR.
    ELSE
        FIND LAST bfdecla-import
            WHERE STRING(bfdecla-import.num-di-ems) = pcod-di NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdecla-import THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdecla-import)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gerarAdicoes DBOProgram
PROCEDURE gerarAdicoes :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-di-ems LIKE {&TABLENAME}.num-di-ems NO-UNDO.
    DEFINE INPUT PARAMETER p-cdd-siscomex-dts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.
    DEFINE VARIABLE i-num-adic AS INTEGER     NO-UNDO.

    ASSIGN i-num-di-ems = p-num-di-ems
           i-seq-item   = 0.

    EMPTY TEMP-TABLE tt-decla-import-adic.
    EMPTY TEMP-TABLE tt-decla-import-adic-itens.
    EMPTY TEMP-TABLE tt-decla-import-adic-trib.
    EMPTY TEMP-TABLE tt-decla-imp-adic-it-trib.
    EMPTY TEMP-TABLE tt-decla-import-ord-aux.
    EMPTY TEMP-TABLE tt-decla-import-ord-aux2.

    FOR EACH decla-import-ord NO-LOCK
        WHERE decla-import-ord.num-di-ems = p-num-di-ems
          AND decla-import-ord.cdd-siscomex-dts = p-cdd-siscomex-dts:

        CREATE tt-decla-import-ord-aux2.
        BUFFER-COPY decla-import-ord TO tt-decla-import-ord-aux2.

        IF NOT VALID-HANDLE(h-bocx404) THEN
            RUN cxbo/bocx404.p PERSISTENT SET h-bocx404.

        RUN retornaClassFisc IN h-bocx404 (INPUT tt-decla-import-ord-aux2.num-ordem, OUTPUT c-classfis).

        ASSIGN tt-decla-import-ord-aux2.cod-classif-fisc = c-classfis.
    END.

    FOR EACH tt-decla-import-ord-aux2 NO-LOCK
       WHERE tt-decla-import-ord-aux2.num-di-ems = p-num-di-ems
         AND tt-decla-import-ord-aux2.cdd-siscomex-dts = p-cdd-siscomex-dts
          BY tt-decla-import-ord-aux2.cod-classif-fisc:

        FOR FIRST decla-import-ord NO-LOCK
            WHERE decla-import-ord.num-di-ems  = tt-decla-import-ord-aux2.num-di-ems
              AND decla-import-ord.num-ordem   = tt-decla-import-ord-aux2.num-ordem
              AND decla-import-ord.num-parcela = tt-decla-import-ord-aux2.num-parcela
              AND decla-import-ord.cdd-siscomex-dts = tt-decla-import-ord-aux2.cdd-siscomex-dts:

            EMPTY TEMP-TABLE tt-decla-import-ord.

            CREATE tt-decla-import-ord.
            BUFFER-COPY decla-import-ord EXCEPT num-adic TO tt-decla-import-ord.

            IF NOT CAN-FIND(FIRST tt-decla-import-adic
                            WHERE tt-decla-import-adic.num-di-ems = i-num-di-ems
                              AND tt-decla-import-adic.cdd-siscomex-dts = p-cdd-siscomex-dts) THEN DO:

                RUN criaAdicao(INPUT TABLE tt-decla-import-ord, INPUT 0).
            END.
            ELSE DO:
                RUN verificaQuebraAdicao.
            END.

            IF NOT CAN-FIND(FIRST tt-decla-import-ord-aux OF tt-decla-import-ord) THEN
                CREATE tt-decla-import-ord-aux.

            BUFFER-COPY tt-decla-import-ord TO tt-decla-import-ord-aux.
        END.
    END.

    IF NOT VALID-HANDLE(h-bocx403) THEN
        RUN cxbo/bocx403.p PERSISTENT SET h-bocx403.

    IF NOT VALID-HANDLE(h-bocx402) THEN
        RUN cxbo/bocx402.p PERSISTENT SET h-bocx402.

    IF NOT VALID-HANDLE(h-bocx393) THEN
        RUN cxbo/bocx393.p PERSISTENT SET h-bocx393.

    IF NOT VALID-HANDLE(h-bocx390) THEN DO:
        RUN cxbo/bocx390.p PERSISTENT SET h-bocx390.
        RUN openQueryStatic IN h-bocx390 (INPUT "Main":U) NO-ERROR.
    END.

    IF NOT VALID-HANDLE(h-bocx00506) THEN
        RUN cxbo/bocx00506.p PERSISTENT SET h-bocx00506.

    IF NOT VALID-HANDLE(h-bocx00512) THEN
        RUN cxbo/bocx00512.p PERSISTENT SET h-bocx00512.

    IF CAN-FIND(FIRST tt-decla-import-adic) THEN DO:

        ASSIGN i-num-adic = 0.

        FOR EACH tt-decla-import-adic:

            EMPTY TEMP-TABLE tt-decla-import-adic-aux.

            CREATE tt-decla-import-adic-aux.
            BUFFER-COPY tt-decla-import-adic TO tt-decla-import-adic-aux.

            RUN openQueryStatic IN h-bocx403(INPUT 'Main':U).
            RUN emptyRowErrors  IN h-bocx403.
            RUN emptyRowObject  IN h-bocx403.
            RUN setRecord       IN h-bocx403 (INPUT TABLE tt-decla-import-adic-aux).
            RUN createRecord    IN h-bocx403.

            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN getRowErrors IN h-bocx403(OUTPUT TABLE RowErrors APPEND).
            END.
            ELSE DO:

                ASSIGN i-num-adic = i-num-adic + 1.

                FOR EACH tt-decla-import-adic-itens
                   WHERE tt-decla-import-adic-itens.num-di-ems = i-num-di-ems
                   AND   tt-decla-import-adic-itens.num-adic   = tt-decla-import-adic.num-adic
                   AND   tt-decla-import-adic-itens.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts:

                    EMPTY TEMP-TABLE tt-decla-import-adic-itens-aux.
                    CREATE tt-decla-import-adic-itens-aux.
                    BUFFER-COPY tt-decla-import-adic-itens TO tt-decla-import-adic-itens-aux.

                    RUN openQueryStatic IN h-bocx402(INPUT 'Main':U).
                    RUN emptyRowErrors  IN h-bocx402.
                    RUN emptyRowObject  IN h-bocx402.
                    RUN setRecord       IN h-bocx402 (INPUT TABLE tt-decla-import-adic-itens-aux).
                    RUN createRecord    IN h-bocx402.

                    IF RETURN-VALUE = "NOK":U THEN DO:
                        RUN getRowErrors IN h-bocx402(OUTPUT TABLE RowErrors APPEND).
                    END.
                END.
            END.

            IF l-nt2024002 THEN DO:
                IF NOT CAN-FIND(FIRST RowErrors
                                WHERE RowErrors.errorType   <> "INTERNAL":U
                                AND   RowErrors.errorSubType = "ERROR":U) THEN DO:

                    FOR EACH tt-decla-import-adic-trib NO-LOCK
                        WHERE tt-decla-import-adic-trib.num-di-ems = i-num-di-ems
                        AND   tt-decla-import-adic-trib.num-adic   = tt-decla-import-adic.num-adic
                        AND   tt-decla-import-adic-trib.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts:

                        IF  LOOKUP(tt-decla-import-adic-trib.cod-campo, "C-CLASS-TRIB-REG,CST-REG,ALIQ-EFETIVA-REG") > 0
                        AND (tt-decla-import-adic-trib.cod-conteudo = "" OR tt-decla-import-adic-trib.cod-conteudo = "0") THEN DO:

                            RUN emptyRowObject  IN h-bocx00506.
                            RUN openQueryStatic IN h-bocx00506 (INPUT "Main":U) NO-ERROR.
                            RUN goToKey         IN h-bocx00506 (INPUT tt-decla-import-adic-trib.num-di-ems,
                                                                INPUT tt-decla-import-adic-trib.num-adic,
                                                                INPUT tt-decla-import-adic-trib.cdd-siscomex-dts,
                                                                INPUT tt-decla-import-adic-trib.nom-trib,
                                                                INPUT tt-decla-import-adic-trib.cod-campo).
                            IF RETURN-VALUE = "OK" THEN
                                RUN deleteRecord IN h-bocx00506.
                        END.
                        ELSE DO:

                            EMPTY TEMP-TABLE tt-decla-import-adic-trib-aux.
                            CREATE tt-decla-import-adic-trib-aux.
                            BUFFER-COPY tt-decla-import-adic-trib TO tt-decla-import-adic-trib-aux.

                            RUN openQueryStatic IN h-bocx00506(INPUT 'Main':U).
                            RUN emptyRowErrors  IN h-bocx00506.
                            RUN emptyRowObject  IN h-bocx00506.
                            RUN goToKey         IN h-bocx00506 (INPUT tt-decla-import-adic-trib.num-di-ems,
                                                                INPUT tt-decla-import-adic-trib.num-adic,
                                                                INPUT tt-decla-import-adic-trib.cdd-siscomex-dts,
                                                                INPUT tt-decla-import-adic-trib.nom-trib,
                                                                INPUT tt-decla-import-adic-trib.cod-campo).
                            IF RETURN-VALUE = "NOK" THEN DO:
                                RUN setRecord      IN h-bocx00506 (INPUT TABLE tt-decla-import-adic-trib-aux).
                                RUN createRecord   IN h-bocx00506.
                            END.
                        END.

                        IF RETURN-VALUE = "NOK":U THEN DO:
                            RUN getRowErrors IN h-bocx00506(OUTPUT TABLE RowErrors APPEND).
                        END.
                    END.

                    FOR EACH tt-decla-imp-adic-it-trib NO-LOCK
                        WHERE tt-decla-imp-adic-it-trib.num-di-ems = i-num-di-ems
                        AND   tt-decla-imp-adic-it-trib.num-adic   = tt-decla-import-adic.num-adic
                        AND   tt-decla-imp-adic-it-trib.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts:

                        IF  LOOKUP(tt-decla-imp-adic-it-trib.cod-campo, "C-CLASS-TRIB-REG,CST-REG,ALIQ-EFETIVA-REG") > 0
                        AND (tt-decla-imp-adic-it-trib.cod-conteudo = "" OR tt-decla-imp-adic-it-trib.cod-conteudo = "0") THEN DO:

                            RUN openQueryStatic IN h-bocx00512(INPUT 'Main':U).
                            RUN emptyRowErrors  IN h-bocx00512.
                            RUN emptyRowObject  IN h-bocx00512.
                            RUN goToKey         IN h-bocx00512 (INPUT tt-decla-imp-adic-it-trib.num-di-ems,
                                                                INPUT tt-decla-imp-adic-it-trib.num-adic,
                                                                INPUT tt-decla-imp-adic-it-trib.num-seq,
                                                                INPUT tt-decla-imp-adic-it-trib.cdd-siscomex-dts,
                                                                INPUT tt-decla-imp-adic-it-trib.nom-trib,
                                                                INPUT tt-decla-imp-adic-it-trib.cod-campo).
                            IF RETURN-VALUE = "OK" THEN
                                RUN deleteRecord IN h-bocx00512.
                        END.
                        ELSE DO:

                            EMPTY TEMP-TABLE tt-decla-imp-adic-it-trib-aux.
                            CREATE tt-decla-imp-adic-it-trib-aux.
                            BUFFER-COPY tt-decla-imp-adic-it-trib TO tt-decla-imp-adic-it-trib-aux.

                            RUN openQueryStatic IN h-bocx00512(INPUT 'Main':U).
                            RUN emptyRowErrors  IN h-bocx00512.
                            RUN emptyRowObject  IN h-bocx00512.
                            RUN goToKey         IN h-bocx00512 (INPUT tt-decla-imp-adic-it-trib-aux.num-di-ems,
                                                                INPUT tt-decla-imp-adic-it-trib-aux.num-adic,
                                                                INPUT tt-decla-imp-adic-it-trib-aux.num-seq,
                                                                INPUT tt-decla-imp-adic-it-trib-aux.cdd-siscomex-dts,
                                                                INPUT tt-decla-imp-adic-it-trib-aux.nom-trib,
                                                                INPUT tt-decla-imp-adic-it-trib-aux.cod-campo).
                            IF RETURN-VALUE = "NOK":U THEN DO:
                                RUN setRecord       IN h-bocx00512 (INPUT TABLE tt-decla-imp-adic-it-trib-aux).
                                RUN createRecord    IN h-bocx00512.
                            END.
                        END.
                        IF RETURN-VALUE = "NOK":U THEN DO:
                            RUN getRowErrors IN h-bocx00512(OUTPUT TABLE RowErrors APPEND).
                        END.
                    END.
                END.
            END.

            IF NOT CAN-FIND(FIRST RowErrors
                            WHERE RowErrors.errorType   <> "INTERNAL":U
                            AND   RowErrors.errorSubType = "ERROR":U) THEN DO:

                FOR EACH  tt-decla-import-adic-nve
                    WHERE tt-decla-import-adic-nve.num-di-ems = i-num-di-ems
                    AND   tt-decla-import-adic-nve.num-adic   = tt-decla-import-adic-aux.num-adic
                    AND   tt-decla-import-adic-nve.cdd-siscomex-dts = tt-decla-import-adic-aux.cdd-siscomex-dts:

                    EMPTY TEMP-TABLE tt-decla-import-adic-nve-aux.

                    CREATE tt-decla-import-adic-nve-aux.
                    BUFFER-COPY tt-decla-import-adic-nve TO tt-decla-import-adic-nve-aux.

                    RUN openQueryStatic IN h-bocx393(INPUT 'Main':U).
                    RUN emptyRowErrors  IN h-bocx393.
                    RUN emptyRowObject  IN h-bocx393.
                    RUN goToKey         IN h-bocx393(INPUT tt-decla-import-adic-nve-aux.num-di-ems,
                                                     INPUT tt-decla-import-adic-nve-aux.num-adic,
                                                     INPUT tt-decla-import-adic-nve-aux.idi-niv,
                                                     INPUT tt-decla-import-adic-nve-aux.cod-ident,
                                                     INPUT tt-decla-import-adic-nve-aux.cod-atributo,
                                                     INPUT tt-decla-import-adic-nve-aux.cdn-especif,
                                                     INPUT tt-decla-import-adic-nve-aux.cdd-siscomex-dts).

                    IF RETURN-VALUE = "NOK":U THEN DO:
                        RUN setRecord       IN h-bocx393 (INPUT TABLE tt-decla-import-adic-nve-aux).
                        RUN createRecord    IN h-bocx393.
                        IF RETURN-VALUE = "NOK":U THEN DO:
                            RUN getRowErrors IN h-bocx393(OUTPUT TABLE RowErrors APPEND).
                        END.
                    END.
                END.
            END.
        END.

        IF NOT CAN-FIND(FIRST RowErrors
                        WHERE RowErrors.errorType <> "INTERNAL":U ) THEN DO:

            FOR EACH tt-decla-import-ord-aux:

                EMPTY TEMP-TABLE tt-decla-import-ord.

                CREATE tt-decla-import-ord.
                BUFFER-COPY tt-decla-import-ord-aux TO tt-decla-import-ord.

                IF NOT VALID-HANDLE(h-bocx404) THEN
                    RUN cxbo/bocx404.p PERSISTENT SET h-bocx404.

                RUN openQueryStatic  IN h-bocx404 (INPUT 'Main':U).
                RUN goToKey          IN h-bocx404 (INPUT tt-decla-import-ord.num-di-ems,
                                                   INPUT tt-decla-import-ord.num-ordem,
                                                   INPUT tt-decla-import-ord.num-parcela,
                                                   INPUT tt-decla-import-ord.cdd-siscomex-dts).
                IF RETURN-VALUE = "OK":U THEN DO:
                    RUN getIntField    IN h-bocx404(INPUT "num-adic":U, OUTPUT tt-decla-import-ord.num-adic).
                    RUN getIntField    IN h-bocx404(INPUT "num-seq":U,  OUTPUT tt-decla-import-ord.num-seq).

                    RUN setRecord      IN h-bocx404(INPUT TABLE tt-decla-import-ord).
                    RUN updateRecord   IN h-bocx404.
                END.
            END.

            FOR FIRST decla-import EXCLUSIVE-LOCK
                WHERE decla-import.num-di-ems    = p-num-di-ems
                AND   decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts
                and   decla-import.log-ativo:

                ASSIGN d-peso-liq-total-di       = 0
                       d-peso-brut-merc-total-di = 0.

                /* Adiá‰es */
                FOR EACH  decla-import-adic NO-LOCK
                    WHERE decla-import-adic.num-di-ems = decla-import.num-di-ems
                      AND decla-import-adic.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:

                    ASSIGN d-peso-liq-total-di = d-peso-liq-total-di + decla-import-adic.val-peso-liq.
                END.

                FOR EACH  decla-import-ord NO-LOCK
                    WHERE decla-import-ord.num-di-ems = decla-import.num-di-ems
                      AND decla-import-ord.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:

                    ASSIGN d-peso-brut-merc-total-di = d-peso-brut-merc-total-di + decla-import-ord.val-peso-brut-merc.
                END.

                ASSIGN decla-import.val-peso-liq-di    = d-peso-liq-total-di
                       decla-import.val-peso-brut-merc = d-peso-brut-merc-total-di
                       decla-import.val-peso-brut-tot-di = decla-import.val-peso-brut-merc + decla-import.val-peso-embal-di
                       decla-import.num-adicoes          = i-num-adic.
            END. /* FOR FIRST decla-import */
        END. /* IF  NOT CAN-FIND(FIRST RowErrors */
    END.

    /*-------[ Calculo da taxa Siscomex ]------------------------------------*/
    /*---[ Despesas das Adiá‰es ]-----------------------------------------------------------------------------------*/
    FOR EACH despes-adic EXCLUSIVE-LOCK
       WHERE despes-adic.num-di-ems = i-num-di-ems
         AND despes-adic.cdd-siscomex-dts = p-cdd-siscomex-dts:

        DELETE despes-adic validate(true, "").
    END. /* FOR EACH   decla-import-adic */

    FIND FIRST decla-import no-lock
         WHERE decla-import.num-di-ems = i-num-di-ems
           AND decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts NO-ERROR.

    FIND FIRST param-imp NO-LOCK
         WHERE param-imp.cod-estabel = decla-import.cod-estab NO-ERROR.

    /* verificar param */
     ASSIGN l-utz-taxa-siscomex = param-imp.log-tax-siscomex
            i-cod-desp          = param-imp.cdn-despes-siscomex
            i-cod-emitente-desp = param-imp.cdn-emit-siscomex.

    ASSIGN d-val-despes-tot = 0.

    IF NOT VALID-HANDLE(h-bocx407) THEN
        RUN cxbo/bocx407.p PERSISTENT SET h-bocx407.

    IF NOT CAN-FIND(FIRST RowErrors
                    WHERE RowErrors.errorType <> "INTERNAL":U ) THEN DO:

        FOR FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = i-cod-emitente-desp:

            ASSIGN i-cod-cond-pag = emitente.cod-cond-pag.
        END.

        IF l-utz-taxa-siscomex THEN DO:

            RUN pi-seta-l-automatico IN h-bocx390(INPUT YES). /* seta a variavel l-automatico para yes, para passar pela validaá∆o do siscomex */

            /* gerar uma despesa para cada adicao (despes-adic)*/
            FOR EACH decla-import-adic NO-LOCK
               WHERE decla-import-adic.num-di-ems = i-num-di-ems
                 AND decla-import-adic.cdd-siscomex-dts = p-cdd-siscomex-dts,
                EACH decla-import-ord NO-LOCK
               WHERE decla-import-ord.num-di-ems = decla-import-adic.num-di-ems
                 AND decla-import-ord.num-adic   = decla-import-adic.num-adic
                 AND decla-import-ord.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts,
               FIRST ordens-embarque NO-LOCK
               WHERE ordens-embarque.embarque     = decla-import-ord.cod-embarq
                 AND ordens-embarque.cod-estabel  = decla-import-ord.cod-estab
                 AND ordens-embarque.numero-ordem = decla-import-ord.num-ordem
                 AND ordens-embarque.parcela      = decla-import-ord.num-parcela:

                RUN retorna-ponto-nacionalizacao IN h-bocx407 (INPUT decla-import-ord.cod-embarq,
                                                               INPUT decla-import-ord.cod-estab,
                                                               OUTPUT i-cdn-pto-nacionaliz-histor).

                ASSIGN d-val-despes = 0.
                       d-val-despes = ordens-embarque.val-tax-siscomex.

                FIND FIRST tt-despes-adic
                     WHERE tt-despes-adic.num-di-ems = decla-import-adic.num-di-ems
                     AND   tt-despes-adic.num-adic   = decla-import-adic.num-adic
                     AND   tt-despes-adic.cdn-despes = i-cod-desp
                     AND   tt-despes-adic.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts NO-ERROR.

                IF NOT AVAIL tt-despes-adic  THEN DO:

                    CREATE tt-despes-adic.
                    ASSIGN tt-despes-adic.num-di-ems        = decla-import-adic.num-di-ems
                           tt-despes-adic.num-adic          = decla-import-adic.num-adic
                           tt-despes-adic.cdn-despes        = i-cod-desp
                           tt-despes-adic.cdd-siscomex-dts  = decla-import-adic.cdd-siscomex-dts
                           tt-despes-adic.cdn-emit-despes   = i-cod-emitente-desp
                           tt-despes-adic.cdn-cond-pag      = i-cod-cond-pag
                           tt-despes-adic.cdn-moeda          = 0
                           tt-despes-adic.cdn-pto-control     = i-cdn-pto-nacionaliz-histor
                           tt-despes-adic.idi-orig-despes   = 2.

                    ASSIGN tt-despes-adic.val-despes = 0.

                    RUN pi-busca-valor-taxa-siscomex (INPUT decla-import.cod-estab,
                                                      INPUT tt-despes-adic.num-adic,
                                                      OUTPUT tt-despes-adic.val-despes).
                END.
                ELSE DO:
                    IF l-desemb-parc THEN DO:
                        ASSIGN tt-despes-adic.val-despes = tt-despes-adic.val-despes + d-val-despes.
                    END.
                END.
            END.

            RUN openQueryStatic IN h-bocx390 (INPUT "Main":U) NO-ERROR.
            RUN emptyRowObject  IN h-bocx390.
            RUN emptyRowErrors  IN h-bocx390.

            FOR EACH tt-despes-adic:

               EMPTY TEMP-TABLE tt-despes-adic-aux.

               CREATE tt-despes-adic-aux.
               BUFFER-COPY tt-despes-adic TO tt-despes-adic-aux.

               RUN goToKey IN h-bocx390(INPUT tt-despes-adic-aux.num-di-ems,
                                        INPUT tt-despes-adic-aux.num-adic,
                                        INPUT tt-despes-adic-aux.cdn-despes,
                                        INPUT tt-despes-adic-aux.cdn-emit-despes,
                                        INPUT tt-despes-adic-aux.cdd-siscomex-dts).

               IF RETURN-VALUE = "NOK":U THEN DO:

                    RUN setRecord       IN h-bocx390 (INPUT TABLE tt-despes-adic-aux).
                    RUN createRecord    IN h-bocx390.
                    RUN getRowErrors    IN h-bocx390(OUTPUT TABLE RowErrors).
                END.
                ELSE DO:

                    RUN setRecord       IN h-bocx390 (INPUT TABLE tt-despes-adic-aux).
                    RUN updateRecord    IN h-bocx390.
                END.
            END.
            /* seta a variavel l-automatico para yes, para passar pela validaá∆o do siscomex */
            RUN pi-seta-l-automatico IN h-bocx390(INPUT NO).
        END.

        /* totaliza as despesas do parametro (taxa siscomex) para a DI */
        RUN pi-totaliza-taxa-siscomex (INPUT i-num-di-ems,
                                       INPUT p-cdd-siscomex-dts).
    END.
    /*---------[ Fim - Calculo da taxa Siscomex ]--------------------------------------------*/

    RELEASE decla-import.
    RELEASE decla-import-adic.
    RELEASE decla-import-ord.
    RELEASE decla-import-adic-itens.
    RELEASE despes-decla-import.
    RELEASE despes-adic.
    RELEASE decla-import-cotac.

    IF VALID-HANDLE(h-bocx402) THEN
        DELETE PROCEDURE h-bocx402.
    ASSIGN h-bocx402 = ?.
    IF VALID-HANDLE(h-bocx403) THEN
        DELETE PROCEDURE h-bocx403.
    ASSIGN h-bocx403 = ?.
    IF VALID-HANDLE(h-bocx393) THEN
        DELETE PROCEDURE h-bocx393.
    ASSIGN h-bocx393 = ?.
    IF VALID-HANDLE(h-bocx390) THEN
        DELETE PROCEDURE h-bocx390.
    ASSIGN h-bocx390 = ?.
    IF VALID-HANDLE(h-bocx404) THEN
        DELETE PROCEDURE h-bocx404.
    ASSIGN h-bocx404 = ?.
    IF VALID-HANDLE(h-bocx407) THEN
        DELETE PROCEDURE h-bocx407.
    ASSIGN h-bocx407 = ?.
    IF VALID-HANDLE(h-bocx00506) THEN
        DELETE PROCEDURE h-bocx00506.
    ASSIGN h-bocx00506 = ?.
    IF VALID-HANDLE(h-bocx00512) THEN
        DELETE PROCEDURE h-bocx00512.
    ASSIGN h-bocx00512 = ?.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gerarItensDuimpAdic DBOProgram
PROCEDURE gerarItensDuimpAdic  :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-di-ems LIKE {&TABLENAME}.num-di-ems NO-UNDO.
    DEFINE INPUT PARAMETER p-cdd-siscomex-dts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.

    DEFINE VARIABLE i-num-adic       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-num-parcela    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-cod-fabricante AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cClasstrib     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE de-fator-conv    AS DECIMAL     NO-UNDO.

    ASSIGN i-num-di-ems = p-num-di-ems
           i-seq-item   = 0
           l-im7000     = YES.

    EMPTY TEMP-TABLE tt-decla-import-adic.
    EMPTY TEMP-TABLE tt-decla-import-adic-itens.
    EMPTY TEMP-TABLE tt-decla-import-adic-trib.
    EMPTY TEMP-TABLE tt-decla-imp-adic-it-trib.
    EMPTY TEMP-TABLE tt-decla-import-ord-aux.
    EMPTY TEMP-TABLE tt-decla-import-ord-aux2.
    EMPTY TEMP-TABLE tt-duimp-item.

    IF NOT VALID-HANDLE(h-bocx00488) THEN
        RUN cxbo/bocx00488.p PERSISTENT SET h-bocx00488.

    IF NOT VALID-HANDLE(h-bocx403) THEN
        RUN cxbo/bocx403.p PERSISTENT SET h-bocx403.

    IF NOT VALID-HANDLE(h-bocx402) THEN
        RUN cxbo/bocx402.p PERSISTENT SET h-bocx402.

    IF NOT VALID-HANDLE(h-bocx393) THEN
        RUN cxbo/bocx393.p PERSISTENT SET h-bocx393.

    IF NOT VALID-HANDLE(h-bocx390) THEN DO:
        RUN cxbo/bocx390.p PERSISTENT SET h-bocx390.
        RUN openQueryStatic IN h-bocx390 (INPUT "Main":U) NO-ERROR.
    END.

    IF NOT VALID-HANDLE(h-bocx00506) THEN
        RUN cxbo/bocx00506.p PERSISTENT SET h-bocx00506.

    IF NOT VALID-HANDLE(h-bocx00512) THEN
        RUN cxbo/bocx00512.p PERSISTENT SET h-bocx00512.

    FOR EACH decla-import-ord NO-LOCK
        WHERE decla-import-ord.num-di-ems = p-num-di-ems
          AND decla-import-ord.cdd-siscomex-dts = p-cdd-siscomex-dts:

        CREATE tt-decla-import-ord-aux2.
        BUFFER-COPY decla-import-ord TO tt-decla-import-ord-aux2.

        IF NOT VALID-HANDLE(h-bocx404) THEN
            RUN cxbo/bocx404.p PERSISTENT SET h-bocx404.

        RUN retornaClassFisc IN h-bocx404 (INPUT tt-decla-import-ord-aux2.num-ordem, OUTPUT c-classfis).

        ASSIGN tt-decla-import-ord-aux2.cod-classif-fisc = c-classfis.
    END.

    ASSIGN i-num-parcela = 0.
    FOR EACH tt-decla-import-ord-aux2 NO-LOCK
       WHERE tt-decla-import-ord-aux2.num-di-ems       = p-num-di-ems
         AND tt-decla-import-ord-aux2.cdd-siscomex-dts = p-cdd-siscomex-dts
          BY tt-decla-import-ord-aux2.num-ordem
          BY tt-decla-import-ord-aux2.num-parcela:

        FOR FIRST decla-import-ord NO-LOCK
            WHERE decla-import-ord.num-di-ems  = tt-decla-import-ord-aux2.num-di-ems
              AND decla-import-ord.num-ordem   = tt-decla-import-ord-aux2.num-ordem
              AND decla-import-ord.num-parcela = tt-decla-import-ord-aux2.num-parcela
              AND decla-import-ord.cdd-siscomex-dts = tt-decla-import-ord-aux2.cdd-siscomex-dts:

            EMPTY TEMP-TABLE tt-decla-import-ord.

            CREATE tt-decla-import-ord.
            BUFFER-COPY decla-import-ord EXCEPT num-adic TO tt-decla-import-ord.

            RUN criaAdicao (INPUT TABLE tt-decla-import-ord, INPUT 1).

            IF NOT CAN-FIND(FIRST tt-decla-import-ord-aux OF tt-decla-import-ord) THEN
                CREATE tt-decla-import-ord-aux.

            BUFFER-COPY tt-decla-import-ord TO tt-decla-import-ord-aux.
        END.
    END.

    IF CAN-FIND(FIRST tt-decla-import-adic) THEN DO:

        ASSIGN i-num-adic = 0.

        FOR EACH tt-decla-import-adic:

            EMPTY TEMP-TABLE tt-decla-import-adic-aux.

            CREATE tt-decla-import-adic-aux.
            BUFFER-COPY tt-decla-import-adic TO tt-decla-import-adic-aux.

            RUN openQueryStatic IN h-bocx403(INPUT 'Main':U).
            RUN emptyRowErrors  IN h-bocx403.
            RUN emptyRowObject  IN h-bocx403.
            RUN setRecord       IN h-bocx403 (INPUT TABLE tt-decla-import-adic-aux).
            RUN createRecord    IN h-bocx403.

            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN getRowErrors IN h-bocx403(OUTPUT TABLE RowErrors APPEND).
            END.
            ELSE DO:
                ASSIGN i-num-adic = i-num-adic + 1.

                FOR EACH tt-decla-import-adic-itens
                   WHERE tt-decla-import-adic-itens.num-di-ems = i-num-di-ems
                   AND   tt-decla-import-adic-itens.num-adic   = tt-decla-import-adic.num-adic
                   AND   tt-decla-import-adic-itens.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts:

                    EMPTY TEMP-TABLE tt-decla-import-adic-itens-aux.
                    CREATE tt-decla-import-adic-itens-aux.
                    BUFFER-COPY tt-decla-import-adic-itens TO tt-decla-import-adic-itens-aux.

                    RUN openQueryStatic IN h-bocx402(INPUT 'Main':U).
                    RUN emptyRowErrors  IN h-bocx402.
                    RUN emptyRowObject  IN h-bocx402.
                    RUN setRecord       IN h-bocx402 (INPUT TABLE tt-decla-import-adic-itens-aux).
                    RUN createRecord    IN h-bocx402.

                    IF RETURN-VALUE = "NOK":U THEN DO:
                        RUN getRowErrors IN h-bocx402(OUTPUT TABLE RowErrors APPEND).
                    END.

                END.
            END.
            IF l-nt2024002 THEN DO:
                IF NOT CAN-FIND(FIRST RowErrors
                                WHERE RowErrors.errorType   <> "INTERNAL":U
                                AND   RowErrors.errorSubType = "ERROR":U) THEN DO:

                    FOR EACH tt-decla-import-adic-trib NO-LOCK
                        WHERE tt-decla-import-adic-trib.num-di-ems = i-num-di-ems
                        AND   tt-decla-import-adic-trib.num-adic   = tt-decla-import-adic.num-adic
                        AND   tt-decla-import-adic-trib.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts:

                        IF  LOOKUP(tt-decla-import-adic-trib.cod-campo, "C-CLASS-TRIB-REG,CST-REG,ALIQ-EFETIVA-REG") > 0
                        AND (tt-decla-import-adic-trib.cod-conteudo = "" OR tt-decla-import-adic-trib.cod-conteudo = "0") THEN DO:

                            RUN emptyRowObject  IN h-bocx00506.
                            RUN openQueryStatic IN h-bocx00506 (INPUT "Main":U) NO-ERROR.
                            RUN goToKey         IN h-bocx00506 (INPUT tt-decla-import-adic-trib.num-di-ems,
                                                                INPUT tt-decla-import-adic-trib.num-adic,
                                                                INPUT tt-decla-import-adic-trib.cdd-siscomex-dts,
                                                                INPUT tt-decla-import-adic-trib.nom-trib,
                                                                INPUT tt-decla-import-adic-trib.cod-campo).
                            IF RETURN-VALUE = "OK" THEN
                                RUN deleteRecord IN h-bocx00506.
                        END.
                        ELSE DO:

                            EMPTY TEMP-TABLE tt-decla-import-adic-trib-aux.
                            CREATE tt-decla-import-adic-trib-aux.
                            BUFFER-COPY tt-decla-import-adic-trib TO tt-decla-import-adic-trib-aux.

                            RUN openQueryStatic IN h-bocx00506(INPUT 'Main':U).
                            RUN emptyRowErrors  IN h-bocx00506.
                            RUN emptyRowObject  IN h-bocx00506.
                            RUN goToKey         IN h-bocx00506 (INPUT tt-decla-import-adic-trib.num-di-ems,
                                                                INPUT tt-decla-import-adic-trib.num-adic,
                                                                INPUT tt-decla-import-adic-trib.cdd-siscomex-dts,
                                                                INPUT tt-decla-import-adic-trib.nom-trib,
                                                                INPUT tt-decla-import-adic-trib.cod-campo).
                            IF RETURN-VALUE = "NOK" THEN DO:
                                RUN setRecord      IN h-bocx00506 (INPUT TABLE tt-decla-import-adic-trib-aux).
                                RUN createRecord   IN h-bocx00506.
                            END.
                        END.

                        IF RETURN-VALUE = "NOK":U THEN DO:
                            RUN getRowErrors IN h-bocx00506(OUTPUT TABLE RowErrors APPEND).
                        END.
                    END.

                    FOR EACH tt-decla-imp-adic-it-trib NO-LOCK
                        WHERE tt-decla-imp-adic-it-trib.num-di-ems = i-num-di-ems
                        AND   tt-decla-imp-adic-it-trib.num-adic   = tt-decla-import-adic.num-adic
                        AND   tt-decla-imp-adic-it-trib.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts:

                        IF  LOOKUP(tt-decla-imp-adic-it-trib.cod-campo, "C-CLASS-TRIB-REG,CST-REG,ALIQ-EFETIVA-REG") > 0
                        AND (tt-decla-imp-adic-it-trib.cod-conteudo = "" OR tt-decla-imp-adic-it-trib.cod-conteudo = "0") THEN DO:

                            RUN openQueryStatic IN h-bocx00512(INPUT 'Main':U).
                            RUN emptyRowErrors  IN h-bocx00512.
                            RUN emptyRowObject  IN h-bocx00512.
                            RUN goToKey         IN h-bocx00512 (INPUT tt-decla-imp-adic-it-trib.num-di-ems,
                                                                INPUT tt-decla-imp-adic-it-trib.num-adic,
                                                                INPUT tt-decla-imp-adic-it-trib.num-seq,
                                                                INPUT tt-decla-imp-adic-it-trib.cdd-siscomex-dts,
                                                                INPUT tt-decla-imp-adic-it-trib.nom-trib,
                                                                INPUT tt-decla-imp-adic-it-trib.cod-campo).
                            IF RETURN-VALUE = "OK" THEN
                                RUN deleteRecord IN h-bocx00512.
                        END.
                        ELSE DO:

                            EMPTY TEMP-TABLE tt-decla-imp-adic-it-trib-aux.
                            CREATE tt-decla-imp-adic-it-trib-aux.
                            BUFFER-COPY tt-decla-imp-adic-it-trib TO tt-decla-imp-adic-it-trib-aux.

                            RUN openQueryStatic IN h-bocx00512(INPUT 'Main':U).
                            RUN emptyRowErrors  IN h-bocx00512.
                            RUN emptyRowObject  IN h-bocx00512.
                            RUN goToKey         IN h-bocx00512 (INPUT tt-decla-imp-adic-it-trib-aux.num-di-ems,
                                                                INPUT tt-decla-imp-adic-it-trib-aux.num-adic,
                                                                INPUT tt-decla-imp-adic-it-trib-aux.num-seq,
                                                                INPUT tt-decla-imp-adic-it-trib-aux.cdd-siscomex-dts,
                                                                INPUT tt-decla-imp-adic-it-trib-aux.nom-trib,
                                                                INPUT tt-decla-imp-adic-it-trib-aux.cod-campo).
                            IF RETURN-VALUE = "NOK":U THEN DO:
                                RUN setRecord       IN h-bocx00512 (INPUT TABLE tt-decla-imp-adic-it-trib-aux).
                                RUN createRecord    IN h-bocx00512.
                            END.
                        END.
                        IF RETURN-VALUE = "NOK":U THEN DO:
                            RUN getRowErrors IN h-bocx00512(OUTPUT TABLE RowErrors APPEND).
                        END.
                    END.
                END.
            END.
        END.

        IF NOT CAN-FIND(FIRST RowErrors
                        WHERE RowErrors.errorType <> "INTERNAL":U ) THEN DO:

            FOR EACH tt-decla-import-ord-aux:

                EMPTY TEMP-TABLE tt-decla-import-ord.

                CREATE tt-decla-import-ord.
                BUFFER-COPY tt-decla-import-ord-aux TO tt-decla-import-ord.

                IF NOT VALID-HANDLE(h-bocx404) THEN
                    RUN cxbo/bocx404.p PERSISTENT SET h-bocx404.

                RUN openQueryStatic  IN h-bocx404 (INPUT 'Main':U).
                RUN goToKey          IN h-bocx404 (INPUT tt-decla-import-ord.num-di-ems,
                                                   INPUT tt-decla-import-ord.num-ordem,
                                                   INPUT tt-decla-import-ord.num-parcela,
                                                   INPUT tt-decla-import-ord.cdd-siscomex-dts).
                IF RETURN-VALUE = "OK":U THEN DO:
                    RUN getIntField    IN h-bocx404(INPUT "num-adic":U, OUTPUT tt-decla-import-ord.num-adic).
                    RUN getIntField    IN h-bocx404(INPUT "num-seq":U,  OUTPUT tt-decla-import-ord.num-seq).

                    RUN setRecord      IN h-bocx404(INPUT TABLE tt-decla-import-ord).
                    RUN updateRecord   IN h-bocx404.
                END.

                FOR FIRST tt-duimp-item
                    WHERE tt-duimp-item.cod-duimp-dts     = tt-decla-import-ord.num-di-ems
                      and tt-duimp-item.num-di-ems        = tt-decla-import-ord.num-di-ems
                      AND tt-duimp-item.cod-item          = tt-decla-import-ord.cod-item
                      AND tt-duimp-item.seq-item          = tt-decla-import-ord.num-adic:
                END.
                IF NOT AVAIL tt-duimp-item THEN DO:

                    CREATE tt-duimp-item.
                    ASSIGN tt-duimp-item.cod-duimp-dts    = tt-decla-import-ord.num-di-ems
                           tt-duimp-item.num-di-ems       = tt-decla-import-ord.num-di-ems
                           tt-duimp-item.cod-item         = tt-decla-import-ord.cod-item
                           tt-duimp-item.seq-item         = tt-decla-import-ord.num-adic.
                END.
                ASSIGN tt-duimp-item.numero-ordem          = tt-decla-import-ord.num-ordem
                       tt-duimp-item.embarque              = tt-decla-import-ord.cod-embarq
                       tt-duimp-item.cod-emitente          = tt-decla-import-ord.cdn-fornec
                       tt-duimp-item.cod-estabel           = tt-decla-import-ord.cod-estab
                       tt-duimp-item.unid-com              = tt-decla-import-ord.cod-unid-med-fornec
                       tt-duimp-item.nat-operacao          = tt-decla-import-ord.cod-natur-operac
                       tt-duimp-item.qtd-com               = tt-decla-import-ord.qtd-fornec
                       tt-duimp-item.qtd-med               = tt-decla-import-ord.qtd-item
                       tt-duimp-item.peso-liq              = tt-decla-import-ord.val-peso-liq.

                //Tratamento quantidade Unidade Estat°stica NCM
                ASSIGN de-fator-conv = 0.
                FOR FIRST ITEM NO-LOCK
                    WHERE ITEM.it-codigo = tt-duimp-item.cod-item:

                    ASSIGN de-fator-conv = DECIMAL(TRIM(SUBSTRING(item.char-1,321,20))). /* fator conv p/ unid tribut - tabela item */

                    IF de-fator-conv <> 0 THEN
                        ASSIGN tt-duimp-item.qtd-med = ROUND(tt-decla-import-ord.qtd-item * de-fator-conv, 4).
                END.

                for first duimp-siscomex
                    where duimp-siscomex.cod-duimp-dts = tt-duimp-item.cod-duimp-dts no-lock:
                   assign tt-duimp-item.cod-pais-iso-exporta     = duimp-siscomex.cod-pais-iso.
                end.

                 FIND FIRST processo-imp NO-LOCK
                      WHERE processo-imp.num-pedido = ordem-compra.num-pedido NO-ERROR.
                 IF AVAIL processo-imp then
                     ASSIGN tt-duimp-item.cdn-exporta = string(processo-imp.cod-exportador)
                            c-cod-fabricante = string(processo-imp.cod-fabricante).

                for first ordens-embarque NO-LOCK
                    WHERE ordens-embarque.embarque     = tt-decla-import-ord.cod-embarq
                      AND ordens-embarque.cod-estabel  = tt-decla-import-ord.cod-estab
                      AND ordens-embarque.numero-ordem = tt-decla-import-ord.num-ordem
                      AND ordens-embarque.parcela      = tt-decla-import-ord.num-parcela,
                      first ordem-compra
                      where ordem-compra.numero-ordem = ordens-embarque.numero-ordem no-lock,
                      first embarque-imp
                      where embarque-imp.cod-estabel = ordens-embarque.cod-estabel
                        and embarque-imp.embarque    = ordens-embarque.embarque no-lock:

                      assign tt-duimp-item.incoterm   = embarque-imp.cod-incoterm
                             tt-duimp-item.numero-rof = embarque-imp.nr-rof.

                      /* Local de Consumo: grava UF + codigo IBGE no cod-livre-1 */
                      RUN pi-monta-local-consumo (INPUT  ordens-embarque.cod-estabel,
                                                  INPUT  ordens-embarque.numero-ordem,
                                                  OUTPUT tt-duimp-item.cod-livre-1).

                      FOR first incoterm where incoterm.incoterm = embarque-imp.cod-incoterm no-lock:
                         assign tt-duimp-item.compl-incoterm = incoterm.descricao.
                      END.

                      /* Busca a comercializacao */
                      for first natur-oper
                          where natur-oper.nat-operacao = tt-duimp-item.nat-operacao no-lock:
                          ASSIGN tt-duimp-item.aplicacao = if natur-oper.consum-final then 2 else 1.
                      end.

                      /* Cotacao do item */
                    FIND FIRST cotacao-item NO-LOCK
                         WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                         AND   cotacao-item.cod-emitente = ordem-compra.cod-emitente
                         AND   cotacao-item.it-codigo    = ordem-compra.it-codigo
                         AND   cotacao-item.cot-aprovada NO-ERROR.
                    IF  AVAIL cotacao-item THEN DO:
                        ASSIGN tt-duimp-item.vlr-unit-mo = (cotacao-item.pre-unit-for * 100) / (100 + cotacao-item.aliquota-ipi)
                               tt-duimp-item.mo-codigo  = cotacao-item.mo-codigo.

                          /* Sugere Fabricante e Pais da Cotaá∆o Item - IM0060 */
                          ASSIGN tt-duimp-item.cdn-fabrican  = TRIM(substring(cotacao-item.char-2,41,20)).

                          /* Sugere Fabricante do Processo Importaá∆o - IM0040 ou Fornecedor */
                          IF tt-duimp-item.cdn-fabrican = "0"
                          OR (tt-duimp-item.cdn-fabrican = string(ordem-compra.cod-emitente) AND tt-duimp-item.cdn-fabrican <> c-cod-fabricante) THEN
                              ASSIGN tt-duimp-item.cdn-fabrican = IF c-cod-fabricante <> "0" THEN c-cod-fabricante ELSE string(ordem-compra.cod-emitente).

                          /* Atualiza flag "Fornecedor Ç fabricante?" */
                          IF (tt-decla-import-ord.cdn-fornec = tt-decla-import-ord.cdn-fabrican) THEN
                                ASSIGN tt-decla-import-ord.log-emite-fabrican  = YES.

                    END.
                end.

                IF  l-nt2024002 THEN DO:
                    ASSIGN c-cClasstrib = "".
                    RUN openQueryStatic  IN h-bocx00506(INPUT 'Main':U).
                    RUN emptyRowErrors   IN h-bocx00506.
                    RUN emptyRowObject   IN h-bocx00506.

                    RUN goToKey          IN h-bocx00506 (INPUT tt-decla-import-ord.num-di-ems,
                                                         INPUT tt-decla-import-ord.num-adic,
                                                         INPUT tt-decla-import-ord.cdd-siscomex-dts,
                                                         INPUT "CBS":U,         /* nom-trib */
                                                         INPUT "C-CLASS-TRIB"). /* cod-campo */
                    IF RETURN-VALUE = "NOK":U THEN
                        RUN goToKey      IN h-bocx00506 (INPUT tt-decla-import-ord.num-di-ems,
                                                         INPUT tt-decla-import-ord.num-adic,
                                                         INPUT tt-decla-import-ord.cdd-siscomex-dts,
                                                         INPUT "IBSUF":U,       /* nom-trib */
                                                         INPUT "C-CLASS-TRIB"). /* cod-campo */
                    IF RETURN-VALUE = "NOK":U THEN
                        RUN goToKey      IN h-bocx00506 (INPUT tt-decla-import-ord.num-di-ems,
                                                         INPUT tt-decla-import-ord.num-adic,
                                                         INPUT tt-decla-import-ord.cdd-siscomex-dts,
                                                         INPUT "IBSMUN":U,      /* nom-trib */
                                                         INPUT "C-CLASS-TRIB"). /* cod-campo */
                    IF RETURN-VALUE <> "NOK":U THEN DO:
                        RUN getCharField IN h-bocx00506 (INPUT "cod-conteudo":U, OUTPUT c-cClasstrib).
                        ASSIGN tt-duimp-item.desc-comp = IF c-cClasstrib <> "" THEN "<":U + TRIM(c-cClasstrib) + ">":U
                                                         ELSE tt-duimp-item.desc-comp.
                    END.
                END.

                RUN openQueryStatic  IN h-bocx00488 (INPUT "Main":U) NO-ERROR.
                RUN emptyRowErrors   IN h-bocx00488.
                RUN emptyRowObject   IN h-bocx00488.
                RUN goToKey          IN h-bocx00488 (INPUT tt-duimp-item.num-di-ems,
                                                     INPUT tt-duimp-item.cod-item,
                                                     INPUT tt-duimp-item.seq-item).
                IF  RETURN-VALUE = "OK":U THEN DO:
                    RUN setRecord    IN h-bocx00488 (INPUT TABLE tt-duimp-item).
                    RUN updateRecord IN h-bocx00488.
                END.
                ELSE DO:
                    RUN setRecord    IN h-bocx00488 (INPUT TABLE tt-duimp-item).
                    RUN createRecord IN h-bocx00488.
                END.
                RUN getRowErrors     IN h-bocx00488 (OUTPUT TABLE RowErrors).

                DELETE tt-duimp-item.
            END.

            FOR FIRST decla-import EXCLUSIVE-LOCK
                WHERE decla-import.num-di-ems    = p-num-di-ems
                AND   decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts
                and   decla-import.log-ativo:

                ASSIGN d-peso-liq-total-di       = 0
                       d-peso-brut-merc-total-di = 0.

                /* Adiá‰es */
                FOR EACH  decla-import-adic NO-LOCK
                    WHERE decla-import-adic.num-di-ems = decla-import.num-di-ems
                      AND decla-import-adic.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:

                    ASSIGN d-peso-liq-total-di = d-peso-liq-total-di + decla-import-adic.val-peso-liq.
                END.

                FOR EACH  decla-import-ord NO-LOCK
                    WHERE decla-import-ord.num-di-ems = decla-import.num-di-ems
                      AND decla-import-ord.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:

                    ASSIGN d-peso-brut-merc-total-di = d-peso-brut-merc-total-di + decla-import-ord.val-peso-brut-merc.
                END.

                ASSIGN decla-import.val-peso-liq-di    = d-peso-liq-total-di
                       decla-import.val-peso-brut-merc = d-peso-brut-merc-total-di
                       decla-import.val-peso-brut-tot-di = decla-import.val-peso-brut-merc + decla-import.val-peso-embal-di
                       decla-import.num-adicoes          = i-num-adic.
            END. /* FOR FIRST decla-import */
        END. /* IF  NOT CAN-FIND(FIRST RowErrors */
    END.

    /*-------[ Calculo da taxa Siscomex ]------------------------------------*/
    /*---[ Despesas das Adiá‰es ]-----------------------------------------------------------------------------------*/
    FOR EACH despes-adic EXCLUSIVE-LOCK
       WHERE despes-adic.num-di-ems = i-num-di-ems
         AND despes-adic.cdd-siscomex-dts = p-cdd-siscomex-dts:

        DELETE despes-adic validate(true, "").
    END. /* FOR EACH   decla-import-adic */

    FIND FIRST decla-import no-lock
         WHERE decla-import.num-di-ems = i-num-di-ems
           AND decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts NO-ERROR.

    FIND FIRST param-imp NO-LOCK
         WHERE param-imp.cod-estabel = decla-import.cod-estab NO-ERROR.

    /* verificar param */
     ASSIGN l-utz-taxa-siscomex = param-imp.log-tax-siscomex
            i-cod-desp          = param-imp.cdn-despes-siscomex
            i-cod-emitente-desp = param-imp.cdn-emit-siscomex.

    ASSIGN d-val-despes-tot = 0.

    IF NOT VALID-HANDLE(h-bocx407) THEN
        RUN cxbo/bocx407.p PERSISTENT SET h-bocx407.

    IF NOT CAN-FIND(FIRST RowErrors
                    WHERE RowErrors.errorType <> "INTERNAL":U ) THEN DO:

        FOR FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = i-cod-emitente-desp:

            ASSIGN i-cod-cond-pag = emitente.cod-cond-pag.
        END.

        IF l-utz-taxa-siscomex THEN DO:

            RUN pi-seta-l-automatico IN h-bocx390(INPUT YES). /* seta a variavel l-automatico para yes, para passar pela validaá∆o do siscomex */

            /* gerar uma despesa para cada adicao (despes-adic)*/
            FOR EACH decla-import-adic NO-LOCK
               WHERE decla-import-adic.num-di-ems = i-num-di-ems
                 AND decla-import-adic.cdd-siscomex-dts = p-cdd-siscomex-dts,
                EACH decla-import-ord NO-LOCK
               WHERE decla-import-ord.num-di-ems = decla-import-adic.num-di-ems
                 AND decla-import-ord.num-adic   = decla-import-adic.num-adic
                 AND decla-import-ord.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts,
               FIRST ordens-embarque NO-LOCK
               WHERE ordens-embarque.embarque     = decla-import-ord.cod-embarq
                 AND ordens-embarque.cod-estabel  = decla-import-ord.cod-estab
                 AND ordens-embarque.numero-ordem = decla-import-ord.num-ordem
                 AND ordens-embarque.parcela      = decla-import-ord.num-parcela:

                RUN retorna-ponto-nacionalizacao IN h-bocx407 (INPUT decla-import-ord.cod-embarq,
                                                               INPUT decla-import-ord.cod-estab,
                                                               OUTPUT i-cdn-pto-nacionaliz-histor).

                ASSIGN d-val-despes = 0.
                       d-val-despes = ordens-embarque.val-tax-siscomex.

                FIND FIRST tt-despes-adic
                     WHERE tt-despes-adic.num-di-ems = decla-import-adic.num-di-ems
                     AND   tt-despes-adic.num-adic   = decla-import-adic.num-adic
                     AND   tt-despes-adic.cdn-despes = i-cod-desp
                     AND   tt-despes-adic.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts NO-ERROR.

                IF NOT AVAIL tt-despes-adic  THEN DO:

                    CREATE tt-despes-adic.
                    ASSIGN tt-despes-adic.num-di-ems        = decla-import-adic.num-di-ems
                           tt-despes-adic.num-adic          = decla-import-adic.num-adic
                           tt-despes-adic.cdn-despes        = i-cod-desp
                           tt-despes-adic.cdd-siscomex-dts  = decla-import-adic.cdd-siscomex-dts
                           tt-despes-adic.cdn-emit-despes   = i-cod-emitente-desp
                           tt-despes-adic.cdn-cond-pag      = i-cod-cond-pag
                           tt-despes-adic.cdn-moed          = 0
                           tt-despes-adic.cdn-pto-contr     = i-cdn-pto-nacionaliz-histor
                           tt-despes-adic.idi-orig-despes   = 2.

                    ASSIGN tt-despes-adic.val-desp = 0.

                    RUN pi-busca-valor-taxa-siscomex (INPUT decla-import.cod-estab,
                                                      INPUT tt-despes-adic.num-adic,
                                                      OUTPUT tt-despes-adic.val-desp).
                END.
                ELSE DO:
                    IF l-desemb-parc THEN DO:
                        ASSIGN tt-despes-adic.val-desp = tt-despes-adic.val-desp + d-val-despes.
                    END.
                END.
            END.

            RUN openQueryStatic IN h-bocx390 (INPUT "Main":U) NO-ERROR.
            RUN emptyRowObject  IN h-bocx390.
            RUN emptyRowErrors  IN h-bocx390.

            FOR EACH tt-despes-adic:

               EMPTY TEMP-TABLE tt-despes-adic-aux.

               CREATE tt-despes-adic-aux.
               BUFFER-COPY tt-despes-adic TO tt-despes-adic-aux.

               RUN goToKey IN h-bocx390(INPUT tt-despes-adic-aux.num-di-ems,
                                        INPUT tt-despes-adic-aux.num-adic,
                                        INPUT tt-despes-adic-aux.cdn-despes,
                                        INPUT tt-despes-adic-aux.cdn-emit-despes,
                                        INPUT tt-despes-adic-aux.cdd-siscomex-dts).

               IF RETURN-VALUE = "NOK":U THEN DO:

                    RUN setRecord       IN h-bocx390 (INPUT TABLE tt-despes-adic-aux).
                    RUN createRecord    IN h-bocx390.
                    RUN getRowErrors    IN h-bocx390(OUTPUT TABLE RowErrors).
                END.
                ELSE DO:

                    RUN setRecord       IN h-bocx390 (INPUT TABLE tt-despes-adic-aux).
                    RUN updateRecord    IN h-bocx390.
                END.
            END.
            /* seta a variavel l-automatico para yes, para passar pela validaá∆o do siscomex */
            RUN pi-seta-l-automatico IN h-bocx390(INPUT NO).
        END.

        /* totaliza as despesas do parametro (taxa siscomex) para a DI */
        RUN pi-totaliza-taxa-siscomex (INPUT i-num-di-ems,
                                       INPUT p-cdd-siscomex-dts).
    END.
    /*---------[ Fim - Calculo da taxa Siscomex ]--------------------------------------------*/

    RELEASE decla-import.
    RELEASE decla-import-adic.
    RELEASE decla-import-ord.
    RELEASE decla-import-adic-itens.
    RELEASE despes-decla-import.
    RELEASE despes-adic.
    RELEASE decla-import-cotac.

    IF VALID-HANDLE(h-bocx402) THEN
        DELETE PROCEDURE h-bocx402.
    ASSIGN h-bocx402 = ?.
    IF VALID-HANDLE(h-bocx403) THEN
        DELETE PROCEDURE h-bocx403.
    ASSIGN h-bocx403 = ?.
    IF VALID-HANDLE(h-bocx393) THEN
        DELETE PROCEDURE h-bocx393.
    ASSIGN h-bocx393 = ?.
    IF VALID-HANDLE(h-bocx390) THEN
        DELETE PROCEDURE h-bocx390.
    ASSIGN h-bocx390 = ?.
    IF VALID-HANDLE(h-bocx404) THEN
        DELETE PROCEDURE h-bocx404.
    ASSIGN h-bocx404 = ?.
    IF VALID-HANDLE(h-bocx407) THEN
        DELETE PROCEDURE h-bocx407.
    ASSIGN h-bocx407 = ?.
    IF VALID-HANDLE(h-bocx00506) THEN
        DELETE PROCEDURE h-bocx00506.
    ASSIGN h-bocx00506 = ?.
    IF VALID-HANDLE(h-bocx00512) THEN
        DELETE PROCEDURE h-bocx00512.
    ASSIGN h-bocx00512 = ?.
    IF VALID-HANDLE(h-bocx00488) THEN
        DELETE PROCEDURE h-bocx00488.
    ASSIGN h-bocx00488 = ?.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraUltimaSeqDi DBOProgram
PROCEDURE geraUltimaSeqDi :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pUltimaSeq AS INTEGER NO-UNDO.

    FIND LAST bf{&TABLENAME}
        WHERE bf{&TABLENAME}.num-seq-retif < 99 NO-LOCK NO-ERROR.

    IF AVAIL bf{&TABLENAME} THEN
        ASSIGN pUltimaSeq = bf{&TABLENAME}.num-di-ems + 1.
    ELSE
        ASSIGN pUltimaSeq = 1.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAdicoes DBOProgram
PROCEDURE getAdicoes :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR tt-decla-import-adic.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-decla-import-adic-itens.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-decla-import-adic-trib.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-decla-imp-adic-it-trib.

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
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-conhecto-house":U THEN ASSIGN pFieldValue = RowObject.cod-conhecto-house.
        WHEN "cod-conhecto-master":U THEN ASSIGN pFieldValue = RowObject.cod-conhecto-master.
        WHEN "cod-di-siscomex":U THEN ASSIGN pFieldValue = RowObject.cod-di-siscomex.
        WHEN "cod-estab":U THEN ASSIGN pFieldValue = RowObject.cod-estab.
        WHEN "cod-identif":U THEN ASSIGN pFieldValue = RowObject.cod-identif.
        WHEN "cod-inf-compltar":U THEN ASSIGN pFieldValue = RowObject.cod-inf-compltar.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-natur-operac":U THEN ASSIGN pFieldValue = RowObject.cod-natur-operac.
        WHEN "des-checksum":U THEN ASSIGN pFieldValue = RowObject.des-checksum.
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE      NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dat-di":U THEN ASSIGN pFieldValue = RowObject.dat-di.
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-retif":U THEN ASSIGN pFieldValue = RowObject.dat-retif.
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL   NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "val-acresc":U THEN ASSIGN pFieldValue = RowObject.val-acresc.
        WHEN "val-acresc-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-acresc-me[1].
        WHEN "val-acresc-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-acresc-me[2].
        WHEN "val-base-cofins":U THEN ASSIGN pFieldValue = RowObject.val-base-cofins.
        WHEN "val-base-icms":U THEN ASSIGN pFieldValue = RowObject.val-base-icms.
        WHEN "val-base-ii":U THEN ASSIGN pFieldValue = RowObject.val-base-ii.
        WHEN "val-base-ipi":U THEN ASSIGN pFieldValue = RowObject.val-base-ipi.
        WHEN "val-base-pis":U THEN ASSIGN pFieldValue = RowObject.val-base-pis.
        WHEN "val-cofins-db-cr":U THEN ASSIGN pFieldValue = RowObject.val-cofins-db-cr.
        WHEN "val-cofins-nao-tributad":U THEN ASSIGN pFieldValue = RowObject.val-cofins-nao-tributad.
        WHEN "val-cofins-outras":U THEN ASSIGN pFieldValue = RowObject.val-cofins-outras.
        WHEN "val-despes-compltar":U THEN ASSIGN pFieldValue = RowObject.val-despes-compltar.
        WHEN "val-despes-compltar-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-despes-compltar-me[1].
        WHEN "val-despes-compltar-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-despes-compltar-me[2].
        WHEN "val-despes-di":U THEN ASSIGN pFieldValue = RowObject.val-despes-di.
        WHEN "val-despes-di-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-despes-di-me[1].
        WHEN "val-despes-di-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-despes-di-me[2].
        WHEN "val-despes-nac":U THEN ASSIGN pFieldValue = RowObject.val-despes-nac.
        WHEN "val-despes-nac-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-despes-nac-me[1].
        WHEN "val-despes-nac-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-despes-nac-me[2].
        WHEN "val-frete":U THEN ASSIGN pFieldValue = RowObject.val-frete.
        WHEN "val-frete-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-frete-me[1].
        WHEN "val-frete-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-frete-me[2].
        WHEN "val-icms-db-cr":U THEN ASSIGN pFieldValue = RowObject.val-icms-db-cr.
        WHEN "val-icms-nao-tributad":U THEN ASSIGN pFieldValue = RowObject.val-icms-nao-tributad.
        WHEN "val-icms-outras":U THEN ASSIGN pFieldValue = RowObject.val-icms-outras.
        WHEN "val-ii-db-cr":U THEN ASSIGN pFieldValue = RowObject.val-ii-db-cr.
        WHEN "val-ii-nao-tribut":U THEN ASSIGN pFieldValue = RowObject.val-ii-nao-tribut.
        WHEN "val-ii-outras":U THEN ASSIGN pFieldValue = RowObject.val-ii-outras.
        WHEN "val-ipi-db-cr":U THEN ASSIGN pFieldValue = RowObject.val-ipi-db-cr.
        WHEN "val-ipi-nao-tributad":U THEN ASSIGN pFieldValue = RowObject.val-ipi-nao-tributad.
        WHEN "val-ipi-outras":U THEN ASSIGN pFieldValue = RowObject.val-ipi-outras.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-peso-brut-merc":U THEN ASSIGN pFieldValue = RowObject.val-peso-brut-merc.
        WHEN "val-peso-brut-tot-di":U THEN ASSIGN pFieldValue = RowObject.val-peso-brut-tot-di.
        WHEN "val-peso-embal-di":U THEN ASSIGN pFieldValue = RowObject.val-peso-embal-di.
        WHEN "val-peso-liq-di":U THEN ASSIGN pFieldValue = RowObject.val-peso-liq-di.
        WHEN "val-pis-db-cr":U THEN ASSIGN pFieldValue = RowObject.val-pis-db-cr.
        WHEN "val-pis-nao-tributad":U THEN ASSIGN pFieldValue = RowObject.val-pis-nao-tributad.
        WHEN "val-pis-outras":U THEN ASSIGN pFieldValue = RowObject.val-pis-outras.
        WHEN "val-seguro":U THEN ASSIGN pFieldValue = RowObject.val-seguro.
        WHEN "val-seguro-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-seguro-me[1].
        WHEN "val-seguro-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-seguro-me[2].
        WHEN "val-vmcv":U THEN ASSIGN pFieldValue = RowObject.val-vmcv.
        WHEN "val-vmcv-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-vmcv-me[1].
        WHEN "val-vmcv-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-vmcv-me[2].
        WHEN "val-vmld":U THEN ASSIGN pFieldValue = RowObject.val-vmld.
        WHEN "val-vmld-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-vmld-me[1].
        WHEN "val-vmld-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-vmld-me[2].
        WHEN "val-vmle":U THEN ASSIGN pFieldValue = RowObject.val-vmle.
        WHEN "val-vmle-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-vmle-me[1].
        WHEN "val-vmle-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-vmle-me[2].
        WHEN "cdd-siscomex-dts":U THEN ASSIGN pFieldValue = RowObject.cdd-siscomex-dts.
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER   NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cdn-agent-carg-import":U THEN ASSIGN pFieldValue = RowObject.cdn-agent-carg-import.
        WHEN "cdn-consign":U THEN ASSIGN pFieldValue = RowObject.cdn-consign.
        WHEN "cdn-itiner":U THEN ASSIGN pFieldValue = RowObject.cdn-itiner.
        WHEN "cdn-msg-di":U THEN ASSIGN pFieldValue = RowObject.cdn-msg-di.
        WHEN "cdn-pais-proceden":U THEN ASSIGN pFieldValue = RowObject.cdn-pais-proceden.
        WHEN "cdn-recinto-alfand":U THEN ASSIGN pFieldValue = RowObject.cdn-recinto-alfand.
        WHEN "cdn-setor-armaz":U THEN ASSIGN pFieldValue = RowObject.cdn-setor-armaz.
        WHEN "cdn-transpdor":U THEN ASSIGN pFieldValue = RowObject.cdn-transpdor.
        WHEN "cdn-urf-despch":U THEN ASSIGN pFieldValue = RowObject.cdn-urf-despch.
        WHEN "cdn-urf-entr":U THEN ASSIGN pFieldValue = RowObject.cdn-urf-entr.
        WHEN "cdn-via-transp-di":U THEN ASSIGN pFieldValue = RowObject.cdn-via-transp-di.
        WHEN "idi-caract-operac":U THEN ASSIGN pFieldValue = RowObject.idi-caract-operac.
        WHEN "idi-docto-carg":U THEN ASSIGN pFieldValue = RowObject.idi-docto-carg.
        WHEN "idi-ind-utiliz":U THEN ASSIGN pFieldValue = RowObject.idi-ind-utiliz.
        WHEN "idi-modalid-despch":U THEN ASSIGN pFieldValue = RowObject.idi-modalid-despch.
        WHEN "idi-motiv-retif":U THEN ASSIGN pFieldValue = RowObject.idi-motiv-retif.
        WHEN "idi-tip-conhecto":U THEN ASSIGN pFieldValue = RowObject.idi-tip-conhecto.
        WHEN "idi-tip-decla-import":U THEN ASSIGN pFieldValue = RowObject.idi-tip-decla-import.
        WHEN "idi-via-transp-di":U THEN ASSIGN pFieldValue = RowObject.idi-via-transp-di.
        WHEN "num-adicoes":U THEN ASSIGN pFieldValue = RowObject.num-adicoes.
        WHEN "num-di-ems":U THEN ASSIGN pFieldValue = RowObject.num-di-ems.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-seq-retif":U THEN ASSIGN pFieldValue = RowObject.num-seq-retif.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice dclmprt-id
  Parameters:
               retorna valor do campo num-di-ems
               retorna valor do campo num-seq-retif
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnum-di-ems    LIKE decla-import.num-di-ems    NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq-retif LIKE decla-import.num-seq-retif NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnum-di-ems = RowObject.num-di-ems
           pnum-seq-retif = RowObject.num-seq-retif
           pcdd-siscomex-dts = RowObject.cdd-siscomex-dts.

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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL   NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-ativo":U THEN ASSIGN pFieldValue = RowObject.log-ativo.
        WHEN "log-fundap":U THEN ASSIGN pFieldValue = RowObject.log-fundap.
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        WHEN "log-multimod":U THEN ASSIGN pFieldValue = RowObject.log-multimod.
        WHEN "log-pend-rat":U THEN ASSIGN pFieldValue = RowObject.log-pend-rat.
                when "log-pend-despes-compltar":U then
                &if "{&bf_mat_versao_ems}" < "2.09" &then
                        assign pFieldValue = substring(RowObject.cod-livre-1,1,1) = "S":U
                &else
                    assign pFieldValue = RowObject.log-pend-despes-compltar
                &ENDIF .
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNaturOper DBOProgram
PROCEDURE getNaturOper :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pNatOper LIKE decla-import.cod-natur-oper NO-UNDO.

    ASSIGN pNatOper = c-cod-natur-oper-old.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNewSeqRetif DBOProgram
PROCEDURE getNewSeqRetif :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pNumDiEms  LIKE {&TABLENAME}.num-di-ems NO-UNDO.
    DEFINE INPUT  PARAMETER pCddSiscomexDts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.
    DEFINE OUTPUT PARAMETER pUltimaSeq AS INTEGER                   NO-UNDO.

    FIND LAST decla-import NO-LOCK
        WHERE decla-import.num-di-ems = pNumDiEms
          AND decla-import.cdd-siscomex-dts = pCddSiscomexDts NO-ERROR.

    IF AVAIL decla-import THEN
        ASSIGN pUltimaSeq = decla-import.num-seq-retif + 1.
    ELSE
        ASSIGN pUltimaSeq = 1.

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
    DEFINE INPUT PARAMETER pFieldName   AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW          NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†retornada flag "NOK":U ---*/
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
  Purpose:     Reposiciona registro com base no °ndice dclmprt-id
  Parameters:
               recebe valor do campo num-di-ems
               recebe valor do campo num-seq-retif
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-di-ems       LIKE decla-import.num-di-ems      NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-retif    LIKE decla-import.num-seq-retif   NO-UNDO.
    DEFINE INPUT PARAMETER pcdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts NO-UNDO.

    FIND FIRST bfdecla-import
         WHERE bfdecla-import.num-di-ems       = pnum-di-ems
           AND bfdecla-import.num-seq-retif    = pnum-seq-retif
           AND bfdecla-import.cdd-siscomex-dts = pcdd-siscomex-dts NO-LOCK NO-ERROR.

/*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdecla-import THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdecla-import)).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyByDiSiscomex DBOProgram
PROCEDURE goToKeyByDiSiscomex :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-di-siscomex LIKE decla-import.cod-di-siscomex NO-UNDO.

    FIND FIRST bfdecla-import
         WHERE bfdecla-import.cod-di-siscomex = pcod-di-siscomex
           AND bfdecla-import.log-ativo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdecla-import THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdecla-import)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyCustom DBOProgram
PROCEDURE goToKeyCustom :
/*------------------------------------------------------------------------------
  Purpose:     Foi necess†rio alteraro goToKey pois na tela de DECLARAÄ«O DE DI,
               o bot∆o v† para deve trazer a ultima retificaá∆o da DI e o usu†rio
               n∆o deve informar. Deve ser buscado pelo sistema.
  Parameters:
               recebe valor do campo num-di-ems
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-di-ems LIKE decla-import.num-di-ems NO-UNDO.
    DEFINE INPUT PARAMETER pde-cdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts NO-UNDO.

    FIND FIRST bfdecla-import
         WHERE bfdecla-import.num-di-ems = pnum-di-ems
           AND bfdecla-import.cdd-siscomex-dts = pde-cdd-siscomex-dts
           AND bfdecla-import.log-ativo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdecla-import THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdecla-import)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyByDiDuimp DBOProgram
PROCEDURE goToKeyByDiDuimp :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-di-siscomex LIKE decla-import.cod-di-siscomex NO-UNDO.

    IF  i-tp-nacionaliz = 3 /* DUIMP */ THEN
        FIND FIRST bfdecla-import
             WHERE bfdecla-import.cod-di-siscomex  = pcod-di-siscomex
               AND bfdecla-import.num-seq-retif    = 99
               AND bfdecla-import.log-ativo NO-LOCK NO-ERROR.
    ELSE /* DI */
        FIND FIRST bfdecla-import
             WHERE bfdecla-import.cod-di-siscomex  = pcod-di-siscomex
               AND bfdecla-import.num-seq-retif    <> 99
               AND bfdecla-import.log-ativo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdecla-import THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdecla-import)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE log-imposto-alterado DBOProgram
PROCEDURE log-imposto-alterado :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-num-di-ems       LIKE decla-import.num-di-ems         NO-UNDO.
    DEFINE INPUT  PARAMETER p-cdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts   NO-UNDO.
    DEFINE OUTPUT PARAMETER log-imp-alterado   AS   LOGICAL                         NO-UNDO.

    IF CAN-FIND(FIRST decla-import-adic
                    WHERE decla-import-adic.num-di-ems = p-num-di-ems
                      AND decla-import-adic.cdd-siscomex-dts = p-cdd-siscomex-dts
                    AND (
                    &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
                           decla-import.log-ava-base-ii      OR
                           decla-import.log-ava-base-ipi         OR
                           decla-import.log-ava-base-pis         OR
                           decla-import.log-ava-base-cofins      OR
                           decla-import.log-ava-base-icms    OR
                           decla-import.log-ava-impto-ii         OR
                           decla-import.log-ava-impto-ipi        OR
                           decla-import.log-ava-impto-pis        OR
                           decla-import.log-ava-impto-cofins OR
                           decla-import.log-ava-impto-icms
                    &ELSE
                           SUBSTRING(decla-import-adic.cod-livre-1,4,1)  = "S":U OR
                           SUBSTRING(decla-import-adic.cod-livre-1,5,1)  = "S":U OR
                           SUBSTRING(decla-import-adic.cod-livre-1,6,1)  = "S":U OR
                           SUBSTRING(decla-import-adic.cod-livre-1,7,1)  = "S":U OR
                           SUBSTRING(decla-import-adic.cod-livre-1,8,1)  = "S":U OR
                           SUBSTRING(decla-import-adic.cod-livre-1,9,1)  = "S":U OR
                           SUBSTRING(decla-import-adic.cod-livre-1,10,1) = "S":U OR
                           SUBSTRING(decla-import-adic.cod-livre-1,11,1) = "S":U OR
                           SUBSTRING(decla-import-adic.cod-livre-1,12,1) = "S":U OR
                           SUBSTRING(decla-import-adic.cod-livre-1,13,1) = "S":U
                    &ENDIF
                )) THEN
                    ASSIGN log-imp-alterado = YES.
                ELSE
                    ASSIGN log-imp-alterado = NO.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDiBreakBySeqRet DBOProgram
PROCEDURE openQueryByDiBreakBySeqRet : //Usa apenas na DI
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH  {&TABLENAME}
                                WHERE {&TABLENAME}.cod-estab       >= c-cod-estab-ini
                                AND   {&TABLENAME}.cod-estab       <= c-cod-estab-fim
                                AND   {&TABLENAME}.num-di-ems      >= d-num-di-ems-ini
                                AND   {&TABLENAME}.num-di-ems      <= d-num-di-ems-fim
                                AND   {&TABLENAME}.cod-di-siscomex >= c-cod-di-siscomex-ini
                                AND   {&TABLENAME}.cod-di-siscomex <= c-cod-di-siscomex-fim
                                AND   {&TABLENAME}.cdd-siscomex-dts >= d-cdd-siscomex-dts-ini
                                AND   {&TABLENAME}.cdd-siscomex-dts <= d-cdd-siscomex-dts-fim
                                AND (
                                      ({&TABLENAME}.dat-di               >= d-dat-di-ini
                                      AND   {&TABLENAME}.dat-di          <= d-dat-di-fim
                                      AND   {&TABLENAME}.dat-di          <> ?)
                                    OR {&TABLENAME}.dat-di = ? )
                                AND   {&TABLENAME}.log-ativo
                                AND   {&TABLENAME}.num-seq-retif = (IF i-tp-nacionaliz = 3 THEN 99
                                                                    ELSE {&TABLENAME}.num-seq-retif)
                        NO-LOCK INDEXED-REPOSITION.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDiEMS DBOProgram
PROCEDURE openQueryByDiEMS :
/*------------------------------------------------------------------------------
  Purpose:     Abre a Query de acordo com a faixa de DI
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH  {&TABLENAME}
                                WHERE {&TABLENAME}.num-di-ems      >= d-num-di-ems-ini
                                AND   {&TABLENAME}.num-di-ems      <= d-num-di-ems-fim
                        NO-LOCK INDEXED-REPOSITION.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDiEMSSeq DBOProgram
PROCEDURE openQueryByDiEMSSeq :
/*------------------------------------------------------------------------------
  Purpose:     Abre a Query de acordo com a faixa de DI e Seq Retif
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH  {&TABLENAME}
                                WHERE {&TABLENAME}.num-di-ems       = d-num-di-ems
                                AND   {&TABLENAME}.num-seq-retif    = i-num-seq-retif
                                AND   {&TABLENAME}.cdd-siscomex-dts = de-cdd-siscomex-dts
                        NO-LOCK INDEXED-REPOSITION.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDIOnlySiscomex DBOProgram
PROCEDURE openQueryByDIOnlySiscomex :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    IF i-tp-nacionaliz = 3 THEN /* DUIMP */
        OPEN QUERY {&QUERYNAME} FOR EACH  {&TABLENAME}
                                    WHERE {&TABLENAME}.cod-estab        >= c-cod-estab-ini
                                    AND   {&TABLENAME}.cod-estab        <= c-cod-estab-fim
                                    AND   {&TABLENAME}.num-di-ems       >= d-num-di-ems-ini
                                    AND   {&TABLENAME}.num-di-ems       <= d-num-di-ems-fim
                                    AND   {&TABLENAME}.cod-di-siscomex  >= c-cod-di-siscomex-ini
                                    AND   {&TABLENAME}.cod-di-siscomex  <= c-cod-di-siscomex-fim
                                    AND   {&TABLENAME}.cdd-siscomex-dts >= d-cdd-siscomex-dts-ini
                                    AND   {&TABLENAME}.cdd-siscomex-dts <= d-cdd-siscomex-dts-fim
                                    AND(
                                          ({&TABLENAME}.dat-di               >= d-dat-di-ini
                                          AND   {&TABLENAME}.dat-di          <= d-dat-di-fim
                                          AND   {&TABLENAME}.dat-di          <> ?)
                                        OR {&TABLENAME}.dat-di = ? )
                                    AND   {&TABLENAME}.log-ativo
                                    AND   {&TABLENAME}.cod-di-siscomex <> ""
                                    AND   {&TABLENAME}.num-seq-retif = 99
                            NO-LOCK INDEXED-REPOSITION.
    ELSE /* DI */
        OPEN QUERY {&QUERYNAME} FOR EACH  {&TABLENAME}
                                    WHERE {&TABLENAME}.cod-estab        >= c-cod-estab-ini
                                    AND   {&TABLENAME}.cod-estab        <= c-cod-estab-fim
                                    AND   {&TABLENAME}.num-di-ems       >= d-num-di-ems-ini
                                    AND   {&TABLENAME}.num-di-ems       <= d-num-di-ems-fim
                                    AND   {&TABLENAME}.cod-di-siscomex  >= c-cod-di-siscomex-ini
                                    AND   {&TABLENAME}.cod-di-siscomex  <= c-cod-di-siscomex-fim
                                    AND   {&TABLENAME}.cdd-siscomex-dts >= d-cdd-siscomex-dts-ini
                                    AND   {&TABLENAME}.cdd-siscomex-dts <= d-cdd-siscomex-dts-fim
                                    AND(
                                          ({&TABLENAME}.dat-di               >= d-dat-di-ini
                                          AND   {&TABLENAME}.dat-di          <= d-dat-di-fim
                                          AND   {&TABLENAME}.dat-di          <> ?)
                                        OR {&TABLENAME}.dat-di = ? )
                                    AND   {&TABLENAME}.log-ativo
                                    AND   {&TABLENAME}.cod-di-siscomex <> ""
                                    AND   {&TABLENAME}.num-seq-retif   <> 99
                            NO-LOCK INDEXED-REPOSITION.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByLogAtivo DBOProgram
PROCEDURE openQueryByLogAtivo :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME}
                                WHERE {&TABLENAME}.log-ativo = l-log-ativo
                                  AND {&TABLENAME}.cdd-siscomex-dts = 0 //relacionamento com DUIMP
                                  AND {&TABLENAME}.num-seq-retif < 99 NO-LOCK INDEXED-REPOSITION.

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
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-di-embarque DBOProgram
PROCEDURE pi-busca-di-embarque :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se embarque est† relacionado a DI, se estiver retorna o n£mero da DI
  Parameters:
               recebe embarque
               retorna n£mero DI EMS
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-embarque   LIKE decla-import-embarq.cod-embarq NO-UNDO.
    DEFINE INPUT  PARAMETER pc-cod-estab  LIKE decla-import-embarq.cod-estab  NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-num-di-ems LIKE decla-import-embarq.num-di-ems NO-UNDO.

    FIND FIRST decla-import-embarq
         WHERE decla-import-embarq.cod-embarq       = pc-embarque
           AND decla-import-embarq.cod-estab        = pc-cod-estab
           AND decla-import-embarq.cdd-siscomex-dts = 0 NO-LOCK NO-ERROR. /* tijucas - chamado TSVQD4 */

    IF AVAIL decla-import-embarq THEN
        ASSIGN pi-num-di-ems = decla-import-embarq.num-di-ems.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-duimp-embarque DBOProgram
PROCEDURE pi-busca-duimp-embarque :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se embarque est† relacionado a DUIMP, se estiver retorna o n£mero da DUIMP
  Parameters:
               recebe embarque
               retorna n£mero DUIMP EMS
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-embarque   LIKE decla-import-embarq.cod-embarq NO-UNDO.
    DEFINE INPUT  PARAMETER pc-cod-estab  LIKE decla-import-embarq.cod-estab  NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-num-di-ems LIKE decla-import-embarq.num-di-ems NO-UNDO.

    FIND FIRST decla-import-embarq
         WHERE decla-import-embarq.cod-embarq        = pc-embarque
           AND decla-import-embarq.cod-estab         = pc-cod-estab
           AND decla-import-embarq.cdd-siscomex-dts <> 0 NO-LOCK NO-ERROR.

    IF AVAIL decla-import-embarq THEN
        ASSIGN pi-num-di-ems = decla-import-embarq.num-di-ems.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-doc-relacs DBOProgram
PROCEDURE pi-busca-doc-relacs :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pr-decla-import AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-docum-est.

    EMPTY TEMP-TABLE tt-docum-est.

    FOR FIRST decla-import NO-LOCK
        WHERE ROWID(decla-import) = pr-decla-import : END.

    IF NOT AVAIL decla-import OR decla-import.cod-di-siscomex = "" THEN
        RETURN "NOK":U.

    FOR EACH docum-est NO-LOCK
        WHERE docum-est.declaracao-import = decla-import.cod-di-siscomex:
        CREATE tt-docum-est.
        BUFFER-COPY docum-est TO tt-docum-est.
        ASSIGN tt-docum-est.observacao = "".

        IF  l-nt2024002 THEN DO:
            RUN cria-nf-pagto-antecip (INPUT docum-est.serie-docto,
                                       INPUT docum-est.nro-docto,
                                       INPUT docum-est.cod-emitente,
                                       INPUT docum-est.nat-operacao,
                                       INPUT docum-est.cod-estabel).
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cria-nf-pagto-antecip DBOProgram
PROCEDURE cria-nf-pagto-antecip:
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    define input parameter p-serie         like docum-est.serie-docto    no-undo.
    define input parameter p-nro-docto     like docum-est.nro-docto      no-undo.
    define input parameter p-cod-emitente  like docum-est.cod-emitente   no-undo.
    define input parameter p-nat-operacao  like docum-est.nat-operacao   no-undo.
    define input parameter p-cod-estabel   like docum-est.cod-estabel    no-undo.

    FOR EACH nota-fisc-adc NO-LOCK
        WHERE nota-fisc-adc.cod-estab        = p-cod-estabel
        AND   nota-fisc-adc.cod-serie        = p-serie
        AND   nota-fisc-adc.cod-nota-fisc    = p-nro-docto
        AND   nota-fisc-adc.cdn-emitente     = p-cod-emitente
        AND   nota-fisc-adc.cod-natur-operac = p-nat-operacao
        AND   nota-fisc-adc.idi-tip-dado     = 3: /* Docto Fiscal Referenciado */

        FOR FIRST b-docum-est NO-LOCK
            WHERE  b-docum-est.cod-estabel  = nota-fisc-adc.cod-estab
            AND    b-docum-est.serie-docto  = nota-fisc-adc.cod-ser-docto-referado
            AND    b-docum-est.nro-docto    = nota-fisc-adc.cod-docto-referado
            AND    b-docum-est.cod-emitente = nota-fisc-adc.cdn-emit-docto-referado
            AND    b-docum-est.dt-emissao   = nota-fisc-adc.dat-docto-referado:
        END.

        IF  AVAIL b-docum-est
        AND b-docum-est.cod-tipo-nf-cred-deb = "6" /* Nota de DÇbito */
        AND b-docum-est.cod-finalidade = "6" /* Pagamento Antecipado */ THEN DO:

            FIND FIRST emitente NO-LOCK
                WHERE emitente.cod-emitente = p-cod-emitente NO-ERROR.

            CREATE tt-docum-est.
            BUFFER-COPY b-docum-est TO tt-docum-est.
            ASSIGN tt-docum-est.observacao  = "Referente NF "
                                            + TRIM(p-cod-estabel) + "/"
                                            + TRIM(p-serie) + "/"
                                            + TRIM(p-nat-operacao) + "/"
                                            + TRIM(p-nro-docto) + "/"
                                            + (IF AVAIL emitente THEN TRIM(emitente.nome-abrev) ELSE "").
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-impostos DBOProgram
PROCEDURE pi-busca-impostos :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-num-di-ems             LIKE decla-import.num-di-ems            NO-UNDO.
    DEFINE INPUT  PARAMETER p-cdd-siscomex-dts       LIKE decla-import.cdd-siscomex-dts      NO-UNDO.
    DEFINE OUTPUT PARAMETER p-val-base-ii            LIKE decla-import.val-base-ii           NO-UNDO.
    DEFINE OUTPUT PARAMETER p-val-susp-ii            LIKE decla-import.val-ii-nao-tribut     NO-UNDO.
    DEFINE OUTPUT PARAMETER p-val-recolhe-ii         LIKE decla-import.val-ii-db-cr          NO-UNDO.
    DEFINE OUTPUT PARAMETER p-val-outros-ii          LIKE decla-import.val-ii-outras         NO-UNDO.

    DEFINE OUTPUT PARAMETER p-val-base-ipi           LIKE decla-import.val-base-ipi          NO-UNDO.
    DEFINE OUTPUT PARAMETER p-val-susp-ipi           LIKE decla-import.val-ipi-nao-tribut    NO-UNDO.
    DEFINE OUTPUT PARAMETER p-val-recolhe-ipi        LIKE decla-import.val-ipi-db-cr         NO-UNDO.
    DEFINE OUTPUT PARAMETER p-val-outros-ipi         LIKE decla-import.val-ipi-outras        NO-UNDO.

    DEFINE OUTPUT PARAMETER p-val-base-pis           LIKE decla-import.val-base-pis          NO-UNDO.
    DEFINE OUTPUT PARAMETER p-val-susp-pis           LIKE decla-import.val-pis-nao-tribut    NO-UNDO.
    DEFINE OUTPUT PARAMETER p-val-recolhe-pis        LIKE decla-import.val-pis-db-cr         NO-UNDO.
    DEFINE OUTPUT PARAMETER p-val-outros-pis         LIKE decla-import.val-pis-outras        NO-UNDO.

    DEFINE OUTPUT PARAMETER p-val-base-cofins        LIKE decla-import.val-base-cofins       NO-UNDO.
    DEFINE OUTPUT PARAMETER p-val-susp-cofins        LIKE decla-import.val-cofins-nao-tribut NO-UNDO.
    DEFINE OUTPUT PARAMETER p-val-recolhe-cofins     LIKE decla-import.val-cofins-db-cr      NO-UNDO.
    DEFINE OUTPUT PARAMETER p-val-outros-cofins      LIKE decla-import.val-cofins-outras     NO-UNDO.

    DEFINE OUTPUT PARAMETER p-val-base-icms          LIKE decla-import.val-base-icms         NO-UNDO.
    DEFINE OUTPUT PARAMETER p-val-susp-icms          LIKE decla-import.val-icms-nao-tribut   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-val-recolhe-icms       LIKE decla-import.val-icms-db-cr        NO-UNDO.
    DEFINE OUTPUT PARAMETER p-val-outros-icms        LIKE decla-import.val-icms-outras       NO-UNDO.

    DEFINE OUTPUT PARAMETER p-v-base-fcp             LIKE decla-import.val-base-icms         NO-UNDO.
    DEFINE OUTPUT PARAMETER p-v-susp-fcp             LIKE decla-import.val-icms-nao-tribut   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-v-recolhe-fcp          LIKE decla-import.val-icms-db-cr        NO-UNDO.
    DEFINE OUTPUT PARAMETER p-v-outros-fcp           LIKE decla-import.val-icms-outras       NO-UNDO.

    DEFINE OUTPUT PARAMETER p-v-base-fcp-st          LIKE decla-import.val-base-icms         NO-UNDO.
    DEFINE OUTPUT PARAMETER p-v-susp-fcp-st          LIKE decla-import.val-icms-nao-tribut   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-v-recolhe-fcp-st       LIKE decla-import.val-icms-db-cr        NO-UNDO.
    DEFINE OUTPUT PARAMETER p-v-outros-fcp-st        LIKE decla-import.val-icms-outras       NO-UNDO.

    DEFINE OUTPUT PARAMETER p-v-base-icms-st         LIKE decla-import.val-base-icms         NO-UNDO.
    DEFINE OUTPUT PARAMETER p-v-susp-icms-st         LIKE decla-import.val-icms-nao-tribut   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-v-recolhe-icms-st      LIKE decla-import.val-icms-db-cr        NO-UNDO.
    DEFINE OUTPUT PARAMETER p-v-outros-icms-st       LIKE decla-import.val-icms-outras       NO-UNDO.

    DEFINE OUTPUT PARAMETER p-v-base-icms-compl      LIKE decla-import.val-base-icms         NO-UNDO.
    DEFINE OUTPUT PARAMETER p-v-susp-icms-compl      LIKE decla-import.val-icms-nao-tribut   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-v-recolhe-icms-compl   LIKE decla-import.val-icms-db-cr        NO-UNDO.
    DEFINE OUTPUT PARAMETER p-v-outros-icms-compl    LIKE decla-import.val-icms-outras       NO-UNDO.

    FOR FIRST bf{&TABLENAME} NO-LOCK
        WHERE bf{&TABLENAME}.num-di-ems = p-num-di-ems
          AND bf{&TABLENAME}.cdd-siscomex-dts = p-cdd-siscomex-dts:

        ASSIGN p-val-base-ii    = bf{&TABLENAME}.val-base-ii
               p-val-susp-ii    = bf{&TABLENAME}.val-ii-nao-tribut
               p-val-recolhe-ii = bf{&TABLENAME}.val-ii-db-cr
               p-val-outros-ii  = bf{&TABLENAME}.val-ii-outras

               p-val-base-ipi    = bf{&TABLENAME}.val-base-ipi
               p-val-susp-ipi    = bf{&TABLENAME}.val-ipi-nao-tribut
               p-val-recolhe-ipi = bf{&TABLENAME}.val-ipi-db-cr
               p-val-outros-ipi  = bf{&TABLENAME}.val-ipi-outras

               p-val-base-pis    = bf{&TABLENAME}.val-base-pis
               p-val-susp-pis    = bf{&TABLENAME}.val-pis-nao-tribut
               p-val-recolhe-pis = bf{&TABLENAME}.val-pis-db-cr
               p-val-outros-pis  = bf{&TABLENAME}.val-pis-outras

               p-val-base-cofins    = bf{&TABLENAME}.val-base-cofins
               p-val-susp-cofins    = bf{&TABLENAME}.val-cofins-nao-tribut
               p-val-recolhe-cofins = bf{&TABLENAME}.val-cofins-db-cr
               p-val-outros-cofins  = bf{&TABLENAME}.val-cofins-outras

               p-val-base-icms    = bf{&TABLENAME}.val-base-icms
               p-val-susp-icms    = bf{&TABLENAME}.val-icms-nao-tribut
               p-val-recolhe-icms = bf{&TABLENAME}.val-icms-db-cr
               p-val-outros-icms  = bf{&TABLENAME}.val-icms-outras.

        FOR EACH decla-import-adic-itens NO-LOCK
           WHERE decla-import-adic-itens.num-di-ems = bf{&TABLENAME}.num-di-ems
             AND decla-import-adic-itens.cdd-siscomex-dts = bf{&TABLENAME}.cdd-siscomex-dts:

            ASSIGN p-v-base-fcp           = p-v-base-fcp        + decla-import-adic-itens.val-base-fcp
                   p-v-base-fcp-st        = p-v-base-fcp-st     + decla-import-adic-itens.val-base-fcp-substto
                   p-v-base-icms-st       = p-v-base-icms-st    + decla-import-adic-itens.val-base-icms-substto
                   p-v-base-icms-compl    = p-v-base-icms-compl + decla-import-adic-itens.val-base-icms-compltar.

            /*Os Impostos ICMS ST, ICMS Complementar e taxas FCP e FCP ST, sempre seguem a mesma tributaá∆o do imposto do ICMS*/
            /*Suspenso*/
            IF p-val-susp-icms    <> 0 THEN
               ASSIGN p-v-susp-fcp        = p-v-susp-fcp              + decla-import-adic-itens.val-fcp
                      p-v-susp-fcp-st     = p-v-susp-fcp-st           + decla-import-adic-itens.val-fcp-substto
                      p-v-susp-icms-st    = p-v-susp-icms-st          + decla-import-adic-itens.val-icms-substto
                      p-v-susp-icms-compl = p-v-susp-icms-compl       + decla-import-adic-itens.val-icms-compltar.

            /*A Recolher*/
            IF p-val-recolhe-icms <> 0 THEN
               ASSIGN p-v-recolhe-fcp        = p-v-recolhe-fcp        + decla-import-adic-itens.val-fcp
                      p-v-recolhe-fcp-st     = p-v-recolhe-fcp-st     + decla-import-adic-itens.val-fcp-substto
                      p-v-recolhe-icms-st    = p-v-recolhe-icms-st    + decla-import-adic-itens.val-icms-substto
                      p-v-recolhe-icms-compl = p-v-recolhe-icms-compl + decla-import-adic-itens.val-icms-compltar.

            /*Outros*/
            IF p-val-outros-icms <> 0 THEN
               ASSIGN p-v-outros-fcp        = p-v-outros-fcp          + decla-import-adic-itens.val-fcp
                      p-v-outros-fcp-st     = p-v-outros-fcp-st       + decla-import-adic-itens.val-fcp-substto
                      p-v-outros-icms-st    = p-v-outros-icms-st      + decla-import-adic-itens.val-icms-substto
                      p-v-outros-icms-compl = p-v-outros-icms-compl   + decla-import-adic-itens.val-icms-compltar.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-valor-taxa-siscomex DBOProgram
PROCEDURE pi-busca-valor-taxa-siscomex :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-estab   LIKE decla-import.cod-estab     NO-UNDO.
    DEFINE INPUT  PARAMETER p-num-adic    LIKE decla-import-adic.num-adic NO-UNDO.
    DEFINE OUTPUT PARAMETER p-valor-desp  LIKE despes-adic.val-despes     NO-UNDO.

    ASSIGN p-valor-desp = 0.

    /*Busca dos Valores das Taxas com base na adiá∆o*/
    IF p-num-adic = 1 THEN DO:
        FOR FIRST tab-ocor NO-LOCK
            WHERE tab-ocor.cod-tab    = 612
            AND   tab-ocor.c-campo[1] = p-cod-estab
            AND   tab-ocor.i-campo[1] = 1 :
            ASSIGN p-valor-desp = tab-ocor.de-campo[1].
        END.

        FOR FIRST tab-ocor NO-LOCK
            WHERE tab-ocor.cod-tab    = 612
            AND   tab-ocor.c-campo[1] = p-cod-estab
            AND   tab-ocor.i-campo[1] = 2 :
            ASSIGN p-valor-desp = p-valor-desp + tab-ocor.de-campo[1].
        END.
    END.
    ELSE DO:
        IF p-num-adic = 2 THEN DO:
            FOR FIRST tab-ocor NO-LOCK
                WHERE tab-ocor.cod-tab    = 612
                AND   tab-ocor.c-campo[1] = p-cod-estab
                AND   tab-ocor.i-campo[1] = 2 :
                ASSIGN p-valor-desp = tab-ocor.de-campo[1].
            END.
        END.
        ELSE DO:
            IF p-num-adic >= 3 AND
               p-num-adic <= 5 THEN DO:
                FOR FIRST tab-ocor NO-LOCK
                    WHERE tab-ocor.cod-tab    = 612
                    AND   tab-ocor.c-campo[1] = p-cod-estab
                    AND   tab-ocor.i-campo[1] = 3 :
                    ASSIGN p-valor-desp = tab-ocor.de-campo[1].
                END.
            END.
            ELSE DO:
                IF p-num-adic >= 6 AND
                   p-num-adic <= 10 THEN DO:
                    FOR FIRST tab-ocor NO-LOCK
                        WHERE tab-ocor.cod-tab    = 612
                        AND   tab-ocor.c-campo[1] = p-cod-estab
                        AND   tab-ocor.i-campo[1] = 4 :
                        ASSIGN p-valor-desp = tab-ocor.de-campo[1].
                    END.
                END.
                ELSE DO:
                    IF p-num-adic >= 11 AND
                       p-num-adic <= 20 THEN DO:
                        FOR FIRST tab-ocor NO-LOCK
                            WHERE tab-ocor.cod-tab    = 612
                            AND   tab-ocor.c-campo[1] = p-cod-estab
                            AND   tab-ocor.i-campo[1] = 5 :
                            ASSIGN p-valor-desp = tab-ocor.de-campo[1].
                        END.
                    END.
                    ELSE DO:
                        IF p-num-adic >= 21 AND
                           p-num-adic <= 50 THEN DO:
                            FOR FIRST tab-ocor NO-LOCK
                                WHERE tab-ocor.cod-tab    = 612
                                AND   tab-ocor.c-campo[1] = p-cod-estab
                                AND   tab-ocor.i-campo[1] = 6 :
                                ASSIGN p-valor-desp = tab-ocor.de-campo[1].
                            END.
                        END.
                        ELSE DO:
                            IF p-num-adic >= 51 THEN DO:
                                FOR FIRST tab-ocor NO-LOCK
                                    WHERE tab-ocor.cod-tab    = 612
                                    AND   tab-ocor.c-campo[1] = p-cod-estab
                                    AND   tab-ocor.i-campo[1] = 7 :
                                    ASSIGN p-valor-desp = tab-ocor.de-campo[1].
                                END.
                            END.
                        END.
                    END.
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-valores DBOProgram
PROCEDURE pi-busca-valores :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-num-di-ems             LIKE decla-import.num-di-ems        NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel            LIKE decla-import.cod-estab         NO-UNDO.
    DEFINE INPUT  PARAMETER p-cdd-siscomex-dts       LIKE decla-import.cdd-siscomex-dts  NO-UNDO.
    DEFINE OUTPUT PARAMETER c-moeda-adic             AS CHAR FORMAT "X(30)":U            NO-UNDO.
    DEFINE OUTPUT PARAMETER c-moeda-frete            AS CHAR FORMAT "X(30)":U            NO-UNDO.
    DEFINE OUTPUT PARAMETER c-moeda-seguro           AS CHAR FORMAT "X(30)":U            NO-UNDO.
    DEFINE OUTPUT PARAMETER c-moeda-acres            AS CHAR FORMAT "X(30)":U            NO-UNDO.
    DEFINE OUTPUT PARAMETER d-val-vmcv               LIKE decla-import-adic.val-vmcv     NO-UNDO.
    DEFINE OUTPUT PARAMETER d-val-vmcv-me            LIKE decla-import-adic.val-vmcv     NO-UNDO.
    DEFINE OUTPUT PARAMETER d-val-vmle               LIKE decla-import-adic.val-vmle     NO-UNDO.
    DEFINE OUTPUT PARAMETER d-val-vmle-me            LIKE decla-import-adic.val-vmle     NO-UNDO.
    DEFINE OUTPUT PARAMETER d-val-vmld               LIKE decla-import-adic.val-vmld     NO-UNDO.
    DEFINE OUTPUT PARAMETER d-val-vmld-me            LIKE decla-import-adic.val-vmld     NO-UNDO.
    DEFINE OUTPUT PARAMETER d-val-frete              LIKE decla-import-adic.val-frete    NO-UNDO.
    DEFINE OUTPUT PARAMETER d-val-frete-me           LIKE decla-import-adic.val-frete    NO-UNDO.
    DEFINE OUTPUT PARAMETER d-val-seguro             LIKE decla-import-adic.val-seguro   NO-UNDO.
    DEFINE OUTPUT PARAMETER d-val-seguro-me          LIKE decla-import-adic.val-seguro   NO-UNDO.
    DEFINE OUTPUT PARAMETER d-val-acresc             LIKE decla-import-adic.val-acresc   NO-UNDO.
    DEFINE OUTPUT PARAMETER d-val-acresc-me          LIKE decla-import-adic.val-acresc   NO-UNDO.
    DEFINE OUTPUT PARAMETER d-tot-val-desp-nacion-me LIKE despes-decla-import.val-despes NO-UNDO.
    DEFINE OUTPUT PARAMETER d-tot-val-desp-nacion    LIKE despes-decla-import.val-despes NO-UNDO.
    DEFINE OUTPUT PARAMETER d-tot-val-desp-compl-me  LIKE despes-decla-import.val-despes NO-UNDO.
    DEFINE OUTPUT PARAMETER d-tot-val-desp-compl     LIKE despes-decla-import.val-despes NO-UNDO.
    DEFINE OUTPUT PARAMETER d-tot-val-desp-di-me     LIKE despes-decla-import.val-despes NO-UNDO.
    DEFINE OUTPUT PARAMETER d-tot-val-desp-di        LIKE despes-decla-import.val-despes NO-UNDO.

    DEFINE VARIABLE d-val-despes        LIKE despes-decla-import.val-despes NO-UNDO.

    FOR FIRST bf{&TABLENAME} NO-LOCK
        WHERE bf{&TABLENAME}.num-di-ems = p-num-di-ems
          AND bf{&TABLENAME}.cdd-siscomex-dts = p-cdd-siscomex-dts,
        FIRST decla-import-adic NO-LOCK
        WHERE decla-import-adic.num-di-ems = p-num-di-ems
          AND decla-import-adic.cdd-siscomex-dts = p-cdd-siscomex-dts:

        FIND FIRST moeda NO-LOCK
             WHERE moeda.mo-codigo = decla-import-adic.cdn-moeda NO-ERROR.

        FIND FIRST param-imp NO-LOCK
             WHERE param-imp.cod-estabel = p-cod-estabel NO-ERROR.

        ASSIGN c-moeda-adic   = fnBuscaMoeda(decla-import-adic.cdn-moeda)
               c-moeda-frete  = fnBuscaMoeda(decla-import-adic.cdn-moed-frete)
               c-moeda-seguro = fnBuscaMoeda(decla-import-adic.cdn-moed-seguro)
               c-moeda-acres  = fnBuscaMoeda(param-imp.int-2).

        /* valores da moeda REAL */
        ASSIGN d-val-vmcv   = bf{&TABLENAME}.val-vmcv
               d-val-vmle   = bf{&TABLENAME}.val-vmle
               d-val-vmld   = bf{&TABLENAME}.val-vmld
               d-val-frete  = bf{&TABLENAME}.val-frete
               d-val-seguro = bf{&TABLENAME}.val-seguro.

        /*valores da moeda estrangeira */
        IF decla-import-adic.cdn-moeda = 0 THEN
            ASSIGN d-val-vmcv-me   = 0
                   d-val-vmle-me   = 0
                   d-val-vmld-me   = 0.
        ELSE DO:
            IF decla-import-adic.cdn-moeda <> param-imp.int-2 THEN
                ASSIGN d-val-vmcv-me   = bf{&TABLENAME}.val-vmcv-me[1]
                       d-val-vmle-me   = bf{&TABLENAME}.val-vmle-me[1]
                       d-val-vmld-me   = bf{&TABLENAME}.val-vmld-me[1].
            ELSE
                ASSIGN d-val-vmcv-me   = bf{&TABLENAME}.val-vmcv-me[2]
                       d-val-vmle-me   = bf{&TABLENAME}.val-vmle-me[2]
                       d-val-vmld-me   = bf{&TABLENAME}.val-vmld-me[2].
        END.

        ASSIGN d-val-frete  = bf{&TABLENAME}.val-frete
               d-val-seguro = bf{&TABLENAME}.val-seguro.

        IF decla-import-adic.cdn-moed-frete <> param-imp.int-2  THEN
            ASSIGN d-val-frete-me = bf{&TABLENAME}.val-frete-me[1].
        ELSE
            ASSIGN d-val-frete-me = bf{&TABLENAME}.val-frete-me[2].

        IF decla-import-adic.cdn-moed-seguro <> param-imp.int-2 THEN
            ASSIGN d-val-seguro-me = bf{&TABLENAME}.val-seguro-me[1].
        ELSE
            ASSIGN d-val-seguro-me = bf{&TABLENAME}.val-seguro-me[2].

        /* acrescimo */
        ASSIGN d-val-acresc    = bf{&TABLENAME}.val-acresc
               d-val-acresc-me = bf{&TABLENAME}.val-acresc-me[1].

        /* total despesas atÇ o ponto de nacionalizacao e despesas complementares */
        FOR EACH despes-decla-import NO-LOCK
           WHERE despes-decla-import.num-di-ems = bf{&TABLENAME}.num-di-ems
             AND despes-decla-import.cdd-siscomex-dts = bf{&TABLENAME}.cdd-siscomex-dts:

            IF despes-decla-import.idi-tip-incid-nf = 1 THEN DO:

                IF despes-decla-import.cdn-moeda <> param-imp.int-2 THEN DO:

                    ASSIGN d-val-despes = 0.

                    RUN converteValorMoeda(INPUT bf{&TABLENAME}.num-di-ems,
                                           INPUT bf{&TABLENAME}.cdd-siscomex-dts,
                                           INPUT despes-decla-import.cdn-moeda,
                                           INPUT param-imp.int-2, /* moeda dolar */
                                           INPUT despes-decla-import.val-despes,
                                           INPUT bf{&TABLENAME}.dat-di,
                                           OUTPUT d-val-despes).

                    ASSIGN d-tot-val-desp-nacion-me = d-tot-val-desp-nacion-me + d-val-despes.
                END.
                ELSE
                    ASSIGN d-tot-val-desp-nacion-me = d-tot-val-desp-nacion-me + despes-decla-import.val-despes.
            END.

            IF despes-decla-import.idi-tip-incid-nf = 2 THEN DO:

                IF despes-decla-import.cdn-moeda <> param-imp.int-2 THEN DO:

                    ASSIGN d-val-despes = 0.

                    RUN converteValorMoeda(INPUT bf{&TABLENAME}.num-di-ems,
                                           INPUT bf{&TABLENAME}.cdd-siscomex-dts,
                                           INPUT despes-decla-import.cdn-moeda,
                                           INPUT param-imp.int-2, /* moeda dolar */
                                           INPUT despes-decla-import.val-despes,
                                           INPUT bf{&TABLENAME}.dat-di,
                                           OUTPUT d-val-despes).

                    ASSIGN d-tot-val-desp-compl-me = d-tot-val-desp-compl-me + d-val-despes.
                END.
                ELSE
                    ASSIGN d-tot-val-desp-compl-me = d-tot-val-desp-compl-me + despes-decla-import.val-despes.
            END.
        END.

        FOR EACH despes-adic NO-LOCK
           WHERE despes-adic.num-di-ems = bf{&TABLENAME}.num-di-ems
             AND despes-adic.cdd-siscomex-dts = bf{&TABLENAME}.cdd-siscomex-dts
             AND despes-adic.idi-orig-despes = 1:

            IF despes-adic.cdn-moeda <> param-imp.int-2 THEN DO:

                ASSIGN d-val-despes = 0.

                RUN converteValorMoeda(INPUT bf{&TABLENAME}.num-di-ems,
                                       INPUT bf{&TABLENAME}.cdd-siscomex-dts,
                                       INPUT despes-adic.cdn-moeda,
                                       INPUT param-imp.int-2, /* moeda dolar */
                                       INPUT despes-adic.val-despes,
                                       INPUT bf{&TABLENAME}.dat-di,
                                       OUTPUT d-val-despes).

                ASSIGN d-tot-val-desp-nacion-me = d-tot-val-desp-nacion-me + d-val-despes.
            END.
            ELSE
                ASSIGN d-tot-val-desp-nacion-me = d-tot-val-desp-nacion-me + despes-adic.val-despes.
        END.

        ASSIGN d-tot-val-desp-di-me = d-tot-val-desp-nacion-me + d-tot-val-desp-compl-me.

        RUN converteValorMoeda(INPUT bf{&TABLENAME}.num-di-ems,
                               INPUT bf{&TABLENAME}.cdd-siscomex-dts,
                               INPUT param-imp.int-2,
                               INPUT 0, /* 0 - real */
                               INPUT d-tot-val-desp-nacion-me,
                               INPUT bf{&TABLENAME}.dat-di,
                               OUTPUT d-tot-val-desp-nacion).

        RUN converteValorMoeda(INPUT bf{&TABLENAME}.num-di-ems,
                               INPUT bf{&TABLENAME}.cdd-siscomex-dts,
                               INPUT param-imp.int-2,
                               INPUT 0, /* 0 - real */
                               INPUT d-tot-val-desp-compl-me,
                               INPUT bf{&TABLENAME}.dat-di,
                               OUTPUT d-tot-val-desp-compl).

        RUN converteValorMoeda(INPUT bf{&TABLENAME}.num-di-ems,
                               INPUT bf{&TABLENAME}.cdd-siscomex-dts,
                               INPUT param-imp.int-2,
                               INPUT 0, /* 0 - real */
                               INPUT d-tot-val-desp-di-me,
                               INPUT bf{&TABLENAME}.dat-di,
                               OUTPUT d-tot-val-desp-di).
        /* fim - total despesas atÇ o ponto de nacionalizacao e despesas complementares */
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tab-ocor DBOProgram
PROCEDURE pi-cria-tab-ocor :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-decla-import-aux.
    DEFINE INPUT PARAMETER TABLE FOR tt-decla-import-embal.
    DEFINE INPUT PARAMETER p-seg-usuario LIKE usuar-mater.cod-usuario NO-UNDO.

    DEFINE VARIABLE i-contaregistro AS INTEGER     NO-UNDO.

    FOR FIRST tt-decla-import-aux:

        FIND FIRST tab-ocor
             WHERE tab-ocor.cod-tab = 610
               AND TRIM(SUBSTRING(tab-ocor.char-1,1,12))  = TRIM(p-seg-usuario) NO-LOCK NO-ERROR.

        IF NOT AVAIL tab-ocor THEN DO:

            FIND LAST tab-ocor NO-LOCK
                WHERE tab-ocor.cod-tab = 610 NO-ERROR.

            IF AVAIL tab-ocor THEN
                ASSIGN i-contaregistro = tab-ocor.cod-ocor + 1.
            ELSE
                ASSIGN i-contaregistro = 1.

            CREATE tab-ocor.
            ASSIGN tab-ocor.cod-tab              = 610
                   tab-ocor.cod-ocor             = i-contaregistro
                   OVERLAY(tab-ocor.char-1,1,12) = p-seg-usuario.
        END.
        ELSE DO:
            FOR FIRST tab-ocor
                WHERE tab-ocor.cod-tab = 610
                AND   TRIM(SUBSTRING(tab-ocor.char-1,1,12))  = TRIM(p-seg-usuario) EXCLUSIVE-LOCK: END.
        END.

        ASSIGN OVERLAY(tab-ocor.c-campo[1],1,1) =    STRING(tt-decla-import-aux.idi-tip-decla-import)
               OVERLAY(tab-ocor.c-campo[1],2,1) =    STRING(tt-decla-import-aux.idi-caract-operac   )
               OVERLAY(tab-ocor.c-campo[1],3,1) =    STRING(tt-decla-import-aux.idi-modalid-despch  )
               OVERLAY(tab-ocor.c-campo[1],4,1) =    STRING(tt-decla-import-aux.idi-via-transp-di   )
               OVERLAY(tab-ocor.c-campo[1],5,1) =    STRING(tt-decla-import-aux.idi-docto-carg      )
               OVERLAY(tab-ocor.c-campo[1],6,1) =    STRING(tt-decla-import-aux.idi-tip-conhecto    )
               OVERLAY(tab-ocor.c-campo[1],7,1) =    STRING(tt-decla-import-aux.idi-ind-utiliz      )
               OVERLAY(tab-ocor.char-1,13,9)    =    STRING(tt-decla-import-aux.cdn-consign         )
               tab-ocor.l-campo[1]              =           tt-decla-import-aux.log-fundap
               OVERLAY(tab-ocor.char-1,22,15)   =           tt-decla-import-aux.cod-identif
               OVERLAY(tab-ocor.char-1,38,25)   =           tt-decla-import-aux.cod-conhecto-house
               OVERLAY(tab-ocor.char-1,64,6)    =           tt-decla-import-aux.cod-natur-operac
               OVERLAY(tab-ocor.char-1,70,9)    = SUBSTRING(tt-decla-import-aux.cod-livre-1,3,9) /* Despachante*/ .
    END.

    ASSIGN i-contaregistro = 0.

    RELEASE tab-ocor.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-deleta-relacs DBOProgram
PROCEDURE pi-deleta-relacs :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-di-ems       LIKE {&TableName}.num-di-ems       NO-UNDO.
    DEFINE INPUT PARAMETER pcdd-siscomex-dts LIKE {&TableName}.cdd-siscomex-dts NO-UNDO.

    /*---[ Zera Sequencia da ordem ]-------------------------------------------------------------------------*/
    FOR EACH decla-import-ord EXCLUSIVE-LOCK
       WHERE decla-import-ord.num-di-ems = pnum-di-ems
        AND decla-import-ord.cdd-siscomex-dts = pcdd-siscomex-dts:

        ASSIGN decla-import-ord.num-adic = 0
               decla-import-ord.num-seq  = 0.
    END. /* FOR EACH   decla-import-adic-itens */

    /*---[ Itens das Adiá‰es ]-------------------------------------------------------------------------*/
    FOR EACH decla-import-adic-itens EXCLUSIVE-LOCK
       WHERE decla-import-adic-itens.num-di-ems = pnum-di-ems
         AND decla-import-adic-itens.cdd-siscomex-dts = pcdd-siscomex-dts:
        DELETE decla-import-adic-itens validate(true, "").
    END. /* FOR EACH   decla-import-adic-itens */

    /* Reforma Tributaria */
    FOR EACH decla-imp-adic-it-trib EXCLUSIVE-LOCK
       WHERE decla-imp-adic-it-trib.num-di-ems = pnum-di-ems
         AND decla-imp-adic-it-trib.cdd-siscomex-dts = pcdd-siscomex-dts:
        DELETE decla-imp-adic-it-trib validate(true, "").
    END.

    /*---[ Documentos Vinculados ]---------------------------------------------------------------------*/
    FOR EACH   decla-import-adic-docto EXCLUSIVE-LOCK
       WHERE decla-import-adic-docto.num-di-ems = pnum-di-ems
         AND decla-import-adic-docto.cdd-siscomex-dts = pcdd-siscomex-dts:
        DELETE decla-import-adic-docto validate(true, "").
    END. /* FOR EACH   decla-import-adic-docto */

    /*---[ NVE ]---------------------------------------------------------------------------------------*/
    FOR EACH decla-import-adic-nve EXCLUSIVE-LOCK
       WHERE decla-import-adic-nve.num-di-ems = pnum-di-ems
         AND decla-import-adic-nve.cdd-siscomex-dts = pcdd-siscomex-dts:
        DELETE decla-import-adic-nve validate(true, "").
    END. /* FOR EACH   decla-import-adic-nve */

    /*---[ Adiá‰es ]-----------------------------------------------------------------------------------*/
    FOR FIRST decla-import EXCLUSIVE-LOCK
        WHERE decla-import.num-di-ems = pnum-di-ems
          AND decla-import.cdd-siscomex-dts = pcdd-siscomex-dts:
        ASSIGN decla-import.num-adicoes = 0.
    END.


    FOR EACH decla-import-adic EXCLUSIVE-LOCK
       WHERE decla-import-adic.num-di-ems = pnum-di-ems
         AND decla-import-adic.cdd-siscomex-dts = pcdd-siscomex-dts:
        DELETE decla-import-adic validate(true, "").
    END. /* FOR EACH   decla-import-adic */

    /* Reforma Tributaria */
    FOR EACH decla-import-adic-trib EXCLUSIVE-LOCK
       WHERE decla-import-adic-trib.num-di-ems = pnum-di-ems
         AND decla-import-adic-trib.cdd-siscomex-dts = pcdd-siscomex-dts:
        DELETE decla-import-adic-trib validate(true, "").
    END.

    /*---[ Despesas das Adiá‰es ]-----------------------------------------------------------------------------------*/
    FOR EACH despes-adic EXCLUSIVE-LOCK
       WHERE despes-adic.num-di-ems = pnum-di-ems
         AND despes-adic.cdd-siscomex-dts = pcdd-siscomex-dts:

        DELETE despes-adic validate(true, "").
    END. /* FOR EACH   decla-import-adic */

    /*---[ Despesas dos Itens Adiá‰es ]-----------------------------------------------------------------------------------*/
    FOR EACH despes-adic-itens EXCLUSIVE-LOCK
       WHERE despes-adic-itens.num-di-ems = pnum-di-ems
         AND despes-adic-itens.cdd-siscomex-dts = pcdd-siscomex-dts:
        DELETE despes-adic-itens validate(true, "").
    END. /* FOR EACH   decla-import-adic */

    FOR FIRST param-imp NO-LOCK
        WHERE param-imp.cod-estabel = decla-import.cod-estab:
        ASSIGN l-utz-taxa-siscomex = param-imp.log-tax-siscomex
               i-cod-desp          = param-imp.cdn-despes-siscomex.
    END.



    RELEASE decla-import-ord.
    RELEASE decla-import-adic-itens.
    RELEASE decla-imp-adic-it-trib.
    RELEASE decla-import-adic-docto.
    RELEASE decla-import-adic-nve.
    RELEASE decla-import-adic.
    RELEASE decla-import-adic-trib.
    RELEASE despes-adic.
    RELEASE despes-adic-itens.
    RELEASE despes-decla-import.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desativa-retificacao-antiga DBOProgram
PROCEDURE pi-desativa-retificacao-antiga :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-num-seq-retif AS INTEGER     NO-UNDO.

    RUN buscaUltimaRetificacao (INPUT RowObject.num-di-ems, INPUT RowObject.cdd-siscomex-dts, OUTPUT i-num-seq-retif).

    IF  i-num-seq-retif = RowObject.num-seq-retif THEN DO:

        FOR EACH bf{&TABLENAME}
            WHERE bf{&TABLENAME}.num-di-ems = RowObject.num-di-ems
            AND bf{&TABLENAME}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts
            AND   bf{&TABLENAME}.num-seq-retif <> RowObject.num-seq-retif EXCLUSIVE-LOCK:
            ASSIGN bf{&TABLENAME}.log-ativo = NO.
        END.

        RELEASE bf{&TABLENAME}.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-valores-di DBOProgram
PROCEDURE pi-gera-valores-di :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pNumDiEms  LIKE {&TABLENAME}.num-di-ems    NO-UNDO.
    DEFINE INPUT  PARAMETER pNumSeqRet LIKE {&TABLENAME}.num-seq-retif NO-UNDO.
    DEFINE INPUT  PARAMETER pCddSiscomexDts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-decla-import-aux.

    EMPTY TEMP-TABLE tt-decla-import-aux.

    FOR FIRST bf{&TABLENAME} NO-LOCK
        WHERE bf{&TABLENAME}.num-di-ems = pNumDiEms
        AND   bf{&TABLENAME}.num-seq-retif = pNumSeqRet
        AND   bf{&TABLENAME}.cdd-siscomex-dts = pCddSiscomexDts:

        CREATE tt-decla-import-aux.
        BUFFER-COPY bf{&TABLENAME} TO tt-decla-import-aux.
    END.

    FOR FIRST tt-decla-import-aux: END.

    FOR EACH decla-import-adic-itens NO-LOCK
        WHERE decla-import-adic-itens.num-di-ems = pNumDiEms
          AND decla-import-adic-itens.cdd-siscomex-dts = pCddSiscomexDts:
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-GeraDeclaImportOrdTrib wMaintenance
PROCEDURE pi-GeraDeclaImportOrdTrib :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nom-trib      AS CHAR  NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-campo     AS CHAR  NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-conteudo  AS CHAR  NO-UNDO.

    FIND FIRST tt-decla-import-ord-trib
         WHERE tt-decla-import-ord-trib.num-di-ems          = tt-decla-import-ord.num-di-ems
           AND tt-decla-import-ord-trib.num-ordem           = tt-decla-import-ord.num-ordem
           AND tt-decla-import-ord-trib.num-parcela         = tt-decla-import-ord.num-parcela
           AND tt-decla-import-ord-trib.cdd-siscomex-dts    = tt-decla-import-ord.cdd-siscomex-dts
           AND tt-decla-import-ord-trib.nom-trib            = p-nom-trib
           AND tt-decla-import-ord-trib.cod-campo           = p-cod-campo EXCLUSIVE-LOCK NO-ERROR.
     IF NOT AVAIL tt-decla-import-ord-trib THEN DO:
         CREATE tt-decla-import-ord-trib.
         ASSIGN tt-decla-import-ord-trib.num-di-ems          = tt-decla-import-ord.num-di-ems
                tt-decla-import-ord-trib.num-ordem           = tt-decla-import-ord.num-ordem
                tt-decla-import-ord-trib.num-parcela         = tt-decla-import-ord.num-parcela
                tt-decla-import-ord-trib.cdd-siscomex-dts    = tt-decla-import-ord.cdd-siscomex-dts
                tt-decla-import-ord-trib.nom-trib            = p-nom-trib
                tt-decla-import-ord-trib.cod-campo           = p-cod-campo.

      END.
      ASSIGN tt-decla-import-ord-trib.cod-conteudo = p-cod-conteudo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-GeraDeclaImportAdicTrib wMaintenance
PROCEDURE pi-GeraDeclaImportAdicTrib:
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-num-di-ems           AS INTEGER  NO-UNDO.
    DEFINE INPUT  PARAMETER p-cdd-siscomex-dts     AS DECIMAL  NO-UNDO.
    DEFINE INPUT  PARAMETER p-num-ordem            AS INTEGER  NO-UNDO.
    DEFINE INPUT  PARAMETER p-num-parcela          AS INTEGER  NO-UNDO.
    DEFINE INPUT  PARAMETER p-num-adic             AS INTEGER  NO-UNDO.

    FOR EACH decla-import-ord-trib WHERE decla-import-ord-trib.num-di-ems       = p-num-di-ems
                                   AND   decla-import-ord-trib.cdd-siscomex-dts = p-cdd-siscomex-dts
                                   AND   decla-import-ord-trib.num-ordem        = p-num-ordem
                                   AND   decla-import-ord-trib.num-parcela      = p-num-parcela
                                   NO-LOCK:
        FIND FIRST tt-decla-import-adic-trib WHERE tt-decla-import-adic-trib.num-di-ems       = p-num-di-ems
                                             AND   tt-decla-import-adic-trib.num-adic         = p-num-adic
                                             AND   tt-decla-import-adic-trib.cdd-siscomex-dts = p-cdd-siscomex-dts
                                             AND   tt-decla-import-adic-trib.nom-trib         = decla-import-ord-trib.nom-trib
                                             AND   tt-decla-import-adic-trib.cod-campo        = decla-import-ord-trib.cod-campo
                                             NO-ERROR.
        IF NOT AVAIL tt-decla-import-adic-trib THEN DO:
            CREATE tt-decla-import-adic-trib.
            ASSIGN tt-decla-import-adic-trib.num-di-ems          = decla-import-ord-trib.num-di-ems
                   tt-decla-import-adic-trib.num-adic            = p-num-adic
                   tt-decla-import-adic-trib.cdd-siscomex-dts    = decla-import-ord-trib.cdd-siscomex-dts
                   tt-decla-import-adic-trib.nom-trib            = decla-import-ord-trib.nom-trib
                   tt-decla-import-adic-trib.cod-campo           = decla-import-ord-trib.cod-campo.
        END.

        ASSIGN tt-decla-import-adic-trib.cod-conteudo = decla-import-ord-trib.cod-conteudo.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-GeraDeclaImpAdicItemTrib wMaintenance
PROCEDURE pi-GeraDeclaImpAdicItemTrib:
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-num-di-ems           AS INTEGER  NO-UNDO.
    DEFINE INPUT  PARAMETER p-cdd-siscomex-dts     AS DECIMAL  NO-UNDO.
    DEFINE INPUT  PARAMETER p-num-adic             AS INTEGER  NO-UNDO.
    DEFINE INPUT  PARAMETER p-num-seq              AS INTEGER  NO-UNDO.

    FOR EACH tt-decla-import-adic-trib WHERE tt-decla-import-adic-trib.num-di-ems       = p-num-di-ems
                                       AND   tt-decla-import-adic-trib.num-adic         = p-num-adic
                                       AND   tt-decla-import-adic-trib.cdd-siscomex-dts = p-cdd-siscomex-dts
                                       NO-LOCK:
        FIND FIRST tt-decla-imp-adic-it-trib WHERE tt-decla-imp-adic-it-trib.num-di-ems       = p-num-di-ems
                                             AND   tt-decla-imp-adic-it-trib.num-adic         = p-num-adic
                                             AND   tt-decla-imp-adic-it-trib.cdd-siscomex-dts = p-cdd-siscomex-dts
                                             AND   tt-decla-imp-adic-it-trib.num-seq          = p-num-seq
                                             AND   tt-decla-imp-adic-it-trib.nom-trib         = tt-decla-import-adic-trib.nom-trib
                                             AND   tt-decla-imp-adic-it-trib.cod-campo        = tt-decla-import-adic-trib.cod-campo
                                             NO-ERROR.
        IF NOT AVAIL tt-decla-imp-adic-it-trib THEN DO:
            CREATE tt-decla-imp-adic-it-trib.
            ASSIGN tt-decla-imp-adic-it-trib.num-di-ems          = tt-decla-import-adic-trib.num-di-ems
                   tt-decla-imp-adic-it-trib.num-adic            = tt-decla-import-adic-trib.num-adic
                   tt-decla-imp-adic-it-trib.num-seq             = p-num-seq
                   tt-decla-imp-adic-it-trib.cdd-siscomex-dts    = tt-decla-import-adic-trib.cdd-siscomex-dts
                   tt-decla-imp-adic-it-trib.nom-trib            = tt-decla-import-adic-trib.nom-trib
                   tt-decla-imp-adic-it-trib.cod-campo           = tt-decla-import-adic-trib.cod-campo.
        END.
        ASSIGN tt-decla-imp-adic-it-trib.cod-conteudo = tt-decla-import-adic-trib.cod-conteudo.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-limpa-temp-table DBOProgram
PROCEDURE pi-limpa-temp-table :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:       esta procedure limpa as tt que estao na memoria quando informamos adicoes
               manualmente atraves do im0410. ù chamado pela cxbo/bocx403.p
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-decla-import-adic.
    EMPTY TEMP-TABLE tt-decla-import-adic-itens.
    EMPTY TEMP-TABLE tt-decla-import-adic-trib.
    EMPTY TEMP-TABLE tt-decla-imp-adic-it-trib.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-quebra-nve DBOProgram
PROCEDURE pi-quebra-nve :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-num-adic LIKE decla-import-adic-itens.num-adic NO-UNDO.

    DEFINE BUFFER bf-tt-decla-import-adic-itens FOR tt-decla-import-adic-itens.

    FOR FIRST tt-decla-import-ord: END.

    DEFINE VARIABLE l-igual AS LOGICAL  INITIAL NO   NO-UNDO.

    FOR EACH nve-item NO-LOCK
        WHERE nve-item.cod-item = tt-decla-import-ord.cod-item :

        FOR EACH tt-decla-import-adic-itens
            BREAK BY tt-decla-import-adic-itens.num-adic:

            FOR EACH  bf-nve-item
                WHERE bf-nve-item.cod-item    = tt-decla-import-adic-itens.cod-item
                AND   bf-nve-item.idi-niv     = nve-item.idi-niv
                AND   bf-nve-item.cod-ident   = nve-item.cod-ident
                AND   bf-nve-item.cod-atributo   = nve-item.cod-atributo
                AND   bf-nve-item.cdn-especif = nve-item.cdn-especif :
                BUFFER-COMPARE nve-item TO bf-nve-item SAVE l-igual.
            END.

            IF LAST-OF(tt-decla-import-adic-itens.num-adic) THEN DO:
                IF l-igual THEN
                    ASSIGN p-num-adic = tt-decla-import-adic-itens.num-adic.
                ELSE
                    ASSIGN p-num-adic = 0.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-dados-tab-ocor DBOProgram
PROCEDURE pi-retorna-dados-tab-ocor :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-seg-usuario LIKE usuar-mater.cod-usuario NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-decla-import-aux.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-decla-import-embal.

    EMPTY TEMP-TABLE tt-decla-import-aux.
    EMPTY TEMP-TABLE tt-decla-import-embal.

    IF CAN-FIND(FIRST tab-ocor
                WHERE tab-ocor.cod-tab = 610
                AND   trim(SUBSTRING(tab-ocor.char-1,1,12))  = p-seg-usuario) THEN DO:

        FOR FIRST tab-ocor
            WHERE tab-ocor.cod-tab = 610
            AND   trim(SUBSTRING(tab-ocor.char-1,1,12))  = p-seg-usuario NO-LOCK:

            CREATE tt-decla-import-aux.
            ASSIGN tt-decla-import-aux.idi-tip-decla-import     = INT(SUBSTRING(tab-ocor.c-campo[1],1,1))
                   tt-decla-import-aux.idi-caract-operac        = INT(SUBSTRING(tab-ocor.c-campo[1],2,1))
                   tt-decla-import-aux.idi-modalid-despch       = INT(SUBSTRING(tab-ocor.c-campo[1],3,1))
                   tt-decla-import-aux.idi-via-transp-di        = INT(SUBSTRING(tab-ocor.c-campo[1],4,1))
                   tt-decla-import-aux.idi-docto-carg           = INT(SUBSTRING(tab-ocor.c-campo[1],5,1))
                   tt-decla-import-aux.idi-tip-conhecto         = INT(SUBSTRING(tab-ocor.c-campo[1],6,1))
                   tt-decla-import-aux.idi-ind-utiliz           = INT(SUBSTRING(tab-ocor.c-campo[1],7,1))
                   tt-decla-import-aux.cdn-consign              = INT(SUBSTRING(tab-ocor.char-1,13,9)   )
                   tt-decla-import-aux.cod-identif              = SUBSTRING(tab-ocor.char-1,22,15)
                   tt-decla-import-aux.cod-conhecto-house       = SUBSTRING(tab-ocor.char-1,38,25)
                   tt-decla-import-aux.cod-natur-operac         = SUBSTRING(tab-ocor.char-1,64,6)
                   tt-decla-import-aux.log-fundap               = tab-ocor.l-campo[1]
                   OVERLAY(tt-decla-import-aux.cod-livre-1,3,9) = SUBSTRING(tab-ocor.char-1,70,9).
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-atualiza-cotac DBOProgram
PROCEDURE pi-seta-atualiza-cotac :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pAtualizaData AS LOGICAL NO-UNDO.

    ASSIGN l-atualiza-data = pAtualizaData.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-desemb-parc DBOProgram
PROCEDURE pi-seta-desemb-parc :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pDesemb AS LOGICAL NO-UNDO.

    ASSIGN l-desemb-parc = pDesemb.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-l-automatica DBOProgram
PROCEDURE pi-seta-l-automatica :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEF INPUT PARAM TABLE FOR tt-decla-import-embarq-nat.

    ASSIGN l-automatica = YES.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-l-im0099 DBOProgram
PROCEDURE pi-seta-l-im0099 :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-l-im0099 AS LOGICAL NO-UNDO.

    ASSIGN l-im0099 = p-l-im0099.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-totaliza-taxa-siscomex DBOProgram
PROCEDURE pi-totaliza-taxa-siscomex :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER i-num-di-ems LIKE decla-import.num-di-ems NO-UNDO.
    DEFINE INPUT PARAMETER p-cdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts NO-UNDO.

    DEFINE VARIABLE l-primeiro AS LOGICAL INITIAL NO NO-UNDO.

    ASSIGN d-val-despes-tot = 0.

    IF NOT VALID-HANDLE(h-bocx406) THEN DO:
        RUN cxbo/bocx406.p PERSISTENT SET h-bocx406.
        RUN openQueryStatic IN h-bocx406 (INPUT "Main":U) NO-ERROR.
    END.

    FIND FIRST decla-import no-lock
         WHERE decla-import.num-di-ems = i-num-di-ems
           AND decla-import.cdd-siscomex-dts = p-cdd-siscomex-dts NO-ERROR.

    FIND FIRST param-imp NO-LOCK
         WHERE param-imp.cod-estabel = decla-import.cod-estab NO-ERROR.

    /* verificar param */
    ASSIGN i-cod-desp = param-imp.cdn-despes-siscomex
           l-primeiro = YES.

    /* totaliza o valor da despesa de siscomex das adicoes e atualiza a di */
     FOR EACH decla-import-adic NO-LOCK
        WHERE decla-import-adic.num-di-ems = i-num-di-ems
          AND decla-import-adic.cdd-siscomex-dts = p-cdd-siscomex-dts,
        FIRST despes-adic NO-LOCK
        WHERE despes-adic.num-di-ems = i-num-di-ems
          AND despes-adic.num-adic   = decla-import-adic.num-adic
          AND despes-adic.cdn-despes = i-cod-desp
          AND despes-adic.cdd-siscomex-dts = p-cdd-siscomex-dts:

         IF l-primeiro THEN DO:
             ASSIGN i-cod-emitente-desp         = despes-adic.cdn-emit-despes
                    i-cod-cond-pag              = despes-adic.cdn-cond-pag
                    i-cdn-pto-nacionaliz-histor = despes-adic.cdn-pto-control
                    l-primeiro                  = NO.
         END.

         ASSIGN d-val-despes-tot = d-val-despes-tot + despes-adic.val-despes.
     END.

     /* seta a variavel l-automatico para yes, para passar pela validaá∆o do siscomex */
     RUN pi-seta-l-automatico IN h-bocx406(INPUT YES).

     EMPTY TEMP-TABLE tt-despes-decla-import.

     CREATE tt-despes-decla-import.
     ASSIGN tt-despes-decla-import.num-di-ems       = decla-import.num-di-ems
            tt-despes-decla-import.cdn-despes       = i-cod-desp
            tt-despes-decla-import.cdn-emit-despes  = i-cod-emitente-desp
            tt-despes-decla-import.cdn-cond-pagto   = i-cod-cond-pag
            tt-despes-decla-import.cdn-moeda        = 0
            tt-despes-decla-import.cdn-pto-control  = i-cdn-pto-nacionaliz-histor
            tt-despes-decla-import.val-despes       = d-val-despes-tot
            tt-despes-decla-import.idi-tip-incid-nf = 1
            tt-despes-decla-import.cdd-siscomex-dts = decla-import.cdd-siscomex-dts.

     RUN goToKey IN h-bocx406(INPUT tt-despes-decla-import.num-di-ems,
                              INPUT tt-despes-decla-import.cdn-pto-control,
                              INPUT tt-despes-decla-import.cdn-despes,
                              INPUT tt-despes-decla-import.cdn-emit-despes,
                              INPUT tt-despes-decla-import.cdd-siscomex-dts).

     IF RETURN-VALUE = "NOK":U THEN DO:
        RUN emptyRowObject  IN h-bocx406.
        RUN emptyRowErrors  IN h-bocx406.
        RUN setRecord       IN h-bocx406 (INPUT TABLE tt-despes-decla-import).
        RUN createRecord    IN h-bocx406.
     END.
     ELSE DO:
         RUN emptyRowObject  IN h-bocx406.
         RUN emptyRowErrors  IN h-bocx406.
         RUN setRecord       IN h-bocx406 (INPUT TABLE tt-despes-decla-import).
         RUN updateRecord    IN h-bocx406.
     END.
     /* seta a variavel l-automatico para yes, para passar pela validaá∆o do siscomex */
     RUN pi-seta-l-automatico IN h-bocx406(INPUT NO).

     IF VALID-HANDLE(h-bocx406) THEN
        DELETE PROCEDURE h-bocx406.
    ASSIGN h-bocx406 = ?.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-alteracao-data-di DBOProgram
PROCEDURE pi-valida-alteracao-data-di :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pNumDiEms LIKE {&TABLENAME}.num-di-ems      NO-UNDO.
    DEFINE INPUT  PARAMETER pSeqRetif LIKE {&TABLENAME}.num-seq-retif   NO-UNDO.
    DEFINE INPUT  PARAMETER pData     LIKE {&TABLENAME}.dat-di          NO-UNDO.
    DEFINE INPUT  PARAMETER pCddSiscomexDts  LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.
    DEFINE OUTPUT PARAMETER pRetorno  AS LOGICAL                        NO-UNDO.

    FOR FIRST bf{&TABLENAME} NO-LOCK
        WHERE bf{&TABLENAME}.num-di-ems    = pNumDiEms
        AND   bf{&TABLENAME}.num-seq-retif = pSeqRetif
          AND bf{&TABLENAME}.cdd-siscomex-dts = pCddSiscomexDts:

        IF bf{&TABLENAME}.dat-di <> pData THEN
            ASSIGN pRetorno = YES.
        ELSE
            ASSIGN pRetorno = NO.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-alteracao-data-duimp DBOProgram
PROCEDURE pi-valida-alteracao-data-duimp :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pNumDiEms LIKE {&TABLENAME}.num-di-ems      NO-UNDO.
    DEFINE INPUT  PARAMETER pSeqRetif LIKE {&TABLENAME}.num-seq-retif   NO-UNDO.
    DEFINE INPUT  PARAMETER pData     LIKE {&TABLENAME}.dat-di          NO-UNDO.
    DEFINE INPUT  PARAMETER pCddSiscomexDts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.
    DEFINE OUTPUT PARAMETER pRetorno  AS LOGICAL                        NO-UNDO.

    FOR FIRST bf{&TABLENAME} NO-LOCK
        WHERE bf{&TABLENAME}.num-di-ems    = pNumDiEms
        AND   bf{&TABLENAME}.num-seq-retif = pSeqRetif
        AND   bf{&TABLENAME}.cdd-siscomex-dts = pCddSiscomexDts:

        IF bf{&TABLENAME}.dat-di <> pData THEN
            ASSIGN pRetorno = YES.
        ELSE
            ASSIGN pRetorno = NO.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-di-proc-atual-val DBOProgram
PROCEDURE pi-valida-di-proc-atual-val :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pNumDiEms LIKE {&TABLENAME}.num-di-ems NO-UNDO.
    DEFINE INPUT PARAMETER pCddSiscomexDts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.

    EMPTY TEMP-TABLE RowErrors.

    IF NOT VALID-HANDLE(h-bocx395) THEN
        RUN cxbo/bocx395.p PERSISTENT SET h-bocx395.

    FOR LAST bf{&TABLENAME} NO-LOCK
        WHERE bf{&TABLENAME}.num-di-ems = pNumDiEms
          AND bf{&TABLENAME}.cdd-siscomex-dts = pCddSiscomexDts: END.

    IF NOT AVAIL bf{&TABLENAME} THEN
        RETURN "NOK":U.

    IF bf{&TABLENAME}.dat-di = ? THEN DO:

        {utp/ut-liter.i "Data_Declaraá∆o_Importaá∆o" *}
        {method/svc/errors/inserr.i &ErrorNumber="3936" &ErrorType="EMS" &ErrorParameters="TRIM(RETURN-VALUE)"}
    END.

    /*Validar as cotaá‰es das moedas da DI*/
    RUN getMoedasDespesas IN h-bocx395(INPUT  pNumDiEms, OUTPUT TABLE tt-decla-import-cotac).

    FOR EACH tt-decla-import-cotac
       WHERE tt-decla-import-cotac.val-cotac = 0:

        {method/svc/errors/inserr.i &ErrorNumber="316"
                                    &ErrorType="EMS"
                                    &ErrorParameters=STRING(tt-decla-import-cotac.cdn-moeda) + '~~' + STRING(bf{&TABLENAME}.dat-di)}
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    IF VALID-HANDLE(h-bocx395) THEN
        DELETE PROCEDURE h-bocx395.
    ASSIGN h-bocx395 = ?.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-altera-natur DBOProgram
PROCEDURE pi-verifica-altera-natur :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pNumDiEms LIKE {&TABLENAME}.num-di-ems     NO-UNDO.
    DEFINE INPUT  PARAMETER pSeqRetif LIKE {&TABLENAME}.num-seq-retif  NO-UNDO.
    DEFINE INPUT  PARAMETER pNatOper  LIKE {&TABLENAME}.cod-natur-oper NO-UNDO.
    DEFINE INPUT  PARAMETER pCddSiscomexDts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.
    DEFINE OUTPUT PARAMETER pRetorno  AS LOGICAL                       NO-UNDO.

    IF c-cod-natur-oper-old <> pNatOper
        AND CAN-FIND (FIRST decla-import-embarq
                      WHERE decla-import-embarq.num-di-ems = pNumDiEms
                        AND decla-import-embarq.cdd-siscomex-dts = pCddSiscomexDts)
        AND CAN-FIND(FIRST decla-import-ord
                     WHERE decla-import-ord.num-di-ems = pNumDiEms
                       AND decla-import-ord.cdd-siscomex-dts = pCddSiscomexDts)THEN
        ASSIGN pRetorno = YES.
    ELSE
        ASSIGN pRetorno = NO.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-conf-trib DBOProgram
PROCEDURE pi-verifica-conf-trib :
/*------------------------------------------------------------------------------
  Purpose:     Procedure respons†vel por verificar se existem impostos calculados
               pelo Configurador de Tributos para habilitar o bot∆o de consulta destes
               dados pela Vis∆o DI (IM0400)
  Parameters:  pi-num-di-ems (entrada): N£mero da DI do EMS (integer);
               pl-habilita-bt-conf: (entrada) identifica se existem impostos calculados pelo configurador
                        para habilitar o bot∆o de consulta destas informaá‰es via im0400 (l¢gico)
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pi-num-di-ems       LIKE decla-import.num-di-ems NO-UNDO.
    DEFINE INPUT  PARAMETER pde-cdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-habilita-bt-conf AS   LOGICAL      INITIAL NO NO-UNDO.

    FOR EACH decla-import-embarq
       WHERE decla-import-embarq.num-di-ems = pi-num-di-ems
         AND decla-import-embarq.cdd-siscomex-dts = pde-cdd-siscomex-dts NO-LOCK:
       IF CAN-FIND(FIRST ct-trib-item-doc-est
                   WHERE ct-trib-item-doc-est.cod-embarq  = decla-import-embarq.cod-embarq
                     AND ct-trib-item-doc-est.cod-estab   = decla-import-embarq.cod-estab ) THEN DO:
           ASSIGN pl-habilita-bt-conf = YES.
           LEAVE.
       END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vincula-embarque-desem-parc DBOProgram
PROCEDURE pi-vincula-embarque-desem-parc :
/*------------------------------------------------------------------------------
  Purpose:     Vincula novos embarques a DI do embarque pai
  Parameters:
               recebe n£mero da DI EMS
               recebe Rowid do embarque
               recebe logico informando se deve fazer o relacionamento
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-di-ems     LIKE decla-import.num-di-ems NO-UNDO.
    DEFINE INPUT PARAMETER pde-cdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts NO-UNDO.
    DEFINE INPUT PARAMETER p-rowid-embarque AS ROWID                     NO-UNDO.
    DEFINE INPUT PARAMETER l-relaciona      AS LOGICAL                   NO-UNDO.

    DEFINE VARIABLE iRowsReturned AS INTEGER     NO-UNDO.

    IF l-im0099 THEN DO:

        EMPTY TEMP-TABLE tt-decla-import-ord-aux.

        FOR EACH decla-import-ord NO-LOCK
           WHERE decla-import-ord.num-di-ems  = p-num-di-ems
             AND decla-import-ord.cdd-siscomex-dts = pde-cdd-siscomex-dts:

            CREATE tt-decla-import-ord-aux.
            BUFFER-COPY decla-import-ord TO tt-decla-import-ord-aux.
        END.
        EMPTY TEMP-TABLE tt-decla-import-ord-trib-aux.
        FOR EACH decla-import-ord-trib NO-LOCK
            WHERE decla-import-ord-trib.num-di-ems = p-num-di-ems:

            CREATE tt-decla-import-ord-trib-aux.
            BUFFER-COPY decla-import-ord-trib TO tt-decla-import-ord-trib-aux.
        END.
    END.
    RUN piDeletaRelacs (INPUT p-num-di-ems,
                        INPUT pde-cdd-siscomex-dts).

    FOR FIRST embarque-imp NO-LOCK
        WHERE ROWID(embarque-imp) = p-rowid-embarque : END.

    IF NOT AVAIL (embarque-imp) THEN
        RETURN "NOK":U.

    FOR FIRST decla-import
         WHERE decla-import.num-di-ems = p-num-di-ems
           AND decla-import.cdd-siscomex-dts = pde-cdd-siscomex-dts NO-LOCK:
    END.

    IF NOT AVAIL decla-import THEN
        RETURN "NOK":U.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    {utp/ut-liter.i "Desembarque Parcial"}
    RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

    IF NOT VALID-HANDLE(h-bocx407) THEN
       RUN cxbo/bocx407.p PERSISTENT SET h-bocx407.

    RUN emptyRowObject  IN h-bocx407.

    IF NOT VALID-HANDLE(h-bocx383a) THEN
        RUN cxbo/bocx383a.p PERSISTENT SET h-bocx383a.

    /*Vinculando o embarque a DI*/
    IF l-relaciona THEN DO:

        {utp/ut-liter.i "Vinculando_Embarque_a_DI" *}
        RUN pi-acompanhar IN h-acomp (RETURN-VALUE + "...":U).

        EMPTY TEMP-TABLE tt-decla-import-embarq.
        CREATE tt-decla-import-embarq.
        ASSIGN tt-decla-import-embarq.num-di-ems = p-num-di-ems
               tt-decla-import-embarq.cod-embarq = embarque-imp.embarque
               tt-decla-import-embarq.cod-estab  = embarque-imp.cod-estabel
               tt-decla-import-embarq.cdd-siscomex-dts = pde-cdd-siscomex-dts.

        RUN openQueryStatic IN h-bocx407 (INPUT "Main":U).
        RUN emptyRowErrors  IN h-bocx407.
        RUN setRecord       IN h-bocx407 (INPUT TABLE tt-decla-import-embarq).
        RUN createRecord    IN h-bocx407.
        RUN getRowErrors    IN h-bocx407 (OUTPUT TABLE RowErrors APPEND).
        IF  CAN-FIND(FIRST RowErrors
                     WHERE RowErrors.ErrorType   <> "INTERNAL":U
                     AND   RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            RETURN "NOK":U.
        END.
        ELSE DO:

            IF NOT VALID-HANDLE(h-bocx220na) THEN
                RUN cxbo/bocx220na.p PERSISTENT SET h-bocx220na.
            /*Atualizando embarque-imp com os dados da DI*/
            RUN goToKey IN h-bocx220na (INPUT tt-decla-import-embarq.cod-estab ,
                                        INPUT tt-decla-import-embarq.cod-embarq).

            IF RETURN-VALUE = "OK":U THEN DO:

                RUN getRecord IN h-bocx220na(OUTPUT TABLE tt-embarque-imp).

                FOR FIRST tt-embarque-imp:

                    ASSIGN tt-embarque-imp.declaracao-import = decla-import.cod-di-siscomex
                           tt-embarque-imp.data-di           = decla-import.dat-di
                           &if "{&bf_mat_versao_ems}" < "2.09" &then
                           tt-embarque-imp.int-2             = decla-import.num-di-ems
                           &ELSE
                           tt-embarque-imp.num-di-ems        = decla-import.num-di-ems
                           &ENDIF.
                END.

                {utp/ut-liter.i "Atualizando_dados_do_Embarque" *}
                RUN pi-acompanhar IN h-acomp (RETURN-VALUE + "...":U).

                RUN setRecord    IN h-bocx220na (INPUT TABLE tt-embarque-imp).
                RUN updateRecord IN h-bocx220na.
                RUN getRowErrors IN h-bocx220na (OUTPUT TABLE RowErrors APPEND).

                IF  CAN-FIND(FIRST RowErrors
                             WHERE RowErrors.ErrorType   <> "INTERNAL":U
                             AND   RowErrors.ErrorSubType = "ERROR":U) THEN
                    RETURN "NOK":U.
            END.
        END.
    END.

    EMPTY TEMP-TABLE tt-decla-import-embarq.

    RUN setConstraintByDI IN h-bocx407 (INPUT decla-import.num-di-ems,
                                        INPUT decla-import.cdd-siscomex-dts).
    RUN openQueryStatic   IN h-bocx407 (INPUT "ByDI":U).
    RUN getBatchRecords   IN h-bocx407 (INPUT ?, INPUT ?, INPUT 99999, OUTPUT iRowsReturned, OUTPUT TABLE tt-decla-import-embarq).

    RUN goToKeyCustom (INPUT decla-import.num-di-ems,
                       INPUT decla-import.cdd-siscomex-dts).

    IF RETURN-VALUE = "OK":U THEN
        RUN retornaRegistros (INPUT TABLE tt-decla-import-embarq, OUTPUT TABLE tt-decla-import-ord, OUTPUT TABLE tt-decla-import-ord-trib).

    IF  CAN-FIND(FIRST tt-decla-import-ord) THEN DO:

        {utp/ut-liter.i "Gerando_ordens" *}
        RUN pi-acompanhar IN h-acomp (RETURN-VALUE + "...":U).

        FOR EACH tt-decla-import-ord:

            EMPTY TEMP-TABLE tt-decla-import-ord-aux.

            CREATE tt-decla-import-ord-aux.
            BUFFER-COPY tt-decla-import-ord to tt-decla-import-ord-aux.

            IF NOT VALID-HANDLE(h-bocx404) THEN
                RUN cxbo/bocx404.p PERSISTENT SET h-bocx404.

            RUN openQueryStatic  IN h-bocx404 (INPUT 'Main':U).
            RUN emptyRowErrors   IN h-bocx404.
            RUN emptyRowObject   IN h-bocx404.
            RUN setRecord        IN h-bocx404 (INPUT TABLE tt-decla-import-ord-aux).
            RUN createRecord     IN h-bocx404.

            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN getRowErrors IN h-bocx404(OUTPUT TABLE RowErrors APPEND).
            END.
        END.

        IF CAN-FIND(FIRST RowErrors
                    WHERE RowErrors.ErrorType   <> "INTERNAL":U
                    AND   rowErrors.ErrorSubType = "ERROR":U) THEN DO:
            RETURN "NOK":U.
        END.
        ELSE DO:

            IF  l-nt2024002
            and l-im0099 then do:
               RUN pi-CriaDeclaImportOrdTrib (INPUT TABLE tt-decla-import-ord-trib).
            END.

            /*GERANDO ADIÄÂES E ITENS DA ADIÄ«O E EFETUANDO A QUEBRA*/
            RUN pi-deleta-relacs (INPUT decla-import.num-di-ems,
                                  INPUT decla-import.cdd-siscomex-dts).
            RUN emptyRowErrors   IN THIS-PROCEDURE.

            {utp/ut-liter.i "Gerando_adiá‰es" *}
            RUN pi-acompanhar IN h-acomp (RETURN-VALUE + "...":U).

            IF  l-im0099
            AND i-tp-nacionaliz = 3 /* DUIMP */ THEN
                RUN gerarItensDuimpAdic (INPUT decla-import.num-di-ems,
                                         INPUT decla-import.cdd-siscomex-dts).
            ELSE
                RUN gerarAdicoes (INPUT decla-import.num-di-ems,
                                  INPUT decla-import.cdd-siscomex-dts).

            IF CAN-FIND(FIRST RowErrors
                        WHERE RowErrors.ErrorsubType  = "Error":U
                        AND   RowErrors.ErrorType    <> "INTERNAL":U) THEN DO:
                RETURN "NOK":U.
            END.
            ELSE DO:

                EMPTY TEMP-TABLE tt-decla-import-embarq.
            END.
        END.
    END.


    FIND FIRST decla-import EXCLUSIVE-LOCK
         WHERE decla-import.num-di-ems = p-num-di-ems
           AND decla-import.cdd-siscomex-dts = pde-cdd-siscomex-dts NO-ERROR.

    IF AVAIL decla-import THEN
        ASSIGN decla-import.log-pend-rat          = NO  /*reabrindo rateio desp. Nacionalizaá∆o*/
               decla-import.log-livre-2           = NO  /*reabrindo c†lculo dos impostos*/
        &if "{&bf_mat_versao_ems}" < "2.09" &then
            OVERLAY(decla-import.cod-livre-1,1,1) = "N":U /*reabrindo rateio desp. Compl.*/
        &ELSE
            decla-import.log-pend-despes-compltar = NO /*reabrindo rateio desp. Compl.*/
        &ENDIF .

    RUN pi-rateio-di IN h-bocx383a (INPUT decla-import.num-di-ems,
                                    INPUT decla-import.cdd-siscomex-dts,
                                    INPUT 1). /* rateio despesas de nacionalizacao */

    RUN pi-finalizar IN h-acomp.

    IF VALID-HANDLE(h-acomp) THEN DO:
        DELETE PROCEDURE h-acomp.
        ASSIGN h-acomp = ?.
    END.
    IF VALID-HANDLE (h-bocx407) THEN DO:
        DELETE PROCEDURE h-bocx407.
        ASSIGN h-bocx407 = ?.
    END.
    IF VALID-HANDLE (h-bocx404) THEN DO:
        DELETE PROCEDURE h-bocx404.
        ASSIGN h-bocx404 = ?.
    END.
    IF VALID-HANDLE (h-bocx220na) THEN DO:
        DELETE PROCEDURE h-bocx220na.
        ASSIGN h-bocx220na = ?.
    END.
    IF VALID-HANDLE(h-bocx383a) THEN
        DELETE PROCEDURE h-bocx383a.
    ASSIGN h-bocx383a = ?.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaNumAdicao DBOProgram
PROCEDURE piBuscaNumAdicao :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-num-di-ems   LIKE decla-import-ord.num-di-ems  NO-UNDO.
    DEFINE INPUT  PARAMETER p-numero-ordem LIKE ordens-embarque.numero-ordem NO-UNDO.
    DEFINE INPUT  PARAMETER p-parcela      LIKE ordens-embarque.parcela      NO-UNDO.
    DEFINE INPUT  PARAMETER pde-cdd-siscomex-dts LIKE decla-import-ord.cdd-siscomex-dts NO-UNDO.
    DEFINE OUTPUT PARAMETER p-num-adicao   LIKE decla-import-ord.num-adic    NO-UNDO.


    FIND FIRST decla-import-ord NO-LOCK
         WHERE decla-import-ord.num-di-ems  = p-num-di-ems
         AND   decla-import-ord.num-ordem   = p-numero-ordem
         AND   decla-import-ord.num-parcela = p-parcela
         AND   decla-import-ord.cdd-siscomex = pde-cdd-siscomex-dts NO-ERROR.

    IF AVAIL decla-import-ord THEN
        ASSIGN p-num-adicao = decla-import-ord.num-adic.
    ELSE
        ASSIGN p-num-adicao = 0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDeletaRelacs DBOProgram
PROCEDURE piDeletaRelacs :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-di-ems LIKE {&TableName}.num-di-ems NO-UNDO.
    DEFINE INPUT PARAMETER pde-cdd-siscomex-dts LIKE {&TableName}.cdd-siscomex-dts NO-UNDO.

    /*---[ Ordens DI ]---------------------------------------------------------------------------------*/
    FOR EACH   decla-import-ord EXCLUSIVE-LOCK
         WHERE decla-import-ord.num-di-ems = pnum-di-ems
           AND decla-import-ord.cdd-siscomex-dts = pde-cdd-siscomex-dts:
        DELETE decla-import-ord validate(true, "").
    END.
    /* Reforma Tributaria */
    FOR EACH   decla-import-ord-trib EXCLUSIVE-LOCK
         WHERE decla-import-ord-trib.num-di-ems = pnum-di-ems
           AND decla-import-ord-trib.cdd-siscomex-dts = pde-cdd-siscomex-dts:
        DELETE decla-import-ord-trib validate(true, "").
    END.

    /*---[ Itens das Adiá‰es ]-------------------------------------------------------------------------*/
    FOR EACH   decla-import-adic-itens EXCLUSIVE-LOCK
         WHERE decla-import-adic-itens.num-di-ems = pnum-di-ems
           AND decla-import-adic-itens.cdd-siscomex-dts = pde-cdd-siscomex-dts:
        DELETE decla-import-adic-itens validate(true, "").
    END.
    /* Reforma Tributaria */
    FOR EACH   decla-imp-adic-it-trib EXCLUSIVE-LOCK
        WHERE  decla-imp-adic-it-trib.num-di-ems = pnum-di-ems
        AND    decla-imp-adic-it-trib.cdd-siscomex-dts = pde-cdd-siscomex-dts:
        DELETE decla-imp-adic-it-trib validate(true, "").
    END.

    /*---[ Documentos Vinculados ]---------------------------------------------------------------------*/
    FOR EACH   decla-import-adic-docto EXCLUSIVE-LOCK
        WHERE  decla-import-adic-docto.num-di-ems = pnum-di-ems
        AND    decla-import-adic-docto.cdd-siscomex-dts = pde-cdd-siscomex-dts:
        DELETE decla-import-adic-docto validate(true, "").
    END.

    /*---[ NVE ]---------------------------------------------------------------------------------------*/
    FOR EACH   decla-import-adic-nve EXCLUSIVE-LOCK
        WHERE  decla-import-adic-nve.num-di-ems = pnum-di-ems
        AND    decla-import-adic-nve.cdd-siscomex-dts = pde-cdd-siscomex-dts:
        DELETE decla-import-adic-nve validate(true, "").
    END.

    /*---[ Adiá‰es ]-----------------------------------------------------------------------------------*/
    FOR EACH   decla-import-adic EXCLUSIVE-LOCK
        WHERE  decla-import-adic.num-di-ems = pnum-di-ems
        AND    decla-import-adic.cdd-siscomex-dts = pde-cdd-siscomex-dts:
        DELETE decla-import-adic validate(true, "").
    END.
    /* Reforma Tributaria */
    FOR EACH   decla-import-adic-trib EXCLUSIVE-LOCK
        WHERE  decla-import-adic-trib.num-di-ems = pnum-di-ems
        AND    decla-import-adic-trib.cdd-siscomex-dts = pde-cdd-siscomex-dts:
        DELETE decla-import-adic-trib validate(true, "").
    END.

    /*---[ Despesas das Adiá‰es ]-----------------------------------------------------------------------------------*/
    FOR EACH   despes-adic EXCLUSIVE-LOCK
        WHERE  despes-adic.num-di-ems = pnum-di-ems
        AND    despes-adic.cdd-siscomex-dts = pde-cdd-siscomex-dts:
        DELETE despes-adic validate(true, "").
    END.

    /*---[ Despesas dos Itens Adiá‰es ]-----------------------------------------------------------------------------------*/
    FOR EACH   despes-adic-itens EXCLUSIVE-LOCK
        WHERE  despes-adic-itens.num-di-ems = pnum-di-ems
        AND    decla-import-adic-nve.cdd-siscomex-dts = pde-cdd-siscomex-dts:
        DELETE despes-adic-itens validate(true, "").
    END.

    RELEASE decla-import-ord.
    RELEASE decla-import-ord-trib.
    RELEASE decla-import-adic-itens.
    RELEASE decla-imp-adic-it-trib.
    RELEASE decla-import-adic-docto.
    RELEASE decla-import-adic-nve.
    RELEASE decla-import-adic.
    RELEASE decla-import-adic-trib.
    RELEASE despes-adic.
    RELEASE despes-adic-itens.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaRegistros DBOProgram
PROCEDURE retornaRegistros :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR tt-decla-import-embarq.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-decla-import-ord.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-decla-import-ord-trib.

    DEFINE VAR i-cod-fabricante LIKE processo-imp.cod-fabricante NO-UNDO.

    IF NOT VALID-HANDLE(h-boin082)      THEN RUN inbo/boin082.p    PERSISTENT SET h-boin082.
    IF NOT VALID-HANDLE(h-boin178i)     THEN RUN inbo/boin178i.p   PERSISTENT SET h-boin178i.
    IF NOT VALID-HANDLE(h-bocx404)      THEN RUN cxbo/bocx404.p    PERSISTENT SET h-bocx404.
    IF NOT VALID-HANDLE(h-bocx00507)    THEN RUN cxbo/bocx00507.p  PERSISTENT SET h-bocx00507.

    EMPTY TEMP-TABLE tt-decla-import-ord.

    FOR EACH tt-decla-import-embarq NO-LOCK,
        EACH ordens-embarque NO-LOCK
       WHERE ordens-embarque.cod-estabel = tt-decla-import-embarq.cod-estab
         AND ordens-embarque.embarque    = tt-decla-import-embarq.cod-embarq,
       FIRST ordem-compra NO-LOCK
       WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem:

        FIND FIRST item NO-LOCK
             WHERE item.it-codigo = ordem-compra.it-codigo NO-ERROR.

        FIND FIRST item-mat NO-LOCK
             WHERE item-mat.it-codigo = ordem-compra.it-codigo NO-ERROR.

        FOR FIRST processo-imp FIELDS(cod-fabricante)
            WHERE processo-imp.cod-estabel = tt-decla-import-embarq.cod-estab
              AND processo-imp.nr-proc-imp = ordens-embarque.nr-proc-imp NO-LOCK:
            ASSIGN i-cod-fabricante = processo-imp.cod-fabricante.
        END.

        CREATE tt-decla-import-ord.
        ASSIGN tt-decla-import-ord.num-di-ems          = tt-decla-import-embarq.num-di-ems
               tt-decla-import-ord.num-ordem           = ordens-embarque.numero-ordem
               tt-decla-import-ord.num-parcela         = ordens-embarque.parcela
               tt-decla-import-ord.cdd-siscomex-dts    = tt-decla-import-embarq.cdd-siscomex-dts
               tt-decla-import-ord.cod-estab           = tt-decla-import-embarq.cod-estab
               tt-decla-import-ord.cod-item            = ordem-compra.it-codigo
               tt-decla-import-ord.qtd-item            = ordens-embarque.quantidade
               tt-decla-import-ord.qtd-fornec          = ordens-embarque.qt-do-forn
               tt-decla-import-ord.cod-unid-medid-item = item.un
               tt-decla-import-ord.cod-embarq          = ordens-embarque.embarque
               tt-decla-import-ord.cdn-fornec          = ordem-compra.cod-emitente
               tt-decla-import-ord.val-peso-liq        = ordens-embarque.peso-liquido
               tt-decla-import-ord.val-peso-brut-merc  = ordens-embarque.peso-bruto
               tt-decla-import-ord.val-peso-embal      = ordens-embarque.val-peso-embal
               tt-decla-import-ord.val-cub-tot         = ordens-embarque.val-cub-tot.

        IF NOT l-automatica THEN
            ASSIGN tt-decla-import-ord.cod-natur-operac = RowObject.cod-natur-operac.
        ELSE DO:

            FOR FIRST tt-decla-import-embarq-nat NO-LOCK
                WHERE tt-decla-import-embarq-nat.cod-estab = tt-decla-import-ord.cod-estab
                  AND tt-decla-import-embarq-nat.cod-embarq = tt-decla-import-ord.cod-embarq:

                ASSIGN tt-decla-import-ord.cod-natur-operac = tt-decla-import-embarq-nat.nat-operacao.
            END.
        END.

        ASSIGN tt-decla-import-ord.log-emite-fabrican = NO.

        /*---[ Impostos ]-------------------------------------------------------------------------------------------------------*/
        IF NOT l-im0099 THEN DO:

            FIND FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-operacao = tt-decla-import-ord.cod-natur-operac NO-ERROR.

            IF  AVAIL  natur-oper THEN DO:

                ASSIGN tt-decla-import-ord.val-perc-reduc-icms = natur-oper.perc-red-icm
                       tt-decla-import-ord.val-perc-reduc-ipi  = natur-oper.perc-red-ipi.

                RUN retornaDados-tela IN h-bocx404 (INPUT tt-decla-import-embarq.cod-estab,
                                                    INPUT ordens-embarque.embarque,
                                                    INPUT ordens-embarque.numero-ordem,
                                                    INPUT ordens-embarque.parcela,
                                                    INPUT natur-oper.nat-operacao,
                                                    OUTPUT vtrib-ii-i1,
                                                    OUTPUT vtrib-ipi-i1,
                                                    OUTPUT vtrib-icms-i1,
                                                    OUTPUT vtrib-pis-i1,
                                                    OUTPUT vtrib-cofins-i1,
                                                    OUTPUT vde-aliq-ii-i1,
                                                    OUTPUT vde-aliq-ipi-i1,
                                                    OUTPUT vde-aliq-icms-i1,
                                                    OUTPUT vde-aliq-pis-i1,
                                                    OUTPUT vde-aliq-cofins-i1,
                                                    OUTPUT vsuspensoII,
                                                    OUTPUT vsuspensoIPI,
                                                    OUTPUT vsuspensoICMS,
                                                    OUTPUT vsuspensoPIS,
                                                    OUTPUT vsuspensoCOFINS,
                                                    OUTPUT vtrib-cbs,
                                                    OUTPUT vtrib-ibs-uf,
                                                    OUTPUT vtrib-ibs-mun,
                                                    OUTPUT vde-aliq-cbs,
                                                    OUTPUT vde-aliq-ibs-uf,
                                                    OUTPUT vde-aliq-ibs-mun,
                                                    OUTPUT vde-aliq-red-cbs,
                                                    OUTPUT vde-aliq-red-ibs-uf,
                                                    OUTPUT vde-aliq-red-ibs-mun,
                                                    OUTPUT vcClassTribCBS,
                                                    OUTPUT vcClassTribIBS-UF,
                                                    OUTPUT vcClassTribIBS-Mun,
                                                    OUTPUT vcCST-CBS,
                                                    OUTPUT vcCST-IBS-UF,
                                                    OUTPUT vcCST-IBS-Mun,
                                                    OUTPUT vcCalssTribREG-CBS,
                                                    OUTPUT vcCST-REG-CBS,
                                                    OUTPUT vdeAliqEfetivaREG-CBS,
                                                    OUTPUT vcCalssTribREG-IBS-UF,
                                                    OUTPUT vcCST-REG-IBS-UF,
                                                    OUTPUT vdeAliqEfetivaREG-IBS-UF,
                                                    OUTPUT vcCalssTribREG-IBS-Mun,
                                                    OUTPUT vcCST-REG-IBS-Mun,
                                                    OUTPUT vdeAliqEfetivaREG-IBS-Mun,
                                                    OUTPUT vcClassTribIS,
                                                    OUTPUT vcCST-IS,
                                                    OUTPUT vtrib-is,
                                                    OUTPUT vde-aliq-is,
                                                    OUTPUT vde-aliq-un-is,
                                                    OUTPUT vde-qtde-trib-is,
                                                    OUTPUT vc-un-trib-is).

                ASSIGN tt-decla-import-ord.idi-tributac-impto-import = vtrib-ii-i1
                       tt-decla-import-ord.idi-tributac-ipi          = vtrib-ipi-i1
                       tt-decla-import-ord.idi-tributac-icms         = vtrib-icms-i1
                       tt-decla-import-ord.idi-tributac-pis          = vtrib-pis-i1
                       tt-decla-import-ord.idi-tributac-cofins       = vtrib-cofins-i1
                       tt-decla-import-ord.val-aliq-ii               = vde-aliq-ii-i1
                       tt-decla-import-ord.val-aliq-ipi              = vde-aliq-ipi-i1
                       tt-decla-import-ord.val-aliq-icms             = vde-aliq-icms-i1
                       tt-decla-import-ord.val-aliq-pis              = vde-aliq-pis-i1
                       tt-decla-import-ord.val-aliq-cofins           = vde-aliq-cofins-i1
                       tt-decla-import-ord.val-unit-pis              = item-mat.val-unit-pis
                       tt-decla-import-ord.val-unit-cofins           = item-mat.val-unit-cofins
                       tt-decla-import-ord.val-unit-ipi              = item.valor-ipi-beb
                       tt-decla-import-ord.log-suspens-impto-import  = vsuspensoII
                       tt-decla-import-ord.log-suspens-ipi-import    = vsuspensoIPI.

                &if '{&bf_mat_versao_ems}' >= '2.09' &then
                    ASSIGN tt-decla-import-ord.log-suspens-icms   = vsuspensoICMS
                           tt-decla-import-ord.log-suspens-pis    = vsuspensoPIS
                           tt-decla-import-ord.log-suspens-cofins = vsuspensoCOFINS.
                &else
                    ASSIGN OVERLAY(tt-decla-import-ord.cod-livre-1,1,1) = IF vsuspensoICMS   THEN '1':U ELSE '2':U
                           OVERLAY(tt-decla-import-ord.cod-livre-1,2,1) = IF vsuspensoPIS    THEN '1':U ELSE '2':U
                           OVERLAY(tt-decla-import-ord.cod-livre-1,3,1) = IF vsuspensoCOFINS THEN '1':U ELSE '2':U.
                &endif


                IF l-nt2024002 THEN DO:
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "IBSUF",  INPUT "C-CLASS-TRIB",     INPUT vcClassTribIBS-UF).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "IBSUF",  INPUT "CST",              INPUT vcCST-IBS-UF).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "IBSUF",  INPUT "COD-TRIB",         INPUT vtrib-ibs-uf).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "IBSUF",  INPUT "ALIQUOTA",         INPUT vde-aliq-ibs-uf).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "IBSUF",  INPUT "ALIQ-RED",         INPUT vde-aliq-red-ibs-uf).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "IBSUF",  INPUT "C-CLASS-TRIB-REG", INPUT vcCalssTribREG-IBS-UF).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "IBSUF",  INPUT "CST-REG",          INPUT vcCST-REG-IBS-UF).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "IBSUF",  INPUT "ALIQ-EFETIVA-REG", INPUT vdeAliqEfetivaREG-IBS-UF).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "IBSMUN", INPUT "C-CLASS-TRIB",     INPUT vcClassTribIBS-Mun).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "IBSMUN", INPUT "CST",              INPUT vcCST-IBS-Mun).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "IBSMUN", INPUT "COD-TRIB",         INPUT vtrib-ibs-mun).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "IBSMUN", INPUT "ALIQUOTA",         INPUT vde-aliq-ibs-mun).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "IBSMUN", INPUT "ALIQ-RED",         INPUT vde-aliq-red-ibs-mun).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "IBSMUN", INPUT "C-CLASS-TRIB-REG", INPUT vcCalssTribREG-IBS-Mun).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "IBSMUN", INPUT "CST-REG",          INPUT vcCST-REG-IBS-Mun).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "IBSMUN", INPUT "ALIQ-EFETIVA-REG", INPUT vdeAliqEfetivaREG-IBS-Mun).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "CBS",    INPUT "C-CLASS-TRIB",     INPUT vcClassTribCBS).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "CBS",    INPUT "CST",              INPUT vcCST-CBS).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "CBS",    INPUT "COD-TRIB",         INPUT vtrib-cbs).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "CBS",    INPUT "ALIQUOTA",         INPUT vde-aliq-cbs).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "CBS",    INPUT "ALIQ-RED",         INPUT vde-aliq-red-cbs).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "CBS",    INPUT "C-CLASS-TRIB-REG", INPUT vcCalssTribREG-CBS).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "CBS",    INPUT "CST-REG",          INPUT vcCST-REG-CBS).
                    RUN pi-GeraDeclaImportOrdTrib (INPUT "CBS",    INPUT "ALIQ-EFETIVA-REG", INPUT vdeAliqEfetivaREG-CBS).
                    
                    IF SUBSTRING(item.char-1,289,1) = "S" /* Incide IS */ THEN DO:
                        RUN pi-GeraDeclaImportOrdTrib (INPUT "IS",     INPUT "C-CLASS-TRIB",     INPUT vcClassTribIS).
                        RUN pi-GeraDeclaImportOrdTrib (INPUT "IS",     INPUT "CST",              INPUT vcCST-IS).
                        RUN pi-GeraDeclaImportOrdTrib (INPUT "IS",     INPUT "COD-TRIB",         INPUT vtrib-is).
                        RUN pi-GeraDeclaImportOrdTrib (INPUT "IS",     INPUT "ALIQUOTA",         INPUT vde-aliq-is).
                        RUN pi-GeraDeclaImportOrdTrib (INPUT "IS",     INPUT "ALIQ-ESPEC-UN",    INPUT vde-aliq-un-is).
                        RUN pi-GeraDeclaImportOrdTrib (INPUT "IS",     INPUT "QTDE-TRIBUT",      INPUT vde-qtde-trib-is).
                        RUN pi-GeraDeclaImportOrdTrib (INPUT "IS",     INPUT "UN-TRIBUT",        INPUT vc-un-trib-is).
                    END.
                END.

            END. /* IF  AVAIL  natur-oper THEN DO: */
        END. /* if not l-im0099 */
        ELSE DO:
            /* Ç pelo im0099, buscar dados informados no im0410 */
            FOR FIRST tt-decla-import-ord-aux NO-LOCK
                WHERE tt-decla-import-ord-aux.num-di-ems   = tt-decla-import-embarq.num-di-ems
                AND   tt-decla-import-ord-aux.cdd-siscomex-dts = tt-decla-import-embarq.cdd-siscomex-dts
                AND   tt-decla-import-ord-aux.num-ord      = ordens-embarque.numero-ordem
                AND   tt-decla-import-ord-aux.cod-estab    = tt-decla-import-embarq.cod-estab:

                ASSIGN tt-decla-import-ord.val-perc-reduc-icms       = tt-decla-import-ord-aux.val-perc-reduc-icms
                       tt-decla-import-ord.val-perc-reduc-ipi        = tt-decla-import-ord-aux.val-perc-reduc-ipi
                       tt-decla-import-ord.idi-tributac-impto-import = tt-decla-import-ord-aux.idi-tributac-impto-import
                       tt-decla-import-ord.idi-tributac-ipi          = tt-decla-import-ord-aux.idi-tributac-ipi
                       tt-decla-import-ord.idi-tributac-icms         = tt-decla-import-ord-aux.idi-tributac-icms
                       tt-decla-import-ord.idi-tributac-pis          = tt-decla-import-ord-aux.idi-tributac-pis
                       tt-decla-import-ord.idi-tributac-cofins       = tt-decla-import-ord-aux.idi-tributac-cofins
                       tt-decla-import-ord.val-aliq-ii               = tt-decla-import-ord-aux.val-aliq-ii
                       tt-decla-import-ord.val-aliq-ipi              = tt-decla-import-ord-aux.val-aliq-ipi
                       tt-decla-import-ord.val-aliq-icms             = tt-decla-import-ord-aux.val-aliq-icms
                       tt-decla-import-ord.val-aliq-pis              = tt-decla-import-ord-aux.val-aliq-pis
                       tt-decla-import-ord.val-aliq-cofins           = tt-decla-import-ord-aux.val-aliq-cofins
                       tt-decla-import-ord.val-unit-pis              = tt-decla-import-ord-aux.val-unit-pis
                       tt-decla-import-ord.val-unit-cofins           = tt-decla-import-ord-aux.val-unit-cofins
                       tt-decla-import-ord.val-unit-ipi              = tt-decla-import-ord-aux.val-unit-ipi
                       tt-decla-import-ord.log-suspens-impto-import  = tt-decla-import-ord-aux.log-suspens-impto-import
                       tt-decla-import-ord.log-suspens-ipi-import    = tt-decla-import-ord-aux.log-suspens-ipi-import  .

                &if '{&bf_mat_versao_ems}' >= '2.09' &then
                    ASSIGN tt-decla-import-ord.log-suspens-icms   = tt-decla-import-ord-aux.log-suspens-icms
                           tt-decla-import-ord.log-suspens-pis    = tt-decla-import-ord-aux.log-suspens-pis
                           tt-decla-import-ord.log-suspens-cofins = tt-decla-import-ord-aux.log-suspens-cofins.
                &else
                    ASSIGN OVERLAY(tt-decla-import-ord.cod-livre-1,1,1) = SUBSTRING(tt-decla-import-ord-aux.cod-livre-1,1,1)
                           OVERLAY(tt-decla-import-ord.cod-livre-1,2,1) = SUBSTRING(tt-decla-import-ord-aux.cod-livre-1,2,1)
                           OVERLAY(tt-decla-import-ord.cod-livre-1,3,1) = SUBSTRING(tt-decla-import-ord-aux.cod-livre-1,3,1).
                &endif
                IF l-nt2024002 THEN DO:
                    FOR EACH tt-decla-import-ord-trib-aux NO-LOCK
                        WHERE tt-decla-import-ord-trib-aux.num-di-ems       = tt-decla-import-ord-aux.num-di-ems
                        AND   tt-decla-import-ord-trib-aux.num-ordem        = tt-decla-import-ord-aux.num-ordem
                        AND   tt-decla-import-ord-trib-aux.num-parcela      = tt-decla-import-ord-aux.num-parcela
                        AND   tt-decla-import-ord-trib-aux.cdd-siscomex-dts = tt-decla-import-ord-aux.cdd-siscomex-dts:
                        RUN pi-GeraDeclaImportOrdTrib (INPUT tt-decla-import-ord-trib-aux.nom-trib, INPUT tt-decla-import-ord-trib-aux.cod-campo, INPUT tt-decla-import-ord-trib-aux.cod-conteudo).
                    END.
                END.
            END.
        END.
        /*-------------------------------------------------------------------------------------------------------[ Impostos ]---*/

        ASSIGN c-class-fiscal = "".

        IF VALID-HANDLE(h-boin082) THEN DO:

            RUN findCotacaoAprovada IN h-boin082 (INPUT ordens-embarque.numero-ordem, OUTPUT tt-decla-import-ord.cod-unid-med-fornec).

            IF tt-decla-import-ord.cod-unid-med-fornec = "" THEN DO:

                RUN getCharfield IN h-boin082 (INPUT "un":U,     OUTPUT tt-decla-import-ord.cod-unid-med-fornec).
                RUN getcharfield IN h-boin082 (INPUT "char-1":U, OUTPUT c-char-1).
            END.

            IF AVAIL item AND item.tipo-contr = 4 AND c-return = "" AND SUBSTRING(c-char-1,81,20) <> "" THEN
                ASSIGN c-class-fiscal = SUBSTRING(c-char-1,81,20).
            ELSE
                ASSIGN c-class-fiscal = item.class-fiscal.

            /* Sugere Fabricante e Pais da Cotaá∆o Item - IM0060 */
            RUN getcharfield IN h-boin082 (INPUT "char-2":U,        OUTPUT c-char-2).
            RUN getintfield  IN h-boin082 (INPUT "cdn-pais-orig":U, OUTPUT tt-decla-import-ord.cdn-pais-proceden).

            ASSIGN tt-decla-import-ord.cdn-fabrican      = INT(substring(c-char-2,41,20)).

            /* Sugere Fabricante do Processo Importaá∆o - IM0040 ou Fornecedor */
            IF tt-decla-import-ord.cdn-fabrican = 0
            OR (tt-decla-import-ord.cdn-fabrican = tt-decla-import-ord.cdn-fornec AND tt-decla-import-ord.cdn-fabrican <> i-cod-fabricante) THEN
                ASSIGN tt-decla-import-ord.cdn-fabrican = IF i-cod-fabricante <> 0 THEN i-cod-fabricante ELSE tt-decla-import-ord.cdn-fornec.

            /* Atualiza flag "Fornecedor Ç fabricante?" */
            IF (tt-decla-import-ord.cdn-fornec = tt-decla-import-ord.cdn-fabrican) THEN
                ASSIGN tt-decla-import-ord.log-emite-fabrican  = YES.
        END.

        IF AVAIL item THEN DO:

            FIND FIRST classif-fisc NO-LOCK WHERE classif-fisc.class-fiscal = c-class-fiscal NO-ERROR.

            IF AVAIL classif-fisc THEN DO:

                ASSIGN tt-decla-import-ord.cod-naladi-ncca        = STRING(classif-fisc.cod-naladi)
                       tt-decla-import-ord.cdn-naladi-sist-harmon = classif-fisc.cod-naladi-sh
                       tt-decla-import-ord.cod-nbm                = STRING(classif-fisc.cod-mercosul).
            END.

            FOR FIRST item-mat NO-LOCK WHERE item-mat.it-codigo = item.it-codigo:
                &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
                    ASSIGN tt-decla-import-ord.cod-tip-recip   = item-mat.cod-tip-recip
                           tt-decla-import-ord.qtd-capac-recip = item-mat.qtd-capc-recip
                           tt-decla-import-ord.cod-especif     = item-mat.dsl-especif.
                &ELSE
                    ASSIGN tt-decla-import-ord.cod-tip-recip   = SUBSTRING(item-mat.char-1,11,2)
                           tt-decla-import-ord.qtd-capac-recip = DEC(SUBSTRING(item-mat.char-1,13,8))
                           tt-decla-import-ord.cod-especif     = SUBSTRING(item-mat.char-2,24,150).
                &ENDIF
            END.
        END.

        FOR FIRST licenciam-import-oc NO-LOCK
            WHERE licenciam-import-oc.numero-ordem = ordens-embarque.numero-ordem
            AND   licenciam-import-oc.parcela      = ordens-embarque.parcela:

            ASSIGN tt-decla-import-ord.cod-licenc-import = licenciam-import-oc.licenca-import
                   tt-decla-import-ord.dat-livre-1       = licenciam-import-oc.dat-livre-1.
        END.

        IF tt-decla-import-ord.cdn-pais-proceden = 0 THEN DO:

            IF tt-decla-import-ord.log-emite-fabrican THEN
                FOR FIRST emitente NO-LOCK
                    WHERE emitente.cod-emitente = tt-decla-import-ord.cdn-fornec:

                    FOR FIRST pais NO-LOCK WHERE pais.nome-pais = emitente.pais:

                        ASSIGN tt-decla-import-ord.cdn-pais-proceden = pais.cod-pais.
                    END.
                 END.
            ELSE
                FOR FIRST emitente NO-LOCK
                    WHERE emitente.cod-emitente = tt-decla-import-ord.cdn-fabrican:

                    FOR FIRST pais NO-LOCK WHERE pais.nome-pais = emitente.pais:

                        ASSIGN tt-decla-import-ord.cdn-pais-proceden = pais.cod-pais.
                    END.
                 END.
        END.

        FIND FIRST embarque-imp NO-LOCK
             WHERE embarque-imp.cod-estabel = tt-decla-import-embarq.cod-estab
             AND   embarque-imp.embarque    = tt-decla-import-embarq.cod-embarq NO-ERROR.

        IF AVAIL embarque-imp THEN DO:

            &if '{&bf_mat_versao_ems}' >= '2.09' &then
                IF embarque-imp.idi-natur-cambial = 2 /* Sem Cobertura */ THEN
                    ASSIGN tt-decla-import-ord.idi-ind-pagto = 4. /* Sem Cobertura */
                ELSE
                    FOR FIRST pedido-compr OF ordem-compra NO-LOCK:

                        IF pedido-compr.cod-cond-pag <> 0 THEN
                            FOR FIRST cond-pagto NO-LOCK
                                WHERE cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag:

                                DO i = 1 TO 12:
                                   IF cond-pagto.prazos[i] <> 0 THEN ASSIGN i-ult-prazo   = cond-pagto.prazos[i]
                                                                            i-cod-ven-par = cond-pagto.cod-ven-par[i].
                                END.

                                IF i-ult-prazo <= 180 OR i-cod-ven-par = 2 /* Ö vista */ OR i-cod-ven-par = 3 /* antecipado */ THEN
                                    ASSIGN tt-decla-import-ord.idi-ind-pagto = 1. /* AtÇ 180 dias */
                                ELSE
                                    IF i-ult-prazo >= 181 AND i-ult-prazo <= 360 THEN
                                        ASSIGN tt-decla-import-ord.idi-ind-pagto = 2. /* De 181 atÇ 360 dias */
                                     ELSE
                                         IF i-ult-prazo >= 361 THEN
                                             ASSIGN tt-decla-import-ord.idi-ind-pagto = 3. /* Acima de 360 dias */
                            END.
                        ELSE
                            FOR FIRST cond-especif NO-LOCK
                                WHERE cond-especif.num-pedido = pedido-compr.num-pedido:

                                DO  i = 1 TO 12:
                                    IF cond-especif.data-pagto[i] <> ? THEN ASSIGN d-dt-ult-prazo = cond-especif.data-pagto[i].
                                END.

                                FOR FIRST historico-embarque NO-LOCK
                                    WHERE historico-embarque.cod-estabel = tt-decla-import-embarq.cod-estab
                                      AND historico-embarque.embarque    = tt-decla-import-embarq.cod-embarq:

                                    IF historico-embarque.dt-efetiva <> ? THEN
                                        ASSIGN d-dt-embarque = historico-embarque.dt-efetiva.
                                    ELSE
                                        ASSIGN d-dt-embarque = historico-embarque.dt-ult-previsao.
                                END.

                                IF (d-dt-ult-prazo - d-dt-embarque) <= 180 THEN
                                    ASSIGN tt-decla-import-ord.idi-ind-pagto = 1. /* AtÇ 180 dias */
                                ELSE
                                    IF (d-dt-ult-prazo - d-dt-embarque) >= 181 AND (d-dt-ult-prazo - d-dt-embarque) <= 360 THEN
                                        ASSIGN tt-decla-import-ord.idi-ind-pagto = 2. /* De 181 atÇ 360 dias */
                                    ELSE
                                        IF (d-dt-ult-prazo - d-dt-embarque) >= 361 THEN
                                            ASSIGN tt-decla-import-ord.idi-ind-pagto = 3. /* Acima de 360 dias */
                            END.
                    END.
            &ELSE
                IF embarque-imp.int-1 = 2 THEN
                    ASSIGN tt-decla-import-ord.idi-ind-pagto = 4. /* Sem Cobertura */
                ELSE
                    FOR FIRST pedido-compr OF ordem-compra NO-LOCK:
                        IF pedido-compr.cod-cond-pag <> 0 THEN
                            FOR FIRST cond-pagto NO-LOCK
                                WHERE cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag:

                                DO i = 1 TO 12:
                                   IF cond-pagto.prazos[i] <> 0 THEN ASSIGN i-ult-prazo   = cond-pagto.prazos[i]
                                                                            i-cod-ven-par = cond-pagto.cod-ven-par[i].
                                END.

                                IF i-ult-prazo <= 180 OR i-cod-ven-par = 2 /* Ö vista */ OR i-cod-ven-par = 3 /* antecipado */ THEN
                                    ASSIGN tt-decla-import-ord.idi-ind-pagto = 1. /* AtÇ 180 dias */
                                ELSE
                                    IF i-ult-prazo >= 181 AND i-ult-prazo <= 360 THEN
                                        ASSIGN tt-decla-import-ord.idi-ind-pagto = 2. /* De 181 atÇ 360 dias */
                                     ELSE
                                         IF i-ult-prazo >= 361 THEN
                                             ASSIGN tt-decla-import-ord.idi-ind-pagto = 3. /* Acima de 360 dias */
                            END.
                        ELSE
                            FOR FIRST cond-especif NO-LOCK
                                WHERE cond-especif.num-pedido = pedido-compr.num-pedido:

                                DO  i = 1 TO 12:
                                    IF cond-especif.data-pagto[i] <> ? THEN ASSIGN d-dt-ult-prazo = cond-especif.data-pagto[i].
                                END.

                                FOR FIRST historico-embarque NO-LOCK
                                    WHERE historico-embarque.cod-estabel = tt-decla-import-embarq.cod-estab
                                    AND   historico-embarque.embarque    = tt-decla-import-embarq.cod-embarq:

                                    IF  historico-embarque.dt-efetiva <> ? THEN
                                        ASSIGN d-dt-embarque = historico-embarque.dt-efetiva.
                                    ELSE
                                        ASSIGN d-dt-embarque = historico-embarque.dt-ult-previsao.
                                END.

                                IF (d-dt-ult-prazo - d-dt-embarque) <= 180 THEN
                                    ASSIGN tt-decla-import-ord.idi-ind-pagto = 1. /* AtÇ 180 dias */
                                ELSE
                                    IF (d-dt-ult-prazo - d-dt-embarque) >= 181 AND (d-dt-ult-prazo - d-dt-embarque) <= 360 THEN
                                        ASSIGN tt-decla-import-ord.idi-ind-pagto = 2. /* De 181 atÇ 360 dias */
                                    ELSE
                                        IF (d-dt-ult-prazo - d-dt-embarque) >= 361 THEN
                                            ASSIGN tt-decla-import-ord.idi-ind-pagto = 3. /* Acima de 360 dias */
                            END.
                    END.
            &ENDIF
        END. /* if  avail  embarque-imp */
    END. /* for each tt-decla-import-embarq  */

    /* volta para 'NO' a variavel que controla se a geracao Ç manual ou autom†tica */
    ASSIGN l-automatica = NO.

    IF VALID-HANDLE(h-bocx404) THEN DO:
        DELETE PROCEDURE h-bocx404.
        ASSIGN h-bocx404 = ?.
    END.

    IF VALID-HANDLE(h-boin082) THEN
        DELETE PROCEDURE h-boin082.
    ASSIGN h-boin082 = ?.

    IF VALID-HANDLE(h-boin178i) THEN
        DELETE PROCEDURE h-boin178i.
    ASSIGN h-boin178i = ?.

    IF VALID-HANDLE(h-bocx00507) THEN DO:
        DELETE PROCEDURE h-bocx00507.
        ASSIGN h-bocx00507 = ?.
    END.

    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaValorIPIUnid DBOProgram
PROCEDURE retornaValorIPIUnid :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-di-adic      AS CHARACTER                      NO-UNDO.
    DEFINE INPUT  PARAMETER p-it-codigo    LIKE ITEM.it-codigo               NO-UNDO.
    DEFINE OUTPUT PARAMETER d-val-ipi-unid LIKE item.valor-ipi-beb           NO-UNDO.

    DEFINE VARIABLE p-num-di-ems LIKE decla-import-adic.num-di-ems NO-UNDO.
    DEFINE VARIABLE p-cdd-siscomex-dts LIKE decla-import-adic.cdd-siscomex-dts NO-UNDO.
    DEFINE VARIABLE p-num-adic   LIKE decla-import-adic.num-adic   NO-UNDO.

    ASSIGN d-val-ipi-unid = 0.

    ASSIGN p-num-di-ems = INT(ENTRY(1,p-di-adic,"/":U))
           p-cdd-siscomex-dts = INT(ENTRY(2,p-di-adic,"/":U))
           p-num-adic   = INT(ENTRY(3,p-di-adic,"/":U)).

    FOR FIRST decla-import-adic NO-LOCK
        WHERE decla-import-adic.num-di-ems  = p-num-di-ems
        AND   decla-import-adic.num-adic    = p-num-adic
        AND   decla-import-adic.cdd-siscomex-dts = p-cdd-siscomex-dts:

        ASSIGN d-val-ipi-unid = decla-import-adic.val-unit-ipi.
    END.

    IF d-val-ipi-unid <= 0 THEN DO:
        FIND FIRST item NO-LOCK
             WHERE item.it-codigo = p-it-codigo NO-ERROR.
        IF AVAIL item THEN
            ASSIGN d-val-ipi-unid = item.valor-ipi-beb.
        ELSE
            ASSIGN d-val-ipi-unid = 0.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaAdicInformada DBOProgram
PROCEDURE setaAdicInformada :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-l-adic-informada AS LOGICAL NO-UNDO.

    ASSIGN l-adic-informadas = p-l-adic-informada.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-tp-nacionaliz DBOProgram
PROCEDURE pi-seta-tp-nacionaliz :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pTpNacionaliz AS INTEGER NO-UNDO.

    ASSIGN i-tp-nacionaliz = pTpNacionaliz.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByDiBreakBySeqRet DBOProgram
PROCEDURE setConstraintByDiBreakBySeqRet :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-estab-ini        LIKE decla-import.cod-estab       NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estab-fim        LIKE decla-import.cod-estab       NO-UNDO.
    DEFINE INPUT PARAMETER p-num-di-ems-ini       LIKE decla-import.num-di-ems      NO-UNDO.
    DEFINE INPUT PARAMETER p-num-di-ems-fim       LIKE decla-import.num-di-ems      NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-di-siscomex-ini  LIKE decla-import.cod-di-siscomex NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-di-siscomex-fim  LIKE decla-import.cod-di-siscomex NO-UNDO.
    DEFINE INPUT PARAMETER p-dat-di-ini           LIKE decla-import.dat-di          NO-UNDO.
    DEFINE INPUT PARAMETER p-dat-di-fim           LIKE decla-import.dat-di          NO-UNDO.
    DEFINE INPUT PARAMETER p-cdd-siscomex-ini-dts LIKE decla-import.cdd-siscomex-dts NO-UNDO.
    DEFINE INPUT PARAMETER p-cdd-siscomex-fim-dts LIKE decla-import.cdd-siscomex-dts NO-UNDO.
    DEFINE INPUT PARAMETER pTpNacionaliz          AS INTEGER NO-UNDO.

    ASSIGN c-cod-estab-ini         = p-cod-estab-ini
           c-cod-estab-fim         = p-cod-estab-fim
           d-num-di-ems-ini        = p-num-di-ems-ini
           d-num-di-ems-fim        = p-num-di-ems-fim
           c-cod-di-siscomex-ini   = p-cod-di-siscomex-ini
           c-cod-di-siscomex-fim   = p-cod-di-siscomex-fim
           d-dat-di-ini            = p-dat-di-ini
           d-dat-di-fim            = p-dat-di-fim
           d-cdd-siscomex-dts-ini  = p-cdd-siscomex-ini-dts
           d-cdd-siscomex-dts-fim  = p-cdd-siscomex-fim-dts
           i-tp-nacionaliz         = pTpNacionaliz.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByDiEMS DBOProgram
PROCEDURE setConstraintByDiEMS :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-di-ems-ini         AS INTEGER  NO-UNDO.
    DEFINE INPUT PARAMETER p-num-di-ems-fim         AS INTEGER  NO-UNDO.
    DEFINE INPUT PARAMETER p-cdd-siscomex-dts-ini   AS DECIMAL NO-UNDO.
    DEFINE INPUT PARAMETER p-cdd-siscomex-dts-fim   AS DECIMAL NO-UNDO.

    ASSIGN d-num-di-ems-ini       = p-num-di-ems-ini
           d-num-di-ems-fim       = p-num-di-ems-fim
           d-cdd-siscomex-dts-ini = p-cdd-siscomex-dts-ini
           d-cdd-siscomex-dts-fim = p-cdd-siscomex-dts-fim.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByDiEMSSeq DBOProgram
PROCEDURE setConstraintByDiEMSSeq :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-di-ems         LIKE decla-import.num-di-ems       NO-UNDO.
    DEFINE INPUT PARAMETER p-num-seq-retif      LIKE decla-import.num-seq-retif    NO-UNDO.
    DEFINE INPUT PARAMETER p-cdd-siscomex-dts   LIKE decla-import.cdd-siscomex-dts NO-UNDO.

    ASSIGN d-num-di-ems        = p-num-di-ems
           i-num-seq-retif     = p-num-seq-retif
           de-cdd-siscomex-dts = p-cdd-siscomex-dts.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByLogAtivo DBOProgram
PROCEDURE setConstraintByLogAtivo :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-log-ativo AS LOGICAL     NO-UNDO.

    ASSIGN l-log-ativo = p-log-ativo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE totalizaDespesas DBOProgram
PROCEDURE totalizaDespesas :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pNumDiEms                 LIKE {&TABLENAME}.num-di-ems                  NO-UNDO.
    DEFINE INPUT  PARAMETER pNumSeqRet                LIKE {&TABLENAME}.num-seq-retif               NO-UNDO.
    DEFINE INPUT  PARAMETER pCddSiscomexDts           LIKE {&TABLENAME}.cdd-siscomex-dts            NO-UNDO.
    DEFINE OUTPUT PARAMETER i-cdn-moed-tot-desp-nac   LIKE moeda.mo-codigo                          NO-UNDO.
    DEFINE OUTPUT PARAMETER i-cdn-moed-tot-desp-compl LIKE moeda.mo-codigo                          NO-UNDO.
    DEFINE OUTPUT PARAMETER i-cdn-moed-tot-desp-di    LIKE moeda.mo-codigo                          NO-UNDO.
    DEFINE OUTPUT PARAMETER d-tot-val-desp-compl      AS DEC FORMAT "->>,>>>,>>>,>>9.9999999999":U  NO-UNDO.
    DEFINE OUTPUT PARAMETER d-tot-val-desp-compl-me   AS DEC FORMAT "->>,>>>,>>>,>>9.9999999999":U  NO-UNDO.
    DEFINE OUTPUT PARAMETER d-tot-val-desp-di         AS DEC FORMAT "->>,>>>,>>>,>>9.9999999999":U  NO-UNDO.
    DEFINE OUTPUT PARAMETER d-tot-val-desp-di-me      AS DEC FORMAT "->>,>>>,>>>,>>9.9999999999":U  NO-UNDO.
    DEFINE OUTPUT PARAMETER d-tot-val-desp-nacion     AS DEC FORMAT "->>,>>>,>>>,>>9.9999999999":U  NO-UNDO.
    DEFINE OUTPUT PARAMETER d-tot-val-desp-nacion-me  AS DEC FORMAT "->>,>>>,>>>,>>9.9999999999":U  NO-UNDO.

    /*TOTALIZANDO DESPESAS NACIONALIZAÄ«O!!!*/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do include: method/svc/errors/inserr.i ---*/

    FIND FIRST param-imp NO-LOCK WHERE param-imp.cod-estabel = RowObject.cod-estab NO-ERROR.

    IF RowObject.cdd-siscomex-dts = 0 THEN DO: //Validaá‰es a serem realizadas somente via IM0400
        IF pType <> "DELETE":U THEN DO:

            IF NOT CAN-FIND(FIRST estabelec
                            WHERE estabelec.cod-estabel = RowObject.cod-estab) THEN DO:

                {utp/ut-liter.i "Estabelecimento" *}
                {method/svc/errors/inserr.i &ErrorNumber="2" &ErrorType="EMS" &ErrorParameters="TRIM(RETURN-VALUE)"}
            END.

            IF RowObject.cod-di-siscomex <> "" THEN DO:

                IF CAN-FIND(FIRST bf{&TABLENAME}
                            WHERE bf{&TABLENAME}.cod-di-siscomex  = RowObject.cod-di-siscomex
                            AND   bf{&TABLENAME}.num-di-ems      <> RowObject.num-di-ems) THEN DO:

                    {utp/ut-liter.i "Declaraá∆o_de_Importaá∆o/DUIMP" *}
                    ASSIGN c-lbl-traducao = TRIM(RETURN-VALUE).
                    {utp/ut-liter.i "N£mero_de_SISCOMEX" *}

                    {method/svc/errors/inserr.i &ErrorNumber="30797"
                                                &ErrorType="EMS"
                                                &ErrorParameters="c-lbl-traducao + '~~~~' + TRIM(RETURN-VALUE) + '~~~~' + '' + '~~~~' + ''"}
                END.

                IF RowObject.dat-di = ? THEN DO:

                    {utp/ut-liter.i "Declaraá∆o_Importaá∆o" *}
                    {method/svc/errors/inserr.i &ErrorNumber="1385" &ErrorType="EMS" &ErrorParameters="TRIM(RETURN-VALUE)"}
                END.
            END.

            IF pType = "create":U AND RowObject.cod-natur-operac = "" THEN DO:

                {method/svc/errors/inserr.i &ErrorNumber="52132" &ErrorType="EMS" &ErrorParameters="''"}
            END.
            ELSE DO:

                /* Declaracao de Importacao nao tem natureza de operacao quando seus embarques possuem naturezas diferentes enrte si */
                IF RowObject.cod-natur-operac <> "" AND
                NOT CAN-FIND(FIRST natur-oper
                             WHERE natur-oper.nat-operacao = RowObject.cod-natur-operac) THEN DO:

                    {utp/ut-liter.i "Natureza_Operacaá∆o" *}
                    {method/svc/errors/inserr.i &ErrorNumber="2" &ErrorType="EMS" &ErrorParameters="TRIM(RETURN-VALUE)"}
                END.
            END.

            IF RowObject.cdn-urf-entr <> 0 THEN DO:

                IF NOT CAN-FIND(FIRST unid-rf
                                WHERE unid-rf.cdn-unid-recta-feder = RowObject.cdn-urf-entr) THEN DO:

                    {utp/ut-liter.i "URF_Entrada_Pa°s" *}
                    {method/svc/errors/inserr.i &ErrorNumber="2" &ErrorType="EMS" &ErrorParameters="TRIM(RETURN-VALUE)"}
                END.
            END.

            IF RowObject.cdn-pais-proceden <> 0 THEN DO:

                IF NOT CAN-FIND(FIRST pais
                                WHERE int(pais.cod-pais-siscomex) = RowObject.cdn-pais-proceden) THEN DO:


                    {utp/ut-liter.i "Pa°s" *}
                    {method/svc/errors/inserr.i &ErrorNumber="2" &ErrorType="EMS" &ErrorParameters="TRIM(RETURN-VALUE)"}
                END.
            END.

            IF RowObject.cdn-urf-despch <> 0 THEN DO:

                IF NOT CAN-FIND(FIRST unid-rf
                                WHERE unid-rf.cdn-unid-recta-feder = RowObject.cdn-urf-despch) THEN DO:

                    {utp/ut-liter.i "URF_Despacho" *}
                    {method/svc/errors/inserr.i &ErrorNumber="2" &ErrorType="EMS" &ErrorParameters="TRIM(RETURN-VALUE)"}
                END.
            END.

            IF RowObject.cdn-transp <> 0
               AND NOT CAN-FIND(FIRST transporte
                                WHERE transporte.cod-transp = RowObject.cdn-transp) THEN DO:

                {utp/ut-liter.i "Transportador" *}
                {method/svc/errors/inserr.i &ErrorNumber="2" &ErrorType="EMS" &ErrorParameters="TRIM(RETURN-VALUE)"}
            END.

            IF RowObject.cdn-agent-carg-import <> 0
               AND NOT CAN-FIND(FIRST transporte
                                WHERE transporte.cod-transp = RowObject.cdn-agent-carg-import) THEN DO:

                {utp/ut-liter.i "Agente_de_Carga_(Transportador)" *}
                {method/svc/errors/inserr.i &ErrorNumber="2" &ErrorType="EMS" &ErrorParameters="TRIM(RETURN-VALUE)"}
            END.
        END.

        IF pType = "Create":U THEN DO:

            IF CAN-FIND (FIRST decla-import
                         WHERE decla-import.num-di-ems    = RowObject.num-di-ems
                         AND   decla-import.num-seq-retif = RowObject.num-seq-retif
                         AND   decla-import.cdd-siscomex-dts = RowObject.cdd-siscomex-dts) THEN DO:

                {utp/ut-liter.i "Declaraá∆o_Importaá∆o" *}
                {method/svc/errors/inserr.i &ErrorNumber="1" &ErrorType="EMS" &ErrorParameters="TRIM(RETURN-VALUE)"}
            END.
        END.

        IF pType = "Update":U THEN DO:

            FIND LAST bf{&TABLENAME}
                WHERE bf{&TABLENAME}.num-di-ems = RowObject.num-di-ems
                  AND bf{&TABLENAME}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts NO-LOCK NO-ERROR.

            IF AVAIL bf{&TABLENAME} AND bf{&TABLENAME}.num-seq-retif > RowObject.num-seq-retif THEN DO:

                {method/svc/errors/inserr.i &ErrorNumber="52131"
                                            &ErrorType="EMS"
                                            &ErrorParameters="STRING(decla-import.num-di-ems) + '~~~~' + STRING(decla-import.num-seq-retif)"}
            END.
        END.

        IF pType = "DELETE":U THEN DO:

            IF  CAN-FIND(FIRST decla-import-embarq
                         WHERE decla-import-embarq.num-di-ems       = RowObject.num-di-ems
                           AND decla-import-embarq.cdd-siscomex-dts = RowObject.cdd-siscomex-dts) THEN DO:

                {utp/ut-liter.i "N∆o_Ç_poss°vel_excluir_Declaraá∆o_de_Importaá∆o" *}
                ASSIGN c-lbl-traducao = TRIM(RETURN-VALUE).
                {utp/ut-liter.i "N∆o_Ç_poss°vel_excluir_Declaraá∆o_de_Importaá∆o_pois_existe_embarques_vinculados" *}

                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorParameters="c-lbl-traducao + '!' + '~~~~' + TRIM(RETURN-VALUE) + '!'"}
            END.
        END.
    END.

    IF pType <> "DELETE":U THEN DO:
        IF RowObject.idi-caract-operac = 2 THEN DO:

            FIND FIRST emitente
                 WHERE emitente.cod-emitente = RowObject.cdn-consign NO-LOCK NO-ERROR.

            IF NOT AVAIL emitente OR RowObject.cdn-consign = 0 THEN DO:

                {utp/ut-liter.i "Consignat†rio" *}
                {method/svc/errors/inserr.i &ErrorNumber="2" &ErrorType="EMS" &ErrorParameters="TRIM(RETURN-VALUE)"}
            END.
        END.

        /* Despachante */
        IF SUBSTRING(RowObject.cod-livre-1, 3, 9) <> "0":U THEN DO:

            FIND FIRST emitente
                 WHERE emitente.cod-emitente = INT(SUBSTRING(RowObject.cod-livre-1, 3, 9)) NO-LOCK NO-ERROR.

            IF NOT AVAIL emitente THEN DO:

                {utp/ut-liter.i "Despachante" *}
                {method/svc/errors/inserr.i &ErrorNumber="2" &ErrorType="EMS" &ErrorParameters="TRIM(RETURN-VALUE)"}
            END.
        END.
    END.


    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaQuebraAdicao DBOProgram
PROCEDURE verificaQuebraAdicao :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-moeda            LIKE moeda.mo-codigo             NO-UNDO.
    DEFINE VARIABLE l-log-necessita-li LIKE item.log-necessita-li       NO-UNDO.
    DEFINE VARIABLE i-cdn-fabrican     LIKE processo-imp.cod-fabricante NO-UNDO.
    DEFINE VARIABLE l-dif-trib-novo    AS LOGICAL    INITIAL NO         NO-UNDO.

    DEFINE BUFFER bf-tt-decla-import-ord FOR tt-decla-import-ord.

    FOR FIRST param-imp
        WHERE param-imp.cod-estabel = tt-decla-import-ord.cod-estab NO-LOCK: END.

    FOR FIRST item NO-LOCK
        WHERE item.it-codigo = tt-decla-import-ord.cod-item: END.

    FIND FIRST ordens-embarque
         WHERE ordens-embarque.embarque     = tt-decla-import-ord.cod-embarq
           AND ordens-embarque.cod-estabel  = tt-decla-import-ord.cod-estab
           AND ordens-embarque.numero-ordem = tt-decla-import-ord.num-ordem
           AND ordens-embarque.parcela      = tt-decla-import-ord.num-parcela NO-LOCK NO-ERROR.

    FIND FIRST processo-imp
         WHERE processo-imp.cod-estabel = tt-decla-import-ord.cod-estab
           AND processo-imp.nr-proc-imp = ordens-embarque.nr-proc-imp NO-LOCK NO-ERROR.

    IF AVAIL processo-imp THEN DO:

       ASSIGN i-cdn-fabrican = processo-imp.cod-fabricante.

       IF SUBSTRING(param-imp.char-1,167,1) = "S":U THEN
          ASSIGN l-log-necessita-li = YES.
       ELSE
          ASSIGN l-log-necessita-li = item.log-necessita-li.
    END.

    FOR FIRST embarque-imp NO-LOCK
        WHERE embarque-imp.cod-estabel = tt-decla-import-ord.cod-estab
        AND   embarque-imp.embarque    = tt-decla-import-ord.cod-embarq : END.

    IF NOT VALID-HANDLE(h-boin082) THEN
        RUN inbo/boin082.p  PERSISTENT SET h-boin082.

    ASSIGN c-return = ''.
    RUN findCotacaoAprovada IN h-boin082 (INPUT tt-decla-import-ord.num-ordem, OUTPUT c-return).

    IF c-return = "" THEN DO:
        RUN getIntfield  IN h-boin082 (INPUT "mo-codigo":U, OUTPUT i-moeda).
        RUN getCharField IN h-boin082 (INPUT "char-1":U,    OUTPUT c-char-1).
    END.

    IF AVAIL item AND item.tipo-contr = 4 AND c-return = "" AND SUBSTRING(c-char-1,81,20) <> "" THEN
        ASSIGN c-class-fiscal = SUBSTRING(c-char-1,81,20).
    ELSE
        ASSIGN c-class-fiscal = item.class-fiscal.

    if l-nt2024002 then do:
        FOR FIRST tt-decla-import-adic NO-LOCK
             WHERE tt-decla-import-adic.cod-classif-fisc            = c-class-fiscal
             AND   tt-decla-import-adic.cdn-classif-fisc-ex         = INT(item.dec-1)
             AND   tt-decla-import-adic.cdn-naladi-sist-harmon      = tt-decla-import-ord.cdn-naladi-sist-harmon
             AND   tt-decla-import-adic.cod-naladi-ncca             = tt-decla-import-ord.cod-naladi-ncca
             AND   tt-decla-import-adic.cod-nbm                     = tt-decla-import-ord.cod-nbm
             AND   tt-decla-import-adic.cod-licenc-import           = tt-decla-import-ord.cod-licenc-import
             AND   tt-decla-import-adic.cod-incoterm                = embarque-imp.cod-incoterm
             AND   tt-decla-import-adic.cdn-fornec                  = tt-decla-import-ord.cdn-fornec
             AND   (tt-decla-import-adic.cdn-fabrican               = tt-decla-import-ord.cdn-fabrican)
             AND   tt-decla-import-adic.cod-aladi                   = tt-decla-import-ord.cod-aladi
             AND   tt-decla-import-adic.cdn-moeda                   = i-moeda
             AND   tt-decla-import-adic.log-nec-licenc              = l-log-necessita-li
             AND
             &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN
                 tt-decla-import-adic.idi-natur-cambial             = embarque-imp.idi-natur-cambial
             &ELSE
                 tt-decla-import-adic.idi-natur-cambial             = embarque-imp.int-1
             &ENDIF
             AND   tt-decla-import-adic.idi-metod-val               = tt-decla-import-ord.idi-metod-val
             AND   tt-decla-import-adic.idi-tributac-icms           = tt-decla-import-ord.idi-tributac-icms
             AND   tt-decla-import-adic.idi-tributac-ipi            = tt-decla-import-ord.idi-tributac-ipi
             AND   tt-decla-import-adic.idi-tributac-pis            = tt-decla-import-ord.idi-tributac-pis
             AND   tt-decla-import-adic.idi-tributac-cofins         = tt-decla-import-ord.idi-tributac-cofins
             AND   tt-decla-import-adic.idi-tributac-impto-import   = tt-decla-import-ord.idi-tributac-impto-import

            &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN
                AND   tt-decla-import-adic.log-suspens-icms        = tt-decla-import-ord.log-suspens-icms
                AND   tt-decla-import-adic.log-suspens-pis         = tt-decla-import-ord.log-suspens-pis
                AND   tt-decla-import-adic.log-suspens-cofins      = tt-decla-import-ord.log-suspens-cofins
            &ELSE
                AND   SUBSTRING(tt-decla-import-adic.cod-livre-1,1,1) = SUBSTRING(tt-decla-import-ord.cod-livre-1,1,1)
                AND   SUBSTRING(tt-decla-import-adic.cod-livre-1,2,1) = SUBSTRING(tt-decla-import-ord.cod-livre-1,2,1)
                AND   SUBSTRING(tt-decla-import-adic.cod-livre-1,3,1) = SUBSTRING(tt-decla-import-ord.cod-livre-1,3,1)
            &ENDIF

            AND   tt-decla-import-adic.val-aliq-cofins             = tt-decla-import-ord.val-aliq-cofins
            AND   tt-decla-import-adic.val-aliq-icms               = tt-decla-import-ord.val-aliq-icms
            AND   tt-decla-import-adic.val-aliq-ii                 = tt-decla-import-ord.val-aliq-ii
            AND   tt-decla-import-adic.val-aliq-ipi                = tt-decla-import-ord.val-aliq-ipi
            AND   tt-decla-import-adic.val-aliq-pis                = tt-decla-import-ord.val-aliq-pis
            AND   tt-decla-import-adic.val-perc-reduc-cofins       = tt-decla-import-ord.val-perc-reduc-cofins
            AND   tt-decla-import-adic.val-perc-reduc-icms         = tt-decla-import-ord.val-perc-reduc-icms
            AND   tt-decla-import-adic.val-perc-reduc-impto-import = tt-decla-import-ord.val-perc-reduc-impto-import
            AND   tt-decla-import-adic.val-perc-reduc-ipi          = tt-decla-import-ord.val-perc-reduc-ipi
            AND   tt-decla-import-adic.val-perc-reduc-pis          = tt-decla-import-ord.val-perc-reduc-pis
            AND   tt-decla-import-adic.log-suspens-impto-import    = tt-decla-import-ord.log-suspens-impto-import
            AND   tt-decla-import-adic.log-suspens-ipi-import      = tt-decla-import-ord.log-suspens-ipi-import
            AND   tt-decla-import-adic.qtd-capac-recip             = tt-decla-import-ord.qtd-capac-recip
            AND   tt-decla-import-adic.val-unit-pis                = tt-decla-import-ord.val-unit-pis
            AND   tt-decla-import-adic.val-unit-cofins             = tt-decla-import-ord.val-unit-cofins
            AND   tt-decla-import-adic.val-unit-ipi                = tt-decla-import-ord.val-unit-ipi:

            FOR EACH decla-import-ord-trib
                WHERE decla-import-ord-trib.num-di-ems       = tt-decla-import-ord.num-di-ems
                AND   decla-import-ord-trib.cdd-siscomex-dts = tt-decla-import-ord.cdd-siscomex-dts
                AND   decla-import-ord-trib.num-ordem        = tt-decla-import-ord.num-ordem
                AND   decla-import-ord-trib.num-parcela      = tt-decla-import-ord.num-parcela NO-LOCK:
                FIND FIRST tt-decla-import-adic-trib
                    WHERE tt-decla-import-adic-trib.num-di-ems       = decla-import-ord-trib.num-di-ems
                    AND   tt-decla-import-adic-trib.cdd-siscomex-dts = decla-import-ord-trib.cdd-siscomex-dts
                    AND   tt-decla-import-adic-trib.nom-trib         = decla-import-ord-trib.nom-trib
                    AND   tt-decla-import-adic-trib.cod-campo        = decla-import-ord-trib.cod-campo
                    AND   tt-decla-import-adic-trib.cod-conteudo     = decla-import-ord-trib.cod-conteudo NO-LOCK NO-ERROR.
                IF  NOT AVAIL tt-decla-import-adic-trib THEN LEAVE.
            END.
        END.
        IF AVAIL tt-decla-import-adic AND AVAIL tt-decla-import-adic-trib THEN DO:

            /* quebra do Pais. como n∆o h† o campo cdn-pais-proceden na decla-import-adic, a saida foi fazer esta busca. */
            FIND FIRST tt-decla-import-ord-aux NO-LOCK
                 WHERE tt-decla-import-ord-aux.num-adic = tt-decla-import-adic.num-adic NO-ERROR.
            IF AVAIL tt-decla-import-ord-aux THEN DO:

                IF CAN-FIND(FIRST tt-decla-import-ord-aux NO-LOCK
                            WHERE tt-decla-import-ord-aux.cdn-pais-proceden = tt-decla-import-ord.cdn-pais-proceden) THEN DO:

                    RUN criaItemAdicao (INPUT tt-decla-import-adic.num-adic).
                END.
                ELSE DO:
                    RUN criaAdicao(INPUT TABLE tt-decla-import-ord, INPUT 0).
                END.
            END.
            ELSE DO:
                RUN criaItemAdicao (INPUT tt-decla-import-adic.num-adic).
            END.
        END.
        ELSE DO:
            RUN criaAdicao(INPUT TABLE tt-decla-import-ord, INPUT 0).
        END.
    END.
    ELSE DO:
        FOR FIRST tt-decla-import-adic
             WHERE tt-decla-import-adic.cod-classif-fisc            = c-class-fiscal
             AND   tt-decla-import-adic.cdn-classif-fisc-ex         = INT(item.dec-1)
             AND   tt-decla-import-adic.cdn-naladi-sist-harmon      = tt-decla-import-ord.cdn-naladi-sist-harmon
             AND   tt-decla-import-adic.cod-naladi-ncca             = tt-decla-import-ord.cod-naladi-ncca
             AND   tt-decla-import-adic.cod-nbm                     = tt-decla-import-ord.cod-nbm
             AND   tt-decla-import-adic.cod-licenc-import           = tt-decla-import-ord.cod-licenc-import
             AND   tt-decla-import-adic.cod-incoterm                = embarque-imp.cod-incoterm
             AND   tt-decla-import-adic.cdn-fornec                  = tt-decla-import-ord.cdn-fornec
             AND   (tt-decla-import-adic.cdn-fabrican               = tt-decla-import-ord.cdn-fabrican)
             AND   tt-decla-import-adic.cod-aladi                   = tt-decla-import-ord.cod-aladi
             AND   tt-decla-import-adic.cdn-moeda                   = i-moeda
             AND   tt-decla-import-adic.log-nec-licenc              = l-log-necessita-li
             AND
             &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN
                 tt-decla-import-adic.idi-natur-cambial             = embarque-imp.idi-natur-cambial
             &ELSE
                 tt-decla-import-adic.idi-natur-cambial             = embarque-imp.int-1
             &ENDIF
             AND   tt-decla-import-adic.idi-metod-val               = tt-decla-import-ord.idi-metod-val
             AND   tt-decla-import-adic.idi-tributac-icms           = tt-decla-import-ord.idi-tributac-icms
             AND   tt-decla-import-adic.idi-tributac-ipi            = tt-decla-import-ord.idi-tributac-ipi
             AND   tt-decla-import-adic.idi-tributac-pis            = tt-decla-import-ord.idi-tributac-pis
             AND   tt-decla-import-adic.idi-tributac-cofins         = tt-decla-import-ord.idi-tributac-cofins
             AND   tt-decla-import-adic.idi-tributac-impto-import   = tt-decla-import-ord.idi-tributac-impto-import

            &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN
                AND   tt-decla-import-adic.log-suspens-icms        = tt-decla-import-ord.log-suspens-icms
                AND   tt-decla-import-adic.log-suspens-pis         = tt-decla-import-ord.log-suspens-pis
                AND   tt-decla-import-adic.log-suspens-cofins      = tt-decla-import-ord.log-suspens-cofins
            &ELSE
                AND   SUBSTRING(tt-decla-import-adic.cod-livre-1,1,1) = SUBSTRING(tt-decla-import-ord.cod-livre-1,1,1)
                AND   SUBSTRING(tt-decla-import-adic.cod-livre-1,2,1) = SUBSTRING(tt-decla-import-ord.cod-livre-1,2,1)
                AND   SUBSTRING(tt-decla-import-adic.cod-livre-1,3,1) = SUBSTRING(tt-decla-import-ord.cod-livre-1,3,1)
            &ENDIF

            AND   tt-decla-import-adic.val-aliq-cofins             = tt-decla-import-ord.val-aliq-cofins
            AND   tt-decla-import-adic.val-aliq-icms               = tt-decla-import-ord.val-aliq-icms
            AND   tt-decla-import-adic.val-aliq-ii                 = tt-decla-import-ord.val-aliq-ii
            AND   tt-decla-import-adic.val-aliq-ipi                = tt-decla-import-ord.val-aliq-ipi
            AND   tt-decla-import-adic.val-aliq-pis                = tt-decla-import-ord.val-aliq-pis
            AND   tt-decla-import-adic.val-perc-reduc-cofins       = tt-decla-import-ord.val-perc-reduc-cofins
            AND   tt-decla-import-adic.val-perc-reduc-icms         = tt-decla-import-ord.val-perc-reduc-icms
            AND   tt-decla-import-adic.val-perc-reduc-impto-import = tt-decla-import-ord.val-perc-reduc-impto-import
            AND   tt-decla-import-adic.val-perc-reduc-ipi          = tt-decla-import-ord.val-perc-reduc-ipi
            AND   tt-decla-import-adic.val-perc-reduc-pis          = tt-decla-import-ord.val-perc-reduc-pis
            AND   tt-decla-import-adic.log-suspens-impto-import    = tt-decla-import-ord.log-suspens-impto-import
            AND   tt-decla-import-adic.log-suspens-ipi-import      = tt-decla-import-ord.log-suspens-ipi-import
            AND   tt-decla-import-adic.qtd-capac-recip             = tt-decla-import-ord.qtd-capac-recip
            AND   tt-decla-import-adic.val-unit-pis                = tt-decla-import-ord.val-unit-pis
            AND   tt-decla-import-adic.val-unit-cofins             = tt-decla-import-ord.val-unit-cofins
            AND   tt-decla-import-adic.val-unit-ipi                = tt-decla-import-ord.val-unit-ipi NO-LOCK:
        END.
        IF AVAIL tt-decla-import-adic THEN DO:

            /* quebra do Pais. como n∆o h† o campo cdn-pais-proceden na decla-import-adic, a saida foi fazer esta busca. */
            FIND FIRST tt-decla-import-ord-aux
                 WHERE tt-decla-import-ord-aux.num-adic = tt-decla-import-adic.num-adic NO-ERROR.

            IF AVAIL tt-decla-import-ord-aux THEN DO:

                IF CAN-FIND(FIRST tt-decla-import-ord-aux
                            WHERE tt-decla-import-ord-aux.cdn-pais-proceden = tt-decla-import-ord.cdn-pais-proceden) THEN DO:

                    RUN criaItemAdicao (INPUT tt-decla-import-adic.num-adic).
                END.
                ELSE DO:
                    RUN criaAdicao(INPUT TABLE tt-decla-import-ord, INPUT 0).
                END.
            END.
            ELSE DO:

                RUN criaItemAdicao (INPUT tt-decla-import-adic.num-adic).
            END.
        END.
        ELSE DO:

            RUN criaAdicao(INPUT TABLE tt-decla-import-ord, INPUT 0).
        END.
    END.
    IF VALID-HANDLE(h-boin082) THEN
        DELETE PROCEDURE h-boin082.
    ASSIGN h-boin082 = ?.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-CriaDeclaImportOrdTrib DBOProgram
PROCEDURE pi-CriaDeclaImportOrdTrib :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-decla-import-ord-trib.

    IF NOT VALID-HANDLE(h-bocx00507) THEN RUN cxbo/bocx00507.p PERSISTENT SET h-bocx00507.

    FOR EACH tt-decla-import-ord-trib NO-LOCK:

        empty temp-table tt-decla-import-ord-trib-aux.
        create tt-decla-import-ord-trib-aux.
        buffer-copy tt-decla-import-ord-trib to tt-decla-import-ord-trib-aux.

        RUN openQueryStatic  IN h-bocx00507 (INPUT "Main":U) no-error.
        RUN emptyRowErrors   IN h-bocx00507.
        RUN emptyRowObject   IN h-bocx00507.
        RUN goToKey          IN h-bocx00507 (INPUT tt-decla-import-ord-trib.num-di-ems,
                                             INPUT tt-decla-import-ord-trib.num-ordem,
                                             INPUT tt-decla-import-ord-trib.num-parcela,
                                             INPUT tt-decla-import-ord-trib.cdd-siscomex-dts,
                                             INPUT tt-decla-import-ord-trib.nom-trib,
                                             INPUT tt-decla-import-ord-trib.cod-campo).

        IF  RETURN-VALUE = "NOK":U THEN DO:
            RUN setRecord    IN h-bocx00507 (INPUT TABLE tt-decla-import-ord-trib-aux).
            RUN createRecord IN h-bocx00507.
        END.
        ELSE DO:
            RUN setRecord    IN h-bocx00507 (INPUT TABLE tt-decla-import-ord-trib-aux).
            RUN updateRecord IN h-bocx00507.
        END.
        DELETE tt-decla-import-ord-trib.
    END.

    IF VALID-HANDLE(h-bocx00507) THEN DO:
        DELETE PROCEDURE h-bocx00507.
        ASSIGN h-bocx00507 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-BuscacClassTribItem DBOProgram
PROCEDURE pi-BuscacClassTribItem :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-num-di-ems           AS INTEGER  NO-UNDO.
    DEFINE INPUT  PARAMETER p-num-adic             AS INTEGER  NO-UNDO.
    DEFINE INPUT  PARAMETER p-cdd-siscomex-dts     AS DECIMAL  NO-UNDO.
    DEFINE output PARAMETER p-cClassTrib           AS char     NO-UNDO.

    for first tt-decla-import-adic-trib no-lock
        WHERE tt-decla-import-adic-trib.num-di-ems       = p-num-di-ems
        AND   tt-decla-import-adic-trib.num-adic         = p-num-adic
        AND   tt-decla-import-adic-trib.cdd-siscomex-dts = p-cdd-siscomex-dts
        AND   tt-decla-import-adic-trib.nom-trib         = "CBS":U
        AND   tt-decla-import-adic-trib.cod-campo        = "C-CLASS-TRIB":U:
        assign p-cClassTrib = tt-decla-import-adic-trib.cod-conteudo.
   end.

   IF  p-cClassTrib = "" THEN
       for first tt-decla-import-adic-trib no-lock
           WHERE tt-decla-import-adic-trib.num-di-ems       = p-num-di-ems
           AND   tt-decla-import-adic-trib.num-adic         = p-num-adic
           AND   tt-decla-import-adic-trib.cdd-siscomex-dts = p-cdd-siscomex-dts
           AND   tt-decla-import-adic-trib.nom-trib         = "IBSUF":U
           AND   tt-decla-import-adic-trib.cod-campo        = "C-CLASS-TRIB":U:
           assign p-cClassTrib = tt-decla-import-adic-trib.cod-conteudo.
       end.

    IF  p-cClassTrib = "" THEN
        for first tt-decla-import-adic-trib no-lock
            WHERE tt-decla-import-adic-trib.num-di-ems       = p-num-di-ems
            AND   tt-decla-import-adic-trib.num-adic         = p-num-adic
            AND   tt-decla-import-adic-trib.cdd-siscomex-dts = p-cdd-siscomex-dts
            AND   tt-decla-import-adic-trib.nom-trib         = "IBSMUN":U
            AND   tt-decla-import-adic-trib.cod-campo        = "C-CLASS-TRIB":U:
            assign p-cClassTrib = tt-decla-import-adic-trib.cod-conteudo.
       end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnBuscaMoeda DBOProgram
FUNCTION fnBuscaMoeda RETURNS CHARACTER
  ( i-moeda AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c-moeda AS CHARACTER FORMAT "X(30)":U NO-UNDO.

  FIND FIRST moeda NO-LOCK
       WHERE moeda.mo-codigo = i-moeda NO-ERROR.

  IF AVAIL moeda THEN
      ASSIGN c-moeda = STRING(i-moeda) + " - ":U + moeda.descricao.
  ELSE
      ASSIGN c-moeda = STRING(i-moeda).


  RETURN c-moeda.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-monta-local-consumo DBOProgram
/* Local de Consumo (UF + IBGE) reutilizavel */
{imp/impLocalConsumo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
