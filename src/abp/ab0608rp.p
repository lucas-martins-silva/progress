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
{include/i-prgvrs.i AB0608RP 2.00.00.005 } /*** "010005" 28/05/2025 17:11:19 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0608rp MAB}
&ENDIF


{include/i_fnctrad.i}
/*****************************************************************************
**
**       PROGRAMA: AB0609RP.p
**
**       DATA....: Agosto de 2003
**
**       AUTOR...: DATASUL S.A.
**
**       OBJETIVO: Remonta Motor
**
*****************************************************************************/
  /** Defini‡Æo dos Parƒmetros **/
   
define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field i-seq            as integer
    field c-cod            as character format "x(300)"
    field lParam           as logical
    FIELD i-tipo           AS INT
    FIELD l-quebra         AS LOG
    field classifica       as integer format "9".

define shared temp-table tt-digita no-undo
    field sequencia         as   integer
    field cod-dimensao      as   character format "x(300)"
    field cod-nivel         as   character format "X(16)"
    field tpMater           as   character format "X(30)"
    field desc-dimensao     as   character format "x(32)"
    field Nivel             as   character format "x(40)"
    field cod-dimens-pai    as   character format "x(300)"
    field quantidade        as decimal format  ">>>,>>>,>>9.99"
    field val-mater         as decimal format  ">>>,>>>,>>>,>>9.99"
    field un                like mab-tip-mater.un
    field r-rowid           as   rowid
    field p-image           as   integer
    field seq-tree          as   integer
    FIELD integracao        AS   CHAR FORMAT "x(15)"
    FIELD data              LIKE mab-abastec-lubrific.dat-movto         
    FIELD hora              LIKE mab-abastec-lubrific.hra-inicial       
    FIELD contador          LIKE mab-abastec-lubrific.val-hodom-horim   
    FIELD nr-trans          LIKE mab-item-abastec.nr-trans 
    FIELD dt-trans          LIKE movto-estoq.dt-trans
    index id is primary unique sequencia ascending
                               cod-dimensao ascending.

def temp-table tt-raw-digita
   field raw-digita as raw.
/****************************************************************************/
                                               /** Defini‡Æo de Parƒmetros **/   
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.
/****************************************************************************/
                    /** Transferˆncia de parƒmetros para temp-table padrÆo **/
create tt-param.
raw-transfer raw-param to tt-param.

define buffer bfDigita for tt-digita.

/****************************************************************************/
                                                /** Defini‡Æo de Vari veis **/
DEFINE VARIABLE h-acomp     AS HANDLE  NO-UNDO.
DEFINE VARIABLE c-tipo  AS CHARACTER FORMAT "X(30)":U NO-UNDO.
{include/i-rpvar.i}
/****************************************************************************/
                                                     /** Cabe‡alho e Forms **/
{abp/ab0608.i1} /*--- Defini‡Æo dos frames ---*/

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
         HEIGHT             = 6.63
         WIDTH              = 32.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/** Parametriza padräes de cabe‡alho e rodap‚ a serem exibidos **/
run piInicial in this-procedure.
       
/** Imprime cabe‡alho e abre o output para arquivo **/
{include/i-rpcab.i}    
{include/i-rpout.i}

/** Procedure para inicializar c lculos e impressÆo **/
run piPrincipal in this-procedure.

/** Fecha o output para arquivo **/
{include/i-rpclo.i}

return "OK":U. 
/*--- Fim do Programa ---*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-displayParametros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayParametros Procedure 
PROCEDURE displayParametros :
/*------------------------------------------------------------------------------
  Purpose:     displayParametros
  Parameters:  <none>
  Notes:       Mostra os parƒmetros selecionados
------------------------------------------------------------------------------*/
if tt-param.lParam then do:
    page.
    IF tt-param.i-tipo = 1 THEN DO:
        {utp/ut-liter.i Somente_DimensÆo_Selecionada *}
    END.
    ELSE do:
        {utp/ut-liter.i Completo *}
    END.
    ASSIGN c-tipo = RETURN-VALUE.
    DISPLAY /*PAR¶METROS*/
            c-liter-par
            tt-param.i-tipo
            c-tipo
            tt-param.l-quebra
            /*IMPRESSÇO*/
            c-liter-imp
            c-destino
            tt-param.arquivo
            tt-param.usuario
        WITH FRAME f-param-definidos.
