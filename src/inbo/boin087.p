USING rep.imp.*.
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
********************************************************************************/
{include/i-prgvrs.i BOIN087 2.00.00.040 } /*** "010040" 08/10/2026 14:32:17 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin087 MRE}
&ENDIF

{utp/ut-glob.i}
/*--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN087
&GLOBAL-DEFINE DBOVersion
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName despesa-aces
&GLOBAL-DEFINE TableLabel Despesa Acess¢ria
&GLOBAL-DEFINE QueryName qr{&TableName}


/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/
{cdp/cdcfgdis.i}
{inbo/boin087.i RowObject}

{inbo/boin01129.i tt-despesa-aces-tribut}
{inbo/boin01129.i tt-despesa-aces-tribut-aux}
{dibo/bodi01141.i tt-relacto-tributo} /*temp-table do cdapi1005*/

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
{method/dboqry.i}


/*--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Defini»’o de Temp-Table para Cÿlculo dos Impostos */
{dibo/bodi317im2bra.i1 }

{cdp/cdcfgmat.i}

def buffer b-emit-estab   for emitente.
def buffer b-despesa      for despesa-aces.

/* V riaveis Utilizadas para Controle de Programas Espec¡ficos */
def new global shared var i-cod-emit-aux like emitente.cod-emitente no-undo.

def var i-cod-emitente      as int                                       no-undo.
def var c-serie-docto       as char                                      no-undo.
def var c-nro-docto         as char                                      no-undo.
def var c-nat-operacao      as char                                      no-undo.

def var i-empresa           like param-global.empresa-prin               no-undo.
def var l-procedimento-ok   as logical                                   no-undo.
def var h_bodi317im2bra     as handle                                    no-undo.
DEF VAR h-bodi613calc2      AS HANDLE                                    NO-UNDO.
def var l-atualiza-impostos as logical init yes                          no-undo.
def var de-base-pis-aux     as decimal format ">>>>,>>>,>>9.99":U init 0 no-undo.
def var de-valor-pis-aux    as decimal format ">>>>,>>>,>>9.99":U init 0 no-undo.
def var de-base-cofins-aux  as decimal format ">>>>,>>>,>>9.99":U init 0 no-undo.
def var de-valor-cofins-aux as decimal format ">>>>,>>>,>>9.99":U init 0 no-undo.
def var i-nr-horas          as decimal no-undo.
def var i-periodo           as INTEGER no-undo.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "Numero" column-label "Numero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Aluda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistencia".

def var h_api_cta_ctbl       as handle no-undo.
def var h_api_ccusto         as handle no-undo.
def var c-formato-conta      as char no-undo.
def var c-formato-ccusto     as char no-undo.

/* Vari veis conta ctbl */
def var v_cod_cta_ctbl       as char   no-undo.
def var v_titulo_cta_ctbl    as char   no-undo.
def var v_num_tip_cta_ctbl   as int    no-undo.
def var v_num_sit_cta_ctbl   as int    no-undo.
def var v_ind_finalid_cta    as char   no-undo.
/* Vari veis centro de custo */
def var v_cod_ccusto         as char   no-undo.
def var v_titulo_ccusto      as char   no-undo.
def var v_log_utz_ccusto     as log    no-undo.

DEF VAR h-boin01129 AS HANDLE NO-UNDO.

{dibo/bodi613calc.i3}  //defini‡Æo da tb-wt-it-impostoCBSIBS

/*Utilizado no pre-processador {&bf_libera_15_posicoes}*/
define variable c-formato as char format "x(16)" no-undo.

&if '{&bf_libera_15_posicoes}' = 'yes' &then
    assign c-formato = ">>>>>>>>9999999". /* Formato de 15 posi‡äes */
&else
    assign c-formato = ">>>9999999". /* Formato de 10 posi‡äes */
&endif

/*Desenvolvimento referente a altera‡Æo de casas decimais PIS/COFINS*/
DEFINE VARIABLE de-aliquota-pis        AS DECIMAL FORMAT ">9.9999" NO-UNDO.
DEFINE VARIABLE de-aliquota-cofins     AS DECIMAL FORMAT ">9.9999" NO-UNDO.
DEFINE VARIABLE h-cdapi995             AS HANDLE                   NO-UNDO.

/* Definicao/atribuicao da variave l-mult-natur-receb -> Usa multiplas naturezas no recebimento */
{cdp/cd9701.i}

/*****defini‡Æo de v riaveis para calcular o vencimento (CD9020.i7)********/
DEFINE VARIABLE i-ind              AS   INTEGER                 NO-UNDO.
DEFINE VARIABLE dat-tipo-dia       LIKE calen-coml.tipo-dia     NO-UNDO.
DEFINE VARIABLE da-data            AS   DATE    EXTENT 12       NO-UNDO.
DEFINE VARIABLE da-partida         AS   DATE                    NO-UNDO.


DEF VAR iCodFornAc  LIKE despesa-aces.cod-forn-ac NO-UNDO.
DEF VAR cSerDoctoAc LIKE despesa-aces.ser-docto-ac NO-UNDO.
DEF VAR cNroDoctoAc LIKE despesa-aces.nro-docto-ac NO-UNDO.
DEF VAR cNatOperAc  LIKE despesa-aces.nat-oper-ac NO-UNDO.

DEF VAR h-cdapi1005        AS HANDLE                             NO-UNDO.
DEF VAR dAliq              LIKE relacto-tributo.aliquota         NO-UNDO.
DEF VAR dPercDifer         LIKE relacto-tributo.perc-diferido    NO-UNDO.
DEF VAR dPercRed           LIKE relacto-tributo.perc-red         NO-UNDO.
DEF VAR dPercCredPresum    LIKE relacto-tributo.perc-cred-presum NO-UNDO.
DEF VAR dAliqDeson         LIKE relacto-tributo.aliquota         NO-UNDO.
DEF VAR dPercRedAliqGov    AS DECIMAL                            NO-UNDO.


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
         HEIGHT             = 14.33
         WIDTH              = 39.
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

    find first param-global no-lock no-error.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram
PROCEDURE afterCreateRecord :

    RUN pi-gravar-dados-cfg-trib.
    RUN saveDescBCPisCofins.
    RUN efetivaTtDespesaAcesTribut.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram
PROCEDURE afterDeleteRecord :

    FOR EACH ct-trib-despesa-aces EXCLUSIVE-LOCK
       WHERE ct-trib-despesa-aces.cod-emitente    = RowObject.cod-emitente
         AND ct-trib-despesa-aces.serie-docto     = RowObject.serie-docto
         AND ct-trib-despesa-aces.nro-docto       = RowObject.nro-docto
         AND ct-trib-despesa-aces.nat-operacao    = RowObject.nat-operacao
         AND ct-trib-despesa-aces.cod-emitente-ac = RowObject.cod-forn-ac
         AND ct-trib-despesa-aces.serie-docto-ac  = RowObject.ser-docto-ac
         AND ct-trib-despesa-aces.nro-docto-ac    = RowObject.nro-docto-ac
         AND ct-trib-despesa-aces.nat-operacao-ac = RowObject.nat-oper-ac:
        DELETE ct-trib-despesa-aces.
    END.

    FOR EACH despesa-aces-tribut EXCLUSIVE-LOCK
       WHERE despesa-aces-tribut.cod-emitente    = RowObject.cod-emitente
         AND despesa-aces-tribut.serie-docto     = RowObject.serie-docto
         AND despesa-aces-tribut.nro-docto       = RowObject.nro-docto
         AND despesa-aces-tribut.nat-operacao    = RowObject.nat-operacao
         AND despesa-aces-tribut.cod-emitente-ac = RowObject.cod-forn-ac
         AND despesa-aces-tribut.serie-docto-ac  = RowObject.ser-docto-ac
         AND despesa-aces-tribut.nro-docto-ac    = RowObject.nro-docto-ac
         AND despesa-aces-tribut.nat-operacao-ac = RowObject.nat-oper-ac:
         DELETE despesa-aces-tribut.
    END.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterNewRecord DBOProgram
PROCEDURE afterNewRecord :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    IF  not avail docum-est then
        return "NOK":U.

    run findUsuario.

    run findEstabelec ( docum-est.cod-estabel ).
    run findEmitente ( docum-est.cod-emitente ).
    assign RowObject.cod-esp         = if  avail param-re then param-re.esp-def-dac
                                       else ""
           RowObject.dt-emissao      = docum-est.dt-emissao
           RowObject.tp-despesa      = if  avail emitente then emitente.tp-desp-padrao
                                       else 0
           RowObject.aliquota-icm    = 0
           RowObject.ser-docto-ac    = if  avail estabelec then estabelec.serie-manual
                                       else "".

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram
PROCEDURE afterUpdateRecord :

    RUN pi-gravar-dados-cfg-trib.
    RUN saveDescBCPisCofins.
    RUN efetivaTtDespesaAcesTribut.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignValueImpostos DBOProgram
PROCEDURE assignValueImpostos :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    find tb-wt-it-imposto
        where tb-wt-it-imposto.seq-wt-docto    = 1
          and tb-wt-it-imposto.seq-wt-it-docto = 1
        exclusive-lock no-error.

    if  avail tb-wt-it-imposto THEN DO:
        assign RowObject.base-icm      = tb-wt-it-imposto.vl-bicms-it
               RowObject.icm-nao-trib  = tb-wt-it-imposto.vl-icmsnt-it
               RowObject.icm-outras    = tb-wt-it-imposto.vl-icmsou-it
               RowObject.icm-deb-cre   = tb-wt-it-imposto.vl-icms-it
               RowObject.icm-complem   = tb-wt-it-imposto.icm-complem
               RowObject.base-subs     = tb-wt-it-imposto.vl-bsubs-it
               RowObject.vl-subs       = tb-wt-it-imposto.vl-icmsub-it.
        OVERLAY(RowObject.char-2,69,20) = SUBSTRING(tb-wt-it-imposto.char-1,296,20).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDestroy DBOProgram
PROCEDURE beforeDestroy :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:  Elimina a BOs da mem¢ria.
------------------------------------------------------------------------------*/
    if  valid-handle (h_bodi317im2bra) then do:
        delete procedure h_bodi317im2bra.
        assign h_bodi317im2bra = ?.
    end.

    IF VALID-HANDLE(h-bodi613calc2) THEN DO:   /*bo configurador*/
        DELETE PROCEDURE h-bodi613calc2.
        ASSIGN h-bodi613calc2 = ?.
    END.

    IF VALID-HANDLE(h-cdapi995) THEN DO:
        RUN pi-finalizar in h-cdapi995.
        ASSIGN h-cdapi995 = ?.
    END.

    IF VALID-HANDLE(h-boin01129) THEN DO:
       DELETE PROCEDURE h-boin01129.
       ASSIGN h-boin01129 = ?.
    END.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculateImpostos DBOProgram
PROCEDURE calculateImpostos :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
        UTILIZADO PELA WEB.
------------------------------------------------------------------------------*/

    def input parameter pType       as   char                     no-undo. /* CREATE / UPDATE */

    if  not avail RowObject
    or  not avail docum-est then
        RETURN "NOK":U.

    run createTbWtDocto_Item_Imposto (RowObject.cod-forn-ac,
                                      RowObject.nat-oper-ac).

    if   pType = "CREATE":U then do:
         run setAliquotaTributacaoICMS ( RowObject.cod-forn-ac,
                                         RowObject.nat-oper-ac ).
    end.

    run calculate_ICMS ( RowObject.valor,
                         RowObject.aliquota-icm,
                         RowObject.cd-trib-icm,
                         RowObject.nat-oper-ac ).

    if  l-atualiza-impostos then
        run assignValueImpostos.

    IF VALID-HANDLE(h_bodi317im2bra) THEN
        DELETE PROCEDURE h_bodi317im2bra.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculate_ICMS DBOProgram
PROCEDURE calculate_ICMS :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def input param piValor        like despesa-aces.valor          no-undo.
    def input param piAliquotaICM  like item-doc-est.aliquota-icm   no-undo.
    def input param piTribICM      like item-doc-est.cd-trib-icm    no-undo.
    def input param piNatOper      like despesa-aces.nat-oper-ac    no-undo.

    run findNaturOper ( piNatOper ).
    if  return-value = "NOK":U then
        return "NOK":U.

    run findEmitente ( input RowObject.cod-forn-ac ).
    if  return-value = "NOK":U then
        return "NOK":U.

    assign RowObject.valor               = piValor
           RowObject.cd-trib-icm         = piTribICM
           RowObject.aliquota-icm        = piAliquotaICM
           RowObject.nat-oper-ac         = piNatOper

           tb-wt-it-docto.vl-merc-ori    = piValor
           tb-wt-it-docto.vl-merc-liq    = piValor
           tb-wt-it-docto.vl-preori      = piValor
           tb-wt-it-docto.vl-preuni      = piValor
           tb-wt-it-docto.vl-merc-s-icms = piValor
           tb-wt-it-docto.vl-merc-tab    = piValor
           tb-wt-it-imposto.aliquota-icm = piAliquotaICM
           tb-wt-it-imposto.cd-trib-icm  = piTribICM
           tb-wt-it-docto.nat-operacao   = RowObject.nat-oper-ac

           tb-wt-docto.nat-operacao      = RowObject.nat-oper-ac
           tb-wt-docto.cod-des-merc      = if  natur-oper.consum-final
                                           then 2
                                           else 1.

    if  valid-handle(h_bodi317im2bra) then do:
        run enviaTbWtDocto in h_bodi317im2bra ( input table tb-wt-docto ) .
        RUN enviaTbWtItImposto in h_bodi317im2bra ( input table tb-wt-it-imposto ) .
        RUN enviaTbWtItDocto in h_bodi317im2bra ( input table tb-wt-it-docto ) .
        RUN localizaWtDocto in h_bodi317im2bra ( input 1,
                                                 output l-procedimento-ok ).
        IF  not l-procedimento-ok then
            RETURN "NOK":U.

        RUN localizaWtItDocto in h_bodi317im2bra ( input 1,
                                                   input 1,
                                                   output l-procedimento-ok ).
        IF  not l-procedimento-ok then
            RETURN "NOK":U.

        RUN localizaWtItImposto in h_bodi317im2bra ( input 1,
                                                     input 1,
                                                     output l-procedimento-ok ).
        IF  not l-procedimento-ok then
            RETURN "NOK":U.



        RUN calculaICMS in h_bodi317im2bra ( input  1,
                                            output l-procedimento-ok).


        RUN calculaICMSComplementar in h_bodi317im2bra ( input  1,
                                                         output l-procedimento-ok).

        RUN retornaTbWtItImposto in h_bodi317im2bra (output table tb-wt-it-imposto).

        find tb-wt-it-imposto
            where tb-wt-it-imposto.seq-wt-docto    = 1
              and tb-wt-it-imposto.seq-wt-it-docto = 1
            exclusive-lock no-error.


        if  avail tb-wt-it-imposto then do:
            if  avail natur-oper and natur-oper.subs-trib then do:
                assign tb-wt-it-imposto.vl-bsubs-it = (tb-wt-it-imposto.vl-bicms-it
                                                  * int(tb-wt-it-imposto.cd-trib-icm = 4
                                                   or tb-wt-it-imposto.cd-trib-icm = 1) )
                                                   + (tb-wt-it-imposto.vl-icmsou-it
                                                   * int(tb-wt-it-imposto.cd-trib-icm = 3) )
                       tb-wt-it-imposto.vl-icmsub-it = tb-wt-it-imposto.vl-icms-it.

                {inbo/boin090.i2 tb-wt-it-imposto.vl-icmsub-it}
            end.
            else
                assign tb-wt-it-imposto.vl-bsubs-it = 0
                       tb-wt-it-imposto.vl-icmsub-it = 0.

        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculate_Pis_Cofins DBOProgram
PROCEDURE calculate_Pis_Cofins :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    def input param piValor          like despesa-aces.valor          no-undo.
    def input param piAliquotaPIS    like item-doc-est.aliquota-icm   no-undo.
    def input param piTribPIS        as int                           no-undo.
    def input param piAliquotaCofins like item-doc-est.aliquota-icm   no-undo.
    def input param piTribCofins     as int                           no-undo.
    def output param piBasePis       as decimal                       no-undo.
    def output param piValorPis      as decimal                       no-undo.
    def output param piBaseCofins    as decimal                       no-undo.
    def output param piValorCofins   as decimal                       no-undo.


    if  piTribPis = 1               /* Tributado */
    OR  piTribPis = 3  then do:     /* Outros */
        assign piBasePis  = piValor
               piValorPis =  round(piBasePis * (piAliquotaPis  / 100),2).
    end.
    else
        assign piBasePis  = piValor
               piValorPis = 0.

    if  piTribCofins = 1             /* Tributado */
    OR  piTribCofins = 3  then do:   /* Outros */
        assign piBaseCofins  = piValor
               piValorCofins = round(piBaseCofins * (piAliquotaCofins  / 100),2).
    end.
    else
        assign piBaseCofins  = piValor
               piValorCofins = 0.

    ASSIGN RowObject.idi-tributac-pis     = piTribPIS
           RowObject.val-aliq-pis         = piAliquotaPIS
           RowObject.val-base-calc-pis    = piBasePis
           RowObject.val-pis              = piValorPis
           RowObject.idi-tributac-cofins  = piTribCofins
           RowObject.val-aliq-cofins      = piAliquotaCofins
           RowObject.val-base-calc-cofins = piBaseCofins
           RowObject.val-cofins           = piValorCofins.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createTbWtDocto_Item_Imposto DBOProgram
