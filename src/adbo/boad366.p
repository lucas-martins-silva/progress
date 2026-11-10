&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAD366 2.00.00.011 } /*** "010011" 10/06/2025 09:30:38 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad366 MUT}
&ENDIF

/*--------------------------------------------------------------------------
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

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName            BOAD366
&GLOBAL-DEFINE DBOVersion         1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName          crta-remessa-docto-exp
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName          qr{&TableName} 

DEFINE TEMP-TABLE tt-contr-titulo-exp NO-UNDO LIKE contr-titulo-exp
       field r-rowid as rowid.

DEFINE TEMP-TABLE tt-contrato-exp NO-UNDO LIKE contrato-exp
           field r-rowid as rowid.

/*definiá∆o de temp-table usada para passagem de parametros*/
DEFINE TEMP-TABLE tt-crta-remessa-titulo NO-UNDO LIKE crta-remessa-titulo
         field r-rowid as rowid.

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{adbo/boad366.i RowObject}

/**** Miniflexibilizacao ****/
{cdp/cdcfgfin.i}
{include/i_dbvers.i}

/*getdefinefunction*/
{include/getdefinedfunction.i}

/* l-funcao-arbitragem */
{ecp/ec0003.i2}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bf-crta-remessa-exp FOR crta-remessa-exp.
DEFINE BUFFER bf-crta-remessa-docto-pend-exp FOR crta-remessa-docto-pend-exp.
DEFINE BUFFER bfcontrato-exp FOR contrato-exp.
DEFINE BUFFER bfcrta-remessa-titulo FOR crta-remessa-titulo.
DEFINE BUFFER bfcontr-titulo-exp for contr-titulo-exp.
DEFINE BUFFER bf-contr-titulo-exp FOR contr-titulo-exp. 
DEFINE BUFFER bftitulo for titulo. /* cria um buf da tab titulo para alimentar tt-titulos-selecionados*/

/*Temp table para pi-efetiva-vinculacao*/
def temp-table tt_rateio_valores no-undo
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont†bil" column-label "Conta Cont†bil"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field ttv_val_rat_aprop_ctbl           as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Valor Aprop Ctbl" column-label "Valor Aprop Ctbl"
    index tt_chave                         is primary unique
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending.

def temp-table tt_log_erro no-undo  
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància".

def temp-table tt_correcoes_efetuadas no-undo
    field tta_cod_banco             as character format "x(8)"                      label "Banco" column-label "Banco"
    field tta_cod_produt_financ     as character format "x(8)"                      label "Produto Financeiro" column-label "Produto Financeiro"
    field tta_cod_operac_financ     as character format "x(10)"                     label "Operaá∆o Financeira" column-label "Operaá∆o Financeira"
    field ttv_dat_correc            as date      format "99/99/9999"                initial today  label "Data Correá∆o" column-label "Data Correá∆o"
    field ttv_val_tax_pre           as decimal   format "->>,>>>,>>>,>>9.999999999" decimals 9 label "Val.Tax.Pre" column-label "Val.Tax.Pre"
    field tta_cod_indic_econ_juros  as character format "x(8)"                      label "Indic Econ Juros" column-label "Indic Econ Juros"
    field ttv_val_tax_pos           as decimal   format "->>>,>>9.9999999999"       decimals 10 label "Val.Tax.Pos" column-label "Val.Tax.Pos"
    field ttv_val_cota_tax_pos      as decimal   format "->>>,>>9.999999999"        decimals 9 column-label "Val.Cota Tax.Pos"
    field ttv_val_correc            as decimal   format "->>,>>>,>>>,>>9.99"        decimals 2 label "Valor Correá∆o" column-label "Valor Correá∆o"
    field tta_dat_prox_aniver_aplic as date      format "99/99/9999"                initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF label "Pr¢ximo Anivers†rio" column-label "Pr¢ximo Anivers†rio"
    field ttv_val_comis_delcred     as decimal   format "->>,>>>,>>>,>>9.99"        decimals 2 label "Val Del Credere" column-label "Val Del Credere"
    field ttv_val_cota_inic         as decimal   format "->>,>>>,>>>,>>9.999999999" decimals 9 label "Cotaá∆o Inic" column-label "Cotaá∆o Inic"
    field ttv_val_cota_fim          as decimal   format "->>>,>>9.999999999"        decimals 9 label "Cotaá∆o Fim" column-label "Cotaá∆o Fim"
    field ttv_val_juros             as decimal   format "->>>,>>>,>>9.99"           decimals 2 label "Valor Juros" column-label "Valor Juros"  
    field ttv_cb3_ident_visual      as Character format "x(20)" label "N£mero Plaqueta" column-label "N£mero Plaqueta".

def temp-table tt-titulo no-undo
   field cod-esp      as char format "x(3)"       label "Esp"
   field serie        as char format "x(5)"       label "SÇrie"
   field nr-docto     as char format "x(16)"      label "Documento"
   field parcela      as char format "x(2)"       label "/P".

def temp-table tt-titulos-selecionados no-undo like titulo
    field r-rowid            as rowid 
    field de-vl-vinculado    as decimal label "Vl Vinculado" format ">,>>>,>>>,>>9.99"
    field ctr-referencia     as char
    field dt-referencia      as date
    field nr-contrato        as char
    field dt-contrato        as date
    field prod-financ        as char
    field dt-vinculado       as DATE
    field vl-paridade        as dec
    field moeda              as int
    field ctr-referencia-liq as char
    field dt-referencia-liq  as date
    field nr-contrato-liq    as char
    field dt-contrato-liq    as date
    field cod-unid-negoc     as char init '' format "x(3)" 
    index codigo          is primary
                             ep-codigo
                             cod-estabel
                             referencia
                             dt-referencia.
/*--- Vari†veis ---*/

&IF "{&mguni_version}" >= "2.07A" &THEN
DEF VAR c-ep-codigo       LIKE empresa.ep-codigo NO-UNDO.
&ELSE
DEF VAR c-ep-codigo       AS INT NO-UNDO.
&ENDIF

&IF "{&mguni_version}" >= "2.07A" &THEN
def var i-ep-codigo       LIKE empresa.ep-codigo  no-undo.
&ELSE
def var i-ep-codigo       as int  no-undo.
&ENDIF
def var c-cod-estabel     as char no-undo.
def var c-nr-crta-remessa as char no-undo.

def var c-documento like crta-remessa-docto-exp.documento          no-undo.
def var i-tipo      like crta-remessa-docto-exp.ind-tipo-documento no-undo.
def var i-conta-cambio AS INT no-undo. /*: contador*/
    
DEF VAR de-soma     AS INT     NO-UNDO. 
DEF VAR l-saida     AS LOGICAL NO-UNDO. 
DEF VAR i-seq-erro  AS INT     NO-UNDO. 
DEF VAR v-pagar     AS CHAR    NO-UNDO. 
DEF VAR v-receber   AS CHAR    NO-UNDO. 
def var l-atualiza  as LOGICAL no-undo. 

/*para pi-efetiva-vinculacao*/
DEF VAR cod-moeda-cambial        AS INT NO-UNDO.
DEF VAR vl-paridade-impl         AS DEC NO-UNDO.
DEF VAR vl-vinc-mo-contrato           AS DEC NO-UNDO.
DEF VAR vl-saldo-liquidar-mo-contrato AS DEC NO-UNDO.
DEF VAR c-empresa               AS CHAR NO-UNDO.
def var p-cod-plano-cta-ctbl   as character format "x(8)"                    no-undo.
def var p-cta-produt-financ    as character format "x(20)"                   no-undo.
def var p-liquidacao-ace   AS LOG     NO-UNDO.
def var l-corrige-contrato as logical no-undo.
def var v-funcao-pre-pagto as log     no-undo.
def var v-log-aplica-empre-ativo as log no-undo.
def var de-saldo-operac-financ as decimal format ">>>,>>>,>>9.99" decimals 2 no-undo.
def var de-saldo-princ-operac-financ as decimal format ">>>,>>>,>>9.99" decimals 2 no-undo.
def var l-hist-ava         as logical no-undo.
def var c-historico        as character format "x(2000)" no-undo.
def var p_num_id_movto_acerto_sdo       as integer format ">>>>,>>9"         no-undo. 
def var p_num_id_movto_acerto_sdo_princ as integer format ">>>>,>>9"         no-undo.
def var p-cta-ajuste as char no-undo.
def var p-ct-codigo  as char no-undo.
def var p-sc-codigo  as char no-undo.
def var p_cod_plano_cta_ctbl   as character format "x(8)"                    no-undo.

DEF VAR l-func-alt-car-rem AS LOG NO-UNDO.

/* Projeto 82 - Unificaá∆o de Conceitos*/
def var c-cod-ccusto-ajust as char no-undo.

/*funá∆o vincul-carta-mec*/
def new global shared var l-vincul-carta as LOGICAL no-undo.

def temp-table tt-documentos like crta-remessa-docto-exp.
                                    
def var hShowMsg    as handle NO-UNDO.
DEF VAR h-boad049   AS HANDLE NO-UNDO.
DEF VAR h-acr788za  AS HANDLE NO-UNDO.
DEF VAR h-boad357   AS HANDLE NO-UNDO.
def var h-boad350   as handle no-undo.
def var h-boad355   as handle no-undo.
def var h-boad347   as handle no-undo.
DEF VAR h-boad346   AS HANDLE NO-UNDO.
DEF VAR h-acomp   AS HANDLE NO-UNDO.

/*Variaveis do bloqueio do MEC*/
def var h-bloqueio          as handle no-undo.
def var c-error-description as char no-undo.
def var c-error-help        as char no-undo.
def var c-dados-blq         as char no-undo.
def var v-log-operac-em-digitac as logical format "Sim/N∆o" no-undo.
/*Variaveis do bloqueio do MEC*/


/*para pi-efetiva-vinculacao*/

def var p_cod_cta_ctbl
    as character
    format "x(20)"
    no-undo.
def new global shared var v_cod_usuar_corren 
    as character 
    format "x(12)":U 
    label "Usu†rio Corrente" 
    column-label "Usu†rio Corrente" 
    no-undo. 
def new global shared var v_cod_empres_usuar 
    as character 
    format "x(3)":U 
    label "Empresa" 
    column-label "Empresa" 
    no-undo. 
def var v_cod_usuar_corren_old
    as character 
    format "x(12)":U 
    label "Usu†rio Corrente" 
    column-label "Usu†rio Corrente" 
    no-undo. 
def var v_cod_empres_usuar_old 
    as character 
    format "x(3)":U 
    label "Empresa" 
    column-label "Empresa" 
    no-undo. 
def var v_log_calcula_juros_comptcia
    as logical
    format "Sim/N∆o"
    initial yes
    label "Calc Jur/Var Compet"
    no-undo.
/*variavel auxiliar*/
def var v_cod_empres_usuar_aux 
    as character 
    format "x(3)":U 
    no-undo. 

/*definiá∆o da temp-table tt-erro EMS 5.0 */
{ecp/ec0005c.i}
/*** definiá∆o da temp-table tt_operac_financ_cambio_1 ***/
{ecp/ec0005j.i}
/*** definicao da temp-table tt_repas_pend_apl ***/
{ecp/ec0003.i1}
/* Vari†veis para traduá∆o de contas cont†beis - utb786za*/
{ecp/ec0006c.i2}


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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 2.04
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

/*{include/getdefinedfunction.i}    
 Verificar se funØ o especial estò habilitada */
assign l-func-alt-car-rem = &if defined(BF_FIN_ALTERA_CARTA_REM) &then yes &else GetDefinedFunction("SPP-ALT-CAR-REM") &endif.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforecreateRecord DBOProgram 
PROCEDURE beforecreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FIND LAST bfcrta-remessa-docto-exp NO-LOCK
      where bfcrta-remessa-docto-exp.ep-codigo       = RowObject.ep-codigo
        and bfcrta-remessa-docto-exp.cod-estabel     = RowObject.cod-estabel
        and bfcrta-remessa-docto-exp.nr-crta-remessa = RowObject.nr-crta-remessa NO-ERROR.
  IF AVAIL bfcrta-remessa-docto-exp THEN 
      assign RowObject.sequencia = bfcrta-remessa-docto-exp.sequencia + 10.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforedeleterecord DBOProgram 
PROCEDURE beforedeleterecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Elimina T°tulos Relacionados */
    for each crta-remessa-docto-pend-exp where
             crta-remessa-docto-pend-exp.ep-codigo          = RowObject.ep-codigo          and
             crta-remessa-docto-pend-exp.cod-estabel        = RowObject.cod-estabel        and
             crta-remessa-docto-pend-exp.nr-crta-remessa    = RowObject.nr-crta-remessa    and
             crta-remessa-docto-pend-exp.documento          = RowObject.documento          and
             crta-remessa-docto-pend-exp.ind-tipo-documento = RowObject.ind-tipo-documento and
             crta-remessa-docto-pend-exp.desc-tp-documento  = RowObject.desc-tp-documento 
             exclusive-lock:
       delete crta-remessa-docto-pend-exp.    
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "c-time":U THEN ASSIGN pFieldValue = RowObject.c-time.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-esp":U THEN ASSIGN pFieldValue = RowObject.cod-esp.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "desc-tp-documento":U THEN ASSIGN pFieldValue = RowObject.desc-tp-documento.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "documento":U THEN ASSIGN pFieldValue = RowObject.documento.
        WHEN "nr-crta-remessa":U THEN ASSIGN pFieldValue = RowObject.nr-crta-remessa.
        WHEN "nr-docto":U THEN ASSIGN pFieldValue = RowObject.nr-docto.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
        WHEN "serie":U THEN ASSIGN pFieldValue = RowObject.serie.
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
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
        WHEN "dt-apresentacao":U THEN ASSIGN pFieldValue = RowObject.dt-apresentacao.
        WHEN "dt-emissao":U THEN ASSIGN pFieldValue = RowObject.dt-emissao.
        WHEN "dt-today":U THEN ASSIGN pFieldValue = RowObject.dt-today.
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
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetDescFK DBOProgram 
PROCEDURE GetDescFK :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input  param c-table       as char no-undo.
   def input  param i-param       as int  no-undo.
   def output param c-description as char no-undo.

   case c-table:
      when "texto-padrao-mec":u then do:
         find texto-padrao-mec where texto-padrao-mec.codigo = i-param no-lock no-error.
         if avail texto-padrao-mec then
            assign c-description = texto-padrao-mec.descricao.
         else
            assign c-description = "".
      end.
      when "banco":u then do:
         find banco where banco.cod-banco = i-param no-lock no-error.
         if avail banco then
            assign c-description = banco.nome-banco.
         else
            assign c-description = "".
      end.
      when "emitente":u then do:
         find emitente where emitente.cod-emitente = i-param no-lock no-error.
         if avail emitente then
            assign c-description = emitente.nome-abrev.
         else
            assign c-description = "".
      end.
   end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetDescFK2 DBOProgram 