END.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-imprimeVisao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimeVisao Procedure 
PROCEDURE imprimeVisao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter rRow    as rowid     no-undo.
define input parameter cCodPai as character no-undo.

if can-find(first bfDigita
            where bfDigita.cod-dimensao = cCodPai no-lock) then do:
    for first bfDigita
        where bfDigita.cod-dimensao = cCodPai no-lock:
        run imprimeVisao (input rowid(bfDigita),
                          input bfDigita.cod-dimens-pai).
    END.
END.
for first bfDigita
    where rowid(bfDigita) = rRow no-lock:
END.
{abp/ab0608.i2 bfDigita.p-image}
assign tt-digita.cod-nivel:label in frame f-visoes = trim(return-value).

display bfDigita.cod-nivel     @ tt-digita.cod-nivel   
        bfDigita.desc-dimensao @ tt-digita.desc-dimensao
    with frame f-visoes.
down with frame f-visoes.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piInicial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piInicial Procedure 
PROCEDURE piInicial :
/*------------------------------------------------------------------------------
  Purpose:     piInicial
  Parameters:  <none>
  Notes:       Define os valores que serÆo mostrados o cabe‡alho e rodap‚
------------------------------------------------------------------------------*/
assign c-programa = "AB/0608"
       c-versao   = "2.00"
       c-revisao  = "000".

&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
    ASSIGN cAuxTraducao001 = {varinc/var00002.i 04 integer(tt-param.destino)}.
    run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                        INPUT "",
                        INPUT "").
    ASSIGN c-destino  = RETURN-VALUE.
&else
    ASSIGN c-destino  = {varinc/var00002.i 04 integer(tt-param.destino)}.
&endif

find first param-global no-lock no-error.
if  available param-global THEN DO:
    FOR FIRST empresa
        WHERE empresa.ep-codigo = param-global.empresa-prin NO-LOCK:
        ASSIGN c-empresa = empresa.nome.
    END.
    IF NOT AVAIL empresa THEN DO:
        assign c-empresa = param-global.grupo.
    END.
END.

{utp/ut-liter.i Sa¡das_de_Combust¡veis_e_Lubrificantes *}
assign c-titulo-relat = trim(return-value).

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
  Parameters:  <none>
  Notes:       Corpo princiapl da aplica‡Æo
------------------------------------------------------------------------------*/
/** Mostra frames de cabe‡alho e rodap‚ padräes da Datasul **/
view frame f-cabec.
view frame f-rodape. 

/** Busca os parƒmetros criados na interface gr fica **/
find first tt-param.

/** Inicializa programa de acompanhamento padrÆo Datasul **/
run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp(input c-titulo-relat).

