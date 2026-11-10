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
{include/i-prgvrs.i ABAPI009 2.00.00.004 } /*** 010004 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i abapi009 MAB}
&ENDIF


/*****************************************************************************
**
**       PROGRAMA: ABAPI009.p
**
**       DATA....: Abril de 2004
**
**       AUTOR...: Roberto Soares Pereira - Cingo
**
**       OBJETIVO: Fazer a Transferˆncia dos Pneus alocados para o Equipamento
**
*****************************************************************************/

/* ***************************  Definitions  ************************** */


{frbo/bofr013.i TTMab-histor-ativid}
{frbo/bofr066.i TTMco-movto-compon}
{frbo/bofr074.i TTMpn-movto-pneu}
{abp/abapi001.i1} /** Temp-table de  Erros **/ 



/** Par³metros **/
define input parameter  table for TTMab-histor-ativid.
define output parameter table for RowErrors.
define input parameter  pAcao as character.

/** Variÿveis Handle **/
DEFINE VARIABLE hDBOmpn-movto-pneu   AS HANDLE                    NO-UNDO.
DEFINE VARIABLE hDBOmco-movto-compon AS HANDLE                    NO-UNDO.
DEFINE VARIABLE hDBOmpn-pneu         AS HANDLE                    NO-UNDO.


/** Variÿveis normais **/
DEFINE VARIABLE c-hora-invertida    AS decimal                    NO-UNDO.
DEFINE VARIABLE i-num-docto         like mpn-movto-pneu.num-docto NO-UNDO.
DEFINE VARIABLE cAcao               AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-texto             AS CHARACTER  format "x(50)"  NO-UNDO.
{utp/ut-glob.i} /** Defini»’o do usuÿrio corrente no EMS **/

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
         HEIGHT             = 10.79
         WIDTH              = 39.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
{abp/ab9000.i}    /** Convers’o de horas **/

run piInicializacao in this-procedure.

{abp/abapi001.i2} /** Cria»’o de Erros **/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-buscaDocumento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaDocumento Procedure 
PROCEDURE buscaDocumento :
/*------------------------------------------------------------------------------
  Purpose:     buscaDocumento
  Parameters:  sa¡da pDoc = N£mero do documento
  Notes:       Busca a pr½xima numera»’o do documento.
------------------------------------------------------------------------------*/
define output parameter pDoc like mpn-movto-pneu.num-docto no-undo.

define buffer bfmpn-movto-pneu for mpn-movto-pneu.

FOR first bfmpn-movto-pneu no-lock:
END.
IF AVAIL bfmpn-movto-pneu THEN DO:
    for last bfmpn-movto-pneu fields(num-docto) no-lock:
        assign  pDoc = bfmpn-movto-pneu.num-docto + 1.
    end.
end.
else 
    assign pDoc = 1.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Cria-mco-movto-compon) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cria-mco-movto-compon Procedure 
PROCEDURE Cria-mco-movto-compon :
/*------------------------------------------------------------------------------
  Purpose:    cria registro mpn-movto-penu
  Parameters: recebe a temp table para cria»’o do registro 
              entrada RowObject2 = Temp-Table da Tabela mco-movto-compon
------------------------------------------------------------------------------*/

FOR FIRST TTmco-movto-compon NO-LOCK:
    /*** M²todo para cria»’o do movimento de componentes ***/
    run criaMovimentoCompon in hDBOmco-movto-compon (input table TTmco-movto-compon,
                                                     input cAcao).
    if return-value = "NOK":U then do:   
        /** Busca Erros da BO **/
        run getRowErrors in hDBOmco-movto-compon (output table RowErrors).
        /** Limpa temp-tables de erros **/
        run emptyRowErrors in hDBOmco-movto-compon.
        return "NOK":U.
    end.

END.

return "OK":U.

END PROCEDURE.

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

FOR FIRST TTmpn-movto-pneu NO-LOCK:
    RUN setaPrograma IN hDBOmpn-movto-pneu (INPUT "ABAPI009":U).
    /*** M²todo para cria»’o do movimento de pneus ***/
    run criaMovimentoPneu in hDBOmpn-movto-pneu  (input table TTmpn-movto-pneu,
                                                  input cAcao).
    if return-value = "NOK":U then do:   
       /** Busca Erros da BO **/
       run getRowErrors in hDBOmpn-movto-pneu (output table RowErrors).
       /** Limpa temp-tables de erros **/
       run emptyRowErrors in hDBOmpn-movto-pneu.
       return "NOK":U.
    end.

