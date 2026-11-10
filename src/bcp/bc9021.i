/********************************************************************************************
**   Include...: bc9021.i                                                                 **
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

DEFINE TEMP-TABLE tt-devolve-picking NO-UNDO
            FIELD cod-usuario               AS CHARACTER    FORMAT 'x(25)':U                        LABEL 'Usuario' 
            FIELD cod-coletor               AS CHARACTER    FORMAT 'x(14)':U                        LABEL 'Coletor' 
            FIELD cod-equipamento           AS CHARACTER    FORMAT 'x(14)':U                        LABEL 'Equipamento' 
            FIELD num-documento             AS CHARACTER    FORMAT 'x(16)':U                        LABEL 'Documento Sa¡da' 
            FIELD cod-estabel               LIKE estabelec.cod-estabel                              LABEL 'Estabelecimento'
            FIELD cod-local                 AS CHARACTER    FORMAT 'x(03)':U                        LABEL 'Local'
            FIELD cdd-embarq                AS DECIMAL      FORMAT '>>>>>>>>>>>>>>>9':U             LABEL 'Embarque'
            FIELD serie                     AS CHARACTER    FORMAT 'x(5)':U                         LABEL 'S‚rie'
            FIELD id-docto                  AS DECIMAL      FORMAT '>>>>>>>>>9':U                   LABEL 'Id Docto'
            FIELD num-docto-origem          AS DECIMAL      FORMAT '>>>>>>>>>9':U                   LABEL 'Docto Origem'
            FIELD ind-tipo-trans            AS INTEGER      FORMAT '>9':U                           LABEL 'Tipo Transa‡Æo'
            FIELD ind-origem-docto          AS INTEGER      FORMAT '>9':U                           LABEL 'Origem Docto'
            FIELD id-carga                  AS DEC          FORMAT '>>>>>>>>>>>>>9':U               LABEL 'ID Carga'
            FIELD alteracao                 AS LOG                                                  LABEL 'Altera‡Æo?'
            FIELD cod-depos                 AS CHAR         FORMAT 'X(3)':U                         LABEL 'Dep¢sito'
            FIELD dat-atualizacao           AS DATE         FORMAT '99/99/9999'                     LABEL 'Atualizacao'
            FIELD dat-transacao             AS DATE         FORMAT '99/99/9999'                     LABEL 'Transacao'
            FIELD num-seq-item              AS INTEGER      FORMAT '>>>>>9':U                       LABEL 'Sequˆncia'
            FIELD num-serial                AS DECIMAL      FORMAT '>>>>>>>>>>>>>9':U               LABEL 'Serial'
            FIELD cod-item                  AS CHARACTER    FORMAT 'x(16)':U                        LABEL 'Item'  
            FIELD qtd-item                  AS DECIMAL      FORMAT '>>>,>>>,>>9.9999':U             LABEL 'Qtd Item'            
            FIELD cod-lote                  AS CHARACTER    FORMAT 'x(40)':U                        LABEL 'Lote'      
            FIELD cod-refer                 AS CHARACTER    FORMAT 'x(08)':U                        LABEL 'Referˆncia'
            FIELD dat-validade              AS DATE         FORMAT '99/99/9999':U                   LABEL 'Data Validade'
            FIELD nr-resumo                 AS INTEGER      FORMAT '>>>>,>>9':u                     LABEL 'Resumo'
            FIELD ind-tipo-contr-est        AS INTEGER      FORMAT '>9':U                           LABEL 'Tipo Controle Item'
            FIELD nr-pedcli                 AS CHARACTER    FORMAT 'X(12)':U                        LABEL 'Pedido Cliente'
            FIELD nome-abrev                AS CHARACTER    FORMAT 'x(12)':U                        LABEL 'Cliente'
            FIELD num-seq-item-ped          AS INTEGER      FORMAT '>>>>>9':U                       LABEL 'Sequencia Pedido'
            FIELD cod-livre-1               AS CHARACTER    FORMAT 'x(40)':U                        LABEL 'Cod Livre 1'
            FIELD cod-livre-2               AS CHARACTER    FORMAT 'x(40)':U                        LABEL 'Cod Livre 2'
            FIELD cod-livre-3               AS CHARACTER    FORMAT 'x(40)':U                        LABEL 'Cod Livre 3'
            FIELD num-livre-1               AS INTEGER      FORMAT '>>>>>>>9':U                     LABEL 'Num Livre 1'
            FIELD num-livre-2               AS INTEGER      FORMAT '>>>>>>>9':U                     LABEL 'Num Livre 2'     
            FIELD num-livre-3               AS INTEGER      FORMAT '>>>>>>>9':U                     LABEL 'Num Livre 3'
            FIELD dec-livre-1               AS DECIMAL      FORMAT '>>>>>>9.9999':U     DECIMALS 4  LABEL 'Dec Livre 1'
            FIELD dec-livre-2               AS DECIMAL      FORMAT '>>>>>>9.9999':U     DECIMALS 4  LABEL 'Dec Livre 2'
            FIELD dec-livre-3               AS DECIMAL      FORMAT '>>>>>>9.9999':U     DECIMALS 4  LABEL 'Dec Livre 3'
            FIELD log-livre-1               AS LOGICAL      FORMAT 'Sim/NÆo'                        LABEL 'Log Livre 1'
            FIELD log-livre-2               AS LOGICAL      FORMAT 'Sim/NÆo'                        LABEL 'Log Livre 2'
            FIELD log-livre-3               AS LOGICAL      FORMAT 'Sim/NÆo'                        LABEL 'Log Livre 3'
            FIELD dat-livre-1               AS DATE         FORMAT '99/99/9999'                     LABEL 'DataLivre 1'
            FIELD dat-livre-2               AS DATE         FORMAT '99/99/9999'                     LABEL 'DataLivre 2'
            FIELD dat-livre-3               AS DATE         FORMAT '99/99/9999'                     LABEL 'DataLivre 3'
            INDEX ID  IS PRIMARY id-docto
                                 num-seq-item 
                                 num-serial
                                 cod-item
                                 cod-refer
                                 cod-lote.    

                                 
DEFINE TEMP-TABLE tt-devolve-picking-bkp NO-UNDO LIKE tt-devolve-picking
            FIELD nr-trans LIKE bc-trans.nr-trans.
                         
    
DEFINE TEMP-TABLE tt-docto-itens-emb NO-UNDO
            FIELD cod-embalagem             LIKE wm-box-saldo.cod-embalagem         
            FIELD qtd-item-emb              LIKE wm-box-saldo.qtd-item    
            FIELD qti-embalagem             LIKE wm-box-movto.qti-embalagem                            
            FIELD qtd-volume                LIKE wm-item-embalagem.qtd-volume         
            FIELD qtd-peso                  LIKE wm-item-embalagem.qtd-peso.

{utp/ut-glob.i}

DEF NEW GLOBAL SHARED VAR v_cod_estab_usuar            LIKE estabelec.cod-estabel   LABEL 'emsuni.estabelecimento'      COLUMN-LABEL 'Estab'            NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v_cod_idiom_usuar            AS CHARACTER FORMAT 'X(8)'   LABEL 'emsuni.idioma'               COLUMN-LABEL 'emsuni.idioma'    NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v_cod_pais_empres_usuar      AS CHARACTER FORMAT 'x(3)'   LABEL 'Pa¡s emsuni.empresa Usu rio' COLUMN-LABEL 'Pa¡s'             NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren_criptog   AS CHARACTER FORMAT 'x(161)'                                                                     NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v2_cod_usuar_corren          AS CHARACTER FORMAT 'x(121)' LABEL 'Usu rio Corrente'            COLUMN-LABEL 'Usu rio Corrente' NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v2_cod_empres_usuar          AS CHARACTER FORMAT 'x(3)'   LABEL 'emsuni.empresa'              COLUMN-LABEL 'emsuni.empresa'   NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v2_cod_estab_usuar           LIKE estabelec.cod-estabel   LABEL 'emsuni.estabelecimento'      COLUMN-LABEL 'Estab'            NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v2_cod_idiom_usuar           AS CHARACTER FORMAT 'x(8)'   LABEL 'emsuni.idioma'               COLUMN-LABEL 'emsuni.idioma'    NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v2_cod_pais_empres_usuar     AS CHARACTER FORMAT 'x(3)'   LABEL 'Pa¡s emsuni.empresa Usu rio' COLUMN-LABEL 'Pa¡s'             NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v2_cod_usuar_corren_criptog  AS CHARACTER FORMAT 'x(16)'                                                                      NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v2_cod_grp_usuar_lst         AS CHARACTER                 LABEL 'Grupo Usu rios'              COLUMN-LABEL 'Grupo'            NO-UNDO. 

DEFINE VARIABLE vcod-deposito      AS CHARACTER.
DEFINE VARIABLE vcod-senha         AS CHARACTER FORMAT 'x(18)':U          NO-UNDO.
DEFINE VARIABLE vLogUtilizaColetor AS LOGICAL                    INIT NO  NO-UNDO.
DEFINE VARIABLE vLogAprovaFatura   AS LOGICAL                    INIT NO  NO-UNDO.
DEFINE VARIABLE vCodTipoEquip      AS CHARACTER                  INIT ''  NO-UNDO.
DEFINE VARIABLE vLogAtivo          AS LOGICAL                    INIT NO  NO-UNDO.
DEFINE VARIABLE vLogProcesso       AS LOGICAL                    INIT NO  NO-UNDO.
DEFINE VARIABLE vNumDocto          LIKE tt-devolve-picking.num-documento  NO-UNDO.
DEFINE VARIABLE vNumSerial         LIKE wm-etiqueta.id-etiqueta           NO-UNDO.
DEFINE VARIABLE vNrEmbarque        AS INTEGER   FORMAT '>>>>>>9' INIT 0   NO-UNDO.
DEFINE VARIABLE vNrResumo          AS INTEGER                    INIT 0   NO-UNDO.
DEFINE VARIABLE vNrPedCli          AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE vNOmeAbrev         AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE vnom-estabel       AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE vnom-local         AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE wgbosc038          AS WIDGET-HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbosc039          AS WIDGET-HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbosc044          AS WIDGET-HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbosc045          AS WIDGET-HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbosc079          AS WIDGET-HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbosc092          AS WIDGET-HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbosc095          AS WIDGET-HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbosc047          AS WIDGET-HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbosc074f         AS WIDGET-HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbosc074          AS WIDGET-HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbosc099f         AS WIDGET-HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbosc099          AS WIDGET-HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbosc109          AS WIDGET-HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbcapi001         AS WIDGET-HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbc9021f          AS WIDGET-HANDLE                       NO-UNDO.
DEFINE VARIABLE vdetalhe           AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE vusuario           AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE vLogControlaLogin  AS LOGICAL                    INIT NO  NO-UNDO.