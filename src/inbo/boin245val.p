&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOFunction 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN245VAL 2.00.00.116 } /*** "010016" 10/09/2026 15:25:12 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin245val MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : dbofun.p
    Purpose    : O DBO Function (Datasul Business Objects) ‚ um programa 
                 PROGRESS que cont‚m a l¢gica de neg¢cio.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN245VAL
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName  natur-oper
&GLOBAL-DEFINE TableLabel Natureza Opera‡Æo 

{utp/ut-glob.i}

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_dialet_corren AS CHARACTER NO-UNDO.

{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}

&if defined (bf_dis_versao_ems) &then
&else
    &GLOBAL-DEFINE bf_dis_versao_ems 2.00
&endif

&IF '{&bf_dis_versao_ems}' >= '2.04' 
AND '{&bf_dis_versao_ems}' < '2.08' &THEN
    &GLOBAL-DEFINE log-icms-substto-antecip SUBSTRING(RowObject.char-1,147,1) = "1"
&ENDIF

&IF '{&bf_dis_versao_ems}' >= '2.08' &THEN
    &GLOBAL-DEFINE log-icms-substto-antecip RowObject.log-icms-substto-antecip
&ENDIF 

{bhp/bh9999.i1}

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/

{inbo/boin245.i RowObject}

def buffer b-natur-oper  for natur-oper.
def buffer b2-natur-oper for natur-oper.

def var pType              as char no-undo.
def var c-label-natur-oper as char no-undo.
DEF VAR c-trad-nft         AS CHAR NO-UNDO.
DEF VAR c-trad-nfs-nfe     AS CHAR NO-UNDO.
DEF VAR c-liter            AS CHAR NO-UNDO.

DEFINE VARIABLE c-especie-20 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-especie-21 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-especie-22 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-especie-23 AS CHARACTER   NO-UNDO.

define temp-table RowErrorsFrotas no-undo
    field ErrorSequence    as integer
    field ErrorNumber      as integer
    field ErrorDescription as character
    field ErrorParameters  as character
    field ErrorType        as character
    field ErrorHelp        as character
    field ErrorSubType     as character.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOFunction
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOFunction
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOFunction ASSIGN
         HEIGHT             = 14.75
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOFunction 
/* ************************* Included-Libraries *********************** */

