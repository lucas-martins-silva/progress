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
{include/i-prgvrs.i AB0609RP 2.00.00.007 } /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0609rp MAB}
&ENDIF


{include/i_fnctrad.i}
/*****************************************************************************
**
**       PROGRAMA: AB0609RP.p
**
**       DATA....: Agosto de 2003
**
**       AUTOR...: Marcio Willwock - Manufatura - DATASUL S.A.
**
**       OBJETIVO: ImpressÆo Consulta AB0609 - Consumo Combust¡vel
**
*****************************************************************************/
                                             /** Defini‡Æo das temp-tables **/
define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field i-seq            as integer
    field c-cod            as character format "x(300)"
    field dtIni            as date format "99/99/9999"
    field dtFim            as date format "99/99/9999"
    field lParam           as LOGICAL
    FIELD i-tipo           AS INT
    field classificacao    as int format "9"
    field i-tipo-browse    as integer.

define shared temp-table tt-digita no-undo
    field sequencia           as   integer
    field cod-dimensao        as   character format "x(300)"
    field cod-oficial         as   character format "X(20)"
    field desc-dimensao       as   character format "x(32)"
    field cod-dimens-pai      as   character format "x(300)"
    field qtd-combustivel     as   decimal   format "->,>>>,>>9.9999"
    field val-percurso        as   decimal   format "->,>>>,>>9.99"
    field val-per-pad         as   decimal   format "->,>>>,>>9.99"
    field un                  like mab-model.un
    field relacao             as   character format "x(5)"
    field val-real            as   decimal   format "->,>>>,>>9.9999"
    field val-padrao          as   decimal   format "->,>>>,>>9.9999"
    field val-desperdicio     as   decimal   format "->,>>>,>>9.9999"
    field val-ganho           as   decimal   format "->,>>>,>>9.9999"
    field de-desvio           as   decimal   format "->,>>>,>>9.99"
    field l-desperdicio       as   logical
    field l-irregular         as   logical
    field r-rowid             as   rowid
    field p-image             as   integer
    field seq-tree            as   integer
    field val-percurso-sec    as   decimal   format "->,>>>,>>9.99"
    field val-per-pad-sec     as   decimal   format "->,>>>,>>9.99"
    field relacao-sec         as   character format "x(5)"
    field val-real-sec        as   decimal   format "->,>>>,>>9.9999"
    field val-padrao-sec      as   decimal   format "->,>>>,>>9.9999"
    field val-desperdicio-sec as   decimal   format "->,>>>,>>9.9999"
    field val-ganho-sec       as   decimal   format "->,>>>,>>9.9999"
    field de-desvio-sec       as   decimal   format "->,>>>,>>9.99"
    field l-desperdicio-sec   as   logical
    field l-irregular-sec     as   logical
    field l-LogContSec        as   logical
    FIELD l-VisaoPorItem      AS   LOGICAL /* Criado no IRM001380-Contabiliza‡Æo Item Abastecimento / Lubrifica‡Æo */
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
/****************************************************************************/
                                                /** Defini‡Æo de Vari veis **/
DEFINE VARIABLE h-acomp     AS HANDLE  NO-UNDO.

define buffer bfDigita for tt-digita.
{include/i-rpvar.i}
/****************************************************************************/
{abp/ab0609.i1}                                      /** Cabe‡alho e Forms **/


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
/** Cria a p gina dos parƒmetros **/
page.

/******************************************************************
  Espa‡o reservado para buscar informa‡äes a serem impressas nos 
  parƒmetros (Opcional)
******************************************************************/

/** L¢gica opcional do programador **/

/******************************************************************
  Final do espa‡o reservado
******************************************************************/

DISPLAY /*IMPRESSÇO*/
        c-liter-imp          
        c-destino            
        tt-param.arquivo
        tt-param.usuario     
    WITH FRAME f-param-definidos.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-imprimeVisao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimeVisao Procedure 
PROCEDURE imprimeVisao :
/*------------------------------------------------------------------------------
  Purpose:     imprimeVisao
  Parameters:  entrada pRow    = Rowid da temp-table selecionada
               entrada cCodPai = C¢digo do pai do registro selecionado
  Notes:       Imprime os cabe‡alhos da sele‡Æo feita pelo usu rio
------------------------------------------------------------------------------*/
define input parameter rRow    as rowid     no-undo.
define input parameter cCodPai as character no-undo.

if can-find(first bfDigita
            where bfDigita.cod-dimensao = cCodPai no-lock) then do:
    for first bfDigita
        where bfDigita.cod-dimensao = cCodPai no-lock:
        run imprimeVisao (input rowid(bfDigita),
                          input bfDigita.cod-dimens-pai).
    end.
end.
for first bfDigita
    where rowid(bfDigita) = rRow no-lock:
end.
if avail bfDigita then do:
    {abp/ab0609.i2 bfDigita.p-image}
    assign tt-digita.cod-oficial:label in frame f-visoes = trim(return-value).   

    display bfDigita.cod-oficial   @ tt-digita.cod-oficial   
            bfDigita.desc-dimensao @ tt-digita.desc-dimensao
        with frame f-visoes.
    down with frame f-visoes.
end.

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
assign c-programa = "AB/0609"
       c-versao   = "2.00"
       c-revisao  = "000"
       /** Define o destino do arquivo a ser gerado **/
.
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

/** Busca os parƒmetros criados na interface gr fica **/
find first tt-param.

/** Busca empresa padrÆo **/
find first param-global no-lock no-error.
if  available param-global then
    assign c-empresa = param-global.grupo.

/** Guarda valores para imprimir t¡tulos **/
{utp/ut-liter.i "Consumo Combust¡vel" *}
assign c-titulo-relat = trim(return-value).
{utp/ut-liter.i "ABASTECIMENTO" *}
assign c-sistema = trim(return-value).

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

DEFINE VARIABLE l-quebra AS LOGICAL    NO-UNDO.
/** Mostra frames de cabe‡alho e rodap‚ padräes da Datasul **/
view frame f-cabec.
view frame f-rodape. 

/** Inicializa programa de acompanhamento padrÆo Datasul **/
run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp(input c-titulo-relat).


find first tt-param.

/*********************************************************************
   Neste espa‡o deve-se colocar a l¢gica para busca as informa‡äes e 
   tamb‚m para fazer o display, pode-se inclui a chamada de procedures
   ou fazer a l¢gica neste espa‡o.
*********************************************************************/

/** IMPRIME SOMENTE A VISÇO SELECIONADA **/

IF i-tipo = 1 THEN DO:
    if tt-param.classificacao = 1 then do:
        for first tt-digita
            where tt-digita.sequencia    = tt-param.i-seq
            and   tt-digita.cod-dimensao = tt-param.c-cod no-lock:
        
            display tt-param.dtIni
                    tt-param.dtFim
                with frame f-periodo.
        
            run imprimeVisao (input rowid(tt-digita),
                              input tt-digita.cod-dimens-pai).
                              
            for each  bfDigita
                where bfDigita.cod-dimens-pai = tt-digita.cod-dimensao no-lock
                break by bfDigita.cod-dimens-pai:


                if first-of(bfDigita.cod-dimens-pai) then do:
                    case bfDigita.p-image:
                        when 3 then do:
                            {utp/ut-liter.i "Grupo Eqpto"}
                        end.
                        when 4 then do:
                            {utp/ut-liter.i "Modelo Eqpto"}
                        end.
                        when 18 then do:
                            {utp/ut-liter.i "Estrut Mecƒnica"}
                        end.
                        otherwise do:
                            {abp/ab0609.i2 bfDigita.p-image}
                        end.
                    end case.
                    assign bfDigita.cod-oficial:label in frame f-dados   = trim(return-value).
                    assign bfDigita.cod-oficial:label in frame f-dados-2 = trim(return-value).
                    put skip(1).
                end.
                if tt-param.i-tipo-browse = 1 then do:
                    IF bfDigita.l-VisaoPorItem = NO THEN DO:
                        display bfDigita.cod-oficial
                                bfDigita.desc-dimensao 
                                bfDigita.qtd-combustivel 
                                bfDigita.val-percurso 
                                bfDigita.val-real 
                                if bfDigita.l-irregular then "*" else "" @ c-fora 
                                bfDigita.val-padrao 
                                bfDigita.relacao 
                                bfDigita.de-desvio
                            with frame f-dados.
                        down with frame f-dados.

                        IF  bfDigita.l-LogContSec THEN DO:
                            DISPLAY c-desc-cont-sec 
                                    bfDigita.val-percurso-sec
                                    bfDigita.val-real-sec
                                    if bfDigita.l-irregular-sec then "*" else "" @ c-fora-sec
                                    bfDigita.val-padrao-sec
                                    bfDigita.relacao-sec
                                    bfDigita.de-desvio-sec
                                with frame f-dados-sec.
                            down with frame f-dados-sec.
                        END.
                    END.
                    ELSE DO:
                        display bfDigita.cod-oficial
                                bfDigita.desc-dimensao 
                                bfDigita.qtd-combustivel 
                            with frame f-dadosVisaoItem.
                        down with frame f-dadosVisaoItem.
                    END.
                END.
                else do:
                    display bfDigita.cod-oficial
                            bfDigita.desc-dimensao
                        with frame f-dados-2.
                    down with frame f-dados-2.
                END.
            END.
        END.
    END.
    else do:
        if tt-param.classificacao = 2 then do:
            for first tt-digita
                where tt-digita.sequencia    = tt-param.i-seq
                and   tt-digita.cod-dimensao = tt-param.c-cod no-lock:

                display tt-param.dtIni
                        tt-param.dtFim
                    with frame f-periodo.

                run imprimeVisao (input rowid(tt-digita),
                                  input tt-digita.cod-dimens-pai).

                for each  bfDigita
                    where bfDigita.cod-dimens-pai = tt-digita.cod-dimensao no-lock break by bfDigita.qtd-combustivel descending by bfDigita.cod-dimens-pai:

                    if first-of(bfDigita.cod-dimens-pai) then do:
                        case bfDigita.p-image:
                            when 3 then do:
                                {utp/ut-liter.i "Grupo Eqpto"}
                            end.
                            when 4 then do:
                                {utp/ut-liter.i "Modelo Eqpto"}
                            end.
                            when 18 then do:
                                {utp/ut-liter.i "Estrut Mecƒnica"}
                            end.
                            otherwise do:
                                {abp/ab0609.i2 bfDigita.p-image}
                            end.
                        end case.
                        assign bfDigita.cod-oficial:label in frame f-dados = trim(return-value).
                        assign bfDigita.cod-oficial:label in frame f-dados-2 = trim(return-value).
                        /*put skip(1).*/
                    END.
                    if tt-param.i-tipo-browse = 1 then do:
                        IF bfDigita.l-VisaoPorItem = NO THEN DO:
                            display bfDigita.cod-oficial
                                    bfDigita.desc-dimensao
                                    bfDigita.qtd-combustivel
                                    bfDigita.val-percurso
                                    bfDigita.val-real
                                    if bfDigita.l-irregular then "*" else "" @ c-fora
                                    bfDigita.val-padrao
                                    bfDigita.relacao
                                    bfDigita.de-desvio
                                    with frame f-dados.
                            down with frame f-dados.

                            IF  bfDigita.l-LogContSec THEN DO:
                                DISPLAY c-desc-cont-sec
                                        bfDigita.val-percurso-sec
                                        bfDigita.val-real-sec
                                        if bfDigita.l-irregular-sec then "*" else "" @ c-fora-sec
                                        bfDigita.val-padrao-sec
                                        bfDigita.relacao-sec
                                        bfDigita.de-desvio-sec
                                    with frame f-dados-sec.
                                down with frame f-dados-sec.
                            END.
                        END.
                        ELSE DO:
                            display bfDigita.cod-oficial
                                    bfDigita.desc-dimensao
                                    bfDigita.qtd-combustivel
                                    with frame f-dadosVisaoItem.
                            down with frame f-dadosVisaoItem.
                        END.
                    end.
                    else do:
                        display bfDigita.cod-oficial
                                bfDigita.desc-dimensao
                            with frame f-dados-2.
                        down with frame f-dados-2.
                    end.
                END.
            END.
        END.
    end.