PROCEDURE createTbWtDocto_Item_Imposto :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def input parameter piCodFornAc like despesa-aces.cod-forn-ac no-undo.
    def input parameter piNatOperAc like despesa-aces.nat-oper-ac no-undo.

    if  not avail docum-est then
        return "NOK":U.

    run findNaturOper ( piNatOperAc ).

    if  return-value <> "OK":U then
        RETURN "NOK":U.
    run findEmitente  ( piCodFornAc ).
    if  return-value <> "OK":U then
        RETURN "NOK":U.

    run findEstabelec ( docum-est.cod-estabel ).

    if  return-value <> "OK":U then
        RETURN "NOK":U.


    if  not valid-handle(h_bodi317im2bra) then
        run dibo/bodi317im2bra.p persistent set h_bodi317im2bra.

    find tb-wt-docto
        where tb-wt-docto.seq-wt-docto    = 1
        exclusive-lock no-error.
    if  not avail tb-wt-docto then do:
        create tb-wt-docto.
        assign tb-wt-docto.seq-wt-docto = 1.
    end.

    assign tb-wt-docto.cod-des-merc = if  natur-oper.consum-final
                                      then 2
                                      else 1
           tb-wt-docto.cod-emitente = piCodFornAc
           tb-wt-docto.cod-estabel  = docum-est.cod-estabel
           tb-wt-docto.nat-operacao = piNatOperAc
           tb-wt-docto.nome-abrev   = emitente.nome-abrev
           tb-wt-docto.nr-nota      = docum-est.nro-docto
           tb-wt-docto.dt-emis-nota = docum-est.dt-trans
           tb-wt-docto.cidade       = estabelec.cidade
           tb-wt-docto.estado       = estabelec.estado
           tb-wt-docto.pais         = estabelec.pais
           tb-wt-docto.ind-tip-nota = 8.

    find tb-wt-it-docto
        where tb-wt-it-docto.seq-wt-docto    = 1
          and tb-wt-it-docto.seq-wt-it-docto = 1
        exclusive-lock no-error.
    if  not avail tb-wt-it-docto then do:

        create tb-wt-it-docto.
        assign tb-wt-it-docto.seq-wt-docto    = tb-wt-docto.seq-wt-docto
               tb-wt-it-docto.seq-wt-it-docto = 1
               tb-wt-it-docto.nr-seq-nota     = 1.
    end.

    assign tb-wt-it-docto.calcula         = yes
           tb-wt-it-docto.nat-operacao    = piNatOperAc
           tb-wt-it-docto.nr-sequencia    = 10
           tb-wt-it-docto.quantidade[1]   = 1.


    find tb-wt-it-imposto
        where tb-wt-it-imposto.seq-wt-docto    = 1
          and tb-wt-it-imposto.seq-wt-it-docto = 1
        exclusive-lock no-error.

    if  not avail tb-wt-it-imposto then do:
        create tb-wt-it-imposto.
        assign tb-wt-it-imposto.seq-wt-docto    = tb-wt-docto.seq-wt-docto
               tb-wt-it-imposto.seq-wt-it-docto = tb-wt-it-docto.seq-wt-it-docto.
    end.

    assign tb-wt-it-imposto.perc-red-icm    = natur-oper.perc-red-icm.

    if  valid-handle(h_bodi317im2bra) then do:
        run enviaTbWtItImposto in h_bodi317im2bra ( input table tb-wt-it-imposto ) .
        run enviaTbWtItDocto   in h_bodi317im2bra ( input table tb-wt-it-docto ) .
        run enviaTbWtDocto     in h_bodi317im2bra ( input table tb-wt-docto ) .
    end.

    RUN createTempTableImpostosCBSIBS.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE determineValueValid DBOProgram
PROCEDURE determineValueValid :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    find tb-wt-it-imposto
        where tb-wt-it-imposto.seq-wt-docto    = 1
          and tb-wt-it-imposto.seq-wt-it-docto = 1
        exclusive-lock no-error.

    if  avail tb-wt-it-imposto then do:

        if  tb-wt-it-imposto.vl-icms-it = 0
        and RowObject.icm-deb-cre <> 0 then
            assign RowObject.icm-deb-cre = 0.

        if  tb-wt-it-imposto.vl-icmsnt-it = 0
        and RowObject.icm-nao-trib <>  0 then
            assign RowObject.icm-nao-trib = 0.

        if  tb-wt-it-imposto.vl-bicms-it = 0
        and RowObject.base-icm <> 0 then
            assign RowObject.base-icm = 0.

        if  tb-wt-it-imposto.vl-icmsou-it = 0
        and RowObject.icm-outras <> 0 then
            assign RowObject.icm-outras = 0.

        if  SUBSTRING(tb-wt-it-imposto.char-1,296,20) = ""
        and SUBSTRING(RowObject.char-2,69,20) <> "" then
            OVERLAY(RowObject.char-1,69,20) = "".

        if  tb-wt-it-imposto.icm-complem = 0
        and RowObject.icm-complem <> 0 then
            assign RowObject.icm-complem = 0.

        if  tb-wt-it-imposto.vl-bsubs-it = 0
        and RowObject.base-subs <> 0 then
            assign RowObject.base-subs = 0.

        if  tb-wt-it-imposto.vl-icmsub-it = 0
        and RowObject.vl-subs <> 0 then
            assign RowObject.vl-subs = 0.

    end.

    assign v_cod_cta_ctbl = RowObject.ct-tr-fornec.
    if avail docum-est then
        run findContaContabil (input-output v_cod_cta_ctbl, input docum-est.dt-trans, INPUT docum-est.cod-estabel, output v_log_utz_ccusto ).
    else
        run findContaContabil (input-output v_cod_cta_ctbl, input today, INPUT docum-est.cod-estabel, output v_log_utz_ccusto ).

    if  return-value = "NOK":U then
        return "NOK":U.

  /*  assign RowObject.ct-tr-fornec = conta-contab.ct-codigo
           RowObject.sc-tr-fornec = conta-contab.sc-codigo.   */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCGCEmitente DBOProgram
PROCEDURE findCGCEmitente :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def input  param piCGC          like emitente.cgc           no-undo.
    def output param piCodEmitente  like emitente.cod-emitente  no-undo.

    def buffer bf-emitente for emitente.

    assign i-cod-emit-aux = 0.

    for first bf-emitente
       where bf-emitente.cgc = piCGC no-lock:
    end.

    if  avail bf-emitente then
        assign i-cod-emit-aux = bf-emitente.cod-emitente.

    {method/svc/custom/custom.i &Event = "AfterFindCGCEmitente"}

    assign piCodEmitente = i-cod-emit-aux.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCodEsp DBOProgram
PROCEDURE findCodEsp :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def input param piCodEsp   like despesa-aces.cod-esp no-undo.

    if  not avail espec-ap
    or  espec-ap.cod-esp <> piCodEsp then

        for first espec-ap
            fields ( cod-esp  descricao  )
            where espec-ap.cod-esp = piCodEsp no-lock.
        end.

    if  not avail espec-ap then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "'Esp‚cie'" *}
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="TRIM(RETURN-VALUE)"}
        RETURN "NOK":U.
    end.
    else
        RETURN "OK":U.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findContaContabil DBOProgram
PROCEDURE findContaContabil :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def input-output param piCtCodigo     like despesa-aces.ct-tr-fornec no-undo.
    def input        param dt-transacao   like docum-est.dt-trans no-undo.
    def input        param pcod-estabel   like docum-est.cod-estabel no-undo.
    def output       param log-utz-ccusto as log init true no-undo.

    run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output piCtCodigo,         /* CONTA */
                                                   input        dt-transacao,       /* DATA TRANSACAO */
                                                   output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUA›øO DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */

    delete object h_api_cta_ctbl.

    for each tt_log_erro no-lock:
        RUN _insertErrorManual IN THIS-PROCEDURE (INPUT 17006,
                                                  INPUT "EMS":U,
                                                  INPUT "ERROR":U,
                                                  INPUT tt_log_erro.ttv_des_msg_erro + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')',
                                                  INPUT tt_log_erro.ttv_des_msg_ajuda,
                                                  INPUT "":U).
    end.
    if return-value = "NOK" then do:
        RETURN "NOK":U.
    end.
    else do:
        run prgint/utb/utb742za.py persistent set h_api_ccusto.
        /* Verifica se a conta utiliza centro de custo */
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                           input  pcod-estabel,       /* ESTABELECIMENTO EMS2 */
                                                           input  "",                 /* PLANO CONTAS */
                                                           input  piCtCodigo,         /* CONTA */
                                                           input  dt-transacao,       /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro). /* ERROS */

        assign log-utz-ccusto = v_log_utz_ccusto.
        delete object h_api_ccusto.
    end.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCentroCusto DBOProgram
PROCEDURE findCentroCusto :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def input param piScCodigo   like despesa-aces.sc-tr-fornec no-undo.
    def input param dt-transacao like docum-est.dt-trans no-undo.

    run prgint/utb/utb742za.py persistent set h_api_ccusto.

    /* Busca dados do centro de custo */
    run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                               input  "",                 /* CODIGO DO PLANO CCUSTO */
                                               input  piScCodigo,         /* CCUSTO */
                                               input  dt-transacao,       /* DATA DE TRANSACAO */
                                               output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). /* ERROS */

    for each tt_log_erro no-lock:
        RUN _insertErrorManual IN THIS-PROCEDURE (INPUT 17006,
                                                  INPUT "EMS":U,
                                                  INPUT "ERROR":U,
                                                  INPUT tt_log_erro.ttv_des_msg_erro + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')',
                                                  INPUT tt_log_erro.ttv_des_msg_ajuda,
                                                  INPUT "":U).
    end.
    delete object h_api_ccusto.

    if return-value = "NOK" then do:
        RETURN "NOK":U.
    end.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findDocumento DBOProgram
PROCEDURE findDocumento :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def input param piCod-emit   like docum-est.cod-emitente no-undo.
    def input param piSerie      like docum-est.serie-docto  no-undo.
    def input param piNro-docto  like docum-est.nro-docto    no-undo.
    def input param piNat-oper   like docum-est.nat-operacao no-undo.


    if  not avail docum-est
    or  docum-est.serie-docto  <> piSerie
    or  docum-est.nro-docto    <> piNro-docto
    or  docum-est.nat-operacao <> piNat-oper
    or  docum-est.cod-emitente <> piCod-emit then

        for first docum-est
            fields ( serie-docto   nro-docto     nat-operacao
                     cod-emitente  cod-estabel   usuario
                     dt-trans      dt-emissao    ce-atual )

            where docum-est.serie-docto  = piSerie
              and docum-est.nro-docto    = piNro-docto
              and docum-est.nat-operacao = piNat-oper
              and docum-est.cod-emitente = piCod-emit no-lock.
        end.

    if  not avail docum-est then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "'Documento'" *}
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="TRIM(RETURN-VALUE)"}
        RETURN "NOK":U.
    end.
    else
        RETURN "OK":U.


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

    def input param piCodEmitente   like docum-est.cod-emitente no-undo.


    if  not avail emitente
    or  emitente.cod-emitente <> piCodEmitente then

        for first emitente
            where emitente.cod-emitente = piCodEmitente no-lock.
        end.

    if  not avail emitente then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "'Emitente'" *}
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="TRIM(RETURN-VALUE)"}
        RETURN "NOK":U.
    end.
    else
        RETURN "OK":U.

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
    or  estabelec.cod-estabel <> piEstab then do:

        for first estabelec
            fields ( cod-estabel    pais    serie-manual char-2
                     cod-emitente   estado  cidade  ep-codigo

                     &IF '{&bf_dis_versao_ems}' >= '2.06' &THEN
                        idi-tributac-cofins
                     &endif
                                                                   )

            where estabelec.cod-estabel = piEstab no-lock.
        end.

        for first estab-mat
            fields ( cod-estabel cod-cta-fornec-unif cod-ccusto-fornec-unif
                                 cod-cta-frete-unif  cod-ccusto-frete-unif  )
            where estab-mat.cod-estabel = piEstab no-lock.
        end.
    end.

    if  not avail estabelec then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "'Estabelecimento'" *}
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="TRIM(RETURN-VALUE)"}
        RETURN "NOK":U.
    end.
    else do:

        assign i-empresa = estabelec.ep-codigo.

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

    def input param piNatOperacao   like docum-est.nat-operacao no-undo.

    if  not avail natur-oper
    or  natur-oper.nat-operacao <> piNatOperacao then

        for first natur-oper
            fields ( nat-operacao   perc-red-icm  mercado
                     consum-final   denominacao   perc-pis
                     subs-trib      emite-duplic  per-fin-soc
                     cd-trib-icm    tipo-compra   cod-cfop
                     nat-ativa      char-1 )
            where natur-oper.nat-operacao = piNatOperacao no-lock.
        end.

    if  not avail natur-oper then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "'Natureza de Opera‡Æo'" *}
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="TRIM(RETURN-VALUE)"}
        RETURN "NOK":U.
    end.
    else
        RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findParamOf DBOProgram
PROCEDURE findParamOf :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def input param piEstab   like docum-est.cod-estabel no-undo.

    if  not avail param-of
    or  param-of.cod-estabel <> piEstab then do:

        for first param-of
            fields ( cod-estabel char-2

                     &IF '{&bf_dis_versao_ems}' >= '2.06' &THEN
                        dat-pis-recup dat-cofins-recup
                     &endif
                                                                  )
            where param-of.cod-estabel = piEstab no-lock.
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findTipoDespesa DBOProgram
PROCEDURE findTipoDespesa :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def input param piTipoDesp like despesa-aces.tp-despesa no-undo.

    if  not avail tipo-rec-desp
    or  tipo-rec-desp.tp-codigo <> piTipoDesp then

        for first tipo-rec-desp
            fields ( tp-codigo    descricao  )
            where tipo-rec-desp.tp-codigo = piTipoDesp no-lock.
        end.

    if  not avail tipo-rec-desp then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "'Tipo de Despesa'" *}
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="TRIM(RETURN-VALUE)"}
        RETURN "NOK":U.
    end.
    else
        RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findUsuario DBOProgram
