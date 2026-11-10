/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9112C 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9112C MBC}
&ENDIF


/********************************************************************************************
**   Programa..: bc9112c.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - jan/2001 - Karla Cristiane Klemke                           **
**                                                                                         **
**   Objetivo..: Efetuar Login p Coletor em Ambiente EMS                                **
**                                                                                         **
********************************************************************************************/
Define variable v_log_impl_cl   As logical  no-undo.

{cdp/cdapi523.i h-param-global} 
run cdp/cdapi523.p persistent set h-param-global. /* Magnus */

if  valid-handle(h-param-global) then do:

    if return-value = "OK" then do:     /* Existe Param-Global */
        assign v_log_impl_cl = modulo-cl().
        
        if not v_log_impl_cl then do:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Coleta_Dados_Nao_Implantado(EMS)" *}
            message RETURN-VALUE view-as alert-box.
            quit.              
        end. /* if */

    end. /* if */
    else do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Parametros_Globais_Nao_Implantado(EMS)" *}
        message RETURN-VALUE view-as alert-box.
        quit.                
    end. /* else */

end.
delete procedure h-param-global.
