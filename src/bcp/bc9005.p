/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9005 2.00.00.004 } /*** "010004" 15/03/2024 11:29:11  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BC9020 MBC}
&ENDIF

{include/i_dbinst.i}  /* vers’o das bases e bases instaladas */

/********************************************************************************************
**   Programa..: bc9005.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - Nova transa‡Æo de Transferˆncia                             **
**                                                                                         **
**   Objetivo..: Transferencia de Materiais - V2                                           **
**                                                                                         **
**   Cria‡Æo : Amarildo Gambeta - Dezembro 2006                                            **
********************************************************************************************/
Define New Global Shared Var lMenu          As Logical                               No-undo.

/* Definicao global do nome da transacao ---                */
&global-define ProgramName bc9005
/************************************************************/

/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-transfere-bc
{bcp/bc9001.i " "}              
Define Temp-table ttWork No-Undo Like {&TempTable}.
Create ttWork.
/************************************************************/

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Transf Mat. - V2'       At Row 01 Col 01          ~
                             '  Estab:'               At Row 02 Col 01          ~
                             ttWork.cod-estabel       At Row 02 Col 09 No-Label ~
                             '  Docto:'               At Row 03 Col 01          ~
                             ttWork.num-documento     At Row 03 Col 09 No-Label ~
                             'Ref Des:'               At Row 04 Col 01          ~
                             ttWork.cod-refer-destino At Row 04 Col 09 No-label ~
                             'Dep Des:'               At Row 05 Col 01          ~
                             ttWork.cod-depos-destino At Row 05 Col 09 No-Label ~
                             'Loc Des:'               At Row 06 Col 01          ~
                             ttWork.cod-local-destino At Row 06 Col 09 No-Label VIEW-AS FILL-IN SIZE 11 BY 0.88 ~
                             'Lot Des:'               At Row 07 Col 01          ~
                             ttWork.cod-lote-destino  At Row 07 Col 09 No-label FORMAT "x(40)"  VIEW-AS FILL-IN SIZE 11 BY 0.88
&global-define Frame01Repeat  No
/************************************************************/

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Transf Mat. - V2'      At Row 01 Col 01          ~
                             'Codigo do Item:'       At Row 02 Col 01          ~
                             ttWork.cod-item         At Row 03 Col 01 No-label ~
                             'Ref Ori:'              At Row 04 Col 01          ~
                             ttWork.cod-refer-origem At Row 04 Col 09 No-label ~
                             'Dep Ori:'              At Row 05 Col 01          ~
                             ttWork.cod-depos-origem At Row 05 Col 09 No-label ~
                             'Loc Ori:'              At Row 06 Col 01          ~
                             ttWork.cod-local-origem At Row 06 Col 09 No-label VIEW-AS FILL-IN SIZE 11 BY 0.88 ~
                             'Lot Ori:'              At Row 07 Col 01          ~
                             ttWork.cod-lote-origem  At Row 07 Col 09 No-Label FORMAT "x(40)"  VIEW-AS FILL-IN SIZE 11 BY 0.88 ~
                             'Quant:'                At Row 08 Col 01          ~
                             ttWork.qtd-movimento    At Row 08 Col 07 No-label 
&global-define Frame02Repeat Yes
/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-estabel ~
                              ttWork.num-documento ~
                              ttWork.cod-refer-destino ~
                              ttWork.cod-depos-destino ~
                              ttWork.cod-local-destino ~
                              ttWork.cod-lote-destino

&global-define Update02Fields ttWork.cod-item ~
                              ttWork.cod-refer-origem ~
                              ttWork.cod-depos-origem ~
                              ttWork.cod-local-origem ~
                              ttWork.cod-lote-origem ~
                              ttWork.qtd-movimento
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. ~
                                    Run GravaTransacao.
/************************************************************/

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers On Leave of ttWork.cod-item in Frame Frame02 ~
                            Do: ~
                                Define Variable vCodUnico       As Integer Format '9999999999999999' No-undo. ~
                                Define Variable vCodUnicoChar   As Character                         No-undo. ~
                                ~
                                Assign vCodUnico = Int(ttWork.cod-item:Screen-value in Frame Frame02) No-error. ~
                                ~
                                Assign vCodUnicoChar = String(vCodUnico,'9999999999999999'). ~
                                ~
                                Find first bc-ext-saldo-estoq no-lock ~
                                where bc-ext-saldo-estoq.cod-unico   = vCodUnicoChar No-error. ~
                                If   avail bc-ext-saldo-estoq Then Do: ~
                                     Assign ttWork.cod-item        :Screen-value in Frame Frame02 = bc-ext-saldo-estoq.it-codigo ~
                                            ttWork.cod-depos-origem:Screen-value in Frame Frame02 = bc-ext-saldo-estoq.cod-depos ~
                                            ttWork.cod-local-origem:Screen-value in Frame Frame02 = bc-ext-saldo-estoq.cod-localiz ~
                                            ttWork.cod-lote-origem :Screen-value in Frame Frame02 = bc-ext-saldo-estoq.lote. ~
                                End. ~
                             End ~
                             .