PROCEDURE GetDescFK2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input  param c-table       as char no-undo.
   def input  param i-param       as int  no-undo.
   def output param c-description as char format "x(20000)" no-undo.

   case c-table:
      when "texto-padrao-mec":u then do:
         find texto-padrao-mec where texto-padrao-mec.codigo = i-param no-lock no-error.
         if avail texto-padrao-mec then
            assign c-description = texto-padrao-mec.texto.
         else
            assign c-description = "".
      end.
   end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetDescFK3 DBOProgram 
PROCEDURE GetDescFK3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input  param c-table       as char no-undo.
   def input  param i-param       as int  no-undo.
   def input  param c-param       as CHAR no-undo. 
   def output param c-description as char no-undo.

   case c-table:
      when "Agància":u then do:
         IF l-func-alt-car-rem THEN DO:
             find agencia NO-LOCK
                 where agencia.cod-banco = i-param
                 AND   agencia.agencia   = c-param no-error.
             if avail agencia then
                assign c-description = agencia.nome.
             else
                assign c-description = "".
         END.
      end.
   end.

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
        &IF "{&mguni_version}" < "2.07A" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "ind-tipo-documento":U THEN ASSIGN pFieldValue = RowObject.ind-tipo-documento.
        WHEN "qtde-copia":U THEN ASSIGN pFieldValue = RowObject.qtde-copia.
        WHEN "qtde-original":U THEN ASSIGN pFieldValue = RowObject.qtde-original.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice crta-remessa
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo nr-crta-remessa
               retorna valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE crta-remessa-docto-exp.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE crta-remessa-docto-exp.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-crta-remessa LIKE crta-remessa-docto-exp.nr-crta-remessa NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE crta-remessa-docto-exp.sequencia NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo       = RowObject.ep-codigo
           pcod-estabel     = RowObject.cod-estabel
           pnr-crta-remessa = RowObject.nr-crta-remessa
           psequencia       = RowObject.sequencia.

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
  Purpose:     Reposiciona registro com base no °ndice crta-remessa
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo nr-crta-remessa
               recebe valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE crta-remessa-docto-exp.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE crta-remessa-docto-exp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-crta-remessa LIKE crta-remessa-docto-exp.nr-crta-remessa NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE crta-remessa-docto-exp.sequencia NO-UNDO.

    FIND FIRST bfcrta-remessa-docto-exp WHERE 
        bfcrta-remessa-docto-exp.ep-codigo = pep-codigo AND 
        bfcrta-remessa-docto-exp.cod-estabel = pcod-estabel AND 
        bfcrta-remessa-docto-exp.nr-crta-remessa = pnr-crta-remessa AND 
        bfcrta-remessa-docto-exp.sequencia = psequencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcrta-remessa-docto-exp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcrta-remessa-docto-exp)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToCrtaRemessa DBOProgram 
PROCEDURE linkToCrtaRemessa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter phandle as handle no-undo.
    
    run getkey in phandle (output i-ep-codigo,
                           output c-cod-estabel,
                           output c-nr-crta-remessa).
                           
    run setConstraintCrtaRemessa in this-procedure (input i-ep-codigo,
                                                    input c-cod-estabel,
                                                    input c-nr-crta-remessa).
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCrtaRemessa DBOProgram 
PROCEDURE openQueryCrtaRemessa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
        WHERE crta-remessa-docto-exp.ep-codigo       = i-ep-codigo and
              crta-remessa-docto-exp.cod-estabel     = c-cod-estabel and
              crta-remessa-docto-exp.nr-crta-remessa = c-nr-crta-remessa INDEXED-REPOSITION.

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
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK INDEXED-REPOSITION.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-alimenta-tit-selec DBOProgram 
PROCEDURE pi-alimenta-tit-selec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
---- --------------------------------------------------------------------------*/
    
&IF "{&mguni_version}" >= "2.07A" &THEN
    def input  param ep-codigo       LIKE empresa.ep-codigo       no-undo.
&ELSE
    def input  param ep-codigo       as int       no-undo.
&ENDIF
    def input  param cod-estabel     as char      no-undo.
    def input  param nr-crta-remessa as char      no-undo.
    def input  param prod-financ     as char      no-undo.
    def input  param dt-vinculado    as DATE      no-undo.
    def input  param vl-paridade     as DECIMAL   no-undo.
    def input  param i-conta-cambio  as int       no-undo.
    DEF INPUT PARAM TABLE FOR tt-crta-remessa-titulo.
    DEF INPUT PARAM selec-r-rowid AS ROWID NO-UNDO. 
    

    def VAR p-moeda          as integer no-undo.
    def VAR p-dt-vencimen    as date    no-undo.
    def VAR p-vl-saldo-me    as decimal no-undo.
    def VAR p-nr-proc-exp    as char    no-undo.
    def VAR p-val-comis      as decimal no-undo.
    def VAR p-situacao       as integer no-undo.

    IF i-conta-cambio > 1 THEN DO:
        
        /*Busca documentos do tipo carta contrato de cambio*/
        FOR EACH    bfcrta-remessa-docto-exp 
            WHERE   bfcrta-remessa-docto-exp.ep-codigo            = ep-codigo
            AND     bfcrta-remessa-docto-exp.cod-estabel          = cod-estabel
            AND     bfcrta-remessa-docto-exp.nr-crta-remessa      = nr-crta-remessa
            AND     bfcrta-remessa-docto-exp.ind-tipo-documento   = 13 
            NO-LOCK:        
           
            FOR each    bf-crta-remessa-docto-pend-exp 
                WHERE   bf-crta-remessa-docto-pend-exp.ep-codigo            = bfcrta-remessa-docto-exp.ep-codigo
                AND     bf-crta-remessa-docto-pend-exp.cod-estabel          = bfcrta-remessa-docto-exp.cod-estabel
                AND     bf-crta-remessa-docto-pend-exp.nr-crta-remessa      = bfcrta-remessa-docto-exp.nr-crta-remessa
                AND     bf-crta-remessa-docto-pend-exp.documento            = bfcrta-remessa-docto-exp.documento
                AND     bf-crta-remessa-docto-pend-exp.ind-tipo-documento   = bfcrta-remessa-docto-exp.ind-tipo-documento
                NO-LOCK:
                
                FIND FIRST tt-crta-remessa-titulo
                    WHERE   tt-crta-remessa-titulo.ep-codigo       = bf-crta-remessa-docto-pend-exp.ep-codigo
                    AND     tt-crta-remessa-titulo.cod-estabel     = bf-crta-remessa-docto-pend-exp.cod-estabel
                    AND     tt-crta-remessa-titulo.nr-crta-remessa = bf-crta-remessa-docto-pend-exp.nr-crta-remessa
                    AND     tt-crta-remessa-titulo.nr-docto        = bf-crta-remessa-docto-pend-exp.nr-docto
                    NO-LOCK NO-ERROR.
                                       
                    /*Alimentando a temp-table*/
                    CREATE tt-titulos-selecionados.
    
    
                    IF AVAIL tt-crta-remessa-titulo THEN DO:
    
                        ASSIGN  tt-titulos-selecionados.de-vl-vinculado   = tt-crta-remessa-titulo.vl-vinculado-me
                                tt-titulos-selecionados.vl-saldo-me       = tt-crta-remessa-titulo.vl-vinculado-me
                                tt-titulos-selecionados.cod-emitente      = tt-crta-remessa-titulo.cod-emitente
                                tt-titulos-selecionados.nr-docto          = tt-crta-remessa-titulo.nr-docto.
                    END.
                    ELSE RETURN "NOK":U.
    
                    ASSIGN  tt-titulos-selecionados.cod-estabel       = bf-crta-remessa-docto-pend-exp.cod-estabel
                            tt-titulos-selecionados.serie             = bf-crta-remessa-docto-pend-exp.serie
                            tt-titulos-selecionados.cod-esp           = bf-crta-remessa-docto-pend-exp.cod-esp
                            tt-titulos-selecionados.parcela           = bf-crta-remessa-docto-pend-exp.parcela.
    
                    RUN adbo/boad346.p PERSISTENT SET h-boad346.
                    RUN pi-carrega-contratos IN h-boad346 (OUTPUT TABLE tt-contrato-exp).
                    DELETE PROCEDURE h-boad346.
                    
                    /*Localiza o documento em contrato-exp*/
                    FIND FIRST  tt-contrato-exp 
                        WHERE   tt-contrato-exp.nr-contrato = bfcrta-remessa-docto-exp.documento
                        NO-LOCK NO-ERROR.
        
                    IF AVAIL tt-contrato-exp THEN DO:
                    
                        ASSIGN  tt-titulos-selecionados.ctr-referencia    = tt-contrato-exp.referencia
                                tt-titulos-selecionados.dt-referencia     = tt-contrato-exp.dt-referencia
                                tt-titulos-selecionados.nr-contrato       = tt-contrato-exp.nr-contrato
                                tt-titulos-selecionados.dt-contrato       = tt-contrato-exp.dt-contrato.

                        run adbo/boad347.p persistent set h-boad347.
                        run pi-busca-saldo-orig in h-boad347 (input  bf-crta-remessa-docto-pend-exp.ep-codigo,
                                                              input  bf-crta-remessa-docto-pend-exp.cod-estabel,
                                                              input  tt-crta-remessa-titulo.cod-emitente,
                                                              input  bf-crta-remessa-docto-pend-exp.cod-esp,
                                                              input  bf-crta-remessa-docto-pend-exp.serie,
                                                              input  bf-crta-remessa-docto-pend-exp.nr-docto,
                                                              input  bf-crta-remessa-docto-pend-exp.parcela,
                                                              OUTPUT p-moeda,
                                                              OUTPUT p-dt-vencimen,
                                                              OUTPUT p-vl-saldo-me,
                                                              OUTPUT p-nr-proc-exp,
                                                              OUTPUT p-situacao,
                                                              OUTPUT p-val-comis).
                         delete procedure h-boad347.
    
                        IF RETURN-VALUE = "OK":U THEN DO:
    
                            ASSIGN tt-titulos-selecionados.moeda           =   p-moeda
                                   tt-titulos-selecionados.vl-saldo-me     =   p-vl-saldo-me
                                   tt-titulos-selecionados.dt-vencimen     =   p-dt-vencimen
                                   tt-titulos-selecionados.dt-pg-prev      =   p-dt-vencimen
                                   tt-titulos-selecionados.nr-proc-exp     =   p-nr-proc-exp.
                        END.
                        ELSE RETURN "NOK":U.
    
                        ASSIGN  tt-titulos-selecionados.ep-codigo         = ep-codigo
                                tt-titulos-selecionados.dt-vinculado      = dt-vinculado.
                                
                        IF tt-contrato-exp.tp-contrato-exp = 3 THEN
                            tt-titulos-selecionados.prod-financ       = prod-financ.
                        ELSE
                            tt-titulos-selecionados.prod-financ       = "acc".
                            
                        run adbo/boad346.p persistent set h-boad346.
                        run pi-checa-paridade-contrato in h-boad346 (input  ep-codigo,       
                                                                     input  cod-estabel,     
                                                                     input  nr-crta-remessa 
                                                                     ).
                        delete procedure h-boad346.
    
                        IF RETURN-VALUE = "NOK":U THEN 
                            ASSIGN tt-titulos-selecionados.vl-paridade       = 1.
                        ELSE
                            ASSIGN tt-titulos-selecionados.vl-paridade       = vl-paridade.
                    
                    END.
                    ELSE RETURN "NOK":U.
            END.
        END.
    END.
    ELSE DO:

        /*Busca documentos do tipo carta contrato de cambio*/
        FIND FIRST  bfcrta-remessa-docto-exp 
            WHERE   bfcrta-remessa-docto-exp.ep-codigo            = ep-codigo
            AND     bfcrta-remessa-docto-exp.cod-estabel          = cod-estabel
            AND     bfcrta-remessa-docto-exp.nr-crta-remessa      = nr-crta-remessa
            AND     bfcrta-remessa-docto-exp.ind-tipo-documento   = 13 
            NO-LOCK.

        IF AVAIL bfcrta-remessa-docto-exp THEN DO:

            RUN adbo/boad346.p PERSISTENT SET h-boad346.
            RUN pi-carrega-contratos IN h-boad346 (OUTPUT TABLE tt-contrato-exp).
            DELETE PROCEDURE h-boad346.

            /* Localiza o documento em contrato-exp*/
            FIND FIRST  tt-contrato-exp
                where   tt-contrato-exp.nr-contrato = bfcrta-remessa-docto-exp.documento
                NO-LOCK NO-ERROR.

            IF AVAIL tt-contrato-exp THEN DO:
                
                /* Busca informaá‰es para alimentar temp-table*/
                FOR EACH   tt-crta-remessa-titulo 
                    WHERE   tt-crta-remessa-titulo.ep-codigo       = bfcrta-remessa-docto-exp.ep-codigo
                    AND     tt-crta-remessa-titulo.cod-estabel     = bfcrta-remessa-docto-exp.cod-estabel
                    AND     tt-crta-remessa-titulo.nr-crta-remessa = bfcrta-remessa-docto-exp.nr-crta-remessa
                    /*AND     tt-crta-remessa-titulo.sequencia       = bfcrta-remessa-docto-exp.sequencia*/
                    NO-LOCK:



                    run adbo/boad347.p persistent set h-boad347.
                    run pi-busca-saldo-orig in h-boad347 (input  tt-crta-remessa-titulo.ep-codigo,
                                                          input  tt-crta-remessa-titulo.cod-estabel,
                                                          input  tt-crta-remessa-titulo.cod-emitente,
                                                          input  tt-crta-remessa-titulo.cod-esp,
                                                          input  tt-crta-remessa-titulo.serie,
                                                          input  tt-crta-remessa-titulo.nr-docto,
                                                          input  tt-crta-remessa-titulo.parcela,
                                                          OUTPUT p-moeda,
                                                          OUTPUT p-dt-vencimen,
                                                          OUTPUT p-vl-saldo-me,
                                                          OUTPUT p-nr-proc-exp,
                                                          OUTPUT p-situacao,
                                                          OUTPUT p-val-comis).
                    delete procedure h-boad347.
                                        
                    CREATE tt-titulos-selecionados.
                    
                    IF RETURN-VALUE = "OK":U THEN DO:
                    ASSIGN tt-titulos-selecionados.moeda           =   p-moeda
                           tt-titulos-selecionados.vl-saldo-me     =   p-vl-saldo-me
                           tt-titulos-selecionados.dt-vencimen     =   p-dt-vencimen
                           tt-titulos-selecionados.dt-pg-prev      =   p-dt-vencimen
                           tt-titulos-selecionados.nr-proc-exp     =   p-nr-proc-exp.
                    END.
                    ELSE RETURN "NOK":U.
                    
                    /*Alimentando a temp-table*/
                    ASSIGN  tt-titulos-selecionados.ep-codigo         = ep-codigo
                    
                            tt-titulos-selecionados.ctr-referencia    = tt-contrato-exp.referencia
                            tt-titulos-selecionados.dt-referencia     = tt-contrato-exp.dt-referencia
                            tt-titulos-selecionados.nr-contrato       = tt-contrato-exp.nr-contrato
                            tt-titulos-selecionados.dt-contrato       = tt-contrato-exp.dt-contrato
                            
                            tt-titulos-selecionados.cod-estabel       = tt-crta-remessa-titulo.cod-estabel
                            tt-titulos-selecionados.cod-emitente      = tt-crta-remessa-titulo.cod-emitente
                            tt-titulos-selecionados.serie             = tt-crta-remessa-titulo.serie
                            tt-titulos-selecionados.cod-esp           = tt-crta-remessa-titulo.cod-esp
                            tt-titulos-selecionados.nr-docto          = tt-crta-remessa-titulo.nr-docto
                            tt-titulos-selecionados.parcela           = tt-crta-remessa-titulo.parcela
                            tt-titulos-selecionados.de-vl-vinculado   = tt-crta-remessa-titulo.vl-vinculado-me
                            tt-titulos-selecionados.vl-saldo-me       = tt-crta-remessa-titulo.vl-vinculado-me
                            
                            tt-titulos-selecionados.dt-vinculado      = dt-vinculado.
                    IF tt-contrato-exp.tp-contrato-exp = 3 THEN
                        tt-titulos-selecionados.prod-financ       = prod-financ.
                    ELSE
                        tt-titulos-selecionados.prod-financ       = "acc".

                    run adbo/boad346.p persistent set h-boad346.
                    run pi-checa-paridade-contrato in h-boad346 (input  ep-codigo,       
                                                                 input  cod-estabel,     
                                                                 input  nr-crta-remessa).
                    delete procedure h-boad346.
                    
                    IF  RETURN-VALUE = 'NOK':U THEN
                        ASSIGN tt-titulos-selecionados.vl-paridade = 1.
                    ELSE
                        ASSIGN tt-titulos-selecionados.vl-paridade = vl-paridade.
                            
                END.
            END.
            ELSE RETURN "NOK":U.
        END.
        ELSE RETURN "NOK":U.
    END.

    RUN pi-trata-tit-selec (INPUT TABLE tt-crta-remessa-titulo,
                            INPUT selec-r-rowid).                 
    
    IF RETURN-VALUE <> "OK":U THEN
       RETURN RETURN-VALUE.
        
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-autenticacao DBOProgram 
PROCEDURE pi-autenticacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var i-ep-codigo like crta-remessa-docto-exp.ep-codigo no-undo.
    def var c-usuario   like crta-remessa-docto-exp.usuario   no-undo.
    
    {method/svc/autentic/autentic.i
            &vUserEnterprise="i-ep-codigo"
            &vUserName="c-usuario"}
    
    assign RowObject.ep-codigo = i-ep-codigo
           RowObject.usuario   = c-usuario
           RowObject.c-time    = string(TIME, "HH:MM")
           RowObject.dt-today  = today.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-docto-titulos DBOProgram 
