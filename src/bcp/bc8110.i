/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*******************************************************************************
**   Programa..: bc8110.i
**
**   Vers∆o....: 02.00.00 - Datasul
**
**   Objetivo..: Include de temp-tables para Proxy de Acesso a tabela Lote para 
**               o BC
**
**   Autor.....: Carlos Alberto Soares Pereira - Nov/1999
*********************************************************************************/

/**********************************  bc8110.i  **********************************/
Define temp-table ttParamLote NO-UNDO
    Field nr-lote-ini      as Character Label 'Numero Lote Inicial'
    Field nr-lote-fim      as Character Label 'Numero Lote Final'
    Field it-codigo-ini    as Character Label 'Item Inicial'
    Field it-codigo-fim    as Character Label 'Item Final'
    Field acess-mode       as Integer   Label 'Tipo de Acesso'
            /* 0=current,1=First,2=Prev,3=Next,4=Last,5=each 6=PrevN 7=NextN */
    Field num-of-rec       as Integer   Label 'N£mero Registros'  /* only if acess-mode eq 6 or 7 */
    Field record-phrase    as Integer   Label 'Frase Registro'.   /* only if acess-mode eq 5 */

Define temp-table ttLote NO-UNDO
    Field nr-lote          as Character Label 'Numero Lote'
    Field it-codigo        as Character Label 'Item'
    Field rowid-value      as rowid
        Index nrlt     nr-lote
        Index itcdg    it-codigo.
        
Define Frame fttLote
        ttLote
        with STREAM-IO.
Define Frame fttParamLote
        ttParamLote
        with STREAM-IO.
/**********************************  bc8110.i  **********************************/

