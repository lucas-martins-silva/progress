/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*******************************************************************************
**   Programa..: bc8104.i
**
**   Vers∆o....: 02.00.00 - Datasul
**
**   Objetivo..: Include de temp-tables para Proxy de Acesso a tabela Estabelec para 
**               o BC
**
**   Autor.....: Carlos Alberto Soares Pereira - Nov/1999
*********************************************************************************/

/**********************************  bc8104.i  **********************************/
Define temp-table ttParamEstabelec NO-UNDO
    Field cod-estabel-ini    as Character Label 'Estabelecimento Inicial'
    Field cod-estabel-fim    as Character Label 'Estabelecimento Final'
    Field Nome-ini           as Character Label 'Nome Inicial'
    Field Nome-fim           as Character Label 'Nome Final'
    Field acess-mode         as Integer   Label 'Tipo de Acesso'
            /* 0=current,1=First,2=Prev,3=Next,4=Last,5=each 6=PrevN 7=NextN */
    Field num-of-rec         as Integer   Label 'N£mero Registros'  /* only if acess-mode eq 6 or 7 */
    Field record-phrase      as Integer   Label 'Frase Registro'.   /* only if acess-mode eq 5 */

Define temp-table ttEstabelec NO-UNDO
    Field cod-estabel      as Character Label 'Estabelecimento'
    Field Nome             as Character Label 'Nome'
    Field rowid-value      as rowid
        Index cdstbl   cod-estabel
        Index nm       nome.    

Define Frame fttEstabelec
        ttEstabelec
        with STREAM-IO.
Define Frame fttParamEstabelec
        ttParamEstabelec
        with STREAM-IO.
/**********************************  bc8104.i  **********************************/