PROCEDURE pi-busca-docto-titulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF "{&mguni_version}" >= "2.07A" &THEN
    def input  param p-ep-codigo       LIKE empresa.ep-codigo  no-undo.
&ELSE
    def input  param p-ep-codigo       as int  no-undo.
&ENDIF
    def input  param p-cod-estabel     as char no-undo.
    def input  param p-nr-crta-remessa as char no-undo.
    def input  param p-documento       as char no-undo.
    def input  param p-ind-tipo-docto  as int  no-undo.
    def input  param p-desc-tp-docto   as char no-undo.
    def output param table for tt-titulo.

    for each tt-titulo:
       delete tt-titulo.
    end.

    for each crta-remessa-docto-pend-exp where 
             crta-remessa-docto-pend-exp.ep-codigo          = p-ep-codigo       and
             crta-remessa-docto-pend-exp.cod-estabel        = p-cod-estabel     and
             crta-remessa-docto-pend-exp.nr-crta-remessa    = p-nr-crta-remessa and   
             crta-remessa-docto-pend-exp.documento          = p-documento       and   
             crta-remessa-docto-pend-exp.ind-tipo-documento = p-ind-tipo-docto  and
             crta-remessa-docto-pend-exp.desc-tp-documento  = p-desc-tp-docto 
             no-lock:

       create tt-titulo.
       assign tt-titulo.cod-esp      = crta-remessa-docto-pend-exp.cod-esp
              tt-titulo.serie        = crta-remessa-docto-pend-exp.serie
              tt-titulo.nr-docto     = crta-remessa-docto-pend-exp.nr-docto
              tt-titulo.parcela      = crta-remessa-docto-pend-exp.parcela.
    end.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-buscar-titulos-vinculados DBOProgram 
PROCEDURE pi-buscar-titulos-vinculados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR v-sequencia AS INT NO-UNDO.

  DEF INPUT PARAM p-documento LIKE crta-remessa-docto-exp.documento NO-UNDO.
  DEF INPUT PARAM p-nr-crta-remessa LIKE crta-remessa-exp.nr-crta-remessa NO-UNDO.

  FOR EACH contr-titulo-exp
      WHERE contr-titulo-exp.nr-contrato = p-documento NO-LOCK:
      FIND FIRST crta-remessa-titulo
          WHERE crta-remessa-titulo.ep-codigo = contr-titulo-exp.ep-codigo
            AND crta-remessa-titulo.cod-estabel = contr-titulo-exp.cod-estabel
            AND crta-remessa-titulo.cod-esp = contr-titulo-exp.cod-esp
            AND crta-remessa-titulo.serie = contr-titulo-exp.serie
            AND crta-remessa-titulo.nr-docto = contr-titulo-exp.nr-docto
            AND crta-remessa-titulo.parcela = contr-titulo-exp.parcela NO-LOCK NO-ERROR.
      IF  NOT AVAIL crta-remessa-titulo THEN DO:
          FIND LAST crta-remessa-titulo
              WHERE crta-remessa-titulo.ep-codigo = contr-titulo-exp.ep-codigo
                AND crta-remessa-titulo.cod-estabel = contr-titulo-exp.cod-estabel
                AND crta-remessa-titulo.nr-crta-remessa = p-nr-crta-remessa NO-LOCK NO-ERROR.
          IF AVAIL crta-remessa-titulo THEN
              ASSIGN v-sequencia = crta-remessa-titulo.sequencia + 1.
          ELSE
              ASSIGN v-sequencia = 1.
          CREATE crta-remessa-titulo.
          ASSIGN crta-remessa-titulo.ep-codigo = contr-titulo-exp.ep-codigo
                 crta-remessa-titulo.cod-estabel = contr-titulo-exp.cod-estabel
                 crta-remessa-titulo.cod-esp = contr-titulo-exp.cod-esp
                 crta-remessa-titulo.serie = contr-titulo-exp.serie
                 crta-remessa-titulo.nr-docto = contr-titulo-exp.nr-docto
                 crta-remessa-titulo.parcela = contr-titulo-exp.parcela
                 crta-remessa-titulo.cod-emitente = contr-titulo-exp.cod-emitente
                 crta-remessa-titulo.vl-vinculado-me = contr-titulo-exp.vl-vinculado-me
                 crta-remessa-titulo.dt-vinculado = contr-titulo-exp.dt-vinculado
                 crta-remessa-titulo.situacao = contr-titulo-exp.situacao
                 crta-remessa-titulo.estab-titulo = contr-titulo-exp.estab-titulo
                 crta-remessa-titulo.nr-crta-remessa = p-nr-crta-remessa
                 crta-remessa-titulo.sequencia = v-sequencia.

          IF l-func-alt-car-rem THEN
              run pi-cria-docto-automatico (input  crta-remessa-titulo.ep-codigo,
                                            input  crta-remessa-titulo.cod-estabel,
                                            input  crta-remessa-titulo.nr-crta-remessa,
                                            input  crta-remessa-titulo.cod-emitente,
                                            input  crta-remessa-titulo.cod-esp,
                                            input  crta-remessa-titulo.serie,
                                            input  crta-remessa-titulo.nr-docto,
                                            input  crta-remessa-titulo.parcela).
       END.
  END.
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-docto DBOProgram 
PROCEDURE pi-cria-docto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR i-seq AS INTEGER NO-UNDO.
    def input parameter table for tt-documentos.

    assign cQueryUseded = "Main".
    for each RowObject:
       delete RowObject.
    end.

    FIND FIRST tt-documentos no-lock NO-ERROR.

    FIND LAST crta-remessa-docto-pend-exp no-lock
        WHERE crta-remessa-docto-pend-exp.ep-codigo       = tt-documentos.ep-codigo          
        AND   crta-remessa-docto-pend-exp.cod-estabel     = tt-documentos.cod-estabel        
        AND   crta-remessa-docto-pend-exp.nr-crta-remessa = tt-documentos.nr-crta-remessa 
        AND   crta-remessa-docto-pend-exp.sequencia       = tt-documentos.sequencia NO-ERROR.
    IF AVAIL crta-remessa-docto-pend-exp THEN 
        ASSIGN i-seq = crta-remessa-docto-pend-exp.sequencia + 10.
    ELSE
        ASSIGN i-seq = 10.

    for each tt-documentos:
        create RowObject.
        assign RowObject.ep-codigo          = tt-documentos.ep-codigo         
               RowObject.cod-estabel        = tt-documentos.cod-estabel       
               RowObject.nr-crta-remessa    = tt-documentos.nr-crta-remessa   
               RowObject.sequencia          = tt-documentos.sequencia         
               RowObject.documento          = tt-documentos.documento         
               RowObject.dt-emissao         = tt-documentos.dt-emissao        
               RowObject.dt-apresentacao    = tt-documentos.dt-apresentacao   
               RowObject.ind-tipo-documento = tt-documentos.ind-tipo-documento
               RowObject.qtde-original      = 1.
        run createRecord in this-procedure.
        FIND FIRST bf-crta-remessa-docto-pend-exp EXCLUSIVE-LOCK
            WHERE bf-crta-remessa-docto-pend-exp.ep-codigo           = tt-documentos.ep-codigo          
            AND   bf-crta-remessa-docto-pend-exp.cod-estabel         = tt-documentos.cod-estabel        
            AND   bf-crta-remessa-docto-pend-exp.nr-crta-remessa     = tt-documentos.nr-crta-remessa   
            AND   bf-crta-remessa-docto-pend-exp.documento           = tt-documentos.documento          
            AND   bf-crta-remessa-docto-pend-exp.ind-tipo-documento  = tt-documentos.ind-tipo-documento
            NO-ERROR.
        IF NOT avail bf-crta-remessa-docto-pend-exp THEN DO:
            CREATE bf-crta-remessa-docto-pend-exp.
            ASSIGN bf-crta-remessa-docto-pend-exp.ep-codigo           = tt-documentos.ep-codigo         
                   bf-crta-remessa-docto-pend-exp.cod-estabel         = tt-documentos.cod-estabel       
                   bf-crta-remessa-docto-pend-exp.nr-crta-remessa     = tt-documentos.nr-crta-remessa   
                   bf-crta-remessa-docto-pend-exp.documento           = tt-documentos.documento         
                   bf-crta-remessa-docto-pend-exp.ind-tipo-documento  = tt-documentos.ind-tipo-documento
                   bf-crta-remessa-docto-pend-exp.cod-esp             = tt-documentos.cod-esp           
                   bf-crta-remessa-docto-pend-exp.serie               = tt-documentos.serie             
                   bf-crta-remessa-docto-pend-exp.nr-docto            = tt-documentos.nr-docto          
                   bf-crta-remessa-docto-pend-exp.parcela             = tt-documentos.parcela           
                   bf-crta-remessa-docto-pend-exp.cod-emitente        = tt-documentos.cod-emitente      
                   bf-crta-remessa-docto-pend-exp.sequencia           = i-seq.
            assign i-seq = i-seq + 10.
        END.
    end.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-docto-automatico DBOProgram 
