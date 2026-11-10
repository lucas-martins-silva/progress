define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field modelo           AS char format "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf    as LOG
    FIELD regiao-ini       as char format "x(12)":U
    FIELD regiao-fim       as char format "x(12)":U
    FIELD rota-ini         as char format "x(12)":U
    FIELD rota-fim         as char format "x(12)":U
    FIELD grp-prod-ini     AS INTEGER
    FIELD grp-prod-fim     AS INTEGER
    FIELD prod-rural-ini   AS INTEGER
    FIELD prod-rural-fim   AS INTEGER
    FIELD cod-estabel      as char format "x(5)":U
    FIELD cod-periodo      AS CHAR FORMAT "99/9999"
    FIELD cod-serie        as char format "x(5)":U
    FIELD dt-emissao       AS DATE FORMAT "99/99/9999"
    FIELD it-codigo        AS CHAR FORMAT "X(16)":U
    FIELD nat-operacao     AS CHAR FORMAT "X(6)":U
    FIELD cod-transp-ini   AS INTEGER
    FIELD cod-transp-fim   AS INTEGER
    FIELD cod-propried     AS CHARACTER.
    /*Fim alteracao 15/02/2005*/

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD cdn-produt   AS INTEGER   FORMAT ">>>,>>>,>>9"      
    FIELD nom-produt   AS CHARACTER FORMAT "X(30)"                             
    FIELD cod-propried AS CHARACTER FORMAT "X(16)"
    FIELD des-propried AS CHARACTER FORMAT "X(60)"
    FIELD val-unit     AS DECIMAL
    FIELD val-total    AS DECIMAL
    FIELD quantidade   AS DECIMAL
    INDEX id cdn-produt.
 
def temp-table tt-raw-digita                   
    field raw-digita as raw.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD identif-segment AS CHAR
    FIELD cd-erro         AS INTEGER
    FIELD desc-erro       AS CHAR FORMAT "x(80)".

DEF TEMP-TABLE tt-variavel NO-UNDO
    FIELD cod-var-oper   AS CHAR FORMAT "x(16)"
    FIELD valor-variavel AS CHAR FORMAT "x(60)".

DEF TEMP-TABLE tt-retorno NO-UNDO
    FIELD valor-retorno AS CHAR FORMAT "x(60)"
    FIELD campo-retorno AS CHAR FORMAT "x(60)"
    FIELD perc-rateio   AS DECIMAL FORMAT ">>9,99". 

def temp-table tt-editor no-undo
    field linha      as integer
    field conteudo   as character format "x(80)"
    index editor-id is primary unique linha.

def temp-table tt_movto_event_financ no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_event_financ             as character format "x(16)" label "Evento" column-label "Evento"
    field tta_dat_movto_event              as date format "99/99/9999" initial ? label "Data Movto" column-label "Dt Mov"
    field tta_num_seq_movto_event          as integer format "999999" initial 0 label "Sequˆncia Movto" column-label "Seq"
    field tta_num_id_movto_event           as integer format "999999999" initial 0 label "Token Movto" column-label "Token"
    field tta_des_movto_event              as character format "x(50)" label "Descri‡Æo" column-label "Descri‡Æo"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_val_movto_event              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Movto" column-label "Vl Movto"
    field tta_log_integr                   as logical format "Sim/NÆo" initial no label "Integrado" column-label "Integrado"
    field tta_num_id_fechto_event_financ   as integer format "999999999" initial 0 label "ID Fechamento" column-label "ID Fechto"
    field tta_ind_orig_movto_event         as character format "X(15)" initial "Manual" label "Origem" column-label "Origem"
    field tta_des_unid_event               as character format "x(10)" label "Unidade Evento" column-label "Unid Evento"
    field tta_cod_prop_rural               as character format "x(16)" label "Propriedade Rural" column-label "Prop Rural"
    field tta_num_id_movto_conven          as integer format "999999999" initial 0 label "ID Movto Convˆnio" column-label "ID Movto"
    field tta_num_parc_movto               as integer format "9999" initial 0 label "Parcela Movto" column-label "Parcela"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_rota                     as character format "x(12)" label "Rota" column-label "Rota"
    field tta_des_event_financ             as character format "x(40)" label "Descri‡Æo" column-label "Descri‡Æo"
    field tta_ind_natur_event              as character format "X(02)" initial "DB" label "Natureza" column-label "Natureza"
    field tta_cod_grp_produt               as character format "x(12)" label "Grupo Produtor" column-label "Grp Produtor"
    field tta_cod_grp_event_financ         as character format "x(16)" label "Grupo Evento" column-label "Grp Event"
    field tta_des_grp_event_financ         as character format "x(40)" label "Descri‡Æo" column-label "Desc"
    field tta_cod_regiao                   as character format "x(12)" label "RegiÆo" column-label "RegiÆo"
    field ttv_nom_regiao                   as character format "x(50)"
    index tt_mvtvntfn_conv                
          tta_num_id_movto_event           ascending
    index tt_mvtvntfn_fechto              
          tta_num_id_fechto_event_financ   ascending
    index tt_mvtvntfn_id                   is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_fornecedor               ascending
          tta_cod_prop_rural               ascending
          tta_cod_event_financ             ascending
          tta_dat_movto_event              ascending
          tta_num_seq_movto_event          ascending
    index tt_mvtvntfn_num                  is unique
          tta_num_id_movto_event           ascending
    .

DEF temp-table tt_row_errors no-undo
    field ttv_num_seq_erro                 as integer format ">>>>,>>9" initial 0
    field ttv_num_erro                     as integer format ">>>>,>>9"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistˆncia" column-label "Inconsistˆncia"
    field ttv_des_param                    as character format "x(50)" label "Param" column-label "Param"
    field ttv_des_type                     as character format "x(10)"
    field ttv_des_help                     as character format "x(40)" label "Ajuda" column-label "Ajuda"
    field ttv_des_sub_type                 as character format "x(40)"
    index tt_indice_errors                
          ttv_num_seq_erro                 ascending.
