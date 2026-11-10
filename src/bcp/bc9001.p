/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9001 2.00.00.013 } /*** "010013" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9001 MBC}
&ENDIF
/********************************************************************************************
**   Programa..: bc9001.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - mai/2000 - Carlos Alberto Soares Pereira                    **
**               2.00.00.001 - jun/2000 - John Cleber Jaraceski                            **
**                                                                                         **
**   Objetivo..: Template DB Interface para transacao de Transferencia de Materiais        **
**                                                                                         **
**   Includes..: bc9105.i, bc9101.i, bc9100.i, bc9001.i                                    **
**                                                                                         **
********************************************************************************************/

/***************************************************************************************************
** SECAO DE PRE-PROCESSADORES DA TEMPLATE                                                         **
** Nesta secao sao definidos os pre-processadores que serao usados na montagem da interface.      **
**                                                                                                **
** DESCRICAO DOS PREPROCESSADORES:                                                                **
** ProgramName          - Nome do programa e, tambem, do Codigo da transacao do Data Collection   **
**                        que sera acionada pela interface.                                       **
** TempTable            - Nome da Temp-Table da transacao de negocio para comunicacao com ERP.    **
**                        Ex: tt-transfere-bc.                                                    **
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
**                        OBS. Nao deve conter formatacao. Ex. ttWork.cod-item no-label.         **
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
Define New Global Shared Var lMenu          As Logical                               No-undo.
Define New Shared Variable   wgboin172      As Widget-handle                		 No-undo.       


/* Definicao global do nome da transacao ---                */
&global-define ProgramName bc9001
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
&global-define Frame01Defs   'Transf Materiais 1/2'   At Row 01 Col 01          ~
                             '  Estab:'               At Row 02 Col 01          ~
                             ttWork.cod-estabel       At Row 02 Col 09 No-Label ~
                             '  Docto:'               At Row 03 Col 01          ~
                             ttWork.num-documento     At Row 03 Col 09 No-Label ~
                             'Ref Des:'               At Row 04 Col 01          ~
                             ttWork.cod-refer-destino At Row 04 Col 09 No-label ~
                             'Dep Des:'               At Row 05 Col 01          ~
                             ttWork.cod-depos-destino At Row 05 Col 09 No-Label ~
                             'Loc Des:'               At Row 06 Col 01          ~
                             ttWork.cod-local-destino At Row 06 Col 09 No-Label VIEW-AS FILL-IN SIZE 12 BY 0.88 ~
                             'Lot Des:'               At Row 07 Col 01          ~
                             ttWork.cod-lote-destino  At Row 07 Col 09 No-label VIEW-AS FILL-IN SIZE 12 BY 0.88
&global-define Frame01Repeat  No
/************************************************************/

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Transf Meteriais 2/2'  At Row 01 Col 01          ~
                             'Codigo do Item:'       At Row 02 Col 01          ~
                             ttWork.cod-item         At Row 03 Col 01 No-label ~
                             'Ref Ori:'              At Row 04 Col 01          ~
                             ttWork.cod-refer-origem At Row 04 Col 09 No-label ~
                             'Dep Ori:'              At Row 05 Col 01          ~
                             ttWork.cod-depos-origem At Row 05 Col 09 No-label ~
                             'Loc Ori:'              At Row 06 Col 01          ~
                             ttWork.cod-local-origem At Row 06 Col 09 No-label VIEW-AS FILL-IN SIZE 12 BY 0.88 ~
                             'Lot Ori:'              At Row 07 Col 01          ~
                             ttWork.cod-lote-origem  At Row 07 Col 09 No-Label VIEW-AS FILL-IN SIZE 12 BY 0.88 ~
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
/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject7 wgboin172
/************************************************************/

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
			
   IF NOT VALID-HANDLE(wgboin172) THEN
	   Run inbo/boin172.r persistent set wgboin172 No-error.
	   			
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
         {bcp/bc9105.i "0" "Codigo do Estabelecimento deve ser informado"}
    End.
    If   ttWork.num-documento = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "0" "Numero do Documento deve ser informado"}
    End.
    If   ttWork.cod-depos-destino = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "0" "Codigo do deposito de destino deve ser informado"}
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
         {bcp/bc9105.i "0" "Codigo do Item deve ser informado"}
    End.
    If   ttWork.cod-depos-origem = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "0" "Codigo do deposito deve ser informado"}
    End.
    If   ttWork.qtd-movimento = 0 Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "0" "Quantidade deve ser informada"}
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
	Def Var iTipoConEst			    As integer 					No-Undo.
	 
	
	Assign iTipoConEst = 0.
		
	Run openQueryStatic in wgboin172 (input "Main":U) .
	 
	Run goToKey in wgboin172 (input {&TempTable}.cod-item ).
	If return-value = "OK":U then do:
	   Run getIntField in wgboin172 (INPUT "tipo-con-est":U,
								     OUTPUT iTipoConEst).
	End.
		
	IF iTipoConEst = 1 Then
	   Assign {&TempTable}.cod-lote-destino = ""
	          {&TempTable}.cod-refer-destino = "".
	Else IF iTipoConEst = 2 or iTipoConEst = 3 Then
	   Assign {&TempTable}.cod-refer-destino = "".

    Assign vTransDetail = vTransaction + 
                          " Doc: "     + String({&TempTable}.num-documento)   +
                          " Item: "    + Trim({&TempTable}.cod-item)          +
                          " Ref: "     + Trim({&TempTable}.cod-refer-destino) +
                          " Depos: "   + Trim({&TempTable}.cod-depos-destino) +
                          " Local: "   + Trim({&TempTable}.cod-local-destino) +
                          " Lote: "    + Trim({&TempTable}.cod-lote-destino)  +
                          " Qt: "      + String({&TempTable}.qtd-movimento).

    Run _RetornaUsuario (Output vNomeUsuario).

    Assign {&TempTable}.data-transacao = Today
           {&TempTable}.cod-usuario   = vNomeUsuario.

    Raw-transfer {&TempTable} To vConteudoRaw.

    Run _GenerateDCTransaction (Input vTransaction,            /* Codigo da Transacao                   */
                                Input vConteudoRaw,            /* Conteudo da temp-table {&TempTable}   */
                                Input vTransDetail,            /* Cabecalho de detalhes da transacao    */
                                Input vNomeUsuario).           /* Usuario responsavel pela transacao    */    												
								
End Procedure.
/*************************************  Codigo do Usuario Fim   **********************************/

FINALLY:    
   IF NOT lMenu AND THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
  
   RETURN 'OK':U.
END FINALLY.