PROCEDURE findUsuario :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    if  avail docum-est then do:
        if  not avail param-re
        or  param-re.usuario <> docum-est.usuario then

            for first param-re
                fields ( usuario   esp-def-dac
                         var-emis  dec-1       )
                where param-re.usuario = docum-est.usuario no-lock.
            end.
    end.

    if  not avail param-re
    or  not avail docum-est then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "'Usu rio Recebimento'" *}
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="TRIM(RETURN-VALUE)"}
        RETURN "NOK":U.
    end.
    else
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
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U                     THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U                     THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U                  THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-chave-aces-nf-eletro":U   THEN ASSIGN pFieldValue = RowObject.cod-chave-aces-nf-eletro.
        WHEN "cod-esp":U                    THEN ASSIGN pFieldValue = RowObject.cod-esp.
        WHEN "conta-contabil":U             THEN ASSIGN pFieldValue = RowObject.conta-contabil.
        WHEN "ct-tr-fornec":U               THEN ASSIGN pFieldValue = RowObject.ct-tr-fornec.
        WHEN "nat-oper-ac":U                THEN ASSIGN pFieldValue = RowObject.nat-oper-ac.
        WHEN "nat-operacao":U               THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U                  THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "nro-docto-ac":U               THEN ASSIGN pFieldValue = RowObject.nro-docto-ac.
        WHEN "observacao":U                 THEN ASSIGN pFieldValue = RowObject.observacao.
        WHEN "sc-tr-fornec":U               THEN ASSIGN pFieldValue = RowObject.sc-tr-fornec.
        WHEN "ser-docto-ac":U               THEN ASSIGN pFieldValue = RowObject.ser-docto-ac.
        WHEN "serie-docto":U                THEN ASSIGN pFieldValue = RowObject.serie-docto.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-emissao":U THEN ASSIGN pFieldValue = RowObject.dt-emissao.
        WHEN "dt-vencto":U THEN ASSIGN pFieldValue = RowObject.dt-vencto.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "aliquota-icm":U           THEN ASSIGN pFieldValue = RowObject.aliquota-icm.
        WHEN "base-icm":U               THEN ASSIGN pFieldValue = RowObject.base-icm.
        WHEN "base-icm-complem"         THEN ASSIGN pFieldValue = DEC(SUBSTRING(RowObject.char-2,69,20)).
        WHEN "base-icm-fas[1]":U        THEN ASSIGN pFieldValue = RowObject.base-icm-fas[1].
        WHEN "base-icm-fas[2]":U        THEN ASSIGN pFieldValue = RowObject.base-icm-fas[2].
        WHEN "base-subs":U              THEN ASSIGN pFieldValue = RowObject.base-subs.
        WHEN "base-subs-fasb[1]":U      THEN ASSIGN pFieldValue = RowObject.base-subs-fasb[1].
        WHEN "base-subs-fasb[2]":U      THEN ASSIGN pFieldValue = RowObject.base-subs-fasb[2].
        WHEN "cotacao-dia":U            THEN ASSIGN pFieldValue = RowObject.cotacao-dia.
        WHEN "dec-1":U                  THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U                  THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "icm-comp-fasb[1]":U       THEN ASSIGN pFieldValue = RowObject.icm-comp-fasb[1].
        WHEN "icm-comp-fasb[2]":U       THEN ASSIGN pFieldValue = RowObject.icm-comp-fasb[2].
        WHEN "icm-complem":U            THEN ASSIGN pFieldValue = RowObject.icm-complem.
        WHEN "icm-dc-fasb[1]":U         THEN ASSIGN pFieldValue = RowObject.icm-dc-fasb[1].
        WHEN "icm-dc-fasb[2]":U         THEN ASSIGN pFieldValue = RowObject.icm-dc-fasb[2].
        WHEN "icm-deb-cre":U            THEN ASSIGN pFieldValue = RowObject.icm-deb-cre.
        WHEN "icm-nao-trib":U           THEN ASSIGN pFieldValue = RowObject.icm-nao-trib.
        WHEN "icm-ntr-fasb[1]":U        THEN ASSIGN pFieldValue = RowObject.icm-ntr-fasb[1].
        WHEN "icm-ntr-fasb[2]":U        THEN ASSIGN pFieldValue = RowObject.icm-ntr-fasb[2].
        WHEN "icm-out-fasb[1]":U        THEN ASSIGN pFieldValue = RowObject.icm-out-fasb[1].
        WHEN "icm-out-fasb[2]":U        THEN ASSIGN pFieldValue = RowObject.icm-out-fasb[2].
        WHEN "icm-outras":U             THEN ASSIGN pFieldValue = RowObject.icm-outras.
        WHEN "perc-isr":U               THEN ASSIGN pFieldValue = RowObject.perc-isr.
        WHEN "perc-sales-tax":U         THEN ASSIGN pFieldValue = RowObject.perc-sales-tax.
        WHEN "perc-vat":U               THEN ASSIGN pFieldValue = RowObject.perc-vat.
        WHEN "val-aliq-cofins":U        THEN ASSIGN pFieldValue = RowObject.val-aliq-cofins.
        WHEN "val-aliq-pis":U           THEN ASSIGN pFieldValue = RowObject.val-aliq-pis.
        WHEN "val-base-calc-cofins":U   THEN ASSIGN pFieldValue = RowObject.val-base-calc-cofins.
        WHEN "val-base-calc-pis":U      THEN ASSIGN pFieldValue = RowObject.val-base-calc-pis.
        WHEN "val-cofins":U             THEN ASSIGN pFieldValue = RowObject.val-cofins.
        WHEN "val-pis":U                THEN ASSIGN pFieldValue = RowObject.val-pis.
        WHEN "valor":U                  THEN ASSIGN pFieldValue = RowObject.valor.
        WHEN "valor-fasb[1]":U          THEN ASSIGN pFieldValue = RowObject.valor-fasb[1].
        WHEN "valor-fasb[2]":U          THEN ASSIGN pFieldValue = RowObject.valor-fasb[2].
        WHEN "valor-me":U               THEN ASSIGN pFieldValue = RowObject.valor-me.
        WHEN "vl-isr":U                 THEN ASSIGN pFieldValue = RowObject.vl-isr.
        WHEN "vl-subs":U                THEN ASSIGN pFieldValue = RowObject.vl-subs.
        WHEN "vl-subs-fasb[1]":U        THEN ASSIGN pFieldValue = RowObject.vl-subs-fasb[1].
        WHEN "vl-subs-fasb[2]":U        THEN ASSIGN pFieldValue = RowObject.vl-subs-fasb[2].
        WHEN "vl-taxa":U                THEN ASSIGN pFieldValue = RowObject.vl-taxa.
        WHEN "vl-taxa-me":U             THEN ASSIGN pFieldValue = RowObject.vl-taxa-me.
        WHEN "valor-tot-rt":U           THEN ASSIGN pFieldValue = RowObject.valor-tot-rt.
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

    def input  param pFieldName        as char no-undo.
    def output param pDescription      as char no-undo.

    CASE pFieldName:
        WHEN "nome-emit":U      THEN ASSIGN pDescription = if  avail emitente then
                                                               emitente.nome-emit
                                                           else "".
        WHEN "cgc":U            THEN ASSIGN pDescription = if  avail emitente then
                                                               emitente.cgc
                                                           else "".
        WHEN "desc-natur":U     THEN ASSIGN pDescription = if  avail natur-oper then
                                                               natur-oper.denominacao
                                                           else "".
        WHEN "desc-cod-esp":U   THEN ASSIGN pDescription = if  avail espec-ap then
                                                               espec-ap.descricao
                                                           else "".
        WHEN "desc-tipo-desp":U THEN ASSIGN pDescription = if  avail tipo-rec-desp then
                                                               tipo-rec-desp.descricao
                                                           else "".
        WHEN "desc-conta":U     THEN ASSIGN pDescription = v_titulo_cta_ctbl.
        WHEN "desc-ccusto":U    THEN ASSIGN pDescription = v_titulo_ccusto.
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
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cd-trib-icm":U            THEN ASSIGN pFieldValue = RowObject.cd-trib-icm.
        WHEN "cod-emitente":U           THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-forn-ac":U            THEN ASSIGN pFieldValue = RowObject.cod-forn-ac.
        WHEN "cod-tax":U                THEN ASSIGN pFieldValue = RowObject.cod-tax.
        WHEN "cod-tax-isr":U            THEN ASSIGN pFieldValue = RowObject.cod-tax-isr.
        &if '{&bf_dis_versao_ems}' >= '2.09' &then
            WHEN "idi-natur-frete":U    THEN ASSIGN pFieldValue = RowObject.idi-natur-frete.
        &endif
        WHEN "idi-tributac-cofins":U    THEN ASSIGN pFieldValue = RowObject.idi-tributac-cofins.
        WHEN "idi-tributac-pis":U       THEN ASSIGN pFieldValue = RowObject.idi-tributac-pis.
        WHEN "int-1":U                  THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U                  THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "mo-codigo":U              THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "num-parcela":U            THEN ASSIGN pFieldValue = RowObject.num-parcela.
        WHEN "tp-despesa":U             THEN ASSIGN pFieldValue = RowObject.tp-despesa.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice documento
  Parameters:
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo ser-docto-ac
               retorna valor do campo nro-docto-ac
               retorna valor do campo cod-forn-ac
               retorna valor do campo nat-oper-ac
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE despesa-aces.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE despesa-aces.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE despesa-aces.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE despesa-aces.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pser-docto-ac LIKE despesa-aces.ser-docto-ac NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto-ac LIKE despesa-aces.nro-docto-ac NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-forn-ac LIKE despesa-aces.cod-forn-ac NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-oper-ac LIKE despesa-aces.nat-oper-ac NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           pser-docto-ac = RowObject.ser-docto-ac
           pnro-docto-ac = RowObject.nro-docto-ac
           pcod-forn-ac = RowObject.cod-forn-ac
           pnat-oper-ac = RowObject.nat-oper-ac.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "acresc-financ":U THEN ASSIGN pFieldValue = RowObject.acresc-financ.
        WHEN "log-1":U         THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U         THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-doacao":U    THEN ASSIGN pFieldValue = RowObject.log-doacao.
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
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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
  Purpose:     Reposiciona registro com base no ¡ndice documento
  Parameters:
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo ser-docto-ac
               recebe valor do campo nro-docto-ac
               recebe valor do campo cod-forn-ac
               recebe valor do campo nat-oper-ac
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE despesa-aces.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE despesa-aces.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE despesa-aces.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE despesa-aces.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pser-docto-ac LIKE despesa-aces.ser-docto-ac NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto-ac LIKE despesa-aces.nro-docto-ac NO-UNDO.
    DEFINE INPUT PARAMETER pcod-forn-ac LIKE despesa-aces.cod-forn-ac NO-UNDO.
    DEFINE INPUT PARAMETER pnat-oper-ac LIKE despesa-aces.nat-oper-ac NO-UNDO.

    FIND FIRST bfdespesa-aces WHERE
        bfdespesa-aces.serie-docto = pserie-docto AND
        bfdespesa-aces.nro-docto = pnro-docto AND
        bfdespesa-aces.cod-emitente = pcod-emitente AND
        bfdespesa-aces.nat-operacao = pnat-operacao AND
        bfdespesa-aces.ser-docto-ac = pser-docto-ac AND
        bfdespesa-aces.nro-docto-ac = pnro-docto-ac AND
        bfdespesa-aces.cod-forn-ac = pcod-forn-ac AND
        bfdespesa-aces.nat-oper-ac = pnat-oper-ac NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdespesa-aces THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdespesa-aces)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializeFind DBOProgram
