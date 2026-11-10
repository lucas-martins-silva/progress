/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAD391 2.00.00.016 } /*** "010016" 10/06/2025 09:30:38 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad391 MUT}
&ENDIF

{include/i_fncrowid.i}

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

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOAD391
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName movto-contrat-tit-export
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
{adbo/boad391.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var c-usuario  like movto-contrat-tit-export.cod-usuario.
DEF VAR l-funcao-recta-cambio-fut AS LOG INITIAL NO NO-UNDO.

DEF TEMP-TABLE tt-movto-contrat NO-UNDO LIKE movto-contrat-tit-export.

def temp-table tt-param-totalizacao no-undo
    field ttv-num-proc-ini  as char format 'x(12)'
    field ttv-num-proc-fim  as char format 'x(12)'
    field ttv-cliente-ini   as int  format '9'
    field ttv-cliente-fim   as int  format '>>>>>>>>9'
    field ttv-vencto-ini    as date format 99/99/9999
    field ttv-vencto-fim    as date format 99/99/9999
    field ttv-pais-ini      as char format 'x(20)'
    field ttv-pais-fim      as char format 'x(20)'
    field ttv-tit-csa-saldo as int  format '9'.

def temp-table tt-contr-titulo-exp no-undo like contr-titulo-exp
    field r-rowid as rowid.

DEF TEMP-TABLE tt-emitente NO-UNDO LIKE emitente
    FIELD r-rowid AS ROWID
    INDEX nome nome-abrev.

def temp-table tt_chave_tit_acr no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_num_contrat_id_cambio        as integer format "999999999".

def temp-table tt_rateio_tit_acr no-undo
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field ttv_cod_tip_recta                as character format "x(8)"
    field tta_val_perc_rat                 as decimal format "->>9.9999999999" decimals 10 initial 0 label "Perc Rateio" column-label "Perc"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_num_id_val_movto_tit_acr     as integer format ">>>>,>>9" initial 0 label "Id Val Movto" column-label "Id Val Movto"
    field tta_num_id_movto_tit_acr         as integer format "9999999999" initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotaá∆o" column-label "Cotaá∆o"
    .

def temp-table tt_integr_mec_cfl no-undo
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_id_movto_tit_acr         as integer format "9999999999" initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR"
    field tta_num_id_val_movto_tit_acr     as integer format ">>>>,>>9" initial 0 label "Id Val Movto" column-label "Id Val Movto"
    field ttv_dat_movto_mec                as date format "99/99/9999"
    field ttv_ind_trans_mec                as character format "X(08)"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field ttv_val_movto_mec                as decimal format "->>,>>>,>>>,>>9.9999999999" decimals 10
    field tta_cod_contrat_cambio           as character format "x(15)" label "Contrato CÉmbio" column-label "Contrato CÉmbio"
    field tta_cod_refer_contrat_cambio     as character format "x(10)" label "Referància" column-label "Referància"
    field tta_dat_refer_contrat_cambio     as date format "99/99/9999" initial ? label "Dt Referància" column-label "Dt Referància"
    field ttv_num_seq                      as integer format ">>>,>>9" label "SeqÅància" column-label "Seq"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_ind_tip_movto_fluxo_cx       as character format "X(2)" initial "PR" label "Tipo Movimento" column-label "Tipo Movimento"
    field tta_ind_fluxo_movto_cx           as character format "X(3)" initial "ENT" label "Fluxo Movimento" column-label "Fluxo Movimento"
    field tta_val_movto_fluxo_cx           as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Movto" column-label "Valor Movto"
    index tt_                             
          ttv_dat_movto_mec                ascending
    .

def temp-table tt_erro_mec no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "SeqÅància" column-label "Seq"
    field ttv_cod_erro_ems2                as INT column-label "Cod Erro"
    field ttv_des_msg_erro_ems2            as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància"
    .

DEF BUFFER b-movto-contrat-tit-export FOR movto-contrat-tit-export.

{ecp/ec0005c.i}  /* Definicoes para conexao EMS 5 */
{cdp/cdcfgfin.i}

&IF "{&mguni_version}" >= "2.07A" &THEN
DEF VAR c-ep-codigo LIKE empresa.ep-codigo NO-UNDO.
&ELSE
DEF VAR c-ep-codigo AS INT NO-UNDO.
&ENDIF

