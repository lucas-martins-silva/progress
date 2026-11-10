/********************************************************************************************
**   Include...: bc9025.i                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000                                                               **
**                                                                                         **
**   Objetivo..: Armazenar os dados para transacao de Transferencia WMS                    **
**                                                                                         **
********************************************************************************************/

{cdp/cdcfgmat.i} 

Define {1} Temp-Table tt-transf-wms
    Field cod-usuario               As Character    Format 'x(25)':U                                    Label 'Usuario' 
    Field cod-coletor               As Character    Format 'x(14)':U                                    Label 'Coletor' 
    Field cod-estabel               As Character    Format 'x(03)':U                                    Label 'Estabel' 
    Field cod-local                 As Character    Format 'x(05)':U                                    Label 'Local' 
    Field des-endereco              As Character    Format 'x(16)':U                                    Label 'Endereco'
    Field num-seq-item              As Integer      Format '>>>>9':U                                    Label 'Sequencia'
    Field id-docto                  As Decimal      Format '>>>>>>>>>9':U                               Label 'Documento' 
    Field cod-equipamento           As Character    Format 'x(14)':U                                    Label 'Equipamento' 
    Field cod-item                  As Character    Format 'x(16)':U                                    Label 'Item'            
    Field qtd-item                  As Decimal      Format '>>>>>9.999':U                               Label 'Qtd Item'            
    Field cod-lote                  As Character    Format 'x(10)':U                                    Label 'Lote'      
    Field cod-refer                 As Character    Format 'x(10)':U                                    Label 'Referencia' 
    Field qtd-item-retirado         As Decimal      Format '>>>,>>>,>>9.9999':U                         Label 'Qtd Item Retirado'            
    Field num-box-orig              As Decimal      Format '>>>>>>>>>9':U                               Label 'Box Origem'
    Field cod-embalagem             As Character    Format 'x(10)':U                                    Label 'Embalagem'
    Field num-serial                As Decimal      Format '>>>>>>>>>>>>>>':U                           Label 'Serial Lido'
    Field dat-transacao             As Date         Format '99/99/9999'                                 Label 'Transacao'
    FIELD ind-tip-movto             AS INTEGER
    Field cod-cliente               As INTEGER      Format '999999999':U                                Label 'Cod Cliente'
    Field cod-livre-1               As Character    Format 'x(40)':U                                    Label 'Cod Livre 1'
    Field cod-livre-2               As Character    Format 'x(40)':U                                    Label 'Cod Livre 2'
    Field cod-livre-3               As Character    Format 'x(40)':U                                    Label 'Cod Livre 3'
    Field cod-livre-4               As Character    Format 'x(40)':U                                    Label 'Cod Livre 4'
    Field cod-livre-5               As Character    Format 'x(40)':U                                    Label 'Cod Livre 5'
    Field num-livre-1               As Integer      Format '>>>>>>>9':U                                 Label 'Num Livre 1'
    Field num-livre-2               As Integer      Format '>>>>>>>9':U                                 Label 'Num Livre 2'     
    Field num-livre-3               As Integer      Format '>>>>>>>9':U                                 Label 'Num Livre 3'
    Field num-livre-4               As Integer      Format '>>>>>>>9':U                                 Label 'Num Livre 4'
    Field num-livre-5               As Integer      Format '>>>>>>>9':U                                 Label 'Num Livre 5'
    Field dec-livre-1               As Decimal      Format '>>>>>>9.9999':U     Decimals 4              Label 'Dec Livre 1'
    Field dec-livre-2               As Decimal      Format '>>>>>>9.9999':U     Decimals 4              Label 'Dec Livre 2'
    Field dec-livre-3               As Decimal      Format '>>>>>>9.9999':U     Decimals 4              Label 'Dec Livre 3'
    Field dec-livre-4               As Decimal      Format '>>>>>>9.9999':U     Decimals 4              Label 'Dec Livre 4'
    Field dec-livre-5               As Decimal      Format '>>>>>>9.9999':U     Decimals 4              Label 'Dec Livre 5'
    Field log-livre-1               As Logical      Format 'Sim/NÆo'                                    Label 'Log Livre 1'
    Field log-livre-2               As Logical      Format 'Sim/NÆo'                                    Label 'Log Livre 2'
    Field log-livre-3               As Logical      Format 'Sim/NÆo'                                    Label 'Log Livre 3'
    Field log-livre-4               As Logical      Format 'Sim/NÆo'                                    Label 'Log Livre 4'
    Field log-livre-5               As Logical      Format 'Sim/NÆo'                                    Label 'Log Livre 5'
    Field dat-livre-1               As Date         Format '99/99/9999'                                 Label 'DataLivre 1'
    Field dat-livre-2               As Date         Format '99/99/9999'                                 Label 'DataLivre 2'
    Field dat-livre-3               As Date         Format '99/99/9999'                                 Label 'DataLivre 3'
    Field dat-livre-4               As Date         Format '99/99/9999'                                 Label 'DataLivre 4'
    Field dat-livre-5               As Date         Format '99/99/9999'                                 Label 'DataLivre 5'
    field qti-embalagem             as integer                                                          label 'Quantidade Embalagem'
    index ID  is primary num-serial
    INDEX idx-tip-movto ind-tip-movto.