PROCEDURE pi-cria-docto-automatico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF "{&mguni_version}" >= "2.07A" &THEN
    def input parameter p-ep-codigo       LIKE empresa.ep-codigo   no-undo.
&ELSE
    def input parameter p-ep-codigo       as integer   no-undo.
&ENDIF
    def input parameter p-cod-estabel     as character no-undo.
    def input parameter p-nr-crta-remessa as character no-undo.
    def input parameter p-cod-emitente    as integer   no-undo.
    def input parameter p-cod-esp         as character no-undo.
    def input parameter p-serie           as character no-undo.
    def input parameter p-nr-docto        as character no-undo.
    def input parameter p-parcela         as character no-undo.

    if can-find (param-global where param-global.modulo-ex = yes) then do:
        run ecp/ec0003i.p (input p-ep-codigo,
                           input p-cod-estabel,
                           input p-nr-crta-remessa,
                           input p-cod-emitente,
                           input p-cod-esp,
                           input p-serie,
                           input p-nr-docto,
                           input p-parcela).
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-docto-titulos DBOProgram 
PROCEDURE pi-cria-docto-titulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF "{&mguni_version}" >= "2.07A" &THEN
    def input param p-ep-codigo       LIKE empresa.ep-codigo  no-undo.
&ELSE
    def input param p-ep-codigo       as int  no-undo.
&ENDIF
    def input param p-cod-estabel     as char no-undo.
    def input param p-nr-crta-remessa as char no-undo.
    def input param p-documento       as char no-undo.
    def input param p-ind-tipo-docto  as int  no-undo.
    def input param p-desc-tp-docto   as char no-undo.
    def input param table for tt-titulo.

    def var i-seq as int no-undo.

    for each crta-remessa-docto-pend-exp where
             crta-remessa-docto-pend-exp.ep-codigo          = p-ep-codigo       and
             crta-remessa-docto-pend-exp.cod-estabel        = p-cod-estabel     and
             crta-remessa-docto-pend-exp.nr-crta-remessa    = p-nr-crta-remessa and
             crta-remessa-docto-pend-exp.documento          = p-documento       and
             crta-remessa-docto-pend-exp.ind-tipo-documento = p-ind-tipo-docto  and
             crta-remessa-docto-pend-exp.desc-tp-documento  = p-desc-tp-docto  
             exclusive-lock:
       delete crta-remessa-docto-pend-exp.    
    end.

    assign i-seq = 10.
    find last crta-remessa-docto-pend-exp where
              crta-remessa-docto-pend-exp.ep-codigo          = p-ep-codigo   and
              crta-remessa-docto-pend-exp.cod-estabel        = p-cod-estabel and
              crta-remessa-docto-pend-exp.nr-crta-remessa    = p-nr-crta-remessa 
              no-lock no-error.
    if avail crta-remessa-docto-pend-exp then
       assign i-seq = crta-remessa-docto-pend-exp.sequencia + 10.
              
    for each tt-titulo:
       create crta-remessa-docto-pend-exp.
       assign crta-remessa-docto-pend-exp.ep-codigo          = p-ep-codigo
              crta-remessa-docto-pend-exp.cod-estabel        = p-cod-estabel
              crta-remessa-docto-pend-exp.nr-crta-remessa    = p-nr-crta-remessa
              crta-remessa-docto-pend-exp.documento          = p-documento 
              crta-remessa-docto-pend-exp.ind-tipo-documento = p-ind-tipo-docto 
              crta-remessa-docto-pend-exp.desc-tp-documento  = p-desc-tp-docto
              crta-remessa-docto-pend-exp.cod-esp            = tt-titulo.cod-esp
              crta-remessa-docto-pend-exp.serie              = tt-titulo.serie       
              crta-remessa-docto-pend-exp.nr-docto           = tt-titulo.nr-docto 
              crta-remessa-docto-pend-exp.parcela            = tt-titulo.parcela    
              crta-remessa-docto-pend-exp.sequencia          = i-seq.
       assign i-seq = i-seq + 10.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-efetiva-vinculo DBOProgram 
PROCEDURE pi-efetiva-vinculo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR l-status AS char NO-UNDO.
DEF VAR h-apl768zd AS HANDLE NO-UNDO.

ASSIGN l-status = "NOK".

