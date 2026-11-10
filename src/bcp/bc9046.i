/********************************************************************************************
**   Include...: bc9046.i                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000                                                               **
**                                                                                         **
**   Objetivo..: Armazenar os dados para devolucao de picking WMS                          **
**                                                                                         **
********************************************************************************************/
DEFINE TEMP-TABLE RowErrors NO-UNDO 
            FIELD ErrorSequence    AS INTEGER
            FIELD ErrorNumber      AS INTEGER 
            FIELD ErrorDescription AS CHARACTER 
            FIELD ErrorParameters  AS CHARACTER 
            FIELD ErrorType        AS CHARACTER 
            FIELD ErrorHelp        AS CHARACTER 
            FIELD ErrorSubType     AS CHARACTER.

DEFINE TEMP-TABLE tt-confirma NO-UNDO
            FIELD cod-usuario      AS CHARACTER   LABEL 'Usuario'         FORMAT 'x(25)':U           
            FIELD cod-coletor      AS CHARACTER   LABEL 'Coletor'         FORMAT 'x(14)':U           
            FIELD cod-equipamento  AS CHARACTER   LABEL 'Equipamento'     FORMAT 'x(14)':U           
            FIELD num-documento    AS INTEGER     LABEL 'Documento'       FORMAT '>>>>,>>9':U        
            FIELD cod-estabel      AS CHARACTER   LABEL 'Estabelecimento' FORMAT &if '{&mgscm_version}' >= '2.08' &then 'x(5)' &else 'x(3)' &endif
            FIELD cod-local        AS CHARACTER   LABEL 'Local'           FORMAT 'x(03)':U           
            FIELD id-docto         AS DECIMAL     LABEL 'Id Docto'        FORMAT '>>>>>>>>>9':U      
            FIELD cod-depos        AS CHARACTER   LABEL 'Dep¢sito'        FORMAT 'X(3)':U            
            FIELD num-seq-item     AS INTEGER     LABEL 'Sequˆncia'       FORMAT '>>>>>9':U
            FIELD id-movto         AS DECIMAL     LABEL 'Id Movto'        FORMAT '>>>>>>>>>9':U              
            FIELD num-serial       AS DECIMAL     LABEL 'Serial'          FORMAT '>>>>>>>>>>>>>9':U  
            FIELD cod-item         AS CHARACTER   LABEL 'Item'            FORMAT 'x(16)':U           
            FIELD qtd-item         AS DECIMAL     LABEL 'Qtd Item'        FORMAT '>>>,>>>,>>9.9999':U    
            FIELD cod-lote         AS CHARACTER   LABEL 'Lote'            FORMAT 'x(40)':U           
            FIELD cod-refer        AS CHARACTER   LABEL 'Referˆncia'      FORMAT 'x(08)':U           
            INDEX ID IS PRIMARY id-docto
                                num-seq-item
                                id-movto 
                                num-serial
                                cod-item
                                cod-refer
                                cod-lote.    

DEFINE TEMP-TABLE tt-itens NO-UNDO
            FIELD cod-estabel  LIKE wm-box-movto.cod-estabel
            FIELD cod-local    LIKE wm-box-movto.cod-local
            FIELD id-docto     LIKE wm-box-movto.id-docto
            FIELD num-seq-item LIKE wm-box-movto.num-seq-item
            FIELD cod-item     LIKE item-docto-transf-depos.cod-item COLUMN-LABEL "ITEM"
            FIELD qtd-item     LIKE item-docto-transf-depos.qtd-item COLUMN-LABEL "QTD" FORMAT ">>>,>>>,>>9.99"
            FIELD cod-lote     LIKE item-docto-transf-depos.cod-lote
            FIELD cod-refer    LIKE item-docto-transf-depos.cod-refer
            INDEX idx-docto IS PRIMARY cod-item.


{utp/ut-glob.i}

DEF NEW GLOBAL SHARED VAR v2_cod_usuar_corren AS CHARACTER FORMAT 'x(12)' LABEL 'Usu rio Corrente' COLUMN-LABEL 'Usu rio Corrente' NO-UNDO.

DEF VAR vcod-senha          AS CHARACTER NO-UNDO FORMAT "x(18)" .
DEF VAR vLogControlaLogin   AS LOGICAL   NO-UNDO.
DEF VAR wgbosc079           AS HANDLE    NO-UNDO.
DEF VAR wgBOSC092           AS HANDLE    NO-UNDO.
DEF VAR h-bosc047           AS HANDLE    NO-UNDO.
DEF VAR h-boin084           AS HANDLE    NO-UNDO.
DEF VAR h-bosc070           AS HANDLE    NO-UNDO.
DEF VAR h-bosc172           AS HANDLE    NO-UNDO.
DEF VAR vLogUtilizaColetor  AS LOGICAL   NO-UNDO.
DEF VAR vLogAprovaFatura    AS LOGICAL   NO-UNDO.
DEF VAR vCodTipoEquip       AS LOGICAL   NO-UNDO.
DEF VAR vLogAtivo           AS LOGICAL   NO-UNDO.
DEF VAR vLogProcesso        AS LOGICAL   NO-UNDO.
DEF VAR vNomeUsuario        AS CHARACTER no-undo.

/*******************************************************************************/
