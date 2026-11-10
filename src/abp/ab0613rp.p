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
{include/i-prgvrs.i AB0613RP 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0613rp MAB}
&ENDIF


{include/i_fnctrad.i}
/*****************************************************************************
**
**       PROGRAMA: AB0613RP.p
**
**       DATA....: Setembro de 2003
**
**       AUTOR...: Marcio Willwock - Manufatura - DATASUL S.A.
**
**       OBJETIVO: <none>
**
*****************************************************************************/
                                             /** Definiá∆o das temp-tables **/
define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field i-seq            as integer
    field c-cod            as character format "x(300)"
    field i-seq-or         as integer
    field c-cod-or         as character format "x(300)"
    field lParam           as logical
    field iUltimo          as integer
    field lTipo            as integer.

define shared temp-table tt-digita no-undo
    field sequencia         as   integer
    field cod-dimensao      as   character format "x(300)"
    field cod-oficial       as   character format "X(20)"
    field desc-dimensao     as   character format "x(32)"
    field cod-dimens-pai    as   character format "x(300)"
    field uso-real          as   decimal FORMAT "->>>,>>>,>>9.9"
    field uso-padrao        as   decimal format "->>>,>>>,>>9.9"
    field diferenca         as   decimal format "->>>,>>>,>>9.9"
    field perc-desvio       as   decimal format "->>9.9"
    field un                as   character format "x(2)"
    field iPrazo            as   integer /** 1=Antes 2=Dentro 3=Ap¢s **/ 
    field iAntes            as   integer
    field iDentro           as   integer
    field iApos             as   integer
    field r-rowid           as   rowid
    field p-image           as   integer
    field seq-tree          as   integer
    field quantidade        as   decimal format ">>>,>>9.99"
    field valor             as   decimal format ">>>,>>9.99"
    index id is primary unique sequencia ascending
                               cod-dimensao ascending.
def temp-table tt-raw-digita
   field raw-digita as raw.
/****************************************************************************/
                                               /** Definiá∆o de ParÉmetros **/   
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.
/****************************************************************************/
                    /** Transferància de parÉmetros para temp-table padr∆o **/
create tt-param.
raw-transfer raw-param to tt-param.
/** Este c¢digo deve existir somente se relat¢rio contiver digitaá∆o **/
for each tt-raw-digita no-lock:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.
/****************************************************************************/
                                                /** Definiá∆o de Vari†veis **/
DEFINE VARIABLE h-acomp AS HANDLE     NO-UNDO.
DEFINE VARIABLE cPai2   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPrazo  AS CHARACTER  format "x(6)"  NO-UNDO.
DEFINE VARIABLE cDesc1  AS CHARACTER  format "x(22)" NO-UNDO.
DEFINE VARIABLE cDesc2  AS CHARACTER  format "x(22)" NO-UNDO.
DEFINE VARIABLE cDesc3  AS CHARACTER  format "x(22)" NO-UNDO.
define buffer bfDigita  for tt-digita.
{include/i-rpvar.i}
/****************************************************************************/
                                                     /** Cabeáalho e Forms **/
{abp/ab0613.i}
{abp/ab0613.i1}

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
         HEIGHT             = 9.29
         WIDTH              = 28.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/** Parametriza padr‰es de cabeáalho e rodapÇ a serem exibidos **/
run piInicial in this-procedure.
       
/** Imprime cabeáalho e abre o output para arquivo **/
{include/i-rpcab.i}    
{include/i-rpout.i}

/** Procedure para inicializar c†lculos e impress∆o **/
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
  Notes:       Mostra os parÉmetros selecionados
------------------------------------------------------------------------------*/
/** Cria a p†gina dos parÉmetros **/
page.

/******************************************************************
  Espaáo reservado para buscar informaá‰es a serem impressas nos 
  parÉmetros (Opcional)
******************************************************************/

/** L¢gica opcional do programador **/

/******************************************************************
  Final do espaáo reservado
******************************************************************/

DISPLAY /*IMPRESS«O*/
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
  Parameters:  entrada cDimensao = C¢digo da dimens∆o do registro pai
  Notes:       Busca n°veis abaixo, coforme seleá∆o do n°vel         
------------------------------------------------------------------------------*/
define input parameter cDimensao as character no-undo.

