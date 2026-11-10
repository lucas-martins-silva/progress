&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/
{include/i-prgvrs.i BOIN01167 2.00.00.018} /* 08/10/2026 08:23:40 */
{include/i-license-manager.i BOIN01167 MRE}
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN01167
&GLOBAL-DEFINE DBOVersion
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName sumar-recebto
&GLOBAL-DEFINE TableLabel
&GLOBAL-DEFINE QueryName qr{&TableName}

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{inbo/boin01167.i RowObject}
{inbo/boin01167.i tt-sumar-recebto}


{rep/re0501.i13} //tt-sumar-recebto-grade
{inbo/boin01126.i2} /*tt-deduzIbsItem*/
{cep/ceapi320.i2} /* define l-moeda-func, l-moed-ifrs-1, l-moed-ifrs-2*/
{cdp/cd1234.i}   /* Funá∆o fn_ajust_dec */

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
{utp/ut-glob.i}
{cdp/cd9701.i}  /* Definiá∆o/atribuiá∆oo da vari†vel l-mult-natur-receb -> Usa multiplas naturezas no recebimento */
{cdp/cd9700.i} /* definicao variaveis para cd9700.i1 */
{cdp/cd0666.i}   /*definiá∆o da temp-table de erro*/
{include/i_fncrowid.i}

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància".

/* --- Definiá‰es de Temp-tables para Integraá∆o com o FGL (fg1900zo) --- */
DEF NEW SHARED TEMP-TABLE tt_integr_lote_ctbl_1 NO-UNDO
    FIELD tta_cod_modul_dtsul      AS CHARACTER
    FIELD tta_num_lote_ctbl        AS INTEGER INITIAL 1
    FIELD tta_des_lote_ctbl        AS CHARACTER
    FIELD tta_cod_empresa          AS CHARACTER
    FIELD tta_dat_lote_ctbl        AS DATE INITIAL TODAY
    FIELD ttv_ind_erro_valid       AS CHARACTER INITIAL "N∆o"
    FIELD tta_log_integr_ctbl_online AS LOGICAL INITIAL NO
    FIELD ttv_rec_integr_lote_ctbl AS &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID FORMAT ">>>>>>9" &ENDIF
    INDEX tt_recid IS PRIMARY UNIQUE ttv_rec_integr_lote_ctbl ASCENDING.

DEF NEW SHARED TEMP-TABLE tt_integr_lancto_ctbl_1 NO-UNDO
    FIELD tta_cod_cenar_ctbl               AS CHARACTER
    FIELD tta_log_lancto_conver            AS LOGICAL INITIAL no
    FIELD tta_log_lancto_apurac_restdo     AS LOGICAL INITIAL no
    FIELD tta_cod_rat_ctbl                 AS CHARACTER
    FIELD ttv_rec_integr_lote_ctbl         AS &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID FORMAT ">>>>>>9" &ENDIF
    FIELD tta_num_lancto_ctbl              AS INTEGER
    FIELD ttv_ind_erro_valid               AS CHARACTER INITIAL "N∆o"
    FIELD tta_dat_lancto_ctbl              AS DATE
    FIELD ttv_rec_integr_lancto_ctbl       AS &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID FORMAT ">>>>>>9" &ENDIF
    INDEX tt_id IS PRIMARY UNIQUE ttv_rec_integr_lote_ctbl tta_num_lancto_ctbl
    INDEX tt_recid ttv_rec_integr_lancto_ctbl.

def new shared temp-table tt_integr_item_lancto_ctbl_1 no-undo
    field ttv_rec_integr_lancto_ctbl       as &IF {&ROWID_READY} = YES &THEN
                                                ROWID
                                              &ELSE
                                                RECID format ">>>>>>9"
                                              &ENDIF
    field tta_num_seq_lancto_ctbl          as integer format ">>>>9" initial 0 label "Sequencia Lancto" column-label "Sequencia Lancto"
    field tta_ind_natur_lancto_ctbl        as character format "X(02)" initial "DB" label "Natureza" column-label "Natureza"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont†bil" column-label "Conta Cont†bil"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico Padr∆o" column-label "Hist¢rico Padr∆o"
    field tta_des_histor_lancto_ctbl       as character format "x(2000)" label "Hist¢rico Cont†bil" column-label "Hist¢rico Cont†bil"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_dat_docto                    as date format "99/99/9999" initial ? label "Data Documento" column-label "Data Documento"
    field tta_des_docto                    as character format "x(25)" label "N£mero Documento" column-label "N£mero Documento"
    field tta_cod_imagem                   as character format "x(30)" label "Imagem" column-label "Imagem"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_dat_lancto_ctbl              as date format "99/99/9999" initial ? label "Data Lanáamento" column-label "Data Lancto"
    field tta_qtd_unid_lancto_ctbl         as decimal format ">>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade" column-label "Quantidade"
    field tta_val_lancto_ctbl              as decimal format ">>>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Lanáamento" column-label "Valor Lanáamento"
    field tta_num_seq_lancto_ctbl_cpart    as integer format ">>>9" initial 0 label "Sequencia CPartida" column-label "Sequencia CP"
    field ttv_ind_erro_valid               as character format "X(08)" initial "N∆o"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_proj_financ              as character format "x(20)" label "Projeto" column-label "Projeto"
    field ttv_rec_integr_item_lancto_ctbl  as &IF {&ROWID_READY} = YES &THEN
                                                ROWID
                                              &ELSE
                                                RECID format ">>>>>>9"
                                              &ENDIF
    index tt_id                            is primary unique
          ttv_rec_integr_lancto_ctbl       ascending
          tta_num_seq_lancto_ctbl          ascending
    index tt_recid
          ttv_rec_integr_item_lancto_ctbl  ascending.

def new shared temp-table tt_integr_aprop_lancto_ctbl_1 no-undo
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_qtd_unid_lancto_ctbl         as decimal format ">>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade" column-label "Quantidade"
    field tta_val_lancto_ctbl              as decimal format ">>>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Lanáamento" column-label "Valor Lanáamento"
    field tta_num_id_aprop_lancto_ctbl     as integer format "999999999" initial 0 label "Apropriacao Lancto" column-label "Apropriacao Lancto"
    field ttv_rec_integr_item_lancto_ctbl  AS &IF {&ROWID_READY} = YES &THEN
                                                ROWID
                                              &ELSE
                                                RECID format ">>>>>>9"
                                              &ENDIF
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cotaá∆o" column-label "Data Cotaá∆o"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotaá∆o" column-label "Cotaá∆o"
    field ttv_ind_erro_valid               as character format "X(08)" initial "N∆o"
    field tta_ind_orig_val_lancto_ctbl     as character format "X(10)" initial "Informado" label "Origem Valor" column-label "Origem Valor"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field ttv_rec_integr_aprop_lancto_ctbl as &IF {&ROWID_READY} = YES &THEN
                                                ROWID
                                              &ELSE
                                                RECID format ">>>>>>9" initial ?
                                              &ENDIF
    index tt_id                            is primary unique
          ttv_rec_integr_item_lancto_ctbl  ascending
          tta_cod_finalid_econ             ascending
          tta_cod_unid_negoc               ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
    index tt_recid
          ttv_rec_integr_aprop_lancto_ctbl ASCENDING.

def new shared temp-table tt_integr_ctbl_valid_1 no-undo
    field ttv_rec_integr_ctbl              as &IF {&ROWID_READY} = YES &THEN
                                                ROWID
                                              &ELSE
                                                RECID format ">>>>>>9"
                                              &ENDIF
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_ind_pos_erro                 as character format "X(08)" label "Posiá∆o"
    index tt_id                            is primary unique
          ttv_rec_integr_ctbl              ascending
          ttv_num_mensagem                 ascending.

DEF NEW SHARED TEMP-TABLE tt_params_generic_api NO-UNDO
    FIELD ttv_rec_id          AS &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID FORMAT ">>>>>>9" &ENDIF
    FIELD ttv_cod_tabela      AS CHARACTER
    FIELD ttv_cod_campo       AS CHARACTER
    FIELD ttv_cod_valor       AS CHARACTER
    INDEX tt_idx_param_generic IS PRIMARY UNIQUE ttv_cod_tabela ttv_rec_id ttv_cod_campo.

DEF TEMP-TABLE tt_xml_input_output NO-UNDO
    FIELD ttv_cod_label                    AS CHARACTER FORMAT "x(8)"
    FIELD ttv_des_conteudo                 AS CHARACTER FORMAT "x(40)"
    FIELD ttv_des_conteudo_aux             AS CHARACTER FORMAT "x(40)"
    FIELD ttv_num_seq_1                    AS INTEGER   FORMAT ">>>,>>9"
    INDEX tt_id ttv_cod_label ASCENDING ttv_des_conteudo ASCENDING ttv_num_seq_1 ASCENDING
    INDEX tt_2 ttv_cod_label ASCENDING.

DEF TEMP-TABLE tt_log_erros NO-UNDO
    FIELD ttv_num_seq                      AS INTEGER   FORMAT ">>>,>>9" LABEL "Sequància" COLUMN-LABEL "Seq"
    FIELD ttv_num_cod_erro                 AS INTEGER   FORMAT ">>>>,>>9" LABEL "N£mero" COLUMN-LABEL "N£mero"
    FIELD ttv_des_erro                     AS CHARACTER FORMAT "x(80)" LABEL "Inconsistància" COLUMN-LABEL "Inconsistància"
    FIELD ttv_des_ajuda                    AS CHARACTER FORMAT "x(100)" LABEL "Ajuda" COLUMN-LABEL "Ajuda".

DEF TEMP-TABLE tt_cenar_ctbl_ems5 NO-UNDO
    FIELD tta_cod_cenar_ctbl         AS CHARACTER FORMAT "x(8)"
    FIELD tta_des_cenar_ctbl         AS CHARACTER FORMAT "x(40)"
    FIELD tta_log_cenar_ifrs         AS LOGICAL
    FIELD tta_log_cenar_fisc         AS LOGICAL
    FIELD ttv_log_permis_cenar_usuar AS LOGICAL.

DEF TEMP-TABLE tt_erro_fgl NO-UNDO
    FIELD ttv_num_erro_fgl AS INTEGER
    FIELD ttv_des_erro_fgl AS CHARACTER FORMAT "x(100)"
    FIELD ttv_des_arq_erro AS CHARACTER FORMAT "x(100)"
    FIELD ttv_log_ctbz     AS LOGICAL.

/* Temp-table para agrupar documentos antes da integraá∆o */
DEFINE TEMP-TABLE tt-movto-ctbz NO-UNDO
    FIELD dt-trans   AS DATE
    FIELD refer-ctbl AS CHARACTER FORMAT "x(20)"
    FIELD r-rowid    AS ROWID
    INDEX idx1 dt-trans.

/* Temp-table para devolver o log de processamento para o RPW */
DEFINE TEMP-TABLE tt-log-ctbz NO-UNDO
    FIELD ep-codigo   AS CHAR FORMAT "x(5)"
    FIELD cod-estabel AS CHAR FORMAT "x(5)"
    FIELD dt-trans    AS DATE
    FIELD refer-ctbl  AS CHAR FORMAT "x(20)"
    FIELD cod-msg     AS INT
    FIELD desc-msg    AS CHAR FORMAT "x(120)".

DEFINE VARIABLE l-mat-unid-negoc AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-gera-log       AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-tipo-docto     AS INTEGER INITIAL 1  NO-UNDO.
DEFINE VARIABLE l-validar-configuracao AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE lExistRelacParaDocto AS LOGICAL INITIAL NO  NO-UNDO.
DEFINE VARIABLE h-boin060 AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-literal-tribut AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lb-seq         AS CHARACTER   NO-UNDO.


DEF VAR rw-docum-est    AS ROWID  NO-UNDO.
DEFINE VAR h-reapi411  AS HANDLE   NO-UNDO.

{inbo/boin01189.i tt-configur-conta-ctbz}
{rep/reapi411.i} /* Temp-table(s) compartilhada(s) - tt-contas-erros */

/* Verifica Funá∆o Especial */
ASSIGN l-gera-log = CAN-FIND (FIRST funcao
                              WHERE funcao.cd-funcao = "spp-extrair-tt-contabiliz":U
                                AND funcao.ativo).


DEFINE NEW SHARED STREAM s_1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow:
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB)
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 14.5
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME





&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:
               recebe nome do campo
               retorna valor do campo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-unid-neg":U THEN ASSIGN pFieldValue = RowObject.cod-unid-neg.
        WHEN "cod-usuario-ctbz":U THEN ASSIGN pFieldValue = RowObject.cod-usuario-ctbz.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "ind-tipo-ctbz":U THEN ASSIGN pFieldValue = RowObject.ind-tipo-ctbz.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "refer-ctbl":U THEN ASSIGN pFieldValue = RowObject.refer-ctbl.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:
               recebe nome do campo
               retorna valor do campo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dt-trans":U THEN ASSIGN pFieldValue = RowObject.dt-trans.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:
               recebe nome do campo
               retorna valor do campo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "valor-ctbl-credito[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ctbl-credito[1].
        WHEN "valor-ctbl-debito[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ctbl-debito[1].
        WHEN "valor-ctbl-credito[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ctbl-credito[2].
        WHEN "valor-ctbl-debito[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ctbl-debito[2].
        WHEN "valor-ctbl-credito[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ctbl-credito[3].
        WHEN "valor-ctbl-debito[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ctbl-debito[3].
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:
               recebe nome do campo
               retorna valor do campo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "idi-modul-orig":U THEN ASSIGN pFieldValue = RowObject.idi-modul-orig.
        WHEN "num-id-movto-ctbl":U THEN ASSIGN pFieldValue = RowObject.num-id-movto-ctbl.
        WHEN "num-id-recebto":U THEN ASSIGN pFieldValue = RowObject.num-id-recebto.
        WHEN "seq-item":U THEN ASSIGN pFieldValue = RowObject.seq-item.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice idx-sumar-recebto
  Parameters:
               retorna valor do campo cod-estabel
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo seq-item
               retorna valor do campo ct-codigo
               retorna valor do campo sc-codigo
               retorna valor do campo cod-unid-neg
               retorna valor do campo dt-trans
               retorna valor do campo ind-tipo-ctbz
               retorna valor do campo idi-modul-orig
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE sumar-recebto.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pserie-docto LIKE sumar-recebto.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE sumar-recebto.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE sumar-recebto.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE sumar-recebto.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq-item LIKE sumar-recebto.seq-item NO-UNDO.
    DEFINE OUTPUT PARAMETER pct-codigo LIKE sumar-recebto.ct-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER psc-codigo LIKE sumar-recebto.sc-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-unid-neg LIKE sumar-recebto.cod-unid-neg NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-trans LIKE sumar-recebto.dt-trans NO-UNDO.
    DEFINE OUTPUT PARAMETER pind-tipo-ctbz LIKE sumar-recebto.ind-tipo-ctbz NO-UNDO.
    DEFINE OUTPUT PARAMETER pidi-modul-orig LIKE sumar-recebto.idi-modul-orig NO-UNDO.


    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           pseq-item = RowObject.seq-item
           pct-codigo = RowObject.ct-codigo
           psc-codigo = RowObject.sc-codigo
           pcod-unid-neg = RowObject.cod-unid-neg
           pdt-trans = RowObject.dt-trans
           pind-tipo-ctbz  = RowObject.ind-tipo-ctbz
           pidi-modul-orig = RowObject.idi-modul-orig.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:
               recebe nome do campo
               retorna valor do campo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-ctbzdo":U THEN ASSIGN pFieldValue = RowObject.log-ctbzdo.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:
               recebe nome do campo
               retorna valor do campo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice  idx-sumar-recebto
  Parameters:
               recebe valor do campo cod-estabel
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo seq-item
               recebe valor do campo ct-codigo
               recebe valor do campo sc-codigo
               recebe valor do campo cod-unid-neg
               recebe valor do campo dt-trans
               recebe valor do campo ind-tipo-ctbz
               recebe valor do campo idi-modul-orig
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE sumar-recebto.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pserie-docto LIKE sumar-recebto.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE sumar-recebto.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE sumar-recebto.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE sumar-recebto.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pseq-item LIKE sumar-recebto.seq-item NO-UNDO.
    DEFINE INPUT PARAMETER pct-codigo LIKE sumar-recebto.ct-codigo NO-UNDO.
    DEFINE INPUT PARAMETER psc-codigo LIKE sumar-recebto.sc-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-unid-neg LIKE sumar-recebto.cod-unid-neg NO-UNDO.
    DEFINE INPUT PARAMETER pdt-trans LIKE sumar-recebto.dt-trans NO-UNDO.
    DEFINE INPUT PARAMETER pind-tipo-ctbz LIKE sumar-recebto.ind-tipo-ctbz NO-UNDO.
    DEFINE INPUT PARAMETER pidi-modul-orig LIKE sumar-recebto.idi-modul-orig NO-UNDO.

    FIND FIRST bfsumar-recebto WHERE
        bfsumar-recebto.cod-estabel = pcod-estabel AND
        bfsumar-recebto.serie-docto = pserie-docto AND
        bfsumar-recebto.nro-docto = pnro-docto AND
        bfsumar-recebto.cod-emitente = pcod-emitente AND
        bfsumar-recebto.nat-operacao = pnat-operacao AND
        bfsumar-recebto.seq-item = pseq-item AND
        bfsumar-recebto.ct-codigo = pct-codigo AND
        bfsumar-recebto.sc-codigo = psc-codigo AND
        bfsumar-recebto.cod-unid-neg = pcod-unid-neg AND
        bfsumar-recebto.dt-trans = pdt-trans AND
        bfsumar-recebto.ind-tipo-ctbz = pind-tipo-ctbz AND
        bfsumar-recebto.idi-modul-orig = pidi-modul-orig NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfsumar-recebto THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfsumar-recebto)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH  {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gerarLanctoContabil DBOProgram
PROCEDURE gerarLanctoContabil :
/*:T------------------------------------------------------------------------------
  Purpose:     Gera a grade contˇbil do documento
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM r-docum-est AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEF VAR h-reapi436         AS HANDLE                         NO-UNDO.
    def var l-gera-sumar    as logical  initial yes no-undo.
    
    DEFINE BUFFER bfdocum-est FOR docum-est.
   
    run gerarSumarizacao (input r-docum-est,
                          output l-gera-sumar).
    IF  l-gera-sumar 
    AND CAN-FIND(FIRST funcao
                 WHERE funcao.cd-funcao = "spp-contab-trib-rt":U
                   AND funcao.ativo) THEN DO:
                   
        IF NOT VALID-HANDLE (h-reapi436) THEN
            RUN rep/reapi436.p PERSISTENT SET h-reapi436.

        IF NOT VALID-HANDLE (h-reapi411) THEN
        RUN rep/reapi411.p PERSISTENT SET h-reapi411.


        FIND FIRST docum-est WHERE ROWID(docum-est) = r-docum-est NO-LOCK NO-ERROR.
        IF NOT AVAIL docum-est THEN
            RETURN "OK":U.

        ASSIGN rw-docum-est = ROWID(docum-est).

        RUN emptyRowErrors.
        
        RUN validaDocumEstJaContabilizado.
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.

        DO TRANSACTION ON ERROR UNDO, LEAVE:

            RUN limpaSumarRecebtoDocumento.
            RUN openQueryStatic ( "Main" ).
            RUN processaItensLanctoContabil (INPUT h-reapi436).
    
            IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U)
            OR CAN-FIND (tt-contas-erros)   THEN DO: 
               UNDO, LEAVE.
            END.
            ELSE DO:
                IF  RETURN-VALUE <> "NOK":U 
                AND CAN-FIND (FIRST bfsumar-recebto NO-LOCK
                              WHERE bfsumar-recebto.cod-estabel  = docum-est.cod-estabel
                                AND bfsumar-recebto.serie-docto  = docum-est.serie-docto
                                AND bfsumar-recebto.nro-docto    = docum-est.nro-docto
                                AND bfsumar-recebto.cod-emitente = docum-est.cod-emitente
                                AND bfsumar-recebto.nat-operacao = docum-est.nat-operacao
                                AND bfsumar-recebto.dt-trans     = docum-est.dt-trans) THEN DO:
                    
                    {method/svc/errors/inserr.i &ErrorNumber="58622" /*Sumarizaá∆o recebimento efetuado com sucesso!*/
                                                &ErrorType="EMS"
                                                &ErrorSubType="INFORMATION"}
                END.
                /* Atualizar o documento como sumarizado somente quando n∆o houver erro */
                FIND CURRENT docum-est EXCLUSIVE-LOCK NO-ERROR.
                IF AVAILABLE docum-est THEN
                ASSIGN docum-est.log-sumar = CAN-FIND (FIRST bfsumar-recebto NO-LOCK
                                                       WHERE bfsumar-recebto.cod-estabel  = docum-est.cod-estabel
                                                         AND bfsumar-recebto.serie-docto  = docum-est.serie-docto
                                                         AND bfsumar-recebto.nro-docto    = docum-est.nro-docto
                                                         AND bfsumar-recebto.cod-emitente = docum-est.cod-emitente
                                                         AND bfsumar-recebto.nat-operacao = docum-est.nat-operacao
                                                         AND bfsumar-recebto.dt-trans     = docum-est.dt-trans).
                FIND CURRENT bfdocum-est NO-LOCK NO-ERROR.
            END.
        END.
    END.

    RETURN "OK":U.
    FINALLY:
        IF VALID-HANDLE(h-reapi436) THEN DO:
           DELETE PROCEDURE h-reapi436 NO-ERROR.
           ASSIGN h-reapi436 = ?.
        END.

        IF VALID-HANDLE(h-reapi411) THEN DO:
           DELETE PROCEDURE h-reapi411 NO-ERROR.
           ASSIGN h-reapi411 = ?.
        END.

    END FINALLY.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaFuncaoSppContabTribRt DBOProgram
