/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9006 2.00.00.016 } /*** "010016" 15/03/2024 14:19:29  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC9006 MBC}
&ENDIF
/********************************************************************************************
**   Programa..: bc9006.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - mai/2000 - Carlos Alberto Soares Pereira                    **
**               2.00.00.001 - jun/2000 - John Cleber Jaraceski                            **
**                                                                                         **
**   Objetivo..: Template DB Interface para transacao de Reporte Repetitivo                **
**                                                                                         **
**   Includes..: bc9105.i, bc9101.i, bc9100.i, bc9006.i                                    **
**                                                                                         **
********************************************************************************************/
Define New Global Shared Var lMenu          As Logical                               No-undo.
/***************************************************************************************************
** SECAO DE PRE-PROCESSADORES DA TEMPLATE                                                         **
** Nesta secao sao definidos os pre-processadores que serao usados na montagem da interface.      **
**                                                                                                **
** DESCRICAO DOS PREPROCESSADORES:                                                                **
** ProgramName          - Nome do programa e, tambem, do Codigo da transacao do Data Collection   **
**                        que sera acionada pela interface.                                       **
** TempTable            - Nome da Temp-Table da transacao de negocio para comunicacao com ERP.    **
**                        Ex: tt-reporte-repet-bc.                                                **
** FrameSize            - Tamanho da tela da interface. Deve-se observar este parametro quando da **
**                        definicao das telas, o espaco utilizado nao pode ultrapassar o limite   **
**                        estabelecido por este pre-processador.                                  **
** Frame99Name          - Nome da Tela. Sugestao "Frame" mais sequencia.                          **
**                        Ex. Frame01, Frame02, Frame03, etc.                                     **
** Frame99Defs          - Definicoes da tela onde a mesma deve conter:                            **
**                        .Titulo da Tela quando necessario.                                      **
**                        .Campos com a opcao no-label e sua localizacao Ex. At Row x Col y.      **
**                        .Literais que substituem os labels dos campos e sua localizacao.        **
**                        .Instrucoes de Navegacao quando houver espaco livre para o mesmo.       **
**                        Ex. "F4=Sair","ESC=Voltar","F2=Gravar" etc.                             **
** Frame99Repeat        - Indica se a tela tem caracteristica de repeticao. O Valor YES indica    **
**                        que ha repeticao e o valor NO indica que nao ha repeticao.              **
** Update99Fields       - Relaciona os campos que serao solicitados na tela.                      **
**                        OBS. Nao deve conter formatacao. Ex. ttWork.it-codigo no-label.         **
** TriggerBeforeFrame99 - Gatilho para ser executado antes da execucao da tela. Neste gatilho     **
**                        devem ser colocadas chamadas as procedures de inicializacao dos campos  **
**                        da tela.                                                                **
** TriggerAfterFrame99  - Gatilho para ser executado apos a execucao da tela. Neste gatilho       **
**                        dever ser colocada a chamada a procedures que devera armazenar  na      **
**                        temp-table {&TempTable} os campos da ttWork, que sao os campos          **
**                        solicitados em tela. Neste gatilho tambem, quando o mesmo se referir a  **
**                        ultima tela de entrada de dados, devera existir uma chamada a procedure **
**                        que executa a procedure _GenerateDCTransaction que eï responsavel por   **
**                        gerar a transacao no Coleta de Dados.                                   **
** UserTriggers         - Este pro-processador destina-se as triggers customizadas do usuario.    **
**                        Ex: Alimentar um campo da dela conforme o informado em outro campo.     **
**                            On Leave of ttWork.cod-depos in Frame Frame02                       **
**                            Do:                                                                 **
**                                Case ttWork.cod-depos:                                          **
**                                  When 'Pro' Then Assign ttWork.cod-local = 'Pro01'.            **
**                                  When 'Alm' Then Assign ttWork.cod-local = 'Alm01'.            **
**                                  When 'Exp' Then Assign ttWork.cod-local = 'Exp01'.            **
**                            End.                                                                **
***************************************************************************************************/