define variable cPai  as character no-undo.
define buffer bfDigita2 for tt-digita.

/** Est† selecionado n°vel acima **/
if tt-param.i-seq < (tt-param.iUltimo - 2) then do:
    assign cPai  = "".
    for each  bfDigita
        where bfDigita.cod-dimens-pai = cDimensao no-lock:
        /** Verifica se existem n°veis abaixo que n∆o sejam os 2 £ltimos **/
        if (bfDigita.sequencia < (tt-param.iUltimo - 1)) then do:
            run imprimeDados (bfDigita.cod-dimensao).
        end.
        else do:
            if cPai <> bfDigita.cod-dimens-pai then do:
                /** Busca Campo antepen£ltimo n°vel **/
                for first bfDigita2
                    where bfDigita2.cod-dimensao = bfDigita.cod-dimens-pai no-lock:
                    if cPai2 <> bfDigita2.cod-dimens-pai then do:
                        /** Imprime os cabeáalhos **/
                        put skip(2).
                        run imprimeVisao (input rowid(bfDigita),
                                          input bfDigita.cod-dimens-pai).
                        assign cPai = bfDigita2.cod-dimens-pai.
                        disp "".
                    end.
                    assign cPai2 = bfDigita2.cod-dimens-pai.
                    /** Busca Label **/
                    {abp/ab0613.i2 bfDigita2.p-image}
                    assign cDesc1:label in frame f-dados  = trim(return-value).
                    assign cDesc1:label in frame f-dados2 = trim(return-value).

                    if tt-param.lTipo = 1 then
                        /** Imprime dados da vis∆o **/
                        display if bfDigita2.p-image = 7 
                                then bfDigita2.cod-oficial
                                else if bfDigita2.p-image = 2 
                                then bfDigita2.cod-oficial + " - " + bfDigita2.desc-dimensao 
                                else bfDigita2.desc-dimensao @ cDesc1
                            with frame f-dados.
                     if tt-param.lTipo = 2 then
                         /** Imprime dados da vis∆o **/
                         display if bfDigita2.p-image = 7 
                                 then bfDigita2.cod-oficial 
                                 else if bfDigita2.p-image = 2 
                                 then bfDigita2.cod-oficial + " - " + bfDigita2.desc-dimensao 
                                 else bfDigita2.desc-dimensao @ cDesc1
                             with frame f-dados2.
                end.
            end.
            run piFinal.
        end.
    end.