PROCEDURE InitializeFind :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    find first param-estoq no-lock no-error.

    find first param-global no-lock no-error.

    for each tb-wt-docto exclusive-lock:
        delete tb-wt-docto.
    end.

    for each tb-wt-it-docto exclusive-lock:
        delete tb-wt-it-docto.
    end.

    for each tb-wt-it-imposto exclusive-lock:
        delete tb-wt-it-imposto.
    end.

    for each tb-wt-it-impostoCBSIBS exclusive-lock:
        delete tb-wt-it-impostoCBSIBS.
    end.


    IF  not avail docum-est then
        return "NOK":U.

    run findUsuario.

    IF  return-value = "NOK":U then
        return "NOK":U.


    run findEstabelec ( docum-est.cod-estabel ).

    IF  return-value = "NOK":U then
        return "NOK":U.
    run findEmitente ( docum-est.cod-emitente ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToDocumEst DBOProgram
PROCEDURE linkToDocumEst :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def input parameter pHandle as handle no-undo.

    run getKey in pHandle ( output i-cod-emitente,
                            output c-serie-docto,
                            output c-nro-docto,
                            output c-nat-operacao ).

    run findDocumento ( input i-cod-emitente,
                        input c-serie-docto,
                        input c-nro-docto,
                        input c-nat-operacao ).

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

    open query qr{&tableName} for each {&tableName}
         no-lock
        indexed-reposition.


    return "OK":U  .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfDocumEst DBOProgram
PROCEDURE openQueryOfDocumEst :
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
           no-lock
           indexed-reposition.


    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveDescBCPisCofins DBOProgram
PROCEDURE saveDescBCPisCofins :
    DEFINE VARIABLE h-reapi432 AS HANDLE      NO-UNDO.

    IF NOT VALID-HANDLE(h-reapi432) THEN
       RUN rep/reapi432.p PERSISTENT SET h-reapi432.

    RUN emptyTtDespesaAcesTribut IN h-reapi432.
    RUN setHandleDespesaAces     IN h-reapi432 (INPUT BUFFER RowObject:HANDLE).
    RUN calcDescBcPisCofins      IN h-reapi432.
    RUN saveDespesaAcesTribut    IN h-reapi432.


    RETURN "OK":U.
    FINALLY:
        IF VALID-HANDLE(h-reapi432) THEN DO:
            DELETE PROCEDURE h-reapi432 NO-ERROR.
            ASSIGN h-reapi432 = ?.
        END.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gravar-dados-cfg-trib DBOProgram
PROCEDURE pi-gravar-dados-cfg-trib :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    /** eliminar tributos da despesa acessoria **/
    FOR EACH ct-trib-despesa-aces EXCLUSIVE-LOCK
       WHERE ct-trib-despesa-aces.cod-emitente    = RowObject.cod-emitente
         AND ct-trib-despesa-aces.serie-docto     = RowObject.serie-docto
         AND ct-trib-despesa-aces.nro-docto       = RowObject.nro-docto
         AND ct-trib-despesa-aces.nat-operacao    = RowObject.nat-operacao
         AND ct-trib-despesa-aces.cod-emitente-ac = RowObject.cod-forn-ac
         AND ct-trib-despesa-aces.serie-docto-ac  = RowObject.ser-docto-ac
         AND ct-trib-despesa-aces.nro-docto-ac    = RowObject.nro-docto-ac
         AND ct-trib-despesa-aces.nat-operacao-ac = RowObject.nat-oper-ac:
        DELETE ct-trib-despesa-aces.
   END.
   RELEASE ct-trib-despesa-aces.

    FIND FIRST tb-wt-docto NO-LOCK
         WHERE tb-wt-docto.seq-wt-docto = 1 NO-ERROR.

    FOR EACH tb-wt-it-docto NO-LOCK,
        EACH tb-ct-trib-wt-item-docto NO-LOCK
       WHERE tb-ct-trib-wt-item-docto.num-seq-wt-docto      = tb-wt-it-docto.seq-wt-docto
         AND tb-ct-trib-wt-item-docto.num-seq-wt-item-docto = tb-wt-it-docto.seq-wt-it-docto:

        /** gravar tributos da despesa acessoria **/
        CREATE ct-trib-despesa-aces.
        ASSIGN ct-trib-despesa-aces.cod-emitente          = RowObject.cod-emitente
               ct-trib-despesa-aces.serie-docto           = RowObject.serie-docto
               ct-trib-despesa-aces.nro-docto             = RowObject.nro-docto
               ct-trib-despesa-aces.nat-operacao          = RowObject.nat-operacao
               ct-trib-despesa-aces.cod-emitente-ac       = tb-wt-docto.cod-emitente
               ct-trib-despesa-aces.serie-docto-ac        = RowObject.ser-docto-ac
               ct-trib-despesa-aces.nro-docto-ac          = RowObject.nro-docto-ac
               ct-trib-despesa-aces.nat-operacao-ac       = tb-wt-docto.nat-operacao
               ct-trib-despesa-aces.num-seq               = tb-wt-it-docto.seq-wt-it-docto
               ct-trib-despesa-aces.num-ct-trib           = tb-ct-trib-wt-item-docto.num-seq
               ct-trib-despesa-aces.cod-tip-trib          = tb-ct-trib-wt-item-docto.cod-tip-trib
               ct-trib-despesa-aces.cod-configur-trib     = tb-ct-trib-wt-item-docto.cod-configur-trib
               ct-trib-despesa-aces.cod-estab             = tb-wt-docto.cod-estabel.

        ASSIGN ct-trib-despesa-aces.cod-chave-cenar       = tb-ct-trib-wt-item-docto.cod-chave-cenar
               ct-trib-despesa-aces.idi-cod-tributac      = tb-ct-trib-wt-item-docto.idi-cod-tributac
               ct-trib-despesa-aces.val-aliq              = tb-ct-trib-wt-item-docto.val-aliq
               ct-trib-despesa-aces.val-base              = tb-ct-trib-wt-item-docto.val-base-calc
               ct-trib-despesa-aces.val-trib              = tb-ct-trib-wt-item-docto.val-trib
               ct-trib-despesa-aces.val-perc-reduc        = tb-ct-trib-wt-item-docto.val-perc-reduc
               ct-trib-despesa-aces.val-fix-trib          = tb-ct-trib-wt-item-docto.val-fix-trib
               ct-trib-despesa-aces.val-quant-fix         = tb-ct-trib-wt-item-docto.val-quant-fix
               ct-trib-despesa-aces.cod-sit-tributar      = tb-ct-trib-wt-item-docto.cod-sit-tributar
               ct-trib-despesa-aces.cdn-msg-faturam       = tb-ct-trib-wt-item-docto.num-livre-2  /*cod mensag p/ observ nota MFT*/
               ct-trib-despesa-aces.cdn-msg-of            = tb-ct-trib-wt-item-docto.num-livre-3. /*cod mensag p/ observ nota MOF*/

        ASSIGN ct-trib-despesa-aces.cod-memo-calc-base    = tb-ct-trib-wt-item-docto.cod-memo-calc-base
               ct-trib-despesa-aces.cod-memo-calc-trib    = tb-ct-trib-wt-item-docto.cod-memo-calc-trib
               ct-trib-despesa-aces.dat-ult-atualiz       = TODAY
               ct-trib-despesa-aces.hra-ult-atualiz       = STRING(TIME,"HH:MM:SS":U)
               ct-trib-despesa-aces.cod-usuar-ult-atualiz = c-seg-usuario.

        FOR FIRST ct-configur-trib FIELDS(cod-formul-base-calc cod-formul-trib)
            WHERE ct-configur-trib.cod-configur-trib = tb-ct-trib-wt-item-docto.cod-configur-trib NO-LOCK:
            ASSIGN ct-trib-despesa-aces.cod-formul-base-calc  = ct-configur-trib.cod-formul-base-calc
                   ct-trib-despesa-aces.cod-formul-trib       = ct-configur-trib.cod-formul-trib.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processa-config-trib DBOProgram
PROCEDURE processa-config-trib :
    DEFINE VARIABLE l-NT2024002 AS LOGICAL     NO-UNDO.

    ASSIGN l-NT2024002 = CAN-FIND (FIRST funcao NO-LOCK
                                   WHERE funcao.cd-funcao = "spp-NT2024002"
                                     AND funcao.ativo     = YES).

    FOR EACH tb-wt-it-docto EXCLUSIVE-LOCK:
        ASSIGN OVERLAY(tb-wt-it-docto.char-1,100,7) = STRING(RowObject.val-aliq-pis)
               OVERLAY(tb-wt-it-docto.char-1,107,7) = STRING(RowObject.val-aliq-cofins)
               OVERLAY(tb-wt-it-docto.char-2,96,1)  = STRING(RowObject.idi-tributac-pis)
               OVERLAY(tb-wt-it-docto.char-2,97,1)  = STRING(RowObject.idi-tributac-cofins).
    END.

    FOR EACH tb-wt-it-imposto EXCLUSIVE-LOCK:
        ASSIGN tb-wt-it-imposto.vl-pis              = RowObject.val-pis
               tb-wt-it-imposto.vl-cofins           = RowObject.val-cofins.
     END.

    //Executa configurador de tributos
    {inbo/boin176.m99}

    FOR FIRST tb-wt-it-imposto NO-LOCK
        WHERE tb-wt-it-imposto.seq-wt-docto    = 1
          AND tb-wt-it-imposto.seq-wt-it-docto = 1,
         EACH tb-ct-trib-wt-item-docto NO-LOCK
        WHERE tb-ct-trib-wt-item-docto.num-seq-wt-docto      = tb-wt-it-imposto.seq-wt-docto
          AND tb-ct-trib-wt-item-docto.num-seq-wt-item-docto = tb-wt-it-imposto.seq-wt-it-docto:


        FIND FIRST tb-wt-it-docto NO-LOCK
             WHERE tb-wt-it-docto.seq-wt-docto = tb-wt-it-imposto.seq-wt-docto NO-ERROR.

        CASE tb-ct-trib-wt-item-docto.cod-tip-trib:
            WHEN "ICMS" THEN
                ASSIGN RowObject.cd-trib-icm           = tb-wt-it-imposto.cd-trib-icm
                       RowObject.aliquota-icm          = tb-wt-it-imposto.aliquota-icm
                       RowObject.base-icm              = tb-wt-it-imposto.vl-bicms-it
                       RowObject.icm-nao-trib          = tb-wt-it-imposto.vl-icmsnt-it
                       RowObject.icm-outras            = tb-wt-it-imposto.vl-icmsou-it
                       RowObject.icm-deb-cre           = tb-wt-it-imposto.vl-icms-it.
            WHEN "ICMS COMP" THEN
                ASSIGN RowObject.icm-complem           = tb-wt-it-imposto.icm-complem
                       OVERLAY(RowObject.char-2,69,20) = SUBSTRING(tb-wt-it-imposto.char-1,296,20). /*base icms complementar*/

            WHEN "ICMS ST" THEN
                ASSIGN RowObject.base-subs             = tb-wt-it-imposto.vl-bsubs-it
                       RowObject.vl-subs               = tb-wt-it-imposto.vl-icmsub-it.
            WHEN "PIS" THEN
                ASSIGN RowObject.idi-tributac-pis      = tb-ct-trib-wt-item-docto.idi-cod-tributac
                       RowObject.val-aliq-pis          = IF tb-ct-trib-wt-item-docto.val-aliq <> 0
                                                         THEN tb-ct-trib-wt-item-docto.val-aliq
                                                         ELSE DEC(SUBSTRING(tb-wt-it-docto.char-1,100,7))
                       RowObject.val-base-calc-pis     = tb-ct-trib-wt-item-docto.val-base-calc
                       RowObject.val-pis               = tb-ct-trib-wt-item-docto.val-trib.
            WHEN "COFINS" THEN
                ASSIGN RowObject.idi-tributac-cofins   = tb-ct-trib-wt-item-docto.idi-cod-tributac
                       RowObject.val-aliq-cofins       = IF tb-ct-trib-wt-item-docto.val-aliq <> 0 THEN tb-ct-trib-wt-item-docto.val-aliq
                                                         ELSE DEC(SUBSTRING(tb-wt-it-docto.char-1,107,7))
                       RowObject.val-base-calc-cofins  = tb-ct-trib-wt-item-docto.val-base-calc
                       RowObject.val-cofins            = tb-ct-trib-wt-item-docto.val-trib.
            WHEN "CBS":U THEN DO:
                IF l-NT2024002 THEN DO:
                   RUN createTtDespesaAcesTribut (INPUT docum-est.cod-emitente,
                                                  INPUT docum-est.serie-docto,
                                                  INPUT docum-est.nro-docto,
                                                  INPUT docum-est.nat-operacao,
                                                  INPUT iCodFornAc,
                                                  INPUT cSerDoctoAc,
                                                  INPUT cNroDoctoAc,
                                                  INPUT cNatOperAc,
                                                  INPUT rep.imp.Imposto:CBS,
                                                  INPUT AtributoImposto:COD-TRIB,
                                                  INPUT STRING(tb-ct-trib-wt-item-docto.idi-cod-tributac)).

                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:CBS,
                                                   INPUT AtributoImposto:BASE,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-base-calc)).

                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:CBS,
                                                   INPUT AtributoImposto:ALIQUOTA,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-aliq)).


                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:CBS,
                                                   INPUT AtributoImposto:ALIQ-RED,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-perc-reduc)).

                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:CBS,
                                                   INPUT AtributoImposto:ALIQ-EFETIVA,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).

                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:CBS,
                                                   INPUT AtributoImposto:VALOR,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).
                END.
            END.
            WHEN "CBS_Reg" THEN DO:
                IF l-NT2024002  THEN DO:
                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:CBS,
                                                   INPUT AtributoImposto:BASE-REG,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-base-calc)).

                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:CBS,
                                                   INPUT AtributoImposto:ALIQUOTA-REG,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-aliq)).

                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:CBS,
                                                   INPUT AtributoImposto:ALIQ-RED-REG,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-perc-reduc)).

                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:CBS,
                                                   INPUT AtributoImposto:ALIQ-EFETIVA-REG,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).

                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:CBS,
                                                   INPUT AtributoImposto:VALOR-REG,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).

                END.
            END.
			WHEN "CBS_PercDif" THEN DO:
                IF l-NT2024002 THEN
                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:CBS,
                                                   INPUT AtributoImposto:PERC-DIFER,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).
            END.
            WHEN "CBS_ValDif" THEN DO:
                IF l-NT2024002 THEN
                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:CBS,
                                                   INPUT AtributoImposto:VALOR-DIFER,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).
            END.
            WHEN "CBS_ALCZFM" THEN DO:
                IF l-NT2024002 THEN DO:
                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:CBS,
                                                   INPUT AtributoImposto:BASE-ALCZFM,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-base-calc)).
                    RUN createTtDespesaAcesTribut (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:CBS,
                                                   INPUT AtributoImposto:ALIQ-EFETIVA-ALCZFM,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-aliq)).
                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:CBS,
                                                   INPUT AtributoImposto:VALOR-ALCZFM,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).
                END.
            END.
            WHEN "IBSUF":U THEN DO:
                IF l-NT2024002 THEN DO:
                   RUN createTtDespesaAcesTribut (INPUT docum-est.cod-emitente,
                                                  INPUT docum-est.serie-docto,
                                                  INPUT docum-est.nro-docto,
                                                  INPUT docum-est.nat-operacao,
                                                  INPUT iCodFornAc,
                                                  INPUT cSerDoctoAc,
                                                  INPUT cNroDoctoAc,
                                                  INPUT cNatOperAc,
                                                  INPUT rep.imp.Imposto:IBS-UF,
                                                  INPUT AtributoImposto:COD-TRIB,
                                                  INPUT STRING(tb-ct-trib-wt-item-docto.idi-cod-tributac)).

                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:IBS-UF,
                                                   INPUT AtributoImposto:BASE,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-base-calc)).


                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:IBS-UF,
                                                   INPUT AtributoImposto:ALIQUOTA,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-aliq)).

                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:IBS-UF,
                                                   INPUT AtributoImposto:ALIQ-RED,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-perc-reduc)).

                    RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                    INPUT docum-est.serie-docto,
                                                    INPUT docum-est.nro-docto,
                                                    INPUT docum-est.nat-operacao,
                                                    INPUT iCodFornAc,
                                                    INPUT cSerDoctoAc,
                                                    INPUT cNroDoctoAc,
                                                    INPUT cNatOperAc,
                                                    INPUT rep.imp.Imposto:IBS-UF,
                                                    INPUT AtributoImposto:ALIQ-EFETIVA,
                                                    INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).

                    RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                    INPUT docum-est.serie-docto,
                                                    INPUT docum-est.nro-docto,
                                                    INPUT docum-est.nat-operacao,
                                                    INPUT iCodFornAc,
                                                    INPUT cSerDoctoAc,
                                                    INPUT cNroDoctoAc,
                                                    INPUT cNatOperAc,
                                                    INPUT rep.imp.Imposto:IBS-UF,
                                                    INPUT AtributoImposto:VALOR,
                                                    INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).

                END.
            END.
            WHEN "IBSUF_Reg" THEN DO:
                IF l-NT2024002  THEN DO:
                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:IBS-UF,
                                                   INPUT AtributoImposto:BASE-REG,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-base-calc)).

                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:IBS-UF,
                                                   INPUT AtributoImposto:ALIQUOTA-REG,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-aliq)).

                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:IBS-UF,
                                                   INPUT AtributoImposto:ALIQ-RED-REG,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-perc-reduc)).

                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:IBS-UF,
                                                   INPUT AtributoImposto:ALIQ-EFETIVA-REG,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).

                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:IBS-UF,
                                                   INPUT AtributoImposto:VALOR-REG,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).
                END.
            END.
			WHEN "IBSUF_PercDif" THEN DO:
                IF l-NT2024002 THEN
                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:IBS-UF,
                                                   INPUT AtributoImposto:PERC-DIFER,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).
            END.
            WHEN "IBSUF_ValDif" THEN DO:
                IF l-NT2024002 THEN
                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:IBS-UF,
                                                   INPUT AtributoImposto:VALOR-DIFER,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).
            END.
            WHEN "IBSMUN":U THEN DO:
                IF l-NT2024002 THEN DO:
                   RUN createTtDespesaAcesTribut (INPUT docum-est.cod-emitente,
                                                  INPUT docum-est.serie-docto,
                                                  INPUT docum-est.nro-docto,
                                                  INPUT docum-est.nat-operacao,
                                                  INPUT iCodFornAc,
                                                  INPUT cSerDoctoAc,
                                                  INPUT cNroDoctoAc,
                                                  INPUT cNatOperAc,
                                                  INPUT rep.imp.Imposto:IBS-MUN,
                                                  INPUT AtributoImposto:COD-TRIB,
                                                  INPUT STRING(tb-ct-trib-wt-item-docto.idi-cod-tributac)).


                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:IBS-MUN,
                                                   INPUT AtributoImposto:BASE,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-base-calc)).

                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:IBS-MUN,
                                                   INPUT AtributoImposto:ALIQUOTA,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-aliq)).

                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:IBS-MUN,
                                                   INPUT AtributoImposto:ALIQ-RED,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-perc-reduc)).

                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:IBS-MUN,
                                                   INPUT AtributoImposto:ALIQ-EFETIVA,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).

                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:IBS-MUN,
                                                   INPUT AtributoImposto:VALOR,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).
                END.
            END.
            WHEN "IBSMUN_Reg" THEN DO:
                IF l-NT2024002  THEN DO:
                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:IBS-MUN,
                                                   INPUT AtributoImposto:BASE-REG,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-base-calc)).

                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:IBS-MUN,
                                                   INPUT AtributoImposto:ALIQUOTA-REG,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-aliq)).

                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:IBS-MUN,
                                                   INPUT AtributoImposto:ALIQ-RED-REG,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-perc-reduc)).

                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:IBS-MUN,
                                                   INPUT AtributoImposto:ALIQ-EFETIVA-REG,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-livre-2)).

                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:IBS-MUN,
                                                   INPUT AtributoImposto:VALOR-REG,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).
                END.
            END.
            WHEN "IBSMUN_PercDif" THEN DO:
                IF l-NT2024002 THEN
                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:IBS-MUN,
                                                   INPUT AtributoImposto:PERC-DIFER,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).
            END.
            WHEN "IBSMUN_ValDif" THEN DO:
                IF l-NT2024002 THEN
                   RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.serie-docto,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT iCodFornAc,
                                                   INPUT cSerDoctoAc,
                                                   INPUT cNroDoctoAc,
                                                   INPUT cNatOperAc,
                                                   INPUT rep.imp.Imposto:IBS-MUN,
                                                   INPUT AtributoImposto:VALOR-DIFER,
                                                   INPUT STRING(tb-ct-trib-wt-item-docto.val-trib)).
            END.
        END CASE.
    END.

    RUN pi-gravar-dados-cfg-trib.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFormatParamGlobal DBOProgram
PROCEDURE returnFormatParamGlobal :
/*------------------------------------------------------------------------------
  Parameters: c-campo   - recebe o nome do campo com o formato desejado.
              c-formato - retorna o formato do campo recebido como parƒmetro.
  Notes: Retorna o formato parametrizado nos parametros globais (cd0101), do
         campo recebido como parametro.
------------------------------------------------------------------------------*/
    def input  param c-campo   as char no-undo.
    def output param c-formato as char no-undo.

    find first param-global no-lock no-error.

    if  not avail param-global then
        return "NOK":U.

    case c-campo:
         when "formato-cep" then
              assign c-formato = param-global.formato-cep.
         when "formato-conta-contabil" then
              assign c-formato = param-global.formato-conta-contabil.
         when "formato-id-estadual" then
              assign c-formato = param-global.formato-id-estadual.
         when "formato-id-federal" then
              assign c-formato = param-global.formato-id-federal.
         when "formato-id-pessoal" then
              assign c-formato = param-global.formato-id-pessoal.
         when "formato-nr-nota" then
              assign c-formato = param-global.formato-nr-nota.
         otherwise return "NOK":U.
    end case.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnPessoaEmitente DBOProgram
PROCEDURE returnPessoaEmitente :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def input  param piCodEmitente   like docum-est.cod-emitente no-undo.
    def output param piPessoa        like emitente.natureza      no-undo.
    run findEmitente ( input piCodEmitente).
    if  return-value <> "OK":U then
        return "NOK":U.

    assign piPessoa = emitente.natureza.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAliquotaTributacaoIcms DBOProgram
