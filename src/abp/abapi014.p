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
{include/i-prgvrs.i ABAPI014 2.00.00.002 } /*** 010002 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i abapi014 MAB}
&ENDIF


/*****************************************************************************
**
**       PROGRAMA: ABAPI014.p
**
**       DATA....: Setembro de 2006
**
**       AUTOR...: Marcio da Silva
**
**       OBJETIVO: Fazer a Inativa‡Æo dos Componentes e Pneus alocados para o Equipamento
**
*****************************************************************************/
/* ***************************  Definitions  ************************** */
{frbo/bofr066.i TTMco-movto-compon}
{frbo/bofr074.i TTMpn-movto-pneu}
{abp/abapi001.i1} /** Temp-table de  Erros **/ 

/** Par³metros **/
&IF "{&mguni_version}" >= "2.071" &THEN
DEFINE INPUT  PARAMETER pCodEmp          LIKE empresa.ep-codigo    NO-UNDO.
&ELSE
DEFINE INPUT  PARAMETER pCodEmp          AS INTEGER    NO-UNDO.
&ENDIF
DEFINE INPUT  PARAMETER pCodEqpto        AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pCodSitEqpto     AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pCodServicoPneu  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pCdCausaPneu     AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pCodSitPneu      AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pCdCausaCompon   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pCodSitCompon    AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pEntraMedia      AS logical    NO-UNDO.
DEFINE INPUT  PARAMETER pAcao            AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE            FOR RowErrors.

/** Variÿveis Handle **/
DEFINE VARIABLE hDBOmpn-movto-pneu   AS HANDLE                    NO-UNDO.
DEFINE VARIABLE hDBOmco-movto-compon AS HANDLE                    NO-UNDO.
DEFINE VARIABLE hDBOmpn-pneu         AS HANDLE                    NO-UNDO.

/** Variÿveis normais **/
DEFINE VARIABLE c-hora-invertida    AS decimal                    NO-UNDO.
DEFINE VARIABLE cAcao               AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-texto             AS CHARACTER  format "x(50)"  NO-UNDO.
DEFINE VARIABLE c-erro-pneu         AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-erro-compon       AS CHARACTER                  NO-UNDO.
{utp/ut-glob.i} /** Defini»’o do usuÿrio corrente no EMS **/

DEFINE BUFFER bfMcoMovtoCompon      FOR mco-movto-compon.
DEFINE BUFFER bfmpn-movto-pneu      FOR mpn-movto-pneu.

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
         HEIGHT             = 8.92
         WIDTH              = 41.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
{abp/ab9000.i}    /** ConversÆo de horas **/
{abp/abapi001.i2} /** Cria‡Æoo de Erros **/

run piInicializacao in this-procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Cria-mco-movto-compon) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cria-mco-movto-compon Procedure 
PROCEDURE Cria-mco-movto-compon :
/*------------------------------------------------------------------------------
  Purpose:    cria registro mpn-movto-penu
  Parameters: recebe a temp table para cria»’o do registro
              entrada RowObject2 = Temp-Table da Tabela mco-movto-compon
------------------------------------------------------------------------------*/
for first TTmco-movto-compon no-lock:
    /*** M²todo para cria»’o do movimento de componentes ***/
    run criaMovimentoCompon in hDBOmco-movto-compon (input table TTmco-movto-compon,
                                                     input cAcao).
    if return-value = "NOK":U then do:
        /** Busca Erros da BO **/
        run getRowErrors in hDBOmco-movto-compon (output table RowErrors).
        /** Limpa temp-tables de erros **/
        run emptyRowErrors in hDBOmco-movto-compon.

        assign c-erro-compon = c-erro-compon + TTmco-movto-compon.cod-compon + ", ":U.

        return "NOK":U.
    end.
end.

