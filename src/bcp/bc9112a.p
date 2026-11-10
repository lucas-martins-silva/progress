/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9112A 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9112A MBC}
&ENDIF


/********************************************************************************************
**   Programa..: bc9112A.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - jan/2001 - Karla Cristiane Klemke                           **
**                                                                                         **
**   Objetivo..: Efetuar Login p Coletor em Ambiente MAGNUS                                **
**                                                                                         **
********************************************************************************************/
/* PROGRAMA EXPEDIDO p MAGNUS 

    /* programa deve ser compilado somente c bases do MAGNUS */
    Define variable i-cont as integer  initial 0 no-undo.

    Define variable h-param-global  As handle no-undo.
    run cdp/cdapi525.p persistent set h-param-global. /* Magnus */

    if valid-handle(h-param-global) then do:

        if return-value = "OK" then do:     /* Existe Param-Global */

            IF  not modulo-cl() then do:
                message 'Coleta Dados Nao Implantado(Magnus)' view-as alert-box.
                quit.
            end. /* if */ 
            do i-cont = 1 to num-dbs:
                if dbtype(ldbname(i-cont)) = "PROGRESS" then do:    
                    create alias dictdb for database value(ldbname(i-cont)).    
                    run bcp/bc9112b.p(input entry(4,session:parameter),
                                      input entry(5,session:parameter)).
                    end. /* if */
            end. /* do */ 
        end. /* if */
        else do:
            message 'Parametro Global Inexistente(Magnus)' view-as alert-box.
            quit.
        end. /* else */
    end.
    if not connected("movadm") then do:
       create alias movadm for database mgadm no-error.
       create alias movcom for database mgcom no-error.
       create alias movind for database mgind no-error.
    end. /* if */

    delete procedure h-param-global.
*/    
return "OK":U.