block:
do transaction:
    
    run pi-busca-empresa in this-procedure (output c-ep-codigo). 
    /*** Conecta bases do EMS 5.0 ***                 
    connect -db emsfin -S arv21752 -N tcp -H arvoredo.*/
    RUN pi-conecta-ems5 (INPUT 1).
    
    /*** Verifica Erro na Conex∆o das Bases ***/
    {ecp/ec0005k.i}

    if i-seq-erro <> 0 then do:
      {method/showmessage.i1}
      {method/showmessage.i2}

      undo block, leave block.
    end.

    &IF "{&mguni_version}" <= "2.06B" &THEN
    assign v_cod_usuar_corren_old = v_cod_usuar_corren 
           v_cod_empres_usuar_old = v_cod_empres_usuar.

    assign v_cod_usuar_corren = ""
           v_cod_empres_usuar = "".

    /*** chama login do usuario ***/
    run prgtec/btb/btb906za.py.

    if v_cod_usuar_corren = "" or 
       v_cod_empres_usuar = "" then do:
  
       assign v_cod_usuar_corren = v_cod_usuar_corren_old 
              v_cod_empres_usuar = v_cod_empres_usuar_old.

       undo block, leave block.
    end.
    &ENDIF
    
    ASSIGN v_cod_empres_usuar_aux = v_cod_empres_usuar.
   
    FOR EACH tt-titulos-selecionados no-lock
        BREAK BY tt-titulos-selecionados.nr-docto:                          

        IF FIRST-OF(tt-titulos-selecionados.nr-docto) THEN DO:
            FOR EACH bf-contr-titulo-exp
                WHERE  bf-contr-titulo-exp.ep-codigo       =   tt-titulos-selecionados.ep-codigo
                AND    bf-contr-titulo-exp.cod-estabel     =   tt-titulos-selecionados.cod-estabel
                AND    bf-contr-titulo-exp.referencia      =   tt-titulos-selecionados.ctr-referencia
                AND    bf-contr-titulo-exp.dt-referencia   =   tt-titulos-selecionados.dt-referencia
                AND    bf-contr-titulo-exp.nr-docto        =   tt-titulos-selecionados.nr-docto
                NO-LOCK:
    
            if avail bf-contr-titulo-exp then do:
                FIND FIRST bfcontrato-exp
                    where bfcontrato-exp.nr-contrato  = bf-contr-titulo-exp.nr-contrato and
                          bfcontrato-exp.dt-contrato  = bf-contr-titulo-exp.dt-contrato 
                    NO-LOCK NO-ERROR.
    
                if avail bfcontrato-exp then do:
                     
                      run adbo/boad350.p persistent set h-boad350.
                      for each RowErrors.
                         delete RowErrors.
                      end.
                      DELETE PROCEDURE h-boad350.
    
                      assign l-atualiza = yes.
    
                      if bfcontrato-exp.tp-emprestimo <> 2 
                          AND bfcontrato-exp.tp-contrato-exp = 3
                          then do:
                          /*** Cria temp-table tt_operac_financ_cambio_1 ***/
                          if bf-contr-titulo-exp.num-id-operac-financ <> 0 THEN DO:
                             RUN prgfin/apl/apl768zd.py PERSISTENT SET h-apl768zd.
                             RUN pi_main_code_retorna_tt_operac_financ_1 in h-apl768zd (INPUT 1,
                                                                                        INPUT bf-contr-titulo-exp.num-id-operac-financ,
                                                                                        OUTPUT TABLE tt_operac_financ_cambio_1).
                             DELETE PROCEDURE h-apl768zd.
                          END.

                          find first tt_operac_financ_cambio_1 no-lock no-error.
                          if avail tt_operac_financ_cambio_1 then do:
                             /*** verifica se o valor do titulo Ç igual ao valor do emprestimo ***/
                             ASSIGN vl-vinc-mo-contrato = bf-contr-titulo-exp.vl-vinculado-me.
    
                             IF  l-funcao-arbitragem THEN DO:
                                 {ecp/ec0005.i2 "bf-contr-titulo-exp"
                                                "cod-moeda-cambial"
                                                "vl-paridade-impl"
                                                "vl-vinc-mo-contrato"
                                                "vl-saldo-liquidar-mo-contrato"}
                             END.
                             assign c-empresa = v_cod_empres_usuar
                                    v_cod_empres_usuar = tt_operac_financ_cambio_1.tta_cod_empresa.
                                 
                             if vl-vinc-mo-contrato = tt_operac_financ_cambio_1.tta_val_operac_financ then
                                assign l-atualiza = yes.
                             else do:
                                assign l-atualiza = no.
                                
                                RUN utp/ut-msgs.p (INPUT "msg":U, INPUT 25333, INPUT "").
                                create RowErrors.
                                assign RowErrors.ErrorSequence    = 10
                                       RowErrors.ErrorNumber      = 25333
                                       RowErrors.ErrorParameters  = ""
                                       RowErrors.ErrorType        = ""
                                       RowErrors.ErrorSubType     = "ERROR"
                                       RowErrors.ErrorDescription = return-value.
            
                                {method/showmessage.i1}
                                {method/showmessage.i2}
                                
                                /*** Desconecta bases do EMS 5.0 **/
    /*                             RUN pi-conecta-ems5(INPUT 2). */
    
                                undo block, leave block.
                             end.
                          end.
            
                          if l-atualiza = yes then do:
    
                             assign p-cta-produt-financ  = ""
                                    p-cod-plano-cta-ctbl = "".
            
                             /** Busca conta para contabilizaÁ„o do ACE **/
                             run prgfin/apl/apl769zd.py (input  1,
                                                         input  tt_operac_financ_cambio_1.tta_cod_empresa,
                                                         input  tt_operac_financ_cambio_1.tta_cod_produt_financ,
                                                         input  tt_operac_financ_cambio_1.tta_cod_banco,
                                                         input  "Saldo Curto Prazo",
                                                         input  bf-contr-titulo-exp.dt-vinculado,
                                                         output p-cta-produt-financ,
                                                         output p-cod-plano-cta-ctbl).
            
                             if p-cta-produt-financ <> "" then do:
                                for each tt_rateio_valores:
                                   delete tt_rateio_valores.
                                end.
            
                                create tt_rateio_valores.
                                assign tt_rateio_valores.tta_cod_plano_cta_ctbl = p-cod-plano-cta-ctbl
                                       tt_rateio_valores.tta_cod_cta_ctbl       = p-cta-produt-financ
                                       tt_rateio_valores.ttv_val_rat_aprop_ctbl = vl-vinc-mo-contrato /*tt-contr-titulo-exp.vl-vinculado-me*/ .
                             end.
    
                             /*** Efetiva emprestimo no APL5 ***/
                            run prgfin/apl/apl007zm.py (1,
                                                         input bf-contr-titulo-exp.num-id-operac-financ,
                                                         input tt_operac_financ_cambio_1.tta_cod_banco,
                                                         input tt_operac_financ_cambio_1.tta_cod_produt_financ,
                                                         input tt_operac_financ_cambio_1.tta_cod_operac_financ,
                                                         output table tt_log_erro ).
                            
                            /*Bloqueio: verifica se a operacao financeira foi efetivada no apl*/
                            {ecp/ec0005.i5}

                            RUN pi-conecta-ems5(INPUT 1).
                            find first tt_log_erro where tt_log_erro.ttv_num_cod_erro > 0 
                                AND tt_log_erro.ttv_num_cod_erro <> 8573 
                                no-lock no-error.
                            if not avail tt_log_erro then do: 
                               
                                IF bfcontrato-exp.tp-contrato-exp = 3 THEN DO:
                               
                                    run adbo/boad350.p persistent set h-boad350.
                                    run pi-cria-emprestimo-efetivo in h-boad350 (input bfcontrato-exp.ep-codigo,
                                                     input bfcontrato-exp.cod-banco-ems5,
                                                     input bfcontrato-exp.cod-estabel,
                                                     input bfcontrato-exp.dt-contrato,
                                                     input bfcontrato-exp.dt-referencia,
                                                     input today,
                                                     input bfcontrato-exp.nr-contrato,
                                                     input bfcontrato-exp.num-id-operac-financ,
                                                     input bfcontrato-exp.operac-financ,
                                                     input bfcontrato-exp.prod-financ,
                                                     input bfcontrato-exp.referencia,
                                                     input bf-contr-titulo-exp.cod-banco-ems5,
                                                     input bf-contr-titulo-exp.num-id-operac-financ,
                                                     input bf-contr-titulo-exp.operac-financ,
                                                     input bf-contr-titulo-exp.prod-financ,
                                                     input 0,
                                                     input 4,
                                                     input NO,
                                                     input bf-contr-titulo-exp.vl-vinculado-me,
                                                     input 0).
                                    delete procedure h-boad350.
                                END.
                                
                                ASSIGN v_cod_empres_usuar = v_cod_empres_usuar_aux.
    
                                if return-value = "NOK":U then do:
                                   
                                    assign l-atualiza = no.
                                   
                                    run adbo/boad350.p persistent set h-boad350.
    
                                    RUN getRowErrors IN h-boad350 (OUTPUT TABLE RowErrors).
            
                                    {method/showmessage.i1}
                                    {method/showmessage.i2}
                                       
                                    /*** Desconecta bases do EMS 5.0 ***/
    /*                                 RUN pi-conecta-ems5(INPUT 2). */
    
                                   
                                    DELETE PROCEDURE h-boad350.
    
                                    undo block, leave block.
                                end.
            
                                IF  l-funcao-juros-liq-ace = NO
                                    OR (l-funcao-juros-liq-ace
                                    AND p-liquidacao-ace = NO) THEN do:
            
                                    assign l-corrige-contrato = yes.
                                    find first bfcontr-titulo-exp no-lock
                                        where bfcontr-titulo-exp.ep-codigo      = bfcontrato-exp.ep-codigo        and
                                             bfcontr-titulo-exp.cod-estabel    = bfcontrato-exp.cod-estabel      and                       
                                             bfcontr-titulo-exp.referencia     = bfcontrato-exp.referencia       and
                                             bfcontr-titulo-exp.dt-referencia  = bfcontrato-exp.dt-referencia    and
                                             bfcontr-titulo-exp.dt-vinculado  >= bf-contr-titulo-exp.dt-vinculado and
                                             bfcontr-titulo-exp.situacao      <> 2
                                        no-error.
                                    if avail bfcontr-titulo-exp then
                                        assign l-corrige-contrato = no.
                                END.
            
                                if bfcontrato-exp.tp-emprestimo = 1 and
                                    l-corrige-contrato = yes then do:
    
                                    /* Corrige o Valor do Contrato */
                                    
                                    run prgfin/apl/apl029zb.py (input  1,
                                                                input  bfcontrato-exp.num-id-operac-financ,
                                                                input  "",
                                                                input  "",
                                                                input  "",
                                                                input  bf-contr-titulo-exp.dt-vinculado,
                                                                output table tt_log_erro,
                                                                output table tt_correcoes_efetuadas,
                                                                INPUT  YES,
                                                                INPUT  "Data Fim Correá∆o",
                                                                input  bf-contr-titulo-exp.dt-vinculado ).
            
                                    for each tt_log_erro:
            
                                        assign i-seq-erro = i-seq-erro + 10.
            
                                        create RowErrors.
                                        assign RowErrors.ErrorSequence    = i-seq-erro
                                               RowErrors.ErrorNumber      = tt_log_erro.ttv_num_cod_erro
                                               RowErrors.ErrorParameters  = ""
                                               RowErrors.ErrorType        = ""
                                               RowErrors.ErrorSubType     = "ERROR"
                                               RowErrors.ErrorDescription = tt_log_erro.ttv_des_msg_erro.
            
                                        if tt_log_erro.ttv_des_msg_ajuda = "" then                       
                                            assign RowErrors.ErrorHelp        = tt_log_erro.ttv_des_msg_erro.
                                        else
                                            assign RowErrors.ErrorHelp        = tt_log_erro.ttv_des_msg_ajuda.
    
                                        /*** Desconecta bases do EMS 5.0 ***/
    /*                                     RUN pi-conecta-ems5(INPUT 2). */
                                            
                                    end.
                                    if i-seq-erro <> 0 then do:
                                        {method/showmessage.i1}
                                        {method/showmessage.i2}
            
                                        undo block, leave block.
                                    end.
                                end.
            
                                /* DEVERµ CRIAR TABELA INTERNA ANTES DE GERAR O AVA NO EMPRESTIMO DO TIT.  PARA NAO ENCERRAR A OPERAÄ«O */
                                IF  v-funcao-pre-pagto and v-log-aplica-empre-ativo THEN DO:
                                    IF  bfcontrato-exp.tp-emprestimo = 3 OR
                                        bfcontrato-exp.tp-emprestimo = 4 THEN DO:
                                        FOR EACH tt_repas_pend_apl:
                                            DELETE tt_repas_pend_apl.
                                        END.
            
                                        CREATE tt_repas_pend_apl.
                                        ASSIGN tt_repas_pend_apl.tta_num_id_operac_financ = bfcontrato-exp.num-id-operac-financ
                                               tt_repas_pend_apl.tta_num_seq_repas_pend   = 999
                                               tt_repas_pend_apl.tta_dat_repas_pend       = bf-contr-titulo-exp.dt-vinculado
                                               tt_repas_pend_apl.tta_val_repas_pend       = vl-vinc-mo-contrato /*tt-contr-titulo-exp.vl-vinculado-me*/
                                               tt_repas_pend_apl.tta_ind_sit_repas_pend   = "Pendente"
                                               tt_repas_pend_apl.tta_ind_tip_repas_pend   = "Vinculaá∆o".
            
                                        RUN prgfin/acr/acr788za.py PERSISTENT SET h-acr788za.
                                        RUN pi_atualiza_repas_pend_apl in h-acr788za (INPUT-OUTPUT TABLE tt_repas_pend_apl,
                                                                                      INPUT "Quitada",
                                                                                      INPUT bfcontrato-exp.num-id-operac-financ).
                                        DELETE PROCEDURE h-acr788za.
                                    END.
                                END.
                                /*** criou-se a temp-table tt_operac_financ_cambio_1 novamente, para ter o valor do saldo,
                                     pois os mesmo s¢ existe depois da efetivaá∆o do emprÇstimo ***/
                                
                                RUN prgfin/apl/apl768zd.py PERSISTENT SET h-apl768zd.
                                RUN pi_main_code_retorna_tt_operac_financ_1 in h-apl768zd (INPUT 1,
                                                                                           INPUT bfcontrato-exp.num-id-operac-financ,
                                                                                           OUTPUT TABLE tt_operac_financ_cambio_1).
                                DELETE PROCEDURE h-apl768zd.
            
                                find first tt_operac_financ_cambio_1 no-error.
    
                                assign de-saldo-operac-financ = tt_operac_financ_cambio_1.tta_val_sdo_operac_financ - vl-vinc-mo-contrato /*tt-contr-titulo-exp.vl-vinculado-me*/
                                       de-saldo-princ-operac-financ = tt_operac_financ_cambio_1.tta_val_sdo_princ_operac_financ - vl-vinc-mo-contrato /*tt-contr-titulo-exp.vl-vinculado-me*/ .
                                        
                                IF  l-hist-ava then
                                    ASSIGN c-historico = "Vinculado o T°tulo: "
                                                       + "estab "          + bf-contr-titulo-exp.cod-estabel
                                                       + " serie "         + bf-contr-titulo-exp.serie
                                                       + ", esp "          + bf-contr-titulo-exp.cod-esp
                                                       + ", cliente "      + string(bf-contr-titulo-exp.cod-emitente)
                                                       + ", docto "        + bf-contr-titulo-exp.nr-docto
                                                       + " / "             + bf-contr-titulo-exp.parcela
                                                       + " no Contrato: "  + bf-contr-titulo-exp.nr-contrato
                                                       + ", dt contrato "  + string(bf-contr-titulo-exp.dt-contrato)
                                                       + " refer "         + bf-contr-titulo-exp.referencia
                                                       + ", dt refer "     + string(bf-contr-titulo-exp.dt-referencia)
                                                       + ", pelo usuario " + v_cod_usuar_corren
                                                       + ", em "           + string(bf-contr-titulo-exp.dt-vinculado).
            
            
                               /*** AVA ***/
                                run prgfin/apl/apl708zs.py (1,
                                                            input bfcontrato-exp.num-id-operac-financ,
                                                            input tt_operac_financ_cambio_1.tta_cod_banco,
                                                            input tt_operac_financ_cambio_1.tta_cod_produt_financ,
                                                            input tt_operac_financ_cambio_1.tta_cod_operac_financ,
                                                            input "",
                                                            input "",
                                                            input ?,
                                                            input 0,
                                                            input 0,
                                                            input 0,
                                                            input 0,
                                                            input de-saldo-operac-financ,
                                                            input de-saldo-princ-operac-financ,
                                                            input string( bf-contr-titulo-exp.num-id-operac-financ  ) , 
                                                            input "",
                                                            input "",
                                                            input "",
                                                            input "",
                                                            input table tt_rateio_valores,
                                                            input bf-contr-titulo-exp.dt-vinculado,
                                                            output table tt_log_erro,
                                                            output p_num_id_movto_acerto_sdo,
                                                            output p_num_id_movto_acerto_sdo_princ,
                                                            input 'MEC',
                                                            input c-historico).
            
                                if v_log_calcula_juros_comptcia then do:
    
                                    for each tt_operac_financ_cambio_1:
                                        delete tt_operac_financ_cambio_1.
                                    end.    
            
                                    RUN prgfin/apl/apl768zd.py PERSISTENT SET h-apl768zd.
                                    RUN pi_main_code_retorna_tt_operac_financ_1 in h-apl768zd (INPUT 1,
                                                                                               INPUT bf-contr-titulo-exp.num-id-operac-financ,
                                                                                               OUTPUT TABLE tt_operac_financ_cambio_1).
                                    DELETE PROCEDURE h-apl768zd.
            
                                    find first tt_operac_financ_cambio_1 no-lock no-error.
                                    
                                    if tt_operac_financ_cambio_1.tta_val_sdo_princ_operac_financ = 0 and 
                                        tt_operac_financ_cambio_1.tta_val_sdo_operac_financ       > 0 then do:
                                        
                                        /** BUSCA PARAMETROS DO MEC **/
                                        if not valid-handle(h-boad357) then
                                            run adbo/boad357.p persistent set h-boad357.
            
                                        run pi-busca-conta-ajuste in h-boad357 (output p-cta-ajuste
                                                                                &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
                                                                                    ,output c-cod-ccusto-ajust
                                                                                &ENDIF).

                                        &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
                                            if not valid-handle(h-boad049) then
                                                run adbo/boad049o.p persistent set h-boad049.
                                        &ENDIF
                                            
                                        assign v_cod_empres_usuar = v_cod_empres_usuar_aux.
        
                                        &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
                                        
                                            assign p-ct-codigo = p-cta-ajuste
                                                   p-sc-codigo = c-cod-ccusto-ajust.

                                        &ELSE    
                                            run pi-busca-conta-contab in h-boad049 (input  p-cta-ajuste,
                                                                                    output p-ct-codigo,
                                                                                    output p-sc-codigo).
                                        &ENDIF
            
                                        /* TRADUÄ«O EMS5 */
                                        {ecp/ec0006c.i1 p-ct-codigo p-sc-codigo}
            
                                        for each tt_rateio_valores:
                                            delete tt_rateio_valores.
                                        end.
            
                                        create tt_rateio_valores.
                                        assign tt_rateio_valores.tta_cod_plano_cta_ctbl = p_cod_plano_cta_ctbl
                                               tt_rateio_valores.tta_cod_cta_ctbl       = p_cod_cta_ctbl
                                               tt_rateio_valores.ttv_val_rat_aprop_ctbl = absolute(tt_operac_financ_cambio_1.tta_val_sdo_operac_financ).
            
            
                                        IF  l-hist-ava then
                                            ASSIGN c-historico = "Ajuste Juros: "  
                                                               + " "  + "no contrato" + " " + bfcontrato-exp.nr-contrato
                                                               + ", " + "data contrato" + " " + string(bfcontrato-exp.dt-contrato)
                                                               + ", " + "usuario" + " " + v_cod_usuar_corren
                                                               + ", " + "data vinculacao" + " " + string(bf-contr-titulo-exp.dt-vinculado).     
            
                                        /** ACERTO DE VALOR PARA ACERTAR OS JUROS ACE **/ 
                                        run prgfin/apl/apl708zs.py (input 1, 
                                                                    input bfcontrato-exp.num-id-operac-financ,
                                                                    input "",
                                                                    input "",
                                                                    input "",
                                                                    input "",
                                                                    input "",
                                                                    input ?,
                                                                    input 0,
                                                                    input 0,
                                                                    input 0,
                                                                    input 0,
                                                                    input 0,
                                                                    input 0,
                                                                    input "",
                                                                    input "",
                                                                    input "",
                                                                    input "",
                                                                    input "",
                                                                    input table tt_rateio_valores,
                                                                    input bf-contr-titulo-exp.dt-vinculado,
                                                                    output table tt_log_erro,
                                                                    output p_num_id_movto_acerto_sdo ,
                                                                    output p_num_id_movto_acerto_sdo_princ,
                                                                    input 'APL',
                                                                    input c-historico).
            
                                        IF  VALID-HANDLE(h-boad357) THEN
                                            delete procedure h-boad357.
                                        IF  VALID-HANDLE(h-boad049) THEN
                                            delete procedure h-boad049.
    
                                        ASSIGN v_cod_empres_usuar = v_cod_empres_usuar_aux.
                                    end.
                                END. 
            
                                /* Alterar para data de vinculaÁ„o e n„o "today"  */
                                assign v_cod_empres_usuar = c-empresa.
            
                                find first tt_log_erro where tt_log_erro.ttv_num_cod_erro > 0 no-lock no-error.
                                if not avail tt_log_erro then do:
                                   
                                    IF bfcontrato-exp.tp-contrato-exp = 3 THEN DO:
                                       
                                        run adbo/boad350.p persistent set h-boad350.
                                        run pi-cria-emprestimo-efetivo in h-boad350 (input bfcontrato-exp.ep-codigo,
                                                                                     input bfcontrato-exp.cod-banco-ems5,
                                                                                     input bfcontrato-exp.cod-estabel,
                                                                                     input bfcontrato-exp.dt-contrato,
                                                                                     input bfcontrato-exp.dt-referencia,
                                                                                     input today,
                                                                                     input bfcontrato-exp.nr-contrato,
                                                                                     input bfcontrato-exp.num-id-operac-financ,
                                                                                     input bfcontrato-exp.operac-financ,
                                                                                     input bfcontrato-exp.prod-financ,
                                                                                     input bfcontrato-exp.referencia,
                                                                                     input bf-contr-titulo-exp.cod-banco-ems5,
                                                                                     input bf-contr-titulo-exp.num-id-operac-financ,
                                                                                     input bf-contr-titulo-exp.operac-financ,
                                                                                     input bf-contr-titulo-exp.prod-financ,
                                                                                     input p_num_id_movto_acerto_sdo,
                                                                                     input 13,
                                                                                     input NO,
                                                                                     input bf-contr-titulo-exp.vl-vinculado-me,
                                                                                     input 0).
                                        delete procedure h-boad350.
                                    END.
                                    if return-value = "NOK":U then do:
                                       
                                        assign l-atualiza = no.
    
                                        run adbo/boad350.p persistent set h-boad350.
    
                                        RUN getRowErrors IN h-boad350 (OUTPUT TABLE RowErrors).
            
                                        {method/showmessage.i1}
                                        {method/showmessage.i2}
                                        
                                        /*** Desconecta bases do EMS 5.0 ***/
    /*                                     RUN pi-conecta-ems5(INPUT 2). */
    
    
                                        DELETE PROCEDURE h-boad350.
                                        
                                        undo block, leave block.
                                    end.
                                end.
                                else do:
                                   
                                    assign l-atualiza = no
                                          i-seq-erro = 0.
            
                                    for each tt_log_erro:
                                        assign i-seq-erro = i-seq-erro + 10.
                                        create RowErrors.
                                        assign RowErrors.ErrorSequence    = i-seq-erro
                                            RowErrors.ErrorNumber      = tt_log_erro.ttv_num_cod_erro
                                            RowErrors.ErrorParameters  = ""
                                            RowErrors.ErrorType        = ""
                                            RowErrors.ErrorSubType     = "ERROR"
                                            RowErrors.ErrorDescription = tt_log_erro.ttv_des_msg_erro
                                            RowErrors.ErrorHelp        = tt_log_erro.ttv_des_msg_ajuda.
                                    end.
                                    
                                    {method/showmessage.i1}
                                    {method/showmessage.i2}
                                       
                                    /*** Desconecta bases do EMS 5.0 ***/
    /*                                 RUN pi-conecta-ems5(INPUT 2). */
                                   
                                    undo block, leave block.
                                end.
                             end.
                             else do:
                                
                                 assign l-atualiza = no
                                        i-seq-erro = 0.
            
                                 for each tt_log_erro.
                                     assign i-seq-erro = i-seq-erro + 10.
                                     create RowErrors.
                                     assign RowErrors.ErrorSequence    = i-seq-erro
                                           RowErrors.ErrorNumber      = tt_log_erro.ttv_num_cod_erro
                                           RowErrors.ErrorParameters  = ""
                                           RowErrors.ErrorType        = ""
                                           RowErrors.ErrorSubType     = "ERROR"
                                           RowErrors.ErrorDescription = tt_log_erro.ttv_des_msg_erro
                                           RowErrors.ErrorHelp        = tt_log_erro.ttv_des_msg_ajuda.
                                 end.
            
                                 {method/showmessage.i1}
                                 {method/showmessage.i2}
                                 
                                 /*** Desconecta bases do EMS 5.0 ***/
    /*                              RUN pi-conecta-ems5(INPUT 2). */
    
                                 undo block, leave block.       
                             end.
                          END.
                      end.
                        
                      if l-atualiza = yes then do:
                          &IF "{&mguni_version}" <= "2.06B" &THEN
                          assign v_cod_usuar_corren = v_cod_usuar_corren_old 
                                 v_cod_empres_usuar = v_cod_empres_usuar_old.
                          &ENDIF
    
                          RUN adbo/boad347.p PERSISTENT SET h-boad347.
                          run pi-atualiza-situacao in h-boad347 (input bf-contr-titulo-exp.ep-codigo,
                                                                   input bf-contr-titulo-exp.cod-estabel,
                                                                   input bf-contr-titulo-exp.referencia,
                                                                   input bf-contr-titulo-exp.dt-referencia,
                                                                   input bf-contr-titulo-exp.cod-emitente,
                                                                   input bf-contr-titulo-exp.cod-esp,
                                                                   input bf-contr-titulo-exp.serie,
                                                                   input bf-contr-titulo-exp.nr-docto,
                                                                   input bf-contr-titulo-exp.parcela,
                                                                   input bf-contr-titulo-exp.dt-vinculado,
                                                                   input 1).
                
                          run pi-atualiza-fluxo IN h-boad347 (input bf-contr-titulo-exp.ep-codigo,
                                                                input bf-contr-titulo-exp.cod-estabel,
                                                                input bf-contr-titulo-exp.referencia,
                                                                input bf-contr-titulo-exp.dt-referencia,
                                                                input bf-contr-titulo-exp.cod-emitente,
                                                                input bf-contr-titulo-exp.cod-esp,
                                                                input bf-contr-titulo-exp.serie,
                                                                input bf-contr-titulo-exp.nr-docto,
                                                                input bf-contr-titulo-exp.parcela,
                                                                input bf-contr-titulo-exp.dt-vinculado,
                                                                input no).
            
                          DELETE PROCEDURE h-boad347.
                      end.
                END.
            end.
            END.
        END.
    END.
    /*** Desconecta bases do EMS 5.0 ***/
