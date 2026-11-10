/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9033H 2.00.00.019 } /*** "010019" 09/10/2025 11:26:33 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9033h MBC}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/* versÆo das bases e bases instaladas */ {include/i_dbinst.i}  
/*******************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/********************************************************************************************
**   Programa..: bc9033h.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - Junho / 2006 - Bravo - Cria‡Æo do programa                  **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Picking / Packing WMS            **
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
**                        Ex: tt-picking-wms.                                                     **
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
** AtiveObject1         - Este pro-processador permite que se destruam os objetos persistentes    **
**                        no final da sessao progress.                                            **
**                        Ex: &global-define ActiveObject wgbosc074                               **
***************************************************************************************************/
/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9033
/************************************************************/
/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-picking-wms

{bcp/bc9033.i " "}
{bcp/bc9033.i1 }
{bcp/bc9018h.i}

/*opcao do tipo de leitura. Esse valor vem da bc9033h.p*/
DEFINE NEW GLOBAL SHARED VARIABLE iIndTipoLeitura  AS INTEGER NO-UNDO. 

/* Tipo de Visualiza‡Æo da quantidade */
DEFINE NEW GLOBAL SHARED VARIABLE iIndTipoVisualiza AS INTEGER NO-UNDO.

/*mk Variaveis utilizadas pela BOSC145 para conversÆo de qtd x emb~\un*/
DEFINE VARIABLE p-qtd-caixas   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE p-qtd-unidades AS DECIMAL     NO-UNDO.

DEFINE SHARED VARIABLE i-etiqueta-packing  AS DECIMAL       FORMAT '>>>>>>>>>>>>>>>' NO-UNDO. 

DEF VAR i-etiqueta-packing-aux  AS DECIMAL FORMAT '>>>>>>>>>>>>>>>' NO-UNDO.

DEFINE VARIABLE wgbosc030         AS HANDLE                     NO-UNDO.
DEFINE VARIABLE wgbosc032         AS HANDLE                     NO-UNDO.
DEFINE VARIABLE wgbosc038         AS HANDLE                     NO-UNDO.
DEFINE VARIABLE wgbosc044         AS HANDLE                     NO-UNDO.
DEFINE VARIABLE wgbosc058         AS HANDLE                     NO-UNDO.
DEFINE VARIABLE wgbosc074         AS HANDLE                     NO-UNDO.
DEFINE VARIABLE wgbosc096         AS HANDLE                     NO-UNDO.
DEFINE VARIABLE wgbosc145         AS HANDLE                     NO-UNDO.
DEFINE VARIABLE wgbosc152         AS HANDLE                     NO-UNDO.
DEFINE VARIABLE wgbc9033f         AS HANDLE                     NO-UNDO.
DEFINE VARIABLE l-retorno-bc9033g AS LOGICAL INITIAL NO         NO-UNDO.
DEFINE VARIABLE l-ler-endereco    AS LOGICAL                    NO-UNDO.
DEFINE VARIABLE l-ler-etiqpack    AS LOGICAL                    NO-UNDO.
DEFINE VARIABLE l-item-packing    AS LOGICAL                    NO-UNDO.
DEFINE VARIABLE vsit-docto        AS INTEGER                    NO-UNDO.
DEFINE VARIABLE vind-sit-agrup    AS INTEGER                    NO-UNDO.
DEFINE VARIABLE cIdBox            LIKE wm-box.id-box            NO-UNDO.
DEFINE VARIABLE cCodBloco         LIKE wm-box.cod-bloco         NO-UNDO.
DEFINE VARIABLE cCodRua           LIKE wm-box.cod-rua           NO-UNDO.
DEFINE VARIABLE cCodNivel         LIKE wm-box.cod-nivel         NO-UNDO.
DEFINE VARIABLE cCodColuna        LIKE wm-box.cod-coluna        NO-UNDO.
DEFINE VARIABLE d-qtd-retirada    AS DECIMAL                    NO-UNDO.

/* Definicao das temp-tables ref. ao processo de packing (tt-wm-packing e tt-itens)
   Essas TT's estao definidas na include WM9070.i. 
   A definicao foi copiada para evitar problemas com o pre-processador do campo 
   tt-Wm-packing.id-packing que existe nesta include (aqui o pre-processador foi removido).
*/

/*Defini‡Æo das temp-table tt-Wm-packing e tt-itens.*/
{cdp/cdcfgwms.i}
{wmp/wm9070.i}


/* condor */
RUN getParamTrans (INPUT "WMSai009":U,
                   INPUT "LER-ENDERECO-ITEM":U,
                   OUTPUT l-ler-endereco).
/* condor*/


/* login */ {utp/utapi009.i} 
DEFINE INPUT PARAMETER vRowid AS ROWID NO-UNDO.

DEFINE VARIABLE cEtiqueta  AS CHARACTER FORMAT "x(15)" NO-UNDO.

FIND FIRST ttWm-box-movto-idx-picking WHERE ROWID(ttWm-box-movto-idx-picking) = vRowid NO-ERROR.
FIND FIRST ttWork NO-ERROR.

DEFINE TEMP-TABLE tt-serial NO-UNDO
            FIELD id-etiqueta          LIKE wm-etiqueta.id-etiqueta
            FIELD qtd-item-retirado    LIKE wm-etiqueta.qtd-item-retirado
            FIELD id-movto             LIKE wm-movto-etiqueta.id-movto
            INDEX idx-serial  AS PRIMARY id-etiqueta.

DEFINE TEMP-TABLE tt-etiquetas-packing NO-UNDO LIKE wm-etiqueta
            FIELD RowNum  AS INTEGER INIT 1
            FIELD r-Rowid AS ROWID.

/* Propriedades globais para frames ---                     */               
&global-define FrameSize    21 By 8 
/************************************************************/
/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
/************************************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Picking Packing WMS'                             At Row 01 Col 01                         ~
                             '.................. '                             At Row 02 Col 01                               ~
                             '.................. '                             At Row 03 Col 01                               ~
                             'Doca:....Box:..... '                             AT ROW 04 COL 01                               ~
                             'Lida:...........   '                             At Row 05 Col 01                               ~
                             'Pend:...........   '                             AT ROW 06 COL 01                               ~
                             'Ser:.............. '                             At Row 07 Col 01                               ~
                             'Qtd:.....          '                             At Row 08 Col 01                               ~
                             ttWork.cod-item                                   At Row 02 Col 01 No-label Format 'x(18)'       ~
                             ttWork.des-endereco                               At Row 03 Col 01 No-label Format 'x(18)'       ~
                             ttWork.num-doca                                   At Row 04 Col 06 No-label Format '>>>'         ~
                             ttWork.num-box-lido                               At Row 04 Col 13 No-label FORMAT '>>>>>9'      ~
                             ttWork.cod-livre-3                                At Row 05 Col 06 NO-LABEL FORMAT "x(14)"       ~
                             ttWork.cod-livre-4                                At Row 06 Col 06 NO-LABEL FORMAT "x(14)"       ~
                             cEtiqueta                                         At Row 07 Col 05 No-label FORMAT "x(14)"       ~
                             ttWork.qtd-item-digit                             At Row 08 Col 05 NO-LABEL                      ~
                             
&global-define Frame01Repeat NO
                             
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Picking Packing WMS'                             At Row 01 Col 01                         ~
                             '.................. '                             At Row 02 Col 01                               ~
                             '.................. '                             At Row 03 Col 01                               ~
                             'Doca:....Box:..... '                             AT ROW 04 COL 01                               ~
                             'Lida:...........   '                             At Row 05 Col 01                               ~
                             'Pend:...........   '                             AT ROW 06 COL 01                               ~
                             'Ser:.............. '                             At Row 07 Col 01                               ~
                             'Qtd:.....          '                             At Row 08 Col 01                               ~
                             ttWork.cod-item                                   At Row 02 Col 01 No-label Format 'x(18)'       ~
                             ttWork.des-endereco                               At Row 03 Col 01 No-label Format 'x(18)'       ~
                             ttWork.num-doca                                   At Row 04 Col 06 No-label Format '>>>'         ~
                             ttWork.num-box-lido                               At Row 04 Col 13 No-label FORMAT '>>>>>9'      ~
                             ttWork.cod-livre-3                                At Row 05 Col 06 NO-LABEL FORMAT "x(14)"       ~
                             ttWork.cod-livre-4                                At Row 06 Col 06 NO-LABEL FORMAT "x(14)"       ~
                             cEtiqueta                                         At Row 07 Col 05 No-label FORMAT "x(14)"                     ~
                             ttWork.qtd-item-digit                             At Row 08 Col 05 NO-LABEL                      ~
                             
&global-define Frame02Repeat YES

/* FK INICIO - projeto parati */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Picking/Packing WMS'                             At Row 01 Col 01                         ~
                             'Tipo leitura?      '                             At Row 02 Col 01                         ~
                             '2 - Por quantidade '                             At Row 03 Col 01                         ~
                             '3 - Por EAN/DUN    '                             At Row 04 Col 01                         ~
                             '4 - Por Emb/Un     '                             AT ROW 05 COL 01                         ~
                             'Opcao              '                             At Row 08 Col 01                         ~
                             iIndTipoLeitura                                   At Row 08 Col 14 No-label Format '9'
                             