/*integraá∆o CMG e CFL */
{cdp/cd1202.i2}
{cdp/cdapi533a.i}
def temp-table tt-erro-aux no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".




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
         HEIGHT             = 2
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

    /* Verifica funá∆o Cambio Futuro */
    {include/getdefinedfunction.i}
    /* esta variavel verificar† se a funá∆o Destinaá∆o est† habilitada para que possa ser utilizada a funá∆o de Cambio Futuro */
    ASSIGN l-funcao-recta-cambio-fut = &if defined(BF_FIN_DESTINACAO) &then YES &else GetDefinedFunction("SPP-DESTINACAO") &endif.


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
        &IF "{&mguni_version}" >= "2.07A" &THEN
            WHEN "cdn-empresa":U THEN ASSIGN pFieldValue = RowObject.cdn-empresa.
        &ENDIF
        WHEN "cod-contrat-cambio":U THEN ASSIGN pFieldValue = RowObject.cod-contrat-cambio.
        WHEN "cod-contrat-cambio-dest":U THEN ASSIGN pFieldValue = RowObject.cod-contrat-cambio-dest.
        WHEN "cod-contrat-cambio-orig":U THEN ASSIGN pFieldValue = RowObject.cod-contrat-cambio-orig.
        WHEN "cod-docto":U THEN ASSIGN pFieldValue = RowObject.cod-docto.
        WHEN "cod-espec-docto":U THEN ASSIGN pFieldValue = RowObject.cod-espec-docto.
        WHEN "cod-estab":U THEN ASSIGN pFieldValue = RowObject.cod-estab.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-parcela":U THEN ASSIGN pFieldValue = RowObject.cod-parcela.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-serie":U THEN ASSIGN pFieldValue = RowObject.cod-serie.
        WHEN "cod-usuario":U THEN ASSIGN pFieldValue = RowObject.cod-usuario.
        WHEN "hra-maquina":U THEN ASSIGN pFieldValue = RowObject.hra-maquina.
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
        WHEN "dat-calc-juros":U THEN ASSIGN pFieldValue = RowObject.dat-calc-juros.
        WHEN "dat-liquidac-tit":U THEN ASSIGN pFieldValue = RowObject.dat-liquidac-tit.
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-movto":U THEN ASSIGN pFieldValue = RowObject.dat-movto.
        WHEN "dat-refer-contrat":U THEN ASSIGN pFieldValue = RowObject.dat-refer-contrat.
        WHEN "dat-today":U THEN ASSIGN pFieldValue = RowObject.dat-today.
        WHEN "dat-vinculac-tit":U THEN ASSIGN pFieldValue = RowObject.dat-vinculac-tit.
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
        WHEN "val-cotac-dia":U THEN ASSIGN pFieldValue = RowObject.val-cotac-dia.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-movto":U THEN ASSIGN pFieldValue = RowObject.val-movto.
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
        WHEN "cdn-emitente":U THEN ASSIGN pFieldValue = RowObject.cdn-emitente.
        &IF "{&mguni_version}" < "2.07A" &THEN
            WHEN "cdn-empresa":U THEN ASSIGN pFieldValue = RowObject.cdn-empresa.
        &ENDIF
        WHEN "cdn-portador":U THEN ASSIGN pFieldValue = RowObject.cdn-portador.
        WHEN "cdn-trans":U THEN ASSIGN pFieldValue = RowObject.cdn-trans.
        WHEN "idi-modalid":U THEN ASSIGN pFieldValue = RowObject.idi-modalid.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-seq":U THEN ASSIGN pFieldValue = RowObject.num-seq.
        WHEN "num-seq-pai":U THEN ASSIGN pFieldValue = RowObject.num-seq-pai.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice mvtcntrt-id
  Parameters:  
               retorna valor do campo cdn-empresa
               retorna valor do campo cod-estab
               retorna valor do campo cod-refer
               retorna valor do campo dat-refer-contrat
               retorna valor do campo cdn-emitente
               retorna valor do campo cod-espec-docto
               retorna valor do campo cod-serie
               retorna valor do campo cod-docto
               retorna valor do campo cod-parcela
               retorna valor do campo num-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdn-empresa LIKE movto-contrat-tit-export.cdn-empresa NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estab LIKE movto-contrat-tit-export.cod-estab NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-refer LIKE movto-contrat-tit-export.cod-refer NO-UNDO.
    DEFINE OUTPUT PARAMETER pdat-refer-contrat LIKE movto-contrat-tit-export.dat-refer-contrat NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-emitente LIKE movto-contrat-tit-export.cdn-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-espec-docto LIKE movto-contrat-tit-export.cod-espec-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-serie LIKE movto-contrat-tit-export.cod-serie NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-docto LIKE movto-contrat-tit-export.cod-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-parcela LIKE movto-contrat-tit-export.cod-parcela NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq LIKE movto-contrat-tit-export.num-seq NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdn-empresa = RowObject.cdn-empresa
           pcod-estab = RowObject.cod-estab
           pcod-refer = RowObject.cod-refer
           pdat-refer-contrat = RowObject.dat-refer-contrat
           pcdn-emitente = RowObject.cdn-emitente
           pcod-espec-docto = RowObject.cod-espec-docto
           pcod-serie = RowObject.cod-serie
           pcod-docto = RowObject.cod-docto
           pcod-parcela = RowObject.cod-parcela
           pnum-seq = RowObject.num-seq.

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
        WHEN "log-estorno":U THEN ASSIGN pFieldValue = RowObject.log-estorno.
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
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
  Purpose:     Reposiciona registro com base no °ndice mvtcntrt-id
  Parameters:  
               recebe valor do campo cdn-empresa
               recebe valor do campo cod-estab
               recebe valor do campo cod-refer
               recebe valor do campo dat-refer-contrat
               recebe valor do campo cdn-emitente
               recebe valor do campo cod-espec-docto
               recebe valor do campo cod-serie
               recebe valor do campo cod-docto
               recebe valor do campo cod-parcela
               recebe valor do campo num-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdn-empresa LIKE movto-contrat-tit-export.cdn-empresa NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estab LIKE movto-contrat-tit-export.cod-estab NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer LIKE movto-contrat-tit-export.cod-refer NO-UNDO.
    DEFINE INPUT PARAMETER pdat-refer-contrat LIKE movto-contrat-tit-export.dat-refer-contrat NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-emitente LIKE movto-contrat-tit-export.cdn-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pcod-espec-docto LIKE movto-contrat-tit-export.cod-espec-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-serie LIKE movto-contrat-tit-export.cod-serie NO-UNDO.
    DEFINE INPUT PARAMETER pcod-docto LIKE movto-contrat-tit-export.cod-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-parcela LIKE movto-contrat-tit-export.cod-parcela NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq LIKE movto-contrat-tit-export.num-seq NO-UNDO.

    FIND FIRST bfmovto-contrat-tit-export WHERE 
        bfmovto-contrat-tit-export.cdn-empresa = pcdn-empresa AND 
        bfmovto-contrat-tit-export.cod-estab = pcod-estab AND 
        bfmovto-contrat-tit-export.cod-refer = pcod-refer AND 
        bfmovto-contrat-tit-export.dat-refer-contrat = pdat-refer-contrat AND 
        bfmovto-contrat-tit-export.cdn-emitente = pcdn-emitente AND 
        bfmovto-contrat-tit-export.cod-espec-docto = pcod-espec-docto AND 
        bfmovto-contrat-tit-export.cod-serie = pcod-serie AND 
        bfmovto-contrat-tit-export.cod-docto = pcod-docto AND 
        bfmovto-contrat-tit-export.cod-parcela = pcod-parcela AND 
        bfmovto-contrat-tit-export.num-seq = pnum-seq NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmovto-contrat-tit-export THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmovto-contrat-tit-export)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
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
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tabela DBOProgram 
PROCEDURE pi-cria-tabela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-cdn-emitente            LIKE  movto-contrat-tit-export.cdn-emitente            NO-UNDO.
    DEF INPUT PARAM p-cdn-empresa             LIKE  movto-contrat-tit-export.cdn-empresa             NO-UNDO.
    DEF INPUT PARAM p-cdn-portador            LIKE  movto-contrat-tit-export.cdn-portador            NO-UNDO.
    DEF INPUT PARAM p-cdn-trans               LIKE  movto-contrat-tit-export.cdn-trans               NO-UNDO.
    DEF INPUT PARAM p-cod-contrat-cambio      LIKE  movto-contrat-tit-export.cod-contrat-cambio      NO-UNDO.
    DEF INPUT PARAM p-cod-contrat-cambio-dest LIKE  movto-contrat-tit-export.cod-contrat-cambio-dest NO-UNDO.
    DEF INPUT PARAM p-cod-contrat-cambio-orig LIKE  movto-contrat-tit-export.cod-contrat-cambio-orig NO-UNDO.
    DEF INPUT PARAM p-cod-docto               LIKE  movto-contrat-tit-export.cod-docto               NO-UNDO.
    DEF INPUT PARAM p-cod-espec-docto         LIKE  movto-contrat-tit-export.cod-espec-docto         NO-UNDO.
    DEF INPUT PARAM p-cod-estab               LIKE  movto-contrat-tit-export.cod-estab               NO-UNDO.
    DEF INPUT PARAM p-cod-parcela             LIKE  movto-contrat-tit-export.cod-parcela             NO-UNDO.
    DEF INPUT PARAM p-cod-refer               LIKE  movto-contrat-tit-export.cod-refer               NO-UNDO.
    DEF INPUT PARAM p-cod-serie               LIKE  movto-contrat-tit-export.cod-serie               NO-UNDO.
    DEF INPUT PARAM p-dat-calc-juros          LIKE  movto-contrat-tit-export.dat-calc-juros          NO-UNDO.
    DEF INPUT PARAM p-dat-liquidac-tit        LIKE  movto-contrat-tit-export.dat-liquidac-tit        NO-UNDO.
    DEF INPUT PARAM p-dat-movto               LIKE  movto-contrat-tit-export.dat-movto               NO-UNDO.
    DEF INPUT PARAM p-dat-refer-contrat       LIKE  movto-contrat-tit-export.dat-refer-contrat       NO-UNDO.
    DEF INPUT PARAM p-dat-vinculac-tit        LIKE  movto-contrat-tit-export.dat-vinculac-tit        NO-UNDO.
    DEF INPUT PARAM p-idi-modalid             LIKE  movto-contrat-tit-export.idi-modalid             NO-UNDO.
    DEF INPUT PARAM p-log-estorno             LIKE  movto-contrat-tit-export.log-estorno             NO-UNDO.
    DEF INPUT PARAM p-val-cotac-dia           LIKE  movto-contrat-tit-export.val-cotac-dia           NO-UNDO.
    DEF INPUT PARAM p-val-movto               LIKE  movto-contrat-tit-export.val-movto               NO-UNDO.
    DEF INPUT PARAM p-num-id                  AS INT FORMAT "99999999"                               NO-UNDO.

    DEF VAR v-num-seq     AS INT NO-UNDO.
    DEF VAR v-num-seq-pai AS INT NO-UNDO.
    DEF VAR v-soma        AS DEC NO-UNDO.
    DEF VAR v-num-id      AS INT NO-UNDO.

    DEF BUFFER b-movto-contrat-tit-export     FOR movto-contrat-tit-export.
    DEF BUFFER b-movto-contrat-tit-export-aux FOR movto-contrat-tit-export.
    DEF BUFFER b-contr-titulo-exp             FOR contr-titulo-exp.
    DEF BUFFER b-contr-titulo-exp-aux         FOR contr-titulo-exp.

    assign cQueryUseded = "Main".
    for each RowObject exclusive-lock:
       delete RowObject.
    end.

    {method/svc/autentic/autentic.i
        &vUserName="c-usuario"}
          
    /*BUSCA ULTIMA SEQUENCIA DO TITULO*/
    FOR EACH b-movto-contrat-tit-export NO-LOCK
        WHERE b-movto-contrat-tit-export.cdn-empresa       = p-cdn-empresa            
        AND   b-movto-contrat-tit-export.cod-estab         = p-cod-estab
        AND   b-movto-contrat-tit-export.cod-refer         = p-cod-refer
        AND   b-movto-contrat-tit-export.dat-refer-contrat = p-dat-refer-contrat
        AND   b-movto-contrat-tit-export.cdn-emitente      = p-cdn-emitente
        AND   b-movto-contrat-tit-export.cod-espec-docto   = p-cod-espec-docto
        AND   b-movto-contrat-tit-export.cod-serie         = p-cod-serie
        AND   b-movto-contrat-tit-export.cod-docto         = p-cod-docto
        AND   b-movto-contrat-tit-export.cod-parcela       = p-cod-parcela 
        BY    b-movto-contrat-tit-export.num-seq:
    
        ASSIGN V-NUM-SEQ = b-movto-contrat-tit-export.num-seq.

        IF b-movto-contrat-tit-export.cdn-trans = 3 THEN
            ASSIGN v-soma = v-soma + b-movto-contrat-tit-export.val-movto.
    END.
    ASSIGN V-NUM-SEQ = v-num-seq + 1.

    /*PARA DESTINACAO DEVERµ BUSCAR A SEQUENCIA PAI*/

    create RowObject.
    ASSIGN RowObject.cdn-emitente            = p-cdn-emitente           
           RowObject.cdn-empresa             = p-cdn-empresa            
           RowObject.cdn-portador            = p-cdn-portador           
           RowObject.cdn-trans               = IF p-cdn-trans = 21 THEN 2 ELSE p-cdn-trans
           RowObject.cod-contrat-cambio      = p-cod-contrat-cambio     
           RowObject.cod-contrat-cambio-dest = p-cod-contrat-cambio-dest
           RowObject.cod-contrat-cambio-orig = p-cod-contrat-cambio-orig
           RowObject.cod-docto               = p-cod-docto              
           RowObject.cod-espec-docto         = p-cod-espec-docto        
           RowObject.cod-estab               = p-cod-estab              
           RowObject.cod-parcela             = p-cod-parcela            
           RowObject.cod-refer               = p-cod-refer              
           RowObject.cod-serie               = p-cod-serie              
           RowObject.cod-usuario             = c-usuario      
           RowObject.dat-calc-juros          = p-dat-calc-juros         
           RowObject.dat-liquidac-tit        = p-dat-liquidac-tit       
           RowObject.dat-movto               = p-dat-movto              
           RowObject.dat-refer-contrat       = p-dat-refer-contrat      
           RowObject.dat-today               = TODAY       
           RowObject.dat-vinculac-tit        = p-dat-vinculac-tit       
           RowObject.hra-maquina             = string(TIME, "HH:MM")
           RowObject.idi-modalid             = p-idi-modalid            
           RowObject.log-estorno             = p-log-estorno            
           RowObject.num-seq                 = V-NUM-SEQ
           RowObject.num-seq-pai             = v-num-seq-pai      
           RowObject.val-cotac-dia           = p-val-cotac-dia   
           RowObject.val-movto               = p-val-movto.


           &if defined(BF_FIN_MEC_FUT_CFL2) &then
                IF l-funcao-recta-cambio-fut = YES THEN DO:
                   ASSIGN RowObject.num-id-movto-contrat = NEXT-VALUE(seq-movto-contrat-tit-export)
                          RowObject.num-id-movto-operac-financ = p-num-id
                          v-num-id = CURRENT-VALUE(seq-movto-contrat-tit-export).
                END.
           &endif
           /*
           RowObject.int-1                   =  id do contrato + sequencia   .    
           */
    
    run createRecord in this-procedure.
    
    /*SOMA TBM MOVIMENTO QUE ESTA SENDO CRIADO*/
    IF p-cdn-trans = 3 THEN
        ASSIGN v-soma = v-soma + p-val-movto.

    IF p-cdn-trans = 21  OR 
       p-cdn-trans = 3   THEN DO:
        FOR EACH b-contr-titulo-exp exclusive-lock 
             where b-contr-titulo-exp.ep-codigo     = p-cdn-empresa
             and   b-contr-titulo-exp.cod-estabel   = p-cod-estab                
             and   b-contr-titulo-exp.referencia    = p-cod-refer                
             and   b-contr-titulo-exp.dt-referencia = p-dat-refer-contrat
             and   b-contr-titulo-exp.cod-emitente  = p-cdn-emitente
             and   b-contr-titulo-exp.cod-esp       = p-cod-espec-docto              
             and   b-contr-titulo-exp.serie         = p-cod-serie                      
             and   b-contr-titulo-exp.nr-docto      = p-cod-docto                   
             and   b-contr-titulo-exp.parcela       = p-cod-parcela 
             and   b-contr-titulo-exp.dt-vinculado  = p-dat-vinculac-tit:

            IF P-CDN-TRANS = 21 THEN
                ASSIGN b-contr-titulo-exp.situacao = 5.
            
            IF P-CDN-TRANS = 3 AND 
                v-soma     = b-contr-titulo-exp.vl-vinculado-me THEN
                ASSIGN b-contr-titulo-exp.situacao = 1.
        END.
    END.

    &if defined(BF_FIN_MEC_FUT_CFL2) &then
        IF l-funcao-recta-cambio-fut THEN DO:
            IF p-cdn-trans = 3 THEN DO:
                
                RUN pi-cria-val-movto-contrat-tit-export(INPUT v-num-id).  
                IF RETURN-VALUE = "NOK":U THEN
                    RETURN "NOK":U.
            END.
            ELSE IF p-cdn-trans = 1 THEN DO:
                FIND FIRST movto-contrat-tit-export NO-LOCK
                    WHERE movto-contrat-tit-export.num-id-movto-contrat = v-num-id NO-ERROR.
                IF AVAIL movto-contrat-tit-export THEN DO:
                    FIND FIRST contrato-exp 
                        WHERE  contrato-exp.cod-estabel    = movto-contrat-tit-export.cod-estab
                        AND contrato-exp.ep-codigo         = movto-contrat-tit-export.cdn-empresa
                        AND contrato-exp.dt-referencia     = p-dat-refer-contrat
                        AND contrato-exp.referencia        = p-cod-refer
                        AND contrato-exp.tp-contrato-exp   = 1   NO-LOCK NO-ERROR.
                    IF AVAIL contrato-exp THEN DO:
                        FIND FIRST b-movto-contrat-tit-export NO-LOCK
                            WHERE b-movto-contrat-tit-export.cdn-empresa     = movto-contrat-tit-export.cdn-empresa            
                            AND   b-movto-contrat-tit-export.cod-estab       = movto-contrat-tit-export.cod-estab
                            AND   b-movto-contrat-tit-export.cdn-emitente    = movto-contrat-tit-export.cdn-emitente
                            AND   b-movto-contrat-tit-export.cod-espec-docto = movto-contrat-tit-export.cod-espec-docto
                            AND   b-movto-contrat-tit-export.cod-serie       = movto-contrat-tit-export.cod-serie
                            AND   b-movto-contrat-tit-export.cod-docto       = movto-contrat-tit-export.cod-docto
                            AND   b-movto-contrat-tit-export.cod-parcela     = movto-contrat-tit-export.cod-parcela
                            AND   b-movto-contrat-tit-export.cdn-trans       = 3
                            AND   b-movto-contrat-tit-export.cod-refer       = movto-contrat-tit-export.cod-contrat-cambio-orig
                            AND   b-movto-contrat-tit-export.dat-vinculac-tit = movto-contrat-tit-export.dat-vinculac-tit 
                            AND   b-movto-contrat-tit-export.cod-contrat-cambio-dest = movto-contrat-tit-export.cod-refer  NO-ERROR.
                        IF AVAIL b-movto-contrat-tit-export THEN DO:
                            
                            RUN pi-gera-lancto-cambio-futuro-cfl(INPUT b-movto-contrat-tit-export.num-id-movto-contrat,
                                                                 INPUT "Inclus∆o",
                                                                 INPUT-OUTPUT TABLE tt_integr_mec_cfl,
                                                                 INPUT-OUTPUT TABLE tt_erro_mec).  
                            IF RETURN-VALUE = "NOK":U THEN
                                RETURN "NOK":U.
                        END.
                    END.
                END.
            END.
            ELSE IF p-cdn-trans = 9 THEN DO:
                        
                        RUN pi-gera-saida-fluxo-transitorio ( INPUT v-num-id, 
                                                              INPUT "Inclus∆o", 
                                                              INPUT-OUTPUT TABLE tt_integr_mec_cfl, 
                                                              INPUT-OUTPUT TABLE tt_erro_mec ).
    
                        
                        IF RETURN-VALUE = "NOK":U THEN
                            RETURN "NOK":U.
                    
                
            END.
        END.
    &endif
    
    FIND FIRST b-contr-titulo-exp-aux
         WHERE b-contr-titulo-exp-aux.ep-codigo    = p-cdn-empresa
           and b-contr-titulo-exp-aux.cod-estabel  = p-cod-estab
           and b-contr-titulo-exp-aux.cod-emitente = p-cdn-emitente
           and b-contr-titulo-exp-aux.cod-esp      = p-cod-espec-docto
           and b-contr-titulo-exp-aux.serie        = p-cod-serie      
           and b-contr-titulo-exp-aux.nr-docto     = p-cod-docto      
           and b-contr-titulo-exp-aux.parcela      = p-cod-parcela    
           AND b-contr-titulo-exp-aux.nr-contrato  = p-cod-contrat-cambio
           AND b-contr-titulo-exp-aux.dt-contrato  = p-dat-refer-contrat EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL b-contr-titulo-exp-aux THEN DO:
        FIND FIRST b-movto-contrat-tit-export-aux
            WHERE b-movto-contrat-tit-export-aux.cdn-empresa    = b-contr-titulo-exp-aux.ep-codigo   
            and b-movto-contrat-tit-export-aux.cod-estab        = b-contr-titulo-exp-aux.cod-estabel 
            and b-movto-contrat-tit-export-aux.cdn-emitente     = b-contr-titulo-exp-aux.cod-emitente
            and b-movto-contrat-tit-export-aux.cod-espec-docto  = b-contr-titulo-exp-aux.cod-esp     
            and b-movto-contrat-tit-export-aux.cod-serie        = b-contr-titulo-exp-aux.serie       
            and b-movto-contrat-tit-export-aux.cod-docto        = b-contr-titulo-exp-aux.nr-docto    
            and b-movto-contrat-tit-export-aux.cod-parcela      = b-contr-titulo-exp-aux.parcela     
            and b-movto-contrat-tit-export-aux.cdn-trans        = 3        
            AND b-movto-contrat-tit-export-aux.log-estorno      = NO
            and b-movto-contrat-tit-export-aux.dat-vinculac-tit > b-contr-titulo-exp-aux.dt-vinculado NO-LOCK NO-ERROR.
        IF AVAIL b-movto-contrat-tit-export-aux THEN
           ASSIGN b-contr-titulo-exp-aux.dt-vinculado = b-movto-contrat-tit-export-aux.dat-vinculac-tit.
    END.


    RETURN RETURN-VALUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-destinacao DBOProgram 