PROCEDURE setAliquotaTributacaoIcms :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def input param piEmitente  like docum-est.cod-emitente no-undo.
    def input param piNaturOper like docum-est.nat-operacao no-undo.

    if  not avail docum-est then
        RETURN "NOK":U.

    assign RowObject.cod-forn-ac = piEmitente
           RowObject.nat-oper-ac = piNaturOper.

    run findEstabelec ( input docum-est.cod-estabel ).
    run findEmitente ( input RowObject.cod-forn-ac ).
    run findNaturOper ( input RowObject.nat-oper-ac ).
    find b-emit-estab
        where b-emit-estab.cod-emitente = estabelec.cod-emitente no-lock no-error.
    assign RowObject.cd-trib-icm = if avail natur-oper then natur-oper.cd-trib-icm
                                   else 0.
    if  valid-handle ( h_bodi317im2bra ) then
        run calculaAliquotaICMS in h_bodi317im2bra ( (if avail b-emit-estab
                                                    then b-emit-estab.contrib-icms
                                                    else yes),

                                                    (if avail b-emit-estab
                                                    then b-emit-estab.natureza
                                                    else 2), /*J*/

                                                    (if avail emitente
                                                     then emitente.estado
                                                     else ""),
                                                    (if avail emitente
                                                     then emitente.pais
                                                     else ""),
                                                    estabelec.estado,
                                                    "",
                                                    RowObject.nat-oper-ac,
                                                    output RowObject.aliquota-icm,
                                                    output l-procedimento-ok ).

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAliquotaTributacaoPisCofins DBOProgram
PROCEDURE setAliquotaTributacaoPisCofins :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def  input param piEmitente         like docum-est.cod-emitente no-undo.
    def  input param piNaturOper        like docum-est.nat-operacao no-undo.
    def output param pi-trib-pis        as int.
    def output param pi-aliquota-pis    AS DEC FORMAT ">>9.9999" DECIMALS 4.
    def output param pi-trib-cofins     as int.
    def output param pi-aliquota-cofins AS DEC FORMAT ">>9.9999" DECIMALS 4.

    if  not avail docum-est then
        RETURN "NOK":U.

    assign RowObject.cod-forn-ac = piEmitente
           RowObject.nat-oper-ac = piNaturOper.

    run findEstabelec ( input docum-est.cod-estabel ).
    if  not avail estabelec then
        RETURN "NOK":U.

    run findEmitente  ( input RowObject.cod-forn-ac ).
    if  not avail emitente then
        RETURN "NOK":U.

    run findNaturOper ( input RowObject.nat-oper-ac ).
    if  not avail natur-oper then
        RETURN "NOK":U.

    run findParamOf ( input docum-est.cod-estabel ).

    assign pi-trib-pis        = 2
           pi-aliquota-pis    = 0
           pi-trib-cofins     = 2
           pi-aliquota-cofins = 0.

    IF NOT VALID-HANDLE (h-cdapi995)  THEN
        RUN cdp/cdapi995.p PERSISTENT SET h-cdapi995.

    /* PIS */
    if (    avail param-of
        and docum-est.dt-emissao >= param-of.dat-pis-recup )
    or (    not avail param-of
        and docum-est.dt-emissao >= 12/01/2002) then do:

        if  estabelec.idi-tributac-cofins = 1 then do:            /* Trib */
            if  int(substring(natur-oper.char-1,86,1)) = 1 then do:   /* Trib */
                if  emitente.idi-tributac-pis = 1 then do: /* Trib */
                    assign pi-trib-pis = 1.
                    IF natur-oper.mercado = 1 THEN DO:
                        /* Projeto 4 Casas Decimais */
                        RUN recupera-aliquotas IN h-cdapi995 (INPUT  "natur-oper",
                                                              INPUT  natur-oper.nat-operacao,
                                                              OUTPUT de-aliquota-pis,
                                                              OUTPUT de-aliquota-cofins).
                        IF de-aliquota-pis = 0 THEN
                            ASSIGN pi-aliquota-pis = natur-oper.perc-pis[1].
                        ELSE
                            ASSIGN pi-aliquota-pis = de-aliquota-pis.
                    END.
                    ELSE
                        IF DEC(SUBSTR(natur-oper.char-1,183,9)) <> 0 THEN /* PIS com 4 decimais */
                            ASSIGN pi-aliquota-pis = DEC(SUBSTR(natur-oper.char-1,183,9)).
                        ELSE
                            ASSIGN pi-aliquota-pis = natur-oper.perc-pis[2].
                end.
            end.
            if  int(substring(natur-oper.char-1,86,1)) = 3 then do:   /* Outros */
                if  emitente.idi-tributac-pis = 1 then do: /* Trib */
                    assign pi-trib-pis    = 3.
                    IF natur-oper.mercado = 1 THEN DO:
                        /* Projeto 4 Casas Decimais */
                        RUN recupera-aliquotas IN h-cdapi995 (INPUT  "natur-oper",
                                                              INPUT  natur-oper.nat-operacao,
                                                              OUTPUT de-aliquota-pis,
                                                              OUTPUT de-aliquota-cofins).
                        IF de-aliquota-pis = 0 THEN
                            ASSIGN pi-aliquota-pis = natur-oper.perc-pis[1].
                        ELSE
                            ASSIGN pi-aliquota-pis = de-aliquota-pis.
                    END.
                    ELSE
                        IF DEC(SUBSTR(natur-oper.char-1,183,9)) <> 0 THEN /* PIS com 4 decimais */
                            ASSIGN pi-aliquota-pis = DEC(SUBSTR(natur-oper.char-1,183,9)).
                        ELSE
                            ASSIGN pi-aliquota-pis = natur-oper.perc-pis[2].
                end.
            end.
        end.
    end.

    /* COFINS */
    if (    avail param-of
        and docum-est.dt-emissao >= param-of.dat-cofins-recup )
    or (    not avail param-of
        and docum-est.dt-emissao >= 02/01/2004) then do:

        if  estabelec.idi-tributac-cofins = 1 then do:            /* Trib */
            if  int(substring(natur-oper.char-1,87,1)) = 1 then do:   /* Trib */
                if  emitente.idi-tributac-cofins = 1 then do:         /* Trib */
                    assign pi-trib-cofins = 1.
                    IF natur-oper.mercado = 1 THEN DO:
                        /* Projeto 4 Casas Decimais */
                        RUN recupera-aliquotas IN h-cdapi995 (INPUT  "natur-oper",
                                                              INPUT  natur-oper.nat-operacao,
                                                              OUTPUT de-aliquota-pis,
                                                              OUTPUT de-aliquota-cofins).
                        IF de-aliquota-cofins = 0 THEN
                            ASSIGN pi-aliquota-cofins = natur-oper.per-fin-soc[1].
                        ELSE
                            ASSIGN pi-aliquota-cofins = de-aliquota-cofins.
                    END.
                    ELSE
                        IF DEC(SUBSTR(natur-oper.char-1,192,9)) <> 0 THEN /* COFINS com 4 decimais */
                            ASSIGN pi-aliquota-cofins = DEC(SUBSTR(natur-oper.char-1,192,9)).
                        ELSE
                            ASSIGN pi-aliquota-cofins = natur-oper.per-fin-soc[2].

                end.
            end.
            if  int(substring(natur-oper.char-1,87,1)) = 3 then do:   /* Outros */
                if  emitente.idi-tributac-cofins   = 1 then do: /* Trib */
                    assign pi-trib-cofins     = 3.
                    IF natur-oper.mercado = 1 THEN DO:
                        /* Projeto 4 Casas Decimais */
                        RUN recupera-aliquotas IN h-cdapi995 (INPUT  "natur-oper",
                                                              INPUT  natur-oper.nat-operacao,
                                                              OUTPUT de-aliquota-pis,
                                                              OUTPUT de-aliquota-cofins).
                        IF de-aliquota-cofins = 0 THEN
                            ASSIGN pi-aliquota-cofins = natur-oper.per-fin-soc[1].
                        ELSE
                            ASSIGN pi-aliquota-cofins = de-aliquota-cofins.
                    END.
                    ELSE
                        IF DEC(SUBSTR(natur-oper.char-1,192,9)) <> 0 THEN /* COFINS com 4 decimais */
                            ASSIGN pi-aliquota-cofins = DEC(SUBSTR(natur-oper.char-1,192,9)).
                        ELSE
                            ASSIGN pi-aliquota-cofins = natur-oper.per-fin-soc[2].
                end.
            end.
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAtualizaImpostos DBOProgram
PROCEDURE setAtualizaImpostos :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def input param pi-seta-atualiza-impostos as logical no-undo.


    assign l-atualiza-impostos = pi-seta-atualiza-impostos.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfDocumEst DBOProgram
PROCEDURE setConstraintOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def input param i-cod-emit  as int  no-undo.
    def input param c-ser-docto as char no-undo.
    def input param c-nr-docto  as char no-undo.
    def input param c-nat-oper  as char no-undo.

        assign i-cod-emitente = i-cod-emit
               c-serie-docto  = c-ser-docto
               c-nro-docto    = c-nr-docto
               c-nat-operacao = c-nat-oper.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsConta DBOProgram
PROCEDURE setDefaultsConta :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def output param piConta   like docum-est.ct-transit no-undo.
    def output param piCCusto  like docum-est.sc-transit no-undo.

    run findEstabelec ( docum-est.cod-estabel ).

    if  not avail natur-oper
    or  not avail estab-mat then
        RETURN "NOK":U.

    assign piConta =  if  RowObject.ct-tr-fornec = ""
                      then if  natur-oper.tipo-compra = 2 /* Nota Frete */
                            then estab-mat.cod-cta-frete-unif
                            else estab-mat.cod-cta-fornec-unif
                      else RowObject.ct-tr-fornec.

    assign piCCusto = if  RowObject.sc-tr-fornec = "" and RowObject.ct-tr-fornec = ""
                      then if  natur-oper.tipo-compra = 2 /* Nota Frete */
                            then estab-mat.cod-ccusto-frete-unif
                            else estab-mat.cod-ccusto-fornec-unif
                      else RowObject.sc-tr-fornec.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsEmitente DBOProgram
PROCEDURE setDefaultsEmitente :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def input  param piEmitente  like despesa-aces.cod-forn-ac no-undo.
    def input  param piDtEmissao like despesa-aces.dt-emissao  no-undo.
    def output param piDtVencto  like despesa-aces.dt-vencto   no-undo.
    def output param piTpDespesa like despesa-aces.tp-despesa  no-undo.

    run findEmitente ( piEmitente ).

    if  return-value = "NOK":U then
        return "NOK":U.

    FIND FIRST docum-est NO-LOCK
         WHERE docum-est.serie-docto  = c-serie-docto
         AND   docum-est.nro-docto    = c-nro-docto
         AND   docum-est.cod-emitente = i-cod-emitente
         AND   docum-est.nat-operacao = c-nat-operacao NO-ERROR.

    for first cond-pagto
        where cond-pagto.cod-cond-pag = emitente.cod-cond-pag no-lock.
    end.
    ASSIGN da-data    = TODAY
           da-partida = docum-est.dt-emissao.

    IF AVAIL cond-pagto THEN DO:

        /*faz o c lculo do vencimento conforme parametros CD0404*/
        {cdp/cd9020.i7 docum-est.cod-estabel}

         ASSIGN i-ind = cond-pagto.num-parcelas.

        IF da-data[i-ind] <> ? AND cond-pagto.num-parcelas = 1 THEN
           ASSIGN piDtVencto = da-data[i-ind].
        ELSE
            ASSIGN piDtVencto = today.
    END.

    assign piTpDespesa = emitente.tp-desp-padrao.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRowidDocumEst DBOProgram
PROCEDURE setRowidDocumEst :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/


    def input param rwDocumEst  as rowid no-undo.

    find docum-est
        where rowid(docum-est) = rwDocumEst no-lock no-error.

    run InitializeFind.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateImpostos DBOProgram
PROCEDURE validateImpostos :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    def var h_boin060   as handle no-undo.

    run inbo/boin060.p persistent set h_boin060.


    /* Base do ICMS da Despesa Acess¢ria nÆo confere */
    run updateConsistNota in h_boin060 ( RowObject.cod-emitente,
                                         RowObject.serie-docto,
                                         RowObject.nro-docto,
                                         RowObject.nat-operacao,
                                         0,
                                         tb-wt-it-imposto.vl-bicms-it = RowObject.base-icm, /*ser for igual elimina senÆo cria*/
                                         tb-wt-it-imposto.vl-bicms-it ,
                                         RowObject.base-icm,
                                         5521,

                                         ( if abs(RowObject.base-icm - tb-wt-it-imposto.vl-bicms-it) > param-re.dec-1 /* diferen»a maior que par³metro */
                                           then 1                                                            /* ent’o erro sen’o advert¼ncia */
                                           else 2 )).


    /* Valor do ICMS da Despesa Acess¢ria nÆo confere */
    run updateConsistNota in h_boin060 ( RowObject.cod-emitente,
                                         RowObject.serie-docto,
                                         RowObject.nro-docto,
                                         RowObject.nat-operacao,
                                         0,
                                         tb-wt-it-imposto.vl-icms-it = RowObject.icm-deb-cre, /*ser for igual elimina senÆo cria*/
                                         tb-wt-it-imposto.vl-icms-it ,
                                         RowObject.icm-deb-cre,
                                         5522,
                                         ( if abs(RowObject.icm-deb-cre - tb-wt-it-imposto.vl-icms-it) > param-re.dec-1 /* diferen‡a maior que parƒmetro */
                                          then 1                                                                        /* entÆo erro senÆo advertˆncia */
                                          else 2)).

    /* Valor do ICMS Complementar nÆo confere com o calculado. */
    run updateConsistNota in h_boin060 ( RowObject.cod-emitente,
                                         RowObject.serie-docto,
                                         RowObject.nro-docto,
                                         RowObject.nat-operacao,
                                         0,
                                         tb-wt-it-imposto.icm-complem = RowObject.icm-complem, /*ser for igual elimina senÆo cria*/
                                         tb-wt-it-imposto.icm-complem ,
                                         RowObject.icm-complem,
                                         18811,
                                         ( if abs(RowObject.icm-complem - tb-wt-it-imposto.icm-complem) > param-re.dec-1 /* diferen‡a maior que parƒmetro */
                                          then 1                                                                         /* entÆo erro senÆo advertˆncia */
                                          else 2)).


    /* Valor de ICMS nÆo tributado nÆo confere com o calculado. */
    run updateConsistNota in h_boin060 ( RowObject.cod-emitente,
                                         RowObject.serie-docto,
                                         RowObject.nro-docto,
                                         RowObject.nat-operacao,
                                         0,
                                         tb-wt-it-imposto.vl-icmsnt-it = RowObject.icm-nao-trib, /*ser for igual elimina senÆo cria*/
                                         tb-wt-it-imposto.vl-icmsnt-it ,
                                         RowObject.icm-nao-trib,
                                         18809,
                                         ( if abs(RowObject.icm-nao-trib - tb-wt-it-imposto.vl-icmsnt-it) > param-re.dec-1 /* diferen‡a maior que parƒmetro */
                                          then 1                                                                           /* entÆo erro senÆo advertˆncia */
                                          else 2)).

    /* Valor de ICMS outras nÆo confere com o calculado. */
    run updateConsistNota in h_boin060 ( RowObject.cod-emitente,
                                         RowObject.serie-docto,
                                         RowObject.nro-docto,
                                         RowObject.nat-operacao,
                                         0,
                                         tb-wt-it-imposto.vl-icmsou-it = RowObject.icm-outras, /*ser for igual elimina senÆo cria*/
                                         tb-wt-it-imposto.vl-icmsou-it ,
                                         RowObject.icm-outras,
                                         18810,
                                         ( if abs(RowObject.icm-outras - tb-wt-it-imposto.vl-icmsou-it) > param-re.dec-1 /* diferen‡a maior que parƒmetro */
                                          then 1                                                                         /* entÆo erro senÆo advertˆncia */
                                          else 2)).

    /* Base da Substitui‡Æo Tribut ria nÆo confere com o calculado. */
    run updateConsistNota in h_boin060 ( RowObject.cod-emitente,
                                         RowObject.serie-docto,
                                         RowObject.nro-docto,
                                         RowObject.nat-operacao,
                                         0,
                                         tb-wt-it-imposto.vl-bsubs-it = RowObject.base-subs, /*ser for igual elimina senÆo cria*/
                                         tb-wt-it-imposto.vl-bsubs-it ,
                                         RowObject.base-subs,
                                         18805,
                                         ( if abs(RowObject.base-subs - tb-wt-it-imposto.vl-bsubs-it) > param-re.dec-1 /* diferen‡a maior que parƒmetro */
                                          then 1                                                                         /* entÆo erro senÆo advertˆncia */
                                          else 2)).

    /* Valor Substitui‡Æo Tribut ria nÆo confere com o calculado. */
    run updateConsistNota in h_boin060 ( RowObject.cod-emitente,
                                         RowObject.serie-docto,
                                         RowObject.nro-docto,
                                         RowObject.nat-operacao,
                                         0,
                                         tb-wt-it-imposto.vl-icmsub-it = RowObject.vl-subs , /*ser for igual elimina senÆo cria*/
                                         tb-wt-it-imposto.vl-icmsub-it ,
                                         RowObject.vl-subs,
                                         18806,
                                         ( if abs(RowObject.vl-subs - tb-wt-it-imposto.vl-icmsub-it) > param-re.dec-1 /* diferen‡a maior que parƒmetro */
                                          then 1                                                                         /* entÆo erro senÆo advertˆncia */
                                          else 2)).


    /* Valor da Base do Pis nÆo confere com o calculado.
    run updateConsistNota in h_boin060 ( RowObject.cod-emitente,
                                         RowObject.serie-docto,
                                         RowObject.nro-docto,
                                         RowObject.nat-operacao,
                                         0,
                                         de-base-pis-aux = dec(substring(RowObject.char-2,7,14)) , /*ser for igual elimina senÆo cria*/
                                         de-base-pis-aux,
                                         dec(substring(RowObject.char-2,7,14)),
                                         5521,
                                         ( if abs( dec(substring(RowObject.char-2,7,14))  - de-base-pis-aux) > param-re.dec-1 /* diferen‡a maior que parƒmetro */
                                          then 1                                                                              /* entÆo erro senÆo advertˆncia */
                                          else 2)).

    /* Valor da Base do Pis nÆo confere com o calculado. */
    run updateConsistNota in h_boin060 ( RowObject.cod-emitente,
                                         RowObject.serie-docto,
                                         RowObject.nro-docto,
                                         RowObject.nat-operacao,
                                         0,
                                         de-valor-pis-aux = dec(substring(RowObject.char-2,21,14)) , /*ser for igual elimina senÆo cria*/
                                         de-valor-pis-aux,
                                         dec(substring(RowObject.char-2,21,14)),
                                         5521,
                                         ( if abs( dec(substring(RowObject.char-2,21,14))  - de-valor-pis-aux) > param-re.dec-1 /* diferen‡a maior que parƒmetro */
                                          then 1                                                                         /* entÆo erro senÆo advertˆncia */
                                          else 2)).

    */

    delete procedure h_boin060.
    assign h_boin060 = ?.

    /* Mensagens de Tela */
    if  avail natur-oper
    and natur-oper.subs-trib
    and tb-wt-it-imposto.vl-bsubs-it <> RowObject.base-subs then do:
        {method/svc/errors/inserr.i
                            &ErrorNumber="18805" /*Valor informado difere do calculado.*/
                            &ErrorType="EMS"
                            &ErrorSubType="WARNING" }
    end.

    if  avail natur-oper
    and natur-oper.subs-trib
    and tb-wt-it-imposto.vl-icmsub-it <> RowObject.vl-subs then do:
        {method/svc/errors/inserr.i
                            &ErrorNumber="18806" /*Valor informado difere do calculado.*/
                            &ErrorType="EMS"
                            &ErrorSubType="WARNING" }
    end.

    if  tb-wt-it-imposto.vl-bicms-it <> RowObject.base-icm then do:
        {method/svc/errors/inserr.i
                            &ErrorNumber="18807" /*Valor informado difere do calculado.*/
                            &ErrorType="EMS"
                            &ErrorSubType="WARNING" }
    end.

    if  tb-wt-it-imposto.vl-icms-it <> RowObject.icm-deb-cre then do:
        {method/svc/errors/inserr.i
                            &ErrorNumber="18808" /*Valor informado difere do calculado.*/
                            &ErrorType="EMS"
                            &ErrorSubType="WARNING" }
    end.

    if  tb-wt-it-imposto.vl-icmsnt-it <> RowObject.icm-nao-trib then do:
        {method/svc/errors/inserr.i
                            &ErrorNumber="18809" /*Valor informado difere do calculado.*/
                            &ErrorType="EMS"
                            &ErrorSubType="WARNING" }
    end.

    if  tb-wt-it-imposto.vl-icmsou-it <> RowObject.icm-outras then do:
        {method/svc/errors/inserr.i
                            &ErrorNumber="18810" /*Valor informado difere do calculado.*/
                            &ErrorType="EMS"
                            &ErrorSubType="WARNING" }
    end.

    if  tb-wt-it-imposto.icm-complem <> RowObject.icm-complem then do:
        {method/svc/errors/inserr.i
                            &ErrorNumber="18811" /*Valor informado difere do calculado.*/
                            &ErrorType="EMS"
                            &ErrorSubType="WARNING" }
    end.

    /* if  de-base-pis-aux <> dec(substring(RowObject.char-2,7,14)) then do:
        {method/svc/errors/inserr.i
                            &ErrorNumber="18807" /*Valor informado difere do calculado.*/
                            &ErrorType="EMS"
                            &ErrorSubType="WARNING" }
    end.

    if  de-valor-pis-aux <> dec(substring(RowObject.char-2,21,14)) then do:
        {method/svc/errors/inserr.i
                            &ErrorNumber="18807" /*Valor informado difere do calculado.*/
                            &ErrorType="EMS"
                            &ErrorSubType="WARNING" }
    end.
    */

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createTtDespesaAcesTribut DBOProgram
PROCEDURE createTtDespesaAcesTribut:
    DEFINE INPUT PARAMETER pCodEmitente  LIKE despesa-aces.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pSerieDocto   LIKE despesa-aces.serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER pNroDocto     LIKE despesa-aces.nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pNatOperacao  LIKE despesa-aces.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pCodFornAc    LIKE despesa-aces.cod-forn-ac  NO-UNDO.
    DEFINE INPUT PARAMETER pSerDoctoAc   LIKE despesa-aces.ser-docto-ac NO-UNDO.
    DEFINE INPUT PARAMETER pNroDoctoAc   LIKE despesa-aces.nro-docto-ac NO-UNDO.
    DEFINE INPUT PARAMETER pNatOperAc    LIKE despesa-aces.nat-oper-ac  NO-UNDO.
    DEFINE INPUT PARAMETER pNomTributo   AS CHARACTER                   NO-UNDO.
    DEFINE INPUT PARAMETER pCampo        AS CHARACTER                   NO-UNDO.
    DEFINE INPUT PARAMETER pCodConteudo  AS CHARACTER                   NO-UNDO.


    FIND FIRST tt-despesa-aces-tribut EXCLUSIVE-LOCK
         WHERE tt-despesa-aces-tribut.cod-emitente       = pCodEmitente
           AND tt-despesa-aces-tribut.serie-docto        = pSerieDocto
           AND tt-despesa-aces-tribut.nro-docto          = pNroDocto
           AND tt-despesa-aces-tribut.nat-operacao       = pNatOperacao
           AND tt-despesa-aces-tribut.cod-emitente-ac    = pCodFornAc
           AND tt-despesa-aces-tribut.serie-docto-ac     = pSerDoctoAc
           AND tt-despesa-aces-tribut.nro-docto-ac       = pNroDoctoAc
           AND tt-despesa-aces-tribut.nat-operacao-ac    = pNatOperAc
           AND tt-despesa-aces-tribut.nom-trib           = pNomTributo
           AND tt-despesa-aces-tribut.cod-campo          = pCampo NO-ERROR.

    IF NOT AVAIL tt-despesa-aces-tribut THEN DO:
        create tt-despesa-aces-tribut.
        assign tt-despesa-aces-tribut.cod-emitente       = pCodEmitente
               tt-despesa-aces-tribut.serie-docto        = pSerieDocto
               tt-despesa-aces-tribut.nro-docto          = pNroDocto
               tt-despesa-aces-tribut.nat-operacao       = pNatOperacao
               tt-despesa-aces-tribut.cod-emitente-ac    = pCodFornAc
               tt-despesa-aces-tribut.serie-docto-ac     = pSerDoctoAc
               tt-despesa-aces-tribut.nro-docto-ac       = pNroDoctoAc
               tt-despesa-aces-tribut.nat-operacao-ac    = pNatOperAc
               tt-despesa-aces-tribut.nom-trib           = pNomTributo
               tt-despesa-aces-tribut.cod-campo          = pCampo.
    END.
    ASSIGN tt-despesa-aces-tribut.cod-conteudo       = pCodConteudo.


    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE efetivaTtDespesaAcesTribut DBOProgram
