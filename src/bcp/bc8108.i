/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*******************************************************************************
**   Programa..: bc8108.i
**
**   Vers∆o....: 02.00.00 - Datasul
**
**   Objetivo..: Include de temp-tables para Proxy de Acesso a tabela Item para 
**               o BC
**
**   Autor.....: Carlos Alberto Soares Pereira - Nov/1999
*********************************************************************************/

/**********************************  bc8108.i  **********************************/
Define temp-table ttParamItem NO-UNDO
    Field it-codigo-ini    as Character Label 'Codigo do Item Inicial'
    Field it-codigo-fim    as Character Label 'Codigo do Item Final'
    Field cod-estabel-ini  as Character Label 'Estabelecimento Inicial'
    Field cod-estabel-fim  as Character Label 'Estabelecimento Final'
    Field fm-codigo-ini    as Character Label 'Familia Item Inicial'
    Field fm-codigo-fim    as Character Label 'Familia Item Final'
    Field desc-item-ini    as Character Label 'Descricao Item Inicial'
    Field desc-item-fim    as Character Label 'Descricao Item Final'
    Field tipo-con-est-ini as Integer   Label 'Tipo Controle Estq Inicial'
    Field tipo-con-est-fim as Integer   Label 'Tipo Controle Estq Final'
    Field un-ini           as Character Label 'Unid Medida Inicial'
    Field un-fim           as Character Label 'Unid Medida Final'
    Field ge-codigo-ini    as Integer   Label 'Grupo Estq Inicial'
    Field ge-codigo-fim    as Integer   Label 'Grupo Estq Final'
    Field acess-mode       as Integer   Label 'Tipo de Acesso'
            /* 0=current,1=First,2=Prev,3=Next,4=Last,5=each 6=PrevN 7=NextN */
    Field num-of-rec       as Integer   Label 'N£mero Registros'  /* only if acess-mode eq 6 or 7 */
    Field record-phrase    as Integer   Label 'Frase Registro'.   /* only if acess-mode eq 5 */

Define temp-table ttItem NO-UNDO
    Field it-codigo    as Character Label 'Codigo do Item'
    Field cod-estabel  as Character Label 'Estabelecimento'
    Field fm-codigo    as Character Label 'Familia Item'
    Field desc-item    as Character Label 'Descricao Item'
    Field tipo-con-est as Integer   Label 'Tipo Controle Estq'
    Field un           as Character Label 'Unid Medida'
    Field ge-codigo    as Integer   Label 'Grupo Estq'
    Field rowid-value      as Rowid    
        Index tcdg   it-codigo
        Index cdstbl cod-estabel
        Index fmcdg  fm-codigo
        Index dsctm  desc-item
        Index tpcmst tipo-con-est
        Index n      un
        Index gcdg   ge-codigo.
    
Define Frame fttItem
        ttItem
        with STREAM-IO.
Define Frame fttParamItem
        ttParamItem
        with STREAM-IO.
/**********************************  bc8108.i  **********************************/

