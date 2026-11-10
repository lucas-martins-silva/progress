/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9024k 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9024k MBC}
&ENDIF                                   

{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */

/* Definicao global do nome da transacao */
&global-define ProgramName BC9024

&global-define TempTable tt-inventario-wms
{bcp/bc9024.i }

DEFINE TEMP-TABLE tt-wm-invent-ender NO-UNDO
            FIELD id-etiqueta       LIKE wm-etiqueta.id-etiqueta
            FIELD usuario           LIKE usuario-scm.usuario
            INDEX i-etiq id-etiqueta.

DEFINE QUERY qry-tt-wm-invent-ender FOR tt-wm-invent-ender SCROLLING.  

DEFINE BROWSE brw-tt-wm-invent-ender
        QUERY qry-tt-wm-invent-ender NO-LOCK
   DISPLAY tt-wm-invent-ender.id-etiqueta FORMAT ">>>>99999999999999"
           tt-wm-invent-ender.usuario
     WITH NO-BOX SIZE 20 BY 5 NO-SCROLLBAR-VERTICAL.

DEFINE TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.

DEFINE INPUT PARAMETER TABLE FOR ttWork.

FIND FIRST ttWork NO-ERROR.
 
/* Propriedades globais para frames */  
&global-define ErrorDisplaySeconds 3
&global-define FrameSize    20 By 8

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Etiquetas Coletadas '                             At Row 01 Col 01     ~
                             '--------------------'                             At Row 02 Col 01     ~
                             brw-tt-wm-invent-ender                             At Row 03 Col 01

&global-define Frame01Repeat NO

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields brw-tt-wm-invent-ender

/* definicao da trigger de procedimentos para fechamento do programa */
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. if vLogSai = Yes Then LEAVE _frame01.

&global-define TriggersCloseProgram Run destroy In wgbocl031 No-error.

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ~

/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbocl031
/************************************************************/

/*****************************************   Frames Fim ******************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */ 
/************************************* Codigo do Usuario Inicio ************************************
** Este local ‚ destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:
/*------------------------------------------------------------------------------
  Purpose: Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF RETURN-VALUE = "ESC":U THEN DO:
      ASSIGN vLogSai = YES.
      RETURN.
   END.
   
   ASSIGN vLogErro     = NO
          vLogSai      = NO
          vLogFinaliza = NO.
   
   
   IF NOT VALID-HANDLE(wgbocl031) THEN
      RUN clbo/bocl031.p PERSISTENT SET wgbocl031.
         
   RUN retornarWmInventarioEtiquetaColetadoEnder IN wgbocl031( INPUT ttWork.cod-estabel,   
                                                               INPUT ttWork.cod-local,     
                                                               INPUT ttWork.dat-inventario,
                                                               INPUT ttWork.num-seq-invent,
                                                               INPUT ttWork.num-box,
                                                               INPUT ttWork.num-contagem,
                                                               OUTPUT TABLE tt-wm-invent-ender ).
   
   OPEN QUERY qry-tt-wm-invent-ender FOR EACH tt-wm-invent-ender.
   BROWSE brw-tt-wm-invent-ender:REFRESH() NO-ERROR.
   
   ASSIGN vLogErro     = NO
          vLogSai      = NO
          vLogFinaliza = NO.        
END PROCEDURE.
          