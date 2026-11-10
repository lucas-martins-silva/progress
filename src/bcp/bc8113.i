/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*******************************************************************************
**   Programa..: bc8113.i
**
**   Vers∆o....: 02.00.00 - Datasul
**
**   Objetivo..: Include de temp-tables para Proxy de Acesso a tabela Item-fornec para 
**               o BC
**
**   Autor.....: Carlos Alberto Soares Pereira - Nov/1999
*********************************************************************************/

/**********************************  bc8113.i  **********************************/
Define temp-table ttParamItem-fornec NO-UNDO
    Field it-codigo-ini      as Character Label 'Codigo do Item Inicial'
    Field it-codigo-fim      as Character Label 'Codigo do Item Final'
    Field item-do-forn-ini   as Character Label 'Iten do Fornecedor Inicial'
    Field item-do-forn-fim   as Character Label 'Iten do Fornecedor Final'
    Field cod-emitente-ini   as Integer   Label 'Emitente Inicial'
    Field cod-emitente-fim   as Integer   Label 'Emitente Final'
    Field acess-mode         as Integer   Label 'Tipo de Acesso'
            /* 0=current,1=First,2=Prev,3=Next,4=Last,5=each 6=PrevN 7=NextN */
    Field num-of-rec         as Integer   Label 'N£mero Registros'  /* only if acess-mode eq 6 or 7 */
    Field record-phrase      as Integer   Label 'Frase Registro'.   /* only if acess-mode eq 5 */

Define temp-table ttItem-fornec NO-UNDO
    Field it-codigo      as Character Label 'Codigo do Item'
    Field item-do-forn   as Character Label 'Iten do Fornecedor'
    Field cod-emitente   as Integer   Label 'Emitente'
    Field rowid-value    as Rowid    
        Index tcdg   it-codigo
        Index nmbrv  item-do-forn
        Index cdmtnt cod-emitente.
    
Define Frame fttItem-fornec
        ttItem-fornec
        with STREAM-IO.
Define Frame fttParamItem-fornec
        ttParamItem-fornec
        with STREAM-IO.
/**********************************  bc8113.i  **********************************/