PROCEDURE validaFuncaoSppContabTribRt:
    IF NOT CAN-FIND (FIRST funcao NO-LOCK
                     WHERE funcao.cd-funcao = "spp-contab-trib-rt":U 
                     AND   funcao.ativo) THEN DO:
       {utp/ut-liter.i conta-trib-rt *}
       {method/svc/errors/inserr.i
                          &ErrorNumber="27372" /* msg: &1 j† foi contabilizado(a) / help: &1 j† foi contabilizado(a)*/
                          &ErrorType="EMS"
                          &ErrorSubType = "ERROR":U
                          &ErrorParameters="RETURN-VALUE"}
        RETURN "NOK":U.
    END.
    RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gerarSumarizacao DBOProgram
procedure gerarSumarizacao :
/*:T------------------------------------------------------------------------------
  Purpose: Retorna se o documento deve ser sumarizado ou nío
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    def input  param r-docum-est        as rowid            no-undo.
    def output param p-log-sumarizar    as log  initial yes no-undo.

    def var log-desconsidera-item   as log  no-undo.

    for first docum-est fields(serie-docto nro-docto cod-emitente nat-operacao cod-tipo-ente-gov cod-tipo-oper-gov origem) no-lock
        where rowid(docum-est) = r-docum-est:
    end.
    if not avail docum-est then
        return "OK":U.

    for first natur-oper fields(tipo-compra ind-contabilizacao tp-oper-terc char-1 auto-ce emite-duplic idi-tip-devol-consig)
                         of docum-est no-lock:
    end.
    if not avail natur-oper then
        return "OK":U.

    if (docum-est.cod-tipo-ente-gov > 0 and
        (docum-est.cod-tipo-oper-gov = 2 or docum-est.cod-tipo-oper-gov = 4)) or  //compra governamental
       natur-oper.tipo-compra = 9                                             then //Nota de D?bito ou Cr?dito
        assign p-log-sumarizar = natur-oper.ind-contabilizacao.

    if (natur-oper.tp-oper-terc = 5 and
        natur-oper.idi-tip-devol-consig = 1) or //Devolu?ío Consigna?ío SimbΩlica
       natur-oper.tipo-compra = 4            then //Tipo Compra: Material Agregado
       assign p-log-sumarizar = no.

    itens-nota:
    for each item-doc-est fields(serie-docto nro-docto cod-emitente nat-operacao baixa-ce it-codigo sequencia)
                          of docum-est no-lock,
       first item fields(tipo-contr)
                  of item-doc-est no-lock:

        if not item-doc-est.baixa-ce or       //item do documento estiver com baixa estoque desmarcado
           item.tipo-contr = 4       or      //item da nota seja d?bito direto
           not can-find(first rat-lote       //nío tenham rat-lote
                        {cdp/cd8900.i rat-lote item-doc-est}
                        and rat-lote.sequencia = item-doc-est.sequencia) then do:
           assign log-desconsidera-item = yes.
           leave itens-nota.
        end.
    end.

    if docum-est.origem = "G"       and     //origem GFE
       log-desconsidera-item        and     //bloco itens-nota acima
       not natur-oper.emite-duplic  and     //Natureza nío emite duplicata
       not natur-oper.auto-ce       then    //Estoque automˇtica desmarcado
        assign p-log-sumarizar = no.

end procedure.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaDocumEstJaContabilizado DBOProgram
PROCEDURE validaDocumEstJaContabilizado:

    IF NOT AVAILABLE docum-est THEN
        RETURN "NOK":U.

    IF CAN-FIND (FIRST bfsumar-recebto NO-LOCK
                 WHERE bfsumar-recebto.cod-estabel  = docum-est.cod-estabel
                   AND bfsumar-recebto.serie-docto  = docum-est.serie-docto
                   AND bfsumar-recebto.nro-docto    = docum-est.nro-docto
                   AND bfsumar-recebto.cod-emitente = docum-est.cod-emitente
                   AND bfsumar-recebto.nat-operacao = docum-est.nat-operacao
                   AND bfsumar-recebto.dt-trans     = docum-est.dt-trans
                   AND bfsumar-recebto.log-ctbzdo) THEN DO:

        {utp/ut-liter.i Documento *}
        {method/svc/errors/inserr.i
                    &ErrorNumber="33251" /* msg: &1 j† foi contabilizado(a) / help: &1 j† foi contabilizado(a)*/
                    &ErrorType="EMS"
                    &ErrorSubType = "ERROR":U
                    &ErrorParameters="RETURN-VALUE"}

        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE limpaSumarRecebtoDocumento DBOProgram
PROCEDURE limpaSumarRecebtoDocumento:

    IF NOT AVAILABLE docum-est THEN
        RETURN "NOK":U.


    FOR EACH bfsumar-recebto EXCLUSIVE-LOCK
       WHERE bfsumar-recebto.cod-estabel    = docum-est.cod-estabel
         AND bfsumar-recebto.serie-docto    = docum-est.serie-docto
         AND bfsumar-recebto.nro-docto      = docum-est.nro-docto
         AND bfsumar-recebto.cod-emitente   = docum-est.cod-emitente
         AND bfsumar-recebto.nat-operacao   = docum-est.nat-operacao
         AND bfsumar-recebto.dt-trans       = docum-est.dt-trans :
         DELETE bfsumar-recebto NO-ERROR.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminarSumarRecebto DBOProgram
PROCEDURE eliminarSumarRecebto :
/*:T------------------------------------------------------------------------------
  Purpose:     Elimina a Sumarizaá∆o gerada para um documento de recebimento
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM r-docum-est AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE BUFFER bfdocum-est FOR docum-est.

    FIND docum-est WHERE ROWID(docum-est) = r-docum-est NO-LOCK NO-ERROR.
    IF NOT AVAIL docum-est THEN
        RETURN "OK":U.

    RUN emptyRowErrors.

    RUN validaDocumEstJaContabilizado.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RUN limpaSumarRecebtoDocumento.

    FIND CURRENT docum-est EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE docum-est THEN
        ASSIGN docum-est.log-sumar = NO.
    FIND CURRENT bfdocum-est NO-LOCK NO-ERROR.
    
    
    {method/svc/errors/inserr.i &ErrorNumber="58623" /*Sumarizaá∆o eliminada com sucesso!*/
                                &ErrorType="EMS"
                                &ErrorSubType="INFORMATION"}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processaItensLanctoContabil DBOProgram
PROCEDURE processaItensLanctoContabil:

    DEFINE INPUT PARAMETER ph-reapi436 AS HANDLE NO-UNDO.

    DEF VAR de-valor-cbs      AS DECIMAL                        NO-UNDO.
    DEF VAR de-valor-ibsuf    AS DECIMAL                        NO-UNDO.
    DEF VAR de-valor-ibsmun   AS DECIMAL                        NO-UNDO.
    DEF VAR de-valor-is       AS DECIMAL                        NO-UNDO.
    DEF VAR h-boin01126       AS HANDLE                         NO-UNDO.

    DEF VAR c-conta-cbs-cr       LIKE docum-est.ct-transit         NO-UNDO.
    DEF VAR c-ccusto-cbs-cr      LIKE docum-est.sc-transit         NO-UNDO.
    DEF VAR c-unid-neg-cbs-cr    LIKE unid-neg-nota.cod_unid_negoc NO-UNDO.
    DEF VAR c-conta-ibsuf-cr     LIKE docum-est.ct-transit         NO-UNDO.
    DEF VAR c-ccusto-ibsuf-cr    LIKE docum-est.sc-transit         NO-UNDO.
    DEF VAR c-unid-neg-ibsuf-cr  LIKE unid-neg-nota.cod_unid_negoc NO-UNDO.
    DEF VAR c-conta-ibsmun-cr    LIKE docum-est.ct-transit         NO-UNDO.
    DEF VAR c-ccusto-ibsmun-cr   LIKE docum-est.sc-transit         NO-UNDO.
    DEF VAR c-unid-neg-ibsmun-cr LIKE unid-neg-nota.cod_unid_negoc NO-UNDO.
    DEF VAR c-conta-is-cr        LIKE docum-est.ct-transit         NO-UNDO.
    DEF VAR c-ccusto-is-cr       LIKE docum-est.sc-transit         NO-UNDO.
    DEF VAR c-unid-neg-is-cr     LIKE unid-neg-nota.cod_unid_negoc NO-UNDO.

    DEF VAR c-conta-cbs-db       LIKE docum-est.ct-transit         NO-UNDO.
    DEF VAR c-ccusto-cbs-db      LIKE docum-est.sc-transit         NO-UNDO.
    DEF VAR c-unid-neg-cbs-db    LIKE unid-neg-nota.cod_unid_negoc NO-UNDO.
    DEF VAR c-conta-ibsuf-db     LIKE docum-est.ct-transit         NO-UNDO.
    DEF VAR c-ccusto-ibsuf-db    LIKE docum-est.sc-transit         NO-UNDO.
    DEF VAR c-unid-neg-ibsuf-db  LIKE unid-neg-nota.cod_unid_negoc NO-UNDO.
    DEF VAR c-conta-ibsmun-db    LIKE docum-est.ct-transit         NO-UNDO.
    DEF VAR c-ccusto-ibsmun-db   LIKE docum-est.sc-transit         NO-UNDO.
    DEF VAR c-unid-neg-ibsmun-db LIKE unid-neg-nota.cod_unid_negoc NO-UNDO.
    DEF VAR c-conta-is-db        LIKE docum-est.ct-transit         NO-UNDO.
    DEF VAR c-ccusto-is-db       LIKE docum-est.sc-transit         NO-UNDO.
    DEF VAR c-unid-neg-is-db     LIKE unid-neg-nota.cod_unid_negoc NO-UNDO.
    DEF VAR c-estabel            AS CHARACTER                      NO-UNDO.

    /* Item Total so eh contabilizado aqui quando o estoque nao for tratar o valor */
    DEF VAR l-log-contabiliza-previa-recebto AS LOGICAL NO-UNDO.
    DEF VAR da-dt-ini-consid-is-custo-item   AS DATE    NO-UNDO.
    DEF BUFFER b-natur-fiscal-saida FOR natur-oper.
    IF NOT AVAIL docum-est THEN
        RETURN "NOK":U.

    IF NOT VALID-HANDLE(ph-reapi436) THEN
        RETURN "NOK":U.

    FOR FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = docum-est.cod-emitente: END.

    /* Carga da temp-table de deduá∆o do credito presumido no IBS UF */
    RUN inbo/boin01126.p PERSISTENT SET h-boin01126 NO-ERROR.

    IF VALID-HANDLE(h-boin01126) THEN DO:

        EMPTY TEMP-TABLE tt-deduzIbsItem.

        RUN createTtDeduzValorIbs IN h-boin01126 (INPUT docum-est.serie-docto,
                                                  INPUT docum-est.nro-docto,
                                                  INPUT docum-est.cod-emitente,
                                                  INPUT docum-est.nat-operacao,
                                                  OUTPUT TABLE tt-deduzIbsItem).

    END.



    RUN inicializar IN h-reapi411 (INPUT ROWID(docum-est)).

    FIND FIRST param-gerais-rec NO-LOCK
         WHERE param-gerais-rec.cod-param = 'dt-ini-consid-is-custo-item':U NO-ERROR.
    IF AVAIL param-gerais-rec THEN
        ASSIGN da-dt-ini-consid-is-custo-item = DATE(param-gerais-rec.conteudo) NO-ERROR.

    FIND FIRST param-gerais-rec NO-LOCK
         WHERE param-gerais-rec.cod-param = 'log-contabiliza-previa-recebto':U NO-ERROR.
    IF AVAIL param-gerais-rec THEN
        ASSIGN l-log-contabiliza-previa-recebto = LOGICAL(param-gerais-rec.conteudo) NO-ERROR.

        
    RUN piEliminaConsistNota (INPUT 58618,
                              INPUT 2). //1-erro, 2-advertància 
                              
    FOR EACH item-doc-est OF docum-est NO-LOCK:

        ASSIGN de-valor-cbs    = 0
               de-valor-ibsuf  = 0
               de-valor-ibsmun = 0
               de-valor-is     = 0.

        RUN obterValorTributo (INPUT rep.imp.Imposto:CBS,
                               OUTPUT de-valor-cbs).

        RUN obterValorTributo (INPUT rep.imp.Imposto:IBS-UF,
                               OUTPUT de-valor-ibsuf).

        RUN obterValorTributo (INPUT rep.imp.Imposto:IBS-MUN,
                               OUTPUT de-valor-ibsmun).

        RUN obterValorTributo (INPUT rep.imp.Imposto:IS,
                               OUTPUT de-valor-is).

        /* Somente realizar o processo de gerar a sumar-recebto se possuir valor em pelo menos um dos tributos */
        IF de-valor-cbs    > 0
        OR de-valor-ibsuf  > 0
        OR de-valor-ibsmun > 0
        OR de-valor-is     > 0 THEN DO:
            /* Se usa m£ltiplas naturezas no recebimento */
            IF l-mult-natur-receb THEN DO:
                FOR FIRST natur-oper WHERE natur-oper.nat-operacao = item-doc-est.nat-of NO-LOCK: END.
            END.
            ELSE DO:
                FOR FIRST natur-oper WHERE natur-oper.nat-operacao = item-doc-est.nat-operacao NO-LOCK: END.
            END.
            {cdp/cd9700.i1 natur-oper}

            FOR FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = item-doc-est.it-codigo:
            END.

            IF AVAIL natur-oper AND natur-oper.transf then
                ASSIGN c-estabel = docum-est.estab-de-or.
            ELSE
                ASSIGN c-estabel = docum-est.cod-estabel.
            RUN emptyTtconfigurContaCtbz IN ph-reapi436.

            IF (docum-est.cod-observa = 3 AND item-doc-est.nro-comp <> "") //devolu?ío com origem
            OR natur-oper.tipo-compra = 8    /*devolu?ío de tranfer?ncia*/
            OR natur-oper.transf             /*transfer?ncia */
            OR natur-oper.tp-oper-terc = 2   /*Retorno Beneficiamento*/
            OR natur-oper.tp-oper-terc = 9   /*Retorno Dep Fechado*/
            OR natur-oper.tp-oper-terc = 11  /*Retorno Armaz?m Geral*/
            OR (natur-oper.tp-oper-terc = 5 AND natur-oper.idi-tip-devol-consig = 2)   /*Devolu?ío Consign?ío mercantil*/
            OR (docum-est.cod-observa = 3
                AND (   l-fatura-fat-antecip
                     OR l-remessa-fat-antecip
                     OR l-fatura-ent-futura
                     OR l-remessa-ent-futura )) THEN DO:
                IF item-doc-est.nat-comp <> '' THEN DO:

                    FOR FIRST b-natur-fiscal-saida NO-LOCK
                        WHERE b-natur-fiscal-saida.nat-operacao = item-doc-est.nat-comp:
                    END.
                    /*Se a nota de sa≠da nío contabilzou a nota de entrada tbm nío irˇ contabilizar*/
                    IF b-natur-fiscal-saida.ind-contabilizacao = NO THEN
                        RETURN "NOK":U.
                END.

                ASSIGN i-tipo-docto = 2. //sa≠da
                FOR FIRST nota-fiscal NO-LOCK
                    WHERE nota-fiscal.cod-estabel = c-estabel
                      AND nota-fiscal.serie       = item-doc-est.serie-comp
                      AND nota-fiscal.nr-nota-fis = item-doc-est.nro-comp:

                     RUN setCodEstabel            IN ph-reapi436 (INPUT c-estabel).
                     RUN setDtTrans               IN ph-reapi436 (INPUT nota-fiscal.dt-emis-nota).
                     RUN setTipoDocto             IN ph-reapi436 (INPUT i-tipo-docto).
                     RUN setCodEmitente           IN ph-reapi436 (INPUT nota-fiscal.cod-emitente).
                     RUN setCodGrupEmit           IN ph-reapi436 (INPUT IF AVAILABLE emitente THEN emitente.cod-gr-cli ELSE 0).
                     RUN setNatOperacao           IN ph-reapi436 (INPUT item-doc-est.nat-comp).
                     RUN setFmCodigo              IN ph-reapi436 (INPUT item.fm-codigo).
                     RUN setGeCodigo              IN ph-reapi436 (INPUT item.ge-codigo).
                     RUN setCodCanalVenda         IN ph-reapi436 (INPUT nota-fiscal.cod-canal-venda).
                     RUN setSerie                 IN ph-reapi436 (INPUT nota-fiscal.serie).
                END.
            END.
            ELSE DO:

                ASSIGN i-tipo-docto = 1. //entrada
                RUN setCodEstabel            IN ph-reapi436 (INPUT c-estabel).
                RUN setDtTrans               IN ph-reapi436 (INPUT docum-est.dt-trans).
                RUN setTipoDocto             IN ph-reapi436 (INPUT i-tipo-docto).
                RUN setCodEmitente           IN ph-reapi436 (INPUT docum-est.cod-emitente).
                RUN setCodGrupEmit           IN ph-reapi436 (INPUT emitente.cod-gr-forn).
                RUN setNatOperacao           IN ph-reapi436 (INPUT natur-oper.nat-operacao).
                RUN setFmCodigo              IN ph-reapi436 (INPUT item.fm-codigo).
                RUN setGeCodigo              IN ph-reapi436 (INPUT item.ge-codigo).
                RUN setSerie                 IN ph-reapi436 (INPUT docum-est.serie).
            END.

            RUN setUtilizarCache         IN ph-reapi436 (INPUT YES).

            RUN buscarDadosContaCtbz (INPUT  ph-reapi436,
                                      INPUT  1, //cbs
                                      OUTPUT c-conta-cbs-cr,
                                      OUTPUT c-ccusto-cbs-cr,
                                      OUTPUT c-unid-neg-cbs-cr,
                                      OUTPUT c-conta-cbs-db,
                                      OUTPUT c-ccusto-cbs-db,
                                      OUTPUT c-unid-neg-cbs-db).

            
            IF lExistRelacParaDocto  THEN DO: 
               RUN processaLancamentoTributo (INPUT rep.imp.Imposto:CBS,
                                              INPUT de-valor-cbs,
                                              INPUT c-conta-cbs-cr,
                                              INPUT c-ccusto-cbs-cr,
                                              INPUT c-unid-neg-cbs-cr,
                                              INPUT c-conta-cbs-db,
                                              INPUT c-ccusto-cbs-db,
                                              INPUT c-unid-neg-cbs-db).
                                              
                                              
               IF RETURN-VALUE = "NOK":U THEN
                  RETURN "NOK":U.                              
            END.
            

            RUN buscarDadosContaCtbz (INPUT  ph-reapi436,
                                      INPUT  2, //ibsuf
                                      OUTPUT c-conta-ibsuf-cr,
                                      OUTPUT c-ccusto-ibsuf-cr,
                                      OUTPUT c-unid-neg-ibsuf-cr,
                                      OUTPUT c-conta-ibsuf-db,
                                      OUTPUT c-ccusto-ibsuf-db,
                                      OUTPUT c-unid-neg-ibsuf-db).

            IF lExistRelacParaDocto  THEN DO:
                RUN processaLancamentoTributo (INPUT rep.imp.Imposto:IBS-UF,
                                               INPUT de-valor-ibsuf,
                                               INPUT c-conta-ibsuf-cr,
                                               INPUT c-ccusto-ibsuf-cr,
                                               INPUT c-unid-neg-ibsuf-cr,
                                               INPUT c-conta-ibsuf-db,
                                               INPUT c-ccusto-ibsuf-db,
                                               INPUT c-unid-neg-ibsuf-db).

                IF RETURN-VALUE = "NOK":U THEN
                   RETURN "NOK":U.
            END.
            RUN buscarDadosContaCtbz (INPUT  ph-reapi436,
                                      INPUT  3, //ibsmun
                                      OUTPUT c-conta-ibsmun-cr,
                                      OUTPUT c-ccusto-ibsmun-cr,
                                      OUTPUT c-unid-neg-ibsmun-cr,
                                      OUTPUT c-conta-ibsmun-db,
                                      OUTPUT c-ccusto-ibsmun-db,
                                      OUTPUT c-unid-neg-ibsmun-db).
                                      
            IF lExistRelacParaDocto  THEN DO:
                RUN processaLancamentoTributo (INPUT rep.imp.Imposto:IBS-MUN,
                                               INPUT de-valor-ibsmun,
                                               INPUT c-conta-ibsmun-cr,
                                               INPUT c-ccusto-ibsmun-cr,
                                               INPUT c-unid-neg-ibsmun-cr,
                                               INPUT c-conta-ibsmun-db,
                                               INPUT c-ccusto-ibsmun-db,
                                               INPUT c-unid-neg-ibsmun-db).
                IF RETURN-VALUE = "NOK":U THEN
                   RETURN "NOK":U.
            END.
            /* Item Total so fica de fora daqui quando o estoque vai tratar o IS (data de custo atingida e previa desativada) */
            IF de-valor-is > 0
            AND (item.tipo-contr <> 2
                 OR docum-est.dt-trans < da-dt-ini-consid-is-custo-item
                 OR l-log-contabiliza-previa-recebto) THEN DO:

                RUN buscarDadosContaCtbz (INPUT  ph-reapi436,
                                          INPUT  4, //is
                                          OUTPUT c-conta-is-cr,
                                          OUTPUT c-ccusto-is-cr,
                                          OUTPUT c-unid-neg-is-cr,
                                          OUTPUT c-conta-is-db,
                                          OUTPUT c-ccusto-is-db,
                                          OUTPUT c-unid-neg-is-db).
               IF lExistRelacParaDocto  THEN DO:
                    RUN processaLancamentoTributo (INPUT rep.imp.Imposto:IS,
                                                   INPUT de-valor-is,
                                                   INPUT c-conta-is-cr,
                                                   INPUT c-ccusto-is-cr,
                                                   INPUT c-unid-neg-is-cr,
                                                   INPUT c-conta-is-db,
                                                   INPUT c-ccusto-is-db,
                                                   INPUT c-unid-neg-is-db).
                    IF RETURN-VALUE = "NOK":U THEN
                       RETURN "NOK":U.
               END.
            END.
        END.
    END.

    RETURN "OK":U.
    FINALLY:
        DELETE PROCEDURE h-boin01126 NO-ERROR.
    END FINALLY.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscarDadosContaCtbz DBOProgram
