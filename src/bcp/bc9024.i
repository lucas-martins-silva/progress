/********************************************************************************
** Copyright DATASUL S.A. (2002)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/********************************************************************************************
**   Programa..: bc9024.i                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - novembro/2002 - karla Klemke - Cria‡Æo do programa          **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Invent rio WMS                   **
**                                                                                         **
********************************************************************************************/          
{utp/ut-glob.i}

DEF NEW GLOBAL SHARED VAR v_cod_estab_usuar           LIKE estabelec.cod-estabel  LABEL 'emsuni.estabelecimento'      COLUMN-LABEL 'Estab'            NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v_cod_idiom_usuar           AS CHARACTER FORMAT 'x(8)'  LABEL 'emsuni.idioma'               COLUMN-LABEL 'emsuni.idioma'    NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v_cod_pais_empres_usuar     AS CHARACTER FORMAT 'x(3)'  LABEL 'Pa¡s emsuni.empresa Usu rio' COLUMN-LABEL 'Pa¡s'             NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren_criptog  AS CHARACTER FORMAT 'x(16)'                                                                     NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v2_cod_usuar_corren         AS CHARACTER FORMAT 'x(12)' LABEL 'Usu rio Corrente'            COLUMN-LABEL 'Usu rio Corrente' NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v2_cod_empres_usuar         AS CHARACTER FORMAT 'x(3)'  LABEL 'emsuni.empresa'              COLUMN-LABEL 'emsuni.empresa'   NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v2_cod_estab_usuar          LIKE estabelec.cod-estabel  LABEL 'emsuni.estabelecimento'      COLUMN-LABEL 'Estab'            NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v2_cod_idiom_usuar          AS CHARACTER FORMAT 'x(8)'  LABEL 'emsuni.idioma'               COLUMN-LABEL 'emsuni.idioma'    NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v2_cod_pais_empres_usuar    AS CHARACTER FORMAT 'x(3)'  LABEL 'Pa¡s emsuni.empresa Usu rio' COLUMN-LABEL 'Pa¡s'             NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v2_cod_usuar_corren_criptog AS CHARACTER FORMAT 'x(16)'                                                                     NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v2_cod_grp_usuar_lst        AS CHARACTER LABEL 'Grupo Usu rios' COLUMN-LABEL 'Grupo'                                        NO-UNDO. 

DEF VAR vcod-senha         AS CHARACTER FORMAT 'x(18)':U NO-UNDO.
DEF VAR wgbosc044          AS WIDGET-HANDLE              NO-UNDO.
DEF VAR wgbosc051          AS WIDGET-HANDLE              NO-UNDO.
DEF VAR wgbosc058          AS WIDGET-HANDLE              NO-UNDO.
DEF VAR wgbosc074          AS WIDGET-HANDLE              NO-UNDO.
DEF VAR wgbosc079          AS WIDGET-HANDLE              NO-UNDO.
DEF VAR wgbosc117          AS WIDGET-HANDLE              NO-UNDO.
DEF VAR wgbosc118          AS WIDGET-HANDLE              NO-UNDO.
DEF VAR wgbosc119          AS WIDGET-HANDLE              NO-UNDO.
DEF VAR wgbosc120          AS WIDGET-HANDLE              NO-UNDO.
DEF VAR wgbosc130          AS WIDGET-HANDLE              NO-UNDO.
DEF VAR wgbosc030          AS WIDGET-HANDLE              NO-UNDO.
DEF VAR wgbocl031          AS WIDGET-HANDLE              NO-UNDO.
DEF VAR wgbcapi001         AS WIDGET-HANDLE              NO-UNDO.
DEF VAR wgbc9024j          AS WIDGET-HANDLE              NO-UNDO.
DEF VAR vLogUtilizaColetor AS LOGICAL   INIT NO          NO-UNDO.
DEF VAR vLogAprovaFatura   AS LOGICAL   INIT NO          NO-UNDO.
DEF VAR vCodBloco          AS CHARACTER FORMAT "X(03)":U NO-UNDO.
DEF VAR vCodRua            AS CHARACTER FORMAT "X(03)":U NO-UNDO.
DEF VAR vCodNivel          AS CHARACTER FORMAT "X(03)":U NO-UNDO.
DEF VAR vCodColuna         AS CHARACTER FORMAT "X(03)":U NO-UNDO.
DEF VAR vLado              AS CHARACTER FORMAT "X(01)":U NO-UNDO.
DEF VAR vDesEndereco       AS CHARACTER FORMAT "X(17)":U NO-UNDO.
DEF VAR vLogOk             AS LOGICAL                    NO-UNDO.
DEF VAR vcontrol           AS LOGICAL                    NO-UNDO.
DEF VAR vLogControlaLogin  AS LOGICAL   INIT NO          NO-UNDO.