PROCEDURE efetivaTtDespesaAcesTribut:
    IF NOT VALID-HANDLE(h-boin01129) THEN
        RUN inbo/boin01129.p PERSISTENT SET h-boin01129.

    RUN openQueryStatic IN h-boin01129 (INPUT "Main":U).
    RUN emptyRowErrors  IN h-boin01129.

    FOR EACH tt-despesa-aces-tribut :
        EMPTY TEMP-TABLE tt-despesa-aces-tribut-aux.
        CREATE tt-despesa-aces-tribut-aux.
        BUFFER-COPY tt-despesa-aces-tribut TO tt-despesa-aces-tribut-aux.

        RUN gotokey IN h-boin01129 (INPUT tt-despesa-aces-tribut-aux.cod-emitente,
                                    INPUT tt-despesa-aces-tribut-aux.serie-docto,
                                    INPUT tt-despesa-aces-tribut-aux.nro-docto,
                                    INPUT tt-despesa-aces-tribut-aux.nat-operacao,
                                    INPUT tt-despesa-aces-tribut-aux.cod-emitente-ac,
                                    INPUT tt-despesa-aces-tribut-aux.serie-docto-ac,
                                    INPUT tt-despesa-aces-tribut-aux.nro-docto-ac,
                                    INPUT tt-despesa-aces-tribut-aux.nat-operacao-ac,
                                    INPUT tt-despesa-aces-tribut-aux.nom-trib,
                                    INPUT tt-despesa-aces-tribut-aux.cod-campo).

        IF  RETURN-VALUE = "OK":U THEN DO:
            RUN emptyRowErrors IN h-boin01129.
            RUN setRecord IN h-boin01129 (INPUT TABLE tt-despesa-aces-tribut-aux).
            RUN updateRecord IN h-boin01129.
        END.
        ELSE DO:
            RUN emptyRowErrors IN h-boin01129.
            RUN setRecord IN h-boin01129 (INPUT TABLE tt-despesa-aces-tribut-aux).
            RUN createRecord IN h-boin01129.
        END.
    END.

    FINALLY:
        IF VALID-HANDLE(h-boin01129) THEN DO:
            DELETE PROCEDURE h-boin01129 no-error.
            ASSIGN h-boin01129 = ?.
        END.
    END.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE emptyTtDespesaAcesTribut DBOProgram
PROCEDURE emptyTtDespesaAcesTribut:
    EMPTY TEMP-TABLE tt-despesa-aces-tribut.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    def var de-nro-docto-ac as decimal no-undo.
    def var l-erro          as logical no-undo.

    /*--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida‡äes ---*/

