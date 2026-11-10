/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*******************************************************************************
**   Programa..: bc8107.i
**
**   Vers∆o....: 02.00.00 - Datasul
**
**   Objetivo..: Include de temp-tables para Proxy de Acesso a tabela Familia para 
**               o BC
**
**   Autor.....: Carlos Alberto Soares Pereira - Nov/1999
*********************************************************************************/

/**********************************  bc8107.i  **********************************/
Define temp-table ttParamFamilia NO-UNDO
    Field fm-codigo-ini    as Character Label 'Fam°lia Inicial'
    Field fm-codigo-fim    as Character Label 'Fam°lia Final'
    Field descricao-ini    as Character Label 'Descricao Inicial'
    Field descricao-fim    as Character Label 'Descricao Final'
    Field acess-mode          as Integer   Label 'Tipo de Acesso'
            /* 0=current,1=First,2=Prev,3=Next,4=Last,5=each 6=PrevN 7=NextN */
    Field num-of-rec       as Integer   Label 'N£mero Registros'  /* only if acess-mode eq 6 or 7 */
    Field record-phrase    as Integer   Label 'Frase Registro'.   /* only if acess-mode eq 5 */

Define temp-table ttFamilia NO-UNDO
    Field fm-codigo         as Character Label 'Fam°lia'
    Field descricao         as Character Label 'Descricao'
    Field rowid-value       as rowid
        Index fmcdg    fm-codigo
        Index dscrc    descricao.    
        
Define Frame fttFamilia
        ttFamilia
        with STREAM-IO.
Define Frame fttParamFamilia
        ttParamFamilia
        with STREAM-IO.
/**********************************  bc8107.i  **********************************/