&global-define Frame03Repeat NO 

/************************************************************/
/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.num-box-lido WHEN l-ler-endereco = YES
&global-define Update02Fields cEtiqueta
/************************************************************/
/* Definicao das trigger de interacao com a tela ---        */  
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. If return-value = "ESC":U then return return-value. ~
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. If return-value = "ESC":U then return return-value. ~
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. If return-value = "ESC":U then return return-value. ~
                                                            

/* Definicao das trigger de usuario ---                     */  
&global-define UserTriggers ON 'END-ERROR':U OF Frame Frame01     ~
                            DO:                             ~
                                Assign vLogFinaliza = YES   ~
                                       vLogSai      = YES.  ~
                                RETURN 'ESC':U.             ~
                            END.                            ~
                            ON 'END-ERROR':U OF Frame Frame02     ~
                            DO:                             ~
                                IF l-ler-endereco = NO THEN ~
                                    Assign vLogFinaliza = YES   ~
                                           vLogSai      = YES.  ~
                                RETURN 'ESC':U.             ~
                            END.                            ~
/************************************************************/
/* Definicao dos objetos ativos ---                         */
&global-define ActiveObject1 wgbosc030
&global-define ActiveObject2 wgbosc032
&global-define ActiveObject3 wgbosc038
&global-define ActiveObject4 wgbosc044
&global-define ActiveObject5 wgbosc058
&global-define ActiveObject6 wgbosc074
&global-define ActiveObject7 wgbosc096
&global-define ActiveObject8 wgbosc145
&global-define ActiveObject9 wgbosc152
&global-define ActiveObject10 wgbc9033f
  
/************************************************************/

/*****************************************   Frames Fim ******************************************/
/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 2
/****************************************************************************************/
RUN InitHandles IN THIS-PROCEDURE.

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */ 
/**************************************************************************************************/
/************************************* Codigo do Usuario Inicio ************************************
** Este local ‚ destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/
/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:
   IF NOT AVAIL ttWm-box-movto-idx-picking THEN DO:
      ASSIGN vLogErro = YES.
      RETURN "ESC":U.
   END.
   ASSIGN ttWork.num-tempo-inicio = TIME.
   ASSIGN ttWork.qtd-embal-lidas = 0.
   ASSIGN ttWork.cod-livre-3 = STRING(ttWork.qtd-embal-lidas).
   DISP ttWork.cod-livre-3 WITH FRAME Frame01.
   
   /* Pegar Informacoes do endereco baseado no endereco que foi digitado */     
   RUN SetConstraintBoxes  IN wgbosc030 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                         INPUT ttWm-box-movto-idx-picking.cod-local,
                                         INPUT ttWm-box-movto-idx-picking.id-box,
                                         INPUT ttWm-box-movto-idx-picking.id-box).
   RUN openQueryStatic IN wgbosc030 (INPUT 'Boxes':U).
   RUN getBatchRecords IN wgbosc030 (INPUT ?,
                                     INPUT NO,
                                     INPUT ?,
                                     OUTPUT vNumCont,
                                     OUTPUT TABLE ttwm-box).
   FIND FIRST ttwm-box NO-ERROR.
   IF NOT AVAIL ttwm-box THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "002" "Box Inv lido(WMS)"}
      RETURN ERROR.
   END.
   
   /* Pegar Item */    
   RUN getInfoDoctoItens IN wgbosc096 ( INPUT ttWm-box-movto-idx-picking.cod-estabel, 
                                        INPUT ttWm-box-movto-idx-picking.cod-local,   
                                        INPUT ttWm-box-movto-idx-picking.id-docto,
                                        INPUT ttWm-box-movto-idx-picking.num-seq-item,
                                        OUTPUT TABLE ttwm-docto-itens ).
   FIND FIRST ttwm-docto-itens NO-LOCK NO-ERROR.
   IF NOT AVAIL ttwm-docto-itens THEN DO:
      ASSIGN vLogErro = YES.
      RETURN ERROR.
   END.
   
   /* Verifica o Tipo de Visualiza‡Æo da quantidade - Inicio */
   RUN pi-getIndTipoVisualiza IN THIS-PROCEDURE.
   
   ASSIGN ttWork.qtd-item  = (ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking.
   
   IF iIndTipoVisualiza = 2 THEN DO: /* Quantidade */   
      ASSIGN ttWork.cod-livre-4:SCREEN-VALUE IN FRAME {&Frame01Name} = STRING((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking,">>>>>>>>9.9999")
             ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame01Name} = STRING(ttWork.qtd-embal-lidas,">>>>>>>>9.9999").
   END.
   
   IF iIndTipoVisualiza = 4 THEN DO: /* Emb/Un */
      RUN piConverteQtdeCaixa IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                            INPUT ttWm-box-movto-idx-picking.cod-local,
                                            INPUT ttWm-box-movto-idx-picking.cod-item,
                                            INPUT ttWm-box-movto-idx-picking.cod-embalagem,
                                            INPUT ttWork.qtd-item, 
                                            OUTPUT p-qtd-caixas,
                                            OUTPUT p-qtd-unidades).
      
        
      
      ASSIGN ttWork.cod-livre-4:SCREEN-VALUE IN FRAME {&Frame01Name} = STRING(p-qtd-caixas,">>>>9") + " |" + STRING(p-qtd-unidades).
      
      RUN piConverteQtdeCaixa IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                            INPUT ttWm-box-movto-idx-picking.cod-local,
                                            INPUT ttWm-box-movto-idx-picking.cod-item,
                                            INPUT ttWm-box-movto-idx-picking.cod-embalagem,
                                            INPUT ttWork.qtd-embal-lidas,
                                            OUTPUT p-qtd-caixas,
                                            OUTPUT p-qtd-unidades). 
      
      
         
      
      ASSIGN ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame01Name} = STRING(p-qtd-caixas,">>>>9") + " |" + STRING(p-qtd-unidades).
   
   END.
   
   ASSIGN ttWork.cod-item :SCREEN-VALUE IN FRAME {&Frame01Name}       = ttWm-box-movto-idx-picking.cod-item
          ttWork.num-doca :SCREEN-VALUE IN FRAME {&Frame01Name}       = STRING(ttwm-docto-itens.cod-doca)
          ttWork.des-endereco:SCREEN-VALUE IN FRAME {&Frame01Name}    = ttwm-box.cod-bloco     + '/':U 
                                                                        + ttwm-box.cod-rua     + '/':U 
                                                                        + ttwm-box.cod-nivel   + '/':U 
                                                                        + ttwm-box.cod-coluna  + '/':U
                                                                        + IF ttwm-box.ind-posicao-box = 1 THEN 'E' ELSE 'D'
          ttWork.num-box-lido   :SCREEN-VALUE IN FRAME {&Frame01Name} = '0':U.
          ttWork.qtd-item-digit :SCREEN-VALUE IN FRAME {&Frame01Name} = '0':U .
   ASSIGN ttWork.num-box-lido    = 0
          ttWork.qtd-item-digit  = 0.
   
   /* condor */
   IF l-ler-endereco = YES THEN DO:
      ASSIGN ttWork.num-box-lido = 0
             ttWork.num-box-lido:SCREEN-VALUE IN FRAME {&Frame01Name} = '0':U.
   END.
   ELSE DO:
      ASSIGN ttWork.num-box-lido = ttWm-box-movto-idx-picking.id-box.
             ttWork.num-box-lido:SCREEN-VALUE IN FRAME {&frame01name} = STRING(ttWm-box-movto-idx-picking.id-box).
   END.
   
   /* Alterado para nao brecar no coletor */
   PAUSE 0 NO-MESSAGE.