return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Cria-mpn-movto-pneu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cria-mpn-movto-pneu Procedure 
PROCEDURE Cria-mpn-movto-pneu :
/*------------------------------------------------------------------------------
  Purpose:    cria registro mpn-movto-penu
  Parameters: recebe a temp table para cria»’o do registro 
              entrada RowObject2 = Temp-Table da Tabela mpn-movto-penu
------------------------------------------------------------------------------*/
for first TTmpn-movto-pneu no-lock:
    run setaPrograma in hDBOmpn-movto-pneu (input "ABAPI014":U).
    /*** M²todo para cria»’o do movimento de pneus ***/
    run criaMovimentoPneu in hDBOmpn-movto-pneu  (input table TTmpn-movto-pneu,
                                                  input cAcao).

    if return-value = "OK":U then do:
        for last mpn-histor-vida where mpn-histor-vida.cod-pneu = TTmpn-movto-pneu.cod-pneu exclusive-lock:
            assign mpn-histor-vida.log-km-final-confiav = pEntraMedia.
        end.
    end.
    if return-value = "NOK":U then do:
       /** Busca Erros da BO **/
       run getRowErrors in hDBOmpn-movto-pneu (output table RowErrors).
       /** Limpa temp-tables de erros **/
       run emptyRowErrors in hDBOmpn-movto-pneu.

       assign c-erro-pneu = c-erro-pneu + TTmpn-movto-pneu.cod-pneu + ", ":U.

       return "NOK":U.
    end.

end.

return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-finalizaHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE finalizaHandle Procedure 
PROCEDURE finalizaHandle :
/*------------------------------------------------------------------------------
  Purpose:     finalizaHandle
  Parameters:  <none>
  Notes:       Elimina Handles da mem½ria
------------------------------------------------------------------------------*/
/** Destroy Movimento mpn-movto-pneu **/
if valid-handle(hDBOmpn-movto-pneu) then
    run destroy in hDBOmpn-movto-pneu.

/** Destroy Movimento mco-movto-compon **/
if valid-handle(hDBOmco-movto-compon) then
    run destroy in hDBOmco-movto-compon.

return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-inicializaHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inicializaHandle Procedure 
PROCEDURE inicializaHandle :
/*------------------------------------------------------------------------------
  Purpose:     initializeHandle
  Parameters:  <none>
  Notes:       Inicializa os handles no programa
------------------------------------------------------------------------------*/
/*--- BO Movimento Evento ---*/
if not valid-handle(hDBOmpn-movto-pneu)     or
   hDBOmpn-movto-pneu:type <> "PROCEDURE":U or
   hDBOmpn-movto-pneu:file-name <> "frbo/bofr074.p":U then do:
    run frbo/bofr074.p persistent SET hDBOmpn-movto-pneu.
end.

run openQueryStatic in hDBOmpn-movto-pneu (input "Main":U).

if not valid-handle(hDBOmco-movto-compon)     or
   hDBOmco-movto-compon:type <> "PROCEDURE":U or
   hDBOmco-movto-compon:file-name <> "frbo/bofr066.p":U THEN DO:
    run frbo/bofr066.p persistent set hDBOmco-movto-compon.
end.

run openQueryStatic in hDBOmco-movto-compon (input "Main":U).

return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piCriacaoMovtoPneu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriacaoMovtoPneu Procedure 
PROCEDURE piCriacaoMovtoPneu :
/*------------------------------------------------------------------------------
  Purpose:     piCriacaoMovtoPneu
  Parameters:  <none>
  Notes:       Cria a Temp-Table TTmpn-movto-pneu
------------------------------------------------------------------------------*/
DEFINE VARIABLE cTexto  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTexto2 AS CHARACTER  NO-UNDO.

assign c-erro-pneu = "".


/** Le Tabela par³metros do M½dulo de Pneus**/
find first mpn-param no-lock no-error.
if not avail mpn-param then return "OK":U.