/*********************************************************************
   Neste espa‡o deve-se colocar a l¢gica para busca as informa‡äes e 
   tamb‚m para fazer o display, pode-se inclui a chamada de procedures
   ou fazer a l¢gica neste espa‡o.
*********************************************************************/
blk_relatorio:
DO on stop undo, return "NOK":U:
    /** Imprime somente sele‡Æo **/
    if i-tipo = 1 then do:
        if tt-param.classifica = 3 then do:
            for first tt-digita
                where tt-digita.sequencia    = tt-param.i-seq
                and   tt-digita.cod-dimensao = tt-param.c-cod no-lock
                break by tt-digita.quantidade descending:
                
                run imprimeVisao (input rowid(tt-digita),
                                  input tt-digita.cod-dimens-pai).

                for each  bfDigita
                    where bfDigita.cod-dimens-pai = tt-digita.cod-dimensao no-lock 
                    break by bfDigita.quantidade descending
                          by bfDigita.cod-dimens-pai:
                    if first-of(bfDigita.cod-dimens-pai) then do:
                        {abp/ab0608.i2 bfDigita.p-image}
                        put skip(1).
                        assign bfDigita.cod-nivel:label in frame f-dados = trim(return-value).
                    end.
                    if bfDigita.p-image = 16 then do:
                        assign cCodigo     = bfDigita.cod-nivel
                               cDesc       = bfDigita.desc-dimensao
                               cQuant      = string(bfDigita.quantidade,">>>,>>>,>>9.99")
                               cUn         = bfDigita.un
                               cVal-mater  = string(bfDigita.val-mater,">>>,>>>,>>9.99")
                               cIntegracao = bfDigita.integracao
                               dtData      = bfDigita.data
                               cHora      = bfDigita.hora
                               dContador   = bfDigita.contador
                               cNr-trans   = string(bfDigita.nr-trans,">>>,>>>,>>>,>>>,>>9")
                               dt-trans    = bfDigita.dt-trans.

                        display cCodigo
                                cDesc
                                cQuant
                                cUn
                                cVal-mater
                                cIntegracao
                                dtData
                                cHora
                                dContador
                                cNr-trans
                                dt-trans
                            with frame f-dados1.
                        down with frame f-dados1.
                    end.
                    else do:
                        display bfDigita.cod-nivel AT 01
                                bfDigita.desc-dimensao
                                bfDigita.quantidade
                                bfDigita.un
                                bfDigita.val-mater
                            with frame f-dados.
                        down with frame f-dados.
                    END.
                END.
            END.
        END.
        else do:
            if tt-param.classifica = 2 then do:
                for FIRST tt-digita
                    where tt-digita.sequencia    = tt-param.i-seq
                    and   tt-digita.cod-dimensao = tt-param.c-cod no-lock 
                    break by tt-digita.val-mater descending:

                    run imprimeVisao (input rowid(tt-digita),
                                      input tt-digita.cod-dimens-pai).

                    FOR each  bfDigita
                        where bfDigita.cod-dimens-pai = tt-digita.cod-dimensao no-lock 
                        break by bfDigita.val-mater descending 
                              by bfDigita.cod-dimens-pai:
                        if first-of(bfDigita.cod-dimens-pai) then do:
                            {abp/ab0608.i2 bfDigita.p-image}
                            put skip(1).
                            assign bfDigita.cod-nivel:label in frame f-dados = trim(return-value).
                        END.                        
                        if bfDigita.p-image = 16 then do:
                            assign cCodigo     = bfDigita.cod-nivel
                                   cDesc       = bfDigita.desc-dimensao
                                   cQuant      = string(bfDigita.quantidade,">>>,>>>,>>9.99")
                                   cUn         = bfDigita.un
                                   cVal-mater  = string(bfDigita.val-mater,">>>,>>>,>>9.99")
                                   cIntegracao = bfDigita.integracao
                                   dtData      = bfDigita.data
                                   cHora      = bfDigita.hora
                                   dContador   = bfDigita.contador
                                   cNr-trans   = string(bfDigita.nr-trans,">>>,>>>,>>>,>>>,>>9")
                                   dt-trans    = bfDigita.dt-trans.

                            display cCodigo
                                    cDesc
                                    cQuant
                                    cUn
                                    cVal-mater
                                    cIntegracao
                                    dtData
                                    cHora
                                    dContador
                                    cNr-trans
                                    dt-trans
                                with frame f-dados1.
                            down with frame f-dados1.
                        END.
                        else do:
                            display bfDigita.cod-nivel AT 01
                                    bfDigita.desc-dimensao
                                    bfDigita.quantidade
                                    bfDigita.un
                                    bfDigita.val-mater
                                with frame f-dados.
                            down with frame f-dados.
                        END.
                    END.
                END.
            END.
            else do:
                for FIRST tt-digita
                    where tt-digita.sequencia    = tt-param.i-seq
                    and   tt-digita.cod-dimensao = tt-param.c-cod no-lock:

                    run imprimeVisao (input rowid(tt-digita),
                                      input tt-digita.cod-dimens-pai).

                    FOR each  bfDigita
                        where bfDigita.cod-dimens-pai = tt-digita.cod-dimensao no-lock 
                        break by bfDigita.cod-dimens-pai:
                        if first-of(bfDigita.cod-dimens-pai) then do:
                            {abp/ab0608.i2 bfDigita.p-image}
                            put skip(1).
                            assign bfDigita.cod-nivel:label in frame f-dados = trim(return-value).
                        END.

                        if bfDigita.p-image = 16 then do:
                            assign cCodigo     = string(trim(bfDigita.cod-nivel))
                                   cDesc       = bfDigita.desc-dimensao
                                   cQuant      = string(bfDigita.quantidade,">>>,>>>,>>9.99")
                                   cUn         = bfDigita.un
                                   cVal-mater  = string(bfDigita.val-mater,">>>,>>>,>>9.99")
                                   cIntegracao = bfDigita.integracao
                                   dtData      = bfDigita.data
                                   cHora      = bfDigita.hora
                                   dContador   = bfDigita.contador
                                   cNr-trans   = string(bfDigita.nr-trans,">>>,>>>,>>>,>>>,>>9")
                                   dt-trans    = bfDigita.dt-trans.

                            display cCodigo
                                    cDesc
                                    cQuant
                                    cUn
                                    cVal-mater
                                    cIntegracao
                                    dtData
                                    cHora
                                    dContador
                                    cNr-trans
                                    dt-trans
                                with frame f-dados1.
                            down with frame f-dados1.
                        END.
                        else do:
                            display bfDigita.cod-nivel AT 01
                                    bfDigita.desc-dimensao
                                    bfDigita.quantidade
                                    bfDigita.un
                                    bfDigita.val-mater
                                with frame f-dados.
                            down with frame f-dados.
                        END.
                    END.
                END.
            END.
        END.
    END.
    /** Imprime todos os dados na tela **/
    ELSE DO:
        if tt-param.classifica = 3 then do:
            for EACH  tt-digita
                where tt-digita.sequencia = tt-param.i-seq no-lock 
                break by tt-digita.quantidade descending:

                run imprimeVisao (input rowid(tt-digita),
                                  input tt-digita.cod-dimens-pai).
                for each  bfDigita
                    where bfDigita.cod-dimens-pai = tt-digita.cod-dimensao no-lock
                    break by bfDigita.quantidade descending 
                    by bfDigita.cod-dimens-pai:
                    if first-of(bfDigita.cod-dimens-pai) then do:
                        {abp/ab0608.i2 bfDigita.p-image}
                        put skip(1).
                        assign bfDigita.cod-nivel:label in frame f-dados = trim(return-value).
                    END.
                    if bfDigita.p-image = 16 then do:
                        assign cCodigo     = bfDigita.cod-nivel
                               cDesc       = bfDigita.desc-dimensao
                               cQuant      = string(bfDigita.quantidade,">>>,>>>,>>9.99")
                               cUn         = bfDigita.un
                               cVal-mater  = string(bfDigita.val-mater,">>>,>>>,>>9.99")
                               cIntegracao = bfDigita.integracao
                               dtData      = bfDigita.data
                               cHora      = bfDigita.hora
                               dContador   = bfDigita.contador
                               cNr-trans   = string(bfDigita.nr-trans,">>>,>>>,>>>,>>>,>>9")
                               dt-trans    = bfDigita.dt-trans.

                        display cCodigo
                                cDesc
                                cQuant
                                cUn
                                cVal-mater
                                cIntegracao
                                dtData
                                cHora
                                dContador
                                cNr-trans
                                dt-trans
                            with frame f-dados1.
                        down with frame f-dados1.
                    END.
                    else do:
                        display bfDigita.cod-nivel AT 01
                                bfDigita.desc-dimensao
                                bfDigita.quantidade
                                bfDigita.un
                                bfDigita.val-mater
                            with frame f-dados.
                        down with frame f-dados.
                    END.
                END.
                IF l-quebra THEN
                    PAGE. /*quebra p gina por ficha.*/
                ELSE
                    PUT SKIP(2).
            END.
        END.
        else do:
            if tt-param.classifica = 2 then do:
                for EACH  tt-digita
                    where tt-digita.sequencia = tt-param.i-seq no-lock 
                    break by tt-digita.val-mater descending:
                    
                    run imprimeVisao (input rowid(tt-digita),
                                      input tt-digita.cod-dimens-pai).
                    for each  bfDigita
                        where bfDigita.cod-dimens-pai = tt-digita.cod-dimensao no-lock
                        break by bfDigita.val-mater descending 
                              by bfDigita.cod-dimens-pai:
                        if first-of(bfDigita.cod-dimens-pai) then do:
                            {abp/ab0608.i2 bfDigita.p-image}
                            put skip(1).
                            assign bfDigita.cod-nivel:label in frame f-dados = trim(return-value).
                        END.
                        if bfDigita.p-image = 16 then do:
                            assign cCodigo     = bfDigita.cod-nivel
                                   cDesc       = bfDigita.desc-dimensao
                                   cQuant      = string(bfDigita.quantidade,">>>,>>>,>>9.99")
                                   cUn         = bfDigita.un
                                   cVal-mater  = string(bfDigita.val-mater,">>>,>>>,>>9.99")
                                   cIntegracao = bfDigita.integracao
                                   dtData      = bfDigita.data
                                   cHora      = bfDigita.hora
                                   dContador   = bfDigita.contador
                                   cNr-trans   = string(bfDigita.nr-trans,">>>,>>>,>>>,>>>,>>9")
                                   dt-trans    = bfDigita.dt-trans.

                            display cCodigo
                                    cDesc
                                    cQuant
                                    cUn
                                    cVal-mater
                                    cIntegracao
                                    dtData
                                    cHora
                                    dContador
                                    cNr-trans
                                    dt-trans
                                with frame f-dados1.
                            down with frame f-dados1.
                        END.
                        else do:
                            display bfDigita.cod-nivel AT 01
                                    bfDigita.desc-dimensao
                                    bfDigita.quantidade
                                    bfDigita.un
                                    bfDigita.val-mater
                                with frame f-dados.
                            down with frame f-dados.
                        END.
                    END.
                    IF l-quebra THEN
                        PAGE. /*quebra p gina por ficha.*/
                    ELSE
                        PUT SKIP(2).
                END.
            END.
            else do:
                for EACH  tt-digita
                    where tt-digita.sequencia = tt-param.i-seq no-lock:

                    run imprimeVisao (input rowid(tt-digita),
                                      input tt-digita.cod-dimens-pai).
                    for each  bfDigita
                        where bfDigita.cod-dimens-pai = tt-digita.cod-dimensao no-lock
                        break by bfDigita.cod-dimens-pai:
                        if first-of(bfDigita.cod-dimens-pai) then do:
                            {abp/ab0608.i2 bfDigita.p-image}
                            put skip(1).
                            assign bfDigita.cod-nivel:label in frame f-dados = trim(return-value).
                        END.
                        if bfDigita.p-image = 16 then do:
                            assign cCodigo     = bfDigita.cod-nivel
                                   cDesc       = bfDigita.desc-dimensao
                                   cQuant      = string(bfDigita.quantidade,">>>,>>>,>>9.99")
                                   cUn         = bfDigita.un
                                   cVal-mater  = string(bfDigita.val-mater,">>>,>>>,>>9.99")
                                   cIntegracao = bfDigita.integracao
                                   dtData      = bfDigita.data
                                   cHora      = bfDigita.hora
                                   dContador   = bfDigita.contador
                                   cNr-trans   = string(bfDigita.nr-trans,">>>,>>>,>>>,>>>,>>9")
                                   dt-trans    = bfDigita.dt-trans.

                            display cCodigo
                                    cDesc
                                    cQuant
                                    cUn
                                    cVal-mater
                                    cIntegracao
                                    dtData
                                    cHora
                                    dContador
                                    cNr-trans
                                    dt-trans
                                with frame f-dados1.
                            down with frame f-dados1.
                        END.
                        else do:
                            display bfDigita.cod-nivel AT 01
                                    bfDigita.desc-dimensao
                                    bfDigita.quantidade
                                    bfDigita.un
                                    bfDigita.val-mater
                                with frame f-dados.
                            down with frame f-dados.
                        END.
                    END.
                    IF l-quebra THEN
                        PAGE. /*quebra p gina por ficha.*/
                    ELSE
                        PUT SKIP(2).
                END.
            END.
        END.
    END.
END.

/*********************************************************************
   Fim do espa‡o para l¢gica de c lculo e display das informa‡äes
*********************************************************************/

/** Mostra parƒmetros selecionados **/
run displayParametros in this-procedure.

/** Finaliza programa de acompanhamento padrÆo Datasul **/
run pi-finalizar in h-acomp.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

