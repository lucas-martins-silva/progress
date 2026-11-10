/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*******************************************************************************
**   Programa..: bc8105.i
**
**   Vers∆o....: 02.00.00 - Datasul
**
**   Objetivo..: Include de temp-tables para Proxy de Acesso a tabela Cod-rejeicao para 
**               o BC
**
**   Autor.....: Carlos Alberto Soares Pereira - Nov/1999
*********************************************************************************/

/**********************************  bc8105.i  **********************************/
Define temp-table ttParamCod-rejeicao NO-UNDO
    Field codigo-rejei-ini    as Integer   Label 'Rejeiá∆o Inicial'
    Field codigo-rejei-fim    as Integer   Label 'Rejeiá∆o Final'
    Field descricao-ini       as Character Label 'Descricao Inicial'
    Field descricao-fim       as Character Label 'Descricao Final'
    Field tipo-rejeicao-ini   as Integer   Label 'Tipo Rejeiá∆o Inicial'
    Field tipo-rejeicao-fim   as Integer   Label 'Tipo Rejeiá∆o Final'
    Field acess-mode          as Integer   Label 'Tipo de Acesso'
            /* 0=current,1=First,2=Prev,3=Next,4=Last,5=each 6=PrevN 7=NextN */
    Field num-of-rec          as Integer   Label 'N£mero Registros'  /* only if acess-mode eq 6 or 7 */
    Field record-phrase       as Integer   Label 'Frase Registro'.   /* only if acess-mode eq 5 */

Define temp-table ttCod-rejeicao NO-UNDO
    Field codigo-rejei      as Integer   Label 'Rejeiá∆o'
    Field descricao         as Character Label 'Descricao'
    Field tipo-rejeicao     as Integer   Label 'Tipo Rejeiá∆o'
    Field rowid-value       as rowid
        Index cdrj     codigo-rejei
        Index dscrc    descricao.    

Define Frame fttCod-rejeicao
        ttCod-rejeicao
        with STREAM-IO.
Define Frame fttParamCod-rejeicao
        ttParamCod-rejeicao
        with STREAM-IO.
/**********************************  bc8105.i  **********************************/