/** Busca Registro Pneu **/
for each  mpn-pneu
    where mpn-pneu.ep-codigo-atual = mab-eqpto.ep-codigo
    and   mpn-pneu.cod-eqpto-atual = mab-eqpto.cod-eqpto 
    and   mpn-pneu.dat-situacao    = ? no-lock:

    /** Limpa TTmpn-movto-pneu **/
    empty temp-table TTmpn-movto-pneu.

    /* Converte Para Hora Invertida */
    run converteParaHoraInvertida (input string(mab-eqpto.dat-situacao,"99/99/9999"),
                                   input SUBSTRING(mab-eqpto.cod-livre-1,19,6),
                                   output c-hora-invertida).

    /***************************************************************************
    ** FO 1248166 - Leites L¡der ----------------------------------------------
    ** NÆo realizar as transferˆncias quando o pneu nÆo estava conectado ao 
    ** equipamento na data do hist¢rico 
    ***************************************************************************/
    FOR LAST  mpn-movto-pneu USE-INDEX mpnmvtpn-03
        WHERE mpn-movto-pneu.cod-pneu              = mpn-pneu.cod-pneu
        AND   mpn-movto-pneu.val-dat-hora-invrtda <= c-hora-invertida NO-LOCK:
    END.
    IF AVAIL mpn-movto-pneu THEN DO:
        /*** Valida com movimenta‡Æo **/
        IF mpn-pneu.ep-codigo-atual <> mpn-movto-pneu.ep-codigo-dest OR
           mpn-pneu.cod-eqpto-atual <> mpn-movto-pneu.cod-eqpto-dest THEN NEXT.
    END.
    ELSE DO:
        /** Valida com inicial do pneu quando nÆo encontra movimento **/
        IF mpn-pneu.ep-codigo-atual <> mpn-pneu.ep-codigo-inicial OR
           mpn-pneu.cod-eqpto-atual <> mpn-pneu.cod-eqpto-inicial THEN NEXT.
    END.
    /***************************************************************************
    ** FO 1248166 - Leites L¡der ----------------------------------------------
    ** NÆo realizar as transferˆncias quando j  existirem movimentos posteriores 
    ** a data do hist¢rico para os pneus
    ***************************************************************************/
    FOR FIRST mpn-movto-pneu USE-INDEX mpnmvtpn-03
        WHERE mpn-movto-pneu.cod-pneu              = mpn-pneu.cod-pneu
        AND   mpn-movto-pneu.val-dat-hora-invrtda >= c-hora-invertida NO-LOCK:
    END.
    IF  AVAIL mpn-movto-pneu THEN NEXT.

    /**************************************************************************/

    {utp/ut-liter.i "Transferˆncia entre estabelecimentos (bofr007)"}
    assign c-texto = trim(return-value).

    /** Cria registro Temp-Table **/
    create TTmpn-movto-pneu.

    /** Le cadastro de servi»os **/
    /*for first mpn-serv fields(cd-causa-padr cod-servico) 
        where mpn-serv.cod-servico = mpn-param.cod-serv-transf no-lock:
        assign TTmpn-movto-pneu.cd-causa-padr = mpn-serv.cd-causa-padr.
    end.*/
    assign TTmpn-movto-pneu.dat-movto            = mab-eqpto.dat-situacao
           TTmpn-movto-pneu.hra-inic-apont       = SUBSTRING(mab-eqpto.cod-livre-1,19,6)
           TTmpn-movto-pneu.hra-fim-apont        = SUBSTRING(mab-eqpto.cod-livre-1,19,6)
           TTmpn-movto-pneu.val-dat-hora-invrtda = c-hora-invertida
           TTmpn-movto-pneu.qti-conserto         = 0
           TTmpn-movto-pneu.cod-pneu             = mpn-pneu.cod-pneu
           TTmpn-movto-pneu.ep-codigo-orig       = mpn-pneu.ep-codigo-atual
           TTmpn-movto-pneu.cod-eqpto-orig       = mpn-pneu.cod-eqpto-atual
           TTmpn-movto-pneu.val-hodom-horim-orig = 0
           TTmpn-movto-pneu.cod-pos-orig         = mpn-pneu.cod-pos-atual
           TTmpn-movto-pneu.cod-estabel-orig     = mpn-pneu.cod-estabel-atual
           TTmpn-movto-pneu.cod-servico          = /*mpn-param.cod-serv-transf*/ pCodServicoPneu
           TTmpn-movto-pneu.cod-estabel-dest     = mab-eqpto.cod-estabel
           TTmpn-movto-pneu.val-sulco-1          = 0
           TTmpn-movto-pneu.val-sulco-2          = 0
           TTmpn-movto-pneu.val-sulco-3          = 0
           TTmpn-movto-pneu.val-sulco-4          = 0
           TTmpn-movto-pneu.val-sulco-5          = 0
           TTmpn-movto-pneu.val-sulco-6          = 0
           TTmpn-movto-pneu.val-sulco-7          = 0
           TTmpn-movto-pneu.val-sulco-8          = 0
           TTmpn-movto-pneu.val-sulco-9          = 0
           TTmpn-movto-pneu.val-sulco-10         = 0
           TTmpn-movto-pneu.vli-calibr-encontr   = 0
           TTmpn-movto-pneu.vli-calibr-colocada  = 0
           TTmpn-movto-pneu.ep-codigo-dest       = mpn-pneu.ep-codigo-atual
           TTmpn-movto-pneu.cod-eqpto-dest       = mpn-pneu.cod-eqpto-atual
           TTmpn-movto-pneu.val-hodom-horim-dest = 0
           TTmpn-movto-pneu.cod-pos-dest         = mpn-pneu.cod-pos-atual
           TTmpn-movto-pneu.cod-sit-eqpto        = /*mab-eqpto.cod-sit-eqpto*/ pCodSitPneu
           TTmpn-movto-pneu.idi-consist          = 1 /* Ficha n’o Consistida*/
           TTmpn-movto-pneu.dsl-obs              = c-texto
           TTmpn-movto-pneu.val-km-percur        = 0
           TTmpn-movto-pneu.val-uso-atual        = 0
           TTmpn-movto-pneu.log-consist          = no
           TTmpn-movto-pneu.cod-emitente         = 0
           TTmpn-movto-pneu.cod-desen            = ""
           TTmpn-movto-pneu.cod-borracha         = ""
           TTmpn-movto-pneu.val-km-hora-gartia   = 0
           TTmpn-movto-pneu.nr-nota-fis          = ""
           TTmpn-movto-pneu.serie                = ""
           TTmpn-movto-pneu.nat-operacao         = ""
           TTmpn-movto-pneu.dat-entrega          = ?
           &IF "{&mguni_version}" >= "2.071" &THEN
           TTmpn-movto-pneu.ep-codigo-matr       = ""
           &ELSE
           TTmpn-movto-pneu.ep-codigo-matr       = 0
           &ENDIF
           TTmpn-movto-pneu.cod-estabel-matr     = ""
           TTmpn-movto-pneu.cod-matr             = ""
           TTmpn-movto-pneu.val-mater-1          = 0
           TTmpn-movto-pneu.val-mater-2          = 0
           TTmpn-movto-pneu.val-mater-3          = 0
           TTmpn-movto-pneu.log-recus            = no
           TTmpn-movto-pneu.log-medi-sulco       = no
           TTmpn-movto-pneu.ct-codigo            = ""
           TTmpn-movto-pneu.cc-codigo            = ""
           TTmpn-movto-pneu.cod-refer            = ""
           TTmpn-movto-pneu.cod-localiz          = ""
           TTmpn-movto-pneu.lote                 = ""
           TTmpn-movto-pneu.nr-trans             = 0
           TTmpn-movto-pneu.idi-integr           = 1
           TTmpn-movto-pneu.it-codigo            = ""
           TTmpn-movto-pneu.cod-depos            = ""
           TTmpn-movto-pneu.cd-causa-padr        = pCdCausaPneu.

    for first mpn-serv fields(cd-causa-padr cod-servico log-eqpto-dest log-pos-dest log-estabel-dest) 
        where mpn-serv.cod-servico = mpn-param.cod-serv-transf no-lock:
    end.

    IF CAN-FIND (FIRST mab-param-integ 
        WHERE mab-param-integ.cdn-param = 8 
          AND mab-param-integr.des-valor  <> "1") THEN DO:
        IF mpn-serv.log-eqpto-dest   = YES OR
           mpn-serv.log-pos-dest     = YES OR
           mpn-serv.log-estabel-dest = YES THEN DO: 
            FIND LAST mpn-histor-vida 
                WHERE mpn-histor-vida.cod-pneu = TTmpn-movto-pneu.cod-pneu NO-LOCK NO-ERROR.
            IF AVAIL mpn-histor-vida AND mpn-histor-vida.it-codigo <> "" THEN DO:
                FIND LAST mpn-movto-pneu WHERE mpn-movto-pneu.cod-pneu = TTmpn-movto-pneu.cod-pneu NO-LOCK NO-ERROR.
                IF AVAIL mpn-movto-pneu THEN DO:
                    IF mpn-movto-pneu.cod-livre-2 <> "" THEN
                        ASSIGN TTmpn-movto-pneu.cod-livre-2 = mpn-movto-pneu.cod-livre-2.
                    ELSE DO:
                        FIND FIRST item-uni-estab
                             WHERE item-uni-estab.it-codigo = mpn-histor-vida.it-codigo
                               AND item-uni-estab.cod-estabel = mpn-movto-pneu.cod-estabel-dest NO-LOCK NO-ERROR.
                        IF AVAIL item-uni-estab THEN
                            ASSIGN TTmpn-movto-pneu.cod-livre-2 = item-uni-estab.deposito-pad.

                    END.
                END.
                ELSE DO:
                    FIND FIRST item-uni-estab
                         WHERE item-uni-estab.it-codigo = mpn-histor-vida.it-codigo
                           AND item-uni-estab.cod-estabel = mpn-pneu.cod-estabel-inicial NO-LOCK NO-ERROR.
                    IF AVAIL item-uni-estab THEN DO:
                        ASSIGN TTmpn-movto-pneu.cod-livre-2 = item-uni-estab.deposito-pad.
                    END.
                END.
            END.
        END.                   
    END.
    /** Busca pr¢xima numera‡Æo de pneu **/
    RUN buscaDocumento IN hDBOmpn-movto-pneu (OUTPUT TTmpn-movto-pneu.num-docto).

    run Cria-mpn-movto-pneu in this-procedure.
