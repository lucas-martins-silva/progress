/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*******************************************************************************
**   Programa..: BCProxy.i
**
**   Vers∆o....: 02.00.00 - Datasul
**
**   Objetivo..: Proxy de Acesso a tabela {&Table} para o BC
**
**   Autor.....: Carlos Alberto Soares Pereira - Nov/1999
*********************************************************************************/


/**************************** Parameters Definition Beg *************************/
DEF Input  parameter  table         for ttParam{&Table}.
DEF Output parameter  table         for tt{&Table}.
DEF Output parameter  table         for ttReturnMessages.
/**************************** Parameters Definition End *************************/


/***************************** Variable Definition Beg **************************/
&if '{&mgcld_version}' <= '2.04' &then
    DEF VAR vNumProduto         like Param-BC.int-2     no-undo.
&else
    DEF VAR vNumProduto         like Param-BC.ind-sistema     no-undo.
&endif

DEF VAR vCodError           AS Integer              no-undo.
DEF VAR vDesParam           AS Character            no-undo.
/***************************** Variable Definition End **************************/

/******************************  Proxy Program Beg  *****************************/

For Each ttReturnMessages:
    Delete ttReturnMessages.
End.

Find last Param-BC no-lock no-error.
if  not avail Param-BC then do:
    Assign vCodError = 1
           vDesParam = ''.
    run CreateReturnMessages (Input vCodError,
                              Input vDesParam).
    Return.        
end.

&if '{&mgcld_version}' <= '2.04' &then
    If  Param-BC.int-2 = 0 or
        Param-BC.int-2 = ? then do:
&else
    If  Param-BC.ind-sistema = 0 or
        Param-BC.ind-sistema = ? then do:
&endif
    Assign vCodError = 2
           vDesParam = ''.
    run CreateReturnMessages (Input vCodError,
                              Input vDesParam).
    Assign vNumProduto = 1. /* Assume que o default Ç 1 (EMS2) quando n∆o parametrizado */
End. /* if */   
Else do:
    &if '{&mgcld_version}' <= '2.04' &then
        Assign vNumProduto = Param-BC.int-2.
    &else
        Assign vNumProduto = Param-BC.ind-sistema.
    &endif
End. /* Else */

/* Verifica se foram passados parÉmetros para leitura dos registros */
Find First ttParam{&Table} no-lock no-error.
If  Not AvailAble ttParam{&Table} then do:
    Assign vCodError = 3
           vDesParam = ''.
    run CreateReturnMessages (Input vCodError,
                              Input vDesParam).
    Return.        
End. /* If Not AvailAble ttParam{&Table} */

Case vNumProduto:
    When 1 then Do: 
        Run AcessDatasulEMS2Table. /* Roda Interface em plataforma datasul-EMS2  */
    End. /* When 1 */
    When 2 then Do: 
        Run AcessMagnusTable.      /* Roda Interface em plataforma Magnus-I      */
    End. /* When 2 */
    OtherWise Do:
        Assign vCodError = 4
               vDesParam = 'Produto ' + string(vNumProduto).
        run CreateReturnMessages (Input vCodError,
                                  Input vDesParam).
        Return.        
    End. /* OtherWise */
End Case. /* Case */

/******************************  Proxy Program End  *****************************/


/*********************************************************************************
** PROCEDURE AcessDatasulEMS2Table
**
** Esta procedure roda a BO de acesso a tabela do datasul-EMS 2.00.
*********************************************************************************/
Procedure AcessDatasulEMS2Table:
    run bcp/{&datasul-EMS2BO} (Input  Table ttParam{&Table},
                               Output Table tt{&Table},
                               Output Table ttReturnMessages).
End Procedure. /* AcessDatasulEMS2Table */


/*********************************************************************************
** PROCEDURE AcessMagnusTable
**
** Esta procedure roda a API de acesso a tabela do Magnus I.
*********************************************************************************/
Procedure AcessMagnusTable:
    run bcp/{&Magnus-IBO} (Input  Table ttParam{&Table},
                           Output Table tt{&Table},
                           Output Table ttReturnMessages).
End Procedure. /* AcessMagnusTable */


/*********************************************************************************
** PROCEDURE CreateReturnMessages.
**
** Esta cria as mensagens de retorno da API.
*********************************************************************************/
Procedure CreateReturnMessages:
    DEF INPUT PARAM pCodError   AS Integer          no-undo.
    DEF INPUT PARAM pDesParam   AS Character        no-undo.
    
    DEF VAR vDesError           AS Character        no-undo.
    DEF VAR vNumLocal           AS Integer          no-undo.
    DEF VAR vNumType            AS Integer          no-undo.

    Case pCodError:
        When 1 then do:
            {utp/ut-liter.i ParÉmetros_Coleta_de_Dados_n∆o_encontrados. *}
            Assign vDesError = Return-value
                   vNumLocal = 1
                   vNumType  = 1. 
        End. /* When 1 */
        When 2 then do:
            {utp/ut-liter.i ParÉmetro_Produto_Coleta_de_Dados_n∆o_Informado. *}
            Assign vDesError = Return-value
                   vNumLocal = 1
                   vNumType  = 2. 
        End. /* When 2 */
        When 3 then do:
            {utp/ut-liter.i ParÉmetros_de_Acesso_n∆o_Informados. *}
            Assign vDesError = Return-value
                   vNumLocal = 1
                   vNumType  = 1. 
        End. /* When 3 */
        When 4 then do:
            {utp/ut-liter.i Produto_n∆o_suportado_pelo_Proxy. *}
            Assign vDesError = Return-value
                   vNumLocal = 1
                   vNumType  = 1. 
        End. /* When 4 */
    End. /* Case */
        
    Create ttReturnMessages.
    Assign ttReturnMessages.CodErro    = pCodError
           ttReturnMessages.DesErro    = vDesError
           ttReturnMessages.Local      = vNumLocal
           ttReturnMessages.Type       = vNumType
           ttReturnMessages.Parameters = pDesParam.

End. /* CreateReturnMessages */
/* bc8108.p */

