/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9112B 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9112B MBC}
&ENDIF


/********************************************************************************************
**   Programa..: bc9112b.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - jan/2001 - Karla Cristiane Klemke                           **
**                                                                                         **
**   Objetivo..: Efetuar Login p Coletor em Ambiente MAGNUS (dictdb)                       **
**                                                                                         **
********************************************************************************************/

Define input parameter p-usuario as char no-undo.
Define input parameter p-senha   as char no-undo.
Define variable l-login as logic initial no no-undo.
    
/* PROGRAMA EXPEDIDO PARA MAGNUS     
    assign l-login = setuserid(p-usuario, p-senha, ldbname("dictdb")).
    if l-login = no then do:
       if ldbname("dictdb") = "MGUNI":U or
          ldbname("dictdb") = "MGCLD":U then do:
          do transaction:
              find dictdb._user where dictdb._user._userid = p-usuario exclusive-lock no-error.
              if available dictdb._user then do:
                delete dictdb._user.
              end. /* if */
              create dictdb._user.
              assign dictdb._user._userid = p-usuario
                     dictdb._user._user-name = p-usuario
                     dictdb._user._password = encode(p-senha).                                    
           end. /* do */    
           assign l-login = setuserid(p-usuario, p-senha, ldbname("dictdb")).
       end. /* if */
       else do:
          message "Nao foi possivel setar o usuario no banco" caps(ldbname("dictdb")) view-as alert-box.
          quit.
       end. /* else */
    end. /* if */ 
*/      
return "OK":U.