END.

return "OK":U.

END PROCEDURE.

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

END PROCEDURE.

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
IF NOT VALID-HANDLE(hDBOmpn-movto-pneu) OR
   hDBOmpn-movto-pneu:TYPE <> "PROCEDURE":U OR
   hDBOmpn-movto-pneu:FILE-NAME <> "frbo/bofr074.p":U THEN DO:
    RUN frbo/bofr074.p PERSISTENT SET hDBOmpn-movto-pneu.
END.

RUN openQueryStatic IN hDBOmpn-movto-pneu (INPUT "Main":U).

IF NOT VALID-HANDLE(hDBOmco-movto-compon) OR
   hDBOmco-movto-compon:TYPE <> "PROCEDURE":U OR
   hDBOmco-movto-compon:FILE-NAME <> "frbo/bofr066.p":U THEN DO:
    RUN frbo/bofr066.p PERSISTENT SET hDBOmco-movto-compon.
END.

RUN openQueryStatic IN hDBOmco-movto-compon (INPUT "Main":U).

return "OK":U.

END PROCEDURE.

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
/** Limpa TTmpn-movto-pneu **/
empty temp-table TTmpn-movto-pneu.

/** Le Tabela par³metros do M½dulo de Pneus**/
find first mpn-param no-lock no-error.
if not avail mpn-param then return "OK":U.

/** Busca nœmero documento **/
run buscaDocumento in this-procedure (output i-num-docto).

