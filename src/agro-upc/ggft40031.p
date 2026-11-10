/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGFT40031 2.00.00.014 } /*** "010014" ***/


/*************************************************************************
**    Programa.:  agro-upc/GGFT40031.p 
**    Objetivo.:  UPC no Bot∆o de Calculo para validar peso da balanáa
**    Data.....:  Agosto/2003
*************************************************************************/

/* --- DAGROOGD-3801 - In°cio - */
{ggp/tt-erro.i}
Def Var h-ggapi106 As handle no-undo.
/* --- DAGROOGD-3801 - Fim - */


Def New Global Shared Var seq-wt-docto-ft4003    Like wt-docto.seq-wt-docto No-undo.
Def New Global Shared Var wh-btcalcula2-ft4003   As Widget-handle           No-undo.
Def New Global Shared Var wh-btcalcula           As Widget-handle           No-undo.

if not connected ('emsgra':U) then
	return "OK":U.
else IF NOT can-find( FIRST param-global WHERE param-global.log-modul-gg = yes) then
    return "OK":U. 


/* --- DAGROOGD-3801 - In°cio - */
   Find First wt-docto No-lock
        Where wt-docto.seq-wt-docto = seq-wt-docto-ft4003 NO-ERROR.
   If  Not Avail wt-docto Then 
       Return "OK".
   
   If Not Valid-handle(h-ggapi106) Then
      Run ggp/ggapi106.p persistent Set h-ggapi106.
   
   /* --- Se o M¢dulo de Gr∆os estiver Ativo, efetua avaliaá∆o de fornecedores nas listas - */
   Run piAvaliarListaFornecedores in h-ggapi106 ( Input  5, /* --- Faturamento - */
                                                  Input  wt-docto.nome-abrev,
                                                  Input  '- Efetivaá∆o NF via FT4003 (C†lculo da Nota)',
                                                  Output Table tt-erro ).
   
   Delete procedure h-ggapi106.
   Assign h-ggapi106 = ?.
   
   Run cdp/cd0666.w ( Input Table tt-erro ).        
   If  Can-find (First tt-erro Where tt-erro.cd-erro <> 56450) Then
       Return 'NOK'.
/* --- DAGROOGD-3801 - Fim - */

APPLY "CHOOSE":U TO wh-btcalcula.