/*    find first param-global no-lock no-error.*/

    run findDocumento ( input RowObject.cod-emitente,
                        input RowObject.serie-docto,
                        input RowObject.nro-docto,
                        input RowObject.nat-operacao ).

    if  return-value <> "OK":U then
        return "NOK":U.

    if  docum-est.ce-atual then do:
        {method/svc/errors/inserr.i
                            &ErrorNumber="19515" /*Nota fiscal j  atualizada*/
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" }
    end.

    IF  pType <> "DELETE":U THEN DO:

        assign rowobject.valor-me = rowobject.valor.

        run findUsuario.

        run findTipoDespesa ( RowObject.tp-despesa ).

        run findCodEsp ( RowObject.cod-esp ).

        run findNaturOper ( RowObject.nat-oper-ac ).

        run findEstabelec ( docum-est.cod-estabel ).

        FIND param-ap WHERE
             param-ap.ep-codigo = i-empresa NO-LOCK NO-ERROR.

        run findEmitente ( RowObject.cod-forn-ac ).

        IF  pType = "CREATE":U then
            run setDefaultsConta (output RowObject.ct-tr-fornec, output RowObject.sc-tr-fornec).

        /***** Atualiza os valores *****/
        run determineValueValid.

        if  not can-find(serie where serie.serie = RowObject.ser-docto-ac) then do:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "'S‚rie'" *}
            {method/svc/errors/inserr.i
                                &ErrorNumber="2"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="TRIM(RETURN-VALUE)" }
        end.


        FIND FIRST emitente
             WHERE emitente.cod-emitente = RowObject.cod-forn-ac NO-LOCK NO-ERROR.

        IF AVAIL emitente
            AND   emitente.identific = 1 /*cliente*/ THEN DO:
             {method/svc/errors/inserr.i
                                 &ErrorNumber="15425"  /*Emitente nÆo pode ser cliente*/
                                 &ErrorType="EMS":U
                                 &ErrorSubType="ERROR":U}

        END.
        if  RowObject.cod-forn-ac = 0 then do:
            {method/svc/errors/inserr.i
                                &ErrorNumber="6189" /*Emitente nÆo pode ser desconhecido*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
        end.


        /*Valida numero da despesa acess¢ria*/
        if  RowObject.nro-docto-ac = "0000000"
        or  RowObject.nro-docto-ac = " "  then do:
          {method/svc/errors/inserr.i
                              &ErrorNumber="16686" /*N£mero do Documento dever ser diferente de zero*/
                              &ErrorType="EMS"
                              &ErrorSubType="ERROR" }
        end.

        if  length(RowObject.nro-docto-ac) > length(c-formato) then do:
            {method/svc/errors/inserr.i
                                &ErrorNumber="36151"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters=length(c-formato)}
        end.

        assign de-nro-docto-ac = dec(RowObject.nro-docto-ac) no-error.
        if (ERROR-STATUS:ERROR
            or (error-status:get-number(1) = 76
            and error-status:num-messages  <> 0))then do:
            {method/svc/errors/inserr.i
                                &ErrorNumber="972"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"}
        end.

        /* Tributacao PIS/COFINS - Reduzido */
        &if '{&bf_dis_versao_ems}' >= '2.06' &then
        if  RowObject.idi-tributac-pis    = 4
        or  RowObject.idi-tributac-cofins = 4 then do:
        &else
        if  int(substr(RowObject.char-2,1,1))  = 4
        or  int(substr(RowObject.char-2,35,1)) = 4 then do:
        &endif

            /* Tributacao invalida p/ Despesa Acessoria/Nota Rateio */
            {method/svc/errors/inserr.i
                                &ErrorNumber="29975"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
        end.

        /*Verifica se j  existe despesa acessoria*/
        IF  pType = "CREATE":U then do:
            find b-despesa
                where b-despesa.cod-emitente = docum-est.cod-emitente
                  and b-despesa.nat-operacao = docum-est.nat-operacao
                  and b-despesa.serie-docto  = docum-est.serie-docto
                  and b-despesa.nro-docto    = docum-est.nro-docto
                  and b-despesa.cod-forn-ac  = RowObject.cod-forn-ac
                  and b-despesa.nat-oper-ac  = RowObject.nat-oper-ac
                  and b-despesa.ser-docto-ac = RowObject.ser-docto-ac
                  and b-despesa.nro-docto-ac = RowObject.nro-docto-ac
                no-lock no-error.
            if  avail b-despesa then do:
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "'Despesa Acess¢ria'" *}
                {method/svc/errors/inserr.i
                                    &ErrorNumber="1"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
            end.

            if  docum-est.cod-emitente = RowObject.cod-forn-ac
            and docum-est.nat-operacao = RowObject.nat-oper-ac
            and docum-est.serie-docto  = RowObject.ser-docto-ac
            and docum-est.nro-docto    = RowObject.nro-docto-ac then do:
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "'Documento'" *}
                {method/svc/errors/inserr.i
                                    &ErrorNumber="1"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
            end.

            /** NÆo pode existir duas notas de despesa acess¢ria **/
            FOR first b-despesa no-lock
                where b-despesa.cod-forn-ac   = RowObject.cod-forn-ac
                  and b-despesa.ser-docto-ac  = RowObject.ser-docto-ac
                  and b-despesa.nro-docto-ac  = RowObject.nro-docto-ac
                  AND b-despesa.nat-oper-ac   = RowObject.nat-oper-ac:
                /* Quando nao tem multiplas naturezas pode ter naturezas diferentes */
                IF NOT (b-despesa.nat-operacao <> RowObject.nat-operacao AND
                        b-despesa.dt-emissao    = RowObject.dt-emissao   AND
                        NOT l-mult-natur-receb) THEN
                    {method/svc/errors/inserr.i
                                    &ErrorNumber="33619"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="b-despesa.nro-docto + '~~~~' + b-despesa.nat-operacao + '~~~~' +
                                                      string(b-despesa.cod-emitente) + '~~~~' + b-despesa.serie-docto"}
            end.
        end.

        /*Valida Conta Cont bil*/
        assign v_cod_cta_ctbl = RowObject.ct-tr-fornec.
        run findContaContabil (input-output v_cod_cta_ctbl, input docum-est.dt-trans, INPUT docum-est.cod-estabel, output v_log_utz_ccusto ).

        if  return-value = "OK" and
            v_num_sit_cta_ctbl <> 3 then do:

            {method/svc/errors/inserr.i
                                &ErrorNumber="1062" /*Conta Cont bil nÆo ‚ de sistema*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
        end.

       /* if  avail conta -contab
        and not can-do("2,7",string(conta -contab.estoque)) then do: */
        if  return-value = "OK"
        AND (lookup({adinc/i05ad049.i 4 2}, v_ind_finalid_cta) = 0 AND
             lookup({adinc/i05ad049.i 4 7}, v_ind_finalid_cta) = 0 ) then do:

            {method/svc/errors/inserr.i
                                &ErrorNumber="4994" /*Conta Cont bil inv lida para documento*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
        end.

        /*Valida Centro de Custo*/
        if v_log_utz_ccusto then
            run findCentroCusto (RowObject.sc-tr-fornec, docum-est.dt-trans).

        /*Valida OF*/
        if  param-global.modulo-of then do:
            find doc-fiscal
                where doc-fiscal.cod-estabel  = docum-est.estab-fisc
                  and doc-fiscal.serie        = RowObject.ser-docto-ac
                  and doc-fiscal.nr-doc-fis   = RowObject.nro-docto-ac
                  and doc-fiscal.cod-emitente = RowObject.cod-forn-ac
                  and doc-fiscal.nat-operacao = RowObject.nat-oper-ac no-lock no-error.
            if  available doc-fiscal then do:
                if  doc-fiscal.dt-docto <> docum-est.dt-trans then do:
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="5136" /*Documento j  existe em OF com data diferente*/
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" }
                end.
                else do:
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="18804" /*Obriga‡äes fiscais inmpede atualiza‡Æo*/
                                        &ErrorType="EMS"
                                        &ErrorSubType="WARNING" }
                end.
            end.
        end.


        /*Valida Datas*/
        if  avail param-re
        and RowObject.dt-emissao < today - param-re.var-emis then do:
            {method/svc/errors/inserr.i
                                &ErrorNumber="270" /*Data Inv lida*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
        end.

        if  RowObject.dt-vencto < RowObject.dt-emissao then do:
            {method/svc/errors/inserr.i
                                &ErrorNumber="3730" /*Data de vencimento menor que data de emissÆo*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
        end.

        if  RowObject.dt-emissao > docum-est.dt-trans then do:
            {method/svc/errors/inserr.i
                                &ErrorNumber="4038" /*Data de emissÆo maior que a data de transa‡Æo*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"}
        end.

        if  avail natur-oper
        and natur-oper.emite-duplic
        and param-global.modulo-ap
        and avail param-ap
        and RowObject.dt-vencto < param-ap.dt-ult-fec then do:
            {method/svc/errors/inserr.i
                                &ErrorNumber="270" /*Data Inv lida*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
        end.



        if  avail emitente
        and avail estabelec
        and avail natur-oper then do:

            assign l-erro = yes.

            if  emitente.estado = estabelec.estado
            and (   natur-oper.nat-operacao begins "1"
                 or natur-oper.nat-operacao begins "5") then
                assign l-erro = no.
            else
                if  emitente.estado <> estabelec.estado
                and emitente.natureza = 3 /*"E"*/
                and (   natur-oper.nat-operacao begins "3"
                     or natur-oper.nat-operacao begins "7") then
                    assign l-erro = no.
                else
                    if  emitente.estado <> estabelec.estado
                    and emitente.natureza <> 3 /*"E"*/
                    and (   natur-oper.nat-operacao begins "2"
                         or natur-oper.nat-operacao begins "6") then
                        assign l-erro = no.

            if  l-erro then do:
                {method/svc/errors/inserr.i
                                &ErrorNumber="19235" /*Natureza de Operacao nao confere com Movimentacao efetuada. Confirma?*/
                                &ErrorType="EMS"
                                &ErrorSubType="WARNING" }
            end.
        end.

        /* Valida Natureza de Opera‡Æo */

        if  avail natur-oper and
                  natur-oper.nat-ativa = no then do:
                  {method/svc/errors/inserr.i
                                       &ErrorNumber="26759" /*Natureza Opera‡Æo Inativa*/
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR" }
        end.

        if  RowObject.cd-trib-icm <> 1
        and RowObject.cd-trib-icm <> 2
        and RowObject.cd-trib-icm <> 3
        and RowObject.cd-trib-icm <> 4 then do:
            {method/svc/errors/inserr.i
                                &ErrorNumber="8490" /*C¢digo de Tributa‡Æo de IPI,ICMS,ISS inv lido*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
        end.

        if  RowObject.valor = int(0) then do:
            {method/svc/errors/inserr.i
                                &ErrorNumber="3263" /*Valor deve ser diferente de zero*/
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
        end.

        find tb-wt-it-imposto
            where tb-wt-it-imposto.seq-wt-docto    = 1
              and tb-wt-it-imposto.seq-wt-it-docto = 1
            exclusive-lock no-error.
        if  not avail tb-wt-it-imposto then do:
            run calculateImpostos ( input pType ).

            FOR FIRST tb-wt-it-imposto
                where tb-wt-it-imposto.seq-wt-docto    = 1
                  and tb-wt-it-imposto.seq-wt-it-docto = 1 EXCLUSIVE-LOCK:

                run calculate_pis_cofins ( input RowObject.valor,
                                           input RowObject.val-aliq-pis,
                                           input RowObject.idi-tributac-pis,
                                           input RowObject.val-aliq-cofins,
                                           input RowObject.idi-tributac-cofins,
                                           output de-base-pis-aux,
                                           output de-valor-pis-aux,
                                           output de-base-cofins-aux,
                                           output de-valor-cofins-aux ).
            END.
        end.

        run validateImpostos.

        IF  AVAIL natur-oper
            AND natur-oper.emite-duplic THEN DO:
            IF  (param-global.modulo-ap = YES) AND NOT CAN-FIND(funcao WHERE funcao.cd-funcao = "adm-apb-ems-5.00"
                                                                         AND funcao.ativo = YES
                                                                         AND funcao.log-1 = YES) THEN DO:
                ASSIGN i-periodo = RowObject.dt-vencto - RowObject.dt-emissao.
                FIND param-ap WHERE
                     param-ap.ep-codigo = i-empresa NO-LOCK NO-ERROR.
                IF  AVAIL param-ap THEN DO:
                    IF  param-ap.prazo-implantacao THEN DO:
                        FOR EACH calen-coml
                           WHERE calen-coml.ep-codigo   = i-empresa
                             AND calen-coml.cod-estabel = docum-est.cod-estabel
                             AND calen-coml.data       >= RowObject.dt-emissao
                             AND calen-coml.data       <= RowObject.dt-vencto
                             AND calen-coml.tipo-dia    > 1 NO-LOCK:
                            ASSIGN i-periodo = i-periodo - 1.
                        END.
                        ASSIGN i-nr-horas = i-periodo * 24.
                        IF  i-nr-horas < param-ap.nr-horas THEN DO:
                            FIND FIRST usuar-permissao-ap
                                 WHERE usuar-permissao-ap.ep-codigo = i-empresa
                                   AND usuar-permissao-ap.usuario = c-seg-usuario NO-LOCK NO-ERROR.
                            IF  AVAIL usuar-permissao-ap AND usuar-permissao-ap.liberar THEN DO:
                                {method/svc/errors/inserr.i
                                                &ErrorNumber="30452"
                                                &ErrorType="EMS"
                                                &ErrorSubType="WARNING" }
                            END.
                            ELSE DO:
                                  {method/svc/errors/inserr.i
                                                  &ErrorNumber="8232"
                                                  &ErrorType="EMS"
                                                  &ErrorSubType="ERROR" }
                            END.
                        END.
                    END.
                END.
            END.
        END.

    end.

    /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE zoomConta DBOProgram
PROCEDURE zoomConta :

     define input parameter p-finalidades   as char format "x(256)" no-undo.
     define input parameter p-dt-trans      as date no-undo.
     define output parameter p-cod-cta-ctbl as char format "x(256)" no-undo.
     define output parameter p-titulo       as char format "x(256)" no-undo.

     run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
     run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,            /* EMPRESA EMS2 */
                                                    input  "CEP",                /* M×DULO */
                                                    input  "",                   /* PLANO DE CONTAS */
                                                    input  p-finalidades,        /* FINALIDADES */
                                                    input  p-dt-trans,           /* DATA TRANSACAO */
                                                    output p-cod-cta-ctbl,       /* CODIGO CONTA */
                                                    output p-titulo,             /* DESCRICAO CONTA */
                                                    output v_ind_finalid_cta,    /* FINALIDADE DA CONTA */
                                                    output table tt_log_erro).   /* ERROS */

     delete object h_api_cta_ctbl.
     if return-value = "OK":U then
        RETURN "OK":U.
     else
        return "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE zoomCentroCusto DBOProgram
PROCEDURE zoomCentroCusto :

     define input  parameter p-dt-trans   as date no-undo.
     define output parameter p-cod-ccusto as char format "x(256)" no-undo.
     define output parameter p-titulo     as char format "x(256)" no-undo.

     run prgint/utb/utb742za.py persistent set h_api_ccusto.
     run pi_zoom_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                         input  "",                 /* CODIGO DO PLANO CCUSTO */
                                         input  "",                 /* UNIDADE DE NEGOCIO */
                                         input  p-dt-trans,         /* DATA DE TRANSACAO */
                                         output p-cod-ccusto,       /* CODIGO CCUSTO */
                                         output p-titulo,           /* DESCRICAO CCUSTO */
                                         output table tt_log_erro). /* ERROS */

     delete object h_api_ccusto.
     if return-value = "OK":U then
        RETURN "OK":U.
     else
        return "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFormatoConta DBOProgram
PROCEDURE getFormatoConta :

     define input  parameter p-dt-trans  as date no-undo.
     define output parameter p-formato   as char format "x(256)" no-undo.

     run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
     /* Retorna formato da conta contabil */
     run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                        input  "",                 /* PLANO CONTAS */
                                                        input  p-dt-trans,         /* DATA DE TRANSACAO */
                                                        output p-formato,          /* FORMATO CONTA */
                                                        output table tt_log_erro). /* ERROS */

     delete object h_api_cta_ctbl.
     if return-value = "OK":U then
        RETURN "OK":U.
     else
        return "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFormatoCentroCusto DBOProgram
PROCEDURE getFormatoCentroCusto :

     define input  parameter p-dt-trans as date no-undo.
     define output parameter p-formato  as char format "x(256)" no-undo.

     run prgint/utb/utb742za.py persistent set h_api_ccusto.
     /* Retorna formato do centro de custo */
     run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                    input  "",                 /* PLANO CCUSTO */
                                                    input  p-dt-trans,         /* DATA DE TRANSACAO */
                                                    output p-formato,          /* FORMATO CCUSTO */
                                                    output table tt_log_erro). /* ERROS */

     delete object h_api_ccusto.
     if return-value = "OK":U then
        RETURN "OK":U.
     else
        return "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sugereCClassTrib DBOProgram
PROCEDURE sugereCClassTrib:

    DEF VAR h-reapi433     AS HANDLE                                 NO-UNDO.
    DEF VAR cClassTrib     LIKE relac-class-trib.cod-cclass-trib     NO-UNDO.
    DEF VAR cCst           LIKE relac-class-trib.cod-cst             NO-UNDO.
    DEF VAR cClassTribReg  LIKE relac-class-trib.cod-cclass-trib-reg NO-UNDO.
    DEF VAR cCstReg        LIKE relac-class-trib.cod-cst-reg         NO-UNDO.


    IF CAN-FIND(FIRST funcao NO-LOCK
              WHERE funcao.cd-funcao = "spp-NT2024002":U
              AND   funcao.ativo)  THEN DO:

        IF  NOT AVAIL docum-est THEN
            RETURN "NOK":U.

        RUN findNaturOper ( cNatOperAc ).
        IF  RETURN-VALUE <> "OK":U THEN
            RETURN "NOK":U.

        run findEmitente  ( iCodFornAc ).
        IF  RETURN-VALUE <> "OK":U THEN
            RETURN "NOK":U.


        IF NOT VALID-HANDLE(h-reapi433) THEN
            RUN rep/reapi433.p PERSISTENT SET h-reapi433.

        RUN emptyTtRelacClassTrib IN h-reapi433.
        RUN setTipoDocto          IN h-reapi433 (INPUT 1). /*Entrada*/
        RUN setDtIniValidade      IN h-reapi433 (INPUT docum-est.dt-emissao).
        RUN setCodEstabel         IN h-reapi433 (INPUT docum-est.cod-estabel).
        RUN setNatOperacao        IN h-reapi433 (INPUT natur-oper.nat-operacao).
        RUN setItCodigo           IN h-reapi433 (INPUT '*').
        RUN setClassifFiscal      IN h-reapi433 (INPUT '*').
        RUN setCodNbs             IN h-reapi433 (INPUT '*'). //Como nÆo tem item na despesa acess¢ria, ser  enviado o valor gen‚rico '*'
        RUN setCodGrupEmit        IN h-reapi433 (INPUT emitente.cod-gr-forn).
        RUN setCodEmitente        IN h-reapi433 (INPUT iCodFornAc).
        RUN setCFOP               IN h-reapi433 (INPUT natur-oper.cod-cfop).
        RUN setIndTributo         IN h-reapi433 (INPUT 1). /*1-IBS/CBS*/
        RUN buscarRelacClassTrib  IN h-reapi433.

         /*Retorna os dados do cClassTrib, CST, cClassTrib regular e CST regular*/
        RUN getCSTcClassTribAndReg   IN h-reapi433 (OUTPUT cClassTrib,
                                                    OUTPUT cCst,
                                                    OUTPUT cClassTribReg,
                                                    OUTPUT cCstReg).


        RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                        INPUT docum-est.serie-docto,
                                        INPUT docum-est.nro-docto,
                                        INPUT docum-est.nat-operacao,
                                        INPUT iCodFornAc,
                                        INPUT cSerDoctoAc,
                                        INPUT cNroDoctoAc,
                                        INPUT cNatOperAc,
                                        INPUT rep.imp.Imposto:CBS,
                                        INPUT rep.imp.AtributoImposto:C-CLASS-TRIB,
                                        INPUT cClassTrib).

        RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                        INPUT docum-est.serie-docto,
                                        INPUT docum-est.nro-docto,
                                        INPUT docum-est.nat-operacao,
                                        INPUT iCodFornAc,
                                        INPUT cSerDoctoAc,
                                        INPUT cNroDoctoAc,
                                        INPUT cNatOperAc,
                                        INPUT rep.imp.Imposto:CBS,
                                        INPUT rep.imp.AtributoImposto:CST,
                                        INPUT cCst).

        RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                        INPUT docum-est.serie-docto,
                                        INPUT docum-est.nro-docto,
                                        INPUT docum-est.nat-operacao,
                                        INPUT iCodFornAc,
                                        INPUT cSerDoctoAc,
                                        INPUT cNroDoctoAc,
                                        INPUT cNatOperAc,
                                        INPUT rep.imp.Imposto:CBS,
                                        INPUT rep.imp.AtributoImposto:C-CLASS-TRIB-REG,
                                        INPUT cClassTribReg).

        RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                        INPUT docum-est.serie-docto,
                                        INPUT docum-est.nro-docto,
                                        INPUT docum-est.nat-operacao,
                                        INPUT iCodFornAc,
                                        INPUT cSerDoctoAc,
                                        INPUT cNroDoctoAc,
                                        INPUT cNatOperAc,
                                        INPUT rep.imp.Imposto:CBS,
                                        INPUT rep.imp.AtributoImposto:CST-REG,
                                        INPUT cCstReg).

        RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                        INPUT docum-est.serie-docto,
                                        INPUT docum-est.nro-docto,
                                        INPUT docum-est.nat-operacao,
                                        INPUT iCodFornAc,
                                        INPUT cSerDoctoAc,
                                        INPUT cNroDoctoAc,
                                        INPUT cNatOperAc,
                                        INPUT rep.imp.Imposto:IBS-UF,
                                        INPUT rep.imp.AtributoImposto:C-CLASS-TRIB,
                                        INPUT cClassTrib).

        RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                        INPUT docum-est.serie-docto,
                                        INPUT docum-est.nro-docto,
                                        INPUT docum-est.nat-operacao,
                                        INPUT iCodFornAc,
                                        INPUT cSerDoctoAc,
                                        INPUT cNroDoctoAc,
                                        INPUT cNatOperAc,
                                        INPUT rep.imp.Imposto:IBS-UF,
                                        INPUT rep.imp.AtributoImposto:CST,
                                        INPUT cCst).

        RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                        INPUT docum-est.serie-docto,
                                        INPUT docum-est.nro-docto,
                                        INPUT docum-est.nat-operacao,
                                        INPUT iCodFornAc,
                                        INPUT cSerDoctoAc,
                                        INPUT cNroDoctoAc,
                                        INPUT cNatOperAc,
                                        INPUT rep.imp.Imposto:IBS-UF,
                                        INPUT rep.imp.AtributoImposto:C-CLASS-TRIB-REG,
                                        INPUT cClassTribReg).

        RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                        INPUT docum-est.serie-docto,
                                        INPUT docum-est.nro-docto,
                                        INPUT docum-est.nat-operacao,
                                        INPUT iCodFornAc,
                                        INPUT cSerDoctoAc,
                                        INPUT cNroDoctoAc,
                                        INPUT cNatOperAc,
                                        INPUT rep.imp.Imposto:IBS-UF,
                                        INPUT rep.imp.AtributoImposto:CST-REG,
                                        INPUT cCstReg).

        RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                        INPUT docum-est.serie-docto,
                                        INPUT docum-est.nro-docto,
                                        INPUT docum-est.nat-operacao,
                                        INPUT iCodFornAc,
                                        INPUT cSerDoctoAc,
                                        INPUT cNroDoctoAc,
                                        INPUT cNatOperAc,
                                        INPUT rep.imp.Imposto:IBS-MUN,
                                        INPUT rep.imp.AtributoImposto:C-CLASS-TRIB,
                                        INPUT cClassTrib).

        RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                        INPUT docum-est.serie-docto,
                                        INPUT docum-est.nro-docto,
                                        INPUT docum-est.nat-operacao,
                                        INPUT iCodFornAc,
                                        INPUT cSerDoctoAc,
                                        INPUT cNroDoctoAc,
                                        INPUT cNatOperAc,
                                        INPUT rep.imp.Imposto:IBS-MUN,
                                        INPUT rep.imp.AtributoImposto:CST,
                                        INPUT cCst).

        RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                        INPUT docum-est.serie-docto,
                                        INPUT docum-est.nro-docto,
                                        INPUT docum-est.nat-operacao,
                                        INPUT iCodFornAc,
                                        INPUT cSerDoctoAc,
                                        INPUT cNroDoctoAc,
                                        INPUT cNatOperAc,
                                        INPUT rep.imp.Imposto:IBS-MUN,
                                        INPUT rep.imp.AtributoImposto:C-CLASS-TRIB-REG,
                                        INPUT cClassTribReg).

        RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                        INPUT docum-est.serie-docto,
                                        INPUT docum-est.nro-docto,
                                        INPUT docum-est.nat-operacao,
                                        INPUT iCodFornAc,
                                        INPUT cSerDoctoAc,
                                        INPUT cNroDoctoAc,
                                        INPUT cNatOperAc,
                                        INPUT rep.imp.Imposto:IBS-MUN,
                                        INPUT rep.imp.AtributoImposto:CST-REG,
                                        INPUT cCstReg).

    END.

    RETURN "OK":U.

    FINALLY:
        IF VALID-HANDLE(h-reapi433) THEN DO:
            DELETE PROCEDURE h-reapi433 NO-ERROR.
            ASSIGN h-reapi433 = ?.
        END.
    END FINALLY.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setScreenValueDesp DBOProgram
PROCEDURE setScreenValueDesp:
    DEF INPUT  PARAMETER pCodFornAc  LIKE despesa-aces.cod-forn-ac NO-UNDO.
    DEF INPUT  PARAMETER pSerDoctoAc LIKE despesa-aces.ser-docto-ac NO-UNDO.
    DEF INPUT  PARAMETER pNroDoctoAc LIKE despesa-aces.nro-docto-ac NO-UNDO.
    DEF INPUT  PARAMETER pNatOperAc  LIKE despesa-aces.nat-oper-ac NO-UNDO.

    ASSIGN  iCodFornAc  = pCodFornAc
            cSerDoctoAc = pSerDoctoAc
            cNroDoctoAc = pNroDoctoAc
            cNatOperAc  = pNatOperAc.


    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sugereAliqTributRt DBOProgram