/*******************************************************************************/
DEF TEMP-TABLE ttResumoItem /* Temp-table que recebe o retorno do m‚togo getOcupacaoItem da bosc035*/
         FIELD id-box           LIKE  wm-box-saldo.id-box
         FIELD dt-transacao     LIKE  wm-box-saldo.dt-transacao
         FIELD ind-status-box   LIKE  wm-box-saldo.ind-status-box
         FIELD ind-status-saldo LIKE  wm-box-saldo.ind-status-saldo
         FIELD cod-embalagem    LIKE  wm-box-saldo.cod-embalagem
         FIELD qtd-original     LIKE  wm-box-saldo.qtd-original
         FIELD qtd-item         LIKE  wm-box-saldo.qtd-item
         FIELD qtd-item-bloq    LIKE  wm-box-saldo.qtd-item-bloq
         FIELD qti-embalagem    LIKE  wm-box-movto.qti-embalagem
         FIELD RowNum           AS INTEGER
         FIELD r-RowId          AS ROWID
         INDEX w-res01 IS UNIQUE id-box   
                                 dt-transacao   
                                 cod-embalagem 
                                 qtd-original 
                                 qtd-item
                                 qtd-item-bloq
                                 ind-status-saldo.

/* Retorno do metodo getOcupacaoBox da bosc035 */
DEF TEMP-TABLE ttResumo
         FIELD cod-estabel      LIKE  wm-box-saldo.cod-estabel
         FIELD cod-local        LIKE  wm-box-saldo.cod-local
         FIELD cod-item         LIKE  wm-box-saldo.cod-item
         FIELD cod-refer        LIKE  wm-box-saldo.cod-refer
         FIELD cod-lote         LIKE  wm-box-saldo.cod-lote
         FIELD dt-transacao     LIKE  wm-box-saldo.dt-transacao
         FIELD dt-validade-lote LIKE  wm-saldo-estoque.dt-validade-lote
         FIELD ind-status-box   LIKE  wm-box-saldo.ind-status-box
         FIELD ind-status-saldo LIKE  wm-box-saldo.ind-status-saldo
         FIELD cod-embalagem    LIKE  wm-box-saldo.cod-embalagem
         FIELD qtd-original     LIKE  wm-box-saldo.qtd-original
         FIELD qtd-item         LIKE  wm-box-saldo.qtd-item
         FIELD qtd-item-bloq    LIKE  wm-box-saldo.qtd-item-bloq
         FIELD qti-embalagem    LIKE  wm-box-movto.qti-embalagem
         FIELD cod-cliente      LIKE  wm-box-saldo.cod-cliente
         &IF '{&bf_lote_avancado_liberado}' = 'yes' &THEN
            FIELD log-bloq-movto-cq LIKE wm-box-saldo.log-bloq-movto-cq
            FIELD desc-lote-estado  AS CHARACTER FORMAT "x(20)"
         &ENDIF
         FIELD RowNum           AS INTEGER
         FIELD r-RowId          AS ROWID
         INDEX w-res01 IS UNIQUE  cod-item
                                  cod-refer
                                  cod-lote
                                  dt-transacao   
                                  cod-embalagem 
                                  qtd-original 
                                  qtd-item
                                  qtd-item-bloq
                                  ind-status-saldo.

define temp-table ttEmbSelec 
    field cChave as char
    field cNumEmbal as char
    index idItmEmb is unique cChave.
