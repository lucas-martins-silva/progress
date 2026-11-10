/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0404RP 2.00.00.003 } /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0404rp MAB}
&ENDIF


{include/i_fnctrad.i}
/*****************************************************************************
**
**       PROGRAMA: AB0404RP.p
**
**       DATA....: Agosto de 2003
**
**       AUTOR...: Marcio Willwock - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Remonta Motor
**
*****************************************************************************/
                                              /** Defini‡Æo dos Parƒmetros **/
{abp/ab9004.i} /** Defini‡Æo da Temp-table RowErrors **/

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field iEmpIni          like mab-eqpto.ep-codigo
    field iEmpFim          like mab-eqpto.ep-codigo
    field cEqptoIni        like mab-eqpto.cod-eqpto
    field cEqptoFim        like mab-eqpto.cod-eqpto
    field dtData           as date format "99/99/9999"
    FIELD lAvisos          AS LOGICAL.

define shared temp-table tt-digita no-undo
    field ep-codigo        like mab-eqpto.ep-codigo
    field cod-eqpto        like mab-eqpto.cod-eqpto
    index id ep-codigo cod-eqpto.

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

{abp/ab0404.i} /*--- Defini‡Æo dos frames ---*/

{include/i-rpvar.i}
assign c-programa = "AB/0404"
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

{utp/ut-liter.i "Remonta Motor" MAB}
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

find first tt-digita no-lock no-error.
if not avail tt-digita then do:
    /** Busca equipamentos da faixa escolhida **/
    for each  mab-eqpto fields(ep-codigo cod-eqpto)
        where mab-eqpto.ep-codigo    >= tt-param.iEmpIni
        and   mab-eqpto.ep-codigo    <= tt-param.iEmpFim
        and   mab-eqpto.cod-eqpto    >= tt-param.cEqptoIni
        and   mab-eqpto.cod-eqpto    <= tt-param.cEqptoFim
        and   mab-eqpto.idi-tip-eqpto = 1
        and  (mab-eqpto.dat-situacao  = ?
        or    mab-eqpto.dat-situacao >= today) no-lock:
        create tt-digita.
        assign tt-digita.ep-codigo = mab-eqpto.ep-codigo
               tt-digita.cod-eqpto = mab-eqpto.cod-eqpto.
    end.
end.

run pi-inicializar in h-acomp(input c-titulo-relat).

RUN abp/abapi004.p (input  tt-param.dtData,
                    INPUT  tt-param.lAvisos,
                    INPUT  TABLE tt-digita,
                    OUTPUT TABLE RowErrors).

/***********************************************************************/
                                                  /** P gina de Erros **/
if can-find(first RowErrors) then do:
    FOR EACH RowErrors no-lock:
        display ErrorSequence COLUMN-LABEL "Seq. Erro"  
                ErrorNumber     COLUMN-LABEL "Nr. Erro"
                ErrorDescription COLUMN-LABEL "Descri‡Æo Erro" FORMAT "X(40)"
            with frame f-erro.
        down with frame f-erro.
    END.  
end.

/***********************************************************************/
                                             /** P gina de Parƒmetros **/
page.

DISPLAY /*SELE€ÇO*/ 
        c-liter-sel       
        tt-param.iEmpIni     
        tt-param.iEmpFim     
        tt-param.cEqptoIni   
        tt-param.cEqptoFim   
        tt-param.lAvisos
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
