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
{include/i-prgvrs.i AB0612RP 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0612rp MAB}
&ENDIF


{include/i_fnctrad.i}
/*****************************************************************************
**
**       PROGRAMA: AB0612RP.p
**
**       DATA....: Agosto de 2003
**
**       AUTOR...: Marcio Willwock - Manufatura - DATASUL S.A.
**
**       OBJETIVO: ImpressÆo Consulta AB0612 - Eventos Vencidos e a Vencer
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
    field iTipo            as integer
    field lDescricao       as logical
    field cTipo            as character
    field lParam           as logical
    field iUltimo          as integer.

define shared temp-table tt-digita no-undo
    field sequencia         as   integer
    field cod-dimensao      as   character format "x(300)"
    field cod-oficial       as   character format "X(20)"
    field desc-dimensao     as   character format "x(32)"
    field cod-dimens-pai    as   character format "x(300)"
    field num-docto         like mab-movto-km-eqpto.num-docto
    field uso-real          as   decimal format "->>,>>>,>>9.9"
    field uso-padrao        as   decimal format "->>>,>>>,>>9.9"
    field diferenca         as   decimal format "->>,>>>,>>9.9"
    field un                as   character format "x(3)"
    field lVencido          as   logical
    field lVencer           as   logical
    field r-rowid           as   rowid
    field p-image           as   integer
    field seq-tree          as   integer
    FIELD dat-vencimento    AS   DATE FORMAT "99/99/9999"
    index id is primary unique sequencia ascending
                               cod-dimensao ascending.
def temp-table tt-raw-digita
   field raw-digita as raw.

def temp-table tt-editor no-undo
    field linha      as integer
    field conteudo   as character format "x(80)"
    index editor-id is primary unique linha.

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
define buffer bfDigita  for tt-digita.
{include/i-rpvar.i}
/****************************************************************************/
                                                     /** Cabe‡alho e Forms **/
{abp/ab0612.i1}
{include/pi-edit.i}

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
         HEIGHT             = 7.54
         WIDTH              = 28.86.
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

DISPLAY /*PAR¶METROS*/
        c-liter-par
        tt-param.iTipo
        tt-param.cTipo
        /*IMPRESSÇO*/
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

&IF DEFINED(EXCLUDE-imprimeDados) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimeDados Procedure 
PROCEDURE imprimeDados :
/*------------------------------------------------------------------------------
  Purpose:     imprimeDados
  Parameters:  entrada cDimensao = C¢digo da dimensÆo do registro pai
  Notes:       Busca n¡veis abaixo, coforme sele‡Æo do n¡vel
------------------------------------------------------------------------------*/
define input parameter cDimensao as character no-undo.

define variable cPai as character no-undo.

/** Est  selecionado n¡vel acima **/
if tt-param.i-seq < (tt-param.iUltimo - 1) or tt-param.iTipo = 2 then do:
    assign cPai = "".
    for each  bfDigita
        where bfDigita.cod-dimens-pai = cDimensao no-lock:
        /** Verifica se existem n¡veis abaixo que nÆo sejam os 2 £ltimos **/
        if (bfDigita.sequencia < (tt-param.iUltimo - 1)) then do:
            run imprimeDados (bfDigita.cod-dimensao).
        end.
        else do:
            if cPai <> bfDigita.cod-dimens-pai then do:
                /** Imprime os cabe‡alhos **/
                put skip(2).
                run imprimeVisao (input rowid(bfDigita),
                                  input bfDigita.cod-dimens-pai).
                assign cPai = bfDigita.cod-dimens-pai.
                disp "".
            end.
            run piFinal.
        end.
    end.
end.
/** Est  selecionado o pen£ltimo n¡vel **/
else do:
    for first bfDigita
        where bfDigita.cod-dimensao = cDimensao no-lock:
        /** Imprime Cabe‡alho **/
        run imprimeVisao (input rowid(bfDigita),
                          input bfDigita.cod-dimens-pai).
        disp "".
        run piFinal.
    end.
end.

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
  Parameters:  entrada rRow    = Rowid da temp-table                
               entrada cCodPai = C¢digo da dimensÆo do registro pai 
  Notes:       Imprime os cabe‡alhos, buscando os n¡veis acima do selecionado
------------------------------------------------------------------------------*/
define input parameter rRow    as rowid     no-undo.
define input parameter cCodPai as character no-undo.

DEFINE VARIABLE cTexto  AS CHARACTER format "x(30)"  NO-UNDO.
DEFINE VARIABLE cTexto2 AS CHARACTER format "x(100)" NO-UNDO.

