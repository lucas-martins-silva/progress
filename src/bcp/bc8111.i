/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*******************************************************************************
**   Programa..: bc8111.i
**
**   Vers∆o....: 02.00.00 - Datasul
**
**   Objetivo..: Include de temp-tables para Proxy de Acesso a tabela Saldo-Estoq para 
**               o BC
**
**   Autor.....: Carlos Alberto Soares Pereira - Nov/1999
*********************************************************************************/

/**********************************  bc8111.i  **********************************/
Define temp-table ttParamSaldo-Estoq NO-UNDO
    Field it-codigo-ini    as Character Label 'Item Inicial'
    Field it-codigo-fim    as Character Label 'Item Final'
    Field cod-estabel-ini  as Character Label 'Estabelecimento Inicial'
    Field cod-estabel-fim  as Character Label 'Estabelecimento Final'
    Field cod-refer-ini    as Character Label 'Referància Inicial' 
    Field cod-refer-fim    as Character Label 'Referància Final' 
    Field cod-depos-ini    as Character Label 'Dep¢sito Inicial' 
    Field cod-depos-fim    as Character Label 'Dep¢sito Final' 
    Field cod-localiz-ini  as Character Label 'Localizaá∆o Inicial' FORMAT "x(20)"
    Field cod-localiz-fim  as Character Label 'Localizaá∆o Final'   FORMAT "x(20)"
    Field lote-ini         as Character Label 'Saldo-Estoq Inicial'
    Field lote-fim         as Character Label 'Saldo-Estoq Final'
    Field dt-vali-lote-ini as Date      Label 'Data Validade Inicial'
    Field dt-vali-lote-fim as Date      Label 'Data Validade Final'
    Field qtidade-atu-ini  as Decimal   Label 'Qtde Autal Inicial' 
    Field qtidade-atu-fim  as Decimal   Label 'Qtde Autal Final'
    Field acess-mode       as Integer   Label 'Tipo de Acesso'
            /* 0=current,1=First,2=Prev,3=Next,4=Last,5=each 6=PrevN 7=NextN */
    Field num-of-rec       as Integer   Label 'N£mero Registros'  /* only if acess-mode eq 6 or 7 */
    Field record-phrase    as Integer   Label 'Frase Registro'.   /* only if acess-mode eq 5 */

Define temp-table ttSaldo-Estoq NO-UNDO
    Field it-codigo       as Character Label 'Item'
    Field cod-estabel     as Character Label 'Estabelecimento'
    Field cod-refer       as Character Label 'Referància' 
    Field cod-depos       as Character Label 'Dep¢sito' 
    Field cod-localiz     as Character Label 'Localizaá∆o' FORMAT "x(20)"
    Field Lote            as Character Label 'Saldo-Estoq'
    Field dt-vali-lote    as Date      Label 'Data Valid Saldo-Estoq'
    Field qtidade-atu     as Decimal   Label 'Qtde Autal'
    Field rowid-value     as rowid
        Index tcdg     it-codigo
        Index cdstbl   cod-estabel
        Index cdrfr    cod-refer
        Index cddps    cod-depos
        Index cdlclz   cod-localiz
        Index lt       lote
        Index dtvldt   dt-vali-lote.
        
Define Frame fttSaldo-Estoq
        ttSaldo-Estoq
        with STREAM-IO.
Define Frame fttParamSaldo-Estoq
        ttParamSaldo-Estoq
        with STREAM-IO.
/**********************************  bc8111.i  **********************************/