/*     RUN pi-conecta-ems5(INPUT 2).  */
    ASSIGN l-status = "OK".
    
END. /* Bloco */

/*** Desconecta bases do EMS 5.0 ***/
/* RUN pi-conecta-ems5(INPUT 2). */

&IF "{&mguni_version}" <= "2.06B" &THEN
assign v_cod_usuar_corren = v_cod_usuar_corren_old 
       v_cod_empres_usuar = v_cod_empres_usuar_old.
&ENDIF

RETURN l-status.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-eliminar-docto-exp DBOProgram 
PROCEDURE pi-eliminar-docto-exp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     
    DEF INPUT PARAM p-ep-codigo       LIKE crta-remessa-docto-exp.ep-codigo.
    DEF INPUT PARAM p-cod-estabel     LIKE crta-remessa-docto-exp.cod-estabel.
    DEF INPUT PARAM p-nr-crta-remessa LIKE crta-remessa-docto-exp.nr-crta-remessa.    
    DEF INPUT PARAM p-documento       LIKE crta-remessa-docto-exp.documento.


   FOR EACH crta-remessa-docto-pend-exp
        WHERE crta-remessa-docto-pend-exp.ep-codigo          = p-ep-codigo
          AND crta-remessa-docto-pend-exp.cod-estabel        = p-cod-estabel 
          AND crta-remessa-docto-pend-exp.nr-crta-remessa    = p-nr-crta-remessa
          AND crta-remessa-docto-pend-exp.documento          = p-documento
          AND crta-remessa-docto-pend-exp.ind-tipo-documento = 13 exclusive-LOCK:
        DELETE crta-remessa-docto-pend-exp.
    END.

    FOR EACH crta-remessa-docto-exp
        WHERE crta-remessa-docto-exp.ep-codigo          = p-ep-codigo    
          AND crta-remessa-docto-exp.cod-estabel        = p-cod-estabel   
          AND crta-remessa-docto-exp.nr-crta-remessa    = p-nr-crta-remessa
          AND crta-remessa-docto-exp.documento          = p-documento
          AND crta-remessa-docto-exp.ind-tipo-documento = 13 exclusive-LOCK:
        DELETE crta-remessa-docto-exp.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gravar-docto-exp DBOProgram 