/* Definicao global do nome da transacao ---                */
&global-define ProgramName bc9006
/************************************************************/

/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-reporte-repet-bc
{bcp/bc9006.i " "}
Define Temp-table ttWork No-Undo Like {&TempTable}.
Create ttWork.
/************************************************************/

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Rep. Repetitivo 1/2'          At Row 01 Col 01          ~
                             '  Docto:'                     At Row 02 Col 01          ~
                             ttWork.nro-docto               At Row 03 Col 01 No-Label ~
                             'N.Repor:'                     At Row 04 Col 01          ~
                             ttWork.nr-reporte              At Row 04 Col 09 No-Label ~
                             '  Estab:'                     At Row 05 Col 01          ~
                             ttWork.cod-estabel             At Row 05 Col 09 No-Label ~
                             'Dep.Aca:'                     At Row 06 Col 01          ~
                             ttWork.cod-depos               At Row 06 Col 09 No-Label ~
                             'Loc.Aca:'                     At Row 07 Col 01          ~
                             ttWork.cod-localiz             At Row 07 Col 09 NO-LABEL VIEW-AS FILL-IN SIZE 11 BY 0.88
&global-define Frame01Repeat  No
/************************************************************/

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Codigo do Item:'            At Row 01 Col 01          ~
                             ttWork.it-codigo             At Row 02 Col 01 No-Label ~
                             'Ref Sai:'                   At Row 03 Col 01          ~
                             ttWork.cod-refer             At Row 03 Col 09 No-Label ~
                             'Dep Sai:'                   At Row 04 Col 01          ~
                             ttWork.cod-depos-sai         At Row 04 Col 09 No-Label ~
                             'Loc Sai:'                   At Row 05 Col 01          ~
                             ttWork.cod-local-sai         At Row 05 Col 09 No-Label VIEW-AS FILL-IN SIZE 11 BY 0.88 ~
                             'Lot Sai:'                   At Row 06 Col 01          ~
                             ttWork.lote                  At Row 06 Col 09 No-Label VIEW-AS FILL-IN SIZE 11 BY 0.88 ~
                             'Dt Vali:'                   At Row 07 Col 01          ~
                             ttWork.dt-vali-lote          At Row 07 Col 09 No-Label ~
                             'Quant:'                     At Row 08 Col 01          ~
                             ttWork.qt-reporte            At Row 08 Col 07 No-Label
&global-define Frame02Repeat Yes
/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.nro-docto ~
                              ttWork.nr-reporte ~
                              ttWork.cod-estabel ~
                              ttWork.cod-depos ~
                              ttWork.cod-localiz

&global-define Update02Fields ttWork.it-codigo ~
                              ttWork.cod-refer ~
                              ttWork.cod-depos-sai ~
                              ttWork.cod-local-sai ~
                              ttWork.lote-serie ~
                              ttWork.dt-vali-lote ~
                              ttWork.qt-reporte
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. ~
                                    Run GravaTransacao.
/************************************************************/

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers On Leave of ttWork.it-codigo in Frame Frame02 ~
                            Do: ~
                                Define Variable vCodUnico       As Integer Format '9999999999999999' No-undo. ~
                                Define Variable vCodUnicoChar   As Character                         No-undo. ~
                                ~
                                Assign vCodUnico = Int(ttWork.it-codigo:Screen-value in Frame Frame02) No-error. ~
                                ~
                                Assign vCodUnicoChar = String(vCodUnico,'9999999999999999'). ~
                                ~
                                Find first bc-ext-saldo-estoq no-lock ~
                                where bc-ext-saldo-estoq.cod-unico   = vCodUnicoChar No-error. ~
                                If   avail bc-ext-saldo-estoq Then Do: ~
                                     Assign ttWork.it-codigo       :Screen-value in Frame Frame02 = bc-ext-saldo-estoq.it-codigo ~
                                            ttWork.cod-depos-sai   :Screen-value in Frame Frame02 = bc-ext-saldo-estoq.cod-depos ~
                                            ttWork.cod-local-sai   :Screen-value in Frame Frame02 = bc-ext-saldo-estoq.cod-localiz ~
                                            ttWork.lote-serie      :Screen-value in Frame Frame02 = bc-ext-saldo-estoq.lote. ~
                                End. ~
                             End.

