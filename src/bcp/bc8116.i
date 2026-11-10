/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*******************************************************************************
**   Programa..: bc8115.i
**
**   Vers∆o....: 02.00.00 - Datasul
**
**   Objetivo..: Include de temp-tables para Proxy de Acesso a tabela Natur-Oper para 
**               o BC
**
**   Autor.....: Carlos Alberto Soares Pereira - Nov/1999
*********************************************************************************/

/**********************************  bc8115.i  **********************************/
Define temp-table ttParamNatur-Oper NO-UNDO
    Field nat-operacao-ini        as Character Label 'Natureza Operaá∆o Inicial'
    Field nat-operacao-fim        as Character Label 'Natureza Operaá∆o Final'
    Field acess-mode       as Integer   Label 'Tipo de Acesso'
            /* 0=current,1=First,2=Prev,3=Next,4=Last,5=each 6=PrevN 7=NextN */
    Field num-of-rec       as Integer   Label 'N£mero Registros'  /* only if acess-mode eq 6 or 7 */
    Field record-phrase    as Integer   Label 'Frase Registro'.   /* only if acess-mode eq 5 */

Define temp-table ttNatur-Oper NO-UNDO
    Field nat-operacao     as Character Label 'Natureza Operaá∆o'
    Field rowid-value      as rowid
        Index sr   nat-operacao.

Define Frame ttNatur-Oper
        ttNatur-Oper
        with STREAM-IO.
Define Frame fttParamNatur-Oper
        ttParamNatur-Oper
        with STREAM-IO.
/**********************************  bc8115.i  **********************************/

