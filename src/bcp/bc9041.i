/*
Criada a variavel "wgBOSC074" para utiliza‡Æo no programa "bc9023.p".
*/
/********************************************************************************
** Copyright DATASUL S.A. (2002)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/********************************************************************************************
**   Programa..: bc9023.i                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - novembro/2002 - karla Klemke - Cria‡Æo do programa          **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Consulta de Endere‡o WMS         **
**                                                                                         **
********************************************************************************************/
      
{cdp/cdcfgmat.i}      
      
DEF TEMP-TABLE ttConsulta NO-UNDO        
         FIELD cod-estabel      LIKE  wm-box-saldo.cod-estabel
         FIELD cod-local        LIKE  wm-box-saldo.cod-local
         FIELD cod-item         LIKE  wm-box-saldo.cod-item
         FIELD cod-refer        AS CHAR /* porque é necessário informar o que é o campo (Rf:) LIKE  wm-box-saldo.cod-refer*/
         FIELD cod-lote         LIKE  wm-box-saldo.cod-lote
         FIELD cod-bloco        LIKE wm-box.cod-bloco
         FIELD cod-rua          LIKE wm-box.cod-rua
         FIELD cod-nivel        LIKE wm-box.cod-nivel
         FIELD cod-coluna       LIKE wm-box.cod-coluna
         FIELD cod-embalagem    LIKE  wm-box-saldo.cod-embalagem
         FIELD qtd-item         LIKE  wm-box-saldo.qtd-item
         FIELD ind-posicao-box  AS CHAR
         FIELD RowNum           AS INTEGER
         FIELD r-RowId          AS ROWID. 

/* Retorno do metodo getOcupacaoBox da bosc035 */
DEF TEMP-TABLE ttResumo NO-UNDO
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

{utp/ut-glob.i}
def new global shared var v_cod_estab_usuar 
    as character 
    format 'x(3)' 
    label 'emsuni.estabelecimento' 
    column-label 'Estab' 
    no-undo. 
def new global shared var v_cod_idiom_usuar 
    as character 
    format 'x(8)' 
    label 'emsuni.idioma' 
    column-label 'emsuni.idioma' 
    no-undo. 
def new global shared var v_cod_pais_empres_usuar 
    as character 
    format 'x(3)' 
    label 'Pa¡s emsuni.empresa Usu rio' 
    column-label 'Pa¡s' 
    no-undo. 
def new global shared var v_cod_usuar_corren_criptog 
    as character 
    format 'x(16)' 
    no-undo. 
def new global shared var v2_cod_usuar_corren 
    as character 
    format 'x(12)' 
    label 'Usu rio Corrente' 
    column-label 'Usu rio Corrente' 
    no-undo. 
def new global shared var v2_cod_empres_usuar 
    as character 
    format 'x(3)' 
    label 'emsuni.empresa' 
    column-label 'emsuni.empresa' 
    no-undo. 
def new global shared var v2_cod_estab_usuar 
    as character 
    format 'x(3)' 
    label 'emsuni.estabelecimento' 
    column-label 'Estab' 
    no-undo. 
def new global shared var v2_cod_idiom_usuar 
    as character 
    format 'x(8)' 
    label 'emsuni.idioma' 
    column-label 'emsuni.idioma' 
    no-undo. 
def new global shared var v2_cod_pais_empres_usuar 
    as character 
    format 'x(3)' 
    label 'Pa¡s emsuni.empresa Usu rio' 
    column-label 'Pa¡s' 
    no-undo. 
def new global shared var v2_cod_usuar_corren_criptog 
    as character 
    format 'x(16)' 
    no-undo. 
def new global shared var v2_cod_grp_usuar_lst  
    as character  
    label 'Grupo Usu rios'  
    column-label 'Grupo'  
    no-undo. 
DEFINE VARIABLE vcod-senha              
    AS CHARACTER FORMAT 'x(14)':U  NO-UNDO.
DEFINE VARIABLE wgbosc079             
    AS WIDGET-HANDLE               NO-UNDO.
DEFINE VARIABLE wgBOSC092             
    AS WIDGET-HANDLE               NO-UNDO.
DEFINE VARIABLE wgBOSC074 
    AS WIDGET-HANDLE               NO-UNDO.
DEFINE VARIABLE vLogUtilizaColetor      
    AS LOGICAL            INIT NO  NO-UNDO.
DEFINE VARIABLE vLogAprovaFatura        
    AS LOGICAL            INIT NO  NO-UNDO.
Define Variable vCodTipoEquip           
    As Character          Init ''  No-undo.
Define Variable vLogAtivo        
    As Logical             Init NO No-undo.
Define Variable vLogProcesso 
    As Logical             Init No  No-undo.
Define Variable vNumBox    
    As Integer    Init 0            No-undo.
Define Variable vCodBloco      
    As Character                    No-undo.
Define Variable vCodRua 
    As Character                    No-undo.
Define Variable vCodNivel 
    As Character                    No-undo.
Define Variable vCodColuna 
    As Character                    No-undo.
DEFINE VARIABLE vtexto            
    AS CHARACTER FORMAT 'x(18)'     NO-UNDO.
DEFINE VARIABLE vLado
    AS CHARACTER Format "X(01)":U NO-UNDO.
DEFINE VARIABLE vstatus
    AS INTEGER FORMAT '9'           NO-UNDO.

Define Variable vLogControlaLogin       
    As Logical                 Init No  No-undo.