/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 10
/*****************************************   Frames Fim ******************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Gerador de transa‡Æo do coleta de dados          */

/**************************************************************************************************/

/************************************* Codigo do Usuario Inicio ************************************
** Este local ‚ destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/

/*************************************************************************************************** 
** Esta procedure esta inicializando o campo estabelecimento da tela Frame01 com o valor 1        **
** Os outros campos nao estao sendo inicializados pois os mesmos devem apresentar valor           **
** caso seja retornado a proxima tela para esta.                                                  **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame01:
    Assign 
            ttWork.num-documento     = ''
            ttWork.cod-estabel       = '1'
            ttWork.cod-refer-destino = ''
            ttWork.cod-depos-destino = ''
            ttWork.cod-local-destino = ''
            ttWork.cod-lote-destino  = ''
            .
End Procedure.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame02 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame02:
    Assign 
            ttWork.cod-item         = ''
            ttWork.cod-refer-origem = ''
            ttWork.cod-depos-origem = ''
            ttWork.cod-local-origem = ''
            ttWork.cod-lote-origem  = ''
            ttWork.qtd-movimento    = 0
            .
End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame01:
    /* Validacoes Frame 01 Inicio --- */
    Assign vLogErro = No.
    If   ttWork.cod-estabel = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "0" "Codigo do estabelecimento deve ser informado!"}
    End.
    If   ttWork.num-documento = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "0" "Numero do documento deve ser informado!"}
    End.
    If   ttWork.cod-depos-destino = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "0" "Codigo do deposito de destino deve ser informado!"}
    End.

    If   vLogErro = Yes Then Return Error.
    /* Validacoes Frame 01 Fim    --- */

    Assign  {&TempTable}.cod-estabel       = input Frame Frame01 ttWork.cod-estabel
            {&TempTable}.num-documento     = input Frame Frame01 ttWork.num-documento  
            {&TempTable}.cod-refer-destino = input Frame Frame01 ttWork.cod-refer-destino
            {&TempTable}.cod-depos-destino = input Frame Frame01 ttWork.cod-depos-destino 
            {&TempTable}.cod-local-destino = input Frame Frame01 ttWork.cod-local-destino
            {&TempTable}.cod-lote-destino  = input Frame Frame01 ttWork.cod-lote-destino
            . 
End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 02.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame02:
    /* Validacoes Frame 02 Inicio --- */
    Assign vLogErro = No.
    If   ttWork.cod-item = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "0" "Codigo do item deve ser informado!"}
    End.
    If   ttWork.cod-depos-origem = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "0" "Codigo do deposito deve ser informado!"}
    End.
    If   ttWork.qtd-movimento = 0 Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "0" "Quantidade deve ser informada!"}
    End.

    If   vLogErro = Yes Then Return Error.
    /* Validacoes Frame 02 Fim    --- */

    Assign  {&TempTable}.cod-item         = input Frame Frame02 ttWork.cod-item
            {&TempTable}.cod-refer-origem = input Frame Frame02 ttWork.cod-refer-origem 
            {&TempTable}.cod-depos-origem = input Frame Frame02 ttWork.cod-depos-origem 
            {&TempTable}.cod-local-origem = input Frame Frame02 ttWork.cod-local-origem 
            {&TempTable}.cod-lote-origem  = input Frame Frame02 ttWork.cod-lote-origem
            {&TempTable}.qtd-movimento    = input Frame Frame02 ttWork.qtd-movimento
            . 
End Procedure.

/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
Procedure GravaTransacao:
    Def Var vNomeUsuario            As Character                No-undo.

    Assign vTransDetail = vTransaction + 
                          " Doc: "     + String({&TempTable}.num-documento)   +
                          " Item: "    + Trim({&TempTable}.cod-item)          +
                          " Ref: "     + Trim({&TempTable}.cod-refer-destino) +
                          " Depos: "   + Trim({&TempTable}.cod-depos-destino) +
                          " Local: "   + Trim({&TempTable}.cod-local-destino) +
                          " Lote: "    + Trim({&TempTable}.cod-lote-destino)  +
                          " Qt: "      + String({&TempTable}.qtd-movimento).

    Run _RetornaUsuario (Output vNomeUsuario).

    Assign {&TempTable}.data-transacao      = Today
           {&TempTable}.cod-serie-documento = "DC"
           {&TempTable}.cod-usuario         = vNomeUsuario.

    Raw-transfer {&TempTable} To vConteudoRaw.

    Run _GenerateDCTransaction (Input vTransaction,            /* Codigo da Transacao                   */
                                Input vConteudoRaw,            /* Conteudo da temp-table {&TempTable}   */
                                Input vTransDetail,            /* Cabecalho de detalhes da transacao    */
                                Input vNomeUsuario).           /* Usuario responsavel pela transacao    */
End Procedure.

FINALLY:
   IF NOT lMenu AND THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
  
   RETURN 'OK':U.
END FINALLY.

/*************************************  Codigo do Usuario Fim   **********************************/
