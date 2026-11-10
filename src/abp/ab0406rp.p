/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0406RP 2.00.00.002}  /*** 010002 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0406rp MAB}
&ENDIF


{include/i_fnctrad.i}
/*****************************************************************************
**
**       PROGRAMA: AB0406RP.p
**
**       DATA....: Outubro de 2003
**
**       AUTOR...: Marcio Willwock - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Elimina‡Æo Eventos Programados
**
*****************************************************************************/
                                              /** Defini‡Æo dos Parƒmetros **/
{abp/abapi006.i1} /** tt-param **/
{abp/abapi006.i}  /** rowErrors ttCriados **/

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    index id ordem.

/**Associar os Erros aos equipamentos**/
define temp-table RowErrorsEqpto NO-UNDO LIKE RowErrors 
    FIELD ep-codigo LIKE mab-eqpto.ep-codigo 
    FIELD cod-eqpto LIKE mab-eqpto.cod-eqpto.

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

{abp/ab0406.i} /*--- Defini‡Æo dos frames ---*/

{include/i-rpvar.i}
assign c-programa = "AB/0406"
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

{utp/ut-liter.i "Elimina‡Æo Eventos Programados" *}
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

RUN abp/abapi006.p (INPUT  TABLE tt-param,
                    OUTPUT TABLE RowErrorsEqpto,
                    OUTPUT TABLE ttCriados).

/***********************************************************************/
                                                  /** P gina de Erros **/
if can-find(first RowErrorsEqpto) then do:
    FOR EACH RowErrorsEqpto NO-LOCK 
        BY RowErrorsEqpto.ep-codigo BY RowErrorsEqpto.cod-eqpto:
        display RowErrorsEqpto.ep-codigo
                RowErrorsEqpto.cod-eqpto
                RowErrorsEqpto.ErrorNumber     
                RowErrorsEqpto.ErrorDescription 
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
        tt-param.dataIni   
        tt-param.dataFim   
        tt-param.docIni    
        tt-param.docFim    
        tt-param.EmpIni    
        tt-param.EmpFim    
        tt-param.EqptoIni   
        tt-param.EqptoFim  
        tt-param.EventIni  
        tt-param.EventFim  
        tt-param.SubIni      
        tt-param.SubFim    
        &IF DEFINED(bf_mnt_ems206b) &THEN
        c-liter-un
        cUnidNegocIni 
        cUnidNegocFim
        cFaixa
        &ENDIF
        /*PAR¶METRO*/
        c-liter-par          
        tt-param.lVencido
        tt-param.lVencer
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