PROCEDURE pi-verifica-destinacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-cod-refer         LIKE movto-contrat-tit-export.cod-refer         NO-UNDO. 
    DEF INPUT PARAM p-dat-refer-contrat LIKE movto-contrat-tit-export.dat-refer-contrat NO-UNDO. 
    DEF INPUT PARAM p-cdn-empresa       LIKE movto-contrat-tit-export.cdn-empresa       NO-UNDO.
    DEF INPUT PARAM p-cod-estab         LIKE movto-contrat-tit-export.cod-estab         NO-UNDO. 
    DEF INPUT PARAM p-cod-espec-docto   LIKE movto-contrat-tit-export.cod-espec-docto   NO-UNDO. 
    DEF INPUT PARAM p-cod-serie         LIKE movto-contrat-tit-export.cod-serie         NO-UNDO. 
    DEF INPUT PARAM p-cod-docto         LIKE movto-contrat-tit-export.cod-docto         NO-UNDO. 
    DEF INPUT PARAM p-cod-parcela       LIKE movto-contrat-tit-export.cod-parcela       NO-UNDO.
    DEF INPUT PARAM p-cdn-emitente      LIKE movto-contrat-tit-export.cdn-emitente      NO-UNDO. 
    DEF OUTPUT PARAM p-destinado        AS LOG NO-UNDO.    

    ASSIGN p-destinado = NO.
    
    /*BUSCA OS MOVIMENTOS DO TITULO*/
    FOR EACH  movto-contrat-tit-export NO-LOCK
        WHERE movto-contrat-tit-export.cdn-empresa       = p-cdn-empresa            
        AND   movto-contrat-tit-export.cod-estab         = p-cod-estab
        AND   movto-contrat-tit-export.cdn-emitente      = p-cdn-emitente
        AND   movto-contrat-tit-export.cod-espec-docto   = p-cod-espec-docto
        AND   movto-contrat-tit-export.cod-serie         = p-cod-serie
        AND   movto-contrat-tit-export.cod-docto         = p-cod-docto
        AND   movto-contrat-tit-export.cod-parcela       = p-cod-parcela
        AND   movto-contrat-tit-export.cdn-trans         = 3:
        
        IF movto-contrat-tit-export.log-estorno = NO THEN
            ASSIGN p-destinado = YES.
    END.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryMain DBOProgram 
PROCEDURE OpenQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-movto DBOProgram 
PROCEDURE pi-busca-movto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-cdn-empresa       LIKE movto-contrat-tit-export.cdn-empresa       NO-UNDO.
    DEF INPUT PARAM p-cod-estab         LIKE movto-contrat-tit-export.cod-estab         NO-UNDO. 
    DEF INPUT PARAM p-cod-refer         LIKE movto-contrat-tit-export.cod-refer         NO-UNDO. 
    DEF INPUT PARAM p-dat-refer-contrat LIKE movto-contrat-tit-export.dat-refer-contrat NO-UNDO. 
    DEF INPUT PARAM p-cdn-emitente      LIKE movto-contrat-tit-export.cdn-emitente      NO-UNDO. 
    DEF INPUT PARAM p-cod-espec-docto   LIKE movto-contrat-tit-export.cod-espec-docto   NO-UNDO. 
    DEF INPUT PARAM p-cod-serie         LIKE movto-contrat-tit-export.cod-serie         NO-UNDO. 
    DEF INPUT PARAM p-cod-docto         LIKE movto-contrat-tit-export.cod-docto         NO-UNDO. 
    DEF INPUT PARAM p-cod-parcela       LIKE movto-contrat-tit-export.cod-parcela       NO-UNDO.
    DEF INPUT PARAM p-cod-movto         LIKE movto-contrat-tit-export.cdn-trans         NO-UNDO.
    DEF INPUT PARAM p-dat-vincul        LIKE movto-contrat-tit-export.dat-vinculac-tit  NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-movto-contrat.
    
    /**** RELAÄ«O DE TRANSAÄÂES ****
    &glob val1 Vinculaá∆o
    &glob val2 Liquidaá∆o
    &glob val3 Destinaá∆o
    &glob val4 Devoluá∆o de Reais
    &glob val5 Cancelamento c/Desemb
    &glob val6 Cancelamento s/Desemb
    &glob val7 Abatimento
    &glob val8 Devoluá∆o da Devoluá∆o
    *****/

    FOR EACH tt-movto-contrat:
        DELETE tt-movto-contrat.
    END.                        

    /*BUSCA OS MOVIMENTOS DO TITULO*/
    FOR EACH movto-contrat-tit-export
        WHERE movto-contrat-tit-export.cdn-empresa       = p-cdn-empresa            
        AND   movto-contrat-tit-export.cod-estab         = p-cod-estab
        AND   movto-contrat-tit-export.cdn-emitente      = p-cdn-emitente
        AND   movto-contrat-tit-export.cod-espec-docto   = p-cod-espec-docto
        AND   movto-contrat-tit-export.cod-serie         = p-cod-serie
        AND   movto-contrat-tit-export.cod-docto         = p-cod-docto
        AND   movto-contrat-tit-export.cod-parcela       = p-cod-parcela NO-LOCK:    
    
        /* DESCONSIDERA ESTORNADOS */
        IF movto-contrat-tit-export.log-estorno = YES THEN
            NEXT.

        /* SE PASSOU REFERENCIA BUSCA SOMENE MOVTOS DAQUELA REFERENCIA */
        IF p-cod-refer <> "" THEN       
            IF p-cod-refer         <> movto-contrat-tit-export.cod-refer         OR 
               p-dat-refer-contrat <> movto-contrat-tit-export.dat-refer-contrat THEN
                NEXT.

        /* PARA CONTRATOS EMPRESTIMO ONDE O TITULO PODE SER VINCULADO MAIS DE UMA VEZ AO CONTRATO */
        IF p-dat-vincul <> ? THEN
            IF p-dat-vincul <> movto-contrat-tit-export.dat-vinculac-tit THEN
                NEXT.
        
       IF p-cod-movto   = 0 /*Todos*/                                             OR 
          (p-cod-movto <> 0 AND p-cod-movto = movto-contrat-tit-export.cdn-trans) THEN do:
           CREATE tt-movto-contrat.
           BUFFER-COPY movto-contrat-tit-export TO tt-movto-contrat.
       END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-saldo-portador DBOProgram 