END PROCEDURE.
/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame02:
   /* inicializa a leitura dos seriais */     
   IF NOT AVAIL ttWm-box-movto-idx-picking THEN DO:
      ASSIGN vLogErro = YES.
      RETURN "ESC":U.
   END.
   
   /* Incluido para zerar o campo. Estava confundindo o usuario */
   ASSIGN ttWork.num-serial = 0
          cEtiqueta         = "".
   
   RUN getParamTrans (INPUT "WMSai009":U,
                      INPUT "LER-ETIQUETA-PACKING":U,
                      OUTPUT l-ler-etiqpack).
   
   ASSIGN l-item-packing = NO.
   IF l-ler-etiqpack THEN DO:
      RUN getInfPackItemEtiqueta IN wgbosc152 (INPUT i-etiqueta-packing,
                                               OUTPUT l-item-packing).
   END.
   
   /* Verifica se deve executar frame de leitura da Etiqueta de Packing a cada leitura de Serial do Item
      Ira ler a Etiqueta para Itens que Nao Sofrem Packing  E quando o parametro da transacao estiver obrigando esta leitura. */
   IF NOT l-item-packing AND l-ler-etiqpack THEN DO: 
      DO ON ENDKEY UNDO,RETRY
         ON ERROR  UNDO,RETRY:
         
         IF RETRY AND NOT vLogErro THEN DO:
            ASSIGN vLogFinaliza = YES
                   vLogErro     = YES.
            RETURN "ESC".
         END.
            
         ASSIGN vLogErro               = NO
                i-etiqueta-packing-aux = 0.
      
         PAUSE 0.
         
         UPDATE 'Picking/Packing'                                 AT ROW 01 COL 01           
                '------------------'                              AT ROW 02 COL 01           
                'Etiqueta Packing:'                               AT ROW 03 COL 01          
                i-etiqueta-packing-aux                            AT ROW 04 COL 01 NO-LABEL 
            WITH FRAME fetiquetaembalagem 1 DOWN FONT 3 SIZE {&FrameSize} NO-BOX OVERLAY ROW 01 COL 01.
         
         IF LENGTH(STRING(i-etiqueta-packing-aux)) = 0 THEN DO:
            ASSIGN vLogErro = YES.
            {bcp/bc9105.i "000" "Etiqueta deve ser informada"}
            UNDO,RETRY.
         END.
      
         IF LENGTH(STRING(i-etiqueta-packing-aux)) <> 15 THEN DO:
            ASSIGN vLogErro = YES.
            {bcp/bc9105.i "000" "Etiqueta informada deve ser de Embalagem"}
            UNDO,RETRY.
         END.

         RUN goToKey IN wgbosc152 (INPUT i-etiqueta-packing-aux).
      
         IF RETURN-VALUE <> "OK":U THEN DO:
            ASSIGN vLogErro = YES.
            {bcp/bc9105.i "000" "Etiqueta de embalagem nÆo foi encontrada"}
            ASSIGN i-etiqueta-packing = 0.
            UNDO,RETRY.
         END.
         IF i-etiqueta-packing-aux <> 0 THEN
            ASSIGN i-etiqueta-packing = i-etiqueta-packing-aux.
         
         PAUSE 0.
      END.
   END. 
   ASSIGN p-qtd-caixas   = 0
          p-qtd-unidades = 0.
   
   /* Pegar Informacoes do endereco baseado no endereco que foi digitado */     
   RUN SetConstraintBoxes  IN wgbosc030 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                         INPUT ttWm-box-movto-idx-picking.cod-local,
                                         INPUT ttWm-box-movto-idx-picking.id-box,
                                         INPUT ttWm-box-movto-idx-picking.id-box).
   RUN openQueryStatic IN wgbosc030 (INPUT 'Boxes':U).
   RUN getBatchRecords IN wgbosc030 (INPUT ?,
                                     INPUT NO,
                                     INPUT ?,
                                     OUTPUT vNumCont,
                                     OUTPUT TABLE ttwm-box).
   FIND FIRST ttwm-box NO-ERROR.
   IF NOT AVAIL ttwm-box THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "002" "Box Inv lido(WMS)"}
      RETURN ERROR.
   END.
   
   /* Pegar Item */    
   RUN getInfoDoctoItens IN wgbosc096 ( INPUT ttWm-box-movto-idx-picking.cod-estabel, 
                                        INPUT ttWm-box-movto-idx-picking.cod-local,   
                                        INPUT ttWm-box-movto-idx-picking.id-docto,
                                        INPUT ttWm-box-movto-idx-picking.num-seq-item,
                                        OUTPUT TABLE ttwm-docto-itens ).
   FIND FIRST ttwm-docto-itens NO-LOCK NO-ERROR.
   IF NOT AVAIL ttwm-docto-itens THEN DO:
      ASSIGN vLogErro = YES.
      RETURN ERROR.
   END.
   
   /* Verifica o Tipo de Visualiza‡Æo da quantidade - Inicio */
   RUN pi-getIndTipoVisualiza IN THIS-PROCEDURE.
   
   ASSIGN ttWork.qtd-item  = (ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking.
   
   /* Verifica o Tipo de Visualiza‡Æo da quantidade - Inicio */
   IF iIndTipoVisualiza = 2 THEN DO: /* Quantidade */
      ASSIGN ttWork.cod-livre-4:SCREEN-VALUE IN FRAME {&Frame02Name} = STRING((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking,">>>>>>>>9.9999")
             ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame02Name} = STRING(ttWork.qtd-embal-lidas,">>>>>>>>9.9999").
   END.
   
   IF iIndTipoVisualiza = 4 THEN DO: /* Emb/Un */   
      RUN piConverteQtdeCaixa IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                            INPUT ttWm-box-movto-idx-picking.cod-local,
                                            INPUT ttWm-box-movto-idx-picking.cod-item,
                                            INPUT ttWm-box-movto-idx-picking.cod-embalagem,
                                            INPUT ttWork.qtd-item,
                                            OUTPUT p-qtd-caixas,
                                            OUTPUT p-qtd-unidades).
      
      ASSIGN ttWork.cod-livre-4:SCREEN-VALUE IN FRAME {&Frame02Name} = STRING(p-qtd-caixas,">>>>9") + " |" + STRING(p-qtd-unidades).
      
      RUN piConverteQtdeCaixa IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                            INPUT ttWm-box-movto-idx-picking.cod-local,
                                            INPUT ttWm-box-movto-idx-picking.cod-item,
                                            INPUT ttWm-box-movto-idx-picking.cod-embalagem,
                                            INPUT ttWork.qtd-embal-lidas,
                                            OUTPUT p-qtd-caixas,
                                            OUTPUT p-qtd-unidades). 
      
      ASSIGN ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame02Name} = STRING(p-qtd-caixas,">>>>9") + " |" + STRING(p-qtd-unidades).
   END.
   ASSIGN ttWork.qtd-item = (ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking.
   
   ASSIGN ttWork.cod-item:SCREEN-VALUE IN FRAME {&Frame02Name}     = ttwm-docto-itens.cod-item
          ttWork.num-doca:SCREEN-VALUE IN FRAME {&Frame02Name}     = STRING(ttwm-docto-itens.cod-doca)
          ttWork.des-endereco:SCREEN-VALUE IN FRAME {&Frame02Name} = ttwm-box.cod-bloco       + '/':U 
                                                                     + ttwm-box.cod-rua       + '/':U 
                                                                     + Ttwm-box.cod-nivel     + '/':U 
                                                                     + ttwm-box.cod-coluna    + '/':U
                                                                     + IF ttwm-box.ind-posicao-box = 1 THEN 'E' ELSE 'D'
          ttWork.num-box-lido:SCREEN-VALUE IN FRAME {&Frame02Name} = STRING(ttWork.num-box-lido).
   
   ASSIGN ttWork.qtd-embal-lidas = 0.
   
   /* iniciliza temp-table tt-picking-wms-table baseada na tabela bc-trans */      
   RUN pi-inicializa-tt-picking-wms-table IN wgbc9033f (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                                        INPUT ttWm-box-movto-idx-picking.cod-local,
                                                        INPUT ttWm-box-movto-idx-picking.id-movto,
                                                        INPUT ttWm-box-movto-idx-picking.ind-tipo-movto,
                                                        OUTPUT TABLE tt-picking-wms-table).
   IF RETURN-VALUE <> 'OK':U OR NOT VALID-HANDLE(wgbc9033f) Then Do:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "104" "Problemas na inicializa‡Æo (DC)"}
   END.
   
   FOR EACH tt-picking-wms-table
      WHERE tt-picking-wms-table.id-docto       = ttWm-box-movto-idx-picking.id-docto
        AND tt-picking-wms-table.id-movto       = ttWm-box-movto-idx-picking.id-movto
        AND tt-picking-wms-table.num-seq-item   = ttWm-box-movto-idx-picking.num-seq-item
        AND tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto:
   
      ASSIGN ttWork.qtd-embal-lidas = ttWork.qtd-embal-lidas + tt-picking-wms-table.qtd-item-digit.
   END.
   
   ASSIGN ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame02Name} = STRING(ttWork.qtd-embal-lidas,">>>>>>>>9.9999").
   
   /* ConversÆo emb/un - Inicio */ 
   IF iIndTipoVisualiza = 4 THEN DO:
      RUN piConverteQtdeCaixa IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                            INPUT ttWm-box-movto-idx-picking.cod-local,
                                            INPUT ttWm-box-movto-idx-picking.cod-item,
                                            INPUT ttWm-box-movto-idx-picking.cod-embalagem,
                                            INPUT ttWork.qtd-embal-lidas,
                                            OUTPUT p-qtd-caixas,
                                            OUTPUT p-qtd-unidades). 
      
      ASSIGN ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame02Name} = STRING(p-qtd-caixas,">>>>9") + " |" + STRING(p-qtd-unidades).
   END.
  
   PAUSE 0 NO-MESSAGE.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
   ASSIGN vLogIniciado = YES.
   ASSIGN vLogErro     = NO
          vLogSai      = NO
          vLogFinaliza = NO.
   IF ttWork.num-box-lido = 0 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "401" "Box Inv lido(WMS)"}
      RETURN ERROR.
   END.
   RUN emptyRowErrors IN wgbosc032.
   RUN validaBoxOut IN wgbosc032 (INPUT ttWm-box-movto-idx-picking.cod-estabel, 
                                  INPUT ttWm-box-movto-idx-picking.cod-local,   
                                  INPUT ttWm-box-movto-idx-picking.id-movto,
                                  INPUT ttWork.num-box-lido).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      RUN getRowErrors IN wgbosc032(OUTPUT TABLE RowErrors).
      FOR EACH RowErrors:
         CREATE tt-erro.
         ASSIGN tt-erro.i-sequen = 1011
                tt-erro.cd-erro  = ErrorNumber
                tt-erro.mensagem = ErrorDescription + "(WMS)":U.
      END.
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "402" "Box Diferente (WMS)"}
      /* Sai quando dah erro de box diferente */
      ASSIGN vLogSai = YES.   
      RETURN ERROR.
   END. 
   
   HIDE ALL.
   ASSIGN vLogFinaliza = NO
          vLogSai      = NO.
   
   RETURN 'OK':U.