define buffer bfDigita2 for tt-digita.

/** Verifica se existe n¡vel acima **/
if can-find(first bfDigita2
            where bfDigita2.cod-dimensao = cCodPai no-lock) then do:
    for first bfDigita2
        where bfDigita2.cod-dimensao = cCodPai no-lock:
        run imprimeVisao (input rowid(bfDigita2),
                          input bfDigita2.cod-dimens-pai).
    end.
end.
/** Busca apenas n¡veis superiores aos 2 £ltimos **/
for first bfDigita2
    where rowid(bfDigita2) = rRow 
    and   bfDigita2.sequencia < (tt-param.iUltimo - 1) no-lock:
end.
if avail bfDigita2 then do:
    {abp/ab0612.i2 bfDigita2.p-image}
    assign cTexto  = return-value
           cTexto2 = ": " + bfDigita2.cod-oficial + " - " + bfDigita2.desc-dimensao.
    put cTexto  at 3.
    put cTexto2.
    put skip(0).
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piFinal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piFinal Procedure 
PROCEDURE piFinal :
/*------------------------------------------------------------------------------
  Purpose:     piFinal
  Parameters:  <none>
  Notes:       Busca £ltimo n¡vel e imprime
------------------------------------------------------------------------------*/
define buffer bfDigita2 for tt-digita.

for each  bfDigita2
    where bfDigita2.cod-dimens-pai = bfDigita.cod-dimensao no-lock
    break by bfDigita2.cod-dimens-pai:
    if first-of(bfDigita2.cod-dimens-pai) then do:
        {abp/ab0612.i2 bfDigita.p-image}
        assign tt-digita.cod-oficial:label in frame f-dados = trim(return-value).
        {abp/ab0612.i2 bfDigita2.p-image}
        assign bfDigita.desc-dimensao:label in frame f-dados = trim(return-value).

        display if bfDigita.p-image = 2 
                then bfDigita.cod-oficial + " - " + bfDigita.desc-dimensao
                else bfDigita.desc-dimensao  @ tt-digita.cod-oficial
            with frame f-dados.
    end.
    display if bfDigita2.p-image = 2
            then bfDigita2.cod-oficial + " - " + bfDigita2.desc-dimensao
            else bfDigita2.desc-dimensao @ bfDigita.desc-dimensao
            bfDigita2.uso-real      @ bfDigita.uso-real     
            bfDigita2.uso-padrao    @ bfDigita.uso-padrao   
            bfDigita2.diferenca     @ bfDigita.diferenca    
            bfDigita2.un            @ bfDigita.un           
            bfDigita2.num-docto     @ bfDigita.num-docto
        with frame f-dados.
    down with frame f-dados.


    /* Verifica se usu rio deseja imprimir descri‡Æo dos eventos. */
    if tt-Param.lDescricao then do:
       if bfDigita2.num-docto <> 0  then do:
           for first mab-movto-event where mab-movto-event.num-docto = bfDigita2.num-docto no-lock:
               if mab-movto-event.dsl-obs <> "" then do:
                   empty temp-table tt-editor.
                   run pi-print-editor ( mab-movto-event.dsl-obs, 80).
                   for each tt-editor where tt-editor.linha >= 1:
                       Put tt-editor.conteudo at 37.
                   end.
                   put skip(1).
               end.
           end.
        end.
    end.

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
assign c-programa = "AB/0612"
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
if available param-global THEN DO:
    FOR FIRST empresa
        WHERE empresa.ep-codigo = param-global.empresa-prin NO-LOCK:
        ASSIGN c-empresa = empresa.razao-social.
    END.
END.
/** Guarda valores para imprimir t¡tulos **/
{utp/ut-liter.i "Eventos Vencidos e a Vencer" *}
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
/** Mostra frames de cabe‡alho e rodap‚ padräes da Datasul **/
view frame f-cabec.
view frame f-rodape. 

/** Inicializa programa de acompanhamento padrÆo Datasul **/
run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp(input c-titulo-relat).

/*********************************************************************
   Neste espa‡o deve-se colocar a l¢gica para busca as informa‡äes e 
   tamb‚m para fazer o display, pode-se inclui a chamada de procedures
   ou fazer a l¢gica neste espa‡o.
*********************************************************************/

/** Somente visÆo selecionada **/
if tt-param.iTipo = 1 then do:
    run imprimeDados (tt-param.c-cod).
end.
/** Completo **/
else do:
    for each  tt-digita
        where tt-digita.sequencia = 1 no-lock:
        run imprimeDados (tt-digita.cod-dimensao).
    end.
end.

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

