/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI013 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bcapi013 MBC}
&ENDIF


/***********************************************************************************
** Produto....: CLD 2.00 - Coleda de Dados                                        **
**                                                                                **
** Include....: bcapi013.p                                                        **
**                                                                                **
** Finalidade.: Efetivar a transacao de embraque com a tabela bc-integracao       **
**                                                                                **
** Parametros.: Nenhum                                                            **
**                                                                                **
** Autor......: Carlos Alberto Soares Pereira                                     **
**                                                                                **
** Versao.....: 2.0.00.000 - 15/06/2000 - Carlos                                  **
************************************************************************************/
{bcp/bc9102.i}     /* Definicao da temp-table de erros do coleta de dados          */
/***********************************************************************************/
{bcp/bcapi013.i}
{include/i_dbvers.i}

    Define Temp-Table tt-bc-integracao NO-UNDO Like bc-integracao.

    Define Input        Parameter table for tt-integracao-13.
    Define Input-output Parameter table for tt-bc-integracao.
    Define Input-Output Parameter Table For tt-erro.

    find first tt-integracao-13 
         no-error.

    if  not avail tt-integracao-13  then do:
        run utp/ut-msgs.p (input "msg",
                           input 3950,
                           input " " ).
    
        create tt-erro.
        assign 
               tt-erro.cd-erro = 3950
               tt-erro.mensagem = string(return-value).
        return "NOK".
    end.
    else /**** teste de versao de api *****/
        if  tt-integracao-13.cod-versao-integracao <> 1 then do:
            run utp/ut-msgs.p (input "msg",
                               input 3941,
                               input "").
            create tt-erro.
            assign tt-erro.cd-erro   = 3941
                   tt-erro.mensagem  =   return-value 
                                       + string(tt-integracao-13.cod-versao-integracao) 
                                       + " / " 
                                       + "1".
            return "NOK".
        end.
    
    if  tt-integracao-13.cd-trans = "" then do:
        {utp/ut-table.i mgmp mp-transacao 1}
        run utp/ut-msgs.p (input "msg",
                           input 56,
                           input return-value).
                           
        create tt-erro.
        assign tt-erro.cd-erro   = 56
               tt-erro.mensagem  = return-value.
                
        {utp/ut-liter.i "Programa" * L} 
        
        assign tt-erro.mensagem = tt-erro.mensagem + "(" + return-value + ": bcapi013)".
    end.
             
    for each tt-bc-integracao:
    
        if  tt-integracao-13.opcao-inteiro-1 = 1
        then do:
            create bc-integracao.
            buffer-copy tt-bc-integracao except sequencia to bc-integracao.
            assign bc-integracao.cd-trans = tt-integracao-13.cd-trans.
        end.
    
    end.   