end.
/** Est† selecionado o pen£ltimo ou £ltimo n°vel **/
else do:
    /** Verifica se foi selecionado £ltimo **/
    if tt-param.c-cod <> tt-param.c-cod-or then do:
        for first bfDigita
            where bfDigita.cod-dimens-pai = cDimensao 
            and   bfDigita.cod-dimensao   = tt-param.c-cod-or no-lock
            break by bfDigita.cod-dimens-pai:
            /** Para primeiro registro **/
            if first-of(bfDigita.cod-dimens-pai) then do:
                /** Imprime Cabeáalho **/
                run imprimeVisao (input rowid(bfDigita),
                                  input bfDigita.cod-dimens-pai).
                /** Pula linha **/
                disp "".
                /** Busca Campo antepen£ltimo n°vel **/
                for first bfDigita2
                    where bfDigita2.cod-dimensao = bfDigita.cod-dimens-pai no-lock:
                    /** Busca Label **/
                    {abp/ab0613.i2 bfDigita2.p-image}
                    assign cDesc1:label in frame f-dados  = trim(return-value).
                    assign cDesc1:label in frame f-dados2 = trim(return-value).

                    if tt-param.lTipo = 1 then
                       /** Imprime dados da vis∆o **/
                       display if bfDigita2.p-image = 7 
                               then bfDigita2.cod-oficial 
                               else if bfDigita2.p-image = 2 
                               then bfDigita2.cod-oficial + " - " + bfDigita2.desc-dimensao 
                               else bfDigita2.desc-dimensao  @ cDesc1
                           with frame f-dados.
                    if tt-param.lTipo = 2 then
                       /** Imprime dados da vis∆o **/
                       display if bfDigita2.p-image = 7 
                               then bfDigita2.cod-oficial 
                               else if bfDigita2.p-image = 2 
                               then bfDigita2.cod-oficial + " - " + bfDigita2.desc-dimensao 
                               else bfDigita2.desc-dimensao  @ cDesc1
                           with frame f-dados2.
                end.
            end.
            run piFinal.
        end.
    end.
    else do:
        for each  bfDigita
            where bfDigita.cod-dimens-pai = cDimensao no-lock
            break by bfDigita.cod-dimens-pai:
            /** Para primeiro registro **/
            if first-of(bfDigita.cod-dimens-pai) then do:
                /** Imprime Cabeáalho **/
                run imprimeVisao (input rowid(bfDigita),
                                  input bfDigita.cod-dimens-pai).
                /** Pula linha **/
                disp "".
                /** Busca Campo antepen£ltimo n°vel **/
                for first bfDigita2
                    where bfDigita2.cod-dimensao = bfDigita.cod-dimens-pai no-lock:
                    /** Busca Label **/
                    {abp/ab0613.i2 bfDigita2.p-image}
                    assign cDesc1:label in frame f-dados  = trim(return-value).
                    assign cDesc1:label in frame f-dados2 = trim(return-value).
                    /** Imprime dados da vis∆o **/

                    if tt-param.lTipo = 1 then
                       display if bfDigita2.p-image = 7 
                               then bfDigita2.cod-oficial 
                               else if bfDigita2.p-image = 2 
                               then bfDigita2.cod-oficial + " - " + bfDigita2.desc-dimensao 
                               else bfDigita2.desc-dimensao @ cDesc1
                           with frame f-dados.
                    if tt-param.lTipo = 2 then
                       display if bfDigita2.p-image = 7 
                               then bfDigita2.cod-oficial 
                               else if bfDigita2.p-image = 2 
                               then bfDigita2.cod-oficial + " - " + bfDigita2.desc-dimensao 
                               else bfDigita2.desc-dimensao @ cDesc1
                           with frame f-dados2.
                end.
            end.
            run piFinal.
        end.
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
               entrada cCodPai = C¢digo da dimens∆o do registro pai
  Notes:       Imprime os cabeáalhos, buscando os n°veis acima do selecionado
------------------------------------------------------------------------------*/
define input parameter rRow    as rowid     no-undo.
define input parameter cCodPai as character no-undo.

DEFINE VARIABLE cTexto  AS CHARACTER format "x(30)"  NO-UNDO.
DEFINE VARIABLE cTexto2 AS CHARACTER format "x(100)" NO-UNDO.

define buffer bfDigita2 for tt-digita.
/** Verifica se existe n°vel acima **/
if can-find(first bfDigita2
            where bfDigita2.cod-dimensao = cCodPai no-lock) then do:
    for first bfDigita2
        where bfDigita2.cod-dimensao = cCodPai no-lock:
        run imprimeVisao (input rowid(bfDigita2),
                          input bfDigita2.cod-dimens-pai).
    end.
end.
/** Busca apenas n°veis superiores aos 3 £ltimos **/
for first bfDigita2
    where rowid(bfDigita2) = rRow 
    and   bfDigita2.sequencia < (tt-param.iUltimo - 2) no-lock:
end.
if avail bfDigita2 then do:
    {abp/ab0613.i2 bfDigita2.p-image}
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
  Notes:       Busca £ltimo n°vel e imprime
------------------------------------------------------------------------------*/
define buffer bfDigita2 for tt-digita.

