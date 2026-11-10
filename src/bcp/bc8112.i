/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*******************************************************************************
**   Programa..: bc8112.i
**
**   Vers∆o....: 02.00.00 - Datasul
**
**   Objetivo..: Include de temp-tables para Proxy de Acesso a tabela Ord-prod para 
**               o BC
**
**   Autor.....: Carlos Alberto Soares Pereira - Nov/1999
*********************************************************************************/

/**********************************  bc8112.i  **********************************/
Define temp-table ttParamOrd-prod NO-UNDO
    Field nr-ord-produ-ini as Integer   Label 'Ordem de Produá∆o Inicial'
    Field nr-ord-produ-fim as Integer   Label 'Ordem de Produá∆o Final'
    Field it-codigo-ini    as Character Label 'Codigo do Item Inicial'
    Field it-codigo-fim    as Character Label 'Codigo do Item Final'
    Field cod-estabel-ini  as Character Label 'Estabelecimento Inicial'
    Field cod-estabel-fim  as Character Label 'Estabelecimento Final'
    Field cod-depos-ini    as Character Label 'Dep¢sito Inicial'
    Field cod-depos-fim    as Character Label 'Dep¢sito Final'
    Field acess-mode       as Integer   Label 'Tipo de Acesso'
            /* 0=current,1=First,2=Prev,3=Next,4=Last,5=each 6=PrevN 7=NextN */
    Field num-of-rec       as Integer   Label 'N£mero Registros'  /* only if acess-mode eq 6 or 7 */
    Field record-phrase    as Integer   Label 'Frase Registro'.   /* only if acess-mode eq 5 */

Define temp-table ttOrd-prod NO-UNDO
    Field nr-ord-produ as Integer   Label 'Ordem de Produá∆o'
    Field it-codigo    as Character Label 'Codigo do Item'
    Field cod-estabel  as Character Label 'Estabelecimento'
    Field cod-depos    as Character Label 'Dep¢sito'
    Field rowid-value      as Rowid    
        Index nrrdprd nr-ord-produ     
        Index tcdg    it-codigo
        Index cdstbl  cod-estabel
        Index cddps   cod-depos.
    
Define Frame fttOrd-prod
        ttOrd-prod
        with STREAM-IO.
Define Frame fttParamOrd-prod
        ttParamOrd-prod
        with STREAM-IO.
/**********************************  bc8112.i  **********************************/

