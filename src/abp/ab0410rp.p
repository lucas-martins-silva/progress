/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0410RP 2.00.00.002 } /*** 010002 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0410rp MAB}
&ENDIF


{include/i_fnctrad.i}
/*****************************************************************************
**
**       PROGRAMA: AB0410RP.p
**
**       DATA....: Agosto de 2003
**
**       AUTOR...: Marcio Willwock - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Integra‡Æo Frotas com EMS (estoque)
**
*****************************************************************************/
                                              /** Defini‡Æo dos Parƒmetros **/
{abp/ab9004.i} /** Defini‡Æo da Temp-table RowErrors **/
{abp/abapi005.i} /** Temp-Tables tt-param **/
{abp/abapi003.i} /** Defini‡Æo da ttDocumento **/

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

/* Defini‡Æo e prepara‡Æo dos parƒmetros */
def temp-table tt-raw-digita
   field raw-digita as raw.
   
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

find first tt-param.

/***********************************************************************/
                                           /** Defini‡Æo de Vari veis **/
DEFINE VARIABLE h-acomp     AS HANDLE  NO-UNDO.

/***********************************************************************/
                                                /** Cabe‡alho e Forms **/

{abp/ab0410.i} /*--- Defini‡Æo dos frames ---*/

{include/i-rpvar.i}
assign c-programa = "AB/0410"
       c-versao   = "2.00"
       c-revisao  = "000"
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

find first param-global no-lock no-error.
if  available param-global then
    assign c-empresa = param-global.grupo.

{utp/ut-liter.i "Integra‡Æo Frotas / EMS" *}
assign c-titulo-relat = trim(return-value).

{utp/ut-liter.i ABASTECIMENTO *}
assign c-sistema = trim(return-value).
       
{include/i-rpcab.i}    
{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape. 

/***********************************************************************/
                                               /** In¡cio do Programa **/
run utp/ut-acomp.p persistent set h-acomp.

run pi-inicializar in h-acomp(input c-titulo-relat).

RUN pi-desabilita-cancela in h-acomp.

RUN abp/abapi005.p (INPUT  h-acomp,
                    INPUT  TABLE tt-param,
                    INPUT  TABLE ttDocumento,
                    OUTPUT TABLE RowErrors).

/***********************************************************************/
                                                  /** P gina de Erros **/
if can-find(first RowErrors) then do:
    FOR EACH RowErrors no-lock:
        display ErrorSequence   
                ErrorNumber     
                ErrorDescription FORMAT "X(90)"
            with frame f-erro.
        down with frame f-erro.
    END.  
end.

/***********************************************************************/
                                             /** P gina de Parƒmetros **/
page.

&IF DEFINED(bf_mnt_ems206b) &THEN
    ASSIGN cUnidNegocIni = tt-param.unidNegocIni
           cUnidNegocFim = tt-param.unidNegocFim.

    IF NOT l-usa-unid-negoc THEN
        ASSIGN cFaixa     = "":U
               c-liter-un = "":U.
&ENDIF

DISPLAY /*SELE€ÇO*/ 
        c-liter-sel       
        tt-param.dataMovimento
        tt-param.estabInicial 
        tt-param.estabFinal   
        tt-param.depositoIni
        tt-param.depositoFim
        &IF DEFINED(bf_mnt_ems206b) &THEN
        c-liter-un
        cUnidNegocIni 
        cUnidNegocFim
        cFaixa
        &ENDIF
        /*IMPRESSÇO*/
        c-liter-imp          
        c-destino            
        tt-param.arquivo
        tt-param.usuario     
    WITH FRAME f-param-definidos.

/***********************************************************************/
                                          /** Finaliza‡Æo do Programa **/
run pi-finalizar in h-acomp.

{include/i-rpclo.i}     

return "OK". 

/*--- Fim do Programa ---*/