for each  bfDigita2
    where bfDigita2.cod-dimens-pai = bfDigita.cod-dimensao no-lock
    break by bfDigita2.cod-dimens-pai:
    if first-of(bfDigita2.cod-dimens-pai) then do:
        {abp/ab0613.i2 bfDigita.p-image}
        assign cDesc2:label in frame f-dados  = trim(return-value).
        assign cDesc2:label in frame f-dados2 = trim(return-value).

        {abp/ab0613.i2 bfDigita2.p-image}
        assign cDesc3:label in frame f-dados  = trim(return-value).
        assign cDesc3:label in frame f-dados2 = trim(return-value).

        if tt-param.lTipo = 1 then
           display 
            if bfDigita.p-image = 7 
               then bfDigita.cod-oficial 
               else if bfDigita.p-image = 2 
               then bfDigita.cod-oficial + " - " + bfDigita.desc-dimensao 
               else bfDigita.desc-dimensao @ cDesc2
               with frame f-dados.
        if tt-param.lTipo = 2 then
           display if bfDigita.p-image = 7 
               then bfDigita.cod-oficial 
               else if bfDigita.p-image = 2 
               then bfDigita.cod-oficial + " - " + bfDigita.desc-dimensao 
               else bfDigita.desc-dimensao @ cDesc2
               with frame f-dados2.

    end.
    case bfDigita2.iPrazo:
        when 0 then do:
            {utp/ut-liter.i " "}
        end.
        when 1 then do:
            {utp/ut-liter.i "Antes"}
        end.
        when 2 then do:
            {utp/ut-liter.i "Dentro"}
        end.
        when 3 then do:
            {utp/ut-liter.i "Ap¢s"}
        end.
    end case.

    if tt-param.lTipo = 1 then do:
       display if bfDigita2.p-image = 7 
               then bfDigita2.cod-oficial 
               else if bfDigita2.p-image = 2 
               then bfDigita2.cod-oficial + " - " + bfDigita2.desc-dimensao 
               else bfDigita2.desc-dimensao @ cDesc3
               bfDigita2.uso-real           @ bfDigita.uso-real
               bfDigita2.uso-padrao         @ bfDigita.uso-padrao
               bfDigita2.diferenca          @ bfDigita.diferenca
               bfDigita2.un                 @ bfDigita.un
               bfDigita2.perc-desvio        @ bfDigita.perc-desvio
              return-value                  @ cPrazo
           with frame f-dados.
       down with frame f-dados.
    end.
    if tt-param.lTipo = 2 then do:
       display if bfDigita2.p-image = 7 
               then bfDigita2.cod-oficial 
               else if bfDigita2.p-image = 2 
               then bfDigita2.cod-oficial + " - " + bfDigita2.desc-dimensao 
               else bfDigita2.desc-dimensao @ cDesc3
               bfDigita2.quantidade    @ bfDigita.quantidade
               bfDigita2.valor         @ bfDigita.valor   
           with frame f-dados2.
       down with frame f-dados2.
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
  Notes:       Define os valores que ser∆o mostrados o cabeáalho e rodapÇ
------------------------------------------------------------------------------*/
assign c-programa = "AB/0613"
       c-versao   = "2.00"
       c-revisao  = "000"
       /** Define o destino do arquivo a ser gerado **/
.
&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
    ASSIGN cAuxTraducao001 = {varinc/var00002.i 04 integer(tt-param.destino)}.
    run utp/ut-liter.p (input replace(trim(cauxtraducao001)," ","_"),
                        INPUT "",
                        INPUT "").
    ASSIGN c-destino  = RETURN-VALUE.
&else
    ASSIGN c-destino  = {varinc/var00002.i 04 integer(tt-param.destino)}.
&endif

/** Busca os parÉmetros criados na interface gr†fica **/
find first tt-param.

/** Busca empresa padr∆o **/
find first param-global no-lock no-error.
if  available param-global then
    assign c-empresa = param-global.grupo.

/** Guarda valores para imprimir t°tulos **/
{utp/ut-liter.i "Eventos Realizados em Compartimentos e Filtros" *}
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
  Notes:       Corpo princiapl da aplicaá∆o
------------------------------------------------------------------------------*/
/** Mostra frames de cabeáalho e rodapÇ padr‰es da Datasul **/
view frame f-cabec.
view frame f-rodape. 

/** Inicializa programa de acompanhamento padr∆o Datasul **/
run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp(input c-titulo-relat).

/*********************************************************************
   Neste espaáo deve-se colocar a l¢gica para busca as informaá‰es e 
   tambÇm para fazer o display, pode-se inclui a chamada de procedures
   ou fazer a l¢gica neste espaáo.
*********************************************************************/

/** Imprime os dados **/
run imprimeDados (tt-param.c-cod).

/*********************************************************************
   Fim do espaáo para l¢gica de c†lculo e display das informaá‰es
*********************************************************************/

/** Mostra parÉmetros selecionados **/
if tt-param.lParam then
    run displayParametros in this-procedure.

/** Finaliza programa de acompanhamento padr∆o Datasul **/
run pi-finalizar in h-acomp.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