end. /* end each mpn-pneu */

FOR FIRST mab-param
    WHERE mab-param.cdn-param = 47
    AND   mab-param.des-valor = "2" NO-LOCK:
    {utp/ut-liter.i "Alguns pneus nÆo foram inativados e devem ser inativados manualmente"}
    assign cTexto = return-value.
    {utp/ut-liter.i "Pneus nÆo inativados"}
    assign cTexto2 = return-value.
    
    if c-erro-pneu <> "" then do:
        run utp/ut-msgs.p (input "SHOW":U,
                           input 27979,
                           input cTexto + "." + "~~"
                                  + cTexto2 + ": " + c-erro-pneu + ".").
    end.
END.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piCriaMovtoCompon) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaMovtoCompon Procedure 
PROCEDURE piCriaMovtoCompon :
/*------------------------------------------------------------------------------
  Purpose:     piCriacaoMovtoCompon
  Parameters:  <none>
  Notes:       Cria a Temp-Table TTmco-movto-compon
------------------------------------------------------------------------------*/
DEFINE VARIABLE cTexto  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTexto2 AS CHARACTER  NO-UNDO.

assign c-erro-compon = "".

/** Busca Registro Pneu **/
for each  mco-compon
    where mco-compon.ep-codigo-atual = mab-eqpto.ep-codigo
    and   mco-compon.cod-eqpto-atual = mab-eqpto.cod-eqpto
    and   mco-compon.dat-situacao    = ? no-lock:

    /** Limpa TTmco-movto-compon **/
    empty temp-table TTmco-movto-compon.

    /* Converte Para Hora Invertida */
    run converteParaHoraInvertida (input string(mab-eqpto.dat-situacao,"99/99/9999"),
                                   input string(substring(mab-eqpto.cod-livre-1,19,6)),
                                   output c-hora-invertida).

    /***************************************************************************
    ** FO 1248166 - Leites L¡der ----------------------------------------------
    ** NÆo realizar as transferˆncias quando o componente nÆo estava conectado ao 
    ** equipamento na data do hist¢rico 
    ***************************************************************************/
    for last  mco-movto-compon use-index mcmvtcmp-02
        where mco-movto-compon.num-seqcial           = mco-compon.num-seqcial
        and   mco-movto-compon.val-dat-hora-invrtda <= c-hora-invertida no-lock:
    end.
    if avail mco-movto-compon then do:
        if mco-movto-compon.idi-tip-movto > 1 then do:
            /*** Valida com movimenta‡Æo **/
            if mco-compon.ep-codigo-atual <> mco-movto-compon.ep-codigo or
               mco-compon.cod-eqpto-atual <> mco-movto-compon.cod-eqpto then next.
        end.
    end.
    else do:
        /** Valida com inicial do pneu quando nÆo encontra movimento **/
        if mco-compon.ep-codigo-atual <> mco-compon.ep-codigo-inicial or
           mco-compon.cod-eqpto-atual <> mco-compon.cod-eqpto-inicial then next.
    end.
    /***************************************************************************
    ** FO 1248166 - Leites L¡der ----------------------------------------------
    ** NÆo realizar as transferˆncias quando j  existirem movimentos posteriores 
    ** a data do hist¢rico para os componentes
    ***************************************************************************/
    if can-find(first mco-movto-compon use-index mcmvtcmp-02
                where mco-movto-compon.num-seqcial           = mco-compon.num-seqcial
                and   mco-movto-compon.val-dat-hora-invrtda >= c-hora-invertida no-lock) then next.
    /**************************************************************************/

    /** Cria registro Temp-Table **/    
    create TTmco-movto-compon.
    assign TTmco-movto-compon.num-seqcial           = mco-compon.num-seqcial
           TTmco-movto-compon.cod-sub-sist          = mco-compon.cod-sub-sist
           TTmco-movto-compon.dat-movto             = mab-eqpto.dat-situacao
           TTmco-movto-compon.cod-compon            = mco-compon.cod-compon
           TTmco-movto-compon.hra-movto             = substring(mab-eqpto.cod-livre-1,19,6)
           TTmco-movto-compon.val-dat-hora-invrtda  = c-hora-invertida
           TTmco-movto-compon.ep-codigo             = mco-compon.ep-codigo-atual
           TTmco-movto-compon.cod-eqpto             = mco-compon.cod-eqpto-atual
           TTmco-movto-compon.cod-evento            = ""
           TTmco-movto-compon.cod-localiz-compon    = mco-compon.cod-localiz-compon
           TTmco-movto-compon.idi-tip-movto         = 3 /* "Transfer¼ncia" */
           TTmco-movto-compon.nr-ord-produ          = 0
           TTmco-movto-compon.num-seq               = 0
           TTmco-movto-compon.cod-sit-eqpto         = /*mab-eqpto.cod-sit-eqpto*/ pCodSitCompon
           TTmco-movto-compon.val-uso-final         = 0
           TTmco-movto-compon.cod-estabel           = mab-eqpto.cod-estabel.

    IF l-usa-unid-negoc THEN DO:
        &IF DEFINED(bf_mnt_ems206b) &THEN
            ASSIGN TTmco-movto-compon.cod-unid-negoc = mab-eqpto.cod-unid-negoc.
        &ENDIF
    END.

    /** Se o c¢digo da situa‡Æo for inativo pega o valor do parƒmetro 46 (ab0101) como valor para o campo da causa desativa‡Æo **/
    find first mab-sit-eqpto
        where mab-sit-eqpto.cod-sit-eqpto = TTmco-movto-compon.cod-sit-eqpto no-lock no-error.
    if avail mab-sit-eqpto then do:
        if mab-sit-eqpto.idi-tip = 2 /*inativo*/ then do:
            /*for first mab-param 
                where mab-param.cdn-param = 46 no-lock:
                assign overlay(TTmco-movto-compon.cod-livre-1,21,08) = mab-param.des-valor.
            END.*/
            assign overlay(TTmco-movto-compon.cod-livre-1,21,08) = pCdCausaCompon.
        end.
    end.

    run buscaDocumento in hDBOmco-movto-compon (output TTmco-movto-compon.num-docto).

    /** Verifica se Centro Custo atual est  atualizado **/
    if mco-compon.cc-codigo-atual <> "" then do:
        assign TTmco-movto-compon.cc-codigo = mco-compon.cc-codigo-atual.
    end.
    else do:
        assign TTmco-movto-compon.cc-codigo = mco-compon.cc-codigo.
    end.

    run Cria-mco-movto-compon in this-procedure.