PROCEDURE buscarDadosContaCtbz PRIVATE:

    DEFINE INPUT  PARAMETER ph-reapi436         AS HANDLE                         NO-UNDO.
    DEFINE INPUT  PARAMETER pi-ind-tip-ctbz     AS INTEGER                        NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-conta-cr         LIKE docum-est.ct-transit         NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-ccusto-cr        LIKE docum-est.sc-transit         NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-unid-neg-cr      LIKE unid-neg-nota.cod_unid_negoc NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-conta-db         LIKE docum-est.ct-transit         NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-ccusto-db        LIKE docum-est.sc-transit         NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-unid-neg-db      LIKE unid-neg-nota.cod_unid_negoc NO-UNDO.

    
    DEFINE VARIABLE c-indice-configur-conta-ctbz AS CHARACTER  INITIAL '' NO-UNDO.
    
    IF NOT VALID-HANDLE(ph-reapi436) THEN
       RETURN "NOK":U.
    
    ASSIGN c-literal-tribut = ''.
    CASE pi-ind-tip-ctbz:
        WHEN 1 THEN DO:
            {utp/ut-liter.i "CBS" *}
            ASSIGN c-literal-tribut = RETURN-VALUE.
        END.
        WHEN 2 THEN DO:
            {utp/ut-liter.i "IBS_UF" *}
            ASSIGN c-literal-tribut = RETURN-VALUE.
        END.
        WHEN 3 THEN DO:
            {utp/ut-liter.i "IBS_MUN" *}
            ASSIGN c-literal-tribut = RETURN-VALUE.
        END.
        WHEN 4 THEN DO:
            {utp/ut-liter.i "IS" *}
            ASSIGN c-literal-tribut = RETURN-VALUE.
        END.
    END CASE.
    EMPTY TEMP-TABLE tt-configur-conta-ctbz.   
    RUN emptyTtconfigurContaCtbz IN ph-reapi436.
    RUN setIndTipCtbz            IN ph-reapi436 (INPUT pi-ind-tip-ctbz).
    RUN buscarConfigurContaCtbz  IN ph-reapi436.
    ASSIGN lExistRelacParaDocto = NO.
    RUN encontradoRelactoParaDocto IN ph-reapi436 (OUTPUT lExistRelacParaDocto).
    
    /*utilizada somente para retornar o cen†rio utilizado*/
    RUN getTtDadosCtbz IN ph-reapi436 (OUTPUT TABLE tt-configur-conta-ctbz).
          
    IF lExistRelacParaDocto THEN DO:
        RUN getDadosCtbz IN ph-reapi436 (OUTPUT pc-conta-cr,
                                         OUTPUT pc-ccusto-cr,
                                         OUTPUT pc-unid-neg-cr,
                                         OUTPUT pc-conta-db,
                                         OUTPUT pc-ccusto-db,
                                         OUTPUT pc-unid-neg-db).
                                         
        
        FOR EACH tt-configur-conta-ctbz:
            ASSIGN c-indice-configur-conta-ctbz  = " - Est: "  	 + tt-configur-conta-ctbz.cod-estabel  +
                                                   " Tipo: " + (IF tt-configur-conta-ctbz.tipo-docto = 1 THEN "Entrada":U ELSE "Sa°da":U) +
                                                   " Dt Inicio validade: "  +  string(tt-configur-conta-ctbz.dt-ini-valid,'99/99/9999') +
                                                   " Dt Fim validade: "  	 + (IF tt-configur-conta-ctbz.dt-fim-valid = ? THEN "" ELSE string(tt-configur-conta-ctbz.dt-fim-valid,'99/99/9999')) +
                                                   " Emit: " + string(tt-configur-conta-ctbz.cod-emitente)    +
                                                   " Grp Emit: " + string(tt-configur-conta-ctbz.cod-grupo-emit)  +
                                                   " Nat. Op.: " + tt-configur-conta-ctbz.nat-operacao    +
                                                   " Fam°lia: " + tt-configur-conta-ctbz.fm-codigo       +
                                                   " GE: " + string(tt-configur-conta-ctbz.ge-codigo)       +
                                                   " SÇrie: " + (IF tt-configur-conta-ctbz.serie = ? THEN "" ELSE tt-configur-conta-ctbz.serie)     +
                                                   " Canal: " + (IF tt-configur-conta-ctbz.cod-canal-venda = ? THEN "" ELSE string(tt-configur-conta-ctbz.cod-canal-venda)).

        END.

        CASE pi-ind-tip-ctbz:
            WHEN 1 THEN DO:
                /* Validacao de contas REAPI411 Parametros -> ROWID docum-est, seq item, conta, centro custo, origem, tipo */
               {rep/reapi411.i3 "rw-docum-est" "item-doc-est.sequencia" "pc-conta-cr" "pc-ccusto-cr" "Configuraá∆o conta contabilizaá∆o (html.mcd.configurContaCtbz)" "Conta CBS crÇdito" "c-indice-configur-conta-ctbz"}
               {rep/reapi411.i3 "rw-docum-est" "item-doc-est.sequencia" "pc-conta-db" "pc-ccusto-db" "Configuraá∆o conta contabilizaá∆o (html.mcd.configurContaCtbz)" "Conta CBS dÇbito" "c-indice-configur-conta-ctbz"}
            END.
            WHEN 2 THEN DO:
                /* Validacao de contas REAPI411 Parametros -> ROWID docum-est, seq item, conta, centro custo, origem, tipo */
               {rep/reapi411.i3 "rw-docum-est" "item-doc-est.sequencia" "pc-conta-cr" "pc-ccusto-cr" "Configuraá∆o conta contabilizaá∆o (html.mcd.configurContaCtbz)" "Conta IBS UF crÇdito" "c-indice-configur-conta-ctbz"}
               {rep/reapi411.i3 "rw-docum-est" "item-doc-est.sequencia" "pc-conta-db" "pc-ccusto-db" "Configuraá∆o conta contabilizaá∆o (html.mcd.configurContaCtbz)" "Conta IBS UF dÇbito" "c-indice-configur-conta-ctbz"}
            END.
            WHEN 3 THEN DO:
                /* Validacao de contas REAPI411 Parametros -> ROWID docum-est, seq item, conta, centro custo, origem, tipo */
               {rep/reapi411.i3 "rw-docum-est" "item-doc-est.sequencia" "pc-conta-cr" "pc-ccusto-cr" "Configuraá∆o conta contabilizaá∆o (html.mcd.configurContaCtbz)" "Conta IBS MUN crÇdito" "c-indice-configur-conta-ctbz"}
               {rep/reapi411.i3 "rw-docum-est" "item-doc-est.sequencia" "pc-conta-db" "pc-ccusto-db" "Configuraá∆o conta contabilizaá∆o (html.mcd.configurContaCtbz)" "Conta IBS MUN dÇbito" "c-indice-configur-conta-ctbz"}
            END.
            WHEN 4 THEN DO:

                /* Validacao de contas REAPI411 Parametros -> ROWID docum-est, seq item, conta, centro custo, origem, tipo */
               {rep/reapi411.i3 "rw-docum-est" "item-doc-est.sequencia" "pc-conta-cr" "pc-ccusto-cr" "Configuraá∆o conta contabilizaá∆o (html.mcd.configurContaCtbz)" "Conta IS crÇdito" "c-indice-configur-conta-ctbz"}
               {rep/reapi411.i3 "rw-docum-est" "item-doc-est.sequencia" "pc-conta-db" "pc-ccusto-db" "Configuraá∆o conta contabilizaá∆o (html.mcd.configurContaCtbz)" "Conta IS dÇbito" "c-indice-configur-conta-ctbz"}
            END.
        END CASE.


        RUN isValidaContas IN h-reapi411.
        RUN validaContas IN h-reapi411 (INPUT ROWID(docum-est)).
        IF RETURN-VALUE = "NOK":U THEN DO:
          RUN getTTContasErros IN h-reapi411 (OUTPUT TABLE tt-contas-erros).
          IF CAN-FIND (tt-contas-erros) THEN
              RETURN "NOK":U.
        END.

    END.
    ELSE DO:
        {method/svc/errors/inserr.i &ErrorNumber="58618" /*N∆o localizado configuraá∆o de contas para o tributo &1 */
                                  &ErrorType="EMS":U
                                  &ErrorSubType="WARNING":U
                                  &ErrorParameters="c-literal-tribut + '~~~~' + string(item-doc-est.sequencia)"}    
         RUN piCriaConsistNota (INPUT 0,  //calculado
                                INPUT 0,  //informado
                                INPUT 58618,
                                INPUT c-literal-tribut,
                                INPUT 2). //1-erro, 2-advertància  
    END.
   
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEliminaConsistNota DBOProgram
PROCEDURE piEliminaConsistNota PRIVATE:
    DEF INPUT PARAM i-mensagem    AS INTEGER NO-UNDO. 
    DEF INPUT PARAM i-tipo        AS INTEGER NO-UNDO. 
    
    FOR EACH consist-nota EXCLUSIVE-LOCK
       WHERE consist-nota.serie-docto            = docum-est.serie-docto
         AND consist-nota.nro-docto              = docum-est.nro-docto
         AND consist-nota.cod-emitente           = docum-est.cod-emitente
         AND consist-nota.nat-operacao           = docum-est.nat-operacao
         AND consist-nota.tipo                   = i-tipo
         AND consist-nota.mensagem               = i-mensagem:
         DELETE consist-nota.
    END.
  RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaConsistNota DBOProgram
PROCEDURE piCriaConsistNota PRIVATE:
    DEF INPUT PARAM de-calculado  AS DECIMAL NO-UNDO.
    DEF INPUT PARAM de-informado  AS DECIMAL NO-UNDO.
    DEF INPUT PARAM i-mensagem    AS INTEGER NO-UNDO. 
    DEF INPUT PARAM c-complemento AS CHARACTER NO-UNDO.
    DEF INPUT PARAM i-tipo        AS INTEGER NO-UNDO. 
          
    FIND FIRST consist-nota EXCLUSIVE-LOCK
         WHERE consist-nota.serie-docto            = docum-est.serie-docto
           AND consist-nota.nro-docto              = docum-est.nro-docto
           AND consist-nota.cod-emitente           = docum-est.cod-emitente
           AND consist-nota.nat-operacao           = docum-est.nat-operacao
           AND consist-nota.tipo                   = i-tipo
           AND consist-nota.mensagem               = i-mensagem
           AND consist-nota.int-1                  = item-doc-est.sequencia
           AND trim(SUBSTRING(consist-nota.char-1,1,10)) = c-complemento
           NO-ERROR.
    
    IF NOT AVAIL consist-nota THEN DO:
    
        create consist-nota.
        assign consist-nota.serie-docto  = docum-est.serie-docto
               consist-nota.nro-docto    = docum-est.nro-docto
               consist-nota.nat-operacao = docum-est.nat-operacao
               consist-nota.cod-emitente = docum-est.cod-emitente
               consist-nota.int-1        = item-doc-est.sequencia
               consist-nota.calculado    = de-calculado
               consist-nota.informado    = de-informado
               consist-nota.mensagem     = i-mensagem
               consist-nota.tipo         = i-tipo
               consist-nota.log-1        = no.
      ASSIGN OVERLAY(consist-nota.char-1,1,10) = c-complemento. 
    end.
    RELEASE consist-nota.
       
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTTContasErros DBOProgram
PROCEDURE getTTContasErros:
    DEF OUTPUT PARAM TABLE FOR tt-contas-erros.

RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obterValorTributo DBOProgram
PROCEDURE obterValorTributo PRIVATE:

    DEFINE INPUT  PARAMETER pc-nom-trib AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-valor   AS DECIMAL   NO-UNDO.
    
    DEFINE VARIABLE l-mono-retido-ant AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE de-valor-mono     AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-valor-mono-ret AS DECIMAL     NO-UNDO.
    ASSIGN pde-valor = 0
           de-valor-mono = 0
           de-valor-mono-ret = 0.

    IF NOT AVAIL item-doc-est THEN
        RETURN.
    ASSIGN l-mono-retido-ant = NO.    
    FOR FIRST item-doc-est-tribut NO-LOCK
        WHERE item-doc-est-tribut.cod-serie-docto  = item-doc-est.serie-docto 
          AND item-doc-est-tribut.cod-num-docto    = item-doc-est.nro-docto
          AND item-doc-est-tribut.cdn-emitente     = item-doc-est.cod-emitente
          AND item-doc-est-tribut.cod-natur-operac = item-doc-est.nat-operacao             
          AND item-doc-est-tribut.num-seq          = item-doc-est.sequencia
          AND item-doc-est-tribut.nom-trib         = rep.imp.Imposto:CBS
          AND item-doc-est-tribut.cod-campo = rep.imp.AtributoImposto:C-CLASS-TRIB:
          /*Monof†sico retido anterior Ç gravado no mesmo campo do monof†sico padr∆o e neste momento estamos considerando em n∆o contabilziar o moo retido anterior*/
          ASSIGN l-mono-retido-ant = CAN-FIND(FIRST class-trib NO-LOCK
                                              WHERE class-trib.cod-cclass-trib = TRIM(item-doc-est-tribut.cod-conteudo)
                                                AND class-trib.ind-tributo = 1 /*CBS/IBS*/
                                                AND class-trib.mono-retido-ant = 1).
    END.   

    FOR EACH item-doc-est-tribut NO-LOCK
       WHERE item-doc-est-tribut.cod-serie-docto   = item-doc-est.serie-docto
         AND item-doc-est-tribut.cod-num-docto     = item-doc-est.nro-docto
         AND item-doc-est-tribut.cdn-emitente      = item-doc-est.cod-emitente
         AND item-doc-est-tribut.cod-natur-operac  = item-doc-est.nat-operacao
         AND item-doc-est-tribut.num-seq           = item-doc-est.sequencia
         AND item-doc-est-tribut.nom-trib          = pc-nom-trib:
         
          
        IF  item-doc-est-tribut.cod-campo  <> rep.imp.AtributoImposto:VALOR
        AND item-doc-est-tribut.cod-campo  <> rep.imp.AtributoImposto:VALOR-MONO
        AND item-doc-est-tribut.cod-campo  <> rep.imp.AtributoImposto:VALOR-MONO-RET THEN 
            NEXT.
           
        CASE item-doc-est-tribut.cod-campo:
            WHEN rep.imp.AtributoImposto:VALOR THEN DO:
                IF DEC(REPLACE(item-doc-est-tribut.cod-conteudo,".",",")) > 0 THEN
                   ASSIGN pde-valor = DEC(REPLACE(item-doc-est-tribut.cod-conteudo,".",",")).
            END.
            WHEN rep.imp.AtributoImposto:VALOR-MONO THEN DO:
                IF DEC(REPLACE(item-doc-est-tribut.cod-conteudo,".",",")) > 0 THEN 
                   ASSIGN de-valor-mono = DEC(REPLACE(item-doc-est-tribut.cod-conteudo,".",",")).
                   
                IF item-doc-est-tribut.nom-trib  = rep.imp.Imposto:IBS-MUN THEN DO:
                    IF de-valor-mono > 0 THEN     
                       ASSIGN pde-valor = pde-valor + de-valor-mono.
                END. 
                ELSE DO:
                    IF l-mono-retido-ant = NO
                    AND de-valor-mono > 0 THEN     
                       ASSIGN pde-valor = pde-valor + de-valor-mono.
                END.
            END.
            WHEN rep.imp.AtributoImposto:VALOR-MONO-RET THEN DO:
                IF DEC(REPLACE(item-doc-est-tribut.cod-conteudo,".",",")) > 0 THEN
                   ASSIGN de-valor-mono-ret = DEC(REPLACE(item-doc-est-tribut.cod-conteudo,".",",")).
                   
                IF de-valor-mono-ret > 0 THEN     
                   ASSIGN pde-valor = pde-valor + de-valor-mono-ret.   
            END.
            
        END CASE.
    END.

    /*Deduá∆o do CrÇdito Presumido do IBS UF*/
    IF pc-nom-trib = rep.imp.Imposto:IBS-UF AND pde-valor > 0 THEN DO:

        FIND FIRST tt-deduzIbsItem NO-LOCK
             WHERE tt-deduzIbsItem.cod-serie-docto  = item-doc-est.serie-docto
               AND tt-deduzIbsItem.cod-num-docto    = item-doc-est.nro-docto
               AND tt-deduzIbsItem.cdn-emitente     = item-doc-est.cod-emitente
               AND tt-deduzIbsItem.cod-natur-operac = item-doc-est.nat-operacao
               AND tt-deduzIbsItem.num-seq          = item-doc-est.sequencia
               AND tt-deduzIbsItem.nom-trib         = pc-nom-trib NO-ERROR.

        IF AVAIL tt-deduzIbsItem AND tt-deduzIbsItem.deduz-ibs = TRUE THEN DO:

            /* Abate o valor do crÇdito presumido do valor do imposto */
            ASSIGN pde-valor = pde-valor - tt-deduzIbsItem.valor-ibs.

            /* Tratamento para evitar envio de valores negativos Ö contabilizaá∆o */
            IF pde-valor < 0 THEN
                ASSIGN pde-valor = 0.
        END.
    END.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processaLancamentoTributo DBOProgram
PROCEDURE processaLancamentoTributo PRIVATE:
    DEF INPUT PARAM pi-ind-tip-ctbz AS CHARACTER                      NO-UNDO.
    DEF INPUT PARAM pde-valor       AS DECIMAL                        NO-UNDO.
    DEF INPUT PARAM pc-conta-cr     LIKE docum-est.ct-transit         NO-UNDO.
    DEF INPUT PARAM pc-ccusto-cr    LIKE docum-est.sc-transit         NO-UNDO.
    DEF INPUT PARAM pc-unid-neg-cr  LIKE unid-neg-nota.cod_unid_negoc NO-UNDO.
    DEF INPUT PARAM pc-conta-db     LIKE docum-est.ct-transit         NO-UNDO.
    DEF INPUT PARAM pc-ccusto-db    LIKE docum-est.sc-transit         NO-UNDO.
    DEF INPUT PARAM pc-unid-neg-db  LIKE unid-neg-nota.cod_unid_negoc NO-UNDO.
              
    IF pde-valor > 0 THEN DO:
        //cria o lanáamento no crÇdito
        RUN criarLancRecebimento (INPUT pi-ind-tip-ctbz, INPUT IF i-tipo-docto = 1 THEN "CRED":U ELSE  "DEB":U, INPUT pc-conta-cr, INPUT pc-ccusto-cr, INPUT pc-unid-neg-cr, INPUT pde-valor).
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        //cria o lan?amento no d?bito
        RUN criarLancRecebimento (INPUT pi-ind-tip-ctbz, INPUT IF i-tipo-docto = 1 THEN "DEB":U ELSE "CRED":U, INPUT pc-conta-db, INPUT pc-ccusto-db, INPUT pc-unid-neg-db, INPUT pde-valor).
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criarLancRecebimento DBOProgram
PROCEDURE criarLancRecebimento PRIVATE:
    DEF INPUT PARAM pi-ind-tip-ctbz   AS CHARACTER                    NO-UNDO.
    DEF INPUT PARAM cTipo             AS CHARACTER                    NO-UNDO.
    DEF INPUT PARAM pc-ct-codigo   	  LIKE sumar-recebto.ct-codigo    NO-UNDO.
    DEF INPUT PARAM pc-sc-codigo   	  LIKE sumar-recebto.sc-codigo    NO-UNDO.
    DEF INPUT PARAM pc-cod-unid-negoc LIKE sumar-recebto.cod-unid-neg NO-UNDO.
    DEF INPUT PARAM pde-valor         AS DECIMAL                      NO-UNDO.

    /* Vari†veis para a convers∆o de moedas */
    DEFINE VARIABLE de-valor-moeda1 AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-valor-moeda2 AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-val-aux      AS DECIMAL NO-UNDO.
    DEFINE VARIABLE c-aux-msg       AS CHARACTER NO-UNDO.

    IF NOT AVAIL docum-est THEN
       RETURN "NOK":U.
    IF NOT AVAIL item-doc-est THEN
       RETURN "NOK":U.

    /* Inicializa as moedas alternativas */
    ASSIGN de-valor-moeda1 = 0
           de-valor-moeda2 = 0.

    /* L¢gica de convers∆o - Moeda Alternativa 1 / IFRS 1 */
    IF param-estoq.tem-moeda1 THEN DO:
        RUN cdp/cd0813.p ( 0, 1, pde-valor, docum-est.dt-trans, OUTPUT de-val-aux).

        IF de-val-aux <> ? THEN
           /* Assumindo que a funá∆o fn_ajust_dec est† dispon°vel ou utilizando ROUND/TRUNC nativo */
           ASSIGN de-valor-moeda1 = fn_ajust_dec(TRUNC(de-val-aux, 2), param-estoq.moeda1).
        ELSE DO:
           ASSIGN c-aux-msg = STRING(param-estoq.moeda1) + "~~" + STRING(docum-est.dt-trans).
           {method/svc/errors/inserr.i
               &ErrorNumber="316"
               &ErrorType="EMS"
               &ErrorSubType="ERROR"
               &ErrorParameters="c-aux-msg"}
        END.
    END.

    /* L¢gica de convers∆o - Moeda Alternativa 2 / IFRS 2 */
    IF param-estoq.tem-moeda2 THEN DO:
        RUN cdp/cd0813.p ( 0, 2, pde-valor, docum-est.dt-trans, OUTPUT de-val-aux).

        IF de-val-aux <> ? THEN
           ASSIGN de-valor-moeda2 = fn_ajust_dec(TRUNC(de-val-aux, 2), param-estoq.moeda2).
        ELSE DO:
           ASSIGN c-aux-msg = STRING(param-estoq.moeda2) + "~~" + STRING(docum-est.dt-trans).
           {method/svc/errors/inserr.i
               &ErrorNumber="316"
               &ErrorType="EMS"
               &ErrorSubType="ERROR"
               &ErrorParameters="c-aux-msg"}
        END.
    END.

    FIND FIRST bfsumar-recebto EXCLUSIVE-LOCK
         WHERE bfsumar-recebto.cod-estabel    = docum-est.cod-estabel
           AND bfsumar-recebto.serie-docto    = docum-est.serie-docto
           AND bfsumar-recebto.nro-docto      = docum-est.nro-docto
           AND bfsumar-recebto.cod-emitente   = docum-est.cod-emitente
           AND bfsumar-recebto.nat-operacao   = docum-est.nat-operacao
           AND bfsumar-recebto.seq-item       = item-doc-est.sequencia
           AND bfsumar-recebto.ct-codigo      = pc-ct-codigo
           AND bfsumar-recebto.sc-codigo      = pc-sc-codigo
           AND bfsumar-recebto.cod-unid-neg   = pc-cod-unid-negoc
           AND bfsumar-recebto.dt-trans       = docum-est.dt-trans
           AND bfsumar-recebto.ind-tipo-ctbz  = pi-ind-tip-ctbz
           AND bfsumar-recebto.idi-modul-orig = 1 //recebimento
           NO-ERROR.

    IF AVAIL bfsumar-recebto THEN DO:
        IF cTipo = 'CRED':U THEN
           ASSIGN bfsumar-recebto.valor-ctbl-credito[1] = bfsumar-recebto.valor-ctbl-credito[1] + pde-valor
                  bfsumar-recebto.valor-ctbl-credito[2] = bfsumar-recebto.valor-ctbl-credito[2] + de-valor-moeda1
                  bfsumar-recebto.valor-ctbl-credito[3] = bfsumar-recebto.valor-ctbl-credito[3] + de-valor-moeda2.

        IF cTipo = 'DEB':U THEN
           ASSIGN bfsumar-recebto.valor-ctbl-debito[1]  = bfsumar-recebto.valor-ctbl-debito[1]  + pde-valor
                  bfsumar-recebto.valor-ctbl-debito[2]  = bfsumar-recebto.valor-ctbl-debito[2]  + de-valor-moeda1
                  bfsumar-recebto.valor-ctbl-debito[3]  = bfsumar-recebto.valor-ctbl-debito[3]  + de-valor-moeda2.
    END.
    ELSE DO:
        RUN emptyRowObject.
        CREATE RowObject.
        ASSIGN RowObject.cod-estabel     = docum-est.cod-estabel
               RowObject.serie-docto     = docum-est.serie-docto
               RowObject.nro-docto       = docum-est.nro-docto
               RowObject.cod-emitente    = docum-est.cod-emitente
               RowObject.nat-operacao    = docum-est.nat-operacao
               RowObject.seq-item        = item-doc-est.sequencia
               RowObject.dt-trans        = docum-est.dt-trans
               RowObject.ind-tipo-ctbz   = pi-ind-tip-ctbz
               RowObject.ct-codigo       = pc-ct-codigo
               RowObject.sc-codigo       = pc-sc-codigo
               RowObject.cod-unid-neg    = pc-cod-unid-negoc

               /* Valores recebem o tratamento com o extent */
               RowObject.valor-ctbl-credito[1] = RowObject.valor-ctbl-credito[1] + (IF cTipo = 'CRED':U THEN pde-valor ELSE 0)
               RowObject.valor-ctbl-credito[2] = RowObject.valor-ctbl-credito[2] + (IF cTipo = 'CRED':U THEN de-valor-moeda1 ELSE 0)
               RowObject.valor-ctbl-credito[3] = RowObject.valor-ctbl-credito[3] + (IF cTipo = 'CRED':U THEN de-valor-moeda2 ELSE 0)

               RowObject.valor-ctbl-debito[1]  = RowObject.valor-ctbl-debito[1]  + (IF cTipo = 'DEB':U  THEN pde-valor ELSE 0)
               RowObject.valor-ctbl-debito[2]  = RowObject.valor-ctbl-debito[2]  + (IF cTipo = 'DEB':U  THEN de-valor-moeda1 ELSE 0)
               RowObject.valor-ctbl-debito[3]  = RowObject.valor-ctbl-debito[3]  + (IF cTipo = 'DEB':U  THEN de-valor-moeda2 ELSE 0)

               RowObject.dtm-sumarizacao = DATETIME-TZ(TODAY, MTIME,TIMEZONE)
               RowObject.num-id-recebto  = 0
               RowObject.idi-modul-orig  = 1.  //recebimento

        ASSIGN l-mat-unid-negoc = NO.
        RUN unidNegocAtiva (OUTPUT l-mat-unid-negoc).

        IF l-mat-unid-negoc THEN DO:
           ASSIGN  RowObject.cod-unid-neg    = pc-cod-unid-negoc.
        END.
       
        RUN emptyRowErrors.
        RUN createRecord.
        RUN getRowErrors (OUTPUT TABLE RowErrors).
         
        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
            RETURN "NOK":U.
    END.


    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE unidNegocAtiva DBOProgram
PROCEDURE unidNegocAtiva:
    DEFINE OUTPUT PARAM pUnidNegAtiva AS LOGICAL NO-UNDO.

    FIND FIRST param-mat NO-LOCK NO-ERROR.
    ASSIGN pUnidNegAtiva =  AVAIL param-mat AND   param-mat.ind-unid-neg.
   RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaContaCentroCusto DBOProgram
PROCEDURE validaContaCentroCusto PRIVATE:

        DEF VAR i-empresa          AS CHAR             NO-UNDO.
        DEF VAR v_log_utz_ccusto   AS LOG   INITIAL NO NO-UNDO.
        DEF VAR h_api_ccusto       AS HANDLE           NO-UNDO.
        DEF VAR h_api_cta_ctbl     AS HANDLE           NO-UNDO.

        DEF VAR v_cod_cta_ctbl       AS CHAR   NO-UNDO.
        DEF VAR v_titulo_cta_ctbl    AS CHAR   NO-UNDO.
        DEF VAR v_num_tip_cta_ctbl   AS INT    NO-UNDO.
        DEF VAR v_num_sit_cta_ctbl   AS INT    NO-UNDO.
        DEF VAR v_ind_finalid_cta    AS CHAR   NO-UNDO.
        DEF VAR v_cod_ccusto         AS CHAR   NO-UNDO.
        DEF VAR v_titulo_ccusto      AS CHAR   NO-UNDO.
        

        FOR FIRST estabelec FIELDS(ep-codigo)
             WHERE estabelec.cod-estabel = RowObject.cod-estabel NO-LOCK:
            ASSIGN i-empresa = estabelec.ep-codigo.
        END.
        IF RowObject.ct-codigo <> "":U THEN DO:
            ASSIGN c-literal-tribut = ''.
            {utp/ut-liter.i "Tributo" *}
            ASSIGN c-literal-tribut =  RETURN-VALUE + ': ' + RowObject.ind-tipo-ctbz .
           
            if not valid-handle(h_api_cta_ctbl)  then
               run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

            if not valid-handle(h_api_ccusto)  then
               run prgint/utb/utb742za.py persistent set h_api_ccusto.

           /* Busca dados da conta contabil */
           ASSIGN v_cod_cta_ctbl = RowObject.ct-codigo
                  v_cod_ccusto   = RowObject.sc-codigo.

           run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,                /* EMPRESA EMS2 */
                                                          input        "",                       /* PLANO DE CONTAS */
                                                          input-output v_cod_cta_ctbl,           /* CONTA */
                                                          input        today,/* DATA TRANSACAO */
                                                          output       v_titulo_cta_ctbl,        /* DESCRICAO CONTA */
                                                          output       v_num_tip_cta_ctbl,       /* TIPO DA CONTA */
                                                          output       v_num_sit_cta_ctbl,       /* SITUA¯∞O DA CONTA */
                                                          output       v_ind_finalid_cta,        /* FINALIDADES DA CONTA */
                                                          output table tt_log_erro).             /* ERROS */

           find first tt_log_erro no-lock no-error.
           if avail tt_log_erro then do:
                {utp/ut-liter.i "Seq" *}
                ASSIGN c-lb-seq = RETURN-VALUE.
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')'  + ' ' + c-lb-seq + ': ' +  string(RowObject.seq-item) + ', ' + c-literal-tribut + '~~~~' + tt_log_erro.ttv_des_msg_ajuda"}
           end.
           ELSE DO:
                run pi_valida_conta_contabil in h_api_cta_ctbl (input i-empresa,               /* EMPRESA EMS2 */
                                                                input RowObject.cod-estabel,   /* ESTABELECIMENTO EMS2 */
                                                                input RowObject.cod-unid-neg , /* UNIDADE NEG‡CIO */
                                                                input "",                      /* PLANO CONTAS */
                                                                input v_cod_cta_ctbl,          /* CONTA */
                                                                input "",                      /* PLANO CCUSTO */
                                                                input v_cod_ccusto,            /* CCUSTO */
                                                                input RowObject.dt-trans,      /* DATA TRANSACAO */
                                                                output table tt_log_erro).     /* ERROS */
                IF CAN-FIND (FIRST tt_log_erro) THEN DO:
                   {utp/ut-liter.i "Seq" *}
                   ASSIGN c-lb-seq = RETURN-VALUE.
                END.
                for each tt_log_erro:
                    {method/svc/errors/inserr.i &ErrorNumber="17006"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + ' ' + c-lb-seq + ': ' +  string(RowObject.seq-item) + ', ' + c-literal-tribut + '~~~~' + tt_log_erro.ttv_des_msg_ajuda"}
                end.
                if not avail tt_log_erro then do:

                   /* Verifica se a conta utiliza centro de custo */
                    run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,                /* EMPRESA EMS 2 */
                                                                       input  RowObject.cod-estabel,    /* ESTABELECIMENTO EMS2 */
                                                                       input  "",                       /* PLANO CONTAS */
                                                                       input  v_cod_cta_ctbl,           /* CONTA */
                                                                       input  RowObject.dt-trans,       /* DT TRANSACAO */
                                                                       output v_log_utz_ccusto,         /* UTILIZA CCUSTO ? */
                                                                       output table tt_log_erro).       /* ERROS */
                    IF CAN-FIND (FIRST tt_log_erro) THEN DO:
                       {utp/ut-liter.i "Seq" *}
                       ASSIGN c-lb-seq = RETURN-VALUE.
                    END.
                                                                                       
                    for each tt_log_erro:
                        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')'  + ' ' + c-lb-seq + ': ' +  string(RowObject.seq-item) + ', ' + c-literal-tribut + '~~~~' + tt_log_erro.ttv_des_msg_ajuda"}
                    end.
                    if not avail tt_log_erro then do:

                        IF v_log_utz_ccusto THEN DO:
                            /* Busca dados do centro de custo */
                            run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,            /* EMPRESA EMS2 */
                                                                       input  "",                   /* CODIGO DO PLANO CCUSTO */
                                                                       input  v_cod_ccusto,         /* CCUSTO */
                                                                       input  RowObject.dt-trans,   /* DATA DE TRANSACAO */
                                                                       output v_titulo_ccusto,      /* DESCRICAO DO CCUSTO */
                                                                       output table tt_log_erro).   /* ERROS */

                            find first tt_log_erro no-lock no-error.
                            if avail tt_log_erro then do:
                                {utp/ut-liter.i "Seq" *}
                                ASSIGN c-lb-seq = RETURN-VALUE.
                                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="ERROR"
                                                        &ErrorParameters="STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')'  + ' ' + c-lb-seq + ': ' +  string(RowObject.seq-item) + ', ' + c-literal-tribut  + '~~~~' + tt_log_erro.ttv_des_msg_ajuda"}
                            end.
                        end.
                    end.
                end.
           END.

        END.
    FINALLY:
        DELETE PROCEDURE h_api_cta_ctbl NO-ERROR.
        DELETE PROCEDURE h_api_ccusto NO-ERROR.
    END FINALLY.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaUnidadeNegocio DBOProgram