DEFINE TEMP-TABLE tt-inventario-wms NO-UNDO
            FIELD num-sequencia       AS INTEGER      FORMAT '>>>>>>>>>>>>>9':U                LABEL 'Sequˆncia'
            FIELD cod-usuario         AS CHARACTER    FORMAT 'x(25)':U                         LABEL 'Usuario' 
            FIELD cod-estabel         LIKE estabelec.cod-estabel                               LABEL 'Estabel' 
            FIELD cod-local           AS CHARACTER    FORMAT 'x(03)':U                         LABEL 'Local' 
            FIELD dat-inventario      AS DATE         FORMAT '99/99/9999'                      LABEL 'Data Invent tio'
            FIELD num-seq-invent      AS INTEGER      FORMAT '>>>>>9':U                        LABEL 'Sequencia Inventario'
            FIELD num-contagem        AS INTEGER      FORMAT '>9':U                            LABEL 'Contagem'
            FIELD num-box             AS INTEGER      FORMAT '>>>>>>>9':U                      LABEL 'Box'           
            FIELD log-existe-end      AS LOGICAL      FORMAT 'yes/no':U                        LABEL 'Existe End?'           
            FIELD num-serial          AS DECIMAL      FORMAT '>>>>>>>>>>>>>>':U                LABEL 'Serial'
            FIELD qtd-item            AS DECIMAL      FORMAT '>>>,>>>,>>9.9999':U              LABEL 'Qtd Item'            
            FIELD cod-item            AS CHARACTER    FORMAT 'x(16)':U                         LABEL 'Item'            
            FIELD ind-tipo-contr-est  AS INTEGER      FORMAT '>9':U                            LABEL 'Tipo Controle Item'
            FIELD cod-lote            AS CHARACTER    FORMAT 'x(40)':U                         LABEL 'Lote'      
            FIELD cod-embalagem       AS CHARACTER    FORMAT 'x(10)':u                         LABEL 'Embalagem'
            FIELD cod-Refer           AS CHARACTER    FORMAT 'x(08)':U                         LABEL 'Referencia' 
            FIELD dat-validade        AS DATE         FORMAT '99/99/9999':U                    LABEL 'Validade'
            FIELD qtd-peso            AS DECIMAL      FORMAT '>>>,>>>,>>9.9999':U              LABEL 'Qtd Peso'            
            FIELD qtd-caixas          AS DECIMAL      FORMAT '>>>>>9.999':U                    LABEL 'Qtd Caixas'            
            FIELD ind-transacao       AS INTEGER      FORMAT '99':U                            LABEL 'ind transacao'            
            FIELD cod-livre-1         AS CHARACTER    FORMAT 'x(40)':U                         LABEL 'Cod Livre 1'
            FIELD cod-livre-2         AS CHARACTER    FORMAT 'x(40)':U                         LABEL 'Cod Livre 2'
            FIELD cod-livre-3         AS CHARACTER    FORMAT 'x(40)':U                         LABEL 'Cod Livre 3'
            FIELD cod-livre-4         AS CHARACTER    FORMAT 'x(40)':U                         LABEL 'Cod Livre 4'
            FIELD cod-livre-5         AS CHARACTER    FORMAT 'x(40)':U                         LABEL 'Cod Livre 5'
            FIELD num-livre-1         AS INTEGER      FORMAT '>>>>>>>9':U                      LABEL 'Num Livre 1'
            FIELD num-livre-2         AS INTEGER      FORMAT '>>>>>>>9':U                      LABEL 'Num Livre 2'     
            FIELD num-livre-3         AS INTEGER      FORMAT '>>>>>>>9':U                      LABEL 'Num Livre 3'
            FIELD num-livre-4         AS INTEGER      FORMAT '>>>>>>>9':U                      LABEL 'Num Livre 4'
            FIELD num-livre-5         AS INTEGER      FORMAT '>>>>>>>9':U                      LABEL 'Num Livre 5'
            FIELD dec-livre-1         AS DECIMAL      FORMAT '>>>>>>9.9999':U     DECIMALS 4   LABEL 'Dec Livre 1'
            FIELD dec-livre-2         AS DECIMAL      FORMAT '>>>>>>9.9999':U     DECIMALS 4   LABEL 'Dec Livre 2'
            FIELD dec-livre-3         AS DECIMAL      FORMAT '>>>>>>9.9999':U     DECIMALS 4   LABEL 'Dec Livre 3'
            FIELD dec-livre-4         AS DECIMAL      FORMAT '>>>>>>9.9999':U     DECIMALS 4   LABEL 'Dec Livre 4'
            FIELD dec-livre-5         AS DECIMAL      FORMAT '>>>>>>9.9999':U     DECIMALS 4   LABEL 'Dec Livre 5'
            FIELD log-livre-1         AS LOGICAL      FORMAT 'Sim/NÆo'                         LABEL 'Log Livre 1'
            FIELD log-livre-2         AS LOGICAL      FORMAT 'Sim/NÆo'                         LABEL 'Log Livre 2'
            FIELD log-livre-3         AS LOGICAL      FORMAT 'Sim/NÆo'                         LABEL 'Log Livre 3'
            FIELD log-livre-4         AS LOGICAL      FORMAT 'Sim/NÆo'                         LABEL 'Log Livre 4'
            FIELD log-livre-5         AS LOGICAL      FORMAT 'Sim/NÆo'                         LABEL 'Log Livre 5'
            FIELD dat-livre-1         AS DATE         FORMAT '99/99/9999'                      LABEL 'DataLivre 1'
            FIELD dat-livre-2         AS DATE         FORMAT '99/99/9999'                      LABEL 'DataLivre 2'
            FIELD dat-livre-3         AS DATE         FORMAT '99/99/9999'                      LABEL 'DataLivre 3'
            FIELD dat-livre-4         AS DATE         FORMAT '99/99/9999'                      LABEL 'DataLivre 4'
            FIELD dat-livre-5         AS DATE         FORMAT '99/99/9999'                      LABEL 'DataLivre 5'         
            INDEX ID  IS PRIMARY num-box 
                                 num-serial
                                 cod-item 
                                 cod-refer 
                                 cod-lote
                                 cod-embalagem.    

DEFINE TEMP-TABLE tt-inventario-wms-bkp NO-UNDO LIKE tt-inventario-wms
            FIELD nr-trans              AS DECIMAL  FORMAT 'zzzzzzzzz9':U LABEL 'Transa‡Æo'
            INDEX id-seq num-sequencia.

DEFINE TEMP-TABLE RowErrors NO-UNDO 
            FIELD ErrorSequence    AS INTEGER 
            FIELD ErrorNumber      AS INTEGER 
            FIELD ErrorDescription AS CHARACTER 
            FIELD ErrorParameters  AS CHARACTER 
            FIELD ErrorType        AS CHARACTER 
            FIELD ErrorHelp        AS CHARACTER 
            FIELD ErrorSubType     AS CHARACTER.