end. /* end each mco-compon */

FOR FIRST mab-param
    WHERE mab-param.cdn-param = 47
    AND   mab-param.des-valor = "2" NO-LOCK:
    {utp/ut-liter.i "Alguns componentes nÆo foram inativados e devem ser inativados manualmente"}
    assign cTexto = return-value.
    {utp/ut-liter.i "Componentes nÆo inativados"}
    assign cTexto2 = return-value.
    if c-erro-compon <> "" then do:
        run utp/ut-msgs.p (input "SHOW":U,
                           input 27979,
                           input cTexto + "." + "~~"
                                  + cTexto2 + ": " + c-erro-compon + ".").
    end.
END.

return "OK":U.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piInicializacao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piInicializacao Procedure 
PROCEDURE piInicializacao :
/*------------------------------------------------------------------------------
  Purpose:     piInicializacao
  Parameters:  <none>
  Notes:       Inicializa‡Æo da API
------------------------------------------------------------------------------*/
/* Busca o equipamento passado como parƒmetro */
FOR FIRST mab-eqpto
    WHERE mab-eqpto.ep-codigo = pCodEmp
    AND   mab-eqpto.cod-eqpto = pCodEqpto NO-LOCK:
END.
/* Se este nÆo existir, gera um erro e retorna NOK */
IF NOT AVAIL mab-eqpto THEN DO:
    run piCriaErro in this-procedure (input 391,
                                      input "EMS":U,
                                      input return-value).
    RETURN "NOK":U.
END.

run inicializaHandle in this-procedure.

/** Verifica se o M½dulo de Pneus estÿ implantado **/
if can-find(first funcao where funcao.cd-funcao = "spp-mpn-impl":U
                         and   funcao.ativo     = true) then do:
    
    /** Cria‡Æo da Temp-Table TTmpn-movto-pneu **/
    assign cAcao = pAcao.
    run piCriacaoMovtoPneu in this-procedure.
    
end.

/** Verifica se o M¢dulo de Componentes est  implantado **/
if can-find(first funcao where funcao.cd-funcao = "spp-mco-impl":U
                         and   funcao.ativo     = true) then do:

    /** Cria‡Æo da Temp-Table TTmpn-movto-compon **/
    assign cAcao = pAcao.
    run piCriaMovtoCompon in this-procedure.

end.

run finalizaHandle in this-procedure.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