PROCEDURE validaUnidadeNegocio PRIVATE:
    DEFINE VARIABLE h-cdapi024 AS HANDLE      NO-UNDO.

     
    FIND FIRST unid-negoc
        WHERE unid-negoc.cod-unid-negoc = RowObject.cod-unid-neg NO-LOCK NO-ERROR.
    IF  NOT AVAIL unid-negoc THEN DO:
        {utp/ut-liter.i Unidade_de_Neg¢cio * r}
        {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType = "ERROR":U
                    &ErrorParameters="RETURN-VALUE"}
        RETURN "NOK":U.
    END.
    
    IF NOT VALID-HANDLE(h-cdapi024) THEN
       RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.

    IF  VALID-HANDLE(h-cdapi024) THEN DO:
        EMPTY TEMP-TABLE tt-erro.
        /*Valida se a UN pode ser utilizada pelo Estabelecimento*/
        RUN validaUnidadeNegocioEstabel IN h-cdapi024 (INPUT  RowObject.cod-estabel,
                                                       INPUT  RowObject.dt-trans,
                                                       INPUT  RowObject.cod-unid-neg,
                                                       OUTPUT TABLE tt-erro).


        /*Valida ser a UN pode ser utilizada pelo Usu†rio*/
        RUN validaUnidadeNegocioUsuario IN h-cdapi024 (INPUT  c-seg-usuario,
                                                       INPUT  RowObject.cod-unid-neg,
                                                       OUTPUT TABLE tt-erro APPEND).
        IF CAN-FIND (FIRST tt-erro) THEN DO:
            {utp/ut-liter.i "Seq" *}
            ASSIGN c-lb-seq = RETURN-VALUE.
            
             ASSIGN c-literal-tribut = ''.
            {utp/ut-liter.i "Tributo" *}
            ASSIGN c-literal-tribut =  RETURN-VALUE + ': ' + RowObject.ind-tipo-ctbz .
                
        END.
        FOR EACH tt-erro:
             ASSIGN tt-erro.mensagem = tt-erro.mensagem + c-lb-seq + ': ' +  string(RowObject.seq-item) + ', ' + c-literal-tribut. 
             RUN _insertErrorManual IN THIS-PROCEDURE (INPUT tt-erro.cd-erro,  /* pErrorNumber      */
                                                      INPUT "EMS",            /* pErrorType        */
                                                      INPUT "Error",          /* pErrorSubType     */
                                                      INPUT tt-erro.mensagem, /* pErrorDescription */
                                                      INPUT "",               /* pErrorHelp        */
                                                      INPUT "").              /* pErrorParameters  */
        END.
    END.



    RETURN "OK":U.
    FINALLY:
        IF VALID-HANDLE(h-cdapi024) THEN DO:
           DELETE PROCEDURE h-cdapi024 NO-ERROR.
           ASSIGN h-cdapi024 = ?.
        END.
    END FINALLY.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    IF pType = 'CREATE':U THEN DO:
        IF CAN-FIND (FIRST bfsumar-recebto NO-LOCK
                     WHERE bfsumar-recebto.cod-estabel    = RowObject.cod-estabel
                       AND bfsumar-recebto.serie-docto    = RowObject.serie-docto
                       AND bfsumar-recebto.nro-docto      = RowObject.nro-docto
                       AND bfsumar-recebto.cod-emitente   = RowObject.cod-emitente
                       AND bfsumar-recebto.nat-operacao   = RowObject.nat-operacao
                       AND bfsumar-recebto.seq-item       = RowObject.seq-item
                       AND bfsumar-recebto.ct-codigo      = RowObject.ct-codigo
                       AND bfsumar-recebto.sc-codigo      = RowObject.sc-codigo
                       AND bfsumar-recebto.cod-unid-neg   = RowObject.cod-unid-neg
                       AND bfsumar-recebto.dt-trans       = RowObject.dt-trans
                       AND bfsumar-recebto.ind-tipo-ctbz  = RowObject.ind-tipo-ctbz
                       AND bfsumar-recebto.idi-modul-orig = RowObject.idi-modul-orig ) THEN DO:

            {utp/ut-liter.i "Sumarizaá∆o_contas_recebimento" *}
            {method/svc/errors/inserr.i &ErrorNumber="1"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.

        RUN validaContaCentroCusto.

        ASSIGN l-mat-unid-negoc = NO.
        RUN unidNegocAtiva (OUTPUT l-mat-unid-negoc).

        IF l-mat-unid-negoc THEN DO:
           RUN validaUnidadeNegocio.
    END.
    
     
    END.
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaGradeContabil DBOProgram
PROCEDURE retornaGradeContabil :
/*:T------------------------------------------------------------------------------
  Purpose:     Retornar a grade cont bil do documento
  Parameters:  chave do documento
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pc-serie-docto  LIKE sumar-recebto.serie-docto  NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nro-docto    LIKE sumar-recebto.nro-docto    NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cod-emitente LIKE sumar-recebto.cod-emitente NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nat-operacao LIKE sumar-recebto.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-sumar-recebto-grade.

    EMPTY TEMP-TABLE tt-sumar-recebto-grade.

    FOR EACH sumar-recebto
       WHERE sumar-recebto.serie-docto  = pc-serie-docto
         AND sumar-recebto.nro-docto    = pc-nro-docto
         AND sumar-recebto.cod-emitente = pi-cod-emitente
         AND sumar-recebto.nat-operacao = pc-nat-operacao NO-LOCK:

        FIND FIRST tt-sumar-recebto-grade
             WHERE tt-sumar-recebto-grade.serie-docto      = sumar-recebto.serie-docto
               AND tt-sumar-recebto-grade.nro-docto        = sumar-recebto.nro-docto
               AND tt-sumar-recebto-grade.cod-emitente     = sumar-recebto.cod-emitente
               AND tt-sumar-recebto-grade.nat-operacao     = sumar-recebto.nat-operacao
               AND tt-sumar-recebto-grade.cod-unid-neg     = sumar-recebto.cod-unid-neg
               AND tt-sumar-recebto-grade.ct-codigo        = sumar-recebto.ct-codigo
               AND tt-sumar-recebto-grade.sc-codigo        = sumar-recebto.sc-codigo NO-ERROR.

        IF  NOT AVAIL tt-sumar-recebto-grade THEN DO:
            CREATE tt-sumar-recebto-grade.
            BUFFER-COPY sumar-recebto EXCEPT valor-ctbl-credito valor-ctbl-debito TO tt-sumar-recebto-grade.
        END.

        ASSIGN tt-sumar-recebto-grade.valor-ctbl-credito[1] = tt-sumar-recebto-grade.valor-ctbl-credito[1] + sumar-recebto.valor-ctbl-credito[1]
               tt-sumar-recebto-grade.valor-ctbl-credito[2] = tt-sumar-recebto-grade.valor-ctbl-credito[2] + sumar-recebto.valor-ctbl-credito[2]
               tt-sumar-recebto-grade.valor-ctbl-credito[3] = tt-sumar-recebto-grade.valor-ctbl-credito[3] + sumar-recebto.valor-ctbl-credito[3]

               tt-sumar-recebto-grade.valor-ctbl-debito[1]  = tt-sumar-recebto-grade.valor-ctbl-debito[1]  + sumar-recebto.valor-ctbl-debito[1]
               tt-sumar-recebto-grade.valor-ctbl-debito[2]  = tt-sumar-recebto-grade.valor-ctbl-debito[2]  + sumar-recebto.valor-ctbl-debito[2]
               tt-sumar-recebto-grade.valor-ctbl-debito[3]  = tt-sumar-recebto-grade.valor-ctbl-debito[3]  + sumar-recebto.valor-ctbl-debito[3].

    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE desatualizaContabilidade BOIN01167
PROCEDURE desatualizaContabilidade :
/*------------------------------------------------------------------------------
  Purpose:     Limpa os dados de integraá∆o cont†bil da sumar-recebto e do
               documento f°sico no estoque.
  Parameters:  INPUT pr-sumar-recebto AS ROWID
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pr-sumar-recebto AS ROWID NO-UNDO.

    DEFINE BUFFER bf-sumar-recebto FOR sumar-recebto.
    DEFINE BUFFER bf-docum-est     FOR docum-est.

    /* Busca o registro que ser† descontabilizado de forma exclusiva */
    FIND FIRST bf-sumar-recebto EXCLUSIVE-LOCK
         WHERE ROWID(bf-sumar-recebto) = pr-sumar-recebto NO-ERROR.

    IF AVAILABLE bf-sumar-recebto THEN DO:
        /* Limpa os campos da sumar-recebto referentes Ö contabilizaá∆o */
        ASSIGN bf-sumar-recebto.dtm-contabilizacao = ?
               bf-sumar-recebto.log-ctbzdo         = NO
               bf-sumar-recebto.num-id-movto-ctbl  = 0
               bf-sumar-recebto.refer-ctbl         = "":U
               bf-sumar-recebto.cod-usuario-ctbz   = "":U.

        /* Busca o documento no estoque para desmarcar a flag log-ctbl-atual */
        FIND FIRST bf-docum-est EXCLUSIVE-LOCK
             WHERE bf-docum-est.cod-estabel  = bf-sumar-recebto.cod-estabel
               AND bf-docum-est.serie-docto  = bf-sumar-recebto.serie-docto
               AND bf-docum-est.nro-docto    = bf-sumar-recebto.nro-docto
               AND bf-docum-est.cod-emitente = bf-sumar-recebto.cod-emitente
               AND bf-docum-est.nat-operacao = bf-sumar-recebto.nat-operacao
             NO-ERROR.

        IF AVAILABLE bf-docum-est THEN DO:
            ASSIGN bf-docum-est.log-ctbl-atual = NO.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaMovtoSumarRecebto BOIN01167
PROCEDURE verificaMovtoSumarRecebto :
/*------------------------------------------------------------------------------
  Purpose:     Là a tabela sumar-recebto e separa os
               documentos na temp-table de fila para integraá∆o.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-estabel  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-dt-trans-ini AS DATE      NO-UNDO.
    DEFINE INPUT  PARAMETER p-dt-trans-fim AS DATE      NO-UNDO.
    DEFINE INPUT  PARAMETER p-usuario      AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-tipo-gerac   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-log-ctbz.

    OUTPUT STREAM s_1 TO VALUE(SESSION:TEMP-DIRECTORY + "fgl900zo.txt":U) PAGED PAGE-SIZE VALUE(65) CONVERT TARGET "iso8859-1":U.

    EMPTY TEMP-TABLE tt-movto-ctbz.
    EMPTY TEMP-TABLE tt-log-ctbz.

    FOR EACH sumar-recebto NO-LOCK
       WHERE sumar-recebto.cod-estabel  = p-cod-estabel
         AND sumar-recebto.dt-trans    >= p-dt-trans-ini
         AND sumar-recebto.dt-trans    <= p-dt-trans-fim
         AND sumar-recebto.log-ctbzdo  =  NO:

         FIND FIRST docum-est NO-LOCK
              WHERE docum-est.cod-estabel  = sumar-recebto.cod-estabel
                AND docum-est.serie-docto  = sumar-recebto.serie-docto
                AND docum-est.nro-docto    = sumar-recebto.nro-docto
                AND docum-est.cod-emitente = sumar-recebto.cod-emitente
                AND docum-est.nat-operacao = sumar-recebto.nat-operacao NO-ERROR.

         IF AVAILABLE docum-est THEN DO:

             CREATE tt-movto-ctbz.
             ASSIGN tt-movto-ctbz.dt-trans = IF p-tipo-gerac = "Lote" THEN p-dt-trans-fim ELSE sumar-recebto.dt-trans
                    tt-movto-ctbz.refer-ctbl = "RE":U + REPLACE(STRING(tt-movto-ctbz.dt-trans, "99/99/9999":U), "/":U, "":U) + sumar-recebto.cod-estabel.
                    tt-movto-ctbz.r-rowid  = ROWID(sumar-recebto).
         END.

    END.

    /* Se encontrou documentos para integrar, chama a procedure respons†vel pela integraá∆o */
    IF CAN-FIND(FIRST tt-movto-ctbz) THEN DO:
        RUN integraContabilidade (INPUT p-usuario, OUTPUT TABLE tt-log-ctbz).
    END.

    OUTPUT STREAM s_1 CLOSE.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE integraContabilidade BOIN01167
PROCEDURE integraContabilidade PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Recebe a fila de documentos (tt-movto-ctbz), agrupa os registros
               em lotes e chama a API de integraá∆o do FGL (fg1900zo).
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-usuario AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-log-ctbz.

    DEFINE VARIABLE v_hdl_fgl900zo AS HANDLE  NO-UNDO.
    DEFINE VARIABLE v_hdl_utb742za AS HANDLE  NO-UNDO.
    DEFINE VARIABLE v_hdl_utb743za AS HANDLE  NO-UNDO.

    DEFINE VARIABLE rttLote        AS RECID   NO-UNDO.
    DEFINE VARIABLE rttLancto      AS RECID   NO-UNDO.
    DEFINE VARIABLE rttItem        AS RECID   NO-UNDO.
    DEFINE VARIABLE v-num-lancto   AS INTEGER NO-UNDO.
    DEFINE VARIABLE v-seq-item     AS INTEGER NO-UNDO.

    DEFINE VARIABLE rttLanctoIfrs1         AS RECID     NO-UNDO.
    DEFINE VARIABLE rttLanctoIfrs2         AS RECID     NO-UNDO.
    DEFINE VARIABLE v-seq-item-ifrs1       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE v-seq-item-ifrs2       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE l-gera-ifrs1           AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE l-gera-ifrs2           AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE v_cod_indic_econ_if1   AS CHARACTER NO-UNDO INITIAL "".
    DEFINE VARIABLE v_cod_indic_econ_if2   AS CHARACTER NO-UNDO INITIAL "".
    DEFINE VARIABLE v_cod_finalid_econ_if1 AS CHARACTER NO-UNDO INITIAL "".
    DEFINE VARIABLE v_cod_finalid_econ_if2 AS CHARACTER NO-UNDO INITIAL "".
    DEFINE VARIABLE v_hdl_fgl920za         AS HANDLE    NO-UNDO.
    DEFINE VARIABLE v_cod_cenar_fiscal     AS CHARACTER NO-UNDO INITIAL "".

    DEFINE VARIABLE v_cod_empresa        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE v_cod_estabelec      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE v_cod_indic_econ     AS CHARACTER NO-UNDO INITIAL "".
    DEFINE VARIABLE v_cod_finalid_econ   AS CHARACTER NO-UNDO INITIAL "".
    DEFINE VARIABLE v_cod_plano_cta_ctbl AS CHARACTER NO-UNDO INITIAL "".
    DEFINE VARIABLE v_cod_plano_ccusto   AS CHARACTER NO-UNDO INITIAL "".
    DEFINE VARIABLE l-erro-plano         AS LOGICAL   NO-UNDO.

    DEFINE BUFFER b-movto-ctbz FOR tt-movto-ctbz.
    DEFINE BUFFER b-sumar      FOR sumar-recebto.
    DEFINE BUFFER b-docum      FOR docum-est.
    DEFINE BUFFER b-estab      FOR estabelec.

    RUN prgfin/fgl/fgl900zo.py PERSISTENT SET v_hdl_fgl900zo NO-ERROR.
    RUN prgint/utb/utb742za.py PERSISTENT SET v_hdl_utb742za NO-ERROR.
    RUN prgint/utb/utb743za.py PERSISTENT SET v_hdl_utb743za NO-ERROR.

    FOR EACH tt-movto-ctbz BREAK BY tt-movto-ctbz.dt-trans:

        /* Prepara LOTE e LANÄAMENTO ÈNICO uma vez por grupo */
        IF FIRST-OF(tt-movto-ctbz.dt-trans) THEN DO:

            EMPTY TEMP-TABLE tt_integr_lote_ctbl_1.
            EMPTY TEMP-TABLE tt_integr_lancto_ctbl_1.
            EMPTY TEMP-TABLE tt_integr_item_lancto_ctbl_1.
            EMPTY TEMP-TABLE tt_integr_aprop_lancto_ctbl_1.
            EMPTY TEMP-TABLE tt_integr_ctbl_valid_1.
            EMPTY TEMP-TABLE tt_params_generic_api.
            EMPTY TEMP-TABLE tt_log_erros.

            ASSIGN v-num-lancto = 10
                   v-seq-item   = 0
                   l-erro-plano = NO.

            FIND FIRST b-sumar NO-LOCK WHERE ROWID(b-sumar) = tt-movto-ctbz.r-rowid NO-ERROR.
            FIND FIRST b-estab NO-LOCK WHERE b-estab.cod-estabel = b-sumar.cod-estabel NO-ERROR.

            /* --- Resolve parametrizaá∆o de cen†rio IFRS --- */
            IF NOT AVAILABLE param-estoq THEN
                FIND FIRST param-estoq NO-LOCK NO-ERROR.

            ASSIGN v-seq-item-ifrs1       = 0
                   v-seq-item-ifrs2       = 0
                   rttLanctoIfrs1         = ?
                   rttLanctoIfrs2         = ?
                   v_cod_indic_econ_if1   = "":U
                   v_cod_indic_econ_if2   = "":U
                   v_cod_finalid_econ_if1 = "":U
                   v_cod_finalid_econ_if2 = "":U
                   l-gera-ifrs1 = AVAILABLE param-estoq
                                   AND param-estoq.tem-moeda1
                                   AND param-estoq.log-moed-ifrs-1
                                   AND param-estoq.cod-cenar-ifrs-1 <> "":U
                   l-gera-ifrs2 = AVAILABLE param-estoq
                                   AND param-estoq.tem-moeda2
                                   AND param-estoq.log-moed-ifrs-2
                                   AND param-estoq.cod-cenar-ifrs-2 <> "":U.

            ASSIGN v_cod_cenar_fiscal = "":U.

            /* --- Resolve cen†rio fiscal para enviar no lanáamento em moeda corrente quando houver cen†rio IFRS --- */
            IF l-gera-ifrs1 OR l-gera-ifrs2 THEN DO:
                IF NOT VALID-HANDLE(v_hdl_fgl920za) THEN
                    RUN prgfin/fgl/fgl920za.py PERSISTENT SET v_hdl_fgl920za NO-ERROR.

                IF VALID-HANDLE(v_hdl_fgl920za) THEN DO:
                    EMPTY TEMP-TABLE tt_cenar_ctbl_ems5.
                    EMPTY TEMP-TABLE tt_erro_fgl.
                    RUN pi_main_retorna_cenar_ctbl_empres_1 IN v_hdl_fgl920za
                        (INPUT  IF AVAILABLE b-estab THEN b-estab.ep-codigo ELSE "":U,
                         INPUT  tt-movto-ctbz.dt-trans,
                         OUTPUT TABLE tt_cenar_ctbl_ems5,
                         OUTPUT TABLE tt_erro_fgl).

                    FIND FIRST tt_cenar_ctbl_ems5
                         WHERE tt_cenar_ctbl_ems5.tta_log_cenar_fisc = YES NO-ERROR.
                    IF AVAILABLE tt_cenar_ctbl_ems5 THEN
                        ASSIGN v_cod_cenar_fiscal = tt_cenar_ctbl_ems5.tta_cod_cenar_ctbl.
                END.
            END.

            /* Busca Plano de Centro de Custo */
            IF VALID-HANDLE(v_hdl_utb742za) THEN DO:

                ASSIGN v_cod_finalid_econ      = "":U
                       v_cod_plano_ccusto      = "":U
                       v_cod_plano_cta_ctbl    = "":U.

                /* Traduz Moeda e Finalidade Economica (Padr∆o utb786za) */
                EMPTY TEMP-TABLE tt_xml_input_output.

                CREATE tt_xml_input_output.
                ASSIGN tt_xml_input_output.ttv_cod_label    = "Funá∆o":U
                       tt_xml_input_output.ttv_des_conteudo = "Contabilizaá‰es 2.00":U
                       tt_xml_input_output.ttv_num_seq_1    = 1.

                CREATE tt_xml_input_output.
                ASSIGN tt_xml_input_output.ttv_cod_label    = "Produto":U
                       tt_xml_input_output.ttv_des_conteudo = "EMS 5":U
                       tt_xml_input_output.ttv_num_seq_1    = 1.

                CREATE tt_xml_input_output.
                ASSIGN tt_xml_input_output.ttv_cod_label    = "Empresa":U
                       tt_xml_input_output.ttv_des_conteudo = IF AVAILABLE b-estab THEN b-estab.ep-codigo ELSE ""
                       tt_xml_input_output.ttv_num_seq_1    = 1.
                CREATE tt_xml_input_output.
                ASSIGN tt_xml_input_output.ttv_cod_label    = "Estabel":U
                       tt_xml_input_output.ttv_des_conteudo = b-sumar.cod-estabel
                       tt_xml_input_output.ttv_num_seq_1    = 1.
                CREATE tt_xml_input_output.
                ASSIGN tt_xml_input_output.ttv_cod_label    = "Moeda":U
                       tt_xml_input_output.ttv_des_conteudo = "0;" + STRING(tt-movto-ctbz.dt-trans, "99/99/9999":U)
                       tt_xml_input_output.ttv_num_seq_1    = 1.
                CREATE tt_xml_input_output.
                ASSIGN tt_xml_input_output.ttv_cod_label    = "Finalid":U
                       tt_xml_input_output.ttv_des_conteudo = "0":U /* 0 = Corrente */
                       tt_xml_input_output.ttv_num_seq_1    = 1.

                /* --- Moeda/Finalidade IFRS-1 (seq 2) e IFRS-2 (seq 3), mesma chamada de traduá∆o --- */
                IF l-gera-ifrs1 THEN DO:
                    CREATE tt_xml_input_output.
                    ASSIGN tt_xml_input_output.ttv_cod_label    = "Moeda":U
                           tt_xml_input_output.ttv_des_conteudo = STRING(param-estoq.moeda1) + ";" + STRING(tt-movto-ctbz.dt-trans, "99/99/9999":U)
                           tt_xml_input_output.ttv_num_seq_1    = 2.
                    CREATE tt_xml_input_output.
                    ASSIGN tt_xml_input_output.ttv_cod_label    = "Finalid":U
                           tt_xml_input_output.ttv_des_conteudo = STRING(param-estoq.moeda1)
                           tt_xml_input_output.ttv_num_seq_1    = 2.
                END.

                IF l-gera-ifrs2 THEN DO:
                    CREATE tt_xml_input_output.
                    ASSIGN tt_xml_input_output.ttv_cod_label    = "Moeda":U
                           tt_xml_input_output.ttv_des_conteudo = STRING(param-estoq.moeda2) + ";" + STRING(tt-movto-ctbz.dt-trans, "99/99/9999":U)
                           tt_xml_input_output.ttv_num_seq_1    = 3.
                    CREATE tt_xml_input_output.
                    ASSIGN tt_xml_input_output.ttv_cod_label    = "Finalid":U
                           tt_xml_input_output.ttv_des_conteudo = STRING(param-estoq.moeda2)
                           tt_xml_input_output.ttv_num_seq_1    = 3.
                END.

                RUN prgint/utb/utb786za.py (INPUT-OUTPUT TABLE tt_xml_input_output, OUTPUT TABLE tt_log_erros).
                IF CAN-FIND(FIRST tt_log_erros) THEN ASSIGN l-erro-plano = YES.

                FOR EACH tt_xml_input_output:

                    IF tt_xml_input_output.ttv_cod_label = "Empresa":U THEN
                      ASSIGN v_cod_empresa = tt_xml_input_output.ttv_des_conteudo_aux.

                    IF tt_xml_input_output.ttv_cod_label = "Estabel":U THEN
                      ASSIGN v_cod_estabelec = tt_xml_input_output.ttv_des_conteudo_aux.

                    IF tt_xml_input_output.ttv_cod_label = "Moeda":U AND
                       tt_xml_input_output.ttv_num_seq_1 = 1 THEN
                      ASSIGN v_cod_indic_econ = tt_xml_input_output.ttv_des_conteudo_aux.

                    IF tt_xml_input_output.ttv_cod_label = "Finalid":U AND
                       tt_xml_input_output.ttv_num_seq_1 = 1 THEN
                      ASSIGN v_cod_finalid_econ = tt_xml_input_output.ttv_des_conteudo_aux.

                    /* --- IFRS-1 / IFRS-2 --- */
                    IF tt_xml_input_output.ttv_cod_label = "Moeda":U AND
                       tt_xml_input_output.ttv_num_seq_1 = 2 THEN
                      ASSIGN v_cod_indic_econ_if1 = tt_xml_input_output.ttv_des_conteudo_aux.

                    IF tt_xml_input_output.ttv_cod_label = "Finalid":U AND
                       tt_xml_input_output.ttv_num_seq_1 = 2 THEN
                      ASSIGN v_cod_finalid_econ_if1 = tt_xml_input_output.ttv_des_conteudo_aux.

                    IF tt_xml_input_output.ttv_cod_label = "Moeda":U AND
                       tt_xml_input_output.ttv_num_seq_1 = 3 THEN
                      ASSIGN v_cod_indic_econ_if2 = tt_xml_input_output.ttv_des_conteudo_aux.

                    IF tt_xml_input_output.ttv_cod_label = "Finalid":U AND
                       tt_xml_input_output.ttv_num_seq_1 = 3 THEN
                      ASSIGN v_cod_finalid_econ_if2 = tt_xml_input_output.ttv_des_conteudo_aux.

                END.

                EMPTY TEMP-TABLE tt_log_erro.
                RUN pi_busca_plano_ccusto_empresa IN v_hdl_utb742za
                    (INPUT IF AVAILABLE b-estab THEN b-estab.ep-codigo ELSE "",
                     INPUT tt-movto-ctbz.dt-trans,
                     OUTPUT v_cod_plano_ccusto,
                     OUTPUT TABLE tt_log_erro).
                IF CAN-FIND(FIRST tt_log_erro) THEN ASSIGN l-erro-plano = YES.
            END.

            /* Busca Plano de Contas Cont†bil */
            IF VALID-HANDLE(v_hdl_utb743za) THEN DO:
                EMPTY TEMP-TABLE tt_log_erro.
                RUN pi_busca_plano_cta_ctbl_empresa IN v_hdl_utb743za
                    (INPUT IF AVAILABLE b-estab THEN b-estab.ep-codigo ELSE "",
                     INPUT tt-movto-ctbz.dt-trans,
                     OUTPUT v_cod_plano_cta_ctbl,
                     OUTPUT TABLE tt_log_erro).
                IF CAN-FIND(FIRST tt_log_erro) THEN ASSIGN l-erro-plano = YES.
            END.

            IF l-erro-plano = NO THEN DO:
                /* 1. Cria o Lote */
                CREATE tt_integr_lote_ctbl_1.
                ASSIGN tt_integr_lote_ctbl_1.tta_cod_modul_dtsul      = "MRE":U
                       tt_integr_lote_ctbl_1.tta_cod_empresa          = v_cod_empresa
                       tt_integr_lote_ctbl_1.tta_num_lote_ctbl        = ?
                       tt_integr_lote_ctbl_1.tta_des_lote_ctbl        = tt-movto-ctbz.refer-ctbl
                       tt_integr_lote_ctbl_1.tta_dat_lote_ctbl        = TODAY
                       tt_integr_lote_ctbl_1.ttv_rec_integr_lote_ctbl = &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF(tt_integr_lote_ctbl_1)
                       rttLote                                        = &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF(tt_integr_lote_ctbl_1).

                /* 2. Cria o Lanáamento em moeda corrente (cen†rio fiscal quando houver IFRS, sen∆o em branco) */
                CREATE tt_integr_lancto_ctbl_1.
                ASSIGN tt_integr_lancto_ctbl_1.tta_cod_cenar_ctbl        = v_cod_cenar_fiscal
                       tt_integr_lancto_ctbl_1.tta_num_lancto_ctbl        = v-num-lancto
                       tt_integr_lancto_ctbl_1.tta_dat_lancto_ctbl        = tt-movto-ctbz.dt-trans
                       tt_integr_lancto_ctbl_1.ttv_rec_integr_lote_ctbl   = rttLote
                       tt_integr_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl = &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF (tt_integr_lancto_ctbl_1)
                       rttLancto                                          = &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF (tt_integr_lancto_ctbl_1).

                /* --- Lanáamentos adicionais no mesmo lote por cen†rio IFRS --- */
                IF l-gera-ifrs1 THEN DO:
                    ASSIGN v-num-lancto = v-num-lancto + 10.
                    CREATE tt_integr_lancto_ctbl_1.
                    ASSIGN tt_integr_lancto_ctbl_1.tta_cod_cenar_ctbl        = param-estoq.cod-cenar-ifrs-1
                           tt_integr_lancto_ctbl_1.tta_num_lancto_ctbl       = v-num-lancto
                           tt_integr_lancto_ctbl_1.tta_dat_lancto_ctbl       = tt-movto-ctbz.dt-trans
                           tt_integr_lancto_ctbl_1.ttv_rec_integr_lote_ctbl  = rttLote
                           tt_integr_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl = &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF (tt_integr_lancto_ctbl_1)
                           rttLanctoIfrs1                                    = &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF (tt_integr_lancto_ctbl_1).
                END.

                IF l-gera-ifrs2 THEN DO:
                    ASSIGN v-num-lancto = v-num-lancto + 10.
                    CREATE tt_integr_lancto_ctbl_1.
                    ASSIGN tt_integr_lancto_ctbl_1.tta_cod_cenar_ctbl        = param-estoq.cod-cenar-ifrs-2
                           tt_integr_lancto_ctbl_1.tta_num_lancto_ctbl       = v-num-lancto
                           tt_integr_lancto_ctbl_1.tta_dat_lancto_ctbl       = tt-movto-ctbz.dt-trans
                           tt_integr_lancto_ctbl_1.ttv_rec_integr_lote_ctbl  = rttLote
                           tt_integr_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl = &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF (tt_integr_lancto_ctbl_1)
                           rttLanctoIfrs2                                    = &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF (tt_integr_lancto_ctbl_1).
                END.

            END.
        END.

        /* Cria apenas os ITENS individuais (atrelados ao mesmo Lanáamento) */
        IF l-erro-plano = NO THEN DO:
            FIND FIRST sumar-recebto NO-LOCK WHERE ROWID(sumar-recebto) = tt-movto-ctbz.r-rowid NO-ERROR.
            IF AVAILABLE sumar-recebto THEN DO:

                /* Item e Apropriaá∆o: DêBITO */
                IF sumar-recebto.valor-ctbl-debito[1] > 0 THEN DO:
                    ASSIGN v-seq-item = v-seq-item + 10.
                    CREATE tt_integr_item_lancto_ctbl_1.
                    ASSIGN tt_integr_item_lancto_ctbl_1.tta_num_seq_lancto_ctbl         = v-seq-item
                           tt_integr_item_lancto_ctbl_1.tta_ind_natur_lancto_ctbl       = "DB":U
                           tt_integr_item_lancto_ctbl_1.tta_cod_cta_ctbl                = sumar-recebto.ct-codigo
                           tt_integr_item_lancto_ctbl_1.tta_cod_estab                   = sumar-recebto.cod-estabel
                           tt_integr_item_lancto_ctbl_1.tta_cod_unid_negoc              = sumar-recebto.cod-unid-neg
                           tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl      = "Contabilizaá∆o Recebimento - " + STRING(sumar-recebto.dt-trans, "99/99/9999")
                           tt_integr_item_lancto_ctbl_1.tta_dat_docto                   = sumar-recebto.dt-trans
                           tt_integr_item_lancto_ctbl_1.tta_dat_lancto_ctbl             = sumar-recebto.dt-trans
                           tt_integr_item_lancto_ctbl_1.tta_val_lancto_ctbl             = sumar-recebto.valor-ctbl-debito[1]
                           tt_integr_item_lancto_ctbl_1.tta_cod_ccusto                  = sumar-recebto.sc-codigo
                           tt_integr_item_lancto_ctbl_1.tta_cod_indic_econ              = v_cod_indic_econ
                           tt_integr_item_lancto_ctbl_1.tta_cod_plano_cta_ctbl          = v_cod_plano_cta_ctbl
                           tt_integr_item_lancto_ctbl_1.tta_cod_plano_ccusto            = IF sumar-recebto.sc-codigo <> "":U THEN v_cod_plano_ccusto ELSE "":U
                           tt_integr_item_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl      = rttLancto
                           tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF (tt_integr_item_lancto_ctbl_1)
                           rttItem                                                      = &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF (tt_integr_item_lancto_ctbl_1).

                    CREATE tt_integr_aprop_lancto_ctbl_1.
                    ASSIGN tt_integr_aprop_lancto_ctbl_1.tta_cod_unid_negoc               = sumar-recebto.cod-unid-neg
                           tt_integr_aprop_lancto_ctbl_1.tta_dat_cotac_indic_econ         = sumar-recebto.dt-trans
                           tt_integr_aprop_lancto_ctbl_1.tta_ind_orig_val_lancto_ctbl     = "Informado":U
                           tt_integr_aprop_lancto_ctbl_1.tta_val_lancto_ctbl              = sumar-recebto.valor-ctbl-debito[1]
                           tt_integr_aprop_lancto_ctbl_1.tta_cod_ccusto                   = sumar-recebto.sc-codigo
                           tt_integr_aprop_lancto_ctbl_1.tta_cod_finalid_econ             = v_cod_finalid_econ
                           tt_integr_aprop_lancto_ctbl_1.tta_cod_plano_ccusto             = IF sumar-recebto.sc-codigo <> "":U THEN v_cod_plano_ccusto ELSE "":U
                           tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl  = rttItem
                           tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_aprop_lancto_ctbl = &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF (tt_integr_aprop_lancto_ctbl_1).
                END.

                /* Item e Apropriaá∆o: CRêDITO */
                IF sumar-recebto.valor-ctbl-credito[1] > 0 THEN DO:
                    ASSIGN v-seq-item = v-seq-item + 10.
                    CREATE tt_integr_item_lancto_ctbl_1.
                    ASSIGN tt_integr_item_lancto_ctbl_1.tta_num_seq_lancto_ctbl         = v-seq-item
                           tt_integr_item_lancto_ctbl_1.tta_ind_natur_lancto_ctbl       = "CR":U
                           tt_integr_item_lancto_ctbl_1.tta_cod_cta_ctbl                = sumar-recebto.ct-codigo
                           tt_integr_item_lancto_ctbl_1.tta_cod_estab                   = sumar-recebto.cod-estabel
                           tt_integr_item_lancto_ctbl_1.tta_cod_unid_negoc              = sumar-recebto.cod-unid-neg
                           tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl      = "Contabilizaá∆o Recebimento - " + STRING(sumar-recebto.dt-trans, "99/99/9999")
                           tt_integr_item_lancto_ctbl_1.tta_dat_docto                   = sumar-recebto.dt-trans
                           tt_integr_item_lancto_ctbl_1.tta_dat_lancto_ctbl             = sumar-recebto.dt-trans
                           tt_integr_item_lancto_ctbl_1.tta_val_lancto_ctbl             = sumar-recebto.valor-ctbl-credito[1]
                           tt_integr_item_lancto_ctbl_1.tta_cod_ccusto                  = sumar-recebto.sc-codigo
                           tt_integr_item_lancto_ctbl_1.tta_cod_indic_econ              = v_cod_indic_econ
                           tt_integr_item_lancto_ctbl_1.tta_cod_plano_cta_ctbl          = v_cod_plano_cta_ctbl
                           tt_integr_item_lancto_ctbl_1.tta_cod_plano_ccusto            = IF sumar-recebto.sc-codigo <> "":U THEN v_cod_plano_ccusto ELSE "":U
                           tt_integr_item_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl      = rttLancto
                           tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF (tt_integr_item_lancto_ctbl_1)
                           rttItem                                                      = &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF (tt_integr_item_lancto_ctbl_1).

                    CREATE tt_integr_aprop_lancto_ctbl_1.
                    ASSIGN tt_integr_aprop_lancto_ctbl_1.tta_cod_unid_negoc               = sumar-recebto.cod-unid-neg
                           tt_integr_aprop_lancto_ctbl_1.tta_dat_cotac_indic_econ         = sumar-recebto.dt-trans
                           tt_integr_aprop_lancto_ctbl_1.tta_ind_orig_val_lancto_ctbl     = "Informado":U
                           tt_integr_aprop_lancto_ctbl_1.tta_val_lancto_ctbl              = sumar-recebto.valor-ctbl-credito[1]
                           tt_integr_aprop_lancto_ctbl_1.tta_cod_ccusto                   = sumar-recebto.sc-codigo
                           tt_integr_aprop_lancto_ctbl_1.tta_cod_finalid_econ             = v_cod_finalid_econ
                           tt_integr_aprop_lancto_ctbl_1.tta_cod_plano_ccusto             = IF sumar-recebto.sc-codigo <> "":U THEN v_cod_plano_ccusto ELSE "":U
                           tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl  = rttItem
                           tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_aprop_lancto_ctbl = &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF (tt_integr_aprop_lancto_ctbl_1).
                END.

                /* --- Item e Apropriaá∆o IFRS-1 --- */
                IF l-gera-ifrs1 THEN DO:

                    IF sumar-recebto.valor-ctbl-debito[2] > 0 THEN DO:
                        ASSIGN v-seq-item-ifrs1 = v-seq-item-ifrs1 + 10.
                        CREATE tt_integr_item_lancto_ctbl_1.
                        ASSIGN tt_integr_item_lancto_ctbl_1.tta_num_seq_lancto_ctbl         = v-seq-item-ifrs1
                               tt_integr_item_lancto_ctbl_1.tta_ind_natur_lancto_ctbl       = "DB":U
                               tt_integr_item_lancto_ctbl_1.tta_cod_cta_ctbl                = sumar-recebto.ct-codigo
                               tt_integr_item_lancto_ctbl_1.tta_cod_estab                   = sumar-recebto.cod-estabel
                               tt_integr_item_lancto_ctbl_1.tta_cod_unid_negoc              = sumar-recebto.cod-unid-neg
                               tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl      = "Contabilizaá∆o Recebimento - " + STRING(sumar-recebto.dt-trans, "99/99/9999")
                               tt_integr_item_lancto_ctbl_1.tta_dat_docto                   = sumar-recebto.dt-trans
                               tt_integr_item_lancto_ctbl_1.tta_dat_lancto_ctbl             = sumar-recebto.dt-trans
                               tt_integr_item_lancto_ctbl_1.tta_val_lancto_ctbl             = sumar-recebto.valor-ctbl-debito[2]
                               tt_integr_item_lancto_ctbl_1.tta_cod_ccusto                  = sumar-recebto.sc-codigo
                               tt_integr_item_lancto_ctbl_1.tta_cod_indic_econ              = v_cod_indic_econ_if1
                               tt_integr_item_lancto_ctbl_1.tta_cod_plano_cta_ctbl          = v_cod_plano_cta_ctbl
                               tt_integr_item_lancto_ctbl_1.tta_cod_plano_ccusto            = IF sumar-recebto.sc-codigo <> "":U THEN v_cod_plano_ccusto ELSE "":U
                               tt_integr_item_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl      = rttLanctoIfrs1
                               tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF (tt_integr_item_lancto_ctbl_1)
                               rttItem                                                      = &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF (tt_integr_item_lancto_ctbl_1).

                        CREATE tt_integr_aprop_lancto_ctbl_1.
                        ASSIGN tt_integr_aprop_lancto_ctbl_1.tta_cod_unid_negoc               = sumar-recebto.cod-unid-neg
                               tt_integr_aprop_lancto_ctbl_1.tta_dat_cotac_indic_econ         = sumar-recebto.dt-trans
                               tt_integr_aprop_lancto_ctbl_1.tta_ind_orig_val_lancto_ctbl     = "Informado":U
                               tt_integr_aprop_lancto_ctbl_1.tta_val_lancto_ctbl              = sumar-recebto.valor-ctbl-debito[2]
                               tt_integr_aprop_lancto_ctbl_1.tta_cod_ccusto                   = sumar-recebto.sc-codigo
                               tt_integr_aprop_lancto_ctbl_1.tta_cod_finalid_econ             = v_cod_finalid_econ_if1
                               tt_integr_aprop_lancto_ctbl_1.tta_cod_plano_ccusto             = IF sumar-recebto.sc-codigo <> "":U THEN v_cod_plano_ccusto ELSE "":U
                               tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl  = rttItem
                               tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_aprop_lancto_ctbl = &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF (tt_integr_aprop_lancto_ctbl_1).
                    END.

                    IF sumar-recebto.valor-ctbl-credito[2] > 0 THEN DO:
                        ASSIGN v-seq-item-ifrs1 = v-seq-item-ifrs1 + 10.
                        CREATE tt_integr_item_lancto_ctbl_1.
                        ASSIGN tt_integr_item_lancto_ctbl_1.tta_num_seq_lancto_ctbl         = v-seq-item-ifrs1
                               tt_integr_item_lancto_ctbl_1.tta_ind_natur_lancto_ctbl       = "CR":U
                               tt_integr_item_lancto_ctbl_1.tta_cod_cta_ctbl                = sumar-recebto.ct-codigo
                               tt_integr_item_lancto_ctbl_1.tta_cod_estab                   = sumar-recebto.cod-estabel
                               tt_integr_item_lancto_ctbl_1.tta_cod_unid_negoc              = sumar-recebto.cod-unid-neg
                               tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl      = "Contabilizaá∆o Recebimento - " + STRING(sumar-recebto.dt-trans, "99/99/9999")
                               tt_integr_item_lancto_ctbl_1.tta_dat_docto                   = sumar-recebto.dt-trans
                               tt_integr_item_lancto_ctbl_1.tta_dat_lancto_ctbl             = sumar-recebto.dt-trans
                               tt_integr_item_lancto_ctbl_1.tta_val_lancto_ctbl             = sumar-recebto.valor-ctbl-credito[2]
                               tt_integr_item_lancto_ctbl_1.tta_cod_ccusto                  = sumar-recebto.sc-codigo
                               tt_integr_item_lancto_ctbl_1.tta_cod_indic_econ              = v_cod_indic_econ_if1
                               tt_integr_item_lancto_ctbl_1.tta_cod_plano_cta_ctbl          = v_cod_plano_cta_ctbl
                               tt_integr_item_lancto_ctbl_1.tta_cod_plano_ccusto            = IF sumar-recebto.sc-codigo <> "":U THEN v_cod_plano_ccusto ELSE "":U
                               tt_integr_item_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl      = rttLanctoIfrs1
                               tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF (tt_integr_item_lancto_ctbl_1)
                               rttItem                                                      = &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF (tt_integr_item_lancto_ctbl_1).

                        CREATE tt_integr_aprop_lancto_ctbl_1.
                        ASSIGN tt_integr_aprop_lancto_ctbl_1.tta_cod_unid_negoc               = sumar-recebto.cod-unid-neg
                               tt_integr_aprop_lancto_ctbl_1.tta_dat_cotac_indic_econ         = sumar-recebto.dt-trans
                               tt_integr_aprop_lancto_ctbl_1.tta_ind_orig_val_lancto_ctbl     = "Informado":U
                               tt_integr_aprop_lancto_ctbl_1.tta_val_lancto_ctbl              = sumar-recebto.valor-ctbl-credito[2]
                               tt_integr_aprop_lancto_ctbl_1.tta_cod_ccusto                   = sumar-recebto.sc-codigo
                               tt_integr_aprop_lancto_ctbl_1.tta_cod_finalid_econ             = v_cod_finalid_econ_if1
                               tt_integr_aprop_lancto_ctbl_1.tta_cod_plano_ccusto             = IF sumar-recebto.sc-codigo <> "":U THEN v_cod_plano_ccusto ELSE "":U
                               tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl  = rttItem
                               tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_aprop_lancto_ctbl = &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF (tt_integr_aprop_lancto_ctbl_1).
                    END.
                END. /* l-gera-ifrs1 */

                /* --- Item e Apropriaá∆o IFRS-2 --- */
                IF l-gera-ifrs2 THEN DO:

                    IF sumar-recebto.valor-ctbl-debito[3] > 0 THEN DO:
                        ASSIGN v-seq-item-ifrs2 = v-seq-item-ifrs2 + 10.
                        CREATE tt_integr_item_lancto_ctbl_1.
                        ASSIGN tt_integr_item_lancto_ctbl_1.tta_num_seq_lancto_ctbl         = v-seq-item-ifrs2
                               tt_integr_item_lancto_ctbl_1.tta_ind_natur_lancto_ctbl       = "DB":U
                               tt_integr_item_lancto_ctbl_1.tta_cod_cta_ctbl                = sumar-recebto.ct-codigo
                               tt_integr_item_lancto_ctbl_1.tta_cod_estab                   = sumar-recebto.cod-estabel
                               tt_integr_item_lancto_ctbl_1.tta_cod_unid_negoc              = sumar-recebto.cod-unid-neg
                               tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl      = "Contabilizaá∆o Recebimento - " + STRING(sumar-recebto.dt-trans, "99/99/9999")
                               tt_integr_item_lancto_ctbl_1.tta_dat_docto                   = sumar-recebto.dt-trans
                               tt_integr_item_lancto_ctbl_1.tta_dat_lancto_ctbl             = sumar-recebto.dt-trans
                               tt_integr_item_lancto_ctbl_1.tta_val_lancto_ctbl             = sumar-recebto.valor-ctbl-debito[3]
                               tt_integr_item_lancto_ctbl_1.tta_cod_ccusto                  = sumar-recebto.sc-codigo
                               tt_integr_item_lancto_ctbl_1.tta_cod_indic_econ              = v_cod_indic_econ_if2
                               tt_integr_item_lancto_ctbl_1.tta_cod_plano_cta_ctbl          = v_cod_plano_cta_ctbl
                               tt_integr_item_lancto_ctbl_1.tta_cod_plano_ccusto            = IF sumar-recebto.sc-codigo <> "":U THEN v_cod_plano_ccusto ELSE "":U
                               tt_integr_item_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl      = rttLanctoIfrs2
                               tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF (tt_integr_item_lancto_ctbl_1)
                               rttItem                                                      = &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF (tt_integr_item_lancto_ctbl_1).

                        CREATE tt_integr_aprop_lancto_ctbl_1.
                        ASSIGN tt_integr_aprop_lancto_ctbl_1.tta_cod_unid_negoc               = sumar-recebto.cod-unid-neg
                               tt_integr_aprop_lancto_ctbl_1.tta_dat_cotac_indic_econ         = sumar-recebto.dt-trans
                               tt_integr_aprop_lancto_ctbl_1.tta_ind_orig_val_lancto_ctbl     = "Informado":U
                               tt_integr_aprop_lancto_ctbl_1.tta_val_lancto_ctbl              = sumar-recebto.valor-ctbl-debito[3]
                               tt_integr_aprop_lancto_ctbl_1.tta_cod_ccusto                   = sumar-recebto.sc-codigo
                               tt_integr_aprop_lancto_ctbl_1.tta_cod_finalid_econ             = v_cod_finalid_econ_if2
                               tt_integr_aprop_lancto_ctbl_1.tta_cod_plano_ccusto             = IF sumar-recebto.sc-codigo <> "":U THEN v_cod_plano_ccusto ELSE "":U
                               tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl  = rttItem
                               tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_aprop_lancto_ctbl = &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF (tt_integr_aprop_lancto_ctbl_1).
                    END.

                    IF sumar-recebto.valor-ctbl-credito[3] > 0 THEN DO:
                        ASSIGN v-seq-item-ifrs2 = v-seq-item-ifrs2 + 10.
                        CREATE tt_integr_item_lancto_ctbl_1.
                        ASSIGN tt_integr_item_lancto_ctbl_1.tta_num_seq_lancto_ctbl         = v-seq-item-ifrs2
                               tt_integr_item_lancto_ctbl_1.tta_ind_natur_lancto_ctbl       = "CR":U
                               tt_integr_item_lancto_ctbl_1.tta_cod_cta_ctbl                = sumar-recebto.ct-codigo
                               tt_integr_item_lancto_ctbl_1.tta_cod_estab                   = sumar-recebto.cod-estabel
                               tt_integr_item_lancto_ctbl_1.tta_cod_unid_negoc              = sumar-recebto.cod-unid-neg
                               tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl      = "Contabilizaá∆o Recebimento - " + STRING(sumar-recebto.dt-trans, "99/99/9999")
                               tt_integr_item_lancto_ctbl_1.tta_dat_docto                   = sumar-recebto.dt-trans
                               tt_integr_item_lancto_ctbl_1.tta_dat_lancto_ctbl             = sumar-recebto.dt-trans
                               tt_integr_item_lancto_ctbl_1.tta_val_lancto_ctbl             = sumar-recebto.valor-ctbl-credito[3]
                               tt_integr_item_lancto_ctbl_1.tta_cod_ccusto                  = sumar-recebto.sc-codigo
                               tt_integr_item_lancto_ctbl_1.tta_cod_indic_econ              = v_cod_indic_econ_if2
                               tt_integr_item_lancto_ctbl_1.tta_cod_plano_cta_ctbl          = v_cod_plano_cta_ctbl
                               tt_integr_item_lancto_ctbl_1.tta_cod_plano_ccusto            = IF sumar-recebto.sc-codigo <> "":U THEN v_cod_plano_ccusto ELSE "":U
                               tt_integr_item_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl      = rttLanctoIfrs2
                               tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF (tt_integr_item_lancto_ctbl_1)
                               rttItem                                                      = &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF (tt_integr_item_lancto_ctbl_1).

                        CREATE tt_integr_aprop_lancto_ctbl_1.
                        ASSIGN tt_integr_aprop_lancto_ctbl_1.tta_cod_unid_negoc               = sumar-recebto.cod-unid-neg
                               tt_integr_aprop_lancto_ctbl_1.tta_dat_cotac_indic_econ         = sumar-recebto.dt-trans
                               tt_integr_aprop_lancto_ctbl_1.tta_ind_orig_val_lancto_ctbl     = "Informado":U
                               tt_integr_aprop_lancto_ctbl_1.tta_val_lancto_ctbl              = sumar-recebto.valor-ctbl-credito[3]
                               tt_integr_aprop_lancto_ctbl_1.tta_cod_ccusto                   = sumar-recebto.sc-codigo
                               tt_integr_aprop_lancto_ctbl_1.tta_cod_finalid_econ             = v_cod_finalid_econ_if2
                               tt_integr_aprop_lancto_ctbl_1.tta_cod_plano_ccusto             = IF sumar-recebto.sc-codigo <> "":U THEN v_cod_plano_ccusto ELSE "":U
                               tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl  = rttItem
                               tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_aprop_lancto_ctbl = &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF (tt_integr_aprop_lancto_ctbl_1).
                    END.
                END. /* l-gera-ifrs2 */
            END.
        END.

        /* Envia o pacote inteiro para a API no fim do grupo (LAST-OF) */
        IF LAST-OF(tt-movto-ctbz.dt-trans) THEN DO:
            IF l-erro-plano = NO THEN DO:

                /* Remove lanáamentos IFRS sem nenhum item no dia */
                FOR EACH tt_integr_lancto_ctbl_1
                   WHERE NOT CAN-FIND(FIRST tt_integr_item_lancto_ctbl_1
                                      WHERE tt_integr_item_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl = tt_integr_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl):
                    DELETE tt_integr_lancto_ctbl_1.
                END.

                IF VALID-HANDLE(v_hdl_fgl900zo) THEN DO:

                    IF l-gera-log THEN
                        /* Executar Log antes da procedure */
                        RUN pi_executa_log_temp_table(INPUT BUFFER tt_integr_lote_ctbl_1:HANDLE,
                                                      INPUT BUFFER tt_integr_lancto_ctbl_1:HANDLE,
                                                      INPUT BUFFER tt_integr_item_lancto_ctbl_1:HANDLE,
                                                      INPUT BUFFER tt_integr_aprop_lancto_ctbl_1:HANDLE,
                                                      INPUT BUFFER tt_integr_ctbl_valid_1:HANDLE,
                                                      INPUT BUFFER tt_params_generic_api:HANDLE,
                                                      "RE0765-Antes da Execucao":U).

                    RUN pi_main_api_lote_ctbl_recebto_1 IN v_hdl_fgl900zo (INPUT 3,
                                                                           INPUT "Aborta Lotes Errados":U,
                                                                           INPUT YES,
                                                                           INPUT 66,
                                                                           INPUT "Apropriaá∆o":U,
                                                                           INPUT "Todos":U,
                                                                           INPUT YES,
                                                                           INPUT YES,
                                                                           INPUT-OUTPUT TABLE tt_integr_lote_ctbl_1,
                                                                           INPUT-OUTPUT TABLE tt_integr_lancto_ctbl_1,
                                                                           INPUT-OUTPUT TABLE tt_integr_item_lancto_ctbl_1,
                                                                           INPUT-OUTPUT TABLE tt_integr_aprop_lancto_ctbl_1,
                                                                           INPUT-OUTPUT TABLE tt_integr_ctbl_valid_1,
                                                                           INPUT-OUTPUT TABLE tt_params_generic_api).

                    IF l-gera-log THEN
                        /* Executar Log depois da procedure */
                        RUN pi_executa_log_temp_table(INPUT BUFFER tt_integr_lote_ctbl_1:HANDLE,
                                                      INPUT BUFFER tt_integr_lancto_ctbl_1:HANDLE,
                                                      INPUT BUFFER tt_integr_item_lancto_ctbl_1:HANDLE,
                                                      INPUT BUFFER tt_integr_aprop_lancto_ctbl_1:HANDLE,
                                                      INPUT BUFFER tt_integr_ctbl_valid_1:HANDLE,
                                                      INPUT BUFFER tt_params_generic_api:HANDLE,
                                                      "RE0765-Depois da Execucao":U).

                    /* Verifica erros da FGL */
                    FIND FIRST tt_integr_ctbl_valid_1 NO-LOCK NO-ERROR.

                    IF AVAILABLE tt_integr_ctbl_valid_1 THEN DO:
                        DEFINE VARIABLE c-msg-erro AS CHARACTER NO-UNDO.

                        /* Retorna mensagens do EMS 5 limpando as tags de parÉmetros (&1, &2) */
                        RUN pi_messages (INPUT "msg":U, INPUT tt_integr_ctbl_valid_1.ttv_num_mensagem, INPUT "":U).
                        ASSIGN c-msg-erro = RETURN-VALUE.

                        /* 1. Cria a mensagem de ERRO FGL apenas UMA VEZ para o lote/dia todo */
                        FIND FIRST b-sumar NO-LOCK WHERE ROWID(b-sumar) = tt-movto-ctbz.r-rowid NO-ERROR.
                        IF AVAILABLE b-sumar THEN DO:
                            FIND FIRST b-estab NO-LOCK WHERE b-estab.cod-estabel = b-sumar.cod-estabel NO-ERROR.

                            CREATE tt-log-ctbz.
                            ASSIGN tt-log-ctbz.ep-codigo   = IF AVAILABLE b-estab THEN b-estab.ep-codigo ELSE ""
                                   tt-log-ctbz.cod-estabel = b-sumar.cod-estabel
                                   tt-log-ctbz.dt-trans    = tt-movto-ctbz.dt-trans
                                   tt-log-ctbz.refer-ctbl  = ""
                                   tt-log-ctbz.cod-msg     = tt_integr_ctbl_valid_1.ttv_num_mensagem
                                   tt-log-ctbz.desc-msg    = c-msg-erro.
                        END.

                        /* 2. Varre os documentos do lote APENAS para desmarcar a flag f°sica (sem duplicar log) */
                        FOR EACH b-movto-ctbz NO-LOCK WHERE b-movto-ctbz.dt-trans = tt-movto-ctbz.dt-trans:
                            FIND FIRST b-sumar NO-LOCK WHERE ROWID(b-sumar) = b-movto-ctbz.r-rowid NO-ERROR.
                            IF AVAILABLE b-sumar THEN DO:
                                FIND FIRST b-docum EXCLUSIVE-LOCK
                                     WHERE b-docum.cod-estabel  = b-sumar.cod-estabel
                                       AND b-docum.serie-docto  = b-sumar.serie-docto
                                       AND b-docum.nro-docto    = b-sumar.nro-docto
                                       AND b-docum.cod-emitente = b-sumar.cod-emitente
                                       AND b-docum.nat-operacao = b-sumar.nat-operacao NO-ERROR.
                                IF AVAILABLE b-docum THEN ASSIGN b-docum.log-ctbl-atual = NO.
                            END.
                        END.
                    END.
                    ELSE DO:
                        FIND FIRST tt_integr_lote_ctbl_1 NO-LOCK NO-ERROR.

                        /* 1. Cria a mensagem de SUCESSO apenas UMA VEZ para o lote todo */
                        FIND FIRST b-sumar NO-LOCK WHERE ROWID(b-sumar) = tt-movto-ctbz.r-rowid NO-ERROR.
                        FIND FIRST b-estab NO-LOCK WHERE b-estab.cod-estabel = b-sumar.cod-estabel NO-ERROR.
                        IF AVAILABLE b-sumar THEN DO:

                            {utp/ut-liter.i "Contabilizaá∆o_efetuada_com_sucesso!" * r}

                            CREATE tt-log-ctbz.
                            ASSIGN tt-log-ctbz.ep-codigo   = IF AVAILABLE b-estab THEN b-estab.ep-codigo ELSE ""
                                   tt-log-ctbz.cod-estabel = b-sumar.cod-estabel
                                   tt-log-ctbz.dt-trans    = tt-movto-ctbz.dt-trans
                                   tt-log-ctbz.refer-ctbl  = tt-movto-ctbz.refer-ctbl
                                   tt-log-ctbz.cod-msg     = 2521
                                   tt-log-ctbz.desc-msg    = TRIM(RETURN-VALUE).
                        END.

                        /* 2. Atualiza fisicamente todos os documentos do lote (sem duplicar log) */
                        FOR EACH b-movto-ctbz NO-LOCK WHERE b-movto-ctbz.dt-trans = tt-movto-ctbz.dt-trans:
                            FIND FIRST b-sumar EXCLUSIVE-LOCK WHERE ROWID(b-sumar) = b-movto-ctbz.r-rowid NO-ERROR.
                            IF AVAILABLE b-sumar THEN DO:
                                ASSIGN b-sumar.log-ctbzdo         = YES
                                       b-sumar.dtm-contabilizacao = DATETIME-TZ(TODAY, MTIME,TIMEZONE)
                                       b-sumar.cod-usuario-ctbz   = p-usuario
                                       b-sumar.refer-ctbl         = tt-movto-ctbz.refer-ctbl
                                       b-sumar.num-id-movto-ctbl  = IF AVAILABLE tt_integr_lote_ctbl_1 THEN tt_integr_lote_ctbl_1.tta_num_lote_ctbl ELSE 0.

                                FIND FIRST b-docum EXCLUSIVE-LOCK
                                     WHERE b-docum.cod-estabel  = b-sumar.cod-estabel
                                       AND b-docum.serie-docto  = b-sumar.serie-docto
                                       AND b-docum.nro-docto    = b-sumar.nro-docto
                                       AND b-docum.cod-emitente = b-sumar.cod-emitente
                                       AND b-docum.nat-operacao = b-sumar.nat-operacao NO-ERROR.
                                IF AVAILABLE b-docum THEN ASSIGN b-docum.log-ctbl-atual = YES.
                            END.
                        END.
                    END.
                END.
            END.
            ELSE DO:
                /* Caso tenha falhado ao buscar o plano de contas/ccusto no FIRST-OF */
                FIND FIRST tt_log_erro NO-LOCK NO-ERROR.

                {utp/ut-liter.i "Falha_na_busca_do_Plano_de_Contas/CCusto." * r}

                FOR EACH b-movto-ctbz NO-LOCK WHERE b-movto-ctbz.dt-trans = tt-movto-ctbz.dt-trans:
                    FIND FIRST b-sumar NO-LOCK WHERE ROWID(b-sumar) = b-movto-ctbz.r-rowid NO-ERROR.
                    IF AVAILABLE b-sumar THEN DO:
                        CREATE tt-log-ctbz.
                        ASSIGN tt-log-ctbz.ep-codigo   = IF AVAILABLE b-estab THEN b-estab.ep-codigo ELSE ""
                               tt-log-ctbz.cod-estabel = b-sumar.cod-estabel
                               tt-log-ctbz.dt-trans    = b-sumar.dt-trans
                               tt-log-ctbz.refer-ctbl  = ""
                               tt-log-ctbz.cod-msg     = IF AVAILABLE tt_log_erro THEN tt_log_erro.ttv_num_cod_erro ELSE 0
                               tt-log-ctbz.desc-msg    = TRIM(RETURN-VALUE).
                    END.
                END.
            END.
        END.
    END.

    IF VALID-HANDLE(v_hdl_fgl900zo) THEN DELETE PROCEDURE v_hdl_fgl900zo.
    IF VALID-HANDLE(v_hdl_utb742za) THEN DELETE PROCEDURE v_hdl_utb742za.
    IF VALID-HANDLE(v_hdl_utb743za) THEN DELETE PROCEDURE v_hdl_utb743za.
    IF VALID-HANDLE(v_hdl_fgl920za) THEN DELETE PROCEDURE v_hdl_fgl920za.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_messages BOIN01167
PROCEDURE pi_messages:
/*-------------------------------------------------------------------------------
  Purpose: Retornar mensagens do EMS 5 sem os parÉmetros. Ex.: &1, &2
-------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER c_action   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER i_msg      AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER c_param    AS CHARACTER NO-UNDO.

    DEFINE VARIABLE iLoop     AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iLoopAux  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cAux      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c_prg_msg AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRetorno  AS CHARACTER NO-UNDO.

    ASSIGN c_prg_msg = "messages/":U
                     + STRING(TRUNC(i_msg / 1000,0),"99":U)
                     + "/msg":U
                     + STRING(i_msg, "99999":U).

    IF SEARCH(c_prg_msg + ".r":U) = ? AND SEARCH(c_prg_msg + ".p":U) = ? THEN DO:
        /* Traduá∆o dinÉmica caso o programa de mensagem n∆o exista */
        {utp/ut-liter.i "Mensagem_nr" * r}
        DEFINE VARIABLE c-lbl-msg AS CHARACTER NO-UNDO.
        ASSIGN c-lbl-msg = TRIM(RETURN-VALUE).

        {utp/ut-liter.i "Programa" * r}
        DEFINE VARIABLE c-lbl-prg AS CHARACTER NO-UNDO.
        ASSIGN c-lbl-prg = TRIM(RETURN-VALUE).

        {utp/ut-liter.i "n∆o_encontrado" * r}
        DEFINE VARIABLE c-lbl-nao AS CHARACTER NO-UNDO.
        ASSIGN c-lbl-nao = TRIM(RETURN-VALUE).

        ASSIGN cRetorno = c-lbl-prg + " " + c_prg_msg + " " + c-lbl-nao + ".".
        RETURN cRetorno.
    END.

    RUN VALUE(c_prg_msg + ".p":U) (INPUT c_action, INPUT c_param).

    ASSIGN cRetorno = RETURN-VALUE
           iLoopAux = NUM-ENTRIES(RETURN-VALUE, "&":U) - 1.

    /* Limpa os parÉmetros &1, &2, etc. */
    IF iLoopAux > 0 THEN DO:
        DO iLoop = 1 TO iLoopAux:
            ASSIGN cAux     = "&":U + STRING(iLoop)
                   cRetorno = REPLACE(REPLACE(cRetorno, cAux, "":U), "  ":U, " ":U).
        END.
    END.
    ELSE ASSIGN cRetorno = RETURN-VALUE.

    RETURN cRetorno.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


PROCEDURE pi_executa_log_temp_table:

    /************************ Parameter Definition Begin ************************/

    def Input param p_tt_integr_lote_ctbl_1
        as Handle
        format ">>>>>>9"
        no-undo.
    def Input param p_tt_integr_lancto_ctbl_1
        as Handle
        format ">>>>>>9"
        no-undo.
    def Input param p_tt_integr_item_lancto_ctbl_1
        as Handle
        format ">>>>>>9"
        no-undo.
    def Input param p_tt_integr_aprop_lancto_ctbl_1
        as Handle
        format ">>>>>>9"
        no-undo.
    def Input param p_tt_integr_ctbl_valid_1
        as Handle
        format ">>>>>>9"
        no-undo.
    def Input param p_tt_params_generic_api
        as Handle
        format ">>>>>>9"
        no-undo.
    DEF INPUT PARAM p_cod_programa
        AS CHAR
        NO-UNDO.

    /************************* Parameter Definition End *************************/
    RUN pi_gera_log_temp_table(INPUT p_tt_integr_lote_ctbl_1,
                               INPUT p_cod_programa).
    RUN pi_gera_log_temp_table(INPUT p_tt_integr_lancto_ctbl_1,
                               INPUT p_cod_programa).
    RUN pi_gera_log_temp_table(INPUT p_tt_integr_item_lancto_ctbl_1,
                               INPUT p_cod_programa).
    RUN pi_gera_log_temp_table(INPUT p_tt_integr_aprop_lancto_ctbl_1,
                               INPUT p_cod_programa).
    RUN pi_gera_log_temp_table(INPUT p_tt_integr_ctbl_valid_1,
                               INPUT p_cod_programa).
    RUN pi_gera_log_temp_table(INPUT p_tt_params_generic_api,
                               INPUT p_cod_programa).

END PROCEDURE. /* pi_gera_log_temp_table */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

PROCEDURE pi_gera_log_temp_table:

    /************************ Parameter Definition Begin ************************/

    def Input param p_hdl_temp_table
        as Handle
        format ">>>>>>9"
        no-undo.
    def Input param p_cod_programa
        as character
        format "x(50)"
        no-undo.

    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_hdl_query                      as handle          no-undo. /*local*/
    def var v_num_aux_1                      as integer         no-undo. /*local*/
    def var v_num_aux_2                      as integer         no-undo. /*local*/
    def var v_num_cont                       as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* ATEN??O: esta procedure da um for each na temp-table passada por par?metro, ou seja,
    pode desposicionar os registros dependendo do ponto onde ? chamada,
    por exemplo, se a chamada desta pi for feita dentro do for each ou ap?s um find da propria temp-table.
    O ideal ? cham?-la no ?n?cio e no final do main code da api. */

    if  log-manager:logfile-name <> ?
    and log-manager:logging-level > 2 THEN do:

        create query v_hdl_query.
        v_hdl_query:set-buffers(p_hdl_temp_table).
        v_hdl_query:query-prepare("for each " + p_hdl_temp_table:name).
        v_hdl_query:query-open.
        v_hdl_query:get-next.

        log-manager:write-message('-----------------------------------------------------------------------------------', p_cod_programa).
        log-manager:write-message('------------------------- Registros da ' + p_hdl_temp_table:name + ' ------------------------', p_cod_programa).
        log-manager:write-message('-----------------------------------------------------------------------------------', p_cod_programa).

        assign v_num_cont = 1.

        do while (not v_hdl_query:query-off-end):

             log-manager:write-message('----------------------------------- Registro: ' + string(v_num_cont) + ' -----------------------------------', p_cod_programa).

             do v_num_aux_1 = 1 to p_hdl_temp_table:num-fields:

                /* verifica se o campo foi definido com extent. Ex. field campo as int extent 15 */
                if p_hdl_temp_table:buffer-field(v_num_aux_1):extent > 0 then do:

                    /* percorre os campos extent: campo[1], campo[2], campo[3], ..., campo[15] */
                    do v_num_aux_2 = 1 to p_hdl_temp_table:buffer-field(v_num_aux_1):extent:

                        /* se o campo possuia o valor ? o mesmo nao era apresentado no log, somente era apresentado um ? */
                        if p_hdl_temp_table:buffer-field(v_num_aux_1):buffer-value(v_num_aux_2) = ? then do:

                            log-manager:write-message(p_hdl_temp_table:name + "." + p_hdl_temp_table:buffer-field(v_num_aux_1):name + "[" + string(v_num_aux_2) + "]" + " = ?", p_cod_programa).
                        end.
                        else do:

                            /* se o campo for character gera aspas no valor do campo pra facilitar a visualizacao no log */
                            if p_hdl_temp_table:buffer-field(v_num_aux_1):data-type = 'character' then do:

                                log-manager:write-message(p_hdl_temp_table:name + "." + p_hdl_temp_table:buffer-field(v_num_aux_1):name + "[" + string(v_num_aux_2) + "]" + " = '" + p_hdl_temp_table:buffer-field(v_num_aux_1):buffer-value(v_num_aux_2) + "'", p_cod_programa).
                            end.
                            else do:
                                if p_hdl_temp_table:buffer-field(v_num_aux_1):data-type = 'rowid' then do:     /* Altera??o Realizada Por Demanda - Rowid */
                                    log-manager:write-message(p_hdl_temp_table:name + "." + p_hdl_temp_table:buffer-field(v_num_aux_1):name + "[" + string(v_num_aux_2) + "]" + " = " + string(p_hdl_temp_table:buffer-field(v_num_aux_1):buffer-value(v_num_aux_2)), p_cod_programa).
                                end.
                                else do :
                                    log-manager:write-message(p_hdl_temp_table:name + "." + p_hdl_temp_table:buffer-field(v_num_aux_1):name + "[" + string(v_num_aux_2) + "]" + " = " + p_hdl_temp_table:buffer-field(v_num_aux_1):buffer-value(v_num_aux_2), p_cod_programa).
                                end.
                            end.
                        end.
                    end.
                end.
                else do:

                    /* se o campo possuia o valor ? o mesmo nao era apresentado no log, somente era apresentado um ? */
                    if p_hdl_temp_table:buffer-field(v_num_aux_1):buffer-value() = ? then do:

                        log-manager:write-message(p_hdl_temp_table:name + "." + p_hdl_temp_table:buffer-field(v_num_aux_1):name + " = ?", p_cod_programa).
                    end.
                    else do:

                        /* se o campo for character gera aspas no valor do campo pra facilitar a visualizacao no log */
                        if p_hdl_temp_table:buffer-field(v_num_aux_1):data-type = 'character' then do:

                            log-manager:write-message(p_hdl_temp_table:name + "." + p_hdl_temp_table:buffer-field(v_num_aux_1):name + " = '" + p_hdl_temp_table:buffer-field(v_num_aux_1):buffer-value() + "'", p_cod_programa).
                        end.
                        else do:
                            if p_hdl_temp_table:buffer-field(v_num_aux_1):data-type = 'rowid' then do: /* Altera??o Realizada Por Demanda - Rowid */
                                log-manager:write-message(p_hdl_temp_table:name + "." + p_hdl_temp_table:buffer-field(v_num_aux_1):name + " = " + string(p_hdl_temp_table:buffer-field(v_num_aux_1):buffer-value()), p_cod_programa).
                            end.
                            else do :
                                log-manager:write-message(p_hdl_temp_table:name + "." + p_hdl_temp_table:buffer-field(v_num_aux_1):name + " = " + p_hdl_temp_table:buffer-field(v_num_aux_1):buffer-value(), p_cod_programa).
                            end.
                        end.
                    end.
                end.
             end.

             log-manager:write-message('-----------------------------------------------------------------------------------', p_cod_programa).

             assign v_num_cont = v_num_cont + 1.

             v_hdl_query:get-next.
        end.

        log-manager:write-message('----------------- Quantidade de Registros da ' + p_hdl_temp_table:name + ': ' + string(v_num_cont - 1) + ' ----------------', p_cod_programa).
        log-manager:write-message('-----------------------------------------------------------------------------------', p_cod_programa).

        v_hdl_query:query-close().
        delete object v_hdl_query.

    end.
END PROCEDURE. /* pi_gera_log_temp_table */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


