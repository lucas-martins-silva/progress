/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9051 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im9051 MIM}
&ENDIF

/******************************************************************************************
    Objetivo:   Verifica se o estabelecimento esta parametrizado para cotar automaticamente
                o IPI. Em caso positivo o campo aliquota-ipi devera ser desabilitado.
    Parametros: i-cod-emitente      - Emitente da cotacao
                c-cod-estabel       - Estabelecimento da ordem de compra
                l-habilita-aliq-ipi - Retorna se campo devera ser desabilitado 
******************************************************************************************/    
    define input  parameter i-cod-emitente      as integer   format ">>>>>>>>9":U no-undo. 
&IF "{&mguni_version}" >= "2.071" &THEN
    define input  parameter c-cod-estabel       as character format "x(05)":U      no-undo.
&ELSE
    define input  parameter c-cod-estabel       as character format "x(3)":U      no-undo.
&ENDIF
    define output parameter l-habilita-aliq-ipi as logical                        no-undo.
    
    for first param-global fields (modulo-07) no-lock: end.

    for first emitente fields (natureza)
        where emitente.cod-emitente = i-cod-emitente no-lock: end.
        
    for first param-imp fields (log-cotac-autom-ipi)
        where param-imp.cod-estabel = c-cod-estabel no-lock: end.

    if  param-global.modulo-07
    and avail emitente
    and emitente.natureza > 2 /* Estrangeiro ou Trading */
    and avail param-imp
    and param-imp.log-cotac-autom-ipi then
        assign l-habilita-aliq-ipi = no.
    else
        assign l-habilita-aliq-ipi = yes.
