/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*******************************************************************************
**   Programa..: bc8106.i
**
**   Vers∆o....: 02.00.00 - Datasul
**
**   Objetivo..: Include de temp-tables para Proxy de Acesso a tabela Deposito para 
**               o BC
**
**   Autor.....: Carlos Alberto Soares Pereira - Nov/1999
*********************************************************************************/

/**********************************  bc8106.i  **********************************/
Define temp-table ttParamDeposito NO-UNDO
    Field cod-depos-ini    as Character Label 'Dep¢sito Inicial'
    Field cod-depos-fim    as Character Label 'Dep¢sito Final'
    Field nome-ini         as Character Label 'Nome Inicial'
    Field nome-fim         as Character Label 'Nome Final'
    Field acess-mode          as Integer   Label 'Tipo de Acesso'
            /* 0=current,1=First,2=Prev,3=Next,4=Last,5=each 6=PrevN 7=NextN */
    Field num-of-rec       as Integer   Label 'N£mero Registros'  /* only if acess-mode eq 6 or 7 */
    Field record-phrase    as Integer   Label 'Frase Registro'.   /* only if acess-mode eq 5 */

Define temp-table ttDeposito NO-UNDO
    Field cod-depos         as Character Label 'Dep¢sito'
    Field nome              as Character Label 'Nome'
    Field rowid-value       as rowid
        Index cddp     cod-depos
        Index nm       nome.    

Define Frame fttDeposito
        ttDeposito
        with STREAM-IO.
Define Frame fttParamDeposito
        ttParamDeposito
        with STREAM-IO.
/**********************************  bc8106.i  **********************************/