PROCEDURE pi-atualiza-saldo-portador :

    DEF INPUT PARAM p-cdn-empresa       LIKE titcr-port-mec-liq.ep-codigo   NO-UNDO.
    DEF INPUT PARAM p-cod-estab         LIKE titcr-port-mec-liq.cod-estabel NO-UNDO. 
    DEF INPUT PARAM p-cod-espec-docto   LIKE titcr-port-mec-liq.cod-esp     NO-UNDO. 
    DEF INPUT PARAM p-cod-serie         LIKE titcr-port-mec-liq.serie       NO-UNDO. 
    DEF INPUT PARAM p-cod-docto         LIKE titcr-port-mec-liq.nr-docto    NO-UNDO. 
    DEF INPUT PARAM p-cod-parcela       LIKE titcr-port-mec-liq.parcela     NO-UNDO.
    DEF INPUT PARAM p-val-saldo         LIKE port-mec-liq.valor-saldo       NO-UNDO.

    FIND FIRST titcr-port-mec-liq NO-LOCK
        WHERE titcr-port-mec-liq.ep-codigo   = p-cdn-empresa  
          AND titcr-port-mec-liq.cod-estabel = p-cod-estab
          AND titcr-port-mec-liq.cod-esp     = p-cod-espec-docto 
          AND titcr-port-mec-liq.serie       = p-cod-serie   
          and titcr-port-mec-liq.nr-docto    = p-cod-docto
          AND titcr-port-mec-liq.parcela     = p-cod-parcela NO-ERROR.
    IF AVAIL titcr-port-mec-liq THEN DO:
        FIND FIRST port-mec-liq EXCLUSIVE-LOCK
            WHERE port-mec-liq.ep-codigo    = titcr-port-mec-liq.ep-codigo
              AND port-mec-liq.cod-portador = titcr-port-mec-liq.cod-portador
              AND port-mec-liq.modalidade   = titcr-port-mec-liq.modalidade NO-ERROR.
        IF AVAIL port-mec-liq THEN
            ASSIGN port-mec-liq.valor-saldo    = port-mec-liq.valor-saldo    - p-val-saldo 
                   port-mec-liq.valor-saldo-me = port-mec-liq.valor-saldo-me - p-val-saldo. 
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-estorna DBOProgram 
PROCEDURE pi-estorna :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-cdn-empresa       LIKE movto-contrat-tit-export.cdn-empresa       NO-UNDO.
    DEF INPUT PARAM p-cod-estab         LIKE movto-contrat-tit-export.cod-estab         NO-UNDO. 
    DEF INPUT PARAM p-cod-refer         LIKE movto-contrat-tit-export.cod-refer         NO-UNDO. 
    DEF INPUT PARAM p-dat-refer-contrat LIKE movto-contrat-tit-export.dat-refer-contrat NO-UNDO. 
    DEF INPUT PARAM p-cdn-emitente      LIKE movto-contrat-tit-export.cdn-emitente      NO-UNDO. 
    DEF INPUT PARAM p-cod-espec-docto   LIKE movto-contrat-tit-export.cod-espec-docto   NO-UNDO. 
    DEF INPUT PARAM p-cod-serie         LIKE movto-contrat-tit-export.cod-serie         NO-UNDO. 
    DEF INPUT PARAM p-cod-docto         LIKE movto-contrat-tit-export.cod-docto         NO-UNDO. 
    DEF INPUT PARAM p-cod-parcela       LIKE movto-contrat-tit-export.cod-parcela       NO-UNDO.
    DEF INPUT PARAM p-dat-vincul        LIKE movto-contrat-tit-export.dat-vinculac-tit  NO-UNDO.
    DEF INPUT PARAM p-cdn-trans         LIKE movto-contrat-tit-export.cdn-trans         NO-UNDO.
        
    DEF BUFFER b-movto-contrat-tit-export FOR movto-contrat-tit-export.

    IF p-cdn-trans = 9 THEN DO:
        &if defined(BF_FIN_MEC_FUT_CFL2) &then
            FIND FIRST movto-contrat-tit-export EXCLUSIVE-LOCK
                WHERE movto-contrat-tit-export.cdn-empresa       = p-cdn-empresa            
                AND   movto-contrat-tit-export.cod-estab         = p-cod-estab
                AND   movto-contrat-tit-export.cod-refer         = p-cod-refer         
                AND   movto-contrat-tit-export.dat-refer-contrat = p-dat-refer-contrat 
                AND   movto-contrat-tit-export.cdn-emitente      = p-cdn-emitente
                AND   movto-contrat-tit-export.cod-espec-docto   = p-cod-espec-docto
                AND   movto-contrat-tit-export.cod-serie         = p-cod-serie
                AND   movto-contrat-tit-export.cod-docto         = p-cod-docto
                AND   movto-contrat-tit-export.cod-parcela       = p-cod-parcela 
                AND   movto-contrat-tit-export.dat-vinculac-tit  = p-dat-vincul 
                AND   movto-contrat-tit-export.cdn-trans         = 9 NO-ERROR.
            IF AVAIL movto-contrat-tit-export AND l-funcao-recta-cambio-fut THEN DO:
                ASSIGN movto-contrat-tit-export.log-estorno = YES.
                RUN pi-gera-saida-fluxo-transitorio ( INPUT movto-contrat-tit-export.num-id-movto-contrat, 
                                                      INPUT "Estorno", 
                                                      INPUT-OUTPUT TABLE tt_integr_mec_cfl, 
                                                      INPUT-OUTPUT TABLE tt_erro_mec ).
            END.
        &endif
    END.
    ELSE DO:
        /* ELIMINA MOVIMENTOS DO TITULO */
        FOR EACH movto-contrat-tit-export
            WHERE movto-contrat-tit-export.cdn-empresa       = p-cdn-empresa            
            AND   movto-contrat-tit-export.cod-estab         = p-cod-estab
            AND   movto-contrat-tit-export.cod-refer         = p-cod-refer         
            AND   movto-contrat-tit-export.dat-refer-contrat = p-dat-refer-contrat 
            AND   movto-contrat-tit-export.cdn-emitente      = p-cdn-emitente
            AND   movto-contrat-tit-export.cod-espec-docto   = p-cod-espec-docto
            AND   movto-contrat-tit-export.cod-serie         = p-cod-serie
            AND   movto-contrat-tit-export.cod-docto         = p-cod-docto
            AND   movto-contrat-tit-export.cod-parcela       = p-cod-parcela EXCLUSIVE-LOCK:

            /* retornar o saldo do portador no cancelamento do t°tulo - transaá∆o 9 Liquidaá∆o T°tulo EmprÇstimo Destinado */
            if  movto-contrat-tit-export.cdn-trans = 9
            and movto-contrat-tit-export.log-estorno = no then do:
                run pi-atualiza-saldo-portador(input movto-contrat-tit-export.cdn-empresa,
                                               input movto-contrat-tit-export.cod-estab,
                                               input movto-contrat-tit-export.cod-espec-docto,
                                               input movto-contrat-tit-export.cod-serie,
                                               input movto-contrat-tit-export.cod-docto,
                                               input movto-contrat-tit-export.cod-parcela,
                                               input movto-contrat-tit-export.val-movto * -1).
            end.

            ASSIGN movto-contrat-tit-export.log-estorno = YES.
    
            IF movto-contrat-tit-export.cdn-trans = 1 THEN DO:
                /* Ao Cancelar movimento de Vinculaá∆o Verifica se ele Tem um Movimento de Destinaá∆o */
                FOR EACH b-movto-contrat-tit-export 
                    WHERE b-movto-contrat-tit-export.cdn-empresa     = movto-contrat-tit-export.cdn-empresa            
                    AND   b-movto-contrat-tit-export.cod-estab       = movto-contrat-tit-export.cod-estab
                    AND   b-movto-contrat-tit-export.cdn-emitente    = movto-contrat-tit-export.cdn-emitente
                    AND   b-movto-contrat-tit-export.cod-espec-docto = movto-contrat-tit-export.cod-espec-docto
                    AND   b-movto-contrat-tit-export.cod-serie       = movto-contrat-tit-export.cod-serie
                    AND   b-movto-contrat-tit-export.cod-docto       = movto-contrat-tit-export.cod-docto
                    AND   b-movto-contrat-tit-export.cod-parcela     = movto-contrat-tit-export.cod-parcela
                    AND   b-movto-contrat-tit-export.cdn-trans       = 3
                    AND   b-movto-contrat-tit-export.cod-refer       = movto-contrat-tit-export.cod-contrat-cambio-orig 
                    AND   b-movto-contrat-tit-export.dat-vinculac-tit = movto-contrat-tit-export.dat-vinculac-tit 
                    AND   b-movto-contrat-tit-export.cod-contrat-cambio-dest = movto-contrat-tit-export.cod-refer EXCLUSIVE-LOCK:
                    ASSIGN b-movto-contrat-tit-export.log-estorno = YES.
                    &if defined(BF_FIN_MEC_FUT_CFL2) &then
                        IF l-funcao-recta-cambio-fut THEN DO:
                            FIND FIRST contrato-exp 
                                WHERE  contrato-exp.cod-estabel    = movto-contrat-tit-export.cod-estab
                                AND contrato-exp.ep-codigo         = movto-contrat-tit-export.cdn-empresa
                                AND contrato-exp.dt-referencia     = p-dat-refer-contrat
                                AND contrato-exp.referencia        = p-cod-refer
                                AND contrato-exp.tp-contrato-exp   = 1   NO-LOCK NO-ERROR.
                            IF AVAIL contrato-exp THEN DO:
                                RUN pi-gera-lancto-cambio-futuro-cfl(INPUT b-movto-contrat-tit-export.num-id-movto-contrat,
                                                                     INPUT "Estorno",
                                                                     INPUT-OUTPUT TABLE tt_integr_mec_cfl,
                                                                     INPUT-OUTPUT TABLE tt_erro_mec). 
                                IF RETURN-VALUE = "NOK":U THEN
                                    RETURN "NOK":U.
                            END.
                        END.
                    &endif
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-tit-exist-mec DBOProgram 
PROCEDURE pi-valida-tit-exist-mec:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-cdn-empresa       LIKE contr-titulo-exp.ep-codigo     NO-UNDO.
    DEF INPUT PARAM p-cod-estab         LIKE contr-titulo-exp.cod-estabel   NO-UNDO. 
    DEF INPUT PARAM p-cod-espec-docto   LIKE contr-titulo-exp.cod-esp       NO-UNDO. 
    DEF INPUT PARAM p-cod-serie         LIKE contr-titulo-exp.serie         NO-UNDO. 
    DEF INPUT PARAM p-cod-docto         LIKE contr-titulo-exp.nr-docto      NO-UNDO. 
    DEF INPUT PARAM p-cod-parcela       LIKE contr-titulo-exp.parcela       NO-UNDO.
    DEF OUTPUT PARAM p-log-tit-mec      AS LOGICAL                          NO-UNDO.
    

    IF NOT CAN-FIND(FIRST contr-titulo-exp NO-LOCK
                    WHERE contr-titulo-exp.ep-codigo     = p-cdn-empresa      
                      and contr-titulo-exp.cod-estabel   = p-cod-estab        
                      and contr-titulo-exp.cod-esp       = p-cod-espec-docto  
                      and contr-titulo-exp.serie         = p-cod-serie        
                      and contr-titulo-exp.nr-docto      = p-cod-docto        
                      and contr-titulo-exp.parcela       = p-cod-parcela      
                      ) THEN
        ASSIGN p-log-tit-mec = YES.
    
    RETURN "OK":U.
END PROCEDURE.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-id-tit-acr DBOProgram 
PROCEDURE pi-atualiza-id-tit-acr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-cdn-empresa       LIKE movto-contrat-tit-export.cdn-empresa       NO-UNDO.
    DEF INPUT PARAM p-cod-estab         LIKE movto-contrat-tit-export.cod-estab         NO-UNDO. 
    DEF INPUT PARAM p-cod-refer         LIKE movto-contrat-tit-export.cod-refer         NO-UNDO. 
    DEF INPUT PARAM p-dat-refer-contrat LIKE movto-contrat-tit-export.dat-refer-contrat NO-UNDO. 
    DEF INPUT PARAM p-cdn-emitente      LIKE movto-contrat-tit-export.cdn-emitente      NO-UNDO. 
    DEF INPUT PARAM p-cod-espec-docto   LIKE movto-contrat-tit-export.cod-espec-docto   NO-UNDO. 
    DEF INPUT PARAM p-cod-serie         LIKE movto-contrat-tit-export.cod-serie         NO-UNDO. 
    DEF INPUT PARAM p-cod-docto         LIKE movto-contrat-tit-export.cod-docto         NO-UNDO. 
    DEF INPUT PARAM p-cod-parcela       LIKE movto-contrat-tit-export.cod-parcela       NO-UNDO.
    DEF INPUT PARAM p-dat-vincul        LIKE movto-contrat-tit-export.dat-vinculac-tit  NO-UNDO.
    DEF INPUT PARAM p-cod-movto         AS INT NO-UNDO.
    DEF INPUT PARAM p-num-id            AS INT NO-UNDO.
    
 
    /*BUSCA OS MOVIMENTOS DO TITULO*/
    FIND FIRST movto-contrat-tit-export EXCLUSIVE-LOCK
        WHERE movto-contrat-tit-export.cdn-empresa       = p-cdn-empresa            
        AND   movto-contrat-tit-export.cod-estab         = p-cod-estab
        AND   movto-contrat-tit-export.cdn-emitente      = p-cdn-emitente
        AND   movto-contrat-tit-export.cod-espec-docto   = p-cod-espec-docto
        AND   movto-contrat-tit-export.cod-serie         = p-cod-serie
        AND   movto-contrat-tit-export.cod-docto         = p-cod-docto
        AND   movto-contrat-tit-export.cod-parcela       = p-cod-parcela
        AND   movto-contrat-tit-export.cdn-trans         = p-cod-movto
        AND   movto-contrat-tit-export.dat-vinculac-tit  = p-dat-vincul NO-ERROR.
    IF  AVAIL movto-contrat-tit-export THEN do:
        ASSIGN movto-contrat-tit-export.num-livre-2 = p-num-id.
    END.
    
    RETURN "OK":U.
END PROCEDURE.
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-id-cmg DBOProgram 
PROCEDURE pi-atualiza-id-CMG :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-cdn-empresa       LIKE movto-contrat-tit-export.cdn-empresa       NO-UNDO.
    DEF INPUT PARAM p-cod-estab         LIKE movto-contrat-tit-export.cod-estab         NO-UNDO. 
    DEF INPUT PARAM p-cod-refer         LIKE movto-contrat-tit-export.cod-refer         NO-UNDO. 
    DEF INPUT PARAM p-dat-refer-contrat LIKE movto-contrat-tit-export.dat-refer-contrat NO-UNDO. 
    DEF INPUT PARAM p-cdn-emitente      LIKE movto-contrat-tit-export.cdn-emitente      NO-UNDO. 
    DEF INPUT PARAM p-cod-espec-docto   LIKE movto-contrat-tit-export.cod-espec-docto   NO-UNDO. 
    DEF INPUT PARAM p-cod-serie         LIKE movto-contrat-tit-export.cod-serie         NO-UNDO. 
    DEF INPUT PARAM p-cod-docto         LIKE movto-contrat-tit-export.cod-docto         NO-UNDO. 
    DEF INPUT PARAM p-cod-parcela       LIKE movto-contrat-tit-export.cod-parcela       NO-UNDO.
    DEF INPUT PARAM p-dat-vincul        LIKE movto-contrat-tit-export.dat-vinculac-tit  NO-UNDO.
    DEF INPUT PARAM p-cod-movto         AS INT.
    DEF INPUT PARAM p-num-id            AS INT.
    

    /*BUSCA OS MOVIMENTOS DO TITULO*/
    FIND FIRST movto-contrat-tit-export EXCLUSIVE-LOCK
        WHERE movto-contrat-tit-export.cdn-empresa       = p-cdn-empresa            
        AND   movto-contrat-tit-export.cod-estab         = p-cod-estab
        AND   movto-contrat-tit-export.cod-refer         = p-cod-refer
        AND   movto-contrat-tit-export.dat-refer-contrat = p-dat-refer-contrat
        AND   movto-contrat-tit-export.cdn-emitente      = p-cdn-emitente
        AND   movto-contrat-tit-export.cod-espec-docto   = p-cod-espec-docto
        AND   movto-contrat-tit-export.cod-serie         = p-cod-serie
        AND   movto-contrat-tit-export.cod-docto         = p-cod-docto
        AND   movto-contrat-tit-export.cod-parcela       = p-cod-parcela
        AND   movto-contrat-tit-export.cdn-trans         = p-cod-movto
        AND   movto-contrat-tit-export.dat-vinculac-tit  = p-dat-vincul
        AND   movto-contrat-tit-export.log-estorno       = NO NO-ERROR.
    IF  AVAIL movto-contrat-tit-export THEN do:
        ASSIGN movto-contrat-tit-export.num-livre-1 = p-num-id.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-destinado DBOProgram 
