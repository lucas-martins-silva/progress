/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9050 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM9050 MIM}
&ENDIF



{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}


PROCEDURE altera-movto-ato:
/*Tabela movto-ato*/
DEFINE INPUT PARAMETER c-item-old LIKE ITEM.it-codigo.
DEFINE INPUT PARAMETER c-item-new LIKE ITEM.it-codigo.

  for each movto-ato fields (it-codigo)
     where movto-ato.it-codigo = c-item-old exclusive-lock:
     assign movto-ato.it-codigo = c-item-new.
  end.

END PROCEDURE.


PROCEDURE altera-item-re:
/*Tabela Item-re*/
DEFINE INPUT PARAMETER c-item-old LIKE ITEM.it-codigo.
DEFINE INPUT PARAMETER c-item-new LIKE ITEM.it-codigo.

  for each item-re fields (it-codigo)
         where item-re.it-codigo = c-item-old exclusive-lock:
        assign item-re.it-codigo = c-item-new.
  end.

END PROCEDURE.

   
   