/** Lendo a tamp-table TTMab-histor-ativid **/
for each TTMab-histor-ativid:
    /** Busca Registro Pneu **/
    for each  mpn-pneu
        where mpn-pneu.ep-codigo-atual = TTMab-histor-ativid.ep-codigo
        and   mpn-pneu.cod-eqpto-atual = TTMab-histor-ativid.cod-eqpto no-lock:

        /* Converte Para Hora Invertida */    
        run converteParaHoraInvertida (input string(TTMab-histor-ativid.dat-cadastro, "99/99/9999"),
                                       input "000000",
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

        {utp/ut-liter.i "Transferˆncia entre estabelecimentos (bofr013)"}
        assign c-texto = trim(return-value).

        /** Cria registro Temp-Table **/    
        create TTmpn-movto-pneu.
        assign TTmpn-movto-pneu.num-docto            = i-num-docto
               TTmpn-movto-pneu.dat-movto            = TTMab-histor-ativid.dat-cadastro
               TTmpn-movto-pneu.hra-inic-apont       = "000000"
               TTmpn-movto-pneu.hra-fim-apont        = "000000"
               TTmpn-movto-pneu.val-dat-hora-invrtda = c-hora-invertida
               TTmpn-movto-pneu.qti-conserto         = 0
               TTmpn-movto-pneu.cod-pneu             = mpn-pneu.cod-pneu
               TTmpn-movto-pneu.ep-codigo-orig       = mpn-pneu.ep-codigo-atual
               TTmpn-movto-pneu.cod-eqpto-orig       = mpn-pneu.cod-eqpto-atual
               TTmpn-movto-pneu.val-hodom-horim-orig = 0
               TTmpn-movto-pneu.cod-pos-orig         = mpn-pneu.cod-pos-atual
               TTmpn-movto-pneu.cod-estabel-orig     = mpn-pneu.cod-estabel-atual
               TTmpn-movto-pneu.cod-servico          = mpn-param.cod-serv-transf.
        /** Le cadastro de servi»os **/
        for first mpn-serv fields(cd-causa-padr cod-servico log-eqpto-dest log-pos-dest log-estabel-dest) 
            where mpn-serv.cod-servico = mpn-param.cod-serv-transf no-lock:
            assign TTmpn-movto-pneu.cd-causa-padr = mpn-serv.cd-causa-padr.
        end.
        assign TTmpn-movto-pneu.val-sulco-1          = 0
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
               TTmpn-movto-pneu.cod-estabel-dest     = TTMab-histor-ativid.cod-estabel
               TTmpn-movto-pneu.cod-sit-eqpto        = mpn-pneu.cod-sit-pneu-atual
               TTmpn-movto-pneu.idi-consist          = 1 /* Ficha n’o Consistida*/
               TTmpn-movto-pneu.dsl-obs              = c-texto
               TTmpn-movto-pneu.val-km-percur        = 0
               TTmpn-movto-pneu.val-uso-atual        = mpn-pneu.val-uso-atual 
               TTmpn-movto-pneu.log-consist          = no
               TTmpn-movto-pneu.cod-emitente         = 0
               TTmpn-movto-pneu.cod-desen            = " "
               TTmpn-movto-pneu.cod-borracha         = " "
               TTmpn-movto-pneu.val-km-hora-gartia   = 0
               TTmpn-movto-pneu.nr-nota-fis          = " "
               TTmpn-movto-pneu.serie                = " "
               TTmpn-movto-pneu.nat-operacao         = " "
               TTmpn-movto-pneu.dat-entrega          = ?
               &IF "{&mguni_version}" >= "2.071" &THEN
               TTmpn-movto-pneu.ep-codigo-matr       = ""
               &ELSE
               TTmpn-movto-pneu.ep-codigo-matr       = 0
               &ENDIF
               TTmpn-movto-pneu.cod-estabel-matr     = " "
               TTmpn-movto-pneu.cod-matr             = " "
               TTmpn-movto-pneu.val-mater-1          = 0
               TTmpn-movto-pneu.val-mater-2          = 0
               TTmpn-movto-pneu.val-mater-3          = 0
               TTmpn-movto-pneu.log-recus            = no
               TTmpn-movto-pneu.log-medi-sulco       = no
               TTmpn-movto-pneu.ct-codigo            = " "
               TTmpn-movto-pneu.cc-codigo            = " "
               TTmpn-movto-pneu.cod-refer            = " "
               TTmpn-movto-pneu.cod-localiz          = " "
               TTmpn-movto-pneu.lote                 = " "
               TTmpn-movto-pneu.nr-trans             = 0
               TTmpn-movto-pneu.idi-integr           = 1
               TTmpn-movto-pneu.it-codigo            = " "
               TTmpn-movto-pneu.cod-depos            = " ".
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
        assign i-num-docto = i-num-docto + 1.
    end. /* end each mpn-pneu */

end.

run Cria-mpn-movto-pneu in this-procedure.



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
/** Limpa TTmco-movto-compon **/
empty temp-table TTmco-movto-compon.

/** Busca nœmero documento **/
run buscaDocumento in this-procedure (output i-num-docto).

/** Lendo a tamp-table TTMab-histor-ativid **/
for each TTMab-histor-ativid NO-LOCK:
    /** Busca Registro Pneu **/
    for each  mco-compon
        where mco-compon.ep-codigo-atual = TTMab-histor-ativid.ep-codigo
        and   mco-compon.cod-eqpto-atual = TTMab-histor-ativid.cod-eqpto no-lock:

        /* Converte Para Hora Invertida */
        run converteParaHoraInvertida (input string(TTMab-histor-ativid.dat-cadastro, "99/99/9999"),
                                       input "000000",
                                       output c-hora-invertida).

        /***************************************************************************
        ** FO 1248166 - Leites L¡der ----------------------------------------------
        ** NÆo realizar as transferˆncias quando o componente nÆo estava conectado ao 
        ** equipamento na data do hist¢rico 
        ***************************************************************************/
        FOR LAST  mco-movto-compon USE-INDEX mcmvtcmp-02
            WHERE mco-movto-compon.num-seqcial           = mco-compon.num-seqcial
            AND   mco-movto-compon.val-dat-hora-invrtda <= c-hora-invertida NO-LOCK:
        END.
        IF AVAIL mco-movto-compon THEN DO:
            IF mco-movto-compon.idi-tip-movto > 1 THEN DO:
                /*** Valida com movimenta‡Æo **/
                IF mco-compon.ep-codigo-atual <> mco-movto-compon.ep-codigo OR
                   mco-compon.cod-eqpto-atual <> mco-movto-compon.cod-eqpto THEN NEXT.
            END.
        END.
        ELSE DO:
            /** Valida com inicial do pneu quando nÆo encontra movimento **/
            IF mco-compon.ep-codigo-atual <> mco-compon.ep-codigo-inicial OR
               mco-compon.cod-eqpto-atual <> mco-compon.cod-eqpto-inicial THEN NEXT.
        END.
        /***************************************************************************
        ** FO 1248166 - Leites L¡der ----------------------------------------------
        ** NÆo realizar as transferˆncias quando j  existirem movimentos posteriores 
        ** a data do hist¢rico para os componentes
        ***************************************************************************/
        IF CAN-FIND(FIRST mco-movto-compon USE-INDEX mcmvtcmp-02
                    WHERE mco-movto-compon.num-seqcial           = mco-compon.num-seqcial
                    AND   mco-movto-compon.val-dat-hora-invrtda >= c-hora-invertida NO-LOCK) THEN NEXT.
        /**************************************************************************/

        /** Cria registro Temp-Table **/    
        create TTmco-movto-compon.
        assign TTmco-movto-compon.num-docto            = i-num-docto
               TTmco-movto-compon.num-seqcial          = mco-compon.num-seqcial
               TTmco-movto-compon.cod-sub-sist         = mco-compon.cod-sub-sist
               TTmco-movto-compon.dat-movto            = TTMab-histor-ativid.dat-cadastro
               TTmco-movto-compon.cod-compon           = mco-compon.cod-compon
               TTmco-movto-compon.dat-movto            = TTMab-histor-ativid.dat-cadastro
               TTmco-movto-compon.hra-movto            = "000000"
               TTmco-movto-compon.val-dat-hora-invrtda = c-hora-invertida
               TTmco-movto-compon.ep-codigo            = mco-compon.ep-codigo-atual
               TTmco-movto-compon.cod-eqpto            = mco-compon.cod-eqpto-atual
               TTmco-movto-compon.cod-estabel          = TTmab-histor-ativid.cod-estabel
               TTmco-movto-compon.cod-evento           = " "
               TTmco-movto-compon.cod-localiz-compon   = mco-compon.cod-localiz-compon
               TTmco-movto-compon.idi-tip-movto        = 3 /* "Transfer¼ncia" */
               TTmco-movto-compon.nr-ord-produ         = 0
               TTmco-movto-compon.num-seq              = 0
               TTmco-movto-compon.cod-sit-eqpto        = mco-compon.cod-sit-compon-atual
               TTmco-movto-compon.val-uso-final        = 0.

        IF l-usa-unid-negoc THEN DO:
            &IF DEFINED(bf_mnt_ems206b) &THEN
                ASSIGN TTmco-movto-compon.cod-unid-negoc = TTMab-histor-ativid.cod-unid-negoc.
            &ENDIF
        END.

        ASSIGN i-num-docto = i-num-docto + 1.
        IF CAN-FIND(FIRST mab-param
                    WHERE mab-param.cdn-param = 43
                    AND   mab-param.des-valor = "1":U) THEN DO:
            /** Valida se o Centro de Custo da Manuten‡Æo est  informado **/
            IF TTmab-histor-ativid.cod-ccusto-alter <> "":U THEN DO:
                ASSIGN TTmco-movto-compon.cc-codigo = TTmab-histor-ativid.cod-ccusto-alter.
            END.
            ELSE DO:
                ASSIGN TTmco-movto-compon.cc-codigo = TTmab-histor-ativid.cc-codigo.
            END.
        END.
        ELSE DO:
            /** Verifica se Centro Custo atual est  atualizado **/
            IF mco-compon.cc-codigo-atual <> "" THEN DO:
                ASSIGN TTmco-movto-compon.cc-codigo = mco-compon.cc-codigo-atual.
            END.
            ELSE DO:
                ASSIGN TTmco-movto-compon.cc-codigo = mco-compon.cc-codigo.
            END.
        END.
    END. /* end each mco-compon */
END.

run Cria-mco-movto-compon in this-procedure.

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
  Notes:       Inicializa‡Æo da API
------------------------------------------------------------------------------*/

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