end.
ELSE DO:
    /*IMPRIME TODOS OS DADOS DA TELA*/
    IF  tt-param.classificacao = 1 THEN DO:
        FOR EACH  tt-digita
            WHERE tt-digita.sequencia = tt-param.i-seq NO-LOCK:
            
            RUN imprimeVisao (INPUT ROWID(tt-digita),
                              INPUT tt-digita.cod-dimens-pai).
            FOR EACH  bfDigita
                WHERE bfDigita.cod-dimens-pai = tt-digita.cod-dimensao NO-LOCK
                BREAK BY bfDigita.cod-dimens-pai:
                IF  FIRST-OF(bfDigita.cod-dimens-pai) THEN DO:
                    CASE bfDigita.p-image:
                        WHEN 3 THEN DO:
                            {utp/ut-liter.i "Grupo Eqpto"}
                        END.
                        WHEN 4 THEN DO:
                            {utp/ut-liter.i "Modelo Eqpto"}
                        END.
                        when 18 then do:
                            {utp/ut-liter.i "Estrut Mecƒnica"}
                        end.
                        OTHERWISE DO:
                            {abp/ab0609.i2 bfDigita.p-image}
                        END.
                    END CASE.
                    ASSIGN bfDigita.cod-oficial:LABEL IN FRAME f-dados = TRIM(RETURN-VALUE).
                    assign bfDigita.cod-oficial:label in frame f-dados-2 = trim(return-value).
                    PUT SKIP(1).
                END.
                if tt-param.i-tipo-browse = 1 then do: 
                    IF bfDigita.l-VisaoPorItem = NO THEN DO:
                        DISPLAY bfDigita.cod-oficial
                                bfDigita.desc-dimensao
                                bfDigita.qtd-combustivel
                                bfDigita.val-percurso
                                bfDigita.val-real
                                IF bfDigita.l-irregular THEN "*" ELSE "" @ c-fora
                                bfDigita.val-padrao
                                bfDigita.relacao
                                bfDigita.de-desvio
                                WITH FRAME f-dados.
                        DOWN WITH FRAME f-dados.

                        IF  bfDigita.l-LogContSec THEN DO:
                            DISPLAY c-desc-cont-sec
                                    bfDigita.val-percurso-sec
                                    bfDigita.val-real-sec
                                    IF bfDigita.l-irregular-sec THEN "*" ELSE "" @ c-fora-sec
                                    bfDigita.val-padrao-sec
                                    bfDigita.relacao-sec
                                    bfDigita.de-desvio-sec
                                    WITH FRAME f-dados-sec.
                            DOWN WITH FRAME f-dados-sec.
                        END.
                    END.
                    ELSE DO:
                        
                        DISPLAY bfDigita.cod-oficial
                                bfDigita.desc-dimensao
                                bfDigita.qtd-combustivel
                                WITH FRAME f-dadosVisaoItem.
                        DOWN WITH FRAME f-dadosVisaoItem.
                        
                    END.
                end.
                else do:
                    display bfDigita.cod-oficial
                            bfDigita.desc-dimensao
                        with frame f-dados-2.
                    down with frame f-dados-2.
                end.
            END.
            IF  l-quebra THEN
                PAGE. /*quebra p gina por ficha.*/
            ELSE
                PUT SKIP(1).
        END.     
    END.
    ELSE DO:
        IF  tt-param.classificacao = 2 then do:
            FOR EACH  tt-digita
                where tt-digita.sequencia    = tt-param.i-seq no-lock:
                
                run imprimeVisao (input rowid(tt-digita),
                                  input tt-digita.cod-dimens-pai).
                for each  bfDigita
                    where bfDigita.cod-dimens-pai = tt-digita.cod-dimensao no-lock break by bfDigita.qtd-combustivel descending by bfDigita.cod-dimens-pai:
                    if first-of(bfDigita.cod-dimens-pai) then do:
                        case bfDigita.p-image:
                            when 3 then do:
                                {utp/ut-liter.i "Grupo Eqpto"}
                            end.
                            when 4 then do:
                                {utp/ut-liter.i "Modelo Eqpto"}
                            end.
                            when 18 then do:
                                {utp/ut-liter.i "Estrut Mecƒnica"}
                            end.
                            otherwise do:
                                    {abp/ab0609.i2 bfDigita.p-image}
                            end.
                         end case.
                         assign bfDigita.cod-oficial:label in frame f-dados = trim(return-value).
                         assign bfDigita.cod-oficial:label in frame f-dados-2 = trim(return-value).
                         /*put SKIP(1).*/
                    end.

                    if tt-param.i-tipo-browse = 1 then do:
                        IF bfDigita.l-VisaoPorItem = NO THEN DO:
                            DISPLAY bfDigita.cod-oficial
                                    bfDigita.desc-dimensao
                                    bfDigita.qtd-combustivel
                                    bfDigita.val-percurso
                                    bfDigita.val-real
                                    IF bfDigita.l-irregular THEN "*" ELSE "" @ c-fora
                                    bfDigita.val-padrao
                                    bfDigita.relacao
                                    bfDigita.de-desvio
                                    WITH FRAME f-dados.
                            DOWN WITH FRAME f-dados.

                            IF  bfDigita.l-LogContSec THEN DO:
                                DISPLAY c-desc-cont-sec
                                        bfDigita.val-percurso-sec
                                        bfDigita.val-real-sec
                                        IF bfDigita.l-irregular-sec THEN "*" ELSE "" @ c-fora-sec
                                        bfDigita.val-padrao-sec
                                        bfDigita.relacao-sec
                                        bfDigita.de-desvio-sec
                                        WITH FRAME f-dados-sec.
                                DOWN WITH FRAME f-dados-sec.
                            END.
                        END.
                        ELSE DO:
                            DISPLAY bfDigita.cod-oficial
                                    bfDigita.desc-dimensao
                                    bfDigita.qtd-combustivel
                                    WITH FRAME f-dadosVisaoItem.
                            DOWN WITH FRAME f-dadosVisaoItem.
                        END.
                    END.
                    ELSE DO:
                        display bfDigita.cod-oficial
                                bfDigita.desc-dimensao
                            with frame f-dados-2.
                        down with frame f-dados-2.
                    END.

                END.
                IF l-quebra THEN
                    PAGE. /*quebra p gina por ficha.*/
                ELSE
                    PUT SKIP(1).
            END.
        END.
    END.
END.

/*********************************************************************
   Fim do espa‡o para l¢gica de c lculo e display das informa‡äes
*********************************************************************/

/** Mostra parƒmetros selecionados **/
if tt-param.lParam then
    run displayParametros in this-procedure.

/** Finaliza programa de acompanhamento padrÆo Datasul **/
run pi-finalizar in h-acomp.

return "OK":U.

END PROCEDURE.
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
