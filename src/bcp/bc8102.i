/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*******************************************************************************
**   Programa..: bc8102.i
**
**   Vers∆o....: 02.00.00 - Datasul
**
**   Objetivo..: Include de temp-tables para Proxy de Acesso a tabela Conta-contab para 
**               o BC
**
**   Autor.....: Carlos Alberto Soares Pereira - Nov/1999
*********************************************************************************/

/**********************************  bc8102.i  **********************************/
Define temp-table ttParamConta-contab NO-UNDO
    Field ep-codigo-ini      LIKE mguni.empresa.ep-codigo Label 'Empresa Inicial'
    Field ep-codigo-fim      LIKE mguni.empresa.ep-codigo Label 'Empresa Inicial'
    Field ct-codigo-ini      as Character Label 'Conta Inicial'
    Field ct-codigo-fim      as Character Label 'Conta Final'
    Field sc-codigo-ini      as Character Label 'SubConta Inicial'
    Field sc-codigo-fim      as Character Label 'SubConta Final'
    Field conta-contabil-ini as Character Label 'Conta Cont†bil Inicial'
    Field conta-contabil-fim as Character Label 'Conta Cont†bil Final'
    Field tipo-ini           as Integer   Label 'Tipo Inicial'
    Field tipo-fim           as Integer   Label 'Tipo Final'
    Field estado-ini         as Integer   Label 'Estado Inicial'
    Field estado-fim         as Integer   Label 'Estado Final'
    Field estoque-ini        as Integer   Label 'Estoque Inicial'
    Field estoque-fim        as Integer   Label 'Estoque Final'
    Field titulo-ini         as Character Label 'T°tulo Inicial'
    Field titulo-fim         as Character Label 'T°tulo Final'
    Field acess-mode         as Integer   Label 'Tipo de Acesso'
            /* 0=current,1=First,2=Prev,3=Next,4=Last,5=each 6=PrevN 7=NextN */
    Field num-of-rec         as Integer   Label 'N£mero Registros'  /* only if acess-mode eq 6 or 7 */
    Field record-phrase      as Integer   Label 'Frase Registro'.   /* only if acess-mode eq 5 */

Define temp-table ttConta-contab NO-UNDO
    Field ep-codigo        LIKE mguni.empresa.ep-codigo   Label 'Empresa'
    Field ct-codigo        as Character Label 'Conta'
    Field sc-codigo        as Character Label 'SubConta'
    Field conta-contabil   as Character Label 'Conta Cont†bil'
    Field tipo             as Integer   Label 'Tipo'
    Field estado           as Integer   Label 'Estado'
    Field estoque          as Integer   Label 'Estoque'
    Field titulo           as Character Label 'T°tulo'
    Field rowid-value      as rowid
        Index pcdg     ep-codigo
        Index ctcdg    ct-codigo
        Index sccdg    sc-codigo
        Index cntcntbl conta-contabil
        Index tp       tipo
        Index std      estado
        Index stqu     estoque
        Index ttl      titulo.

Define Frame fttConta-contab
        ttConta-contab
        with STREAM-IO.
Define Frame fttParamConta-contab
        ttParamConta-contab
        with STREAM-IO.
/**********************************  bc8102.i  **********************************/

