/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9011 2.00.00.007 } /*** "010007" 18/03/2024 08:35:23 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9011 MBC}
&ENDIF


/********************************************************************************************
**   Programa..: bc9011.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - jun/2001 - Carlos Alberto Soares Pereira                    **
**                                                                                         **
**   Objetivo..: Templates DB Interface para transacao de Requisicao de Materiais Ord Manut**
**                                                                                         **
**   Includes..: bc9109.p, bc9110.p, bc9111.p, bc9102.p, bcapi001.p, bcapi010.p, bc9011.p  **
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
**                        Ex: tt-requis-manut-bc.                                                   **
** FrameSize            - Tamanho da tela da interface. Deve-se observar este parametro quando da **
**                        definicao das telas, o espaco utilizado nao pode ultrapassar o limite   **
**                        estabelecido por este pre-processador.                                  **
** Frame99Name          - Nome da Tela. Sugestao "Frame" mais sequencia.                          **
**                        Ex. Frame01, Frame01, Frame02, etc.                                     **
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
**                            On Leave of ttWork.cod-depos in Frame Frame01                       **
**                            Do:                                                                 **
**                                Case ttWork.cod-depos:                                          **
**                                  When 'Pro' Then Assign ttWork.cod-local = 'Pro01'.            **
**                                  When 'Alm' Then Assign ttWork.cod-local = 'Alm01'.            **
**                                  When 'Exp' Then Assign ttWork.cod-local = 'Exp01'.            **
**                            End.                                                                **
***************************************************************************************************/

/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9011
/************************************************************/

/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-requis-manut-bc
{bcp/bc9011.i " "}

DEFINE TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.
CREATE ttWork.
/************************************************************/

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8
/************************************************************/

/***************************************** Frames Inicio ******************************************/

/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Req. Materiais    '   At Row 01 Col 01          ~
                             'Estab:   '            At Row 02 Col 01          ~
                             ttWork.cod-estabel     At Row 02 Col 07 No-Label ~
                             'Ordem:   '            At Row 03 Col 01          ~
                             ttWork.numero-ordem    At Row 03 Col 07 No-Label ~
                             'Docto:'               At Row 04 Col 01          ~
                             ttWork.nro-docto       At Row 05 Col 01 No-Label ~
                             'Serie:   '            At Row 06 Col 01          ~
                             ttWork.serie-docto     At Row 06 Col 07 No-Label~
                             'Ativi:   '            At Row 07 Col 01          ~
                             ttWork.op-codigo       At Row 07 Col 07 No-Label

&global-define Frame01Repeat No
/************************************************************/

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   ' Item:'              At Row 01 Col 01          ~
                             ttWork.it-codigo      At Row 02 Col 01 No-Label ~
                             'Refer:'              At Row 03 Col 01          ~
                             ttWork.cod-refer      At Row 03 Col 08 No-Label ~
                             'Depos:'              At Row 04 Col 01          ~
                             ttWork.cod-depos      At Row 04 Col 08 No-Label ~
                             'Local:'              At Row 05 Col 01          ~
                             ttWork.localizacao    At Row 05 Col 08 No-Label ~
                             'Lote:'               At Row 06 Col 01          ~
                             ttWork.lote           At Row 06 Col 08 No-Label ~
                             'Dt Vld:'             At Row 07 Col 01          ~
                             ttWork.dt-validade-lote   At Row 07 Col 08 No-Label ~
                             'Quant:'              At Row 08 Col 01          ~
                             ttWork.quantidade     At Row 08 Col 08 No-Label
&global-define Frame02Repeat Yes
/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-estabel  ~
                              ttWork.numero-ordem ~
                              ttWork.nro-docto    ~
                              ttWork.serie-docto  ~
                              ttWork.op-codigo   
                              
&global-define Update02Fields ttWork.it-codigo    ~
                              ttWork.cod-refer    ~
                              ttWork.cod-depos    ~
                              ttWork.localizacao  ~
                              ttWork.lote         ~
                              ttWork.dt-validade-lote ~
                              ttWork.quantidade  

/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. ~
                                    Run GravaTransacao.
/************************************************************/

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers
/************************************************************/

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

PROCEDURE InicializaCamposFrame01:

END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame01 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame02:

END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 02.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:

   ASSIGN vLogErro = NO.
   
   IF ttWork.cod-estabel = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "0" "Codigo do Estabelecimento deve ser informado"}
   END.
   
   IF vLogErro = YES THEN
      RETURN ERROR.

   ASSIGN {&TempTable}.cod-estabel  = ttWork.cod-estabel  
          {&TempTable}.numero-ordem = ttWork.numero-ordem 
          {&TempTable}.nro-docto    = ttWork.nro-docto    
          {&TempTable}.serie-docto  = ttWork.serie-docto  
          {&TempTable}.op-codigo    = ttWork.op-codigo.
          
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame02:

   ASSIGN vLogErro = NO.
    
   IF ttWork.it-codigo = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "0" "Codigo do Item deve ser informado"}
   END.
   
   IF ttWork.cod-depos = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "0" "Codigo do Deposito deve ser informado"}
   END.
   
   IF ttWork.quantidade = 0 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "0" "Quantidade deve ser informada"}
   END.
   
   IF vLogErro = YES THEN
      RETURN ERROR.
    /* Validacoes Frame 03 Fim    --- */

    Assign  {&temptable}.it-codigo    = ttWork.it-codigo    
            {&TempTable}.cod-refer    = ttWork.cod-refer    
            {&TempTable}.cod-depos    = ttWork.cod-depos    
            {&TempTable}.localizacao  = ttWork.localizacao  
            {&TempTable}.lote         = ttWork.lote         
            {&TempTable}.dt-validade-lote = ttWork.dt-validade-lote 
            {&TempTable}.quantidade   = ttWork.quantidade 
            . 
END PROCEDURE.
/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
PROCEDURE GravaTransacao:
    Def Var vNomeUsuario            As Character                No-undo.

    Assign vTransDetail = vTransaction  + 
                          " Doc: "      + TRIM({&TempTable}.nro-docto)      +
                          " Item: "     + Trim({&temptable}.it-codigo)      +
                          " Ref: "      + Trim({&TempTable}.cod-refer)      +
                          " Depos: "    + Trim({&TempTable}.cod-depos)      +
                          " Local: "    + Trim({&TempTable}.localizacao)    +
                          " Lote: "     + Trim({&TempTable}.lote)           +
                          " Qt: "       + String({&TempTable}.quantidade).

    Run _RetornaUsuario (Output vNomeUsuario).

    If  vNomeUsuario = '' Then Do:
        vNomeUsuario = 'super'.
    End.

    Assign {&TempTable}.dt-trans        = Today.

    Raw-transfer {&TempTable} To vConteudoRaw.

    Run _GenerateDCTransaction (Input vTransaction,            /* Codigo da Transacao                   */
                                Input vConteudoRaw,            /* Conteudo da temp-table {&TempTable}   */
                                Input vTransDetail,            /* Cabecalho de detalhes da transacao    */
                                Input vNomeUsuario).           /* Usuario responsavel pela transacao    */
END PROCEDURE.

FINALLY:    
   IF NOT lMenu AND THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
  
   RETURN 'OK':U.
END FINALLY.
/*************************************  Codigo do Usuario Fim   **********************************/
