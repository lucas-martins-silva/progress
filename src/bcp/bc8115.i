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
**   Objetivo..: Include de temp-tables para Proxy de Acesso a tabela Serie para 
**               o BC
**
**   Autor.....: Carlos Alberto Soares Pereira - Nov/1999
*********************************************************************************/

/**********************************  bc8115.i  **********************************/
Define temp-table ttParamSerie NO-UNDO
    Field Serie-ini        as Character Label 'Serieimento Inicial'
    Field Serie-fim        as Character Label 'Serieimento Final'
    Field acess-mode       as Integer   Label 'Tipo de Acesso'
            /* 0=current,1=First,2=Prev,3=Next,4=Last,5=each 6=PrevN 7=NextN */
    Field num-of-rec       as Integer   Label 'N£mero Registros'  /* only if acess-mode eq 6 or 7 */
    Field record-phrase    as Integer   Label 'Frase Registro'.   /* only if acess-mode eq 5 */

Define temp-table ttSerie NO-UNDO
    Field Serie          as Character Label 'Serie'
    Field rowid-value      as rowid
        Index sr   Serie.

Define Frame fttSerie
        ttSerie
        with STREAM-IO.
Define Frame fttParamSerie
        ttParamSerie
        with STREAM-IO.
/**********************************  bc8115.i  **********************************/