{method/dbofun.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOFunction 


/* ***************************  Main Block  *************************** */

find param-global NO-LOCK NO-ERROR.

{utp/ut-liter.i Natureza_de_Opera‡Æo MFT}
assign c-label-natur-oper = return-value.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateBrasil DBOFunction 
PROCEDURE validateBrasil :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF RowObject.cd-situacao = 00 
    OR RowObject.cd-situacao = 05
    OR RowObject.cd-situacao = 12 
    OR RowObject.cd-situacao = 19 
    OR RowObject.cd-situacao = 23 
    OR (    RowObject.cd-situacao > 29
        AND RowObject.cd-situacao <> 87
        AND RowObject.cd-situacao <> 88 
        AND RowObject.cd-situacao <> 89) THEN
        {method/svc/errors/inserr.i
                &ErrorNumber="15962"
                &ErrorType="EMS"
                &ErrorParameters="''"}

    if  RowObject.tipo = 3 then do:
        if  RowObject.nat-vinculada <> " " and
            RowObject.nat-vinculada <> ? then do: 
            if  substr(RowObject.nat-operacao,1,1) <> substr(RowObject.nat-vinculada,1,1) or
                RowObject.nat-operacao = RowObject.nat-vinculada then
                {method/svc/errors/inserr.i
                        &ErrorNumber="4676"
                        &ErrorType="EMS"
                        &ErrorParameters="''"}

            find b2-natur-oper where
                 b2-natur-oper.nat-operacao = RowObject.nat-vinculada no-lock no-error.
            if  not avail b2-natur-oper then
                /* Inicio -- Projeto Internacional */
                DO:
                DEFINE VARIABLE c-lbl-liter-natureza-de-operacao-vinculada AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Natureza_de_Opera‡Æo_Vinculada" *}
                ASSIGN c-lbl-liter-natureza-de-operacao-vinculada = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                        &ErrorNumber="8193"
                        &ErrorType="EMS"
                        &ErrorParameters="c-lbl-liter-natureza-de-operacao-vinculada"}
                END. 
            else
                if  b2-natur-oper.tipo <> 2 then
                    /* Inicio -- Projeto Internacional */
                    DO:
                    DEFINE VARIABLE c-lbl-liter-natureza-de-operacao-vinculada-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Natureza_de_Opera‡Æo_Vinculada" *}
                    ASSIGN c-lbl-liter-natureza-de-operacao-vinculada-2 = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                            &ErrorNumber="4676"
                            &ErrorType="EMS"
                            &ErrorParameters="c-lbl-liter-natureza-de-operacao-vinculada-2"}
                    END. 
        end.
    end.

    if  RowObject.tipo <> 1 /* Entrada */ and
        RowObject.cd-trib-icm = 5 /* Diferido */ then
        {method/svc/errors/inserr.i
                &ErrorNumber="18587"
                &ErrorType="EMS"
                &ErrorParameters="''"}

    if  RowObject.cd-vinc-ipi <> "" and
        RowObject.cd-vinc-ipi <> ?  and
        not can-find (cod-vin-ipi where
                      cod-vin-ipi.cd-vin-ipi = RowObject.cd-vinc-ipi) then
        /* Inicio -- Projeto Internacional */
        DO:
        DEFINE VARIABLE c-lbl-liter-codigo-vinculacao-ipi AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "C¢digo_Vincula‡Æo_IPI" *}
        ASSIGN c-lbl-liter-codigo-vinculacao-ipi = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                &ErrorNumber="56"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-codigo-vinculacao-ipi"}
        END. 

    if  not can-do("A,B,C", RowObject.tp-base-icm) then
        /* Inicio -- Projeto Internacional */
        DO:
        DEFINE VARIABLE c-lbl-liter-tipo-base-icms AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Tipo_Base_ICMS" *}
        ASSIGN c-lbl-liter-tipo-base-icms = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-a-b-ou-c AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "A,_B_ou_C" *}
        ASSIGN c-lbl-liter-a-b-ou-c = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                &ErrorNumber="18733"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-tipo-base-icms + '~~~~' + c-lbl-liter-a-b-ou-c"}
        END. 

    RUN utp/ut-liter.p (INPUT TRIM({ininc/i03in218.i 04 20}), INPUT "*", INPUT "").
    ASSIGN c-especie-20 = trim(RETURN-VALUE).

    if  substr(RowObject.char-2,88,5) = "1    " and
        RowObject.especie-doc <> c-especie-20 then
        {method/svc/errors/inserr.i
                &ErrorNumber="25844"
                &ErrorType="EMS"
                &ErrorParameters="''"}

    &if defined (bf_mat_oper_triangular) &then
    
        if  RowObject.log-oper-triang
            and (   RowObject.nat-vinculada = "":U
                 or RowObject.nat-vinculada = ?) then
            {method/svc/errors/inserr.i &ErrorNumber     = "26736"
                                        &ErrorType       = "EMS"
                                        &ErrorParameters = "''"}

        if  RowObject.log-oper-triang 
        and not RowObject.terceiros then do:

            find b2-natur-oper 
                 where b2-natur-oper.nat-operacao = RowObject.nat-vinculada no-lock no-error.

            if  not avail b2-natur-oper then do:
                {utp/ut-liter.i Natureza_de_Opera‡Æo_Vinculada MFT}
                {method/svc/errors/inserr.i
                        &ErrorNumber="56"
                        &ErrorType="EMS"
                        &ErrorParameters="return-value"}
            end.
            else do:
                if  RowObject.tipo = 1 /* Entrada */ 
                and (    not b2-natur-oper.terceiros
                     or  b2-natur-oper.tipo = 1
                     or  (    b2-natur-oper.tp-oper-terc <> 1
                          and b2-natur-oper.tp-oper-terc <> 3)) then do:

                    {utp/ut-liter.i Natureza_de_Opera‡Æo_de_Entrega MFT}
                    {method/svc/errors/inserr.i
                            &ErrorNumber="19079"
                            &ErrorType="EMS"
                            &ErrorParameters="return-value"}
                end.

                if  RowObject.tipo = 2 /* Sa¡da */ 
                and b2-natur-oper.terceiros then do:
                    {method/svc/errors/inserr.i
                            &ErrorNumber="19491"
                            &ErrorType="EMS"
                            &ErrorParameters=" "}
                end.
            end.
        end.
    &endif
    
    IF  RowObject.tipo = 2  
    AND RowObject.subs-trib 
    AND {&log-icms-substto-antecip} then do:
        /* alerta sobre c lculo de ICMS ST com baixa do saldo do ICMS STA */
        {method/svc/errors/inserr.i
                &ErrorNumber="56430"
                &ErrorType="EMS"
                &ErrorParameters="''"}
    end.      

    /* Devol/Remes Garantia ICMS ST Contrib. Substiu¡do */
    IF  RowObject.tipo = 2
    AND TRIM(SUBSTRING(RowObject.char-1,163,1)) = "S" 
    AND RowObject.especie-doc <> "NFD"
    AND RowObject.terceiros    = NO  THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber     = "57335"
                                    &ErrorType       = "EMS"
                                    &ErrorParameters = "''"}
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCreateUpdate DBOFunction 
PROCEDURE validateCreateUpdate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param table for RowObject.
    def input  param p-transacao as char.
    def output param table for RowErrors.

    assign pType = p-transacao.

    find first RowObject no-error.
    if  not avail RowObject then
        return "NOK":U.

    if  pType = "Create":U and
        (RowObject.nat-operacao = " " or
         substr(RowObject.nat-operacao,1,1) = "0") then
        {method/svc/errors/inserr.i
                &ErrorNumber="158"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper"}

    if  pType = "Create":U and
        can-find(natur-oper where
                 natur-oper.nat-operacao = RowObject.nat-operacao) then
        {method/svc/errors/inserr.i
                &ErrorNumber="8"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper"}

    &IF "{&mgadm_dbtype}" = "progress" &THEN
    if pType = "Create":U and 
       substr(RowObject.char-2,104,1) = "1" and
       RowObject.ind-it-sub-dif       = yes then do:
           {method/svc/errors/inserr.i
                    &ErrorNumber="26242"
                    &ErrorType="EMS"
                    &ErrorParameters="return-value"}
            return "NOK":U.
     end.
     &ENDIF

    if  pType = "Update":U then do:
        find b-natur-oper where
             b-natur-oper.nat-operacao = RowObject.nat-operacao no-lock no-error.
        if  not avail b-natur-oper then do:
            {method/svc/errors/inserr.i
                    &ErrorNumber="56"
                    &ErrorType="EMS"
                    &ErrorParameters="c-label-natur-oper"}
            return "NOK":U.
        end.

        &IF "{&mgadm_dbtype}" = "progress" &THEN
        if substr(RowObject.char-2,104,1) = "1" and
           RowObject.ind-it-sub-dif       = yes then do:
           {method/svc/errors/inserr.i
                    &ErrorNumber="26242"
                    &ErrorType="EMS"
                    &ErrorParameters="return-value"}
            return "NOK":U.

        end. 
        &ENDIF

        if  b-natur-oper.tipo <> RowObject.tipo and
            (can-find (first ped-venda
                       where ped-venda.nat-operacao = RowObject.nat-operacao)    or
             can-find (first ped-item
                       where ped-item.nat-operacao = RowObject.nat-operacao)     or
             can-find (first nota-fiscal
                       where nota-fiscal.nat-operacao = RowObject.nat-operacao)  or
             can-find (first it-nota-fisc
                       where it-nota-fisc.nat-operacao = RowObject.nat-operacao)) then do:
            {utp/ut-liter.i Tipo_de_Natureza_de_Opera‡Æo MFT}
            {method/svc/errors/inserr.i
                    &ErrorNumber="25643"
                    &ErrorType="EMS"
                    &ErrorParameters="return-value"}
        end.
        if  b-natur-oper.ind-entfut <> RowObject.ind-entfut and
            (can-find (first ped-venda
                       where ped-venda.nat-operacao = RowObject.nat-operacao
                         and (ped-venda.cod-sit-ped  = 1
                           or ped-venda.cod-sit-ped  = 2)) or
             can-find (first nota-fiscal
                       where nota-fiscal.nat-operacao = RowObject.nat-operacao
                         AND nota-fiscal.dt-cancela = ? 
                         and (nota-fiscal.dt-confirma = ?
                           or nota-fiscal.dt-at-ofest = ?))) then do:
            {utp/ut-liter.i Tipo_de_Opera‡Æo_de_Entrega_Futura MFT}
            {method/svc/errors/inserr.i
                    &ErrorNumber="25643"
                    &ErrorType="EMS"
                    &ErrorParameters="return-value"}
        end.
    end.


    CASE i-pais-impto-usuario:
        WHEN 1 /* Brasil */ THEN DO:
            /*altera‡Æo: ‚ necess rio traduzir o conte£do em outras l¡nguas e a include nÆo faz*/
            IF v_cod_dialet_corren = "pt":U THEN DO:
                 ASSIGN c-especie-20 = "NFD":U
                        c-especie-22 = "NFS":U
                        c-especie-23 = "NFT":U.
            END.
            IF v_cod_dialet_corren = "es":U THEN DO:
                ASSIGN c-especie-20 = "FTD":U
                       c-especie-22 = "FTS":U
                       c-especie-23 = "FTT":U.
            END.
            IF v_cod_dialet_corren = "en":U THEN DO:
                ASSIGN c-especie-20 = "PRA":U
                       c-especie-22 = "INV":U
                       c-especie-23 = "GTN":U.
            END.
        END.
        WHEN 3 /* EUA */ THEN DO:
             ASSIGN c-especie-20 = "PRA":U
                    c-especie-22 = "INV":U
                    c-especie-23 = "GTN":U.

        END.
        OTHERWISE DO:
            ASSIGN c-especie-20 = "FTD":U
                   c-especie-22 = "FTS":U
                   c-especie-23 = "FTT":U.
        END.
    END CASE.    

    if  (RowObject.tipo = 2 or
         RowObject.tipo = 3) and
         RowObject.especie-doc <> c-especie-20 and
         RowObject.especie-doc <> c-especie-22 and
         RowObject.especie-doc <> c-especie-23 THEN DO:

        IF i-pais-impto-usuario = 1 /* Brasil */ THEN DO:
            {method/svc/errors/inserr.i
                    &ErrorNumber="1002"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}
        END.
        ELSE DO:
            /* &1 inv lido - &1 s¢ pode ser cadastrado com os valores &2.*/
            {utp/ut-liter.i "Esp‚cie do Documento" *}
            ASSIGN c-liter = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "ou" *}
            ASSIGN c-liter = c-liter + "~~":U + c-especie-20 + ", ":U + c-especie-22 + " ":U + TRIM(RETURN-VALUE) + " ":U + c-especie-23.
            {method/svc/errors/inserr.i
                    &ErrorNumber="18769"
                    &ErrorType="EMS"
                    &ErrorParameters="c-liter"}
        END.
    END.

    run validateFieldsContents.

    find tipo-rec-desp where
         tipo-rec-desp.tp-codigo = RowObject.tp-rec-desp no-lock no-error.
    if  not avail tipo-rec-desp then
        {method/svc/errors/inserr.i
                &ErrorNumber="3299"
                &ErrorType="EMS"
                &ErrorParameters="''"}
    else do:
        if  RowObject.emite-duplic then do:
            if  RowObject.tipo = 1 and 
                tipo-rec-desp.tipo = 1 then
                {method/svc/errors/inserr.i
                        &ErrorNumber="967"
                        &ErrorType="EMS"
                        &ErrorParameters="''"}

            RUN utp/ut-liter.p (INPUT TRIM({ininc/i03in218.i 04 20}), INPUT "*", INPUT "").
            ASSIGN c-especie-20 = trim(RETURN-VALUE).

            if  RowObject.tipo = 2 and
                tipo-rec-desp.tipo = 2 and 
                (RowObject.especie-doc <> c-especie-20
                AND i-pais-impto-usuario = 1)
                then
                {method/svc/errors/inserr.i
                        &ErrorNumber="415"
                        &ErrorType="EMS"
                        &ErrorParameters="''"}
        end.
    end.

    if  RowObject.cod-esp <> "" then do:
        find esp-doc where
             esp-doc.cod-esp = RowObject.cod-esp no-lock no-error.
        if  not avail esp-doc then
            {method/svc/errors/inserr.i
                    &ErrorNumber="1822"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}
        ELSE DO:
            IF i-pais-impto-usuario <> 1 AND  /* 1 - Brasil */
               i-pais-impto-usuario <> 3 /* 3 - EUA */ THEN DO:
                if (esp-doc.tipo <> 1 and
                    esp-doc.tipo <> 2 and
                    esp-doc.tipo <> 4 and
                    esp-doc.tipo <> 5) THEN
                    {method/svc/errors/inserr.i
                        &ErrorNumber="5921"
                        &ErrorType="EMS"
                        &ErrorParameters="''"}

            END.
            ELSE DO:
                if (esp-doc.tipo <> 1 and
                    esp-doc.tipo <> 4 and
                    esp-doc.tipo <> 5) then
                    {method/svc/errors/inserr.i
                            &ErrorNumber="5921"
                            &ErrorType="EMS"
                            &ErrorParameters="''"}
            END.
        END.
    end.

    /* Industrializa‡Æo por Encomenda */
    IF  RowObject.tipo = 2 /* Saida */
    AND SUBSTR(RowObject.char-1,172,1) = "1" THEN DO:

        IF  RowObject.nat-comp = "" THEN DO:
            {method/svc/errors/inserr.i
                    &ErrorNumber="56554"
                    &ErrorType="EMS"}
        END.
        ELSE DO:
            FOR FIRST b2-natur-oper 
                WHERE b2-natur-oper.nat-operacao = RowObject.nat-comp NO-LOCK: END.
            if  NOT AVAIL b2-natur-oper
            OR  NOT b2-natur-oper.terceiros
            OR  b2-natur-oper.tp-oper-terc <> 2 then do:
                {method/svc/errors/inserr.i
                        &ErrorNumber="55707"
                        &ErrorType="EMS"}
            end.
        END.
    END.

    /* Depósito Fechado */
    IF  RowObject.tipo         = 1 /* Entrada */
    AND RowObject.tp-oper-terc = 8 /* Remessa Depósito Fechado */  
    AND((AVAIL b-natur-oper 
         AND RowObject.tp-oper-terc <> b-natur-oper.tp-oper-terc) 
         OR NOT AVAIL b-natur-oper) THEN DO:

        FOR FIRST b2-natur-oper 
            WHERE b2-natur-oper.nat-operacao = RowObject.nat-comp NO-LOCK: 
        END.

        IF  RowObject.nat-comp = ""
        OR  NOT AVAIL b2-natur-oper
        OR  NOT b2-natur-oper.terceiros
        OR  b2-natur-oper.tipo <> 2
        OR  b2-natur-oper.tp-oper-terc <> 9 /* Retorno Depósito Fechado */ THEN DO:
            {method/svc/errors/inserr.i
                    &ErrorNumber="56815"
                    &ErrorType="EMS"}
        END.
    END.

    if  RowObject.transf and
        param-global.modulo-mp then do:

        find b2-natur-oper where
             b2-natur-oper.nat-operacao = RowObject.nat-comp no-lock no-error.
        if  not avail b2-natur-oper then do:
            {utp/ut-liter.i Natureza_de_Opera‡Æo_Complementar MFT}
            {method/svc/errors/inserr.i
                    &ErrorNumber="56"
                    &ErrorType="EMS"
                    &ErrorParameters="return-value"}
        end.
        else
            if  b2-natur-oper.tipo = RowObject.tipo then do:
                {utp/ut-liter.i Natureza_de_Opera‡Æo_Complementar MFT}
                {method/svc/errors/inserr.i
                        &ErrorNumber="15408"
                        &ErrorType="EMS"
                        &ErrorParameters="return-value"}
            end.
    end.
    
    &if defined (bf_dis_desc_bonif) &then
    if  RowObject.log-natureza-bonif and
        RowObject.cod-natur-oper-bonif <> "" then do:
        {utp/ut-liter.i Natureza_de_Bonifica‡Æo MFT}
        {method/svc/errors/inserr.i
                &ErrorNumber="17739"
                &ErrorType="EMS"
                &ErrorParameters="return-value"}
    end.
    else
        if  RowObject.cod-natur-oper-bonif <> "" then do:
            find b2-natur-oper where
                 b2-natur-oper.nat-operacao = RowObject.cod-natur-oper-bonif no-lock no-error.
            if  not avail b2-natur-oper then do:
                {utp/ut-liter.i Natureza_de_Bonifica‡Æo MFT}
                {method/svc/errors/inserr.i
                        &ErrorNumber="56"
                        &ErrorType="EMS"
                        &ErrorParameters="return-value"}
            end.
            else
                if  not b2-natur-oper.log-natureza-bonif then do:
                    {utp/ut-liter.i Natureza_de_Bonifica‡Æo MFT}
                    {method/svc/errors/inserr.i
                            &ErrorNumber="17740"
                            &ErrorType="EMS"
                            &ErrorParameters="return-value"}
                end.
        end.

    if  pType = "Update":U               and
        not RowObject.log-natureza-bonif and
        b-natur-oper.log-natureza-bonif  and
        can-find(natur-oper where
                 natur-oper.cod-natur-oper-bonif = RowObject.nat-operacao) then do:
        {utp/ut-liter.i Natureza_de_Bonifica‡Æo MFT}
        {method/svc/errors/inserr.i
                &ErrorNumber="17805"
                &ErrorType="EMS"
                &ErrorParameters="return-value"}
    end.
    &endif
    
    /*Valida‡Æo codigo CFOP*/
    if pType = "Create":U or pType = "Update" then do: 
       &if defined(bf_dis_formato_CFOP) &then
           if RowObject.cod-cfop <> " " THEN
              if not can-find(first cfop-natur where cfop-natur.cod-cfop = RowObject.cod-cfop no-lock) then do:
                 /* Inicio -- Projeto Internacional */
                 DEFINE VARIABLE c-lbl-liter-cfop AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "CFOP" *}
                 ASSIGN c-lbl-liter-cfop = TRIM(RETURN-VALUE).
                 {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorParameters="c-lbl-liter-cfop"}
              end.
       &else
           if substr(RowObject.char-1,45,10) <> "" THEN
              if not can-find(first ped-curva where 
                                    ped-curva.vl-aberto = 620
                                and ped-curva.it-codigo = substr(RowObject.char-1,45,10)no-lock) then do:
                 /* Inicio -- Projeto Internacional */
                 DEFINE VARIABLE c-lbl-liter-cfop-2 AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "CFOP" *}
                 ASSIGN c-lbl-liter-cfop-2 = TRIM(RETURN-VALUE).
                 {method/svc/errors/inserr.i
                      &ErrorNumber="2"
                      &ErrorType="EMS"
                      &ErrorParameters="c-lbl-liter-cfop-2"} 
              end.        
       &endif       
    end.

    if  i-pais-impto-usuario = 1 then
        run validateBrasil.
    else
        run validateInternacional.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDelete DBOFunction 