/*****************************************   Frames Fim ******************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */

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
    Assign  ttWork.nro-docto    = ''
            ttWork.nr-reporte   = 0
            ttWork.cod-estabel  = '1'
            ttWork.cod-depos    = ''
            ttWork.cod-localiz  = ''
            .
End Procedure.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame02 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame02:
    Assign  ttWork.it-codigo        = ''
            ttWork.cod-refer        = ''
            ttWork.cod-depos-sai    = ''
            ttWork.cod-local-sai    = ''
            ttWork.lote-serie       = ''
            ttWork.dt-vali-lote     = Today
            ttWork.qt-reporte       = 0
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
    If   ttWork.nro-docto = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "0" "Numero do Documento deve ser informado"}
    End.
    If   ttWork.cod-estabel = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "0" "Codigo do Estabelecimento deve ser informado"}
    End.
    If   ttWork.cod-depos = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "0" "Codigo do Deposito Acabado deve ser informado"}
    End.
    If   vLogErro = Yes Then Return Error.
    /* Validacoes Frame 01 Fim    --- */

    Assign  {&TempTable}.nro-docto      = input Frame Frame01 ttWork.nro-docto
            {&TempTable}.nr-reporte     = input Frame Frame01 ttWork.nr-reporte
            {&TempTable}.cod-estabel    = input Frame Frame01 ttWork.cod-estabel
            {&TempTable}.cod-depos      = input Frame Frame01 ttWork.cod-depos
            {&TempTable}.cod-localiz    = input Frame Frame01 ttWork.cod-localiz
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
    If   ttWork.it-codigo = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "0" "Codigo do Item deve ser informado"}
    End.
    If   ttWork.cod-depos-sai = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "0" "Codigo do Deposito deve ser informado"}
    End.
    If   ttWork.qt-reporte = 0 Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "0" "Quantidade Reportada deve ser informada"}
    End.
    If   vLogErro = Yes Then Return Error.
    /* Validacoes Frame 02 Fim    --- */

    Assign  {&temptable}.it-codigo          = input Frame Frame02 ttWork.it-codigo
            {&TempTable}.cod-refer          = input Frame Frame02 ttWork.cod-refer
            {&TempTable}.cod-depos-sai      = input Frame Frame02 ttWork.cod-depos-sai
            {&TempTable}.cod-local-sai      = input Frame Frame02 ttWork.cod-local-sai
            {&TempTable}.lote-serie         = input Frame Frame02 ttWork.lote-serie
            {&TempTable}.dt-vali-lote       = input Frame Frame02 ttWork.dt-vali-lote
            {&TempTable}.qt-reporte         = input Frame Frame02 ttWork.qt-reporte
            . 
End Procedure.

/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
Procedure GravaTransacao:
    Def Var vNomeUsuario            As Character                No-undo.

    Assign vTransDetail = vTransaction  + 
                          " Doc: "      + String({&TempTable}.nro-docto)        +
                          " Item: "     +   Trim({&temptable}.it-codigo)        +
                          " Ref: "      +   Trim({&TempTable}.cod-refer)        +
                          " Depos: "    +   Trim({&TempTable}.cod-depos-sai)    +
                          " Local: "    +   Trim({&TempTable}.cod-local-sai)    +
                          " Lote: "     +   Trim({&TempTable}.lote-serie)       +
                          " Qt: "       + String({&TempTable}.qt-reporte).

    Run _RetornaUsuario (Output vNomeUsuario).

    Assign {&TempTable}.data-transacao  = Today
           {&TempTable}.data            = Today
           {&TempTable}.cod-usuario     = vNomeUsuario.

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