PROCEDURE pi-verifica-destinado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-cod-refer         LIKE movto-contrat-tit-export.cod-refer         NO-UNDO. 
    DEF INPUT PARAM p-dat-refer-contrat LIKE movto-contrat-tit-export.dat-refer-contrat NO-UNDO. 
    DEF INPUT PARAM p-dat-vincul        LIKE movto-contrat-tit-export.dat-vinculac-tit  NO-UNDO.
    DEF INPUT PARAM p-cdn-empresa       LIKE movto-contrat-tit-export.cdn-empresa       NO-UNDO.
    DEF INPUT PARAM p-cod-estab         LIKE movto-contrat-tit-export.cod-estab         NO-UNDO. 
    DEF INPUT PARAM p-cod-espec-docto   LIKE movto-contrat-tit-export.cod-espec-docto   NO-UNDO. 
    DEF INPUT PARAM p-cod-serie         LIKE movto-contrat-tit-export.cod-serie         NO-UNDO. 
    DEF INPUT PARAM p-cod-docto         LIKE movto-contrat-tit-export.cod-docto         NO-UNDO. 
    DEF INPUT PARAM p-cod-parcela       LIKE movto-contrat-tit-export.cod-parcela       NO-UNDO.
    DEF INPUT PARAM p-cdn-emitente      LIKE movto-contrat-tit-export.cdn-emitente      NO-UNDO. 
    DEF OUTPUT PARAM p-destinado        AS LOG NO-UNDO.    

    /*BUSCA OS MOVIMENTOS DO TITULO*/
    FIND FIRST movto-contrat-tit-export EXCLUSIVE-LOCK
        WHERE movto-contrat-tit-export.cdn-empresa       = p-cdn-empresa            
        AND   movto-contrat-tit-export.cod-estab         = p-cod-estab
        AND   movto-contrat-tit-export.cdn-emitente      = p-cdn-emitente
        AND   movto-contrat-tit-export.cod-espec-docto   = p-cod-espec-docto
        AND   movto-contrat-tit-export.cod-serie         = p-cod-serie
        AND   movto-contrat-tit-export.cod-docto         = p-cod-docto
        AND   movto-contrat-tit-export.cod-parcela       = p-cod-parcela
        AND   movto-contrat-tit-export.cdn-trans         = 3
        AND   movto-contrat-tit-export.dat-vinculac-tit  = p-dat-vincul NO-ERROR.
    IF  AVAIL movto-contrat-tit-export THEN
        ASSIGN p-destinado = YES.
    ELSE
        ASSIGN p-destinado = NO.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-num-id DBOProgram 
PROCEDURE pi-busca-num-id :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-cdn-empresa          LIKE movto-contrat-tit-export.cdn-empresa          NO-UNDO.
    DEF INPUT  PARAM p-cod-estab            LIKE movto-contrat-tit-export.cod-estab            NO-UNDO. 
    DEF INPUT  PARAM p-cod-refer            LIKE movto-contrat-tit-export.cod-refer            NO-UNDO. 
    DEF INPUT  PARAM p-dat-refer-contrat    LIKE movto-contrat-tit-export.dat-refer-contrat    NO-UNDO. 
    DEF INPUT  PARAM p-cdn-emitente         LIKE movto-contrat-tit-export.cdn-emitente         NO-UNDO. 
    DEF INPUT  PARAM p-cod-espec-docto      LIKE movto-contrat-tit-export.cod-espec-docto      NO-UNDO. 
    DEF INPUT  PARAM p-cod-serie            LIKE movto-contrat-tit-export.cod-serie            NO-UNDO. 
    DEF INPUT  PARAM p-cod-docto            LIKE movto-contrat-tit-export.cod-docto            NO-UNDO. 
    DEF INPUT  PARAM p-cod-parcela          LIKE movto-contrat-tit-export.cod-parcela          NO-UNDO.
    DEF INPUT  PARAM p-dat-movto            LIKE movto-contrat-tit-export.dat-movto            NO-UNDO.
    DEF INPUT  PARAM p-cdn-trans            LIKE movto-contrat-tit-export.cdn-trans            NO-UNDO.
    DEF OUTPUT PARAM p-num-id-movto-contrat AS INT FORMAT "99999999" NO-UNDO.

    &if defined(BF_FIN_MEC_FUT_CFL2) &then
        IF l-funcao-recta-cambio-fut = YES THEN DO:

        /*BUSCA OS MOVIMENTOS DO TITULO*/
        FIND FIRST movto-contrat-tit-export EXCLUSIVE-LOCK
            WHERE movto-contrat-tit-export.cdn-empresa       = p-cdn-empresa            
            AND   movto-contrat-tit-export.cod-estab         = p-cod-estab
            AND   movto-contrat-tit-export.cod-refer         = p-cod-refer
            AND   movto-contrat-tit-export.dat-refer-contrat = p-dat-refer-contrat
            AND   movto-contrat-tit-export.cdn-emitente      = p-cdn-emitente
            AND   movto-contrat-tit-export.cod-espec-docto   = p-cod-espec-docto
            AND   movto-contrat-tit-export.cod-serie         = p-cod-serie
            AND   movto-contrat-tit-export.cod-docto         = p-cod-docto
            AND   movto-contrat-tit-export.cod-parcela       = p-cod-parcela
            AND   movto-contrat-tit-export.dat-movto         = p-dat-movto
            AND   movto-contrat-tit-export.cdn-trans         = p-cdn-trans NO-ERROR. 
        IF AVAIL movto-contrat-tit-export THEN
            ASSIGN p-num-id-movto-contrat = movto-contrat-tit-export.num-id-movto-contrat.
        ELSE
            ASSIGN p-num-id-movto-contrat = 0.
        END.
    &ENDIF

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-lancto-cambio-futuro-cfl DBOProgram 
PROCEDURE pi-gera-lancto-cambio-futuro-cfl:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-num-id-dest     AS INT FORMAT "99999999" NO-UNDO.
    DEF INPUT PARAM p-cod-operacao    AS CHAR FORMAT "x(10)"   NO-UNDO.
    DEF INPUT-OUTPUT PARAM TABLE FOR tt_integr_mec_cfl.
    DEF INPUT-OUTPUT PARAM TABLE FOR tt_erro_mec.

    DEF VAR i-num-seq AS INTEGER NO-UNDO.
    DEF VAR h-acr788za AS HANDLE NO-UNDO.
    DEF VAR valor-ent AS DEC FORMAT ">>,>>>,>>>,>>9.99" DECIMALS 2 NO-UNDO.

    RUN prgfin/acr/acr788za.py PERSISTENT SET h-acr788za.

    FOR EACH tt_chave_tit_acr:
        DELETE tt_chave_tit_acr.
    END.

    FOR EACH tt_rateio_tit_acr:
        DELETE tt_rateio_tit_acr.
    END.

    for each tt-erro-aux exclusive-lock:
        delete tt-erro-aux.
    end.

    ASSIGN i-num-seq = 1.

    &if defined(BF_FIN_MEC_FUT_CFL2) &then
        IF l-funcao-recta-cambio-fut = YES THEN DO:

            FIND FIRST param-mec NO-LOCK NO-ERROR.
        
            FIND FIRST movto-contrat-tit-export NO-LOCK
                WHERE movto-contrat-tit-export.num-id-movto-contrat = p-num-id-dest NO-ERROR.
            IF AVAIL  movto-contrat-tit-export THEN DO:
                
                FIND FIRST b-movto-contrat-tit-export
                    where b-movto-contrat-tit-export.cod-estab          = movto-contrat-tit-export.cod-estab         
                      AND b-movto-contrat-tit-export.cod-docto          = movto-contrat-tit-export.cod-docto         
                      AND b-movto-contrat-tit-export.cod-espec-docto    = movto-contrat-tit-export.cod-espec-docto   
                      AND b-movto-contrat-tit-export.cdn-empresa        = movto-contrat-tit-export.cdn-empresa       
                      AND b-movto-contrat-tit-export.cdn-emitente       = movto-contrat-tit-export.cdn-emitente      
                      AND b-movto-contrat-tit-export.cod-parcela        = movto-contrat-tit-export.cod-parcela       
                      AND b-movto-contrat-tit-export.cod-serie          = movto-contrat-tit-export.cod-serie      
                      AND b-movto-contrat-tit-export.cod-refer          = movto-contrat-tit-export.cod-refer
                      AND b-movto-contrat-tit-export.cod-contrat-cambio = movto-contrat-tit-export.cod-contrat-cambio
                      AND b-movto-contrat-tit-export.dat-refer-contrat  = movto-contrat-tit-export.dat-refer-contrat
                      AND b-movto-contrat-tit-export.cdn-trans          = 2   NO-LOCK NO-ERROR.
                IF AVAIL b-movto-contrat-tit-export THEN DO:
                    FIND FIRST contr-titulo-exp
                        WHERE contr-titulo-exp.cod-esp    = b-movto-contrat-tit-export.cod-espec-docto 
                        AND contr-titulo-exp.cod-estabel  = b-movto-contrat-tit-export.cod-estab
                        AND contr-titulo-exp.dt-vinculado = b-movto-contrat-tit-export.dat-vinculac-tit
                        AND contr-titulo-exp.ep-codigo    = b-movto-contrat-tit-export.cdn-empresa
                        AND contr-titulo-exp.nr-docto     = b-movto-contrat-tit-export.cod-docto
                        AND contr-titulo-exp.parcela      = b-movto-contrat-tit-export.cod-parcela
                        AND contr-titulo-exp.serie        = b-movto-contrat-tit-export.cod-serie NO-LOCK NO-ERROR.
                    IF AVAIL contr-titulo-exp THEN DO:
                        FIND FIRST contrato-exp 
                            WHERE  contrato-exp.cod-estabel    = contr-titulo-exp.cod-estabel
                            AND contrato-exp.ep-codigo         = contr-titulo-exp.ep-codigo
                            AND contrato-exp.dt-referencia     = contr-titulo-exp.dt-referencia
                            AND contrato-exp.referencia        = contr-titulo-exp.referencia
                            AND contrato-exp.situacao          = 9
                            AND contrato-exp.tp-contrato-exp   = 1   NO-LOCK NO-ERROR.
                        IF AVAIL contrato-exp THEN DO:
                            
                            FOR EACH val-movto-contrat-tit-export NO-LOCK
                                WHERE val-movto-contrat-tit-export.num-id-movto-contrat = movto-contrat-tit-export.num-id-movto-contrat:
                                
                                CREATE tt-integra-fluxo.
                                ASSIGN tt-integra-fluxo.ind-fluxo-movto   = "SAI"
                                       tt-integra-fluxo.ind-tipo-movto    = "RE"
                                       tt-integra-fluxo.tp-codigo         = param-mec.idi-tip-recta-cambio-fut 
                                       tt-integra-fluxo.cod-funcao        = p-cod-operacao
                                       tt-integra-fluxo.vl-movto-fluxo    = val-movto-contrat-tit-export.val-movto 
                                       tt-integra-fluxo.vl-movto-fluxo-me = val-movto-contrat-tit-export.val-movto-me
                                       tt-integra-fluxo.moeda             = val-movto-contrat-tit-export.cdn-moeda
                                       tt-integra-fluxo.cotacao-dia       = val-movto-contrat-tit-export.val-cotac  /*b-movto-contrat-tit-export.val-cotac-dia*/
                                       tt-integra-fluxo.cod-estabel       = val-movto-contrat-tit-export.cod-estab-tit-acr
                                       tt-integra-fluxo.unid-negoc        = val-movto-contrat-tit-export.cod-unid-negoc-tit-acr
                                       tt-integra-fluxo.dt-fluxo          = movto-contrat-tit-export.dat-liquidac-tit
                                       tt-integra-fluxo.dt-emissao        = movto-contrat-tit-export.dat-movto
                                       tt-integra-fluxo.num-id-orig-movto = val-movto-contrat-tit-export.num-id-val-movto-contrat
                                       tt-integra-fluxo.modulo-origem     = "MEC"
                                       tt-integra-fluxo.ind-orig-movto    = "TCF"
                                       tt-integra-fluxo.num-seq           = i-num-seq
                                       i-num-seq                          = i-num-seq + 1
                                       &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
                                           tt-integra-fluxo.cod-tip-trans-cx = ""
                                           tt-integra-fluxo.cod-cta-corren   = ""
                                           tt-integra-fluxo.conta-contabil   = ""
                                           tt-integra-fluxo.ct-conta         = ""
                                           tt-integra-fluxo.sc-conta         = ""
                                       &ENDIF
                                       .

                                /* transitorio */
                                FIND FIRST tt_integr_mec_cfl 
                                    WHERE tt_integr_mec_cfl.tta_num_id_tit_acr           = val-movto-contrat-tit-export.num-id-tit-acr 
                                      AND tt_integr_mec_cfl.tta_num_id_movto_tit_acr     = val-movto-contrat-tit-export.num-id-movto-tit-acr 
                                      AND tt_integr_mec_cfl.ttv_dat_movto_mec            = movto-contrat-tit-export.dat-liquidac-tit
                                      AND tt_integr_mec_cfl.tta_ind_tip_movto_fluxo_cx   = tt-integra-fluxo.ind-tipo-movto 
                                      AND tt_integr_mec_cfl.tta_ind_fluxo_movto_cx       = tt-integra-fluxo.ind-fluxo-movto 
                                      AND tt_integr_mec_cfl.tta_cod_contrat_cambio       = movto-contrat-tit-export.cod-contrat-cambio 
                                      AND tt_integr_mec_cfl.tta_cod_refer_contrat_cambio = movto-contrat-tit-export.cod-refer 
                                      AND tt_integr_mec_cfl.tta_dat_refer_contrat_cambio = movto-contrat-tit-export.dat-refer-contrat NO-ERROR.
                                IF NOT AVAIL tt_integr_mec_cfl THEN DO:
                                    CREATE tt_integr_mec_cfl.
                                    ASSIGN tt_integr_mec_cfl.tta_num_id_tit_acr           = val-movto-contrat-tit-export.num-id-tit-acr 
                                           tt_integr_mec_cfl.tta_num_id_movto_tit_acr     = val-movto-contrat-tit-export.num-id-movto-tit-acr 
                                           tt_integr_mec_cfl.tta_num_id_val_movto_tit_acr = val-movto-contrat-tit-export.num-id-val-movto-tit-acr 
                                           tt_integr_mec_cfl.ttv_dat_movto_mec            = movto-contrat-tit-export.dat-liquidac-tit 
                                           tt_integr_mec_cfl.ttv_ind_trans_mec            = string(movto-contrat-tit-export.cdn-trans)
                                           tt_integr_mec_cfl.tta_cod_empresa              = val-movto-contrat-tit-export.cod-empres-tit-acr
                                           tt_integr_mec_cfl.tta_cod_estab                = val-movto-contrat-tit-export.cod-estab-tit-acr
                                           tt_integr_mec_cfl.tta_cod_espec_docto          = movto-contrat-tit-export.cod-espec-docto 
                                           tt_integr_mec_cfl.tta_cod_ser_docto            = movto-contrat-tit-export.cod-serie 
                                           tt_integr_mec_cfl.tta_cod_tit_acr              = movto-contrat-tit-export.cod-docto
                                           tt_integr_mec_cfl.tta_cod_parcela              = movto-contrat-tit-export.cod-parcela 
                                           tt_integr_mec_cfl.tta_cdn_cliente              = movto-contrat-tit-export.cdn-emitente 
                                           tt_integr_mec_cfl.tta_cod_refer                = movto-contrat-tit-export.cod-refer 
                                           tt_integr_mec_cfl.ttv_val_movto_mec            = movto-contrat-tit-export.val-movto 
                                           tt_integr_mec_cfl.tta_cod_contrat_cambio       = movto-contrat-tit-export.cod-contrat-cambio 
                                           tt_integr_mec_cfl.tta_cod_refer_contrat_cambio = movto-contrat-tit-export.cod-refer 
                                           tt_integr_mec_cfl.tta_dat_refer_contrat_cambio = movto-contrat-tit-export.dat-refer-contrat 
                                           tt_integr_mec_cfl.ttv_num_seq                  = tt-integra-fluxo.num-seq 
                                           tt_integr_mec_cfl.tta_cod_unid_negoc           = val-movto-contrat-tit-export.cod-unid-negoc-tit-acr 
                                           tt_integr_mec_cfl.tta_cod_tip_fluxo_financ     = ""
                                           tt_integr_mec_cfl.tta_ind_tip_movto_fluxo_cx   = tt-integra-fluxo.ind-tipo-movto 
                                           tt_integr_mec_cfl.tta_ind_fluxo_movto_cx       = tt-integra-fluxo.ind-fluxo-movto 
                                           tt_integr_mec_cfl.tta_val_movto_fluxo_cx       = tt-integra-fluxo.vl-movto-fluxo.
                                END.
                                ELSE DO:
                                    ASSIGN tt_integr_mec_cfl.ttv_val_movto_mec       = tt_integr_mec_cfl.ttv_val_movto_mec  + movto-contrat-tit-export.val-movto 
                                           tt_integr_mec_cfl.tta_val_movto_fluxo_cx  = tt_integr_mec_cfl.tta_val_movto_fluxo_cx + tt-integra-fluxo.vl-movto-fluxo.

                                END.
        
                                CREATE tt-integra-fluxo.
                                ASSIGN tt-integra-fluxo.ind-fluxo-movto   = "ENT"
                                       tt-integra-fluxo.ind-tipo-movto    = "RE"
                                       tt-integra-fluxo.tp-codigo         = val-movto-contrat-tit-export.idi-tip-recta-despes
                                       tt-integra-fluxo.cod-funcao        = p-cod-operacao
                                       tt-integra-fluxo.vl-movto-fluxo    = val-movto-contrat-tit-export.val-movto-me 
                                                                          * movto-contrat-tit-export.val-cotac-dia
                                       tt-integra-fluxo.vl-movto-fluxo-me = val-movto-contrat-tit-export.val-movto-me
                                       tt-integra-fluxo.moeda             = val-movto-contrat-tit-export.cdn-moeda
                                       tt-integra-fluxo.cotacao-dia       = movto-contrat-tit-export.val-cotac-dia
                                       tt-integra-fluxo.cod-estabel       = val-movto-contrat-tit-export.cod-estab-tit-acr
                                       tt-integra-fluxo.unid-negoc        = val-movto-contrat-tit-export.cod-unid-negoc-tit-acr
                                       tt-integra-fluxo.dt-fluxo          = movto-contrat-tit-export.dat-liquidac-tit
                                       tt-integra-fluxo.dt-emissao        = movto-contrat-tit-export.dat-movto
                                       tt-integra-fluxo.num-id-orig-movto = val-movto-contrat-tit-export.num-id-val-movto-contrat
                                       tt-integra-fluxo.modulo-origem     = "MEC"
                                       tt-integra-fluxo.ind-orig-movto    = "RCF"
                                       tt-integra-fluxo.num-seq           = i-num-seq
                                       i-num-seq                          = i-num-seq + 1
                                       &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
                                           tt-integra-fluxo.cod-tip-trans-cx = ""
                                           tt-integra-fluxo.cod-cta-corren   = ""
                                           tt-integra-fluxo.conta-contabil   = ""
                                           tt-integra-fluxo.ct-conta         = ""
                                           tt-integra-fluxo.sc-conta         = ""
                                       &ENDIF
                                       .

                                CREATE tt_integr_mec_cfl.
                                ASSIGN tt_integr_mec_cfl.tta_num_id_tit_acr           = val-movto-contrat-tit-export.num-id-tit-acr 
                                       tt_integr_mec_cfl.tta_num_id_movto_tit_acr     = val-movto-contrat-tit-export.num-id-movto-tit-acr 
                                       tt_integr_mec_cfl.tta_num_id_val_movto_tit_acr = val-movto-contrat-tit-export.num-id-val-movto-tit-acr 
                                       tt_integr_mec_cfl.ttv_dat_movto_mec            = movto-contrat-tit-export.dat-liquidac-tit 
                                       tt_integr_mec_cfl.ttv_ind_trans_mec            = string(movto-contrat-tit-export.cdn-trans)
                                       tt_integr_mec_cfl.tta_cod_empresa              = val-movto-contrat-tit-export.cod-empres-tit-acr
                                       tt_integr_mec_cfl.tta_cod_estab                = val-movto-contrat-tit-export.cod-estab-tit-acr
                                       tt_integr_mec_cfl.tta_cod_espec_docto          = movto-contrat-tit-export.cod-espec-docto 
                                       tt_integr_mec_cfl.tta_cod_ser_docto            = movto-contrat-tit-export.cod-serie 
                                       tt_integr_mec_cfl.tta_cod_tit_acr              = movto-contrat-tit-export.cod-docto
                                       tt_integr_mec_cfl.tta_cod_parcela              = movto-contrat-tit-export.cod-parcela 
                                       tt_integr_mec_cfl.tta_cdn_cliente              = movto-contrat-tit-export.cdn-emitente 
                                       tt_integr_mec_cfl.tta_cod_refer                = movto-contrat-tit-export.cod-refer 
                                       tt_integr_mec_cfl.ttv_val_movto_mec            = movto-contrat-tit-export.val-movto 
                                       tt_integr_mec_cfl.tta_cod_contrat_cambio       = movto-contrat-tit-export.cod-contrat-cambio 
                                       tt_integr_mec_cfl.tta_cod_refer_contrat_cambio = movto-contrat-tit-export.cod-refer 
                                       tt_integr_mec_cfl.tta_dat_refer_contrat_cambio = movto-contrat-tit-export.dat-refer-contrat 
                                       tt_integr_mec_cfl.ttv_num_seq                  = tt-integra-fluxo.num-seq 
                                       tt_integr_mec_cfl.tta_cod_unid_negoc           = val-movto-contrat-tit-export.cod-unid-negoc-tit-acr 
                                       tt_integr_mec_cfl.tta_cod_tip_fluxo_financ     = val-movto-contrat-tit-export.cod-tip-fluxo-financ 
                                       tt_integr_mec_cfl.tta_ind_tip_movto_fluxo_cx   = tt-integra-fluxo.ind-tipo-movto 
                                       tt_integr_mec_cfl.tta_ind_fluxo_movto_cx       = tt-integra-fluxo.ind-fluxo-movto 
                                       tt_integr_mec_cfl.tta_val_movto_fluxo_cx       = tt-integra-fluxo.vl-movto-fluxo.
        
                            END.
                            
                            run cdp/cdapi533a.p (input table  tt-integra-fluxo,
                                                 input table  tt-integra-fluxo-conta,
                                                 input table  tt-integra-cta-corren-2,
                                                 input-output table tt-erro-aux).
                        END.
                    END.
                END.
            END.
        END.
    &ENDIF

    FOR EACH tt-erro-aux:
        CREATE tt_erro_mec.
        ASSIGN tt_erro_mec.ttv_num_seq           = tt-erro-aux.i-sequen
               tt_erro_mec.ttv_cod_erro_ems2     = tt-erro-aux.cd-erro
               tt_erro_mec.ttv_des_msg_erro_ems2 = tt-erro-aux.mensagem.
    END.

    delete procedure h-acr788za.
    FIND FIRST tt-erro-aux NO-ERROR.
    IF AVAIL tt-erro-aux THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-integra-cambio-futuro-cfl DBOProgram 
