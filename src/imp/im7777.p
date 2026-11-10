/*******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL , sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.  
********************************************************************************/
{include/i-prgvrs.i IM7777 2.00.01.043 } /*** "010143" 09/07/2026 16:01:59 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im7777 MIM}
&ENDIF
    
/**********************************************************************************************
**
** IM7777 - Integracao entre Importacao e Recebimento (EMS)
**    
** Objetivo: Criacao dos arquivos tt-docum-est e tt-item-doc-est para posterior 
**           geracao dos arquivos docum-est e item-doc-est ( EMS: reapi190.p / Magnus: re8888.p). 
** 
***********************************************************************************************/

{cdp/cdcfgmat.i} /* Definicao de pre-processadores */
{cdp/cdcfgman.i} /* Definicao de pre-processadores */
{cdp/cdcfgdis.i} /* Definicao de pre-processadores */

{include/i-epc200.i im7777}

{rep/reapi190a.i} /* Definicao das temp-tables utilizadas pela api reapi190 - EMS*/
{rep/reapi190b.i2} /* Definicao das temp-tables utilizadas pela api reapi190 - EMS*/
{cdp/cd4305.i1}  /* Definicao das temp-tables TT-DOCTO, TT-IT-DOCTO E TT-IT-IMPOSTO */    
{btb/btb009za.i} /* Definicao das temp-tables comunicao api btb009za.p */

{imp/im7777.i11} /* include com o fonte do programa para n’o duplicar codigo no magnus */

/* IM7777.P */