PROCEDURE pi-gravar-docto-exp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR v-sequencia AS INT NO-UNDO.
  DEF INPUT PARAM p-documento LIKE crta-remessa-docto-exp.documento NO-UNDO.
  DEF INPUT PARAM p-nr-crta-remessa LIKE crta-remessa-exp.nr-crta-remessa NO-UNDO.

  FOR EACH crta-remessa-docto-pend-exp
      WHERE crta-remessa-docto-pend-exp.documento = p-documento
        AND crta-remessa-docto-pend-exp.nr-crta-remessa = p-nr-crta-remessa
        AND crta-remessa-docto-pend-exp.ind-tipo-documento = 13 NO-LOCK:
      FIND FIRST crta-remessa-docto-exp
          WHERE crta-remessa-docto-exp.ep-codigo = crta-remessa-docto-pend-exp.ep-codigo
            AND crta-remessa-docto-exp.cod-estabel = crta-remessa-docto-pend-exp.cod-estabel
            AND crta-remessa-docto-exp.serie       = crta-remessa-docto-pend-exp.serie 
            AND crta-remessa-docto-exp.cod-esp     = crta-remessa-docto-pend-exp.cod-esp
            AND crta-remessa-docto-exp.nr-docto    = crta-remessa-docto-pend-exp.nr-docto
            AND crta-remessa-docto-exp.parcela     = crta-remessa-docto-pend-exp.parcela NO-LOCK NO-ERROR.
      IF NOT AVAIL crta-remessa-docto-exp THEN DO:
          FIND LAST crta-remessa-docto-exp
              WHERE crta-remessa-docto-exp.ep-codigo = crta-remessa-docto-pend-exp.ep-codigo
                AND crta-remessa-docto-exp.cod-estabel = crta-remessa-docto-pend-exp.cod-estabel
                AND crta-remessa-docto-exp.nr-crta-remessa = p-nr-crta-remessa NO-LOCK NO-ERROR.
          IF AVAIL crta-remessa-docto-exp THEN
              ASSIGN v-sequencia = crta-remessa-docto-exp.sequencia + 1.
          ELSE
              ASSIGN v-sequencia = 1.
          CREATE crta-remessa-docto-exp.
          ASSIGN crta-remessa-docto-exp.ep-codigo   = crta-remessa-docto-pend-exp.ep-codigo
                 crta-remessa-docto-exp.cod-estabel = crta-remessa-docto-pend-exp.cod-estabel
                 crta-remessa-docto-exp.nr-crta-remessa = p-nr-crta-remessa
                 crta-remessa-docto-exp.documento = crta-remessa-docto-pend-exp.nr-docto
                 crta-remessa-docto-exp.ind-tipo-documento = crta-remessa-docto-pend-exp.ind-tipo-documento
                 crta-remessa-docto-exp.serie = crta-remessa-docto-pend-exp.serie
                 crta-remessa-docto-exp.cod-esp = crta-remessa-docto-pend-exp.cod-esp
                 crta-remessa-docto-exp.nr-docto = crta-remessa-docto-pend-exp.nr-docto
                 crta-remessa-docto-exp.parcela = crta-remessa-docto-pend-exp.parcela
                 crta-remessa-docto-exp.cod-emitente = crta-remessa-docto-pend-exp.cod-emitente
                 crta-remessa-docto-exp.usuario = crta-remessa-docto-pend-exp.usuario
                 crta-remessa-docto-exp.estab-titulo = crta-remessa-docto-pend-exp.estab-titulo
                 crta-remessa-docto-exp.sequencia = v-sequencia.
      END.
  END.
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-tit-selec DBOProgram 
PROCEDURE pi-trata-tit-selec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        
    DEF INPUT PARAM TABLE FOR tt-crta-remessa-titulo.
    DEF INPUT PARAM selec-r-rowid AS ROWID NO-UNDO. 

    DEFINE BUFFER bftt-titulos-selecionados for tt-titulos-selecionados.

    /*conta reg tb tt-titulos-selecionados*/
    DEF VAR i-conta     AS INT  INITIAL 0       NO-UNDO.

    def var l-existe                    as logical no-undo.
    def var p-val-comis                 as decimal no-undo.
    def var p-situacao                  as integer no-undo.
    def var v-pagar                     as CHAR    no-undo.
    def var v-receber                   as CHAR    no-undo.
    def var vl-titulos                  as decimal no-undo.    
    def var vl-disponivel               as decimal no-undo.
    DEF VAR v-moeda                     LIKE contrato-exp.moeda.
    def var i-seq-erro                  as integer.
    DEFINE VARIABLE i-total-vincul AS INTEGER    NO-UNDO.


   
    /*Verifica se reg selc em browser Ç o mesmo gravado na tabela */
    FOR EACH tt-titulos-selecionados NO-LOCK
        BREAK BY tt-titulos-selecionados.nr-contrato
              BY tt-titulos-selecionados.nr-docto:

        /* Soma t°tulos*/
        IF FIRST-OF (tt-titulos-selecionados.nr-contrato) THEN DO:
            IF FIRST-OF (tt-titulos-selecionados.nr-docto) THEN DO:
                ASSIGN vl-titulos    =   0.
                RUN adbo/boad347.p PERSISTENT SET h-boad347.
                FOR EACH bftt-titulos-selecionados NO-LOCK
                    WHERE bftt-titulos-selecionados.nr-contrato =   tt-titulos-selecionados.nr-contrato    
                    AND   bftt-titulos-selecionados.dt-contrato =   tt-titulos-selecionados.dt-contrato:
                    
                    ASSIGN i-total-vincul    =   i-total-vincul   +   bftt-titulos-selecionados.de-vl-vinculado.   
                    
                END.
                DELETE PROCEDURE h-boad347.
            END.
        END.

        ASSIGN i-conta      =   i-conta + 1
               i-seq-erro   = 0
               l-existe     = no
               p-val-comis  = 0.
    
            RUN adbo/boad347.p PERSISTENT SET h-boad347.
            run pi-busca-saldo-orig in h-boad347 (   input  tt-titulos-selecionados.ep-codigo,
                                                     input  tt-titulos-selecionados.cod-estabel,                         
                                                     input  tt-titulos-selecionados.cod-emitente,
                                                     input  tt-titulos-selecionados.cod-esp,     
                                                     input  tt-titulos-selecionados.serie,      
                                                     input  tt-titulos-selecionados.nr-docto,    
                                                     input  tt-titulos-selecionados.parcela,    
                                                     output tt-titulos-selecionados.moeda,                                           
                                                     output tt-titulos-selecionados.dt-vencimen,                                     
                                                     output tt-titulos-selecionados.vl-saldo-me,                                     
                                                     output tt-titulos-selecionados.nr-proc-exp,                                     
                                                     output p-situacao,
                                                     output p-val-comis).
    
            if return-value = "OK":U then
                assign l-existe = yes.
            else
                assign l-existe = no.
            
            def var h-boad355 as handle no-undo.
            RUN adbo/boad355.p PERSISTENT SET h-boad355.
            run pi-verificar-produto in h-boad355 (output v-pagar,
                                                   output v-receber).
            delete procedure h-boad355.
    
            run pi-valida-titulos in h-boad347 (input  tt-titulos-selecionados.ep-codigo,
                                                INPUT  tt-titulos-selecionados.cod-estabel,
                                                input  tt-titulos-selecionados.cod-emitente,
                                                input  tt-titulos-selecionados.cod-esp,
                                                input  tt-titulos-selecionados.serie,
                                                input  tt-titulos-selecionados.nr-docto,
                                                input  tt-titulos-selecionados.parcela,
                                                OUTPUT tt-titulos-selecionados.moeda,
                                                output TABLE tt_log_erro).
            DELETE procedure h-boad347.
            
            FOR EACH tt_log_erro NO-LOCK:
                assign i-seq-erro = i-seq-erro + 10.
                create RowErrors.
                assign RowErrors.ErrorSequence    = i-seq-erro
                       RowErrors.ErrorNumber      = tt_log_erro.ttv_num_cod_erro
                       RowErrors.ErrorParameters  = ""
                       RowErrors.ErrorType        = ""
                       RowErrors.ErrorSubType     = "ERROR"
                       RowErrors.ErrorDescription = tt_log_erro.ttv_des_msg_erro
                       RowErrors.ErrorHelp        = tt_log_erro.ttv_des_msg_ajuda.
            END.
        
            IF  tt-titulos-selecionados.moeda <> tt-contrato-exp.moeda
                AND NOT l-funcao-arbitragem THEN DO:
                run utp/ut-msgs.p (input "msg",input 26181, input "").
                  assign i-seq-erro = i-seq-erro + 10.
                  create RowErrors.
                  assign RowErrors.ErrorSequence    = i-seq-erro
                         RowErrors.ErrorNumber      = 26181
                         RowErrors.ErrorParameters  = ""
                         RowErrors.ErrorType        = ""
                         RowErrors.ErrorSubType     = "ERROR"
                         RowErrors.ErrorDescription = return-value.
            END.
            /*16062005*/
            IF  tt-titulos-selecionados.dt-contrato > tt-titulos-selecionados.dt-vinculado THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-do-contrato-de-cam AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "do_Contrato_de_Cambio" *}
                ASSIGN c-lbl-liter-do-contrato-de-cam = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-da-vinculacao AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "da_vinculacao" *}
                ASSIGN c-lbl-liter-da-vinculacao = TRIM(RETURN-VALUE).
                run utp/ut-msgs.p (input "msg",input 29566, input  c-lbl-liter-do-contrato-de-cam  + "~~" +
                                                                   c-lbl-liter-da-vinculacao ).
                  assign i-seq-erro = i-seq-erro + 10.
                  create RowErrors.
                  /* Inicio -- Projeto Internacional */
                  DEFINE VARIABLE c-lbl-liter AS CHARACTER NO-UNDO.
                  ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
                  DEFINE VARIABLE c-lbl-liter-do-contrato-de-cam-2 AS CHARACTER NO-UNDO.
                  {utp/ut-liter.i "do_Contrato_de_Cambio" *}
                  ASSIGN c-lbl-liter-do-contrato-de-cam-2 = TRIM(RETURN-VALUE).
                  DEFINE VARIABLE c-lbl-liter-da-vinculacao-2 AS CHARACTER NO-UNDO.
                  {utp/ut-liter.i "da_vinculacao" *}
                  ASSIGN c-lbl-liter-da-vinculacao-2 = TRIM(RETURN-VALUE).
                  assign RowErrors.ErrorSequence    = i-seq-erro
                         RowErrors.ErrorNumber      = 29566
                         RowErrors.ErrorParameters  = c-lbl-liter-do-contrato-de-cam-2  + "~~" +
                                                      c-lbl-liter-da-vinculacao-2
                         RowErrors.ErrorType        = ""
                         RowErrors.ErrorSubType     = "ERROR"
                         RowErrors.ErrorDescription = c-lbl-liter.
            END.
    
            
            /*if pcAction = "ADD":U then do:  */
            if (tt-titulos-selecionados.nr-proc-exp = ""  and 
               l-existe      = yes  AND
               NOT l-funcao-arbitragem) OR
              (tt-titulos-selecionados.nr-proc-exp = ""  AND
               l-existe = YES      AND
               p-situacao  <> 2    and
               l-funcao-arbitragem) then do:
              run utp/ut-msgs.p (input "msg",input 26109, input "").
              assign i-seq-erro = i-seq-erro + 10.
              create RowErrors.
              assign RowErrors.ErrorSequence    = i-seq-erro
                     RowErrors.ErrorNumber      = 26109
                     RowErrors.ErrorParameters  = ""
                     RowErrors.ErrorType        = ""
                     RowErrors.ErrorSubType     = "ERROR"
                     RowErrors.ErrorDescription = return-value.
            end.   
            /*end.*/
            if l-existe = no then do:
               run utp/ut-msgs.p (input "msg",input 25261, input "").
               assign i-seq-erro = i-seq-erro + 10.
               create RowErrors.
               assign RowErrors.ErrorSequence    = i-seq-erro
                          RowErrors.ErrorNumber      = 25261
                          RowErrors.ErrorParameters  = ""
                          RowErrors.ErrorType        = ""
                          RowErrors.ErrorSubType     = "ERROR"
                          RowErrors.ErrorDescription = return-value.
            end.
                
            if l-existe = yes then do:
            
                IF  l-funcao-arbitragem THEN DO:
                    IF  tt-titulos-selecionados.vl-paridade = 0 THEN DO:
                        assign i-seq-erro = i-seq-erro + 10.
                        run utp/ut-msgs.p (input "MSG",
                                           input 19613,
                                           input "").
                        create RowErrors.
                        assign RowErrors.ErrorSequence    = 10
                               RowErrors.ErrorNumber      = 19613
                               RowErrors.ErrorParameters  = ""
                               RowErrors.ErrorType        = ""
                               RowErrors.ErrorSubType     = "ERROR"
                               RowErrors.ErrorDescription = return-value.
                    END.
                END.
            
                if p-situacao = 2  /* Cliente nao extrangeiro */
                    AND NOT l-funcao-arbitragem THEN DO:
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-liter.i "Cliente" *}
                    run utp/ut-msgs.p (input "msg",input 26098, input RETURN-VALUE).
                    assign i-seq-erro = i-seq-erro + 10.
                    create RowErrors.
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-2 AS CHARACTER NO-UNDO.
                    ASSIGN c-lbl-liter-2 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-cliente AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Cliente" *}
                    ASSIGN c-lbl-liter-cliente = TRIM(RETURN-VALUE).
                    assign RowErrors.ErrorSequence    = i-seq-erro
                           RowErrors.ErrorNumber      = 26098
                           RowErrors.ErrorParameters  = c-lbl-liter-cliente
                           RowErrors.ErrorType        = ""
                           RowErrors.ErrorSubType     = "ERROR"
                           RowErrors.ErrorDescription = c-lbl-liter-2.
                end.
        
                if p-situacao = 1
                    OR (p-situacao <> 1 
                    AND l-funcao-arbitragem) then do: /* Disponivel para o cambio */
                    
                    if tt-titulos-selecionados.moeda  = 0 then do:
                        assign i-seq-erro = i-seq-erro + 10.
                        run utp/ut-msgs.p (input "MSG",
                                           input 26127,
                                           input "").
                        create RowErrors.
                        assign RowErrors.ErrorSequence    = 10
                               RowErrors.ErrorNumber      = 26127
                               RowErrors.ErrorParameters  = ""
                               RowErrors.ErrorType        = ""
                               RowErrors.ErrorSubType     = "ERROR"
                               RowErrors.ErrorDescription = return-value.
                    end.
                END.
                
                if tt-titulos-selecionados.moeda  <> tt-contrato-exp.moeda 
                    AND NOT l-funcao-arbitragem then do:
                    assign i-seq-erro = i-seq-erro + 10.
                    run utp/ut-msgs.p (input "MSG",
                                       input 26251,
                                       input "").
                    create RowErrors.
                    assign RowErrors.ErrorSequence    = 10
                           RowErrors.ErrorNumber      = 26251
                           RowErrors.ErrorParameters  = ""
                           RowErrors.ErrorType        = ""
                           RowErrors.ErrorSubType     = "ERROR"
                           RowErrors.ErrorDescription = return-value.
                end.
                
                if tt-titulos-selecionados.de-vl-vinculado > tt-titulos-selecionados.vl-saldo-me then do:
                    assign i-seq-erro = i-seq-erro + 10.
                    run utp/ut-msgs.p (input "MSG",
                                       input 25134,
                                       input "").
                    create RowErrors.
                    assign RowErrors.ErrorSequence    = 10
                           RowErrors.ErrorNumber      = 25134
                           RowErrors.ErrorParameters  = ""
                           RowErrors.ErrorType        = ""
                           RowErrors.ErrorSubType     = "ERROR"
                           RowErrors.ErrorDescription = return-value.
                end.
    
                IF  v-receber = 'EMS 5' THEN DO:
                    IF  p-val-comis > 0 then do:
                        run utp/ut-msgs.p (input "msg", input 27950, input string(tt-titulos-selecionados.nr-docto)      + "~~" +
                                                                            string(tt-titulos-selecionados.parcela)       + "~~" +
                                                                            STRING(tt-titulos-selecionados.ep-codigo)     + "~~" +
                                                                            string(tt-titulos-selecionados.cod-estabel)   + "~~" +
                                                                            string(tt-titulos-selecionados.cod-esp)       + "~~" +
                                                                            string(tt-titulos-selecionados.serie)).
                        
                        assign i-seq-erro = i-seq-erro + 10.
                        create RowErrors.
                        assign RowErrors.ErrorSequence    = i-seq-erro
                               RowErrors.ErrorNumber      = 27950
                               RowErrors.ErrorParameters  = string(tt-titulos-selecionados.nr-docto)      + "~~" +
                                                            string(tt-titulos-selecionados.parcela)       + "~~" +
                                                            STRING(tt-titulos-selecionados.ep-codigo)     + "~~" +
                                                            string(tt-titulos-selecionados.cod-estabel)   + "~~" +
                                                            string(tt-titulos-selecionados.cod-esp)       + "~~" +
                                                            string(tt-titulos-selecionados.serie)
                               RowErrors.ErrorType        = ""
                               RowErrors.ErrorSubType     = "ERROR"
                               RowErrors.ErrorDescription = return-value.
                    end.
                    
                    IF  p-val-comis > (tt-titulos-selecionados.vl-saldo-me - tt-titulos-selecionados.de-vl-vinculado) THEN DO:
                        run utp/ut-msgs.p (input "msg",input 27995, input   string(tt-titulos-selecionados.vl-saldo-me)                  + "~~" +
                                                                                    string(p-val-comis)                    + "~~" +
                                                                                    string(tt-titulos-selecionados.vl-saldo-me - p-val-comis)    + "~~" +
                                                                                    string(tt-titulos-selecionados.nr-docto)                     + "~~" +
                                                                                    string(tt-titulos-selecionados.parcela)                      + "~~" +
                                                                                    STRING(tt-titulos-selecionados.ep-codigo)                    + "~~" +
                                                                                    string(tt-titulos-selecionados.cod-estabel)                  + "~~" +
                                                                                    string(tt-titulos-selecionados.cod-esp)                      + "~~" +
                                                                                    string(tt-titulos-selecionados.serie)
                                                                                    ).
                        assign i-seq-erro = i-seq-erro + 10.
                        create RowErrors.
                        assign RowErrors.ErrorSequence    = i-seq-erro
                               RowErrors.ErrorNumber      = 27995
                               RowErrors.ErrorParameters  = string(tt-titulos-selecionados.vl-saldo-me)   + "~~" +
                                                            string(p-val-comis)     + "~~" +
                                                            string(tt-titulos-selecionados.vl-saldo-me - p-val-comis)
                               RowErrors.ErrorType        = ""
                               RowErrors.ErrorSubType     = "ERROR"
                               RowErrors.ErrorDescription = return-value.
                    END.
                END.
                assign vl-titulos = 0.
                    
                /*soma titulos*/