PROCEDURE pi-integra-cambio-futuro-cfl:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-cdn-empresa LIKE movto-contrat-tit-export.cdn-empresa NO-UNDO.
    DEF INPUT PARAM p-dat-inic    AS DATE                                   NO-UNDO.
    DEF INPUT PARAM p-dat-fim     AS DATE                                   NO-UNDO.
    DEF INPUT-OUTPUT PARAM TABLE FOR tt_integr_mec_cfl.
    DEF INPUT-OUTPUT PARAM TABLE FOR tt_erro_mec.


    &if defined(BF_FIN_MEC_FUT_CFL2) &then
        IF l-funcao-recta-cambio-fut = YES THEN DO:

            for each movto-contrat-tit-export NO-LOCK
                where movto-contrat-tit-export.cdn-empresa  = p-cdn-empresa
                  and movto-contrat-tit-export.dat-movto   >= p-dat-inic
                  and movto-contrat-tit-export.dat-movto   <= p-dat-fim
                  and movto-contrat-tit-export.cdn-trans    = 3 /* Destinaá∆o */
                  and movto-contrat-tit-export.log-estorno  = no:
        
                FIND FIRST b-movto-contrat-tit-export NO-LOCK
                    WHERE b-movto-contrat-tit-export.cdn-empresa             = movto-contrat-tit-export.cdn-empresa            
                    AND   b-movto-contrat-tit-export.cod-estab               = movto-contrat-tit-export.cod-estab
                    AND   b-movto-contrat-tit-export.cdn-emitente            = movto-contrat-tit-export.cdn-emitente
                    AND   b-movto-contrat-tit-export.cod-espec-docto         = movto-contrat-tit-export.cod-espec-docto
                    AND   b-movto-contrat-tit-export.cod-serie               = movto-contrat-tit-export.cod-serie
                    AND   b-movto-contrat-tit-export.cod-docto               = movto-contrat-tit-export.cod-docto
                    AND   b-movto-contrat-tit-export.cod-parcela             = movto-contrat-tit-export.cod-parcela
                    AND   b-movto-contrat-tit-export.cdn-trans               = 1 /* Vinculaá∆o */
                    AND   b-movto-contrat-tit-export.cod-contrat-cambio-orig = movto-contrat-tit-export.cod-refer NO-ERROR.
                IF AVAIL b-movto-contrat-tit-export THEN DO:
                    
                    FIND FIRST contr-titulo-exp
                        WHERE contr-titulo-exp.cod-esp    = b-movto-contrat-tit-export.cod-espec-docto 
                        AND contr-titulo-exp.cod-estabel  = b-movto-contrat-tit-export.cod-estab
                        AND contr-titulo-exp.dt-vinculado = b-movto-contrat-tit-export.dat-vinculac-tit
                        AND contr-titulo-exp.ep-codigo    = b-movto-contrat-tit-export.cdn-empresa
                        AND contr-titulo-exp.nr-docto     = b-movto-contrat-tit-export.cod-docto
                        AND contr-titulo-exp.parcela      = b-movto-contrat-tit-export.cod-parcela
                        AND contr-titulo-exp.serie        = b-movto-contrat-tit-export.cod-serie NO-LOCK NO-ERROR.
                        
                    IF AVAIL contr-titulo-exp THEN DO:
                        
                        FIND FIRST contrato-exp 
                            WHERE contrato-exp.cod-estabel     = contr-titulo-exp.cod-estabel
                            AND contrato-exp.ep-codigo         = contr-titulo-exp.ep-codigo
                            AND contrato-exp.dt-referencia     = contr-titulo-exp.dt-referencia
                            AND contrato-exp.referencia        = contr-titulo-exp.referencia NO-LOCK NO-ERROR.
                        IF AVAIL contrato-exp THEN DO:
                            
                            IF contrato-exp.tp-contrato-exp   = 1 /* Pronto */  THEN DO:
                                RUN pi-gera-lancto-cambio-futuro-cfl (INPUT movto-contrat-tit-export.num-id-movto-contrat, 
                                                                      INPUT "Inclus∆o", 
                                                                      INPUT-OUTPUT TABLE tt_integr_mec_cfl, 
                                                                      INPUT-OUTPUT TABLE tt-erro-aux ).
                            END.
                        END.
                    END.
                END.
                FOR EACH tt-erro-aux:
                    CREATE tt_erro_mec.
                    ASSIGN tt_erro_mec.ttv_num_seq           = tt-erro-aux.i-sequen
                           tt_erro_mec.ttv_cod_erro_ems2     = tt-erro-aux.cd-erro
                           tt_erro_mec.ttv_des_msg_erro_ems2 = tt-erro-aux.mensagem.
                END.
                IF RETURN-VALUE = "NOK":U THEN
                    RETURN "NOK":U.
        
            END.
        
            for each movto-contrat-tit-export NO-LOCK
                where movto-contrat-tit-export.cdn-empresa  = p-cdn-empresa
                  and movto-contrat-tit-export.dat-movto   >= p-dat-inic
                  and movto-contrat-tit-export.dat-movto   <= p-dat-fim
                  and movto-contrat-tit-export.cdn-trans    = 9 /* Liquidaá∆o T°tulo EmprÇstimo Destinado */
                  and movto-contrat-tit-export.log-estorno  = no:
        
                RUN pi-gera-saida-fluxo-transitorio ( INPUT movto-contrat-tit-export.num-id-movto-contrat, 
                                                      INPUT "Inclus∆o", 
                                                      INPUT-OUTPUT TABLE tt_integr_mec_cfl, 
                                                      INPUT-OUTPUT TABLE tt_erro_mec ).
            END.
        END.
    &ENDIF

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-val-movto-contrat-tit-export DBOProgram 
PROCEDURE pi-cria-val-movto-contrat-tit-export:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:          
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-num-id AS INT FORMAT "99999999" NO-UNDO.

    DEF VAR h-acr788za AS HANDLE NO-UNDO.
    DEF VAR valor AS DEC FORMAT ">>,>>>,>>>,>>9.99" DECIMALS 2   NO-UNDO.
    DEF VAR v-maior AS DEC FORMAT ">>,>>>,>>>,>>9.99" DECIMALS 2 NO-UNDO.
    &IF {&ROWID_READY} = YES &THEN
        DEF VAR v-rec-id AS ROWID NO-UNDO.
    &ELSE
        DEF VAR v-rec-id AS RECID NO-UNDO.
    &ENDIF

    ASSIGN v-maior    = 0.
    
    run pi-busca-empresa in this-procedure (output c-ep-codigo). 

    /*** Carrega bases do EMS 5.0 ***/
    {ecp/ec0005b.i 1}

    RUN prgfin/acr/acr788za.py PERSISTENT SET h-acr788za.

    FOR EACH tt_chave_tit_acr:
        DELETE tt_chave_tit_acr.
    END.

    FOR EACH tt_rateio_tit_acr:
        DELETE tt_rateio_tit_acr.
    END.

    &if defined(BF_FIN_MEC_FUT_CFL2) &then
        IF l-funcao-recta-cambio-fut = YES THEN DO:

            FIND FIRST movto-contrat-tit-export NO-LOCK
                WHERE movto-contrat-tit-export.num-id-movto-contrat = p-num-id NO-ERROR.
            IF AVAIL  movto-contrat-tit-export THEN DO:
                
                FIND FIRST b-movto-contrat-tit-export
                    where b-movto-contrat-tit-export.cod-estab          = movto-contrat-tit-export.cod-estab         
                      AND b-movto-contrat-tit-export.cod-docto          = movto-contrat-tit-export.cod-docto         
                      AND b-movto-contrat-tit-export.cod-espec-docto    = movto-contrat-tit-export.cod-espec-docto   
                      AND b-movto-contrat-tit-export.cdn-empresa        = movto-contrat-tit-export.cdn-empresa       
                      AND b-movto-contrat-tit-export.cdn-emitente       = movto-contrat-tit-export.cdn-emitente      
                      AND b-movto-contrat-tit-export.cod-parcela        = movto-contrat-tit-export.cod-parcela       
                      AND b-movto-contrat-tit-export.cod-serie          = movto-contrat-tit-export.cod-serie      
                      AND b-movto-contrat-tit-export.cod-refer          = movto-contrat-tit-export.cod-refer
                      AND b-movto-contrat-tit-export.cod-contrat-cambio = movto-contrat-tit-export.cod-contrat-cambio
                      AND b-movto-contrat-tit-export.dat-refer-contrat  = movto-contrat-tit-export.dat-refer-contrat
                      AND b-movto-contrat-tit-export.cdn-trans          = 2   NO-LOCK NO-ERROR.
                IF AVAIL b-movto-contrat-tit-export THEN DO:
                    
                    FIND FIRST contr-titulo-exp
                        WHERE contr-titulo-exp.cod-esp    = b-movto-contrat-tit-export.cod-espec-docto 
                        AND contr-titulo-exp.cod-estabel  = b-movto-contrat-tit-export.cod-estab
                        AND contr-titulo-exp.dt-vinculado = b-movto-contrat-tit-export.dat-vinculac-tit
                        AND contr-titulo-exp.ep-codigo    = b-movto-contrat-tit-export.cdn-empresa
                        AND contr-titulo-exp.nr-docto     = b-movto-contrat-tit-export.cod-docto
                        AND contr-titulo-exp.parcela      = b-movto-contrat-tit-export.cod-parcela
                        AND contr-titulo-exp.serie        = b-movto-contrat-tit-export.cod-serie NO-LOCK NO-ERROR.
                    IF AVAIL contr-titulo-exp THEN DO:
                        
                        FIND FIRST contrato-exp 
                            WHERE  contrato-exp.cod-estabel    = contr-titulo-exp.cod-estabel
                            AND contrato-exp.ep-codigo         = contr-titulo-exp.ep-codigo
                            AND contrato-exp.dt-referencia     = contr-titulo-exp.dt-referencia
                            AND contrato-exp.referencia        = contr-titulo-exp.referencia
                            AND contrato-exp.situacao          = 9
                            AND contrato-exp.tp-contrato-exp   = 1   NO-LOCK NO-ERROR.
                        IF AVAIL contrato-exp THEN DO:
                            
                            create tt_chave_tit_acr.
                            assign tt_chave_tit_acr.tta_num_contrat_id_cambio = contrato-exp.num-id-contrato-exp
                                   tt_chave_tit_acr.tta_cod_empresa           = string(contr-titulo-exp.ep-codigo)
                                   tt_chave_tit_acr.tta_cod_estab             = contr-titulo-exp.cod-estabel
                                   tt_chave_tit_acr.tta_cod_espec_docto       = contr-titulo-exp.cod-esp
                                   tt_chave_tit_acr.tta_cod_ser_docto         = contr-titulo-exp.serie
                                   tt_chave_tit_acr.tta_cod_tit_acr           = contr-titulo-exp.nr-docto
                                   tt_chave_tit_acr.tta_cod_parcela           = contr-titulo-exp.parcela.
            
                            RUN pi_busca_rateio_tit_acr IN h-acr788za(INPUT b-movto-contrat-tit-export.dat-movto,
                                                                      INPUT TABLE tt_chave_tit_acr,
                                                                      OUTPUT TABLE tt_rateio_tit_acr).
                            
                            FIND FIRST tt_rateio_tit_acr NO-ERROR.
                            IF AVAIL tt_rateio_tit_acr THEN
                                ASSIGN valor = movto-contrat-tit-export.val-movto * tt_rateio_tit_acr.tta_val_cotac_indic_econ.
            
                            FOR EACH tt_rateio_tit_acr:
                                CREATE val-movto-contrat-tit-export.
                                ASSIGN val-movto-contrat-tit-export.cdn-moeda                = contrato-exp.moeda
                                       val-movto-contrat-tit-export.cod-empres-tit-acr      = tt_rateio_tit_acr.tta_cod_empresa
                                       val-movto-contrat-tit-export.cod-estab-tit-acr        = tt_rateio_tit_acr.tta_cod_estab
                                       val-movto-contrat-tit-export.cod-refer-tit-acr        = tt_rateio_tit_acr.tta_cod_refer
                                       val-movto-contrat-tit-export.cod-tip-fluxo-financ     = tt_rateio_tit_acr.tta_cod_tip_fluxo_financ
                                       val-movto-contrat-tit-export.cod-unid-negoc-tit-acr   = tt_rateio_tit_acr.tta_cod_unid_negoc
                                       val-movto-contrat-tit-export.idi-tip-recta-despes     = int(tt_rateio_tit_acr.ttv_cod_tip_recta)
                                       val-movto-contrat-tit-export.num-id-movto-contrat     = p-num-id /* movimento de destinaá∆o */
                                       val-movto-contrat-tit-export.num-id-movto-tit-acr     = tt_rateio_tit_acr.tta_num_id_movto_tit_acr
                                       val-movto-contrat-tit-export.num-id-tit-acr           = tt_rateio_tit_acr.tta_num_id_tit_acr
                                       val-movto-contrat-tit-export.num-id-val-movto-contrat = NEXT-VALUE(seq-val-movto-contrat)
                                       val-movto-contrat-tit-export.num-id-val-movto-tit-acr = tt_rateio_tit_acr.tta_num_id_val_movto_tit_acr
                                       val-movto-contrat-tit-export.val-cotac                = movto-contrat-tit-export.val-cotac-dia
                                       val-movto-contrat-tit-export.val-movto                = movto-contrat-tit-export.val-movto
                                                                                             * tt_rateio_tit_acr.tta_val_cotac_indic_econ
                                                                                             * (tt_rateio_tit_acr.tta_val_perc_rat / 100)
                                       val-movto-contrat-tit-export.val-movto-me             = movto-contrat-tit-export.val-movto
                                                                                             * (tt_rateio_tit_acr.tta_val_perc_rat / 100)
                                       val-movto-contrat-tit-export.val-perc-rat             = tt_rateio_tit_acr.tta_val_perc_rat.
        
                                IF val-movto-contrat-tit-export.val-movto > v-maior THEN
                                    ASSIGN v-rec-id = &IF {&ROWID_READY} = YES &THEN
                                                        ROWID(val-movto-contrat-tit-export).
                                                      &ELSE
                                                        RECID(val-movto-contrat-tit-export).
                                                      &ENDIF 
        
                                ASSIGN v-maior = v-maior + val-movto-contrat-tit-export.val-movto.
                            END.
                        END.
                    END.
                END.
            END.
            
            IF v-maior <> valor THEN DO:
                FIND FIRST val-movto-contrat-tit-export EXCLUSIVE-LOCK
                    WHERE &IF {&ROWID_READY} = YES &THEN ROWID(val-movto-contrat-tit-export) &ELSE RECID(val-movto-contrat-tit-export) &ENDIF = v-rec-id NO-ERROR.
                IF AVAIL val-movto-contrat-tit-export THEN
                    ASSIGN val-movto-contrat-tit-export.val-movto = val-movto-contrat-tit-export.val-movto + (valor - v-maior).
            END.
            
            run cdp/cdapi533a.p (input table  tt-integra-fluxo,
                                 input table  tt-integra-fluxo-conta,
                                 input table  tt-integra-cta-corren-2,
                                 input-output table tt-erro-aux).
        
            FOR EACH tt-erro-aux:
                CREATE tt_erro_mec.
                ASSIGN tt_erro_mec.ttv_num_seq           = tt-erro-aux.i-sequen
                       tt_erro_mec.ttv_cod_erro_ems2     = tt-erro-aux.cd-erro
                       tt_erro_mec.ttv_des_msg_erro_ems2 = tt-erro-aux.mensagem.
            END.
        
            delete procedure h-acr788za.
            FIND FIRST tt-erro-aux NO-ERROR.
            IF AVAIL tt-erro-aux THEN
                RETURN "NOK":U.
        END.
    &ENDIF

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-saida-fluxo-transitorio DBOProgram 
PROCEDURE pi-gera-saida-fluxo-transitorio:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:          
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-num-id       AS INT FORMAT "99999999" NO-UNDO.
    DEF INPUT PARAM p-cod-operacao AS CHAR FORMAT "x(10)"   NO-UNDO.
    DEF INPUT-OUTPUT PARAM TABLE FOR tt_integr_mec_cfl.
    DEF INPUT-OUTPUT PARAM TABLE FOR tt_erro_mec.

    DEF VAR i-num-seq AS INT NO-UNDO.
    DEF VAR h-acr788za AS HANDLE NO-UNDO.

    RUN prgfin/acr/acr788za.py PERSISTENT SET h-acr788za.

    ASSIGN i-num-seq = 0.

    FOR EACH tt_chave_tit_acr:
        DELETE tt_chave_tit_acr.
    END.

    FOR EACH tt_rateio_tit_acr:
        DELETE tt_rateio_tit_acr.
    END.

    for each tt-erro-aux exclusive-lock:
        delete tt-erro-aux.
    end.

    FIND FIRST param-mec NO-LOCK NO-ERROR.

    &if defined(BF_FIN_MEC_FUT_CFL2) &then
        IF l-funcao-recta-cambio-fut = YES THEN DO:

            /* movto destinaá∆o */
            FIND FIRST movto-contrat-tit-export NO-LOCK
                WHERE movto-contrat-tit-export.num-id-movto-contrat = p-num-id NO-ERROR.
            IF AVAIL movto-contrat-tit-export THEN DO:
                FIND FIRST b-movto-contrat-tit-export
                   where b-movto-contrat-tit-export.cod-estab          = movto-contrat-tit-export.cod-estab         
                     AND b-movto-contrat-tit-export.cod-docto          = movto-contrat-tit-export.cod-docto         
                     AND b-movto-contrat-tit-export.cod-espec-docto    = movto-contrat-tit-export.cod-espec-docto   
                     AND b-movto-contrat-tit-export.cdn-empresa        = movto-contrat-tit-export.cdn-empresa       
                     AND b-movto-contrat-tit-export.cdn-emitente       = movto-contrat-tit-export.cdn-emitente      
                     AND b-movto-contrat-tit-export.cod-parcela        = movto-contrat-tit-export.cod-parcela       
                     AND b-movto-contrat-tit-export.cod-serie          = movto-contrat-tit-export.cod-serie      
                     AND b-movto-contrat-tit-export.cod-contrat-cambio-dest = movto-contrat-tit-export.cod-refer
                     AND b-movto-contrat-tit-export.cdn-trans          = 3   NO-LOCK NO-ERROR.
                IF AVAIL b-movto-contrat-tit-export THEN DO:
                    FOR EACH val-movto-contrat-tit-export NO-LOCK
                        WHERE val-movto-contrat-tit-export.num-id-movto-contrat = b-movto-contrat-tit-export.num-id-movto-contrat:
                        
                        CREATE tt-integra-fluxo.
                        ASSIGN tt-integra-fluxo.ind-fluxo-movto   = "SAI"
                               tt-integra-fluxo.ind-tipo-movto    = "RE"
                               tt-integra-fluxo.tp-codigo         = IF AVAIL param-mec THEN param-mec.idi-tip-recta-cambio-fut ELSE 0
                               tt-integra-fluxo.cod-funcao        = p-cod-operacao
                               tt-integra-fluxo.vl-movto-fluxo    = val-movto-contrat-tit-export.val-movto 
                               tt-integra-fluxo.vl-movto-fluxo-me = val-movto-contrat-tit-export.val-movto-me
                               tt-integra-fluxo.moeda             = val-movto-contrat-tit-export.cdn-moeda
                               tt-integra-fluxo.cotacao-dia       = val-movto-contrat-tit-export.val-cotac  /*b-movto-contrat-tit-export.val-cotac-dia*/
                               tt-integra-fluxo.cod-estabel       = val-movto-contrat-tit-export.cod-estab-tit-acr
                               tt-integra-fluxo.unid-negoc        = val-movto-contrat-tit-export.cod-unid-negoc-tit-acr
                               tt-integra-fluxo.dt-fluxo          = movto-contrat-tit-export.dat-liquidac-tit
                               tt-integra-fluxo.dt-emissao        = movto-contrat-tit-export.dat-movto
                               tt-integra-fluxo.num-id-orig-movto = val-movto-contrat-tit-export.num-id-val-movto-contrat
                               tt-integra-fluxo.modulo-origem     = "MEC"
                               tt-integra-fluxo.ind-orig-movto    = "TCF"
                               tt-integra-fluxo.num-seq           = i-num-seq
                               i-num-seq                          = i-num-seq + 1
                               &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
                                   tt-integra-fluxo.cod-tip-trans-cx = ""
                                   tt-integra-fluxo.cod-cta-corren   = ""
                                   tt-integra-fluxo.conta-contabil   = ""
                                   tt-integra-fluxo.ct-conta         = ""
                                   tt-integra-fluxo.sc-conta         = ""
                               &ENDIF
                               .
                
                        
                        CREATE tt_integr_mec_cfl.
                        ASSIGN tt_integr_mec_cfl.tta_num_id_tit_acr           = val-movto-contrat-tit-export.num-id-tit-acr 
                               tt_integr_mec_cfl.tta_num_id_movto_tit_acr     = val-movto-contrat-tit-export.num-id-movto-tit-acr 
                               tt_integr_mec_cfl.tta_num_id_val_movto_tit_acr = val-movto-contrat-tit-export.num-id-val-movto-tit-acr 
                               tt_integr_mec_cfl.ttv_dat_movto_mec            = movto-contrat-tit-export.dat-liquidac-tit
                               tt_integr_mec_cfl.ttv_ind_trans_mec            = string(movto-contrat-tit-export.cdn-trans)
                               tt_integr_mec_cfl.tta_cod_empresa              = val-movto-contrat-tit-export.cod-empres-tit-acr
                               tt_integr_mec_cfl.tta_cod_estab                = val-movto-contrat-tit-export.cod-estab-tit-acr
                               tt_integr_mec_cfl.tta_cod_espec_docto          = movto-contrat-tit-export.cod-espec-docto 
                               tt_integr_mec_cfl.tta_cod_ser_docto            = movto-contrat-tit-export.cod-serie 
                               tt_integr_mec_cfl.tta_cod_tit_acr              = movto-contrat-tit-export.cod-docto
                               tt_integr_mec_cfl.tta_cod_parcela              = movto-contrat-tit-export.cod-parcela 
                               tt_integr_mec_cfl.tta_cdn_cliente              = movto-contrat-tit-export.cdn-emitente 
                               tt_integr_mec_cfl.tta_cod_refer                = movto-contrat-tit-export.cod-refer 
                               tt_integr_mec_cfl.ttv_val_movto_mec            = movto-contrat-tit-export.val-movto 
                               tt_integr_mec_cfl.tta_cod_contrat_cambio       = movto-contrat-tit-export.cod-contrat-cambio 
                               tt_integr_mec_cfl.tta_cod_refer_contrat_cambio = movto-contrat-tit-export.cod-refer 
                               tt_integr_mec_cfl.tta_dat_refer_contrat_cambio = movto-contrat-tit-export.dat-refer-contrat 
                               tt_integr_mec_cfl.ttv_num_seq                  = tt-integra-fluxo.num-seq 
                               tt_integr_mec_cfl.tta_cod_unid_negoc           = val-movto-contrat-tit-export.cod-unid-negoc-tit-acr 
                               tt_integr_mec_cfl.tta_cod_tip_fluxo_financ     = val-movto-contrat-tit-export.cod-tip-fluxo-financ 
                               tt_integr_mec_cfl.tta_ind_tip_movto_fluxo_cx   = tt-integra-fluxo.ind-tipo-movto 
                               tt_integr_mec_cfl.tta_ind_fluxo_movto_cx       = tt-integra-fluxo.ind-fluxo-movto 
                               tt_integr_mec_cfl.tta_val_movto_fluxo_cx       = tt-integra-fluxo.vl-movto-fluxo.
                
                    END.
                END.
            END.
                
            run cdp/cdapi533a.p (input table  tt-integra-fluxo,
                                 input table  tt-integra-fluxo-conta,
                                 input table  tt-integra-cta-corren-2,
                                 input-output table tt-erro-aux).
            
        
            FOR EACH tt-erro-aux:
                CREATE tt_erro_mec.
                ASSIGN tt_erro_mec.ttv_num_seq           = tt-erro-aux.i-sequen
                       tt_erro_mec.ttv_cod_erro_ems2     = tt-erro-aux.cd-erro
                       tt_erro_mec.ttv_des_msg_erro_ems2 = tt-erro-aux.mensagem.
            END.
            delete procedure h-acr788za.
            FIND FIRST tt-erro-aux NO-ERROR.
            IF AVAIL tt-erro-aux THEN
                RETURN "NOK":U.
        END.
    &ENDIF

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-totalizacao DBOProgram 
PROCEDURE pi-totalizacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-nr-contrato  AS CHAR NO-UNDO.
    DEF INPUT PARAM TABLE FOR tt-param-totalizacao .
    DEF INPUT PARAM TABLE FOR tt-emitente          .
    DEF OUTPUT PARAM p-tot-devol   AS DEC NO-UNDO.
    DEF OUTPUT PARAM p-tot-liq-emp AS DEC NO-UNDO.

    assign p-tot-devol   = 0
           p-tot-liq-emp = 0.

    find first tt-param-totalizacao no-error.
    if avail tt-param-totalizacao then do:
        for each contr-titulo-exp
            where contr-titulo-exp.nr-contrato = p-nr-contrato
              &if "{&mgadm_version}":U < "2.06":U &then
              AND contr-titulo-exp.char-1 >= tt-param-totalizacao.ttv-num-proc-ini
              and contr-titulo-exp.char-1 <= tt-param-totalizacao.ttv-num-proc-fim
                  &else
              AND contr-titulo-exp.nr-proc-exp >= tt-param-totalizacao.ttv-num-proc-ini
              and contr-titulo-exp.nr-proc-exp <= tt-param-totalizacao.ttv-num-proc-fim
                  &endif
              and contr-titulo-exp.cod-emitente >= tt-param-totalizacao.ttv-cliente-ini
              and contr-titulo-exp.cod-emitente <= tt-param-totalizacao.ttv-cliente-fim
              and contr-titulo-exp.dt-vencimen  >= tt-param-totalizacao.ttv-vencto-ini
              and contr-titulo-exp.dt-vencimen  <= tt-param-totalizacao.ttv-vencto-fim no-lock,
            first tt-emitente
            where tt-emitente.cod-emitente = contr-titulo-exp.cod-emitente
              and tt-emitente.pais >= tt-param-totalizacao.ttv-pais-ini
              and tt-emitente.pais <= tt-param-totalizacao.ttv-pais-fim no-lock:    

            For each movto-contrat-tit-export NO-LOCK
                WHERE movto-contrat-tit-export.cdn-empresa       = contr-titulo-exp.ep-codigo            
                AND   movto-contrat-tit-export.cod-estab         = contr-titulo-exp.cod-estabel
                AND   movto-contrat-tit-export.cod-refer         = contr-titulo-exp.referencia
                AND   movto-contrat-tit-export.dat-refer-contrat = contr-titulo-exp.dt-referencia
                AND   movto-contrat-tit-export.cdn-emitente      = contr-titulo-exp.cod-emitente
                AND   movto-contrat-tit-export.cod-espec-docto   = contr-titulo-exp.cod-esp
                AND   movto-contrat-tit-export.cod-serie         = contr-titulo-exp.serie
                AND   movto-contrat-tit-export.cod-docto         = contr-titulo-exp.nr-docto
                AND   movto-contrat-tit-export.cod-parcela       = contr-titulo-exp.parcela
                AND   movto-contrat-tit-export.dat-vinculac-tit  = contr-titulo-exp.dt-vinculado
                AND   movto-contrat-tit-export.LOG-estorno       = NO:
                
                if movto-contrat-tit-export.cdn-trans = 4 then /*devolucao*/
                    ASSIGN p-tot-devol = p-tot-devol + movto-contrat-tit-export.val-movto.
                if movto-contrat-tit-export.cdn-trans = 5 then /*cancelamamento c/ desembolso*/
                    ASSIGN p-tot-devol   = p-tot-devol   - movto-contrat-tit-export.val-movto
                           p-tot-liq-emp = p-tot-liq-emp + movto-contrat-tit-export.val-movto.
            end.
        END.
        IF  p-tot-devol < 0 THEN
            ASSIGN p-tot-devol = 0.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-empresa DBOProgram 
PROCEDURE pi-busca-empresa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param  i-ep-codigo like contrato-exp.ep-codigo.
    
    {method/svc/autentic/autentic.i
            &vUserEnterprise="i-ep-codigo"}
    
    RETURN "OK":U.
END PROCEDURE.