PROCEDURE validateDelete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param table for RowObject.
    def output param table for RowErrors.

    find first RowObject no-error.
    if  not avail RowObject then
        return "NOK":U.

    find b-natur-oper where
         b-natur-oper.nat-operacao = RowObject.nat-operacao no-lock no-error.
    if  not avail b-natur-oper then do:
        {method/svc/errors/inserr.i
                &ErrorNumber="56"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper"}
        return "NOK":U.
    end.

    if  param-global.modulo-bh then do:
        {bhp/bh9999.i 4 Natur-Oper b-natur-oper.nat-operacao '' '' '' '' ''}
        if  return-value <> "OK":U then do:
            {method/svc/errors/inserr.i
                    &ErrorNumber="25607"
                    &ErrorType="EMS"
                    &ErrorParameters="c-label-natur-oper"}
            return "NOK":U.
        end.
    end.

    if  can-find (first ped-venda use-index ch-natoper 
                  where ped-venda.nat-operacao = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i mgdis ped-venda 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.

    &if {&bf_dis_versao_ems} <= 2.02 &then
    if  can-find (first cot-ped-v
                  where cot-ped-v.nat-operacao = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i mgdis cot-ped-v 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.

    if  can-find (first cot-ped-i
                  where cot-ped-i.nat-operacao = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i mgdis cot-ped-i 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.
    &endif

    if  can-find (first emitente use-index ch-natope 
                  where emitente.nat-operacao = b-natur-oper.nat-operacao
                     or emitente.nat-ope-ext  = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i mgadm emitente 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.

    if  can-find (first nota-fiscal 
                  where nota-fiscal.nat-operacao = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i mgdis nota-fiscal 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.

    if  can-find (first it-nota-fisc use-index ch-natope
                  where it-nota-fisc.nat-operacao = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i mgdis it-nota-fisc 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.

    if  can-find(first docum-est
                 where docum-est.nat-operacao = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i mgind docum-est 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.

    /* TQGKE3 - removidas as validações das tabelas mov-tit, lin-i-cr e titulo */

    if  can-find(first imag-for 
                 where imag-for.nat-operacao = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i mgadm imag-for 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.

    if  can-find(first param-fb 
                 where param-fb.nat-oper-pad = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i mgdis param-fb 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.

    if  can-find(first doc-fiscal 
                 where doc-fiscal.nat-operacao = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i mgdis doc-fiscal 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.
	
    if  can-find(first ped-item 
                 where ped-item.nat-operacao = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i mgdis ped-item 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.     

    if  can-find(first devol-cli 
                 where devol-cli.nat-operacao = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i mgdis devol-cli 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.     

    &IF '{&BF_DIS_VERSAO_EMS}' < '2.05' &THEN
    if  can-find(first fisco 
                 where fisco.nat-operacao = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i mgdis fisco 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.
    &ENDIF

    if  can-find(first it-ext-tr 
                 where it-ext-tr.nat-operacao = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i mgdis it-ext-tr 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.     

    if  can-find(first res-cli 
                 where res-cli.nat-operacao = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i mgdis res-cli 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.     

    if  can-find(first it-pre-fat 
                 where it-pre-fat.nat-operacao = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i mgdis it-pre-fat 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.     

    if  can-find(first pre-fatur 
                 where pre-fatur.nat-operacao = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i mgdis pre-fatur 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.     

    if  can-find(first despesa-aces 
                 where despesa-aces.nat-oper-ac  = b-natur-oper.nat-operacao or 
                       despesa-aces.nat-operacao = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i mgind despesa-aces 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.     

    if  can-find(first componente 
                 where componente.nat-operacao = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i mgind componente 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.     

    if  can-find(first ficha-cq 
                 where ficha-cq.nat-operacao = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i mgind ficha-cq 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.

    if  can-find(first item-doc-est 
                 where item-doc-est.nat-of = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i movind item-doc-est 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.

    if  can-find(first pd-cc-it-nfe 
                 where pd-cc-it-nfe.nat-operacao = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i mgind pd-cc-it-n 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.     

    if  can-find(first pd-pd-it-nfe 
                 where pd-pd-it-nfe.nat-operacao = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i mgind pd-pd-it-n 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.

    if  can-find(first dupli-apagar 
                 where dupli-apagar.nat-operacao = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i movind dupli-apagar 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.

    if  can-find(first rat-lote 
                 where rat-lote.nat-operacao = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i mgind rat-lote 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.     

    if  can-find(first rat-ordem 
                 where rat-ordem.nat-operacao = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i mgind rat-ordem 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.     

    if  can-find(first saldo-terc 
                 where saldo-terc.nat-operacao = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i mgind saldo-terc 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.

    if  can-find(first movto-pend 
                 where movto-pend.nat-operacao = b-natur-oper.nat-operacao) then do:
        {utp/ut-table.i mgind movto-pend 1}
        {method/svc/errors/inserr.i
                &ErrorNumber="17"
                &ErrorType="EMS"
                &ErrorParameters="c-label-natur-oper + '~~~~' + return-value"}
    end.

    &if defined(bf_dis_desc_bonif) &then
        if  RowObject.log-natureza-bonif and
            can-find(natur-oper where
                     natur-oper.cod-natur-oper-bonif = b-natur-oper.nat-operacao) then do:
            {utp/ut-liter.i Natureza_de_Bonifica‡Æo MFT}
            {method/svc/errors/inserr.i
                    &ErrorNumber="17805"
                    &ErrorType="EMS"
                    &ErrorParameters="return-value"}
        end.
    &endif
    
    run validateDeleteFrotas in this-procedure.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDeleteFrotas DBOFunction 
PROCEDURE validateDeleteFrotas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define variable h-abapi008 as handle  no-undo.
define variable iErro      as integer no-undo.
define variable i-cont     as integer no-undo.

run cdp/cd9902.p (input 2).
if return-value = "OK":U then do:
    /** Passa o rowid para API de Frotas **/
    run abp/abapi008.p persistent set h-abapi008 (input RowObject.r-rowid).
    /** Valida‡äes de Frotas **/
    run validateNaturezaOperacao in h-abapi008 (input RowObject.nat-operacao).
    if return-value = "NOK":U then do:
        empty temp-table RowErrorsFrotas.
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
        empty temp-table RowErrorsFrotas.
    end.
    /** Elimina a API da mem¢ria **/
    if valid-handle(h-abapi008) then
        delete procedure h-abapi008.
end.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFieldsContents DBOFunction 
PROCEDURE validateFieldsContents :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var c-cotas       as char no-undo.
    def var c-faturamento as char no-undo.

    if  pType = "Create":U and
        (RowObject.denominacao = ? or 
         RowObject.denominacao = " ") then do:
        {utp/ut-liter.i Denomina‡Æo_Natureza_de_Opera‡Æo MFT}
        {method/svc/errors/inserr.i 
                &ErrorNumber="18732"
                &ErrorType="EMS"
                &ErrorParameters="return-value"}
    end.

    if  RowObject.tipo < 1 or
        RowObject.tipo > 3 then do:
        {utp/ut-liter.i Tipo_da_Natureza_de_Opera‡Æo MFT}
        {method/svc/errors/inserr.i 
                &ErrorNumber="18733"
                &ErrorType="EMS"
                &ErrorParameters="return-value + '~~~~' + '(1...3)'"}
    end.

    if  RowObject.tipo < 1 or
        RowObject.tipo > 3 then do:
        {utp/ut-liter.i Mercado_da_Natureza_de_Opera‡Æo MFT}
        {method/svc/errors/inserr.i 
                &ErrorNumber="18733"
                &ErrorType="EMS"
                &ErrorParameters="return-value + '~~~~' + '(1...3)'"}
    end.

    if  RowObject.tp-oper-terc < 1 or
        RowObject.tp-oper-terc > 11 then do:
        {utp/ut-liter.i Tipo_Opera‡Æo_com_Terceiros MFT}
        {method/svc/errors/inserr.i 
                &ErrorNumber="18733"
                &ErrorType="EMS"
                &ErrorParameters="return-value + '~~~~' + '(1...11)'"}
    end.

    if  RowObject.tipo = 1 then do:
        &if defined (bf_mat_estorno_devol) &then
        &else
        if  RowObject.cod-esp <> "" then
            {method/svc/errors/inserr.i
                    &ErrorNumber="25525"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}
        &endif
    end.

    if  not RowObject.ind-contabilizacao and
        RowObject.auto-ct then
        {method/svc/errors/inserr.i
                &ErrorNumber="25667"
                &ErrorType="EMS"
                &ErrorParameters="''"}
                
    RUN utp/ut-liter.p (INPUT TRIM({ininc/i03in218.i 04 21}), INPUT "*", INPUT "").
    ASSIGN c-especie-21 = trim(RETURN-VALUE).

    RUN utp/ut-liter.p (INPUT TRIM({ininc/i03in218.i 04 22}), INPUT "*", INPUT "").
    ASSIGN c-especie-22 = trim(RETURN-VALUE).

    IF  RowObject.terceiros 
    AND (RowObject.especie-doc <> c-especie-22
    AND  RowObject.especie-doc <> c-especie-21) THEN DO:
         {utp/ut-liter.i "ou"}
         ASSIGN c-trad-nfs-nfe = c-especie-22 + ' ' + trim(return-value) + ' ' + c-especie-21.
         {utp/ut-liter.i "com terceiros"}
        {method/svc/errors/inserr.i
                &ErrorNumber="29644"
                &ErrorType="EMS"
                &ErrorParameters="RowObject.especie-doc + '~~~~' + trim(return-value) + '~~~~' + c-trad-nfs-nfe"}
    END.
    
    RUN utp/ut-liter.p (INPUT TRIM({ininc/i03in218.i 04 23}), INPUT "*", INPUT "").
    ASSIGN c-especie-23 = trim(RETURN-VALUE).

    IF  (    RowObject.transf
         AND RowObject.especie-doc <> c-especie-23 ) THEN DO:
        {utp/ut-liter.i "de transferˆncia"}
        {method/svc/errors/inserr.i
                &ErrorNumber="29644"
                &ErrorType="EMS"
                &ErrorParameters="RowObject.especie-doc + '~~~~' + trim(return-value) + '~~~~' + c-especie-23"}
    END.
    IF  (    RowObject.transf = NO
         AND RowObject.especie-doc = c-especie-23) THEN DO:
        RUN utp/ut-liter.p (INPUT TRIM({ininc/i03in218.i 04 21}), INPUT "*", INPUT "").
        ASSIGN c-especie-23 = trim(RETURN-VALUE).
        RUN utp/ut-liter.p (INPUT TRIM({ininc/i03in218.i 04 22}), INPUT "*", INPUT "").
        ASSIGN c-especie-23 = c-especie-23 + "/" + trim(RETURN-VALUE).
        {utp/ut-liter.i "de sa¡da/entrada"}
        {method/svc/errors/inserr.i
                &ErrorNumber="52510"
                &ErrorType="EMS"
                &ErrorParameters="''"}
    END.

    if  RowObject.terceiros then do:
        if  RowObject.transf then
            {method/svc/errors/inserr.i
                    &ErrorNumber="25526"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}
    end.
    else do:
        if  RowObject.tp-oper-terc <> 1 or
            substr(RowObject.char-2,36,05) = "1    ":U then
            {method/svc/errors/inserr.i
                    &ErrorNumber="25527"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}  
    end.

    if  (not RowObject.terceiros or
         substr(RowObject.char-2,36,05) <> "1    ":U or
         (RowObject.tp-oper-terc <> 2 and
          RowObject.tp-oper-terc <> 4 and
          RowObject.tp-oper-terc <> 5 and
          RowObject.tp-oper-terc <> 6 and
          RowObject.tp-oper-terc <> 9 and
          RowObject.tp-oper-terc <> 11)) and
        RowObject.dec-1 <> 0 and
        RowObject.dec-1 <> ? then
        {method/svc/errors/inserr.i
                &ErrorNumber="25528"
                &ErrorType="EMS"
                &ErrorParameters="''"}

    if  not param-global.modulo-08 then

        IF RowObject.log-atual-cotas = YES THEN DO:
            {utp/ut-liter.i Cotas}
            assign c-cotas = return-value.
            {utp/ut-liter.i atualizar_cotas}
            {method/svc/errors/inserr.i
                    &ErrorNumber="25529"
                    &ErrorType="EMS"
                    &ErrorParameters="c-cotas + '~~~~' + return-value"}
        end.

    if  not param-global.modulo-ft then

        if  RowObject.atual-estat then do:
            {utp/ut-liter.i Faturamento MFT}
            assign c-faturamento = return-value.
            {utp/ut-liter.i atualizar_estat¡stica MFT}
            {method/svc/errors/inserr.i
                    &ErrorNumber="25529"
                    &ErrorType="EMS"
                    &ErrorParameters="c-faturamento + '~~~~' + return-value"}
    end.

    &if defined(bf_dis_desc_bonif) &then
    if  RowObject.tipo = 1 and
        (RowObject.log-natureza-bonif or
         (RowObject.cod-natur-oper-bonif <> " " and
          RowObject.cod-natur-oper-bonif <> ?)) then
        {method/svc/errors/inserr.i
                &ErrorNumber="25680"
                &ErrorType="EMS"
                &ErrorParameters="''"}
    &endif

    &if defined (bf_mat_oper_triangular) &then
        if  (   NOT RowObject.transf 
             OR NOT param-global.modulo-mp)
            AND NOT RowObject.ind-entfut
            AND NOT RowObject.baixa-estoq
            AND RowObject.nat-comp <> "":U
            AND RowObject.nat-comp <> ? 
            AND RowObject.tipo     =  1 THEN /* Somente quando ‚ entrada */
            {method/svc/errors/inserr.i &ErrorNumber     = "25530"
                                        &ErrorType       = "EMS"
                                        &ErrorParameters = "''"}
    &else
        if  (not RowObject.transf or
             not param-global.modulo-mp) AND
             not RowObject.ind-entfut
             AND NOT RowObject.baixa-estoq
             and RowObject.nat-comp <> " "
             and RowObject.nat-comp <> ? then
             {method/svc/errors/inserr.i
                     &ErrorNumber="25531"
                     &ErrorType="EMS"
                     &ErrorParameters="''"}

    &endif

    IF  RowObject.ind-entfut
    AND RowObject.nat-comp <> ""
    AND RowObject.nat-comp <> ? THEN DO:

        find b2-natur-oper where
             b2-natur-oper.nat-operacao = RowObject.nat-comp no-lock no-error.
        if  not avail b2-natur-oper then do:
            {utp/ut-liter.i Natureza_de_Opera‡Æo_Complementar MFT}
            {method/svc/errors/inserr.i
                    &ErrorNumber="56"
                    &ErrorType="EMS"
                    &ErrorParameters="return-value"}
        end.
        else 
            /*Se for nota de devolucao cliente, especie NFD e for uma devolucao de entrega 
              futura o tipo de operacao de terceiros tem que ser de retorno beneficiamento */
            IF  RowObject.tipo-compra = 3
            AND RowObject.especie-doc = "NFD"
            AND (SUBSTRING(RowObject.char-1,1,5) = ""
            OR  SUBSTRING(RowObject.char-1,1,5) = "0")
            AND ((RowObject.tipo = 1 and b2-natur-oper.tipo = 2)
            OR  (RowObject.tipo = 2 and b2-natur-oper.tipo = 1))
            AND b2-natur-oper.terceiros THEN DO:
                if b2-natur-oper.tp-oper-terc <> 2 then do:
                    /* mensagem: Natureza Complementar Inv lida para Opera‡Æo Entrega Futura. */
                    {method/svc/errors/inserr.i &ErrorNumber     = "53206"
                                                &ErrorType       = "EMS"
                                                &ErrorParameters = "''"}
                end.
            END.
            ELSE DO:
                IF RowObject.especie-doc = "NFD" 
                AND b2-natur-oper.tp-oper-terc <> 2 THEN /* Devolu‡Æo de fatura entrega futura deve ter complementar do tipo retorno beneficiamento */

                    {method/svc/errors/inserr.i &ErrorNumber     = 53994 /*Natureza Complementar Inválida para Operação Entrega Futura.*/
                                                &ErrorType       = "EMS"
                                                &ErrorSubType    = "ERROR"
                                                &ErrorParameters = " "} 
                                                
                ELSE
                IF 	RowObject.especie-doc <> "NFD" 
                AND (not b2-natur-oper.terceiros 
                OR	b2-natur-oper.tp-oper-terc <> 1) THEN
                
                    {method/svc/errors/inserr.i &ErrorNumber     = "25744"
                                                &ErrorType       = "EMS"	
                                                &ErrorParameters = "''"}
            END. 
    END.
    
    FIND FIRST param-of 
        &IF "{&bf_dis_versao_ems}" < "2.08" &THEN 
        WHERE SUBSTRING(param-of.char-2,57,1) = "S" NO-LOCK NO-ERROR.
    &ELSE
        WHERE param-of.log-devol-consig = YES NO-LOCK NO-ERROR.
    &ENDIF
     
    IF AVAIL param-of 
        AND RowObject.tp-oper-terc = 4
        AND RowObject.baixa-estoq = YES THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber     = "55195"
                                        &ErrorType       = "EMS"
                                        &ErrorSubType    = "ERROR"
                                        &ErrorParameters = "''"}                         
    END.

    if  i-pais-impto-usuario = 1 then
        run validateFieldsContentsBrasil.
    else
        run validateFieldsContentsInternacional.

    if
        &if "{&bf_dis_versao_ems}":U >= "2.08":U &then
            RowObject.log-permite-lote-vencid = yes and
        &else
            substring(RowObject.char-2,133,1) = "1" and
        &endif
        can-find(first funcao
                 where funcao.cd-funcao = "spp-lib-lote-vencido"
                 and   funcao.ativo)
            then do:
            {method/svc/errors/inserr.i &ErrorNumber="34844"
                                        &ErrorType="EMS"
                                        &ErrorParameters="''"}
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFieldsContentsBrasil DBOFunction 
PROCEDURE validateFieldsContentsBrasil :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if  substr(RowObject.char-2,78,06) <> "9.99":U   and
        substr(RowObject.char-2,78,06) <> "9.99.9":U and
        substr(RowObject.char-2,78,07) <> "9.99999":U  then
        /* Inicio -- Projeto Internacional */
        DO:
        DEFINE VARIABLE c-lbl-liter-formato-cfop AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Formato_CFOP" *}
        ASSIGN c-lbl-liter-formato-cfop = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-999-ou-9999 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "9.99_ou_9.99.9" *}
        ASSIGN c-lbl-liter-999-ou-9999 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i 
                &ErrorNumber="18733"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-formato-cfop + '~~~~' + c-lbl-liter-999-ou-9999"}
        END. 

    &if defined (bf_mat_natur_compra_re) &then
    if  RowObject.tipo-compra < 1 or
        RowObject.tipo-compra > 9 then
        /* Inicio -- Projeto Internacional */
        DO:
        DEFINE VARIABLE c-lbl-liter-tipo-de-compra AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Tipo_de_Compra" *}
        ASSIGN c-lbl-liter-tipo-de-compra = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i 
                &ErrorNumber="18733"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-tipo-de-compra + '~~~~' + '1 a 9'"}
        END. 
    &endif

    IF  RowObject.tipo-compra = 9 AND
        RowObject.cod-model-nf-eletro <> "55" THEN DO:
        DEFINE VARIABLE c-lbl-liter-nota-cred-deb AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Nota Cr‚dito/D‚bito" *}
        ASSIGN c-lbl-liter-nota-cred-deb = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i 
                &ErrorNumber="58138"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-nota-cred-deb + '~~~~' + '55'"}
    END.

    if  substr(RowObject.char-2,11,05) <> "1    ":U and
        substr(RowObject.char-2,11,05) <> "2    ":U then
        /* Inicio -- Projeto Internacional */
        DO:
        DEFINE VARIABLE c-lbl-liter-base-ipi AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Base_IPI" *}
        ASSIGN c-lbl-liter-base-ipi = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-1-ou-2 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "1_ou_2" *}
        ASSIGN c-lbl-liter-1-ou-2 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                &ErrorNumber="18733"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-base-ipi + '~~~~' + c-lbl-liter-1-ou-2"}
        END. 

    if  substr(RowObject.char-2,21,05) <> "1    ":U and
        substr(RowObject.char-2,21,05) <> "2    ":U then
        /* Inicio -- Projeto Internacional */
        DO:
        DEFINE VARIABLE c-lbl-liter-base-iss AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Base_ISS" *}
        ASSIGN c-lbl-liter-base-iss = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-1-ou-3 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "1_ou_2" *}
        ASSIGN c-lbl-liter-1-ou-3 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                &ErrorNumber="18733"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-base-iss + '~~~~' + c-lbl-liter-1-ou-3"}
        END. 

    if  RowObject.cd-trib-ipi < 1 or
        RowObject.cd-trib-ipi > 4 then
        /* Inicio -- Projeto Internacional */
        DO:
        DEFINE VARIABLE c-lbl-liter-codigo-tributacao-ipi AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "C¢digo_Tributa‡Æo_IPI" *}
        ASSIGN c-lbl-liter-codigo-tributacao-ipi = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                &ErrorNumber="18733"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-codigo-tributacao-ipi + '~~~~' + '1 a 4'"}
        END. 

    if  RowObject.cd-trib-iss < 1 or
        RowObject.cd-trib-iss > 4 then
        /* Inicio -- Projeto Internacional */
        DO:
        DEFINE VARIABLE c-lbl-liter-codigo-tributacao-iss AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "C¢digo_Tributa‡Æo_ISS" *}
        ASSIGN c-lbl-liter-codigo-tributacao-iss = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                &ErrorNumber="18733"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-codigo-tributacao-iss + '~~~~' + '1 a 4'"}
        END. 

    if  RowObject.merc-base-icms < 1 or
        RowObject.merc-base-icms > 2 then
        /* Inicio -- Projeto Internacional */
        DO:
        DEFINE VARIABLE c-lbl-liter-base-icms AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Base_ICMS" *}
        ASSIGN c-lbl-liter-base-icms = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                &ErrorNumber="18733"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-base-icms + '~~~~' + '1 a 2'"}
        END. 

    if  RowObject.cd-trib-icm < 1 or
        RowObject.cd-trib-icm > 5 then
        /* Inicio -- Projeto Internacional */
        DO:
        DEFINE VARIABLE c-lbl-liter-codigo-tributacao-icms AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "C¢digo_Tributa‡Æo_ICMS" *}
        ASSIGN c-lbl-liter-codigo-tributacao-icms = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                &ErrorNumber="18733"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-codigo-tributacao-icms + '~~~~' + '1 a 5'"}
        END. 

    if  RowObject.dec-2 < 0 or
        RowObject.dec-2 > 1 then
        /* Inicio -- Projeto Internacional */
        DO:
        DEFINE VARIABLE c-lbl-liter-destino-reducao-icms AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Destino_Redu‡Æo_ICMS" *}
        ASSIGN c-lbl-liter-destino-reducao-icms = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                &ErrorNumber="18733"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-destino-reducao-icms + '~~~~' + '1 a 2'"}
        END. 

    if  RowObject.cd-situacao <> 18 and
        substr(RowObject.char-2,76,02) <> "  ":U then
        {method/svc/errors/inserr.i
                &ErrorNumber="25532"
                &ErrorType="EMS"
                &ErrorParameters="''"}

    if  RowObject.ind-entfut and
        RowObject.ind-est-qtd then
        {method/svc/errors/inserr.i
                &ErrorNumber="25536"
                &ErrorType="EMS"
                &ErrorParameters="''"}

    if  not param-global.modulo-ft then do:

        if  RowObject.manut-ipi    or
            RowObject.ind-imprenda or
            RowObject.manut-icm    or
            RowObject.cd-trib-iss  <> 1 or
            RowObject.perc-red-iss <> 0 or
            (RowObject.nat-vinculada <> " ":U and
             RowObject.nat-vinculada <> ?) or
            substr(RowObject.char-2,21,05) <> "1    ":U then
            {method/svc/errors/inserr.i
                    &ErrorNumber="25537"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    end.

    if  not param-global.modulo-of then do:

        if  RowObject.ipi-icm-out or
            (RowObject.cd-vinc-ipi <> " " and
             RowObject.cd-vinc-ipi <> ?) then
            {method/svc/errors/inserr.i
                    &ErrorNumber="25538"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    end.

    if  not param-global.modulo-re then do:

        if  RowObject.subs-trib    or
            RowObject.usa-nota-ent or
            RowObject.usa-pick     or
            RowObject.ipi-icm-out  or
            substr(RowObject.char-2,56,05) = "1    ":U then
            {method/svc/errors/inserr.i
                    &ErrorNumber="25539"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    end.

    if  not RowObject.subs-trib then do:

        if  RowObject.icms-subs-trib <> 0 or
            substr(RowObject.char-2,51,05) = "1    ":U or
            RowObject.usa-nota-ent or
            substr(RowObject.char-2,56,05) = "1    ":U then
            {method/svc/errors/inserr.i
                    &ErrorNumber="25540"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    end.

    if  RowObject.consum-final = yes 
    and RowObject.tipo <> 3 
    and substr(RowObject.char-2,01,05) = "2    ":U then
        {method/svc/errors/inserr.i
                &ErrorNumber="25541"
                &ErrorType="EMS"
                &ErrorParameters="''"}
/*    else
 *         if  RowObject.ipi-icm-out then
 *             {method/svc/errors/inserr.i
 *                     &ErrorNumber="25542"
 *                     &ErrorType="EMS"
 *                     &ErrorParameters="''"}*/

    if  RowObject.perc-red-icm < 0 or
        RowObject.perc-red-icm > 100 then
        /* Inicio -- Projeto Internacional */
        DO:
        DEFINE VARIABLE c-lbl-liter-percentual-de-reducao-de-icms AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Percentual_de_Redu‡Æo_de_ICMS" *}
        ASSIGN c-lbl-liter-percentual-de-reducao-de-icms = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-0-a-100 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "0%_a_100%" *}
        ASSIGN c-lbl-liter-0-a-100 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                &ErrorNumber="18733"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-percentual-de-reducao-de-icms + '~~~~' + c-lbl-liter-0-a-100"}
        END. 

    if  RowObject.perc-red-ipi < 0 or
        RowObject.perc-red-ipi > 100 then
        /* Inicio -- Projeto Internacional */
        DO:
        DEFINE VARIABLE c-lbl-liter-percentual-de-reducao-de-ipi AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Percentual_de_Redu‡Æo_de_IPI" *}
        ASSIGN c-lbl-liter-percentual-de-reducao-de-ipi = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-0-a-101 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "0%_a_100%" *}
        ASSIGN c-lbl-liter-0-a-101 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                &ErrorNumber="18733"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-percentual-de-reducao-de-ipi + '~~~~' + c-lbl-liter-0-a-101"}
        END. 

    if  RowObject.perc-red-iss < 0 or
        RowObject.perc-red-iss > 100 then
        /* Inicio -- Projeto Internacional */
        DO:
        DEFINE VARIABLE c-lbl-liter-percentual-de-reducao-de-iss AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Percentual_de_Redu‡Æo_de_ISS" *}
        ASSIGN c-lbl-liter-percentual-de-reducao-de-iss = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-0-a-102 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "0%_a_100%" *}
        ASSIGN c-lbl-liter-0-a-102 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                &ErrorNumber="18733"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-percentual-de-reducao-de-iss + '~~~~' + c-lbl-liter-0-a-102"}
        END. 

    if  RowObject.icms-subs-trib < 0 or
        RowObject.icms-subs-trib > 100 then
        /* Inicio -- Projeto Internacional */
        DO:
        DEFINE VARIABLE c-lbl-liter-percentual-de-substituicao-tri AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Percentual_de_Substitui‡Æo_Tribut ria" *}
        ASSIGN c-lbl-liter-percentual-de-substituicao-tri = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-0-a-103 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "0%_a_100%" *}
        ASSIGN c-lbl-liter-0-a-103 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                &ErrorNumber="18733"
                &ErrorType="EMS"
                &ErrorParameters="c-lbl-liter-percentual-de-substituicao-tri + '~~~~' + c-lbl-liter-0-a-103"}
        END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFieldsContentsInternacional DBOFunction 
PROCEDURE validateFieldsContentsInternacional :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if  RowObject.uso < 1 or
        RowObject.uso > 3 then do:
        {utp/ut-liter.i Uso_da_Natureza_de_Opera‡Æo MFT}
        {method/svc/errors/inserr.i 
                &ErrorNumber="18733"
                &ErrorType="EMS"
                &ErrorParameters="return-value + '~~~~' + '(1...3)'"}
    end.

    if  RowObject.tipo-trib < 1 or
        RowObject.tipo-trib > 2 then do:
        {utp/ut-liter.i Tipo_de_Tributa‡Æo MFT}
        {method/svc/errors/inserr.i
                &ErrorNumber="18733"
                &ErrorType="EMS"
                &ErrorParameters="return-value + '~~~~' + '(1...2)'"}
    end.

    if  RowObject.calc-auto and
        substr(RowObject.char-2,41,05) = "1    ":U then
        {method/svc/errors/inserr.i
                &ErrorNumber="25543"
                &ErrorType="EMS"
                &ErrorParameters="''"}

    /* Picking */
    if  RowObject.calc-auto and
        RowObject.log-picking then
        {method/svc/errors/inserr.i
                &ErrorNumber="27219"
                &ErrorType="EMS"
                &ErrorParameters="''"}                

    if  substr(RowObject.char-2,41,05) = "2    ":U and
        (substr(RowObject.char-2,61,05) = "1    ":U or
        RowObject.baixa-ship) then
        {method/svc/errors/inserr.i
                &ErrorNumber="25544"
                &ErrorType="EMS"
                &ErrorParameters="''"}

    if  not RowObject.baixa-estoq and
        RowObject.baixa-ship then
        {method/svc/errors/inserr.i
                &ErrorNumber="25545"
                &ErrorType="EMS"
                &ErrorParameters="''"}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateInternacional DBOFunction 
PROCEDURE validateInternacional :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*------------------ Validacoes do campo Operacao Triangular ------------------*/
    &if defined (bf_mat_oper_triangular) &then
    
        find first param-global no-lock no-error.
        
        if  RowObject.log-oper-triang
            and (RowObject.transf
                 or (RowObject.terceiros
                     or RowObject.tp-oper-terc <> 1)) then do:
             {utp/ut-liter.i Natureza_de_Opera‡Æo * c }
             {method/svc/errors/inserr.i
                                &ErrorNumber="19489"
                                &ErrorType="EMS"
                                &ErrorParameters=return-value}
        end.
         
        if  RowObject.log-oper-triang 
        and not RowObject.terceiros then do:
        
            find b2-natur-oper where
                 b2-natur-oper.nat-operacao = RowObject.nat-vinculada no-lock no-error.
            
            if  not avail b2-natur-oper then do:
                {utp/ut-liter.i Natureza_de_Opera‡Æo_Vinculada * c }

                {method/svc/errors/inserr.i
                                   &ErrorNumber="56"
                                   &ErrorType="EMS"
                                   &ErrorParameters=return-value}
            end.
            else do:
                if  RowObject.tipo = 1 /* Entrada */ 
                and (    not b2-natur-oper.terceiros
                     or  b2-natur-oper.tipo = 1
                     or  (    b2-natur-oper.tp-oper-terc <> 1
                          and b2-natur-oper.tp-oper-terc <> 3)) then do:
    
                    {utp/ut-liter.i Natureza_de_Opera‡Æo_de_Entrega MFT}
                    {method/svc/errors/inserr.i
                            &ErrorNumber="19079"
                            &ErrorType="EMS"
                            &ErrorParameters="return-value"}
                end.
    
                if  RowObject.tipo = 2 /* Sa¡da */ 
                and b2-natur-oper.terceiros then do:
                    {method/svc/errors/inserr.i
                            &ErrorNumber="19491"
                            &ErrorType="EMS"
                            &ErrorParameters=" "}
                end.
            end.
       end.
        
    &endif


    &IF '{&bf_dis_versao_ems}' >= '2.062' &THEN 
    IF  &IF '{&bf_dis_versao_ems}' >= '2.071' &THEN 
        RowObject.log-vda-ret &ELSE 
        SUBSTR(RowObject.char-2,131,1) <> "2"
        &ENDIF THEN DO:
        
        IF  RowObject.tipo = 1 AND 
            RowObject.terceiros THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber     = 34137
                                        &ErrorType       = "EMS"
                                        &ErrorSubType    = "ERROR"
                                        &ErrorParameters = ''}
        END.
        ELSE DO:
            IF  RowObject.nat-vinculada = "" THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-tipo-vinculada AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Tipo_Vinculada" *}
                ASSIGN c-lbl-liter-tipo-vinculada = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber     =  265
                                            &ErrorType       = "EMS"
                                            &ErrorSubType    = "ERROR"
                                            &ErrorParameters = 'c-lbl-liter-tipo-vinculada'}
            END.
            ELSE DO:
                FIND FIRST b-natur-oper WHERE
                           b-natur-oper.nat-operacao = RowObject.nat-vinculada no-lock no-error.
                IF  NOT AVAIL b-natur-oper THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-tipo-vinculada-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Tipo_Vinculada" *}
                    ASSIGN c-lbl-liter-tipo-vinculada-2 = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i &ErrorNumber     = 56
                                                 &ErrorType       = "EMS"
                                                 &ErrorSubType    = "ERROR"
                                                 &ErrorParameters = 'c-lbl-liter-tipo-vinculada-2'}
                END.
                ELSE
                    IF  b-natur-oper.terceiros = NO OR b-natur-oper.tp-oper-terc <> 2 THEN DO:
                        {method/svc/errors/inserr.i &ErrorNumber     = 34136
                                                    &ErrorType       = "EMS"
                                                    &ErrorSubType    = "ERROR"
                                                    &ErrorParameters = ''}
                    END.
            END.
        END.

        IF  SUBSTR(RowObject.char-2,41,5) = "2    ":U AND 
            NOT RowObject.baixa-estoq THEN DO:

            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-tipo-debe-bajar-inventario AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Tipo_debe_bajar_inventario" *}
            ASSIGN c-lbl-liter-tipo-debe-bajar-inventario = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-tipo-debe-bajar-inventario-cua AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Tipo_debe_bajar_inventario_cuando_es_un_tipo_de_venta_retorno_y_no_emite_remito,_para_que_baje_el_saldo_que_est _en_terceros" *}
            ASSIGN c-lbl-liter-tipo-debe-bajar-inventario-cua = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber     = 17006
                                        &ErrorType       = "EMS"
                                        &ErrorSubType    = "ERROR"
                                        &ErrorParameters="c-lbl-liter-tipo-debe-bajar-inventario + '~~~~' + 
                                        c-lbl-liter-tipo-debe-bajar-inventario-cua + '.'"}
        END.
        
    END.
    ELSE DO:

        FIND FIRST b-natur-oper WHERE
                   b-natur-oper.nat-operacao = RowObject.nat-operacao NO-LOCK NO-ERROR.

        IF  AVAIL b-natur-oper AND 
            &IF '{&bf_dis_versao_ems}'     >= '2.071' &THEN 
            RowObject.log-vda-ret          <> b-natur-oper.log-vda-ret &ELSE 
            SUBSTR(RowObject.char-2,131,1) <> SUBSTR(b-natur-oper.char-2,131,1)
            &ENDIF THEN DO:        
            IF  CAN-FIND(FIRST ped-sdo-terc WHERE 
                               ped-sdo-terc.cod-natur-operac-ret = RowObject.nat-vinculada) THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber     = 34138
                                            &ErrorType       = "EMS"
                                            &ErrorSubType    = "ERROR"
                                            &ErrorParameters = ''}
            END.
        END.
    END.    

    /*Valida se Gera Nota de Cr‚dito e Gera Nota de D‚bito estÆo marcados*/
    IF SUBSTRING(RowObject.char-2,132,1) = "1"  AND
       SUBSTRING(RowObject.char-2,134,1) = "1" THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber     = 53941
                                    &ErrorType       = "EMS"
                                    &ErrorSubType    = "ERROR"
                                    &ErrorParameters="''"}
    END.

    /*Para notas de Cr‚dito e D‚bito nÆo deve emitir duplicatas pois a NC e ND ‚ gerada por outra api do 
    ems5 */
    IF RowObject.emite-duplic 
        AND
           (&IF "{&bf_mat_versao_ems}" >= "2.071" &THEN
               RowObject.log-gera-ncredito
           &ELSE
               SUBSTRING(RowObject.char-2,132,1) = "1" /*Nota de Cr‚dito*/
           &ENDIF
               OR SUBSTRING(RowObject.char-2,134,1) = "1" /*Nota de D‚bito*/
             )
        THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber     = 53945
                                    &ErrorType       = "EMS"
                                    &ErrorSubType    = "ERROR"
                                    &ErrorParameters="''"}
    END.        

    IF SUBSTRING(RowObject.char-2,134,1) = "1" /*Nota de D‚bito*/ THEN DO:

        FIND FIRST esp-doc 
             WHERE esp-doc.cod-esp = RowObject.cod-esp NO-LOCK NO-ERROR.

        IF NOT AVAIL esp-doc
            OR (
                (AVAIL esp-doc 
                 AND esp-doc.tipo <> 4 /*Nota de D‚bito*/) AND i-pais-impto-usuario <> 21 /*Equador*/
                )
            THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber     = 53944
                                        &ErrorType       = "EMS"
                                        &ErrorSubType    = "ERROR"
                                        &ErrorParameters="''"}
        END.
    END.

    IF &IF "{&bf_mat_versao_ems}" >= "2.071" &THEN
           RowObject.log-gera-ncredito
       &ELSE
           SUBSTRING(RowObject.char-2,132,1) = "1" /*Nota de Cr‚dito*/
       &ENDIF THEN DO:

        FIND FIRST esp-doc 
             WHERE esp-doc.cod-esp = RowObject.cod-esp NO-LOCK NO-ERROR.

        IF NOT AVAIL esp-doc
            OR (AVAIL esp-doc 
                  AND esp-doc.tipo <> 5 /*Nota de Cr‚dito*/
                )
            THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber     = 53943
                                        &ErrorType       = "EMS"
                                        &ErrorSubType    = "ERROR"
                                        &ErrorParameters="''"}
        END.
    END.

    IF  RowObject.terceiros        AND 
        RowObject.tp-oper-terc = 3 AND 
        RowObject.baixa-ship       THEN DO:

        IF  RowObject.nat-vinculada = "" THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-tipo-vinculada-debe-ser-inform AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Tipo_vinculada_debe_ser_informado" *}
            ASSIGN c-lbl-liter-tipo-vinculada-debe-ser-inform = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-tipo-vinculada-debe-ser-inform-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Tipo_vinculada_debe_ser_informado_cuando_es_remesa_consignaci¢n_y_actualiza_invent rio_por_remito" *}
            ASSIGN c-lbl-liter-tipo-vinculada-debe-ser-inform-2 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber     = 17006
                                        &ErrorType       = "EMS"
                                        &ErrorSubType    = "ERROR"
                                        &ErrorParameters="c-lbl-liter-tipo-vinculada-debe-ser-inform + '~~~~' + 
                                        c-lbl-liter-tipo-vinculada-debe-ser-inform-2 + '.'"}
        END.
        ELSE DO:

            FIND FIRST b-natur-oper WHERE
                       b-natur-oper.nat-operacao = RowObject.nat-vinculada no-lock no-error.
            IF  NOT AVAIL b-natur-oper THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-tipo-vinculada-3 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Tipo_Vinculada" *}
                ASSIGN c-lbl-liter-tipo-vinculada-3 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber     = 56
                                             &ErrorType       = "EMS"
                                             &ErrorSubType    = "ERROR"
                                             &ErrorParameters = 'c-lbl-liter-tipo-vinculada-3'}
            END.
            ELSE
                IF  b-natur-oper.terceiros = NO OR b-natur-oper.tp-oper-terc <> 4 THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-tipo-vinculada-no-es-facturaci AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Tipo_vinculada_no_es_Facturaci¢n_Consignaci¢n" *}
                    ASSIGN c-lbl-liter-tipo-vinculada-no-es-facturaci = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-tipo-vinculada-debe-ser-factur AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Tipo_vinculada_debe_ser_Facturaci¢n_Consignaci¢n_cuando_es_remesa_consignaci¢n_y_actualiza_invent rio_por_remito" *}
                    ASSIGN c-lbl-liter-tipo-vinculada-debe-ser-factur = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i &ErrorNumber     = 17006
                                                &ErrorType       = "EMS"
                                                &ErrorSubType    = "ERROR"
                                                &ErrorParameters="c-lbl-liter-tipo-vinculada-no-es-facturaci + '~~~~' + 
                                                c-lbl-liter-tipo-vinculada-debe-ser-factur + '.'"}
                END.
        END.

    END.
    &ENDIF
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