PROCEDURE sugereAliqTributRt:
    DEFINE OUTPUT PARAM TABLE FOR tt-despesa-aces-tribut.

    EMPTY TEMP-TABLE tt-despesa-aces-tribut .

    /***Aliquotas CBS, IBS UF e IBS Mun*********************************/
    IF CAN-FIND(FIRST funcao NO-LOCK
              WHERE funcao.cd-funcao = "spp-NT2024002":U
              AND   funcao.ativo)  THEN DO:


        IF  NOT AVAIL docum-est THEN
            RETURN "NOK":U.

        RUN findNaturOper ( cNatOperAc ).
        IF  RETURN-VALUE <> "OK":U THEN
            RETURN "NOK":U.

        run findEmitente  ( iCodFornAc ).
        IF  RETURN-VALUE <> "OK":U THEN
            RETURN "NOK":U.

        //ser  utilizado o mesmo da nota principal
        FOR FIRST ext-docum-est NO-LOCK
            WHERE ext-docum-est.serie-docto  = docum-est.serie-docto
              AND ext-docum-est.nro-docto    = docum-est.nro-docto
              AND ext-docum-est.cod-emitente = docum-est.cod-emitente
              AND ext-docum-est.nat-operacao = docum-est.nat-operacao
              AND ext-docum-est.cod-param    = "fatogeradorCBS-IBS":U: END.

        IF NOT VALID-HANDLE(h-cdapi1005) THEN
            RUN cdp/cdapi1005.p PERSISTENT SET h-cdapi1005.

        RUN emptyTtRelactoTributo IN h-cdapi1005.
        RUN setDados              IN h-cdapi1005 (INPUT 1, /*Entrada*/
                                                  INPUT docum-est.dt-emissao,
                                                  INPUT docum-est.cod-estabel,
                                                  INPUT cNatOperAc,
                                                  INPUT '*',
                                                  INPUT '*',
                                                  INPUT emitente.cod-gr-forn,
                                                  INPUT iCodFornAc,
                                                  INPUT natur-oper.cod-cfop,
                                                  INPUT '*',
                                                  INPUT (IF AVAIL ext-docum-est THEN ext-docum-est.cod-livre-1 ELSE docum-est.cidade),  /*cidade*/
                                                  INPUT (IF AVAIL ext-docum-est THEN ext-docum-est.cod-livre-2 ELSE docum-est.uf)). /*UF*/

        RUN setNbs IN h-cdapi1005 (INPUT  '*').  //Como nÆo tem item na despesa acess¢ria, ser  enviado o valor gen‚rico
        RUN gerattcombinacao IN h-cdapi1005.

        ASSIGN dAliq           = 0
               dPercDifer      = 0
               dPercRed        = 0
               dPercCredPresum = 0
               dAliqDeson      = 0
               dPercRedAliqGov = 0.

        RUN emptyTtRelactoTributo IN h-cdapi1005.
        RUN setIndTributo         IN h-cdapi1005 (INPUT 1). /*1-CBS, 2-IBS UF e 3-IBS MUN*/
        RUN buscarRelactotributo  IN h-cdapi1005.
        RUN getTributo            IN h-cdapi1005 (OUTPUT dAliq,
                                                  OUTPUT dPercDifer,
                                                  OUTPUT dPercRed,
                                                  OUTPUT dPercCredPresum,
                                                  OUTPUT dAliqDeson,
                                                  OUTPUT dPercRedAliqGov).

        RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                        INPUT docum-est.serie-docto,
                                        INPUT docum-est.nro-docto,
                                        INPUT docum-est.nat-operacao,
                                        INPUT iCodFornAc,
                                        INPUT cSerDoctoAc,
                                        INPUT cNroDoctoAc,
                                        INPUT cNatOperAc,
                                        INPUT rep.imp.Imposto:CBS,
                                        INPUT AtributoImposto:ALIQUOTA,
                                        INPUT STRING(dAliq)).

        RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                        INPUT docum-est.serie-docto,
                                        INPUT docum-est.nro-docto,
                                        INPUT docum-est.nat-operacao,
                                        INPUT iCodFornAc,
                                        INPUT cSerDoctoAc,
                                        INPUT cNroDoctoAc,
                                        INPUT cNatOperAc,
                                        INPUT rep.imp.Imposto:CBS,
                                        INPUT AtributoImposto:PERC-DIFER,
                                        INPUT STRING(dPercDifer)).

        RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                        INPUT docum-est.serie-docto,
                                        INPUT docum-est.nro-docto,
                                        INPUT docum-est.nat-operacao,
                                        INPUT iCodFornAc,
                                        INPUT cSerDoctoAc,
                                        INPUT cNroDoctoAc,
                                        INPUT cNatOperAc,
                                        INPUT rep.imp.Imposto:CBS,
                                        INPUT AtributoImposto:ALIQ-RED,
                                        INPUT STRING(dPercRed)).

        /*Al¡quota efetiva ALC/ZFM (cadastro de al¡quotas dos tributos) - apenas CBS*/
        EMPTY TEMP-TABLE tt-relacto-tributo.
        RUN getTtRelactoTributo IN h-cdapi1005 (OUTPUT TABLE tt-relacto-tributo).
        FOR FIRST tt-relacto-tributo:
            RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                INPUT docum-est.serie-docto,
                                INPUT docum-est.nro-docto,
                                INPUT docum-est.nat-operacao,
                                INPUT iCodFornAc,
                                INPUT cSerDoctoAc,
                                INPUT cNroDoctoAc,
                                INPUT cNatOperAc,
                                INPUT rep.imp.Imposto:CBS,
                                INPUT AtributoImposto:ALIQ-EFETIVA-ALCZFM,
                                INPUT STRING(tt-relacto-tributo.perc-efet-alczfm)).
        END.


        ASSIGN dAliq           = 0
               dPercDifer      = 0
               dPercRed        = 0
               dPercCredPresum = 0
               dAliqDeson      = 0
               dPercRedAliqGov = 0.

        RUN emptyTtRelactoTributo IN h-cdapi1005.
        RUN setIndTributo         IN h-cdapi1005 (INPUT 2). /*IBS UF*/
        RUN buscarRelactotributo  IN h-cdapi1005.
        RUN getTributo            IN h-cdapi1005 (OUTPUT dAliq,
                                                  OUTPUT dPercDifer,
                                                  OUTPUT dPercRed,
                                                  OUTPUT dPercCredPresum,
                                                  OUTPUT dAliqDeson,
                                                  OUTPUT dPercRedAliqGov).

        RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                        INPUT docum-est.serie-docto,
                                        INPUT docum-est.nro-docto,
                                        INPUT docum-est.nat-operacao,
                                        INPUT iCodFornAc,
                                        INPUT cSerDoctoAc,
                                        INPUT cNroDoctoAc,
                                        INPUT cNatOperAc,
                                        INPUT rep.imp.Imposto:IBS-UF,
                                        INPUT AtributoImposto:ALIQUOTA,
                                        INPUT STRING(dAliq)).

        RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                        INPUT docum-est.serie-docto,
                                        INPUT docum-est.nro-docto,
                                        INPUT docum-est.nat-operacao,
                                        INPUT iCodFornAc,
                                        INPUT cSerDoctoAc,
                                        INPUT cNroDoctoAc,
                                        INPUT cNatOperAc,
                                        INPUT rep.imp.Imposto:IBS-UF,
                                        INPUT AtributoImposto:PERC-DIFER,
                                        INPUT STRING(dPercDifer)).

        RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                        INPUT docum-est.serie-docto,
                                        INPUT docum-est.nro-docto,
                                        INPUT docum-est.nat-operacao,
                                        INPUT iCodFornAc,
                                        INPUT cSerDoctoAc,
                                        INPUT cNroDoctoAc,
                                        INPUT cNatOperAc,
                                        INPUT rep.imp.Imposto:IBS-UF,
                                        INPUT AtributoImposto:ALIQ-RED,
                                        INPUT STRING(dPercRed)).


        ASSIGN dAliq           = 0
               dPercDifer      = 0
               dPercRed        = 0
               dPercCredPresum = 0
               dAliqDeson      = 0
               dPercRedAliqGov = 0.

        RUN emptyTtRelactoTributo IN h-cdapi1005.
        RUN setIndTributo         IN h-cdapi1005 (INPUT 3). /*IBS MUN*/
        RUN buscarRelactotributo  IN h-cdapi1005.
        RUN getTributo            IN h-cdapi1005 (OUTPUT dAliq,
                                                  OUTPUT dPercDifer,
                                                  OUTPUT dPercRed,
                                                  OUTPUT dPercCredPresum,
                                                  OUTPUT dAliqDeson,
                                                  OUTPUT dPercRedAliqGov).

        RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                        INPUT docum-est.serie-docto,
                                        INPUT docum-est.nro-docto,
                                        INPUT docum-est.nat-operacao,
                                        INPUT iCodFornAc,
                                        INPUT cSerDoctoAc,
                                        INPUT cNroDoctoAc,
                                        INPUT cNatOperAc,
                                        INPUT rep.imp.Imposto:IBS-MUN,
                                        INPUT AtributoImposto:ALIQUOTA,
                                        INPUT STRING(dAliq)).

        RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                        INPUT docum-est.serie-docto,
                                        INPUT docum-est.nro-docto,
                                        INPUT docum-est.nat-operacao,
                                        INPUT iCodFornAc,
                                        INPUT cSerDoctoAc,
                                        INPUT cNroDoctoAc,
                                        INPUT cNatOperAc,
                                        INPUT rep.imp.Imposto:IBS-MUN,
                                        INPUT AtributoImposto:PERC-DIFER,
                                        INPUT STRING(dPercDifer)).

        RUN createTtDespesaAcesTribut  (INPUT docum-est.cod-emitente,
                                        INPUT docum-est.serie-docto,
                                        INPUT docum-est.nro-docto,
                                        INPUT docum-est.nat-operacao,
                                        INPUT iCodFornAc,
                                        INPUT cSerDoctoAc,
                                        INPUT cNroDoctoAc,
                                        INPUT cNatOperAc,
                                        INPUT rep.imp.Imposto:IBS-MUN,
                                        INPUT AtributoImposto:ALIQ-RED,
                                        INPUT STRING(dPercRed)).

    END.
    /*******************************************************************/
    FINALLY:
        IF VALID-HANDLE(h-cdapi1005) THEN DO:
            DELETE PROCEDURE h-cdapi1005.
            ASSIGN h-cdapi1005 = ?.
        END.
    END FINALLY.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createTempTableImpostosCBSIBS DBOProgramÿ
PROCEDURE createTempTableImpostosCBSIBS:

    FIND FIRST tb-wt-it-impostoCBSIBS EXCLUSIVE-LOCK
        WHERE tb-wt-it-impostoCBSIBS.seq-wt-docto    = 1
          AND tb-wt-it-impostoCBSIBS.seq-wt-it-docto = 1 NO-ERROR.
    IF NOT AVAIL tb-wt-it-impostoCBSIBS THEN DO:
        CREATE tb-wt-it-impostoCBSIBS.
        ASSIGN tb-wt-it-impostoCBSIBS.seq-wt-docto    = 1
               tb-wt-it-impostoCBSIBS.seq-wt-it-docto = 1.
    END.

    RUN getValAtribTtDespAcesTribut (INPUT rep.imp.Imposto:CBS, INPUT AtributoImposto:ALIQUOTA,   OUTPUT tb-wt-it-impostoCBSIBS.aliquota-cbs).
    if tb-wt-it-impostoCBSIBS.aliquota-cbs = 0 then
        RUN getValAtribTtDespAcesTribut (INPUT rep.imp.Imposto:CBS, INPUT AtributoImposto:ALIQUOTA-REG,   OUTPUT tb-wt-it-impostoCBSIBS.aliquota-cbs).

    RUN getValAtribTtDespAcesTribut (INPUT rep.imp.Imposto:CBS, INPUT AtributoImposto:ALIQ-RED,   OUTPUT tb-wt-it-impostoCBSIBS.perc-red-cbs).
    RUN getValAtribTtDespAcesTribut (INPUT rep.imp.Imposto:CBS, INPUT AtributoImposto:PERC-DIFER, OUTPUT tb-wt-it-impostoCBSIBS.perc-difer-cbs).
    RUN getValAtribTtDespAcesTribut (INPUT rep.imp.Imposto:CBS, INPUT AtributoImposto:ALIQ-EFETIVA-ALCZFM, OUTPUT tb-wt-it-impostoCBSIBS.perc-efet-alczfm-cbs).

    RUN getValAtribTtDespAcesTribut (INPUT rep.imp.Imposto:IBS-UF, INPUT AtributoImposto:ALIQUOTA,   OUTPUT tb-wt-it-impostoCBSIBS.aliquota-ibsuf).
    if  tb-wt-it-impostoCBSIBS.aliquota-ibsuf = 0 then
        RUN getValAtribTtDespAcesTribut (INPUT rep.imp.Imposto:IBS-UF, INPUT AtributoImposto:ALIQUOTA-REG,   OUTPUT tb-wt-it-impostoCBSIBS.aliquota-ibsuf).

    RUN getValAtribTtDespAcesTribut (INPUT rep.imp.Imposto:IBS-UF, INPUT AtributoImposto:ALIQ-RED,   OUTPUT tb-wt-it-impostoCBSIBS.perc-red-ibsuf).
    RUN getValAtribTtDespAcesTribut (INPUT rep.imp.Imposto:IBS-UF, INPUT AtributoImposto:PERC-DIFER, OUTPUT tb-wt-it-impostoCBSIBS.perc-difer-ibsuf).

    RUN getValAtribTtDespAcesTribut (INPUT rep.imp.Imposto:IBS-MUN, INPUT AtributoImposto:ALIQUOTA,   OUTPUT tb-wt-it-impostoCBSIBS.aliquota-ibsmun).
    if tb-wt-it-impostoCBSIBS.aliquota-ibsmun = 0 then
        RUN getValAtribTtDespAcesTribut (INPUT rep.imp.Imposto:IBS-MUN, INPUT AtributoImposto:ALIQUOTA-REG,   OUTPUT tb-wt-it-impostoCBSIBS.aliquota-ibsmun).

    RUN getValAtribTtDespAcesTribut (INPUT rep.imp.Imposto:IBS-MUN, INPUT AtributoImposto:ALIQ-RED,   OUTPUT tb-wt-it-impostoCBSIBS.perc-red-ibsmun).
    RUN getValAtribTtDespAcesTribut (INPUT rep.imp.Imposto:IBS-MUN, INPUT AtributoImposto:PERC-DIFER, OUTPUT tb-wt-it-impostoCBSIBS.perc-difer-ibsmun).

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUMEÿ

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getValAtribTtDespAcesTribut DBOProgram
PROCEDURE getValAtribTtDespAcesTribut:

    DEFINE INPUT  PARAM pImposto    AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAM pAtributo   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM pValorAtrib AS DECIMAL   NO-UNDO.

    FIND FIRST tt-despesa-aces-tribut NO-LOCK
         WHERE tt-despesa-aces-tribut.cod-emitente       = docum-est.cod-emitente
           AND tt-despesa-aces-tribut.serie-docto        = docum-est.serie-docto
           AND tt-despesa-aces-tribut.nro-docto          = docum-est.nro-docto
           AND tt-despesa-aces-tribut.nat-operacao       = docum-est.nat-operacao
           AND tt-despesa-aces-tribut.cod-emitente-ac    = tb-wt-docto.cod-emitente
           AND tt-despesa-aces-tribut.serie-docto-ac     = cSerDoctoAc
           AND tt-despesa-aces-tribut.nro-docto-ac       = cNroDoctoAc
           AND tt-despesa-aces-tribut.nat-operacao-ac    = cNatOperAc
           AND tt-despesa-aces-tribut.nom-trib           = pImposto
           AND tt-despesa-aces-tribut.cod-campo          = pAtributo NO-ERROR.

    IF  AVAIL tt-despesa-aces-tribut THEN
        ASSIGN pValorAtrib = dec(tt-despesa-aces-tribut.cod-conteudo ).
    ELSE DO:
     FIND FIRST despesa-aces-tribut NO-LOCK
          WHERE despesa-aces-tribut.cod-emitente       = docum-est.cod-emitente
            AND despesa-aces-tribut.serie-docto        = docum-est.serie-docto
            AND despesa-aces-tribut.nro-docto          = docum-est.nro-docto
            AND despesa-aces-tribut.nat-operacao       = docum-est.nat-operacao
            AND despesa-aces-tribut.cod-emitente-ac    = tb-wt-docto.cod-emitente
            AND despesa-aces-tribut.serie-docto-ac     = cSerDoctoAc
            AND despesa-aces-tribut.nro-docto-ac       = cNroDoctoAc
            AND despesa-aces-tribut.nat-operacao-ac    = cNatOperAc
            AND despesa-aces-tribut.nom-trib           = pImposto
            AND despesa-aces-tribut.cod-campo          = pAtributo NO-ERROR.
     IF  AVAIL despesa-aces-tribut THEN
        ASSIGN pValorAtrib = dec(despesa-aces-tribut.cod-conteudo ).

    END.


    RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTtDespesaAcesTribut DBOProgram
PROCEDURE getTtDespesaAcesTribut:
    DEFINE OUTPUT PARAM TABLE FOR tt-despesa-aces-tribut.

    RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
