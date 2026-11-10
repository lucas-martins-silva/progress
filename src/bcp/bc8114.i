/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*******************************************************************************
**   Programa..: bc8114.i
**
**   Vers∆o....: 02.00.00 - Datasul
**
**   Objetivo..: Include de temp-tables para Proxy de Acesso a tabela Referencia para 
**               o BC
**
**   Autor.....: Carlos Alberto Soares Pereira - Nov/1999
*********************************************************************************/

/**********************************  bc8114.i  **********************************/
Define temp-table ttParamReferencia NO-UNDO
    Field cod-refer-ini    as Character Label 'Referenciaimento Inicial'
    Field cod-refer-fim    as Character Label 'Referenciaimento Final'
    Field Descricao-ini    as Character Label 'Descricao Inicial'
    Field Descricao-fim    as Character Label 'Descricao Final'
    Field acess-mode       as Integer   Label 'Tipo de Acesso'
            /* 0=current,1=First,2=Prev,3=Next,4=Last,5=each 6=PrevN 7=NextN */
    Field num-of-rec       as Integer   Label 'N£mero Registros'  /* only if acess-mode eq 6 or 7 */
    Field record-phrase    as Integer   Label 'Frase Registro'.   /* only if acess-mode eq 5 */

Define temp-table ttReferencia NO-UNDO
    Field cod-refer      as Character Label 'Referencia'
    Field Descricao      as Character Label 'Descricao'
    Field rowid-value      as rowid
        Index cdrfr   cod-refer
        Index dscrc   Descricao.    

Define Frame fttReferencia
        ttReferencia
        with STREAM-IO.
Define Frame fttParamReferencia
        ttParamReferencia
        with STREAM-IO.
/**********************************  bc8114.i  **********************************/