/*                 RUN adbo/boad347.p PERSISTENT SET h-boad347.                                     */
/*                 run pi-soma-titulos-contrato in h-boad347 (input tt-contrato-exp.ep-codigo,      */
/*                                                               input tt-contrato-exp.cod-estabel, */
/*                                                               input tt-contrato-exp.nr-contrato, */
/*                                                               input tt-contrato-exp.dt-contrato, */
/*                                                               output vl-titulos).                */
/*                                                                                                  */
/*                 DELETE PROCEDURE h-boad347.                                                      */
    
                assign vl-disponivel = tt-contrato-exp.vl-contrato-me - vl-titulos.
                
                if tt-contrato-exp.situacao                <> 1 and
                   i-total-vincul  > vl-disponivel then do:
                    assign i-seq-erro = i-seq-erro + 10.
                    run utp/ut-msgs.p (input "MSG",
                                               input 25147,
                                               input "").
                    create RowErrors.
                    assign RowErrors.ErrorSequence    = 10
                           RowErrors.ErrorNumber      = 25147
                           RowErrors.ErrorParameters  = ""
                           RowErrors.ErrorType        = ""
                           RowErrors.ErrorSubType     = "ERROR"
                           RowErrors.ErrorDescription = return-value.
                    
                    if i-total-vincul   = 0   and
                       tt-titulos-selecionados.vl-saldo-me     <> 0   and 
                       l-existe                         = yes then do:
                        assign i-seq-erro = i-seq-erro + 10.
                        run utp/ut-msgs.p (input "MSG",
                                           input 19613,
                                           input "").
                        create RowErrors.
                        assign RowErrors.ErrorSequence    = 10
                               RowErrors.ErrorNumber      = 19613
                               RowErrors.ErrorParameters  = ""
                               RowErrors.ErrorType        = ""
                               RowErrors.ErrorSubType     = "ERROR"
                               RowErrors.ErrorDescription = return-value.
                    end.
            
                    if i-total-vincul    = 0   and 
                       tt-titulos-selecionados.vl-saldo-me     = 0   and 
                       l-existe             = yes then do:
                        assign i-seq-erro = i-seq-erro + 10.
                        run utp/ut-msgs.p (input "MSG",
                                           input 26133,
                                           input "").
                        create RowErrors.
                        assign RowErrors.ErrorSequence    = 10
                               RowErrors.ErrorNumber      = 26133
                               RowErrors.ErrorParameters  = ""
                               RowErrors.ErrorType        = ""
                               RowErrors.ErrorSubType     = "ERROR"
                               RowErrors.ErrorDescription = return-value.
                    end.
                end.
            end. 
                            
            if i-seq-erro <> 0 then do:
                {method/showmessage.i1} 
                {method/showmessage.i2}  
        
                RETURN "NOK":U.   
            end.
        
    END.

    ASSIGN l-vincul-carta   =   YES.
    RUN adbo/boad347.p PERSISTENT SET h-boad347.
    run pi-cria-tabela in h-boad347 (input  table tt-titulos-selecionados).
    
    IF RETURN-VALUE = "OK" THEN DO:
        DELETE PROCEDURE h-boad347.
        RUN pi-efetiva-vinculo IN THIS-PROCEDURE.

        IF RETURN-VALUE = "NOK":U THEN
            RETURN RETURN-VALUE.   
    END.
    ELSE DO:
        run GetRowErrors   in h-boad347 (output table RowErrors).
        DELETE PROCEDURE h-boad347.

        FOR EACH RowErrors NO-LOCK:
            
            {method/showmessage.i1} 
            {method/showmessage.i2}  
                
            RETURN "NOK":U.   
        END.
    END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-contrato DBOProgram 
PROCEDURE pi-verifica-contrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF "{&mguni_version}" >= "2.07A" &THEN
    def input  param p-ep-codigo       LIKE empresa.ep-codigo       no-undo.
&ELSE
    def input  param p-ep-codigo       as int       no-undo.
&ENDIF
    def input  param p-cod-estabel     as char      no-undo.
    def input  param p-nr-crta-remessa as char      no-undo.
    DEF OUTPUT PARAM p-conta-cambio    AS INT       NO-UNDO.
    DEF OUTPUT PARAM v-tp-emprestimo   AS LOGICAL  INITIAL NO NO-UNDO.
&IF "{&mguni_version}" >= "2.07A" &THEN
    DEF OUTPUT PARAM v-ep-codigo       LIKE empresa.ep-codigo       no-undo.
&ELSE
    DEF OUTPUT PARAM v-ep-codigo       as int       no-undo.
&ENDIF

    DEF VAR i-conta-titulo AS INT INITIAL 0 NO-UNDO. /* conta numero de vzs que um tit aparece em tab pendentes*/
    
    ASSIGN i-conta-cambio    =   0.

    /*: verifica numero de quantidade de contratos de cambio*/
    for each bfcrta-remessa-docto-exp where 
             bfcrta-remessa-docto-exp.ep-codigo          = p-ep-codigo       and
             bfcrta-remessa-docto-exp.cod-estabel        = p-cod-estabel     and
             bfcrta-remessa-docto-exp.nr-crta-remessa    = p-nr-crta-remessa AND
             bfcrta-remessa-docto-exp.ind-tipo-documento = 13
             NO-LOCK:

             ASSIGN i-conta-cambio = i-conta-cambio + 1.

    END.
    
    /* Verifica se h† contratos de cambio*/
    IF i-conta-cambio < 1 THEN DO:
        
        /*RETURN "N∆o h† contratos de cambio".*/
        RETURN "NOK-1":U.
        ASSIGN p-conta-cambio = i-conta-cambio.
               i-conta-cambio = 0.
        LEAVE.

    END.
    ELSE DO:     
        
        /* verifica contratos vinculados a carta remessa*/
        for each bfcrta-remessa-docto-exp where 
             bfcrta-remessa-docto-exp.ep-codigo          = p-ep-codigo       AND
             bfcrta-remessa-docto-exp.cod-estabel        = p-cod-estabel     AND
             bfcrta-remessa-docto-exp.nr-crta-remessa    = p-nr-crta-remessa AND
             bfcrta-remessa-docto-exp.ind-tipo-documento = 13 
             NO-LOCK:
           
            /* busca registro contrato na tab de contratos*/
            FIND FIRST bfcontrato-exp 
                WHERE  bfcontrato-exp.nr-contrato = bfcrta-remessa-docto-exp.documento
                NO-LOCK NO-ERROR.

            /* confirma registro contrato na tab de contratos e faz validaá‰es*/
            IF NOT AVAIL bfcontrato-exp THEN DO: 
                
                /*RETURN "contrato de cambio nao encontrado na tab contratos: " + bfcrta-remessa-docto-exp.documento.*/
                RETURN "NOK-2":U.
                p-conta-cambio   = i-conta-cambio.
                i-conta-cambio   = 0.
                v-ep-codigo      = bfcrta-remessa-docto-exp.ep-codigo.
                v-tp-emprestimo  = NO.
               LEAVE.

            END.
            ELSE DO:
                IF bfcontrato-exp.tp-contrato-exp = 3  THEN
                   ASSIGN   v-tp-emprestimo = YES.
                
                IF (bfcontrato-exp.tp-contrato-exp <> 3 and bfcontrato-exp.tp-contrato-exp  <> 1) or
                   (bfcontrato-exp.tp-contrato-exp = 3  AND bfcontrato-exp.tp-emprestimo = 2)
                   THEN
                   RETURN "NOK-3":U.


            END.
        END.

        IF i-conta-cambio > 1 THEN DO:
            
            FOR EACH  bfcrta-remessa-titulo
                WHERE bfcrta-remessa-titulo.ep-codigo          = p-ep-codigo       AND
                      bfcrta-remessa-titulo.cod-estabel        = p-cod-estabel     AND
                      bfcrta-remessa-titulo.nr-crta-remessa    = p-nr-crta-remessa 
                NO-LOCK:

                ASSIGN i-conta-titulo    =   0.

                FOR EACH  bf-crta-remessa-docto-pend-exp
                    WHERE bf-crta-remessa-docto-pend-exp.ep-codigo          = bfcrta-remessa-titulo.ep-codigo       AND
                          bf-crta-remessa-docto-pend-exp.cod-estabel        = bfcrta-remessa-titulo.cod-estabel     AND
                          bf-crta-remessa-docto-pend-exp.nr-crta-remessa    = bfcrta-remessa-titulo.nr-crta-remessa 
                    NO-LOCK:
                    
                    IF bf-crta-remessa-docto-pend-exp.ind-tipo-documento = 13 THEN
                        ASSIGN i-conta-titulo    =   i-conta-titulo + 1.
                END.

                IF i-conta-titulo > 1 THEN
                
                    /*RETURN "T°tulo relacionado com mais de um contrato.".*/
                    RETURN "NOK-4":U.
                
                ELSE IF i-conta-titulo = 0 THEN

                    /*RETURN "H† um titulo nao selecionado para acarta remessa".*/
                    RETURN "NOK-5":U.
            
            END.
        END.
        ELSE IF i-conta-cambio = 1 THEN DO: 
        
            FIND FIRST bfcrta-remessa-titulo 
                WHERE bfcrta-remessa-titulo.ep-codigo          = p-ep-codigo       AND
                      bfcrta-remessa-titulo.cod-estabel        = p-cod-estabel     AND
                      bfcrta-remessa-titulo.nr-crta-remessa    = p-nr-crta-remessa 
                NO-LOCK NO-ERROR.

            IF NOT AVAIL bfcrta-remessa-titulo THEN 
                RETURN "NOK-6":U.
        
        END.
        ELSE RETURN "NOK-1":U.
    END.
    ASSIGN p-conta-cambio = i-conta-cambio.
           i-conta-cambio = 0.
           v-ep-codigo = p-ep-codigo. /*bf-crta-remessa-docto-pend-exp.ep-codigo.*/
/*            v-tp-emprestimo = yes. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintCrtaRemessa DBOProgram 
PROCEDURE setconstraintCrtaRemessa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo       LIKE crta-remessa-docto-exp.ep-codigo       NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel     LIKE crta-remessa-docto-exp.cod-estabel     NO-UNDO.
    DEFINE INPUT PARAMETER pnr-crta-remessa LIKE crta-remessa-docto-exp.nr-crta-remessa NO-UNDO.
    
    assign i-ep-codigo       = pep-codigo
           c-cod-estabel     = pcod-estabel
           c-nr-crta-remessa = pnr-crta-remessa.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
    
    if ptype = "Create":U then do:
       find first bfcrta-remessa-docto-exp where 
                  bfcrta-remessa-docto-exp.ep-codigo          = RowObject.ep-codigo          and
                  bfcrta-remessa-docto-exp.cod-estabel        = RowObject.cod-estabel        and
                  bfcrta-remessa-docto-exp.nr-crta-remessa    = RowObject.nr-crta-remessa    and
                  bfcrta-remessa-docto-exp.documento          = RowObject.documento          and                     
                  bfcrta-remessa-docto-exp.ind-tipo-documento = RowObject.ind-tipo-documento and
                  bfcrta-remessa-docto-exp.desc-tp-documento  = RowObject.desc-tp-documento
                  no-lock no-error.       
                 
       if avail bfcrta-remessa-docto-exp then do:
          {utp/ut-liter.i "Documento" * }
          {method/svc/errors/inserr.i
                      &ErrorNumber="7"
                      &ErrorType="EMS"
                      &ErrorParameters="return-value"}
       end.
    end.

    if ptype = "Create":U or 
       ptype = "Update":U then do:
       run pi-autenticacao.

&IF "{&mguni_version}" >= "2.07A" &THEN
       if RowObject.ep-codigo = "" then do:
&ELSE
       if RowObject.ep-codigo = 0 then do:
&ENDIF
          {utp/ut-liter.i "C¢digo da empresa n∆o pode ser branco." * }
          {method/svc/errors/inserr.i
                      &ErrorNumber="17567"
                      &ErrorType="EMS"
                      &ErrorParameters="return-value"}
       end.
    
       if RowObject.cod-estabel = "" then do:
          {utp/ut-liter.i "Estabelecimento n∆o pode ser branco." * }
          {method/svc/errors/inserr.i
                      &ErrorNumber="17567"
                      &ErrorType="EMS"
                      &ErrorParameters="return-value"}
       end.
       
       if RowObject.nr-crta-remessa = "" then do:
          {utp/ut-liter.i "N£mero da carta remessa n∆o pode ser branco." * }
          {method/svc/errors/inserr.i
                      &ErrorNumber="17567"
                      &ErrorType="EMS"
                      &ErrorParameters="return-value"}
       end.
       
       if RowObject.documento = "" then do:
          {utp/ut-liter.i "Documento deve ser diferente de branco." * }
          {method/svc/errors/inserr.i
                      &ErrorNumber="17567"
                      &ErrorType="EMS"
                      &ErrorParameters="return-value"}
       end.
       
       if RowObject.dt-emissao = ? then do:
          {utp/ut-liter.i "Data de emiss∆o deve ser diferente de branco." * }
          {method/svc/errors/inserr.i
                      &ErrorNumber="17567"
                      &ErrorType="EMS"
                      &ErrorParameters="return-value"}
       end.
       
       if RowObject.qtde-original = 0 and RowObject.qtde-copia = 0 then do:
          {utp/ut-liter.i "Qtde c¢pia e original n∆o podem ser branco, um dos dois deve ser preenchido." * }
          {method/svc/errors/inserr.i
                      &ErrorNumber="17567"
                      &ErrorType="EMS"
                      &ErrorParameters="return-value"}
       end.
       
       if RowObject.dt-apresentacao < RowObject.dt-emissao then do:
          {utp/ut-liter.i "Data de apresentaá∆o n∆o pode ser menor que data de emiss∆o." * }
          {method/svc/errors/inserr.i
                      &ErrorNumber="17567"
                      &ErrorType="EMS"
                      &ErrorParameters="return-value"}
       end.
    end.
    
    if ptype = "Create":U or
       ptype = "Delete":U or 
       ptype = "Update":U then do:
        find first bf-crta-remessa-exp no-lock
             where bf-crta-remessa-exp.ep-codigo       = RowObject.ep-codigo
             and   bf-crta-remessa-exp.cod-estabel     = RowObject.cod-estabel
             and   bf-crta-remessa-exp.nr-crta-remessa = RowObject.nr-crta-remessa no-error.
             
        if bf-crta-remessa-exp.situacao = 2 then do:
            {method/svc/errors/inserr.i
                       &ErrorNumber="26032"
                       &ErrorType="EMS"
                       &ErrorParameters="''"}
        end.
    end.

    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-conecta-ems5 DBOProgram 
PROCEDURE pi-conecta-ems5 :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM i-op-conecta    AS INT NO-UNDO.    
    /* Luiz */
        {ecp/ec0005b.i i-op-conecta}

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