END PROCEDURE.
/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame02:
   DEFINE VARIABLE vqtd-item    AS DECIMAL NO-UNDO.
   DEFINE VARIABLE lIniciaTrans AS LOGICAL NO-UNDO.
   
   RUN RetiraString(INPUT-OUTPUT cEtiqueta).
   ASSIGN ttwork.num-serial = DECIMAL(cEtiqueta)
          lIniciaTrans      = NO.
   
   DO TRANS:   
      IF RETURN-VALUE = "ESC":U THEN DO:
         ASSIGN vLogFinaliza = YES.
         RETURN "ESC":U.
      END.
      
      /* Validacoes Frame 05 Inicio --- */     
      ASSIGN vLogErro     = NO
             vLogSai      = NO
             vLogFinaliza = NO.
      
      IF NOT AVAIL ttWm-box-movto-idx-picking THEN DO:
         ASSIGN vLogErro = YES.
         {bcp/bc9105.i "500" "Movimento Vencido (WMS)"}
         UNDO, RETURN 'NOK':U.
      END.
      
      IF ttWork.num-serial = 0 THEN DO:
         ASSIGN vLogErro = YES.
         {bcp/bc9105.i "501" "Serial Inv lido (DC)"}
         UNDO, RETURN 'NOK':U.
      END.
      
      /* Codigo adicionado para buscar o box da etiqueta lida */
      IF l-ler-endereco = NO THEN DO:
         RUN getSerialAdrress IN wgbosc074  (INPUT ttWork.num-serial,
                                             OUTPUT cIdBox,
                                             OUTPUT cCodBloco,
                                             OUTPUT cCodRua,   
                                             OUTPUT cCodNivel, 
                                             OUTPUT cCodColuna).
         
         IF RETURN-VALUE = 'OK':U THEN
           ASSIGN ttWork.num-box-lido = cIdBox.
      END.
      
      IF ttWork.num-serial = 888888 THEN DO:
         RUN gravaTransacao.       
         
         IF RETURN-VALUE <> 'OK':U THEN DO:
            ASSIGN vLogFinaliza = NO 
                   vLogSai      = NO
                   vlogerro     = NO
                   vlogcancela  = NO.
            UNDO, RETURN RETURN-VALUE.
         END.
         
         ASSIGN vLogFinaliza = YES 
                vLogSai      = YES
                vlogerro     = NO
                vlogcancela  = NO.
         RETURN 'OK':U.
      END.
      
      /* Busca o estabelecimento e o local do documento */
      RUN getEstabelLocalDocto IN wgbosc038 (INPUT ttWm-box-movto-idx-picking.id-docto,
                                             OUTPUT v-cod-estabel,
                                             OUTPUT v-cod-local) NO-ERROR.
      
      /* Busca o saldo do documento */
      ASSIGN vNumSaldo = ((ttwm-docto-itens.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWork.qtd-embal-lidas).
      
      RUN EmptyRowErrors IN wgbosc074 NO-ERROR.
      EMPTY TEMP-TABLE tt-serial.
      
      /* cria o tt-serial */
      FOR EACH tt-picking-wms-table
         WHERE tt-picking-wms-table.id-docto       = ttWm-box-movto-idx-picking.id-docto
           AND tt-picking-wms-table.id-movto       = ttWm-box-movto-idx-picking.id-movto
           AND tt-picking-wms-table.num-seq-item   = ttWm-box-movto-idx-picking.num-seq-item
           AND tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto:
      
         CREATE tt-serial.
         ASSIGN tt-serial.id-etiqueta       = tt-picking-wms-table.num-serial
                tt-serial.qtd-item-retirado = tt-picking-wms-table.qtd-item-digit
                tt-serial.id-movto          = tt-picking-wms-table.id-movto.
      END.
      
      /* valida a etiqueta */
      RUN validaEtiquetaMovtoPicking IN wgbosc074  (INPUT v-cod-estabel,
                                                    INPUT v-cod-local,
                                                    INPUT ttWork.num-serial,
                                                    INPUT ttWm-box-movto-idx-picking.id-docto,
                                                    INPUT ttWm-box-movto-idx-picking.num-seq-item,
                                                    INPUT ttWm-box-movto-idx-picking.id-movto,
                                                    INPUT ttWm-box-movto-idx-picking.ind-tipo-movto,
                                                    INPUT vNumSaldo,
                                                    INPUT TABLE tt-serial,
                                                    OUTPUT vCodItem,
                                                    OUTPUT ttWm-box-movto-idx-picking.cod-embalagem,
                                                    OUTPUT vNumItensSerial).
      
      RUN getRowErrors IN wgbosc074 (OUTPUT TABLE RowErrors) NO-ERROR.
      
      FOR EACH RowErrors:
         HIDE ALL NO-PAUSE.
         ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
         Run bcp/bc9115.p (ErrorNumber,
                           ErrorDescription,
                           8,
                           20,
                           3).
         HIDE ALL NO-PAUSE.
      END.
      IF CAN-FIND( FIRST rowErrors) THEN DO:
         ASSIGN vLogErro = YES.
         UNDO, RETURN ERROR.
      END.
      ASSIGN lIniciaTrans = YES.
      
      /* Verifica se abre embalagem */        
      RUN getAbreEmbalagem IN wgbosc145 ( INPUT ttwm-docto-itens.cod-estabel,
                                          INPUT ttwm-docto-itens.cod-local,
                                          INPUT ttwm-docto-itens.cod-item,
                                          INPUT ttWm-box-movto-idx-picking.cod-embalagem,
                                          OUTPUT v-log-abre-embalagem). 
      
      IF v-log-abre-embalagem AND (((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) = vNumItensSerial)) THEN DO:      
         IF ttWm-box-movto-idx-picking.log-picking = NO THEN
            ASSIGN ttWm-box-movto-idx-picking.log-picking = YES. 
      END.
      /*  Busca se o tipo de leitura eh por eah ou por dun */
      IF v-log-abre-embalagem = YES THEN
         RUN pi-getIndTipoLeitura IN THIS-PROCEDURE.
      
      /* Se abre embalagem e o serial for diferente de zero */
      IF v-log-abre-embalagem THEN DO:
         FIND FIRST tt-picking-wms-table
              WHERE tt-picking-wms-table.num-serial     = ttWork.num-serial
                AND tt-picking-wms-table.id-docto       = ttWm-box-movto-idx-picking.id-docto
                AND tt-picking-wms-table.id-movto       = ttWm-box-movto-idx-picking.id-movto
                AND tt-picking-wms-table.num-seq-item   = ttWm-box-movto-idx-picking.num-seq-item
                AND tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto NO-ERROR.
         IF AVAIL tt-picking-wms-table THEN DO:
            /* Nao deixa o usuario ler este serial se a quantidade disponivel dele estiver esgotada */             
            IF vNumItensSerial <= tt-picking-wms-table.qtd-item-digit THEN DO:
               ASSIGN vLogErro = YES.
               {bcp/bc9105.i "503" "Quantidade Serial Insuficiente ou Completada (WMS)"}
               UNDO, RETURN 'NOK':U.
            END.               
            ELSE DO:
               ASSIGN vNumItensSerial = vNumItensSerial - tt-picking-wms-table.qtd-item-digit.         
            END. 
         END.
      END.
      ELSE DO:
         FIND FIRST tt-picking-wms-table
              WHERE tt-picking-wms-table.num-serial     = ttWork.num-serial
                And tt-picking-wms-table.id-docto       = ttWm-box-movto-idx-picking.id-docto
                And tt-picking-wms-table.id-movto       = ttWm-box-movto-idx-picking.id-movto
                And tt-picking-wms-table.num-seq-item   = ttWm-box-movto-idx-picking.num-seq-item
                And tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto NO-LOCK NO-ERROR.
         IF AVAIL tt-picking-wms-table AND ttWork.num-serial <> 0 THEN DO:
            ASSIGN vLogErro = YES.
            {bcp/bc9105.i "504" "Serial j  Lido (WMS)"}
            UNDO, RETURN 'NOK':U.
         END.
      END.
      
      /* Pega o item e a quantidade do movimento */
      ASSIGN {&TempTable}.num-serial = ttWork.num-serial.
      ASSIGN ttWork.qtd-item = (ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking.
            
      /* Permite alterar a quantidade quando o serial abre embalgem ou via item nÆo sendo Box de Picking */
      IF v-log-abre-embalagem THEN DO:             
         HIDE ALL NO-PAUSE.                                                                                                                                
                                                                                                                                                            
         RUN bcp/bc9033g.p (INPUT ROWID(ttwm-box),                                                                                                         
                            INPUT ROWID(ttWm-box-movto-idx-picking),                                                                                       
                            INPUT ROWID(bttWm-box-movto-idx-picking),                                                                                      
                            INPUT ROWID(ttwm-docto-itens),                                                                                                 
                            INPUT-OUTPUT TABLE tt-picking-wms-table,
                            OUTPUT l-retorno-bc9033g).                                                                                      
                                                                                                                                                            
         HIDE ALL NO-PAUSE.                                                                                                                                                            
         IF NOT l-retorno-bc9033g THEN DO:
            ASSIGN vLogFinaliza = NO
                   vLogSai      = NO
                   vLogerro     = YES.
                   
            UNDO, RETURN RETURN-VALUE.
         END.
                                                                                                                                                            
         ASSIGN vLogFinaliza = YES 
                vLogSai      = YES
                vlogerro     = NO
                vlogcancela  = NO.
         RETURN RETURN-VALUE.
      END.
   
      ASSIGN vqtd-item = 0.
      FOR EACH tt-picking-wms-table
         WHERE tt-picking-wms-table.id-docto       = ttWm-box-movto-idx-picking.id-docto 
           AND tt-picking-wms-table.id-movto       = ttWm-box-movto-idx-picking.id-movto
           AND tt-picking-wms-table.num-seq-item   = ttWm-box-movto-idx-picking.num-seq-item    
           AND tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto NO-LOCK:
         ASSIGN vqtd-item = vqtd-item + tt-picking-wms-table.qtd-item-digit.
      END.
      
      /*  Quantidade do item no Packing */
      ASSIGN vqtd-item = vqtd-item + vNumItensSerial.
      IF vqtd-item >  ttWork.qtd-item THEN DO:
         ASSIGN vLogErro = YES.
         {bcp/bc9105.i "603" "Quantidade Inv lida (WMS)"}
         UNDO, RETURN ERROR.
      END.
      
      FIND FIRST tt-picking-wms-table
           WHERE tt-picking-wms-table.num-serial     = ttWork.num-serial
             AND tt-picking-wms-table.id-docto       = ttWm-box-movto-idx-picking.id-docto
             AND tt-picking-wms-table.id-movto       = ttWm-box-movto-idx-picking.id-movto
             AND tt-picking-wms-table.num-seq-item   = ttWm-box-movto-idx-picking.num-seq-item
             AND tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto NO-ERROR.      
      IF AVAIL tt-picking-wms-table THEN DO:            
         RUN pi-atualiza-qtd-digitada IN wgbc9033f (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                                    INPUT ttWm-box-movto-idx-picking.cod-local,
                                                    INPUT ttWm-box-movto-idx-picking.id-movto,
                                                    INPUT ttWm-box-movto-idx-picking.ind-tipo-movto,
                                                    INPUT ttwm-box-movto-idx-picking.id-docto,
                                                    INPUT ttWork.num-serial,
                                                    INPUT ttWm-box-movto-idx-picking.num-seq-item,
                                                    INPUT vNumItensSerial,
                                                    INPUT tt-picking-wms-table.qtd-item-digit,
                                                    input-OUTPUT TABLE tt-erro).
         
         FIND FIRST tt-erro NO-ERROR.
         IF AVAIL tt-erro THEN DO: 
            FOR EACH tt-erro:
               ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(WMS)":U.
               {bcp/bc9015.i2 STRING(tt-erro.cd-erro) STRING(tt-erro.mensagem)}
               ASSIGN vLogSai = YES.
            END.
            IF vLogErro = YES THEN
               RETURN ERROR.
         END.
         ASSIGN tt-picking-wms-table.qtd-item-digit = tt-picking-wms-table.qtd-item-digit + vNumItensSerial.      
      END.
      ELSE IF lIniciaTrans THEN DO:
         RUN pi-cria-tt-picking-ems-table IN wgbc9033f (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                                        INPUT ttWm-box-movto-idx-picking.cod-local,
                                                        INPUT ttWm-box-movto-idx-picking.id-movto,
                                                        INPUT ttWm-box-movto-idx-picking.ind-tipo-movto,
                                                        INPUT ttwm-box-movto-idx-picking.id-docto,
                                                        INPUT ttWork.num-serial,
                                                        INPUT ttWm-box-movto-idx-picking.num-seq-item,
                                                        INPUT vNumItensSerial,
                                                        INPUT vNumItensSerial , /*ttwork.qtd-item-digit */                                                     
                                                        INPUT ttWm-box-movto-idx-picking.cod-item,
                                                        INPUT ttWork.num-box-lido, /* ttWm-box-movto-idx-picking.id-box. FO 999.812 */
                                                        INPUT ttWm-box-movto-idx-picking.cod-embalagem,
                                                        INPUT ttWm-box-movto-idx-picking.qti-embalagem,
                                                        INPUT ttWm-box-movto-idx-picking.dt-atualizacao,
                                                        INPUT ttWm-box-movto-idx-picking.dt-transacao,
                                                        INPUT ttWork.num-tempo-inicio,
                                                        INPUT ttWork.cod-coletor,
                                                        INPUT ttWork.cod-equipamento,
                                                        INPUT "", /* Lote em branco, pois se nÆo encontrar ‚ porque ‚ uma transa‡Æo com serial que ir  pegar o lote pela etiqueta na API de efetiva‡Æo */
                                                        INPUT-OUTPUT TABLE tt-picking-wms-table,
                                                        OUTPUT TABLE tt-erro).
      
         FIND FIRST tt-erro NO-ERROR.
         IF AVAIL tt-erro THEN DO: 
            FOR EACH tt-erro:
               ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(WMS)":U.
               {bcp/bc9015.i2 STRING(tt-erro.cd-erro) STRING(tt-erro.mensagem)}
               ASSIGN vLogSai = YES.
            END.
            IF vLogErro = YES THEN
               RETURN ERROR.
         END.      
      END.
      ASSIGN ttWork.qtd-embal-lidas = 0.
      
      For Each tt-picking-wms-table
         WHERE tt-picking-wms-table.id-docto       = ttWm-box-movto-idx-picking.id-docto 
           AND tt-picking-wms-table.id-movto       = ttWm-box-movto-idx-picking.id-movto
           AND tt-picking-wms-table.num-seq-item   = ttWm-box-movto-idx-picking.num-seq-item    
           AND tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto NO-LOCK:
         ASSIGN ttWork.qtd-embal-lidas = ttWork.qtd-embal-lidas + tt-picking-wms-table.qtd-item-digit.
      END.
      
      ASSIGN ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame02Name} = STRING(ttWork.qtd-embal-lidas).
      ASSIGN ttWork.cod-estabel      = v-cod-estabel
             ttWork.cod-local        = v-cod-local
             ttWork.id-docto         = ttWm-box-movto-idx-picking.id-docto
             ttWork.id-movto         = ttWm-box-movto-idx-picking.id-movto
             ttWork.num-seq-item     = ttWm-box-movto-idx-picking.num-seq-item
             ttWork.num-box          = ttWork.num-box-lido /* ttWm-box-movto-idx-picking.id-box. FO 999.812 */
             ttWork.num-doca         = ttwm-docto-itens.cod-doca
             ttWork.cod-embalagem    = ttWm-box-movto-idx-picking.cod-embalagem
             ttWork.des-endereco     = ttWork.des-endereco:Screen-value In Frame {&Frame02Name} 
             ttWork.cod-item         = ttwm-docto-itens.cod-item
             ttWork.qtd-item         = ttWm-box-movto-idx-picking.qtd-item
             ttWork.qtd-embalagem    = ttWm-box-movto-idx-picking.qti-embalagem
             ttWork.dat-atualizacao  = ttWm-box-movto-idx-picking.dt-atualizacao
             ttWork.dat-transacao    = ttWm-box-movto-idx-picking.dt-transacao.
      
      PAUSE 0 NO-MESSAGE BEFORE-HIDE.
      
      /* Esta verifica‡Æo pode ser parcial, nÆo necessariamente precisando ser igual a quantidade do movimento */     
      
      IF ((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking) >= ttWork.qtd-embal-lidas THEN DO:
         PAUSE 0 NO-MESSAGE.
         
         RUN gravaTransacao.
         
         IF RETURN-VALUE = 'CTA':U THEN 
            ASSIGN vLogFinaliza = NO 
                   vLogSai      = NO
                   vlogerro     = NO
                   vlogcancela = NO.
         
         IF RETURN-VALUE = 'NOK':U THEN DO:
            ASSIGN vLogFinaliza = NO 
                   vLogSai      = NO
                   vlogerro     = NO
                   vlogcancela  = NO.
            UNDO, RETURN RETURN-VALUE.
         END.
         
         IF RETURN-VALUE = 'OK':U THEN DO:
            ASSIGN vLogFinaliza = YES 
                   vLogSai      = YES
                   vlogerro     = NO
                   vlogcancela  = NO.
            RETURN 'OK':U.
         END.
      END.
      
      ASSIGN vLogFinaliza = No
             vLogSai      = No
             vlogerro     = NO.
      
      RETURN 'NOK':U.
   END.    
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure e‹ executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
PROCEDURE GravaTransacao:
   DEF VAR vNomeUsuario            AS CHARACTER                NO-UNDO.
   DEF VAR v-detalhe               AS CHARACTER                NO-UNDO.
   
   PAUSE 0 NO-MESSAGE.
   
   FIND FIRST wm-etiqueta
        WHERE wm-etiqueta.id-etiqueta = ttWork.num-serial NO-LOCK NO-ERROR.
   IF AVAIL wm-etiqueta THEN
      ASSIGN d-qtd-retirada = wm-etiqueta.qtd-item-retirado.
   
   ASSIGN vNomeUsuario = ttWork.cod-usuario.
   ASSIGN ttWork.cod-estabel           = v-cod-estabel
          ttWork.cod-local             = v-cod-local
          ttWork.id-docto              = ttWm-box-movto-idx-picking.id-docto
          ttWork.id-movto              = ttWm-box-movto-idx-picking.id-movto
          ttWork.num-seq-item          = ttWm-box-movto-idx-picking.num-seq-item
          ttWork.num-box               = ttWork.num-box-lido
          ttWork.num-doca              = ttwm-docto-itens.cod-doca
          ttWork.cod-embalagem         = ttWm-box-movto-idx-picking.cod-embalagem
          ttWork.des-endereco          = ttWork.des-endereco:Screen-value In Frame {&Frame02Name} 
          ttWork.cod-item              = ttwm-docto-itens.cod-item
          ttWork.qtd-item              = ttWm-box-movto-idx-picking.qtd-item
          ttWork.qtd-embalagem         = ttWm-box-movto-idx-picking.qti-embalagem
          ttWork.dat-atualizacao       = ttWm-box-movto-idx-picking.dt-atualizacao
          ttWork.dat-transacao         = ttWm-box-movto-idx-picking.dt-transacao.
   
   EMPTY TEMP-TABLE tt-erro.
   EMPTY TEMP-TABLE tt-trans.
   
   ASSIGN v-detalhe = 'Est:':U  + TRIM(ttWm-box-movto-idx-picking.cod-estabel) + ';':U +
                      'Loc:':U  + TRIM(ttWm-box-movto-idx-picking.cod-local) + ';':U +
                      'IMo:':U  + TRIM(STRING(ttWm-box-movto-idx-picking.id-movto,'>>>>>>>>>9':U)) + ';':U + 
                      'ITM:':U  + TRIM(STRING(ttWm-box-movto-idx-picking.ind-tipo-movto,'>9':U)).
   
   /* cria‡ao da bc-trans */     
   CREATE tt-trans.
   ASSIGN tt-trans.cod-versao-integracao = 1
          tt-trans.i-sequen = 1
          tt-trans.cd-trans = 'WMSai009':U
          tt-trans.detalhe  = v-detalhe.
          tt-trans.usuario  = v_cod_usuar_corren.
          tt-trans.etiqueta = NO.
   
   RUN finaliza-picking IN wgbc9033f ( INPUT TABLE tt-trans,
                                       OUTPUT TABLE tt-erro).
   
   FIND FIRST tt-erro NO-ERROR.
   IF AVAIL tt-erro THEN DO: 
      FOR EACH tt-erro:
         ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(DC)":U.
         {bcp/bc9015.i2 string(tt-erro.cd-erro) string(tt-erro.mensagem)}
         ASSIGN vLogFinaliza = YES
                vLogSai      = YES.
      END.
      IF vLogErro = YES THEN
         RETURN ERROR.
   END.
   ELSE DO:
      RUN picking-pre-api-wms IN wgbc9033f ( INPUT-OUTPUT TABLE tt-trans,
                                             INPUT-OUTPUT TABLE tt-erro).
      
      FIND FIRST tt-erro NO-ERROR.
      IF AVAIL tt-erro THEN DO: 
         FOR EACH tt-erro:
            ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(DC)":U.
            {bcp/bc9015.i2 string(tt-erro.cd-erro) string(tt-erro.mensagem)}
         END.
      END.
      ELSE DO:     
         /* condor */
         /* Apos concluir o Picking, chama efetivacao do Packing */
         
         RUN getParamTrans (INPUT "WMSai009":U,
                            INPUT "LER-ETIQUETA-PACKING":U,
                            OUTPUT l-ler-etiqpack).
         
         RUN getInfPackItemEtiqueta IN wgbosc152 (INPUT i-etiqueta-packing,
                                                  OUTPUT l-item-packing).      
         
         IF l-item-packing = YES OR l-ler-etiqpack = YES THEN DO:         
            RUN EfetivaPacking.
            
            IF RETURN-VALUE <> "NOK":U THEN DO:
               {bcp/bc9105.i "901" "Picking/Packing executado com Sucesso (DC)"}
            END.
            ELSE 
               RETURN RETURN-VALUE.
         END.
         ELSE DO: 
            {bcp/bc9105.i "901" "Picking executado com Sucesso (DC)"}
         END.                                                      
         
         /* Nao finaliza a tela enquanto a quantidade lida 
            for menor que a quantidade do movimento */
         DO:
            /* Incrementa a quantidade de picking */
            ASSIGN ttWm-box-movto-idx-picking.qtd-item-picking = ttWm-box-movto-idx-picking.qtd-item-picking + ttWork.qtd-embal-lidas.
            
            /* Se a quantidade de picking for igual ao movimento, elimina a ttwm-box-movto-idx-picking */
            IF (ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking = 0  THEN DO:
               DELETE ttWm-box-movto-idx-picking.
               RETURN "OK":U.
            END.
         END.
         ASSIGN ttWork.qtd-item-digit = 0.
         ASSIGN vLogFinaliza = NO 
                vLogSai      = NO
                vlogerro     = NO
                vlogcancela  = NO.
         
         RETURN "CTA":U.  /* continua leitura */
      END.
   END.
   
   ASSIGN ttWork.qtd-item-digit  = 0
          ttWork.qtd-embal-lidas = 0
          ttWork.num-serial      = 0.
   
   ASSIGN vLogEmProcesso = YES
          vLogSai        = NO
          vLogFinaliza   = NO.
   
   RETURN 'NOK':U.
END PROCEDURE.

/* verifica o parametro e se pega ou nao  */
PROCEDURE pi-getIndTipoLeitura:
   /* Soh faz se abrir embalagem */
   IF v-log-abre-embalagem = YES THEN DO:
      /* Usado para identificar o tipo de endereco */
      DEFINE VARIABLE cTipoBox AS CHARACTER  NO-UNDO.
      
      /* Busca o tipo de endereco (bc9033h.i) */
      RUN pi-getTipoEndereco(INPUT ttWm-box-movto-idx-picking.cod-estabel, 
                             INPUT ttWm-box-movto-idx-picking.cod-local, 
                             INPUT ttWork.num-box-lido, 
                             OUTPUT cTipoBox).
      
      /* Busca o parametro da bc-param-ext conforme o tipo de endereco (BC9033h.i) */
      RUN pi-getValorParametro (INPUT ttWm-box-movto-idx-picking.cod-item,
                                INPUT "wmsai009":u,
                                INPUT (IF cTipoBox = "NORMAL":U THEN "LEIT-QTD-AREA-NORMAL":U ELSE "LEIT-QTD-AREA-PICKIN":U),
                                OUTPUT iIndTipoLeitura).
      
      /* Se nÆo achar o parametro, assume o valor 2 */
      IF iIndTipoLeitura = 0 THEN DO:
         {bcp/bc9105.i "104" "Parametros nao foram inicializados (DC)"}
         ASSIGN iIndTipoLeitura = 2.
      END.
      
      /* Caso o parametro seja informado incorretamente, informa ao usuario */
      IF iIndTipoLeitura < 0 OR iIndTipoLeitura > 4 THEN DO:
         {bcp/bc9105.i "104" "Valor do parametro incorreto para o item/familia/transacao (DCCCCC)"}
         ASSIGN iIndTipoLeitura = 2.
      END.
      
      /* Se o tipo de leitura for igual a 1, pede em tela */
      IF iIndTipoLeitura = 1 THEN DO:
         REPEAT:
            UPDATE iIndTipoLeitura WITH FRAME Frame03.
            
            /* S¢ aceita valores 2 e 3 digitados em tela */
            IF iIndTipoLeitura = 2 OR iIndTipoLeitura = 3 OR iIndTipoLeitura = 4 THEN
               LEAVE.
         END.
      END.
   END. 
END PROCEDURE.

/*************************************************************************/
/** Efetiva‡Æo do Packing - Procedure chamada apos conclusao do Picking **/
/*************************************************************************/
PROCEDURE EfetivaPacking :
   DEFINE VARIABLE vid-tarefa       LIKE wm-tarefa-resumo-pedido.id-tarefa NO-UNDO.
   DEFINE VARIABLE vnum-seq-volume  LIKE wm-packing.num-seq-volume         NO-UNDO.
   DEFINE VARIABLE vcod-item        LIKE wm-box-movto.cod-item             NO-UNDO.
   DEFINE VARIABLE vpeso-item       AS DECIMAL                             NO-UNDO.
   DEFINE VARIABLE vdt-lote         AS DATE                                NO-UNDO.
   DEFINE VARIABLE vcod-cliente     AS INTEGER                             NO-UNDO.
   DEFINE VARIABLE c-cod-local      AS CHARACTER                           NO-UNDO.
   DEFINE VARIABLE c-cod-estabel    AS CHARACTER                           NO-UNDO.
   DEFINE VARIABLE c-nr-pedcli      AS CHARACTER                           NO-UNDO.
   DEFINE VARIABLE c-cod-embalagem  AS CHARACTER                           NO-UNDO.
   DEFINE VARIABLE c-nome-abrev     AS CHARACTER                           NO-UNDO.
   DEFINE VARIABLE i-num-volume     AS INTEGER                             NO-UNDO.
   DEFINE VARIABLE d-cdd-embarq     AS DECIMAL                             NO-UNDO.
   DEFINE VARIABLE i-nr-resumo      AS INTEGER                             NO-UNDO.
   
   bc9033:
   DO TRANSACTION ON ERROR  UNDO bc9033, LEAVE bc9033
                  ON QUIT   UNDO bc9033, LEAVE bc9033
                  ON STOP   UNDO bc9033, LEAVE bc9033
                  ON ENDKEY UNDO bc9033, LEAVE bc9033:
   
      ASSIGN vcod-item = ttWm-box-movto-idx-picking.cod-item
             vcod-cliente = ttWm-box-movto-idx-picking.cod-cliente.
      
      /* posiciona para ser usada no assign da temp-table */
      RUN openQueryStatic IN wgbosc152 (INPUT "Main":U) NO-ERROR.
      RUN goToKey IN wgbosc152 (INPUT i-etiqueta-packing).
      IF RETURN-VALUE <> "OK":U THEN DO:
         ASSIGN vLogErro = YES.
         {bcp/bc9105.i "000" "Etiqueta de embalagem nÆo foi encontrada"}
         ASSIGN i-etiqueta-packing = 0.
         UNDO,RETRY.
      END.
      
      RUN getCharField IN wgbosc152 (INPUT  "cod-local":U,
                                     OUTPUT c-cod-local).
      
      RUN getCharField IN wgbosc152 (INPUT  "cod-estabel":U,
                                     OUTPUT c-cod-estabel).
      
      RUN getCharField IN wgbosc152 (INPUT  "nome-abrev":U,
                                     OUTPUT c-nome-abrev).
      
      RUN getCharField IN wgbosc152 (INPUT  "cod-embalagem":U,
                                     OUTPUT c-cod-embalagem).
      
      RUN getCharField IN wgbosc152 (INPUT  "nr-pedcli":U,
                                     OUTPUT c-nr-pedcli).
      
      RUN getIntField  IN wgbosc152 (INPUT  "num-volume":U,
                                     OUTPUT i-num-volume).
      
      RUN getIntField  IN wgbosc152 (INPUT  "nr-resumo":U,
                                     OUTPUT i-nr-resumo).
      
      RUN getIntField  IN wgbosc152 (INPUT  "cdd-embarq":U,
                                     OUTPUT d-cdd-embarq).
      
      /* busca valores para tt-wm-packing.id-tarefa e  tt-wm-packing.num-seq-volume  */
      RUN getInfTarefaVolumePacking IN wgbosc152 (INPUT i-etiqueta-packing,
                                                  OUTPUT vid-tarefa,
                                                  OUTPUT vnum-seq-volume).
      /* busca valor para tt-itens.qtd-peso */        
      RUN openQueryStatic IN wgbosc044 (INPUT "Main":U).
      RUN gotokey IN wgbosc044 (INPUT vcod-item ).
      RUN getDecField IN wgbosc044 (INPUT "qtd-peso",
                                    OUTPUT vpeso-item).
      
      /* busca valor para tt-itens.dt-validade-lote */
      RUN OpenQueryMain IN wgbosc058.
      RUN goToKeySemReferLote IN wgbosc058 (INPUT c-cod-estabel,
                                            INPUT c-cod-local,
                                            INPUT vcod-cliente,
                                            INPUT vcod-item).
      RUN getDateField In wgbosc058(INPUT "dt-validade-lote",
                                    OUTPUT vdt-lote).
   
      RUN goToKey IN wgbosc074 (INPUT ttWork.num-serial).
      RUN getIntField IN wgbosc074 (INPUT "ind-sit-agrupador":U,
                                    OUTPUT vind-sit-agrup).
      
      EMPTY TEMP-TABLE tt-etiquetas-packing.
      
      /* agrupador / agrupador proprio */
      /* Busca etiquetas filhas da etiqueta agrupadora*/
      IF vind-sit-agrup >= 2 THEN DO:
         RUN getInfoAgrupador IN wgbosc074 (INPUT ttWork.num-serial,
                                            OUTPUT TABLE tt-etiquetas-packing).
      END.
      
      EMPTY TEMP-TABLE tt-wm-packing.
      EMPTY TEMP-TABLE tt-itens.
      
      CREATE tt-wm-packing.
      ASSIGN tt-wm-packing.cod-estabel     = c-cod-estabel
             tt-wm-packing.cod-local       = c-cod-local
             tt-wm-packing.cdd-embarq      = d-cdd-embarq
             tt-wm-packing.nr-resumo       = i-nr-resumo
             tt-wm-packing.nr-pedcli       = c-nr-pedcli
             tt-wm-packing.nome-abrev      = c-nome-abrev
             tt-wm-packing.num-seq-volume  = vnum-seq-volume
             tt-wm-packing.cod-volume      = c-cod-embalagem
             tt-wm-packing.num-volume      = i-num-volume
             tt-wm-packing.id-docto        = ttWm-box-movto-idx-picking.id-docto
             tt-wm-packing.id-tarefa       = vid-tarefa
             tt-wm-packing.alteracao       = NO
             tt-wm-packing.id-packing      = i-etiqueta-packing
             tt-wm-packing.encerra-packing = YES . /* IF vsit-docto = 2 THEN YES ELSE NO.  encerra packing no ultimo picking */
       
      /* Se a etiqueta for nao agrupadora, cria tt-itens com um unico registro, da etiqueta do item lido. */
      IF NOT CAN-FIND(FIRST tt-etiquetas-packing) THEN DO:  /* nao agrupadora */
         CREATE tt-itens.
         ASSIGN tt-itens.cod-estabel       = c-cod-estabel
                tt-itens.cod-local         = c-cod-local
                tt-itens.id-docto          = ttWm-box-movto-idx-picking.id-docto
                tt-itens.cdd-embarq        = d-cdd-embarq
                tt-itens.nr-resumo         = i-nr-resumo
                tt-itens.nr-pedcli         = c-nr-pedcli
                tt-itens.nome-abrev        = c-nome-abrev
                tt-itens.cod-volume        = c-cod-embalagem
                tt-itens.num-volume        = i-num-volume
                tt-itens.cod-item          = vcod-item
                tt-itens.cod-lote          = ttWm-box-movto-idx-picking.cod-lote
                tt-itens.cod-refer         = ttWm-box-movto-idx-picking.cod-refer
                tt-itens.cod-embalagem     = c-cod-embalagem
                tt-itens.dt-validade-lote  = vdt-lote
                tt-itens.num-seq-item      = ?
                tt-itens.id-etiqueta       = ttWork.num-serial
                tt-itens.qtd-item-retirada = d-qtd-retirada.
                           
         /* Se for leitura por serial */
         IF ttWork.num-serial <> 0 THEN 
            ASSIGN tt-itens.qtd-item       = vNumItensSerial
                   tt-itens.qtd-peso       = vNumItensSerial * vpeso-item
                   tt-itens.qti-embalagem  = ttWm-box-movto-idx-picking.qti-embalagem.
         ELSE
            ASSIGN tt-itens.qtd-item       = ttwork.qtd-item-digit
                   tt-itens.qtd-peso       = ttwork.qtd-item-digit * vpeso-item
                   tt-itens.qti-embalagem  = ttWm-box-movto-idx-picking.qti-embalagem.
      END.
      ELSE DO: /* Se a etiqueta for agrupadora, cria tt-itens com as etiquetas filhas da etiqueta agrupadora */
         /* faz o packing com base nas etiquetas filhas da agrupadora */
         FOR EACH tt-etiquetas-packing:
            CREATE tt-itens.
            ASSIGN tt-itens.cod-estabel       = c-cod-estabel
                   tt-itens.cod-local         = c-cod-local
                   tt-itens.id-docto          = ttWm-box-movto-idx-picking.id-docto
                   tt-itens.cdd-embarq        = d-cdd-embarq
                   tt-itens.nr-resumo         = i-nr-resumo
                   tt-itens.nr-pedcli         = c-nr-pedcli
                   tt-itens.nome-abrev        = c-nome-abrev
                   tt-itens.cod-volume        = c-cod-embalagem
                   tt-itens.num-volume        = i-num-volume
                   tt-itens.cod-item          = vcod-item
                   tt-itens.cod-lote          = ttWm-box-movto-idx-picking.cod-lote
                   tt-itens.cod-refer         = ttWm-box-movto-idx-picking.cod-refer
                   tt-itens.cod-embalagem     = c-cod-embalagem
                   tt-itens.dt-validade-lote  = vdt-lote
                   tt-itens.num-seq-item      = ?
                   tt-itens.id-etiqueta       = tt-etiquetas-packing.id-etiqueta
                   tt-itens.qtd-item          = tt-etiquetas-packing.qtd-item - tt-etiquetas-packing.qtd-item-retirado
                   tt-itens.qtd-peso          = tt-itens.qtd-item * vpeso-item
                   tt-itens.qti-embalagem     = 1
                   tt-itens.qtd-item-retirada = d-qtd-retirada.
         END.
      END.
      
      ASSIGN d-qtd-retirada = 0.
      
      RUN wmp/wm9070.p (INPUT TABLE tt-wm-packing,
                        INPUT TABLE tt-itens,
                        INPUT ttWork.cod-usuario,
                        INPUT ttWork.cod-coletor,
                        INPUT ttWork.cod-equipamento,
                        INPUT NO,
                        OUTPUT TABLE RowErrors). 
      
      FIND FIRST RowErrors NO-LOCK NO-ERROR.
      IF RETURN-VALUE <> 'OK':U OR AVAILABLE RowErrors THEN DO:
         FOR EACH RowErrors:             
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = 8
                   tt-erro.cd-erro  = ErrorNumber
                   tt-erro.mensagem = ErrorDescription.
         END.
      
         FIND FIRST tt-erro NO-ERROR.      
         IF AVAIL tt-erro THEN DO:          
            FOR EACH tt-erro:
                ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(DC)":U.
            
               DO ON ENDKEY UNDO,RETRY:
                  {bcp/bc9015.i2 string(tt-erro.cd-erro) string(tt-erro.mensagem)}
               END.            
            END.         
         END.      
         UNDO bc9033, RETURN 'NOK':U.      
      END. 
    
      /* Processo concluido com sucesso */
      RETURN 'OK':U.
   END.
END PROCEDURE.

/* Limpa os caracteres nao-numericos do equipamento */
PROCEDURE RetiraString :
   DEFINE INPUT-OUTPUT   PARAMETER pcEtiqueta AS CHARACTER  NO-UNDO.
   
   DEFINE VARIABLE iCont AS INTEGER    NO-UNDO.
   DEFINE VARIABLE caux  AS CHARACTER  NO-UNDO.
   
   DO iCont = 1 TO LENGTH(cEtiqueta).
      IF INDEX("0123456789", SUBSTRING(pcEtiqueta,iCont,1)) > 0 THEN DO:
         ASSIGN caux = caux + SUBSTRING(pcEtiqueta,iCont,1).
      END.
   END.
   ASSIGN pcEtiqueta = STRING(DECIMAL(caux)).
        
END PROCEDURE.

/* Verifica tipo de visualiza‡Æo*/
PROCEDURE pi-getIndTipoVisualiza:
   /* Busca o parametro da bc-param-ext conforme o tipo de endereco (BC9018h.i) */
   RUN pi-getValorParametro (INPUT ttWm-box-movto-idx-picking.cod-item,
                             INPUT "wmsai009":U,
                             INPUT "DISP-QTDE":U,
                             OUTPUT iIndTipoVisualiza).
   
   /* Se nÆo achar o parametro, assume o valor 2 */
   IF iIndTipoVisualiza = 0 THEN DO:
      {bcp/bc9105.i "104" "Parametros nao foram inicializados (DC)"}
      ASSIGN iIndTipoVisualiza = 2.
   END.
   
   /* Caso o parametro seja informado incorretamente, informa ao usuario */
   IF iIndTipoVisualiza <> 2 AND iIndTipoVisualiza <> 4 THEN DO:
      {bcp/bc9105.i "104" "Valor do parametro incorreto para o item/familia/transacao (DDDDDDC)"}
      ASSIGN iIndTipoVisualiza = 2.
   END.
END PROCEDURE.

/* Inicializa Handles utilizados no programa */
PROCEDURE InitHandles:
   IF NOT VALID-HANDLE(wgbosc030) THEN DO:
      RUN scbo/bosc030.p PERSISTENT SET wgbosc030 NO-ERROR.
      RUN openQueryStatic IN wgbosc030 (INPUT "Main":U) NO-ERROR.
   END.

   IF NOT VALID-HANDLE(wgbosc032) THEN DO:
      RUN scbo/bosc032.p PERSISTENT SET wgbosc032 NO-ERROR.
      RUN openQueryStatic IN wgbosc032 (INPUT "Main":U) NO-ERROR.
   END.

   IF NOT VALID-HANDLE(wgbosc038) THEN DO:
      RUN scbo/bosc038.p PERSISTENT SET wgbosc038 NO-ERROR.
      RUN openQueryStatic IN wgbosc038 (INPUT "Main":U) NO-ERROR.
   END.

   IF NOT VALID-HANDLE(wgbosc044) THEN DO:
      RUN scbo/bosc044.p PERSISTENT SET wgbosc044 NO-ERROR.
      RUN openQueryStatic IN wgbosc044 (INPUT "Main":U) NO-ERROR.
   END.

   IF NOT VALID-HANDLE(wgbosc058) THEN
      RUN scbo/bosc058.p PERSISTENT SET wgbosc058 NO-ERROR.
   
   IF NOT VALID-HANDLE(wgbosc074) THEN DO:
      RUN scbo/bosc074.p PERSISTENT SET wgbosc074 NO-ERROR.
      RUN openQueryStatic IN wgbosc074 (INPUT "Main":U) NO-ERROR.
   END.

   IF NOT VALID-HANDLE(wgbosc096) THEN DO:
      RUN scbo/bosc096.p PERSISTENT SET wgbosc096 NO-ERROR.
      RUN openQueryStatic IN wgbosc096 (INPUT "Main":U) NO-ERROR.
   END.
    
   IF NOT VALID-HANDLE(wgbosc145) THEN DO:
      RUN scbo/bosc145.p PERSISTENT SET wgbosc145 NO-ERROR.
      RUN openQueryStatic IN wgbosc145 (INPUT "Main":U) NO-ERROR.
   END.

   IF NOT VALID-HANDLE(wgbosc152) THEN DO:
      RUN scbo/bosc152.p PERSISTENT SET wgbosc152 NO-ERROR.
      RUN openQueryStatic IN wgbosc152 (INPUT "Main":U) NO-ERROR.
   END.
   
   IF NOT VALID-HANDLE(wgbc9033f) THEN DO:
      RUN bcp/bc9033f.p PERSISTENT SET wgbc9033f NO-ERROR.
   END.      
END PROCEDURE.
/*************************************  Codigo do Usuario Fim   ********************************/
