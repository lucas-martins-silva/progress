/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*******************************************************************************
**   Programa..: bc8109.i
**
**   Vers∆o....: 02.00.00 - Datasul
**
**   Objetivo..: Include de temp-tables para Proxy de Acesso a tabela Localizacao para 
**               o BC
**
**   Autor.....: Carlos Alberto Soares Pereira - Nov/1999
*********************************************************************************/

/**********************************  bc8109.i  **********************************/
Define temp-table ttParamLocalizacao NO-UNDO
    Field cod-estabel-ini  as Character Label 'Estabelecimento Inicial'
    Field cod-estabel-fim  as Character Label 'Estabelecimento Final'
    Field cod-depos-ini    as Character Label 'Dep¢sito Inicial'
    Field cod-depos-fim    as Character Label 'Dep¢sito Final'
    Field cod-localiz-ini  as Character Label 'Localizaá∆o Inicial' FORMAT "x(20)"
    Field cod-localiz-fim  as Character Label 'Localizaá∆o Final'   FORMAT "x(20)"
    Field descricao-ini    as Character Label 'Descriá∆o Inicial'
    Field descricao-fim    as Character Label 'Descriá∆o Final'
    Field acess-mode       as Integer   Label 'Tipo de Acesso'
            /* 0=current,1=First,2=Prev,3=Next,4=Last,5=each 6=PrevN 7=NextN */
    Field num-of-rec       as Integer   Label 'N£mero Registros'  /* only if acess-mode eq 6 or 7 */
    Field record-phrase    as Integer   Label 'Frase Registro'.   /* only if acess-mode eq 5 */

Define temp-table ttLocalizacao NO-UNDO
    Field cod-estabel      as Character Label 'Estabelecimento'
    Field cod-depos        as Character Label 'Dep¢sito'
    Field cod-localiz      as Character Label 'Localizaá∆o' FORMAT "x(20)"
    Field descricao        as Character Label 'Descriá∆o'
    Field rowid-value      as rowid
        Index cdstbl   cod-estabel
        Index cddps    cod-depos
        Index cdlclz   cod-localiz
        Index dscrc    descricao.

Define Frame fttLocalizacao
        ttLocalizacao
        with STREAM-IO.
Define Frame fttParamLocalizacao
        ttParamLocalizacao
        with STREAM-IO.
/**********************************  bc8109.i  **********************************/

