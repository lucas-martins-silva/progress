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
{include/i-prgvrs.i BOAD347 2.00.00.094 } /*** "010094" 10/06/2025 09:30:38 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad347 MUT}
&ENDIF

{include/i_fncrowid.i}

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
&GLOBAL-DEFINE DBOName              BOAD347
&GLOBAL-DEFINE DBOVersion           2.00.00.089
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName            contr-titulo-exp
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName            qr{&TableName} 
&GLOBAL-DEFINE NewRecordOffQuery     YES



/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{adbo/boad347.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

{include/i_dbvers.i}
{cdp/cdcfgfin.i}   /* Miniflexibilizacao */
{ecp/ec0003.i2} /* arbitragem*/
{crp/crapi003.i} /* TT p/ Inclus∆o de Antecipacao */

/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

define buffer bfcontrato-exp for contrato-exp.
DEF BUFFER b-contr-titulo-exp FOR contr-titulo-exp.
DEF BUFFER b-emitente         FOR emitente.

def var iRowsReturned as integer no-undo.
def var i_cont_contr  as integer no-undo.
def var i_nr_proc_exp as integer no-undo.
def var h-bocx346     as handle no-undo.

def var i-ep-codigo     like contr-titulo-exp.ep-codigo     no-undo.
def var c-cod-estabel   like contr-titulo-exp.cod-estabel   no-undo.
def var c-referencia    like contr-titulo-exp.referencia    no-undo.
def var d-dt-referencia like contr-titulo-exp.dt-referencia no-undo.
def var i-cod-emitente  like contr-titulo-exp.cod-emitente  no-undo.
def var c-cod-esp       like contr-titulo-exp.cod-esp       no-undo.
def var c-serie         like contr-titulo-exp.serie         no-undo.
def var c-nr-docto      like contr-titulo-exp.nr-docto      no-undo.
def var c-parcela       like contr-titulo-exp.parcela       no-undo.

DEF VAR v-nr-proces-ini LIKE contr-titulo-exp.char-1       no-undo.
DEF VAR v-nr-proces-fim LIKE contr-titulo-exp.char-1       no-undo.
DEF VAR v-emitente-ini  LIKE contr-titulo-exp.cod-emitente no-undo.  
DEF VAR v-emitente-fim  LIKE contr-titulo-exp.cod-emitente no-undo.
DEF VAR dt-vencto-ini   LIKE contr-titulo-exp.dt-vencimen  no-undo.
DEF VAR dt-vencto-fim   LIKE contr-titulo-exp.dt-vencimen  no-undo.

def var vl-abater  as   decimal no-undo.
def var i-seq-erro as   integer no-undo.
def var ro-rowid   as   rowid   no-undo.
def var r-titulo   as   rowid   no-undo.
def var c-usuario  like contr-titulo-exp.usuario no-undo.
def var r-mov-tit as rowid no-undo.
def var v-num-id-movto as integer format ">>>>,>>9" no-undo.
def new global shared var gr-processo-exp as rowid no-undo.
def var c-nr-contrato   like contr-titulo-EXP.nr-contrato   no-undo.
def var d-dt-contrato   like contr-titulo-exp.dt-contrato   no-undo.
def var h-boad355 as handle no-undo.
def var v-pagar   as CHAR   no-undo.
def var v-receber as CHAR   no-undo.
&IF "{&mguni_version}" >= "2.07A" &THEN
define variable i-empresa   LIKE empresa.ep-codigo   no-undo.
&ELSE
define variable i-empresa   as integer   no-undo.
&ENDIF
def var c-cod-estabel-ini like contr-titulo-exp.cod-estabel no-undo.
def var c-cod-estabel-fim like contr-titulo-exp.cod-estabel no-undo.
def var i-cod-fornec-ini  like contr-titulo-exp.cod-emitente no-undo.
def var i-cod-fornec-fim  like contr-titulo-exp.cod-emitente no-undo.
def var c-nr-docto-ini    like contr-titulo-exp.nr-docto    no-undo.
def var c-nr-docto-fim    like contr-titulo-exp.nr-docto    no-undo.
def var d-dt-vencimen-ini like contr-titulo-exp.dt-vencimen no-undo.
def var d-dt-vencimen-fim like contr-titulo-exp.dt-vencimen no-undo.
DEF VAR c-nr-proc-exp-ini AS CHAR NO-UNDO.
DEF VAR c-nr-proc-exp-fim AS CHAR NO-UNDO.
DEF VAR c-cod-esp-ini      LIKE contr-titulo-exp.cod-esp      NO-UNDO.
DEF VAR c-cod-esp-fim      LIKE contr-titulo-exp.cod-esp      NO-UNDO.
DEF VAR c-serie-ini        LIKE contr-titulo-exp.serie        NO-UNDO.
DEF VAR c-serie-fim        LIKE contr-titulo-exp.serie        NO-UNDO.
DEF VAR i-parcela-ini      LIKE contr-titulo-exp.parcela      NO-UNDO.
DEF VAR i-parcela-fim      LIKE contr-titulo-exp.parcela      NO-UNDO.
DEF VAR d-dt-vinculado-ini LIKE contr-titulo-exp.dt-vinculado NO-UNDO.
DEF VAR d-dt-vinculado-fim LIKE contr-titulo-exp.dt-vinculado NO-UNDO.
def new global shared var v_cod_empres_usuar as character format "x(03)" no-undo.
def new global shared var v_cod_usuar_corren as character format "x(12)" no-undo.
def var v_cod_empres_usuar_old as character format "x(3)"  no-undo.
def var v_cod_usuar_corren_old as character format "x(12)" no-undo.
def var l-int-mec-ems5         as log initial no           no-undo.
DEF VAR l-select-saque         AS logical                  NO-UNDO.

DEF VAR d-dt-emissao AS DATE NO-UNDO.

&IF {&ROWID_READY} = YES &THEN
    DEF VAR v-rec-tit-acr AS ROWID NO-UNDO.
&ELSE
    DEF VAR v-rec-tit-acr AS RECID NO-UNDO.
&ENDIF
DEF VAR v-nr-proc     as char no-undo.
DEF VAR h-bocx185 AS HANDLE NO-UNDO.
DEF VAR c-return  AS CHAR NO-UNDO.
DEF VAR cod-moeda-cambial  AS INT NO-UNDO.
DEF VAR vl-paridade-impl   AS DEC NO-UNDO.
DEF VAR vl-vincul-contrato AS DEC NO-UNDO.
DEF VAR vl-saldo-liquidar-mo-contrato AS DEC NO-undo.
DEFINE VARIABLE l-libera-vinculo    AS LOGICAL NO-UNDO.

DEF VAR l-multi-an AS LOG    NO-UNDO.
DEF VAR H-BOAD391  AS HANDLE NO-UNDO.
DEF VAR L-DESTINACAO AS LOG NO-UNDO.

def temp-table tt_log_erros no-undo
    field ttv_num_seq as int format ">>>,>>9" label "Sequància" column-label "Seq"
    field ttv_num_cod_erro as int format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_erro as char format "x(50)" label "Inconsistància" column-label "Inconsistància"
    field ttv_des_ajuda as char format "x(50)" label "Ajuda" column-label "Ajuda".

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

def temp-table tt-contrato-exp no-undo like contrato-exp
    field r-rowid as rowid.

find param-global no-lock no-error.

def temp-table tt-contr-titulo-exp no-undo like contr-titulo-exp
    field r-rowid as rowid.

def temp-table tt-contr-titulo-exp-ace no-undo like contr-titulo-exp
    field r-rowid as rowid.

def temp-table tt-titulos no-undo like contr-titulo-exp
    field r-rowid as rowid.

def temp-table tt-titulos-selecionados no-undo like titulo
    field r-rowid         as rowid 
    field de-vl-vinculado as decimal label "Vl Vinculado" format ">,>>>,>>>,>>9.99"
    field ctr-referencia  as char
    field dt-referencia   as date
    field nr-contrato     as char
    field dt-contrato     as date
    field prod-financ     as char
    field dt-vinculado    as DATE
    field vl-paridade as dec
    field moeda as int
    field ctr-referencia-liq as char
    field dt-referencia-liq as date
    field nr-contrato-liq as char
    field dt-contrato-liq as date
    field cod-unid-negoc as char init '' format "x(3)" 
    index codigo          is primary
                             ep-codigo
                             cod-estabel
                             referencia
                             dt-referencia.

def temp-table tt-digita no-undo
&IF "{&mguni_version}" >= "2.07A" &THEN
    field cod-estabel     as char format "x(05)"                label "Est"
&ELSE
    field cod-estabel     as char format "x(3)"                label "Est"
&ENDIF
    field cod-esp         as char format "x(3)"                label "Esp"
    field serie           as char format "x(5)"                label "SÇrie"
    field nr-docto        as char format "x(16)"               label "Documento"
    field parcela         as char format "x(2)"                label "/P"
    field cod-emitente    as int  format ">>>>>>>>9"           label "Cliente"
    field dt-vinculado    as date format "99/99/9999"          label "Dt Vinculado"
    field dt-vencto       as date format "99/99/9999"          label "Dt  Vencto"
    field vl-vinculado-me as dec  format "->>>,>>>,>>>,>>9.99" label "Vl Vinculado ME"
    field sl-liquidar-me  as dec  format "->>>,>>>,>>>,>>9.99" label "Sl Liquidar ME"
    field nr-contrato     as char format "x(15)"               label "Nr.Contrato"
    field dt-contrato     as date format "99/99/9999"          label "Data Contrato".

def temp-table tt-titulo no-undo
&IF "{&mguni_version}" >= "2.07A" &THEN
    field cod-estabel       as char format "x(05)"
&ELSE
    field cod-estabel       as char format "x(3)"
&ENDIF
    field cod-esp           as char format "x(2)"
    field serie             as char format "x(5)"
    field nr-docto          as char format "x(16)"
    field parcela           as char format "x(2)"
    field cod-emitente      as int  format ">>>>>>>>9"
    field dt-emissao        as date format "99/99/9999"
    field dt-vencimen       as date format "99/99/9999"
    field vl-original-me    as decimal format "->>>,>>>,>>>,>>9.99"
    field vl-saldo-me       as decimal format "->>>,>>>,>>>,>>9.99".

def temp-table tt_tit_acr_dat_emissao no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss∆o" column-label "Dt Emiss∆o"
    field tta_val_origin_tit_acr           as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Original T°tulo" column-label "Vl Original T°tulo"
    .

define temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer   format ">>>>,>>9" label "N£mero"         column-label "N£mero"
    field ttv_des_msg_ajuda as character format "x(40)"    label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)"    label "Mensagem Erro"  column-label "Inconsistància".

def temp-table tt-erro-integr no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

def temp-table tt-param-selecao-tit no-undo
   field estabelecimento-ini like tit-ap.cod-estabel
   field estabelecimento-fim like tit-ap.cod-estabel
   field esp-ini             like titulo.cod-esp
   field esp-fim             like titulo.cod-esp
   field cli-ini             like titulo.cod-emitente
   field cli-fim             like titulo.cod-emitente
   field docto-ini           like titulo.nr-docto
   field docto-fim           like titulo.nr-docto
   field vencimen-ini        like titulo.dt-vencimen
   field vencimen-fim        like titulo.dt-vencimen
   field prev-pag-ini        like titulo.dt-pg-prev
   field prev-pag-fim        like titulo.dt-pg-prev
   field nr-proc-exp-ini     like titulo.nr-proc-exp
   field nr-proc-exp-fim     like titulo.nr-proc-exp
   field ind-tip-selec       as char format "x(30)".


DEFINE TEMP-TABLE tt-tit-acr-selecionados NO-UNDO LIKE movadm.titulo
       field r-rowid as rowid
       field de-vl-vinculado as decimal label "Vl Vinculado" format ">,>>>,>>>,>>9.99"
       field ctr-referencia as char
       field dt-referencia as date
       field nr-contrato as char
       field dt-contrato as DATE
       FIELD vl-paridade AS DEC
       FIELD moeda AS INT
       index vencimento is PRIMARY
       ep-codigo
       dt-vencimen
       dt-liq
       nome-abrev.

def temp-table tt_tit_acr_ems5 no-undo
    field cod_empresa           as character format "x(3)" label "Empresa" column-label "Empresa"
    field cod_estab             as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field cod_espec_docto       as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field cod_ser_docto         as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field cod_tit_acr           as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field cod_parcela           as character format "x(02)" label "Parcela" column-label "Parc"
    field cdn_cliente           as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field val_sdo_tit_acr       as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Saldo" column-label "Valor Saldo"
    field dat_vencto_tit_acr    as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field dat_prev_pagto        as date format "99/99/9999" initial today label "Data Prevista Pgto" column-label "Dt Prev Pagto"
    field tta_cod_estab_refer   as character format "x(3)" initial ? label "Estabelecimento" column-label "Estab"
    field tta_cod_refer         as character format "x(10)" label "Referància" column-label "Referància"
    field tta_dat_refer         as date format "99/99/9999" initial ? label "Data Referància" column-label "Data Referància"
    field nr-proc-exp           as character format "x(12)" label "Processo Exportaá∆o" column-label "Processo Exportaá∆o"
    FIELD cod_indic_econ        AS INT.

&if "{&mgadm_version}":U >= "2.06B":U &then
    def temp-table tt-proc-docto-export no-undo like proc-docto-export
        field r-rowid  as rowid.
&endif.

DEFINE TEMP-TABLE tt-processo-exp NO-UNDO LIKE processo-exp
       field r-rowid as rowid.

def temp-table tt-contratos no-undo
    field ep-codigo      like titulo.ep-codigo
    field cod-estabel    like titulo.cod-estabel
    field referencia     as   char
    field dt-referencia  as   date
    field nr-contrato    as   char
    field dt-contrato    as   date
    field cod-comprador  as   integer
    field dt-liquidacao  as   date
    field vl-contrato-me as   decimal
    field r-rowid        as   rowid.

DEF TEMP-TABLE tt-emitente NO-UNDO LIKE emitente
    FIELD r-rowid AS ROWID
    INDEX nome nome-abrev.

/*** definiá‰es para conex∆o das bases do EMS 5.0 ***/
/*{ecp/ec0005c.i}*/

/*** definiá‰es para conex∆o das bases EMS 5.0 ***/
def var i-erro             as integer                            no-undo.
def var c-mensagem         as char format "x(60)"                no-undo.
def var l-elimina-erro     as logical                            no-undo.
def var c-erro             as char                               no-undo.
def var c-erro2            as char                               no-undo.
def var c-erro3            as char                               no-undo.
def var c-erro4            as char                               no-undo.
def var l-conectou         as logical                            no-undo.
/* temp-table */
def temp-table tt-erro no-undo
    field i-cod-erro        as integer format "9999999"
    field c-desc-erro       as char format "x(100)"
    field c-arquivo-erro    as char format "x(100)"
    field l-contabilizou    as logical initial no.


{cdp/cd1202.i5}
{btb/btb009za.i} 
{utp/ut-glob.i}

/** Definicoes de TT p/eliminacao e estorno de antecipacao **/
{crp/crapi021.i}
{adbo/boad346.i3}

/* Integraá‰es */
def var raw-integracao as raw no-undo.

/* Verifica funá∆o pre-pagamento */
def var v-funcao-pre-pagto as log    no-undo.
def var h-acr788za         as handle no-undo.
{ecp/ec0003.i}
{ecp/ec0003.i1}

/*** Verificar se a funá∆o especial est†ˇ habilitada ***/
{include/getdefinedfunction.i}
assign l-int-mec-ems5 = &if defined(BF_FIN_INTEGR_MEC_EMS5) &then YES &else GetDefinedFunction("SPP-INT-MEC-EMS5") &endif.
assign l-select-saque = &if defined(BF_FIN_SELECT_PROCES_EXPORT_SAQUE) &then YES &else GetDefinedFunction("SPP-SELECT-SAQUE") &endif.
assign l-libera-vinculo = &if defined(BF_FIN_VINCUL_CARTA_MEC) &then YES &else GetDefinedFunction("SPP-VINCUL_CARTA_MEC") &endif.
assign l-multi-an = &if defined(BF_FIN_MULTI_AN) &then YES &else GetDefinedFunction("SPP-MULTI-AN") &endif.
assign l-destinacao = &if defined(BF_FIN_DESTINACAO) &then YES &else GetDefinedFunction("SPP-DESTINACAO") &endif.

def shared var l-vincul-carta as logical no-undo.

def new global shared var v_cod_grp_usuar_lst
    as character
    format "x(3)":U
    label "Grupo Usu†rios"
    column-label "Grupo"
    no-undo.

def var v_cod_grp_usuar_lst_old
    as character
    format "x(3)":U
    label "Grupo Usu†rios"
    column-label "Grupo"
    no-undo.

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
         HEIGHT             = 1.96
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterCreateRecord DBOProgram 
PROCEDURE AfterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var h-boad348 as handle no-undo.

    run adbo/boad348.p persistent set h-boad348.
    run pi-cria-docto-automatico in h-boad348 (input RowObject.ep-codigo,
                                               input RowObject.cod-estabel,
                                               input RowObject.referencia,
                                               input RowObject.dt-referencia,
                                               input RowObject.cod-emitente,
                                               input RowObject.cod-esp,
                                               input RowObject.serie,
                                               input RowObject.nr-docto,
                                               input RowObject.parcela).
    if valid-handle(h-boad348) then
        delete procedure h-boad348.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDeleteRecord DBOProgram 
PROCEDURE AfterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    find bfcontrato-exp no-lock
   where bfcontrato-exp.NR-CONTRATO   = RowObject.NR-CONTRATO and
         bfcontrato-exp.DT-CONTRATO   = RowObject.DT-CONTRATO no-error.


    if bfcontrato-exp.tp-contrato-exp = 3 then do:
        for each contr-emprestimo
           where contr-emprestimo.ep-codigo        = RowObject.ep-codigo
           and   contr-emprestimo.cod-estabel      = RowObject.cod-estabel
           and   contr-emprestimo.referencia       = RowObject.referencia
           and   contr-emprestimo.dt-referencia    = RowObject.dt-referencia
           and   contr-emprestimo.cod-banco-ems5-d = RowObject.cod-banco-ems5
           and   contr-emprestimo.prod-financ-d    = RowObject.prod-financ
           and   contr-emprestimo.operac-financ-d  = RowObject.operac-financ exclusive-lock:

           delete contr-emprestimo.

        end.
    end.
    
    
    &if "{&mgadm_version}":U >= "2.06B":U &then
        assign i_cont_contr = 0.
    
        for each contr-titulo-exp
            where contr-titulo-exp.nr-contrato = bfcontrato-exp.nr-contrato 
              and contr-titulo-exp.dt-contrato = bfcontrato-exp.dt-contrato
              and contr-titulo-exp.nr-proc-exp = RowObject.nr-proc-exp no-lock:
            assign i_cont_contr = i_cont_contr + 1.
        end.
    
        if i_cont_contr = 0 then do:
            for each tt-proc-docto-export:
                delete tt-proc-docto-export.
            end.
        
            if not valid-handle(h-bocx346) then 
                run cxbo/bocx346.p persistent set h-bocx346.
        
            run setConstraintOfProcExp in h-bocx346(input bfcontrato-exp.cod-estabel,
                                                    input RowObject.nr-proc-exp).
        
            run openQueryStatic in h-bocx346(input "OfProcExp":U).
        
            run getBatchRecords  in h-bocx346(input  ?,
                                              input  NO,
                                              input  0, /* Retorna todos os resultados*/
                                              output iRowsReturned,
                                              output table tt-proc-docto-export).

            if valid-handle(h-bocx346) then
                delete procedure h-bocx346.
        
            for each contr-docto-exp
                where contr-docto-exp.ep-codigo      = bfcontrato-exp.ep-codigo    
                and   contr-docto-exp.cod-estabel    = bfcontrato-exp.cod-estabel  
                and   contr-docto-exp.referencia     = bfcontrato-exp.referencia   
                and   contr-docto-exp.dt-referencia  = bfcontrato-exp.dt-referencia exclusive-lock:
        
                case contr-docto-exp.ind-tipo-documento:
                    when 3 then
                        assign i_nr_proc_exp = 2.
                    when 1 then
                        assign i_nr_proc_exp = 3.
                    when 6 then
                        assign i_nr_proc_exp = 4.
                    when 14 then
                        assign i_nr_proc_exp = 5.
                    when 9 then
                        assign i_nr_proc_exp = 10.
                    when 11 then
                        assign i_nr_proc_exp = 11.
                end case.
        
                find first tt-proc-docto-export
                    where tt-proc-docto-export.cod-estabel   = contr-docto-exp.cod-estabel
                      and tt-proc-docto-export.nr-proc-exp   = RowObject.nr-proc-exp
                      and tt-proc-docto-export.data-emissao  = contr-docto-exp.dt-emissao
                      and tt-proc-docto-export.hora-emissao  = contr-docto-exp.char-1
                      and tt-proc-docto-export.idi-tip-docto = i_nr_proc_exp no-lock no-error.
                if avail tt-proc-docto-export then do:
                    delete contr-docto-exp.
                end.
            end.
        end.
        for each contr-titulo-reg exclusive-lock
             where contr-titulo-reg.ep-codigo    = RowObject.ep-codigo
               and contr-titulo-reg.cod-estabel  = RowObject.cod-estabel
               and contr-titulo-reg.nr-contrato  = RowObject.nr-contrato
               and contr-titulo-reg.cod-esp      = RowObject.cod-esp
               and contr-titulo-reg.serie        = RowObject.serie
               and contr-titulo-reg.nr-docto     = RowObject.nr-docto
               and contr-titulo-reg.parcela      = RowObject.parcela
               and contr-titulo-reg.dt-vinculado = RowObject.dt-vinculado:
           delete contr-titulo-reg.
        end.
    &endif

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterUpdateRecord DBOProgram 
PROCEDURE AfterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeCreateRecord DBOProgram 
PROCEDURE BeforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*    find bfcontrato-exp no-lock
       where bfcontrato-exp.ep-codigo     = RowObject.ep-codigo and
             bfcontrato-exp.cod-estabel   = RowObject.cod-estabel and
             bfcontrato-exp.referencia    = RowObject.referencia and
             bfcontrato-exp.dt-referencia = RowObject.dt-referencia no-error. */

 find bfcontrato-exp no-lock
   where bfcontrato-exp.NR-CONTRATO   = RowObject.NR-CONTRATO and
         bfcontrato-exp.DT-CONTRATO   = RowObject.DT-CONTRATO no-error.

    if avail bfcontrato-exp then do:
        assign RowObject.nr-contrato = bfcontrato-exp.nr-contrato
               RowObject.dt-contrato = bfcontrato-exp.dt-contrato.


        if bfcontrato-exp.tp-contrato-exp = 3 THEN DO:
            /*            or bfcontrato-exp.tp-contrato-exp = 1  then do: */
           /*** vincula titulo ao emprestimo ***/
           if bfcontrato-exp.tp-emprestimo   <> 2 then do:
               run pi-vincula-titulo-emprestimo.
               if return-value = "NOK":U then
                    RETURN "NOK":U.
           end.

           assign RowObject.l-fluxo-caixa = no.

           if bfcontrato-exp.tp-emprestimo = 2 then
               assign RowObject.situacao = 1.
           else
               assign RowObject.situacao = 2.
        end.
        else do:
            if bfcontrato-exp.situacao <> 1 then
                assign RowObject.dt-vinculado = bfcontrato-exp.dt-contrato.
        end.
    end.
    FIND FIRST contr-titulo-exp NO-LOCK
       WHERE contr-titulo-exp.ep-codigo    = RowObject.ep-codigo
         AND contr-titulo-exp.cod-estabel  = RowObject.cod-estabel
         AND contr-titulo-exp.cod-emitente = RowObject.cod-emitente
         AND contr-titulo-exp.cod-esp      = RowObject.cod-esp
         AND contr-titulo-exp.serie        = RowObject.serie
         AND contr-titulo-exp.nr-docto     = RowObject.nr-docto
         AND contr-titulo-exp.parcela      = RowObject.parcela NO-ERROR.
    IF NOT AVAIL contr-titulo-exp THEN DO:
       ASSIGN  RowObject.log-1 = YES.
    END.

    /*** Alimenta Numero do Processo de Exportaá∆o ***/
    run adbo/boad355.p persistent set h-boad355.
    run pi-verificar-produto in h-boad355 (output v-pagar,
                                           output v-receber).
    delete procedure h-boad355.


    IF v-receber = "EMS 5" THEN DO:

        {cdp/cd1202.i3 RowObject.ep-codigo}

        RUN prgint/utb/utb215za.py (input "acr":u,
                                    INPUT RowObject.ep-codigo,
                                    INPUT RowObject.cod-estabel, 
                                    INPUT RowObject.cod-emitente,
                                    INPUT RowObject.cod-esp,
                                    INPUT RowObject.serie,
                                    INPUT RowObject.nr-docto,
                                    INPUT RowObject.parcela,
                                    OUTPUT v-rec-tit-acr,
                                    OUTPUT v-nr-proc,
                                    OUTPUT TABLE tt_log_erros).

        {cdp/cd1202.i4 RowObject.ep-codigo}
    END.

    &IF "{&mgadm_version}":U < "2.06":U &THEN
        ASSIGN RowObject.char-1      = v-nr-proc.
    &ELSE
        ASSIGN RowObject.nr-proc-exp = v-nr-proc.
    &ENDIF

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeDeleteRecord DBOProgram 
PROCEDURE BeforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var c-ep-codigo like contr-titulo-exp.ep-codigo no-undo.

    find first bfcontrato-exp
       where bfcontrato-exp.NR-CONTRATO   = RowObject.NR-CONTRATO and
             bfcontrato-exp.DT-CONTRATO   = RowObject.DT-CONTRATO NO-LOCK NO-ERROR.

    if bfcontrato-exp.tp-contrato-exp = 3 then do:
        RUN adbo/boad355.p persistent set h-boad355.
        run pi-verificar-produto in h-boad355 (output v-pagar,
                                               output v-receber).
        delete procedure h-boad355.
        
        if  v-receber = "EMS 5" then do:
            IF  (bfcontrato-exp.tp-emprestimo = 3 OR
                bfcontrato-exp.tp-emprestimo = 4) AND
                RowObject.situacao = 1 THEN DO:
                IF  v-funcao-pre-pagto THEN DO:

                    assign c-ep-codigo = RowObject.ep-codigo
                           i-seq-erro  = 0.

                    /*** Carrega bases do EMS 5.0 ***/
                    {ecp/ec0005b.i 1}

                    /*** Verifica Erro na Conex∆o das Bases ***/
                    {ecp/ec0005k.i}

                    if i-seq-erro <> 0 then
                        RETURN "NOK":U.

                    FOR EACH tt_repas_pend_apl:
                        DELETE tt_repas_pend_apl.
                    END.

                    CREATE tt_repas_pend_apl.
                    ASSIGN tt_repas_pend_apl.tta_num_id_operac_financ = bfcontrato-exp.num-id-operac-financ
                           tt_repas_pend_apl.tta_num_seq_repas_pend   = 9999
                           tt_repas_pend_apl.tta_dat_repas_pend       = RowObject.dt-vinculado
                           tt_repas_pend_apl.tta_val_repas_pend       = RowObject.vl-vinculado-me * (-1)
                           tt_repas_pend_apl.tta_ind_sit_repas_pend   = ""
                           tt_repas_pend_apl.tta_ind_tip_repas_pend   = "Vinculaá∆o".

                    RUN prgfin/acr/acr788za.py persistent set h-acr788za.
                    RUN pi_atualiza_repas_pend_apl in h-acr788za (INPUT-OUTPUT TABLE tt_repas_pend_apl,
                                                                  INPUT "Quitada",
                                                                  INPUT bfcontrato-exp.num-id-operac-financ).
                    DELETE PROCEDURE h-acr788za.

                    /*** Desconecta bases do EMS 5.0 ***/
                    {ecp/ec0005b.i 2}

                    /*** Verifica Erro na Conex∆o das Bases ***/
                    {ecp/ec0005k.i}

                    if i-seq-erro <> 0 then
                       RETURN "NOK":U.
                END.
            END.

            if RowObject.operac-financ <> "" then do:
               run pi-elimina-operacao-financeira.
               RETURN return-value.
            end.
        END.
    end.

    if bfcontrato-exp.tp-contrato-exp = 2 then do:
        run pi-elimina-antecipacao in this-procedure.
        return return-value.
    end.

    IF RowObject.log-1 = YES THEN DO:

        FIND FIRST b-contr-titulo-exp EXCLUSIVE-LOCK
          WHERE b-contr-titulo-exp.ep-codigo    = RowObject.ep-codigo
            AND b-contr-titulo-exp.cod-estabel  = RowObject.cod-estabel
            AND b-contr-titulo-exp.cod-emitente = RowObject.cod-emitente
            AND b-contr-titulo-exp.cod-esp      = RowObject.cod-esp
            AND b-contr-titulo-exp.serie        = RowObject.serie
            AND b-contr-titulo-exp.nr-docto     = RowObject.nr-docto
            AND b-contr-titulo-exp.parcela      = RowObject.parcela
            AND b-contr-titulo-exp.nr-contrato  <> RowObject.nr-contrato NO-ERROR.
         IF AVAIL b-contr-titulo-exp THEN DO:
             ASSIGN  b-contr-titulo-exp.log-1 = YES.
         END.
    END.
    RETURN "OK":U.
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
        WHEN "cod-banco-ems5":U THEN ASSIGN pFieldValue = RowObject.cod-banco-ems5.
        WHEN "cod-esp":U THEN ASSIGN pFieldValue = RowObject.cod-esp.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        WHEN "nr-docto":U THEN ASSIGN pFieldValue = RowObject.nr-docto.
        WHEN "operac-financ":U THEN ASSIGN pFieldValue = RowObject.operac-financ.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
        WHEN "prod-financ":U THEN ASSIGN pFieldValue = RowObject.prod-financ.
        WHEN "referencia":U THEN ASSIGN pFieldValue = RowObject.referencia.
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
        WHEN "dt-contrato":U THEN ASSIGN pFieldValue = RowObject.dt-contrato.
        WHEN "dt-referencia":U THEN ASSIGN pFieldValue = RowObject.dt-referencia.
        WHEN "dt-today":U THEN ASSIGN pFieldValue = RowObject.dt-today.
        WHEN "dt-vencimen":U THEN ASSIGN pFieldValue = RowObject.dt-vencimen.
        WHEN "dt-vinculado":U THEN ASSIGN pFieldValue = RowObject.dt-vinculado.
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
        WHEN "sl-liquidar-me":U THEN ASSIGN pFieldValue = RowObject.sl-liquidar-me.
        WHEN "vl-vinculado-me":U THEN ASSIGN pFieldValue = RowObject.vl-vinculado-me.
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
        &IF "{&mguni_version}" < "2.07A" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "num-id-operac-financ":U THEN ASSIGN pFieldValue = RowObject.num-id-operac-financ.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice referencia
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo referencia
               retorna valor do campo dt-referencia
               retorna valor do campo cod-emitente
               retorna valor do campo cod-esp
               retorna valor do campo serie
               retorna valor do campo nr-docto
               retorna valor do campo parcela
               retorna valor do campo dt-vinculado
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE contr-titulo-exp.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE contr-titulo-exp.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER preferencia LIKE contr-titulo-exp.referencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-referencia LIKE contr-titulo-exp.dt-referencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE contr-titulo-exp.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-esp LIKE contr-titulo-exp.cod-esp NO-UNDO.
    DEFINE OUTPUT PARAMETER pserie LIKE contr-titulo-exp.serie NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-docto LIKE contr-titulo-exp.nr-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pparcela LIKE contr-titulo-exp.parcela NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-vinculado LIKE contr-titulo-exp.dt-vinculado NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo     = RowObject.ep-codigo
           pcod-estabel   = RowObject.cod-estabel
           preferencia    = RowObject.referencia
           pdt-referencia = RowObject.dt-referencia
           pcod-emitente = RowObject.cod-emitente
           pcod-esp = RowObject.cod-esp
           pserie = RowObject.serie
           pnr-docto = RowObject.nr-docto
           pparcela = RowObject.parcela
           pdt-vinculado = RowObject.dt-vinculado.

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
        WHEN "l-fluxo-caixa":U THEN ASSIGN pFieldValue = RowObject.l-fluxo-caixa.
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
  Purpose:     Reposiciona registro com base no °ndice referencia
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo referencia
               recebe valor do campo dt-referencia
               recebe valor do campo cod-emitente
               recebe valor do campo cod-esp
               recebe valor do campo serie
               recebe valor do campo nr-docto
               recebe valor do campo parcela
               recebe valor do campo dt-vinculado
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE contr-titulo-exp.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE contr-titulo-exp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER preferencia LIKE contr-titulo-exp.referencia NO-UNDO.
    DEFINE INPUT PARAMETER pdt-referencia LIKE contr-titulo-exp.dt-referencia NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE contr-titulo-exp.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pcod-esp LIKE contr-titulo-exp.cod-esp NO-UNDO.
    DEFINE INPUT PARAMETER pserie LIKE contr-titulo-exp.serie NO-UNDO.
    DEFINE INPUT PARAMETER pnr-docto LIKE contr-titulo-exp.nr-docto NO-UNDO.
    DEFINE INPUT PARAMETER pparcela LIKE contr-titulo-exp.parcela NO-UNDO.
    DEFINE INPUT PARAMETER pdt-vinculado LIKE contr-titulo-exp.dt-vinculado NO-UNDO.

    FIND FIRST bfcontr-titulo-exp WHERE 
        bfcontr-titulo-exp.ep-codigo = pep-codigo AND 
        bfcontr-titulo-exp.cod-estabel = pcod-estabel AND 
        bfcontr-titulo-exp.referencia = preferencia AND 
        bfcontr-titulo-exp.dt-referencia = pdt-referencia AND 
        bfcontr-titulo-exp.cod-emitente = pcod-emitente AND 
        bfcontr-titulo-exp.cod-esp = pcod-esp AND 
        bfcontr-titulo-exp.serie = pserie AND 
        bfcontr-titulo-exp.nr-docto = pnr-docto AND 
        bfcontr-titulo-exp.parcela = pparcela AND 
        bfcontr-titulo-exp.dt-vinculado = pdt-vinculado NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcontr-titulo-exp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcontr-titulo-exp)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyCustom DBOProgram 
PROCEDURE goToKeyCustom :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice referencia
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-emitente
               recebe valor do campo cod-estabel
               recebe valor do campo cod-esp
               recebe valor do campo serie
               recebe valor do campo nr-docto
               recebe valor do campo parcela

  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo    LIKE contr-titulo-exp.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel  LIKE contr-titulo-exp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-esp      LIKE contr-titulo-exp.cod-esp NO-UNDO.
    DEFINE INPUT PARAMETER pserie        LIKE contr-titulo-exp.serie NO-UNDO.
    DEFINE INPUT PARAMETER pnr-docto     LIKE contr-titulo-exp.nr-docto NO-UNDO.
    DEFINE INPUT PARAMETER pparcela      LIKE contr-titulo-exp.parcela NO-UNDO.

    FIND FIRST bfcontr-titulo-exp WHERE 
        bfcontr-titulo-exp.ep-codigo = pep-codigo AND 
        bfcontr-titulo-exp.cod-estabel = pcod-estabel AND 
        bfcontr-titulo-exp.cod-esp = pcod-esp AND 
        bfcontr-titulo-exp.serie = pserie AND 
        bfcontr-titulo-exp.nr-docto = pnr-docto AND 
        bfcontr-titulo-exp.parcela = pparcela NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcontr-titulo-exp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcontr-titulo-exp)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LinkToContrato-Exp DBOProgram 
PROCEDURE LinkToContrato-Exp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter phandle as handle no-undo.

    run getkey in phandle (output i-ep-codigo,
                           output c-cod-estabel,
                           output c-referencia,
                           output d-dt-referencia).

    run SetConstraintContratoExp in this-procedure (input i-ep-codigo,
                                                    input c-cod-estabel,
                                                    input c-referencia,
                                                    input d-dt-referencia).

    RETURN "OK":U.                                                    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LinkToContrato-Exp3 DBOProgram 
PROCEDURE LinkToContrato-Exp3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter phandle as handle no-undo.

    run getkey3 in phandle (output c-nr-contrato ,
                            output d-dt-contrato ).

    run setConstraintContratoEXP3 in this-procedure (input c-nr-contrato ,
                                                     input d-dt-contrato ).
    
    RETURN "OK":U.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryContratoExp DBOProgram 
PROCEDURE OpenQueryContratoExp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
        WHERE contr-titulo-exp.ep-codigo     = i-ep-codigo and
              contr-titulo-exp.cod-estabel   = c-cod-estabel and
              contr-titulo-exp.referencia    = c-referencia and
              contr-titulo-exp.dt-referencia = d-dt-referencia INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LinkToContrato-Exp4 DBOProgram 
PROCEDURE LinkToContrato-Exp4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter phandle as handle no-undo.

    run getkey3 in phandle (output c-nr-contrato ,
                           output d-dt-contrato ).

    run setConstraintContratoEXP4 in this-procedure (input c-nr-contrato ,
                                                     input d-dt-contrato ).

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryContr-titulo-exp DBOProgram 
PROCEDURE openQueryContr-titulo-exp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
         WHERE (contr-titulo-exp.cod-estabel >= c-cod-estabel-ini and
                contr-titulo-exp.cod-estabel <= c-cod-estabel-fim)
           and (contr-titulo-exp.cod-emitente  >= i-cod-fornec-ini and
                contr-titulo-exp.cod-emitente  <= i-cod-fornec-fim)
           and (contr-titulo-exp.nr-docto    >= c-nr-docto-ini and
                contr-titulo-exp.nr-docto    <= c-nr-docto-fim)
           and (contr-titulo-exp.dt-vencimen >= d-dt-vencimen-ini and
                contr-titulo-exp.dt-vencimen <= d-dt-vencimen-fim)
           AND (&IF "{&mgadm_version}":U < "2.06":U &THEN
                    (contr-titulo-exp.char-1 >= c-nr-proc-exp-ini and
                     contr-titulo-exp.char-1 <= c-nr-proc-exp-fim)
                &ELSE
                    (contr-titulo-exp.nr-proc-exp >= c-nr-proc-exp-ini and
                     contr-titulo-exp.nr-proc-exp <= c-nr-proc-exp-fim)
                &ENDIF)
           and contr-titulo-exp.log-1 = YES

           BY contr-titulo-exp.cod-estabel
           BY contr-titulo-exp.cod-emitente
           BY contr-titulo-exp.cod-esp
           BY contr-titulo-exp.serie
           BY contr-titulo-exp.nr-docto
           BY contr-titulo-exp.parcela.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryContratoExp2 DBOProgram 
PROCEDURE openQueryContratoExp2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
        WHERE contr-titulo-exp.ep-codigo     = i-ep-codigo and
              contr-titulo-exp.cod-estabel   = c-cod-estabel and
              contr-titulo-exp.referencia    = c-referencia and
              contr-titulo-exp.dt-referencia = d-dt-referencia and
              contr-titulo-exp.situacao      = 1 and
              contr-titulo-exp.sl-liquidar-me > 0 INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryContratoExp3 DBOProgram 
PROCEDURE openQueryContratoExp3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
        WHERE contr-titulo-EXP.nr-contrato = c-nr-contrato and
              contr-titulo-EXP.dt-contrato = d-dt-contrato AND
              contr-titulo-exp.situacao      = 1 and
              contr-titulo-exp.sl-liquidar-me > 0 
              &if "{&mgadm_version}":U < "2.06":U &then 
                BY contr-titulo-exp.char-1 
              &else 
                BY contr-titulo-exp.nr-proc-exp 
              &endif      
              BY contr-titulo-exp.dt-vencimen
              BY contr-titulo-exp.nr-docto 
              BY contr-titulo-exp.ep-codigo
              BY contr-titulo-exp.cod-estabel
              BY contr-titulo-exp.referencia
              BY contr-titulo-exp.dt-referencia
              BY contr-titulo-exp.cod-emitente
              BY contr-titulo-exp.cod-esp
              BY contr-titulo-exp.serie
              BY contr-titulo-exp.parcela
              BY contr-titulo-exp.dt-vinculado INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryContratoExp4 DBOProgram 
PROCEDURE openQueryContratoExp4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
        WHERE contr-titulo-EXP.nr-contrato = c-nr-contrato and
              contr-titulo-EXP.dt-contrato = d-dt-contrato AND
              contr-titulo-exp.situacao      = 1 and
              contr-titulo-exp.sl-liquidar-me > 0 
              &if "{&mgadm_version}":U < "2.06":U &then
               BY contr-titulo-exp.char-1
              &else
               BY contr-titulo-exp.nr-proc-exp
              &endif
              by contr-titulo-EXP.dt-vencimen
              BY contr-titulo-exp.ep-codigo
              BY contr-titulo-exp.cod-estabel
              BY contr-titulo-exp.referencia
              BY contr-titulo-exp.dt-referencia
              BY contr-titulo-exp.cod-emitente
              BY contr-titulo-exp.cod-esp
              BY contr-titulo-exp.serie
              by contr-titulo-EXP.nr-docto
              BY contr-titulo-exp.parcela
              BY contr-titulo-exp.dt-vinculado INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryEmpreDigitacao DBOProgram 
PROCEDURE OpenQueryEmpreDigitacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
        WHERE contr-titulo-exp.ep-codigo     = i-ep-codigo and
              contr-titulo-exp.cod-estabel   = c-cod-estabel and
              contr-titulo-exp.referencia    = c-referencia and
              contr-titulo-exp.dt-referencia = d-dt-referencia and
              contr-titulo-exp.situacao      = 2 and
              contr-titulo-exp.sl-liquidar-me > 0 INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryEmpreDigitacao3 DBOProgram 
PROCEDURE OpenQueryEmpreDigitacao3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
        WHERE contr-titulo-exp.nr-contrato  = c-nr-contrato AND 
              contr-titulo-exp.dt-contrato  = d-dt-contrato   and
              contr-titulo-exp.situacao      = 2  and  
              contr-titulo-exp.sl-liquidar-me > 0  
        &if "{&mgadm_version}":U < "2.06":U &then 
          BY contr-titulo-exp.char-1 
        &else 
          BY contr-titulo-exp.nr-proc-exp 
        &endif
        BY contr-titulo-exp.dt-vencimen 
        BY contr-titulo-exp.nr-docto 
        BY contr-titulo-exp.ep-codigo 
        BY contr-titulo-exp.cod-estabel 
        BY contr-titulo-exp.referencia 
        BY contr-titulo-exp.dt-referencia 
        BY contr-titulo-exp.cod-emitente 
        BY contr-titulo-exp.cod-esp 
        BY contr-titulo-exp.serie 
        BY contr-titulo-exp.parcela 
        BY contr-titulo-exp.dt-vinculado INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryEmpreDigitacao4 DBOProgram 
PROCEDURE OpenQueryEmpreDigitacao4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   &if "{&mgadm_version}":U >= "2.06B":U &then
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
        WHERE contr-titulo-exp.nr-contrato   = c-nr-contrato
          AND contr-titulo-exp.dt-contrato   = d-dt-contrato
          AND contr-titulo-exp.estab-titulo >= c-cod-estabel-ini
          AND contr-titulo-exp.estab-titulo <= c-cod-estabel-fim
          AND contr-titulo-exp.cod-emitente >= i-cod-fornec-ini
          AND contr-titulo-exp.cod-emitente <= i-cod-fornec-fim
          AND contr-titulo-exp.cod-esp      >= c-cod-esp-ini
          AND contr-titulo-exp.cod-esp      <= c-cod-esp-fim
          AND contr-titulo-exp.serie        >= c-serie-ini
          AND contr-titulo-exp.serie        <= c-serie-fim
          AND contr-titulo-exp.nr-docto     >= c-nr-docto-ini
          AND contr-titulo-exp.nr-docto     <= c-nr-docto-fim
          AND contr-titulo-exp.parcela      >= i-parcela-ini
          AND contr-titulo-exp.parcela      <= i-parcela-fim
          AND contr-titulo-exp.dt-vinculado >= d-dt-vinculado-ini
          AND contr-titulo-exp.dt-vinculado <= d-dt-vinculado-fim
          AND contr-titulo-exp.dt-vencimen  >= d-dt-vencimen-ini
          AND contr-titulo-exp.dt-vencimen  <= d-dt-vencimen-fim
          AND contr-titulo-exp.nr-proc-exp  >= c-nr-proc-exp-ini
          AND contr-titulo-exp.nr-proc-exp  <= c-nr-proc-exp-fim
          AND contr-titulo-exp.situacao      = 2  INDEXED-REPOSITION.
    
    RETURN "OK":U.
   &endif
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryMain2 DBOProgram 
PROCEDURE OpenQueryMain2 :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryTitulo DBOProgram 
PROCEDURE OpenQueryTitulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
        use-index Titulo
        by {&tablename}.nr-docto INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryVinculado DBOProgram 
PROCEDURE OpenQueryVinculado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
        WHERE contr-titulo-exp.ep-codigo     = i-ep-codigo and
              contr-titulo-exp.cod-estabel   = c-cod-estabel and
              contr-titulo-exp.referencia    = c-referencia and
              contr-titulo-exp.dt-referencia = d-dt-referencia and
              contr-titulo-exp.situacao      = 1 INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryVinculado2 DBOProgram 
PROCEDURE OpenQueryVinculado2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
        WHERE contr-titulo-exp.nr-contrato   = c-nr-contrato and
              contr-titulo-exp.dt-contrato   = d-dt-contrato and
              (contr-titulo-exp.situacao      = 1 OR
               contr-titulo-exp.situacao      = 5)
              &if "{&mgadm_version}":U < "2.06":U &then
               BY contr-titulo-exp.char-1
              &else
              BY contr-titulo-exp.nr-proc-exp
              &endif
              by contr-titulo-exp.dt-vencimen
              by contr-titulo-exp.ep-codigo
              by contr-titulo-exp.cod-estabel
              by contr-titulo-exp.referencia 
              by contr-titulo-exp.dt-referencia
              by contr-titulo-exp.cod-emitente
              by contr-titulo-exp.cod-esp 
              by contr-titulo-exp.serie
              by contr-titulo-exp.nr-docto
              by contr-titulo-exp.parcela
              by contr-titulo-exp.dt-vinculado INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryVinculado3 DBOProgram 
PROCEDURE OpenQueryVinculado3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
        WHERE contr-titulo-exp.nr-contrato   = c-nr-contrato   and
              contr-titulo-exp.dt-contrato   = d-dt-contrato   and
              contr-titulo-exp.situacao      = 1               and
              &if "{&mgadm_version}":U < "2.06":U &then 
                  contr-titulo-exp.char-1       >= v-nr-proces-ini and
                  contr-titulo-exp.char-1       <= v-nr-proces-fim and
              &else 
                  contr-titulo-exp.nr-proc-exp  >= v-nr-proces-ini and
                  contr-titulo-exp.nr-proc-exp  <= v-nr-proces-fim and
              &endif
              contr-titulo-exp.cod-emitente >= v-emitente-ini  and
              contr-titulo-exp.cod-emitente <= v-emitente-fim  and
              contr-titulo-exp.dt-vencimen  >= dt-vencto-ini   and
              contr-titulo-exp.dt-vencimen  <= dt-vencto-fim
              &if "{&mgadm_version}":U < "2.06":U &then 
                BY contr-titulo-exp.char-1 
              &else 
                BY contr-titulo-exp.nr-proc-exp 
              &endif      
              by contr-titulo-exp.dt-vencimen
              by contr-titulo-exp.ep-codigo
              by contr-titulo-exp.cod-estabel
              by contr-titulo-exp.referencia 
              by contr-titulo-exp.dt-referencia
              by contr-titulo-exp.cod-emitente
              by contr-titulo-exp.cod-esp 
              by contr-titulo-exp.serie
              by contr-titulo-exp.nr-docto
              by contr-titulo-exp.parcela
              by contr-titulo-exp.dt-vinculado INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryVinculado4 DBOProgram 
PROCEDURE OpenQueryVinculado4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   &if "{&mgadm_version}":U >= "2.06B":U &then
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
        WHERE contr-titulo-exp.nr-contrato   = c-nr-contrato
          AND contr-titulo-exp.dt-contrato   = d-dt-contrato
          AND contr-titulo-exp.estab-titulo >= c-cod-estabel-ini
          AND contr-titulo-exp.estab-titulo <= c-cod-estabel-fim
          AND contr-titulo-exp.cod-emitente >= i-cod-fornec-ini
          AND contr-titulo-exp.cod-emitente <= i-cod-fornec-fim
          AND contr-titulo-exp.cod-esp      >= c-cod-esp-ini
          AND contr-titulo-exp.cod-esp      <= c-cod-esp-fim
          AND contr-titulo-exp.serie        >= c-serie-ini
          AND contr-titulo-exp.serie        <= c-serie-fim
          AND contr-titulo-exp.nr-docto     >= c-nr-docto-ini
          AND contr-titulo-exp.nr-docto     <= c-nr-docto-fim
          AND contr-titulo-exp.parcela      >= i-parcela-ini
          AND contr-titulo-exp.parcela      <= i-parcela-fim
          AND contr-titulo-exp.dt-vinculado >= d-dt-vinculado-ini
          AND contr-titulo-exp.dt-vinculado <= d-dt-vinculado-fim
          AND contr-titulo-exp.dt-vencimen  >= d-dt-vencimen-ini
          AND contr-titulo-exp.dt-vencimen  <= d-dt-vencimen-fim
          AND contr-titulo-exp.nr-proc-exp  >= c-nr-proc-exp-ini
          AND contr-titulo-exp.nr-proc-exp  <= c-nr-proc-exp-fim INDEXED-REPOSITION.
    
    RETURN "OK":U.
   &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-alt-dt-venc-titulo DBOProgram 
PROCEDURE pi-alt-dt-venc-titulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF "{&mguni_version}" >= "2.07A" &THEN
    def input  param p-ep-codigo     LIKE empresa.ep-codigo no-undo.
&ELSE
    def input  param p-ep-codigo     as integer no-undo.
&ENDIF
    def input  param p-cod-fornec    as integer no-undo.
    def input  param p-cod-estabel   as char    no-undo.
    def input  param p-cod-esp       as char    no-undo.
    def input  param p-serie         as char    no-undo.
    def input  param p-nr-docto      as char    no-undo.
    def input  param p-parcela       as char    no-undo.
    def input  param p-dt-vencimen   as date    no-undo.
    def var          h-boad362       as handle  no-undo.

    for each contr-titulo-exp where contr-titulo-exp.ep-codigo    = p-ep-codigo
                              and   contr-titulo-exp.cod-emitente = p-cod-fornec
                              and   contr-titulo-exp.cod-estabel  = p-cod-estabel
                              and   contr-titulo-exp.cod-esp      = p-cod-esp
                              and   contr-titulo-exp.serie        = p-serie
                              and   contr-titulo-exp.nr-docto     = p-nr-docto
                              and   contr-titulo-exp.parcela      = p-parcela EXCLUSIVE-LOCK:

        if not valid-handle(h-boad362) then
            run adbo/boad362.p persistent set h-boad362.

        run pi-atualiza-historico2 in h-boad362 (input contr-titulo-exp.ep-codigo,
                                                 input contr-titulo-exp.cod-estabel,
                                                 input contr-titulo-exp.referencia,
                                                 input contr-titulo-exp.dt-referencia,
                                                 input "Data de Vencimento",
                                                 input string(contr-titulo-exp.dt-vencimen),
                                                 input string(p-dt-vencimen),
                                                 input contr-titulo-exp.nr-docto,
                                                 input contr-titulo-exp.serie,
                                                 input contr-titulo-exp.cod-esp,
                                                 input contr-titulo-exp.cod-emitente).
        assign contr-titulo-exp.dt-vencimen = p-dt-vencimen.
    end.

    if valid-handle(h-boad362) then
        delete procedure h-boad362.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-nr-proc-exp DBOProgram 
PROCEDURE pi-altera-nr-proc-exp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF "{&mguni_version}" >= "2.07A" &THEN
    def input  param p-ep-codigo     LIKE empresa.ep-codigo no-undo.
&ELSE
    def input  param p-ep-codigo     as integer no-undo.
&ENDIF
    def input  param p-cod-estabel   as char    no-undo.
    def input  param p-cod-esp       as char    no-undo.
    def input  param p-serie         as char    no-undo.
    def input  param p-nr-docto      as char    no-undo.
    def input  param p-parcela       as char    no-undo.
    def INPUT  param p-nr-proc       as CHAR    no-undo.
    
    FOR EACH  contr-titulo-exp EXCLUSIVE-LOCK
        where contr-titulo-exp.ep-codigo    = p-ep-codigo
          and contr-titulo-exp.cod-estabel  = p-cod-estabel 
          and contr-titulo-exp.cod-esp      = p-cod-esp
          and contr-titulo-exp.serie        = p-serie
          and contr-titulo-exp.nr-docto     = p-nr-docto
          and contr-titulo-exp.parcela      = p-parcela:

        &IF "{&mgadm_version}":U < "2.06":U &THEN
            ASSIGN contr-titulo-exp.char-1      = p-nr-proc.
        &ELSE
            ASSIGN contr-titulo-exp.nr-proc-exp = p-nr-proc.
        &ENDIF
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-an DBOProgram 
PROCEDURE pi-atualiza-an :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-referencia   AS CHAR NO-UNDO.
    DEF INPUT PARAM p-dt-referncia AS DATE NO-UNDO.
    DEF INPUT PARAM TABLE FOR tt-lin-i-cr.

    FOR EACH tt-lin-i-cr-1 NO-LOCK:
        DELETE tt-lin-i-cr-1.
    END.
    FOR EACH tt-lin-i-cr NO-LOCK:
        CREATE tt-lin-i-cr-1.
        BUFFER-COPY tt-lin-i-cr TO tt-lin-i-cr-1.
    END.
    
    RUN pi-atualiza-an-1(INPUT p-referencia,
                         INPUT p-dt-referncia,
                         INPUT TABLE tt-lin-i-cr-1).

    RETURN "OK":U.
END PROCEDURE. /* fim pi-seleciona-titulos */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-an DBOProgram 
PROCEDURE pi-atualiza-an-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-referencia   AS CHAR NO-UNDO.
    DEF INPUT PARAM p-dt-referncia AS DATE NO-UNDO.
    DEF INPUT PARAM TABLE FOR tt-lin-i-cr-1.

    FOR EACH tt-lin-i-cr-1:
        find contr-titulo-exp
             where contr-titulo-exp.ep-codigo     = tt-lin-i-cr-1.ep-codigo
             and   contr-titulo-exp.cod-estabel   = tt-lin-i-cr-1.cod-estabel
             and   contr-titulo-exp.referencia    = p-referencia
             and   contr-titulo-exp.dt-referencia = p-dt-referncia
             and   contr-titulo-exp.cod-emitente  = tt-lin-i-cr-1.cod-emitente
             and   contr-titulo-exp.cod-esp       = tt-lin-i-cr-1.cod-esp
             and   contr-titulo-exp.serie         = tt-lin-i-cr-1.serie
             and   contr-titulo-exp.nr-docto      = tt-lin-i-cr-1.nr-docto
             and   contr-titulo-exp.parcela       = tt-lin-i-cr-1.parcela EXCLUSIVE-LOCK no-error.
        IF AVAIL contr-titulo-exp THEN
            ASSIGN contr-titulo-exp.log-2 = NO.
    END.

    RETURN "OK":U.
END PROCEDURE. /* fim pi-seleciona-titulos */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-campos DBOProgram 
PROCEDURE pi-atualiza-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param table for tt-contr-titulo-exp.
   def input param p-r-rowid as rowid no-undo.

   assign ro-rowid = p-r-rowid.

   RUN openQueryMain in this-procedure no-error.
   run repositionRecord in this-procedure (input p-r-rowid).

   run updateRecord in this-procedure.

   return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-fluxo DBOProgram 
PROCEDURE pi-atualiza-fluxo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-ep-codigo     like contr-titulo-exp.ep-codigo     no-undo.
    def input param p-cod-estabel   like contr-titulo-exp.cod-estabel   no-undo.
    def input param p-referencia    like contr-titulo-exp.referencia    no-undo.
    def input param p-dt-referencia like contr-titulo-exp.dt-referencia no-undo.
    def input param p-cod-emitente  like contr-titulo-exp.cod-emitente  no-undo.
    def input param p-cod-esp       like contr-titulo-exp.cod-esp       no-undo.
    def input param p-serie         like contr-titulo-exp.serie         no-undo.
    def input param p-nr-docto      like contr-titulo-exp.nr-docto      no-undo.
    def input param p-parcela       like contr-titulo-exp.parcela       no-undo.
    def input param p-dt-vinculado  like contr-titulo-exp.dt-vinculado  no-undo.
    def input param p-fluxo         like contr-titulo-exp.l-fluxo-caixa no-undo.

    def buffer b-contr-titulo-exp for contr-titulo-exp.

    find b-contr-titulo-exp
         where b-contr-titulo-exp.ep-codigo = p-ep-codigo and
               b-contr-titulo-exp.cod-estabel = p-cod-estabel and
               b-contr-titulo-exp.referencia = p-referencia and
               b-contr-titulo-exp.dt-referencia = p-dt-referencia and
               b-contr-titulo-exp.cod-emitente  = p-cod-emitente and
               b-contr-titulo-exp.cod-esp = p-cod-esp and
               b-contr-titulo-exp.serie = p-serie and
               b-contr-titulo-exp.nr-docto = p-nr-docto and
               b-contr-titulo-exp.parcela = p-parcela and
               b-contr-titulo-exp.dt-vinculado = p-dt-vinculado EXCLUSIVE-LOCK NO-ERROR.
    if avail b-contr-titulo-exp then do:
       assign b-contr-titulo-exp.l-fluxo-caixa = p-fluxo.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-fluxo-ems5 DBOProgram 
PROCEDURE pi-atualiza-fluxo-ems5 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param p-ep-codigo     like contr-titulo-exp.ep-codigo     no-undo.
    def input param p-cod-estabel   like contr-titulo-exp.cod-estabel   no-undo.
    def input param p-referencia    like contr-titulo-exp.referencia    no-undo.
    def input param p-dt-referencia like contr-titulo-exp.dt-referencia no-undo.
    def input param p-cod-emitente  like contr-titulo-exp.cod-emitente  no-undo.
    def input param p-cod-esp       like contr-titulo-exp.cod-esp       no-undo.
    def input param p-serie         like contr-titulo-exp.serie         no-undo.
    def input param p-nr-docto      like contr-titulo-exp.nr-docto      no-undo.
    def input param p-parcela       like contr-titulo-exp.parcela       no-undo.
    def input param p-dt-vinculado  like contr-titulo-exp.dt-vinculado  no-undo.
    def input param p-fluxo         like contr-titulo-exp.l-fluxo-caixa no-undo.

    def buffer b-contr-titulo-exp for contr-titulo-exp.

    find b-contr-titulo-exp
         where b-contr-titulo-exp.ep-codigo = p-ep-codigo and
               b-contr-titulo-exp.cod-estabel = p-cod-estabel and
               b-contr-titulo-exp.referencia = p-referencia and
               b-contr-titulo-exp.dt-referencia = p-dt-referencia and
               b-contr-titulo-exp.cod-emitente  = p-cod-emitente and
               b-contr-titulo-exp.cod-esp = p-cod-esp and
               b-contr-titulo-exp.serie = p-serie and
               b-contr-titulo-exp.nr-docto = p-nr-docto and
               b-contr-titulo-exp.parcela = p-parcela and
               b-contr-titulo-exp.dt-vinculado = p-dt-vinculado EXCLUSIVE-LOCK NO-ERROR.
    if avail b-contr-titulo-exp then do:
       assign b-contr-titulo-exp.l-fluxo-caixa = p-fluxo.
    end.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-saldo-titulo DBOProgram 
PROCEDURE pi-atualiza-saldo-titulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p-ep-codigo     like contr-titulo-exp.ep-codigo       no-undo.
    def input  param p-cod-estabel   like contr-titulo-exp.cod-estabel     no-undo.
    def input  param p-referencia    like contr-titulo-exp.referencia      no-undo.
    def input  param p-dt-referencia like contr-titulo-exp.dt-referencia   no-undo.
    def input  param p-cod-emitente  like contr-titulo-exp.cod-emitente    no-undo.
    def input  param p-cod-esp       like contr-titulo-exp.cod-esp         no-undo.
    def input  param p-serie         like contr-titulo-exp.serie           no-undo.
    def input  param p-nr-docto      like contr-titulo-exp.nr-docto        no-undo.
    def input  param p-parcela       like contr-titulo-exp.parcela         no-undo.
    def input  param p-vl-baixa      as   decimal format "->>>,>>>,>>9.99" no-undo.
    def input  param p-dt-vinculado  like contr-titulo-exp.dt-vinculado    no-undo.
    DEF INPUT  PARAM p-vl-baixa-mo-contrato AS DEC format "->>>,>>>,>>9.99" no-undo.
    def buffer bf-contr-titulo-exp   for  contr-titulo-exp.
    def var    h-boad362             as   handle no-undo.

    if p-dt-vinculado <> ? then do:
        find bf-contr-titulo-exp where bf-contr-titulo-exp.ep-codigo     = p-ep-codigo     and
                                       bf-contr-titulo-exp.cod-estabel   = p-cod-estabel   and
                                       bf-contr-titulo-exp.referencia    = p-referencia    and
                                       bf-contr-titulo-exp.dt-referencia = p-dt-referencia and
                                       bf-contr-titulo-exp.cod-emitente  = p-cod-emitente  and
                                       bf-contr-titulo-exp.cod-esp       = p-cod-esp       and
                                       bf-contr-titulo-exp.serie         = p-serie         and
                                       bf-contr-titulo-exp.nr-docto      = p-nr-docto      and
                                       bf-contr-titulo-exp.parcela       = p-parcela       and 
                                       bf-contr-titulo-exp.dt-vinculado  = p-dt-vinculado  exclusive-lock no-error.
    end.
    else do:
        find bf-contr-titulo-exp where bf-contr-titulo-exp.ep-codigo     = p-ep-codigo     and
                                       bf-contr-titulo-exp.cod-estabel   = p-cod-estabel   and
                                       bf-contr-titulo-exp.referencia    = p-referencia    and
                                       bf-contr-titulo-exp.dt-referencia = p-dt-referencia and
                                       bf-contr-titulo-exp.cod-emitente  = p-cod-emitente  and
                                       bf-contr-titulo-exp.cod-esp       = p-cod-esp       and
                                       bf-contr-titulo-exp.serie         = p-serie         and
                                       bf-contr-titulo-exp.nr-docto      = p-nr-docto      and
                                       bf-contr-titulo-exp.parcela       = p-parcela       exclusive-lock no-error.
    end.

    if  not avail bf-contr-titulo-exp then do:
        RETURN "NOK":U.
    end.
    assign bf-contr-titulo-exp.sl-liquidar-me = bf-contr-titulo-exp.sl-liquidar-me - p-vl-baixa.

    IF L-DESTINACAO THEN
        IF P-VL-BAIXA < 0 AND bf-contr-titulo-exp.situacao = 5 THEN
            ASSIGN bf-contr-titulo-exp.situacao = 1.

    IF  p-vl-baixa-mo-contrato <> 0 THEN do:
        IF l-funcao-arbitragem = YES THEN DO:
            RUN adbo/boad355.p persistent set h-boad355.
            run pi-verificar-produto in h-boad355 (output v-pagar,
                                                   output v-receber).
            delete procedure h-boad355.
        
            /* A pesquisa deve ser feita por estes campos, apesar de n∆o ser °ndice £nico, h† um tratamento para evitar duplicidade de registros via programa */
            find first bfcontrato-exp no-lock
                 where bfcontrato-exp.nr-contrato = bf-contr-titulo-exp.nr-contrato  
                   and bfcontrato-exp.dt-contrato = bf-contr-titulo-exp.dt-contrato NO-ERROR.
             
            IF  v-receber = "EMS 5" AND AVAIL bfcontrato-exp AND bfcontrato-exp.tp-contrato-exp = 3 THEN DO:
                ASSIGN bf-contr-titulo-exp.sl-liquidar-mo-contrato  = bf-contr-titulo-exp.sl-liquidar-mo-contrato - p-vl-baixa-mo-contrato.
            END.
        END.
    END.
    if not valid-handle(h-boad362) then
    run adbo/boad362.p persistent set h-boad362.

    run pi-atualiza-historico2 in h-boad362 (input bf-contr-titulo-exp.ep-codigo,
                                             input bf-contr-titulo-exp.cod-estabel,
                                             input bf-contr-titulo-exp.referencia,
                                             input bf-contr-titulo-exp.dt-referencia,
                                             input "Saldo Liquidar",
                                             input string(bf-contr-titulo-exp.sl-liquidar-me + p-vl-baixa ),
                                             input string(bf-contr-titulo-exp.sl-liquidar-me),
                                             input bf-contr-titulo-exp.nr-docto,
                                             input bf-contr-titulo-exp.serie,
                                             input bf-contr-titulo-exp.cod-esp,
                                             input bf-contr-titulo-exp.cod-emitente).

    if valid-handle(h-boad362) then
        delete procedure h-boad362.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-saldo-titulo-vinculado DBOProgram 
PROCEDURE pi-atualiza-saldo-titulo-vinculado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p-ep-codigo     like contr-titulo-exp.ep-codigo       no-undo.
    def input  param p-cod-estabel   like contr-titulo-exp.cod-estabel     no-undo.
    def input  param p-referencia    like contr-titulo-exp.referencia      no-undo.
    def input  param p-dt-referencia like contr-titulo-exp.dt-referencia   no-undo.
    def input  param p-cod-emitente  like contr-titulo-exp.cod-emitente    no-undo.
    def input  param p-cod-esp       like contr-titulo-exp.cod-esp         no-undo.
    def input  param p-serie         like contr-titulo-exp.serie           no-undo.
    def input  param p-nr-docto      like contr-titulo-exp.nr-docto        no-undo.
    def input  param p-parcela       like contr-titulo-exp.parcela         no-undo.
    def input  param p-vl-baixa      as   decimal format "->>>,>>>,>>9.99" no-undo.

    def buffer bf-contr-titulo-exp   for  contr-titulo-exp.
    def var    h-boad362           as   handle no-undo.


    find bf-contr-titulo-exp where bf-contr-titulo-exp.ep-codigo     = p-ep-codigo     and
                                   bf-contr-titulo-exp.cod-estabel   = p-cod-estabel   and
                                   bf-contr-titulo-exp.referencia    = p-referencia    and
                                   bf-contr-titulo-exp.dt-referencia = p-dt-referencia and
                                   bf-contr-titulo-exp.cod-emitente  = p-cod-emitente  and
                                   bf-contr-titulo-exp.cod-esp       = p-cod-esp       and
                                   bf-contr-titulo-exp.serie         = p-serie         and
                                   bf-contr-titulo-exp.nr-docto      = p-nr-docto      and
                                   bf-contr-titulo-exp.parcela       = p-parcela       exclusive-lock no-error.
    if  not avail bf-contr-titulo-exp then do:
        RETURN "NOK":U.
    end.
    assign bf-contr-titulo-exp.vl-vinculado-me = bf-contr-titulo-exp.vl-vinculado-me - p-vl-baixa.
    if not valid-handle(h-boad362) then
    run adbo/boad362.p persistent set h-boad362.
    run pi-atualiza-historico2 in h-boad362 (input bf-contr-titulo-exp.ep-codigo,
                                            input bf-contr-titulo-exp.cod-estabel,
                                            input bf-contr-titulo-exp.referencia,
                                            input bf-contr-titulo-exp.dt-referencia,
                                            input "Valor Vinculado",
                                            input string(bf-contr-titulo-exp.vl-vinculado-me + p-vl-baixa ),
                                            input string(bf-contr-titulo-exp.vl-vinculado-me ),
                                            input bf-contr-titulo-exp.nr-docto,
                                            input bf-contr-titulo-exp.serie,
                                            input bf-contr-titulo-exp.cod-esp,
                                            input bf-contr-titulo-exp.cod-emitente).
    if valid-handle(h-boad362) then
        delete procedure h-boad362.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-situacao DBOProgram 
PROCEDURE pi-atualiza-situacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-ep-codigo     like contr-titulo-exp.ep-codigo     no-undo.
    def input param p-cod-estabel   like contr-titulo-exp.cod-estabel   no-undo.
    def input param p-referencia    like contr-titulo-exp.referencia    no-undo.
    def input param p-dt-referencia like contr-titulo-exp.dt-referencia no-undo.
    def input param p-cod-emitente  like contr-titulo-exp.cod-emitente  no-undo.
    def input param p-cod-esp       like contr-titulo-exp.cod-esp       no-undo.
    def input param p-serie         like contr-titulo-exp.serie         no-undo.
    def input param p-nr-docto      like contr-titulo-exp.nr-docto      no-undo.
    def input param p-parcela       like contr-titulo-exp.parcela       no-undo.
    def input param p-dt-vinculado  like contr-titulo-exp.dt-vinculado  no-undo.
    def input param p-situacao      like contr-titulo-exp.situacao      no-undo.

    def buffer b-contr-titulo-exp2  for contr-titulo-exp.

    find b-contr-titulo-exp2
         where b-contr-titulo-exp2.ep-codigo = p-ep-codigo and
               b-contr-titulo-exp2.cod-estabel = p-cod-estabel and
               b-contr-titulo-exp2.referencia = p-referencia and
               b-contr-titulo-exp2.dt-referencia = p-dt-referencia and
               b-contr-titulo-exp2.cod-emitente  = p-cod-emitente and
               b-contr-titulo-exp2.cod-esp = p-cod-esp and
               b-contr-titulo-exp2.serie = p-serie and
               b-contr-titulo-exp2.nr-docto = p-nr-docto and
               b-contr-titulo-exp2.parcela = p-parcela and
               b-contr-titulo-exp2.dt-vinculado = p-dt-vinculado exclusive-lock no-error.
    if avail b-contr-titulo-exp2 then do:
       assign b-contr-titulo-exp2.situacao = p-situacao.
    end.

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
    {method/svc/autentic/autentic.i
            &vUserName="c-usuario"}

    assign RowObject.usuario  = c-usuario
           RowObject.c-time   = string(TIME, "HH:MM")
           RowObject.dt-today = today.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-contratos DBOProgram 
PROCEDURE pi-busca-contratos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*** Procedure utilizada no m¢dulo de cÉmbio ***/

    def input  param p-ep-codigo   like contr-titulo-exp.ep-codigo   no-undo.
    def input  param p-cod-estabel like contr-titulo-exp.cod-estabel no-undo.
    def input  param p-cod-esp     like contr-titulo-exp.cod-esp     no-undo.
    def input  param p-serie       like contr-titulo-exp.serie       no-undo.
    def input  param p-nr-docto    like contr-titulo-exp.nr-docto    no-undo.
    def input  param p-parcela     like contr-titulo-exp.parcela     no-undo.
    def output param table         for  tt-contratos.


            for each tt-contratos:
                delete tt-contratos.
            end.
            for each contr-titulo-exp
                where contr-titulo-exp.ep-codigo    = p-ep-codigo   and
                      contr-titulo-exp.cod-estabel  = p-cod-estabel and
                      contr-titulo-exp.cod-esp      = p-cod-esp     and
                      contr-titulo-exp.serie        = p-serie       and
                      contr-titulo-exp.nr-docto     = p-nr-docto    and
                      contr-titulo-exp.parcela      = p-parcela     no-lock:

                for each contrato-exp
                    where contrato-exp.nr-contrato   = contr-titulo-exp.nr-contrato     and
                          contrato-exp.dt-contrato   = contr-titulo-exp.dt-contrato  no-lock: 

                    find first tt-contratos no-lock
                        where tt-contratos.ep-codigo     = contr-titulo-exp.ep-codigo    
                        and   tt-contratos.cod-estabel   = contr-titulo-exp.cod-estabel  
                        and   tt-contratos.referencia    = contr-titulo-exp.referencia   
                        and   tt-contratos.dt-referencia = contr-titulo-exp.dt-referencia no-error.
                    if not avail tt-contratos then do:
                        create tt-contratos.
                        assign tt-contratos.ep-codigo      = contrato-exp.ep-codigo
                               tt-contratos.cod-estabel    = contrato-exp.cod-estabel
                               tt-contratos.referencia     = contrato-exp.referencia
                               tt-contratos.dt-referencia  = contrato-exp.dt-referencia
                               tt-contratos.nr-contrato    = contrato-exp.nr-contrato
                               tt-contratos.dt-contrato    = contrato-exp.dt-contrato
                               tt-contratos.cod-comprador  = contrato-exp.cod-comprador
                               tt-contratos.dt-liquidacao  = contrato-exp.dt-liquidacao
                               tt-contratos.vl-contrato-me = contrato-exp.vl-contrato-me
                               tt-contratos.r-rowid        = rowid(contrato-exp).

                        if  contrato-exp.situacao = 1 or contrato-exp.situacao = 9 then /* pendente de contrato ou liquidado sem contrato */       
                            assign tt-contratos.nr-contrato     = ''
                                   tt-contratos.dt-contrato     = ?.
                    end.
                end.
            end.
        RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-contratos-relacionados DBOProgram 
PROCEDURE pi-busca-contratos-relacionados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p-nr-contrato like contr-titulo-exp.nr-contrato. 
    def input  param p-dt-contrato like contr-titulo-exp.dt-contrato.
    def output param table for tt-contr-titulo-exp-ace.

    for each tt-contr-titulo-exp-ace:
        delete tt-contr-titulo-exp-ace.
    end.

    for each  contr-titulo-exp no-lock
        where contr-titulo-exp.nr-contrato = p-nr-contrato
          and contr-titulo-exp.dt-contrato = p-dt-contrato:

        create tt-contr-titulo-exp-ace.
        buffer-copy contr-titulo-exp to tt-contr-titulo-exp-ace.
    end.

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
&IF "{&mguni_version}" >= "2.07A" &THEN
    def output param p-ep-codigo LIKE empresa.ep-codigo no-undo.
&ELSE
    def output param p-ep-codigo as integer no-undo.
&ENDIF
&IF "{&mguni_version}" >= "2.07A" &THEN
    def var          i-ep-codigo LIKE empresa.ep-codigo no-undo.
&ELSE
    def var          i-ep-codigo as integer no-undo.
&ENDIF

    {method/svc/autentic/autentic.i
            &vUserEnterprise="i-ep-codigo"}

    assign p-ep-codigo = i-ep-codigo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-modul-exp DBOProgram
PROCEDURE pi-busca-modul-exp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param p-cod-return as char no-undo.

    def buffer b-param-global for param-global.

    find first b-param-global no-lock no-error.
    if avail b-param-global then do:
        if not b-param-global.modulo-ex then
            assign p-cod-return = "yes".
        else
            assign p-cod-return = "no".
    end.

    RETURN p-cod-return.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-rowid DBOProgram 
PROCEDURE pi-busca-rowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p-ep-codigo   like tt-contr-titulo-exp.ep-codigo   no-undo.
    def input  param p-cod-estabel like tt-contr-titulo-exp.cod-estabel no-undo.
    def input  param p-cod-esp     like tt-contr-titulo-exp.cod-esp     no-undo.
    def input  param p-serie       like tt-contr-titulo-exp.serie       no-undo.
    def input  param p-nr-docto    like tt-contr-titulo-exp.nr-docto    no-undo.
    def input  param p-parcela     like tt-contr-titulo-exp.parcela     no-undo.
    def output param r-titulo      as rowid                             no-undo.
    def output param r-mov-tit     as rowid                             no-undo.

    assign r-titulo  = ?
           r-mov-tit = ?.

    find first titulo use-index codigo
         where titulo.ep-codigo    = p-ep-codigo
         and   titulo.cod-estabel  = p-cod-estabel
         and   titulo.cod-esp      = p-cod-esp
         and   titulo.serie        = p-serie
         and   titulo.nr-docto     = p-nr-docto
         and   titulo.parcela      = p-parcela 
         no-lock no-error.
    if avail titulo then
        assign r-titulo = rowid(titulo).

    find first mov-tit use-index codigo
         where mov-tit.ep-codigo    = p-ep-codigo
         and   mov-tit.cod-estabel  = p-cod-estabel
         and   mov-tit.cod-esp      = p-cod-esp
         and   mov-tit.serie        = p-serie
         and   mov-tit.nr-docto     = p-nr-docto
         and   mov-tit.parcela      = p-parcela 
         no-lock no-error.
    if avail mov-tit then
        assign r-mov-tit = rowid(mov-tit).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-saldo-contrato DBOProgram 
PROCEDURE pi-busca-saldo-contrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF "{&mguni_version}" >= "2.07A" &THEN
    def input  param p-ep-codigo     LIKE empresa.ep-codigo no-undo.
&ELSE
    def input  param p-ep-codigo     as integer no-undo.
&ENDIF
    def input  param p-cod-estabel   as char    no-undo.
    def input  param p-cod-esp       as char    no-undo.
    def input  param p-serie         as char    no-undo.
    def input  param p-nr-docto      as char    no-undo.
    def input  param p-parcela       as char    no-undo.

    DEF OUTPUT PARAM p-val-sl-liquidar AS DECIMAL NO-UNDO.

    ASSIGN p-val-sl-liquidar = 0.

    FOR EACH contr-titulo-exp no-lock
        where contr-titulo-exp.ep-codigo   = p-ep-codigo
        and   contr-titulo-exp.cod-estabel = p-cod-estabel
        and   contr-titulo-exp.cod-esp     = p-cod-esp
        and   contr-titulo-exp.serie       = p-serie
        and   contr-titulo-exp.nr-docto    = p-nr-docto
        and   contr-titulo-exp.parcela     = p-parcela :
        assign p-val-sl-liquidar = p-val-sl-liquidar + contr-titulo-exp.sl-liquidar-me.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-saldo-liquidar-titulo DBOProgram 
PROCEDURE pi-busca-saldo-liquidar-titulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p-ep-codigo      like contr-titulo-exp.ep-codigo.
    def input  param p-cod-estabel    like contr-titulo-exp.cod-estabel.
    def input  param p-cod-emitente   like contr-titulo-exp.cod-emitente.
    def input  param p-cod-esp        like contr-titulo-exp.cod-esp.
    def input  param p-serie          like contr-titulo-exp.serie.
    def input  param p-nr-docto       like contr-titulo-exp.nr-docto.
    def input  param p-parcela        like contr-titulo-exp.parcela.
    def output param p-soma-vinculado as   decimal.

    def buffer bf-contr-titulo-exp2    for  contr-titulo-exp.

    assign p-soma-vinculado = 0.

    for each bf-contr-titulo-exp2
        where bf-contr-titulo-exp2.ep-codigo    = p-ep-codigo
        and   bf-contr-titulo-exp2.cod-estabel  = p-cod-estabel
        and   bf-contr-titulo-exp2.cod-emitente = p-cod-emitente
        and   bf-contr-titulo-exp2.cod-esp      = p-cod-esp
        and   bf-contr-titulo-exp2.serie        = p-serie
        and   bf-contr-titulo-exp2.nr-docto     = p-nr-docto
        and   bf-contr-titulo-exp2.parcela      = p-parcela no-lock:

        assign p-soma-vinculado = p-soma-vinculado + bf-contr-titulo-exp2.sl-liquidar-me.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-saldo-orig DBOProgram 
PROCEDURE pi-busca-saldo-orig :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p-ep-codigo      like contr-titulo-exp.ep-codigo.
    def input  param p-cod-estabel    like contr-titulo-exp.cod-estabel.
    def input  param p-cod-emitente   like contr-titulo-exp.cod-emitente.
    def input  param p-cod-esp        like contr-titulo-exp.cod-esp.
    def input  param p-serie          like contr-titulo-exp.serie.
    def input  param p-nr-docto       like contr-titulo-exp.nr-docto.
    def input  param p-parcela        like contr-titulo-exp.parcela.
    def output param p-moeda          as integer no-undo.
    def output param p-dt-vencimen    as date    no-undo.
    def output param p-vl-saldo-me    as decimal no-undo.
    def output param p-nr-proc-exp    as char    no-undo.
    def output param p-situacao       as integer no-undo.
    def output param p-val-comis      as decimal no-undo.

    define variable v-pagar as char no-undo. /* "EMS 2" ; "EMS 5" */
    define variable v-receber as char no-undo. /* "EMS 2" ; "EMS 5" */
    define variable h-boad355 as handle no-undo.
    define variable h-acr788za as handle no-undo.

    run adbo/boad355.p persistent set h-boad355.
    run pi-verificar-produto in h-boad355 (output v-pagar,
                                           output v-receber).
    delete procedure h-boad355.

    case v-receber :
    when "EMS 5" then do: /* busca saldo orig EMS 5.0 */

        /* Para tratar um erro decorrente da funá∆o <VINCUL-CARTA-MEC> a vari†vel h-btb009za est† sendo deletada.
           Caso seja necess†rio realizar a conexao, a include cd1202.i3 se encarrega de instancea-la para realizar processo.*/
        if valid-handle(h-btb009za) then
            DELETE PROCEDURE h-btb009za.

        {cdp/cd1202.i3 i-ep-codigo-usuario}

        if l-conec-bas = yes and l-conec-fin = yes and l-conec-uni = yes  then do:

            run prgfin/acr/acr788za.py persistent set h-acr788za.

            run pi_busca_saldo_titulo in h-acr788za (input p-ep-codigo,                           
                                                     input p-cod-estabel,                         
                                                     input p-cod-emitente, 
                                                     input p-cod-esp,      
                                                     input p-serie,        
                                                     input p-nr-docto,
                                                     input p-parcela,
                                                     output p-moeda,
                                                     output p-dt-vencimen,
                                                     output p-vl-saldo-me,
                                                     output p-nr-proc-exp,
                                                     output p-situacao,
                                                     output p-val-comis).

            delete procedure h-acr788za.

            {cdp/cd1202.i4 i-ep-codigo-usuario}

        end.
    end.
    end case.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-saldo-titulo DBOProgram 
PROCEDURE pi-busca-saldo-titulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p-ep-codigo      like contr-titulo-exp.ep-codigo.
    def input  param p-cod-estabel    like contr-titulo-exp.cod-estabel.
    def input  param p-cod-emitente   like contr-titulo-exp.cod-emitente.
    def input  param p-cod-esp        like contr-titulo-exp.cod-esp.
    def input  param p-serie          like contr-titulo-exp.serie.
    def input  param p-nr-docto       like contr-titulo-exp.nr-docto.
    def input  param p-parcela        like contr-titulo-exp.parcela.
    def output param p-soma-vinculado as   decimal.

    def buffer bf-contr-titulo-exp2    for  contr-titulo-exp.

    assign p-soma-vinculado = 0.

    for each bf-contr-titulo-exp2
        where bf-contr-titulo-exp2.ep-codigo    = p-ep-codigo
        and   bf-contr-titulo-exp2.cod-estabel  = p-cod-estabel
        and   bf-contr-titulo-exp2.cod-emitente = p-cod-emitente
        and   bf-contr-titulo-exp2.cod-esp      = p-cod-esp
        and   bf-contr-titulo-exp2.serie        = p-serie
        and   bf-contr-titulo-exp2.nr-docto     = p-nr-docto
        and   bf-contr-titulo-exp2.parcela      = p-parcela no-lock:

        assign p-soma-vinculado = p-soma-vinculado + bf-contr-titulo-exp2.vl-vinculado-me.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-titulo DBOProgram 
PROCEDURE pi-busca-titulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param v-ep-codigo   like titulo.ep-codigo.
    def input  param v-cod-estabel like titulo.cod-estabel.
    def input  param v-cod-esp     like titulo.cod-esp.
    def input  param v-serie       like titulo.serie.
    def input  param v-nr-docto    like titulo.nr-docto.
    def input  param v-parcela     like titulo.parcela.
    def output param v-rowid       as   rowid.

    find titulo where titulo.ep-codigo   = v-ep-codigo   and
                      titulo.cod-estabel = v-cod-estabel and
                      titulo.cod-esp     = v-cod-esp     and
                      titulo.serie       = v-serie       and
                      titulo.nr-docto    = v-nr-docto    and
                      titulo.parcela     = v-parcela     no-lock no-error.

    if avail titulo then do:
        assign v-rowid = rowid(titulo).
        RETURN "OK":U.
    end.

    RETURN "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-titulos DBOProgram 
PROCEDURE pi-busca-titulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param pInicod-estabel   like contr-titulo-exp.cod-estabel   no-undo.
   def input param pEndcod-estabel   like contr-titulo-exp.cod-estabel   no-undo.
   def input param pInireferencia    like contr-titulo-exp.referencia    no-undo.
   def input param pEndreferencia    like contr-titulo-exp.referencia    no-undo.
   def input param pInidt-referencia like contr-titulo-exp.dt-referencia no-undo.
   def input param pEnddt-referencia like contr-titulo-exp.dt-referencia no-undo.
   def input param pInicod-emitente  like contr-titulo-exp.cod-emitente  no-undo.
   def input param pEndcod-emitente  like contr-titulo-exp.cod-emitente  no-undo.
   def input param pIninr-contrato   like contr-titulo-exp.nr-contrato   no-undo.
   def input param pEndnr-contrato   like contr-titulo-exp.nr-contrato   no-undo.
   def input param pIninr-docto      like contr-titulo-exp.nr-docto      no-undo.
   def input param pEndnr-docto      like contr-titulo-exp.nr-docto      no-undo.
   def output param table for tt-digita.

   def var i-ep-codigo like contr-titulo-exp.ep-codigo no-undo.
   def var h-acomp as handle no-undo.

    {method/svc/autentic/autentic.i
            &vUserEnterprise="i-ep-codigo"}

   for each tt-digita:
      delete tt-digita.
   end.

   run utp/ut-acomp.p persistent set h-acomp.
   run pi-inicializar in h-acomp (input "Aguarde...").

   for each contr-titulo-exp
      where contr-titulo-exp.ep-codigo      = i-ep-codigo       and
            contr-titulo-exp.cod-estabel   >= pInicod-estabel   and
            contr-titulo-exp.cod-estabel   <= pEndcod-estabel   and
            contr-titulo-exp.referencia    >= pInireferencia    and
            contr-titulo-exp.referencia    <= pEndreferencia    and
            contr-titulo-exp.dt-referencia >= pInidt-referencia and
            contr-titulo-exp.dt-referencia <= pEnddt-referencia and
            contr-titulo-exp.cod-emitente  >= pInicod-emitente  and
            contr-titulo-exp.cod-emitente  <= pEndcod-emitente  and
            contr-titulo-exp.nr-contrato   >= pIninr-contrato   and
            contr-titulo-exp.nr-contrato   <= pEndnr-contrato   and
            contr-titulo-exp.nr-docto      >= pIninr-docto      and
            contr-titulo-exp.nr-docto      <= pEndnr-docto no-lock:

      create tt-digita.
      assign tt-digita.cod-estabel     = contr-titulo-exp.cod-estabel
             tt-digita.cod-esp         = contr-titulo-exp.cod-esp
             tt-digita.serie           = contr-titulo-exp.serie
             tt-digita.nr-docto        = contr-titulo-exp.nr-docto
             tt-digita.parcela         = contr-titulo-exp.parcela
             tt-digita.cod-emitente    = contr-titulo-exp.cod-emitente
             tt-digita.dt-vinculado    = contr-titulo-exp.dt-vinculado
             tt-digita.dt-vencto       = contr-titulo-exp.dt-vencimen
             tt-digita.sl-liquidar-me  = contr-titulo-exp.sl-liquidar-me
             tt-digita.vl-vinculado-me = contr-titulo-exp.vl-vinculado-me
             tt-digita.nr-contrato     = contr-titulo-exp.nr-contrato
             tt-digita.dt-contrato     = contr-titulo-exp.dt-contrato.

      find first contrato-exp no-lock
           where contrato-exp.nr-contrato = contr-titulo-exp.nr-contrato
           and   contrato-exp.dt-contrato = contr-titulo-exp.dt-contrato 
           use-index contrato no-error.

      if avail  contrato-exp  and 
        ( contrato-exp.situacao = 1 or  contrato-exp.situacao = 9)   then
            assign tt-digita.nr-contrato    = ''
                   tt-digita.dt-contrato    = ?.

      run pi-acompanhar in h-acomp (input tt-digita.nr-docto + "/" + tt-digita.parcela).
   end.
   run pi-finalizar in h-acomp.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cancela-devolve-titulo DBOProgram 
PROCEDURE pi-cancela-devolve-titulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param ind-can-dev     as   integer no-undo.
    def input  param p-ep-codigo     like contr-titulo-exp.ep-codigo.
    def input  param p-cod-estabel   like contr-titulo-exp.cod-estabel.
    def input  param p-cod-esp       like contr-titulo-exp.cod-esp.
    def input  param p-serie         like contr-titulo-exp.serie.
    def input  param p-nr-docto      like contr-titulo-exp.nr-docto.
    def input  param p-parcela       like contr-titulo-exp.parcela.
    def input  param p-referencia    like contr-titulo-exp.referencia.
    def input  param p-dt-referencia like contr-titulo-exp.dt-referencia.
    def input  param vl-reduzir      as   decimal no-undo.
    def input  param p-dt-vinculado  like contr-titulo-exp.dt-vinculado.

    def buffer bf-contr-titulo-exp for  contr-titulo-exp.
    def var    h-boad362           as   handle no-undo.

    find bf-contr-titulo-exp
         where bf-contr-titulo-exp.ep-codigo     = p-ep-codigo
         and   bf-contr-titulo-exp.cod-estabel   = p-cod-estabel
         and   bf-contr-titulo-exp.cod-esp       = p-cod-esp
         and   bf-contr-titulo-exp.serie         = p-serie
         and   bf-contr-titulo-exp.nr-docto      = p-nr-docto
         and   bf-contr-titulo-exp.parcela       = p-parcela
         and   bf-contr-titulo-exp.referencia    = p-referencia
         and   bf-contr-titulo-exp.dt-referencia = p-dt-referencia 
         and   bf-contr-titulo-exp.dt-vinculado  = p-dt-vinculado exclusive-lock no-error.
    if  avail bf-contr-titulo-exp then do:
        if ind-can-dev = 2 then do:  /** CANCELAMENTO **/
            if bf-contr-titulo-exp.vl-vinculado-me = vl-reduzir then do:
                &if "{&mgadm_version}":U >= "2.06B":U &then
                    for each bfcontrato-exp
                        where bfcontrato-exp.ep-codigo     = p-ep-codigo  
                          and bfcontrato-exp.cod-estabel   = p-cod-estabel
                          and bfcontrato-exp.referencia    = p-referencia   
                          and bfcontrato-exp.dt-referencia = p-dt-referencia no-lock:
                        assign i_cont_contr = 0.                                              
        
                        for each contr-titulo-exp
                            where contr-titulo-exp.nr-contrato = bfcontrato-exp.nr-contrato 
                              and contr-titulo-exp.dt-contrato = bfcontrato-exp.dt-contrato
                              and contr-titulo-exp.nr-proc-exp = bf-contr-titulo-exp.nr-proc-exp no-lock:
                            assign i_cont_contr = i_cont_contr + 1.
                        end.
                    end.
        
                    if i_cont_contr = 1 then do:
                        for each tt-proc-docto-export:
                            delete tt-proc-docto-export.
                        end.
                    
                        if not valid-handle(h-bocx346) then 
                            run cxbo/bocx346.p persistent set h-bocx346.
                    
                        run setConstraintOfProcExp in h-bocx346(input bf-contr-titulo-exp.cod-estabel,
                                                                input bf-contr-titulo-exp.nr-proc-exp).
                    
                        run openQueryStatic in h-bocx346(input "OfProcExp":U).
                    
                        run getBatchRecords  in h-bocx346(input  ?,
                                                          input  NO,
                                                          input  0, /* Retorna todos os resultados*/
                                                          output iRowsReturned,
                                                          output table tt-proc-docto-export).

                        if valid-handle(h-bocx346) then
                            delete procedure h-bocx346.
                    
                        for each contr-docto-exp
                            where contr-docto-exp.ep-codigo      = p-ep-codigo    
                            and   contr-docto-exp.cod-estabel    = p-cod-estabel  
                            and   contr-docto-exp.referencia     = p-referencia   
                            and   contr-docto-exp.dt-referencia  = p-dt-referencia exclusive-lock:
                    
                            case contr-docto-exp.ind-tipo-documento:
                                when 3 then
                                    assign i_nr_proc_exp = 2.
                                when 1 then
                                    assign i_nr_proc_exp = 3.
                                when 6 then
                                    assign i_nr_proc_exp = 4.
                                when 14 then
                                    assign i_nr_proc_exp = 5.
                                when 9 then
                                    assign i_nr_proc_exp = 10.
                                when 11 then
                                    assign i_nr_proc_exp = 11.
                            end case.
                            find first tt-proc-docto-export
                                where tt-proc-docto-export.cod-estabel   = contr-docto-exp.cod-estabel
                                  and tt-proc-docto-export.nr-proc-exp   = bf-contr-titulo-exp.nr-proc-exp
                                  and tt-proc-docto-export.data-emissao  = contr-docto-exp.dt-emissao
                                  and tt-proc-docto-export.hora-emissao  = contr-docto-exp.char-1
                                  and tt-proc-docto-export.idi-tip-docto = i_nr_proc_exp no-lock no-error.
                            if avail tt-proc-docto-export then do:
                                delete contr-docto-exp.
                            end.
                        end.
                    end.
                &endif                                        
                delete bf-contr-titulo-exp.
                

            end.
            else do:
                if not valid-handle(h-boad362) then
                    run adbo/boad362.p persistent set h-boad362.

                run pi-atualiza-historico2 in h-boad362 (input bf-contr-titulo-exp.ep-codigo,
                                                         input bf-contr-titulo-exp.cod-estabel,
                                                         input bf-contr-titulo-exp.referencia,
                                                         input bf-contr-titulo-exp.dt-referencia,
                                                         input "Saldo Liquidar",
                                                         input string(bf-contr-titulo-exp.sl-liquidar-me),
                                                         input string(bf-contr-titulo-exp.sl-liquidar-me - vl-reduzir),
                                                         input bf-contr-titulo-exp.nr-docto,
                                                         input bf-contr-titulo-exp.serie,
                                                         input bf-contr-titulo-exp.cod-esp,
                                                         input bf-contr-titulo-exp.cod-emitente).

                run pi-atualiza-historico2 in h-boad362 (input bf-contr-titulo-exp.ep-codigo,
                                                        input bf-contr-titulo-exp.cod-estabel,
                                                        input bf-contr-titulo-exp.referencia,
                                                        input bf-contr-titulo-exp.dt-referencia,
                                                        input "Valor Vinculado",
                                                        input string(bf-contr-titulo-exp.vl-vinculado-me),
                                                        input string(bf-contr-titulo-exp.vl-vinculado-me - vl-reduzir),
                                                        input bf-contr-titulo-exp.nr-docto,
                                                        input bf-contr-titulo-exp.serie,
                                                        input bf-contr-titulo-exp.cod-esp,
                                                        input bf-contr-titulo-exp.cod-emitente).

                assign bf-contr-titulo-exp.vl-vinculado-me = bf-contr-titulo-exp.vl-vinculado-me - vl-reduzir
                       bf-contr-titulo-exp.sl-liquidar-me  = bf-contr-titulo-exp.sl-liquidar-me  - vl-reduzir.

                {ecp/ec0005.i2 "bf-contr-titulo-exp"
                               "cod-moeda-cambial"
                               "vl-paridade-impl"
                               "vl-vincul-contrato"
                               "vl-saldo-liquidar-mo-contrato"}
                IF  cod-moeda-cambial <> 0
                AND cod-moeda-cambial <> ? THEN DO:
                    ASSIGN vl-vincul-contrato            = vl-vincul-contrato            - (vl-reduzir * vl-paridade-impl)
                           vl-saldo-liquidar-mo-contrato = vl-saldo-liquidar-mo-contrato - (vl-reduzir * vl-paridade-impl).
                    
                    {ecp/ec0005.i3 "bf-contr-titulo-exp"
                                   "vl-vincul-contrato"
                                   "vl-saldo-liquidar-mo-contrato"}

                END.                    
            end.
        end.

        if ind-can-dev = 3 then do:  /** DEVOLUCAO **/
            run adbo/boad362.p persistent set h-boad362.
            run pi-atualiza-historico in h-boad362 (input bf-contr-titulo-exp.ep-codigo,
                                                    input bf-contr-titulo-exp.cod-estabel,
                                                    input bf-contr-titulo-exp.referencia,
                                                    input bf-contr-titulo-exp.dt-referencia,
                                                    input "Situacao",
                                                    input string({adinc/i01ad347.i 04 bf-contr-titulo-exp.situacao}),
                                                    input string({adinc/i01ad347.i 04 3})).

            run pi-atualiza-historico in h-boad362 (input bf-contr-titulo-exp.ep-codigo,
                                                    input bf-contr-titulo-exp.cod-estabel,
                                                    input bf-contr-titulo-exp.referencia,
                                                    input bf-contr-titulo-exp.dt-referencia,
                                                    input "Fluxo de Caixa",
                                                    input string(bf-contr-titulo-exp.l-fluxo-caixa),
                                                    input "yes").

            assign bf-contr-titulo-exp.situacao       = 3
                   bf-contr-titulo-exp.l-fluxo-caixa  = yes.
        end.

        if ind-can-dev = 4 then do:  /** CANCELAMENTO COM DESEMBOLSO **/
            if bf-contr-titulo-exp.vl-vinculado-me = vl-reduzir then do:
                assign bf-contr-titulo-exp.sl-liquidar-me  = bf-contr-titulo-exp.sl-liquidar-me  - vl-reduzir.
            end.
            else do:
                if not valid-handle(h-boad362) then
                    run adbo/boad362.p persistent set h-boad362.

                run pi-atualiza-historico2 in h-boad362 (input bf-contr-titulo-exp.ep-codigo,
                                                         input bf-contr-titulo-exp.cod-estabel,
                                                         input bf-contr-titulo-exp.referencia,
                                                         input bf-contr-titulo-exp.dt-referencia,
                                                         input "Saldo Liquidar",
                                                         input string(bf-contr-titulo-exp.sl-liquidar-me),
                                                         input string(bf-contr-titulo-exp.sl-liquidar-me - vl-reduzir),
                                                         input bf-contr-titulo-exp.nr-docto,
                                                         input bf-contr-titulo-exp.serie,
                                                         input bf-contr-titulo-exp.cod-esp,
                                                         input bf-contr-titulo-exp.cod-emitente).

                run pi-atualiza-historico2 in h-boad362 (input bf-contr-titulo-exp.ep-codigo,
                                                        input bf-contr-titulo-exp.cod-estabel,
                                                        input bf-contr-titulo-exp.referencia,
                                                        input bf-contr-titulo-exp.dt-referencia,
                                                        input "Valor Vinculado",
                                                        input string(bf-contr-titulo-exp.vl-vinculado-me),
                                                        input string(bf-contr-titulo-exp.vl-vinculado-me - vl-reduzir),
                                                        input bf-contr-titulo-exp.nr-docto,
                                                        input bf-contr-titulo-exp.serie,
                                                        input bf-contr-titulo-exp.cod-esp,
                                                        input bf-contr-titulo-exp.cod-emitente).

                assign bf-contr-titulo-exp.sl-liquidar-me  = bf-contr-titulo-exp.sl-liquidar-me  - vl-reduzir.
            end.
            {ecp/ec0005.i2 "bf-contr-titulo-exp"
                           "cod-moeda-cambial"
                           "vl-paridade-impl"
                           "vl-vincul-contrato"
                           "vl-saldo-liquidar-mo-contrato"}
            IF  cod-moeda-cambial <> 0
            AND cod-moeda-cambial <> ? THEN DO:
                ASSIGN vl-vincul-contrato            = vl-vincul-contrato 
                       vl-saldo-liquidar-mo-contrato = vl-saldo-liquidar-mo-contrato - (vl-reduzir * vl-paridade-impl).
                
                {ecp/ec0005.i3 "bf-contr-titulo-exp"
                               "vl-vincul-contrato"
                               "vl-saldo-liquidar-mo-contrato"}
            END.
        end.
    end.

    if valid-handle (h-boad362) then
        delete procedure h-boad362.     

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-contratos DBOProgram 
PROCEDURE pi-carrega-contratos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
    ** FALTA DEFINIR QUAIS CAMPOS SERAO NECESSARIOS NA TT-CONTRATOS **

    def input  param p-chave-tit as  char no-undo.
    def output param table       for tt-contratos.

    def buffer b-contr-titulo-exp for contr-titulo-exp.

    for each b-contr-titulo-exp no-lock
        where b-contr-titulo-exp.cod-tit = p-tit:
        create tt-contratos.
        assign tt-contratos.campos = b-contr-titulo-exp.campos.
    end.

    RETURN "OK":U.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-fornec DBOProgram 
PROCEDURE pi-carrega-fornec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM v-nr-contrato LIKE contr-titulo-exp.nr-contrato NO-UNDO.
    DEF INPUT PARAM v-dt-contrato LIKE contr-titulo-exp.dt-contrato NO-UNDO.
    DEF INPUT-OUTPUT PARAM TABLE FOR tt-emitente.

    FOR EACH contr-titulo-exp WHERE contr-titulo-exp.nr-contrato = v-nr-contrato
                              AND   contr-titulo-exp.dt-contrato = v-dt-contrato NO-LOCK:
        FIND FIRST tt-emitente WHERE tt-emitente.cod-emitente = contr-titulo-exp.cod-emitente NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-emitente THEN DO:
            FIND FIRST b-emitente WHERE b-emitente.cod-emitente = contr-titulo-exp.cod-emitente NO-LOCK NO-ERROR.
            IF AVAIL b-emitente THEN DO:
                CREATE tt-emitente.
                BUFFER-COPY b-emitente TO tt-emitente.
            END.
        END.
    END.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-titulos DBOProgram 
PROCEDURE pi-carrega-titulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param table        for tt-titulos.

    def buffer b-contr-titulo-exp3 for contr-titulo-exp.

    for each b-contr-titulo-exp3 no-lock
        break by b-contr-titulo-exp3.nr-docto:
        if  first-of(b-contr-titulo-exp3.nr-docto) then do:
            create tt-titulos.
            buffer-copy b-contr-titulo-exp3 to tt-titulos.
        end.
    end.

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
    def input parameter table for tt-titulos-selecionados.

    def var v-diferenca  as decimal no-undo.
    def var v-retorno    as char    no-undo.
    def var l-atz-fluxo  as log     no-undo.
    def var i-ep-codigo  like contr-titulo-exp.ep-codigo     no-undo.
    DEF VAR i-seq-erro AS INTEGER NO-UNDO.

    /*VINVUL-CARTA-MEC*/
    DEFINE VARIABLE l-tp-contrato AS LOGICAL INITIAL YES NO-UNDO.

    assign v-diferenca = 0
           i-seq-erro  = 0.

    assign cQueryUseded = "Main".
    for each RowObject:
       delete RowObject.
    end.

    find first tt-titulos-selecionados no-lock no-error.
    if avail tt-titulos-selecionados then do:
    find  contrato-exp no-lock
        where contrato-exp.nr-contrato   = tt-titulos-selecionados.nr-contrato
          and contrato-exp.dt-contrato   = tt-titulos-selecionados.dt-contrato no-error.

        if not avail contrato-exp then do:
            {method/svc/errors/inserr.i
                       &ErrorNumber="19335"
                       &ErrorType="EMS"
                       &ErrorParameters="''"}
        end.
    end.

    for each tt-titulos-selecionados:

        if (contrato-exp.tp-contrato-exp = 3)
            and (contrato-exp.tp-emprestimo = 1 OR contrato-exp.tp-emprestimo = 3 OR contrato-exp.tp-emprestimo = 4) then do:
        
            FIND FIRST contr-titulo-exp 
                WHERE contr-titulo-exp.ep-codigo      = tt-titulos-selecionados.ep-codigo
                 AND   contr-titulo-exp.cod-estabel   = tt-titulos-selecionados.cod-estabel
                 AND   contr-titulo-exp.referencia    = tt-titulos-selecionados.ctr-referencia
                 AND   contr-titulo-exp.dt-referencia = tt-titulos-selecionados.dt-referencia
                 AND   contr-titulo-exp.cod-emitente  = tt-titulos-selecionados.cod-emitente
                 AND   contr-titulo-exp.cod-esp       = tt-titulos-selecionados.cod-esp
                 AND   contr-titulo-exp.serie         = tt-titulos-selecionados.serie
                 AND   contr-titulo-exp.nr-docto      = tt-titulos-selecionados.nr-docto
                 AND   contr-titulo-exp.parcela       = tt-titulos-selecionados.parcela
                 AND   contr-titulo-exp.dt-vinculado  = tt-titulos-selecionados.dt-vinculado EXCLUSIVE-LOCK no-error.
            if avail contr-titulo-exp then do: 
               run utp/ut-msgs.p (input "msg":u,
                                  INPUT 28454,
                                  INPUT string(tt-titulos-selecionados.dt-vinculado) + "~~" +
                                        string(tt-titulos-selecionados.ep-codigo)    + "~~" +
                                        string(tt-titulos-selecionados.cod-estabel)  + "~~" +                                      
                                        string(tt-titulos-selecionados.cod-emitente) + "~~" +  
                                        string(tt-titulos-selecionados.cod-esp)      + "~~" +       
                                        string(tt-titulos-selecionados.serie)        + "~~" +          
                                        string(tt-titulos-selecionados.nr-docto)     + "~~" +      
                                        string(tt-titulos-selecionados.parcela)).

               assign i-seq-erro = i-seq-erro + 10.
               create RowErrors.
               assign RowErrors.ErrorSequence    = i-seq-erro
                      RowErrors.ErrorNumber      = 28454
                      RowErrors.ErrorParameters  = ""
                      RowErrors.ErrorType        = "EMS"
                      RowErrors.ErrorSubType     = "ERROR"
                      RowErrors.ErrorDescription = return-value.


               run utp/ut-msgs.p (input "help":u,
                                  INPUT 28454,
                                  INPUT string(tt-titulos-selecionados.dt-vinculado) + "~~" +
                                        string(tt-titulos-selecionados.ep-codigo)    + "~~" +
                                        string(tt-titulos-selecionados.cod-estabel)  + "~~" +                                      
                                        string(tt-titulos-selecionados.cod-emitente) + "~~" +  
                                        string(tt-titulos-selecionados.cod-esp)      + "~~" +       
                                        string(tt-titulos-selecionados.serie)        + "~~" +          
                                        string(tt-titulos-selecionados.nr-docto)     + "~~" +      
                                        string(tt-titulos-selecionados.parcela)).

               assign RowErrors.ErrorHelp = return-value.
            end.
        END.
        ELSE DO:
            find contr-titulo-exp
                 where contr-titulo-exp.ep-codigo     = tt-titulos-selecionados.ep-codigo     
                 and   contr-titulo-exp.cod-estabel   = tt-titulos-selecionados.cod-estabel   
                 and   contr-titulo-exp.referencia    = tt-titulos-selecionados.ctr-referencia
                 and   contr-titulo-exp.dt-referencia = tt-titulos-selecionados.dt-referencia 
                 and   contr-titulo-exp.cod-emitente  = tt-titulos-selecionados.cod-emitente  
                 and   contr-titulo-exp.cod-esp       = tt-titulos-selecionados.cod-esp       
                 and   contr-titulo-exp.serie         = tt-titulos-selecionados.serie         
                 and   contr-titulo-exp.nr-docto      = tt-titulos-selecionados.nr-docto      
                 and   contr-titulo-exp.parcela       = tt-titulos-selecionados.parcela exclusive-lock no-error.
            if avail contr-titulo-exp then do:
                IF contr-titulo-exp.log-2 = NO THEN DO:
                    run utp/ut-msgs.p (input "msg",input 819,input "").
                    assign i-seq-erro = i-seq-erro + 10.
                    create RowErrors.
                    assign RowErrors.ErrorSequence    = i-seq-erro
                           RowErrors.ErrorNumber      = 819
                           RowErrors.ErrorParameters  = ""
                           RowErrors.ErrorType        = "EMS"
                           RowErrors.ErrorSubType     = "ERROR"
                           RowErrors.ErrorDescription = RETURN-VALUE.
                END.
                ELSE DO:
                    ASSIGN contr-titulo-exp.sl-liquidar-me  = tt-titulos-selecionados.de-vl-vinculado
                           contr-titulo-exp.vl-vinculado-me = tt-titulos-selecionados.de-vl-vinculado.
                    IF NUM-ENTRIES(contr-titulo-exp.char-2, ";") > 1 THEN
                       ASSIGN contr-titulo-exp.char-2       = contr-titulo-exp.char-2                   + ";" +
                                                              STRING(tt-titulos-selecionados.tp-codigo) + ";" +
                                                              tt-titulos-selecionados.conta-credito     + ";" +
                                                              tt-titulos-selecionados.char-1            + ";" +
                                                              tt-titulos-selecionados.char-2            + ";" +
                                                              STRING(tt-titulos-selecionados.int-1)     + ";" +
                                                              STRING(tt-titulos-selecionados.cod-unid-negoc) + ";" .
                    ELSE
                       ASSIGN contr-titulo-exp.char-2       = contr-titulo-exp.char-2                   + ";" +
                                                              "" + ";" +
                                                              "" + ";" +
                                                              "" + ";" +
                                                              STRING(tt-titulos-selecionados.tp-codigo) + ";" +
                                                              tt-titulos-selecionados.conta-credito     + ";" +
                                                              tt-titulos-selecionados.char-1            + ";" +
                                                              tt-titulos-selecionados.char-2            + ";" +
                                                              STRING(tt-titulos-selecionados.int-1)     + ";" +
                                                              STRING(tt-titulos-selecionados.cod-unid-negoc) + ";".

                    RETURN "OK":U.
                END.
            end.
        END.
    END.

    IF i-seq-erro <> 0 THEN
        RETURN 'NOK':U.

    IF l-funcao-arbitragem = YES THEN DO:

        RUN adbo/boad355.p persistent set h-boad355.
        run pi-verificar-produto in h-boad355 (output v-pagar,
                                               output v-receber).
        delete procedure h-boad355.

    END.
    
    for each tt-titulos-selecionados:
        create RowObject.
        assign RowObject.ep-codigo       = tt-titulos-selecionados.ep-codigo
               RowObject.cod-estabel     = tt-titulos-selecionados.cod-estabel
               RowObject.referencia      = tt-titulos-selecionados.ctr-referencia
               RowObject.dt-referencia   = tt-titulos-selecionados.dt-referencia
               RowObject.nr-contrato     = tt-titulos-selecionados.nr-contrato
               RowObject.dt-contrato     = tt-titulos-selecionados.dt-contrato
               RowObject.cod-emitente    = tt-titulos-selecionados.cod-emitente
               RowObject.serie           = tt-titulos-selecionados.serie
               RowObject.cod-esp         = tt-titulos-selecionados.cod-esp
               RowObject.nr-docto        = tt-titulos-selecionados.nr-docto
               RowObject.parcela         = tt-titulos-selecionados.parcela
               RowObject.dt-vencimen     = tt-titulos-selecionados.dt-vencimen
               RowObject.sl-liquidar-me  = tt-titulos-selecionados.de-vl-vinculado
               RowObject.vl-vinculado-me = tt-titulos-selecionados.de-vl-vinculado
               RowObject.prod-financ     = tt-titulos-selecionados.prod-financ.
        if not l-multi-an and contrato-exp.tp-contrato-exp = 2 then 
           assign RowObject.sl-liquidar-me = 0.

        if tt-titulos-selecionados.dt-vinculado <> ? then do:
            assign RowObject.dt-vinculado    = tt-titulos-selecionados.dt-vinculado.
        end.
        else do:
            find contrato-exp no-lock
               where contrato-exp.ep-codigo     = tt-titulos-selecionados.ep-codigo      and
                     contrato-exp.cod-estabel   = tt-titulos-selecionados.cod-estabel    AND
                     contrato-exp.referencia    = tt-titulos-selecionados.ctr-referencia and
                     contrato-exp.dt-referencia = tt-titulos-selecionados.dt-referencia  no-error.
            if avail contrato-exp then do:
                if contrato-exp.tp-contrato-exp <> 3 then
                    assign RowObject.dt-vinculado = contrato-exp.dt-contrato.
            end.
        end.
        
        IF l-funcao-arbitragem = YES THEN DO:
            IF  v-receber = "EMS 5" 
            AND (contrato-exp.tp-contrato-exp = 3) THEN DO:
                &IF "{&mgadm_version}":U < "2.06b":U &THEN
                     ASSIGN RowObject.char-2 = STRING(tt-titulos-selecionados.moeda) + ";" +
                                               STRING(tt-titulos-selecionados.vl-paridade) + ";" +
                                               STRING(tt-titulos-selecionados.de-vl-vinculado * tt-titulos-selecionados.vl-paridade, "-zzz,zzz,zzz,zz9.99") + ";" +
                                               STRING(tt-titulos-selecionados.de-vl-vinculado * tt-titulos-selecionados.vl-paridade, "-zzz,zzz,zzz,zz9.99") + ";".
                &else
                     ASSIGN RowObject.moeda                    = tt-titulos-selecionados.moeda
                            RowObject.vl-paridade              = tt-titulos-selecionados.vl-paridade
                            RowObject.vl-vinculado-mo-contrato = tt-titulos-selecionados.de-vl-vinculado * tt-titulos-selecionados.vl-paridade
                            RowObject.sl-liquidar-mo-contrato  = RowObject.vl-vinculado-mo-contrato.
                &endif
            END.
        END.

        /* SE FOR ANTECIPAÄ«O CRIA COMO PENDENTE PARA ATUALIZAR POSTERIORMENTE O ACR*/
        IF CONTRATO-EXP.TP-CONTRATO-EXP = 2 AND l-multi-an THEN DO:
            ASSIGN RowObject.log-2  = YES /*Pendente de atualizaá∆o*/.
            IF NUM-ENTRIES(RowObject.char-2,";") > 1 THEN
               ASSIGN RowObject.char-2 = RowObject.char-2 + ";" +
                                         STRING(tt-titulos-selecionados.tp-codigo) + ";" +
                                         tt-titulos-selecionados.conta-credito     + ";" +
                                         tt-titulos-selecionados.char-1            + ";" +
                                         tt-titulos-selecionados.char-2            + ";" +
                                         STRING(tt-titulos-selecionados.int-1)     + ";" +
                                         STRING(tt-titulos-selecionados.cod-unid-negoc) + ";".
            ELSE
              ASSIGN RowObject.char-2 = RowObject.char-2 + ";" +
                                        "" + ";" +
                                        "" + ";" +
                                        "" + ";" +
                                        STRING(tt-titulos-selecionados.tp-codigo) + ";" +
                                        tt-titulos-selecionados.conta-credito     + ";" +
                                        tt-titulos-selecionados.char-1            + ";" +
                                        tt-titulos-selecionados.char-2            + ";" +
                                        STRING(tt-titulos-selecionados.int-1)     + ";" +
                                        STRING(tt-titulos-selecionados.cod-unid-negoc) + ";".
        END.

        run createRecord in this-procedure.
    end.

    assign v-retorno = return-value.

    RETURN v-retorno.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina-antecipacao DBOProgram 
PROCEDURE pi-elimina-antecipacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define variable v-pagar   as char no-undo. 
define variable v-receber as char no-undo.
define variable c-ep-codigo like contr-titulo-exp.ep-codigo no-undo.
define variable h-boad355 as handle no-undo.

run adbo/boad355.p persistent set h-boad355.
run pi-verificar-produto in h-boad355 (output v-pagar,
                                       output v-receber).
delete procedure h-boad355.

    run pi-autenticacao in this-procedure.

    if  l-int-mec-ems5
    and v-receber = "EMS 5" 
    AND RowObject.situacao =  1 then do:
        assign c-ep-codigo = RowObject.ep-codigo
               i-seq-erro  = 0.

        /*** Conecta bases do EMS 5.0 ***/
        {ecp/ec0005b.i 1}

        /*** Verifica Erro na Conex∆o das Bases ***/
        {ecp/ec0005k.i}

        if i-seq-erro <> 0 then
            return "NOK":U.

        &IF "{&mguni_version}" <= "2.06B" &THEN
        assign v_cod_usuar_corren_old = v_cod_usuar_corren 
               v_cod_empres_usuar_old = v_cod_empres_usuar
               v_cod_usuar_corren     = ""
               v_cod_empres_usuar     = "".

        assign v_cod_grp_usuar_lst_old = v_cod_grp_usuar_lst
               v_cod_grp_usuar_lst     = "".
        
        /*** chama login do usuario ***/
        run prgtec/btb/btb906za.py.

        if v_cod_usuar_corren = "" or 
           v_cod_empres_usuar = "" then do:
            assign v_cod_usuar_corren = v_cod_usuar_corren_old 
                   v_cod_empres_usuar = v_cod_empres_usuar_old.
            
            assign v_cod_grp_usuar_lst = v_cod_grp_usuar_lst_old.
            return "NOK":U.
        end.
        
        assign v_cod_grp_usuar_lst = v_cod_grp_usuar_lst_old.
        &ENDIF
        
        for each   tt-linha-cr:
            delete tt-linha-cr.
        end.
        create tt-linha-cr.
        assign tt-linha-cr.ep-codigo    = RowObject.ep-codigo 
               tt-linha-cr.cod-estabel  = RowObject.cod-estabel
               tt-linha-cr.cod-esp      = RowObject.cod-esp
               tt-linha-cr.serie        = RowObject.serie
               tt-linha-cr.nr-docto     = RowObject.nr-docto
               tt-linha-cr.parcela      = RowObject.parcela
               tt-linha-cr.dt-transacao = RowObject.data-1.

        run prgfin~/acr~/acr913za.p(input  param-global.sc-format,
                                  input  table tt-docto-cr,
                                  input  table tt-linha-cr,
                                  output table tt_log_erro).

        find first tt_log_erro no-lock no-error.
        if avail tt_log_erro then do:
            /*** Desconecta bases do EMS 5.0 ***/
            {ecp/ec0005b.i 2}

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
            if i-seq-erro <> 0 then
               return "NOK":U.
        end.
        /*** Desconecta bases do EMS 5.0 ***/
        {ecp/ec0005b.i 2}

        if i-seq-erro <> 0 then
            return "NOK":U.

        &IF "{&mguni_version}" <= "2.06B" &THEN
        assign v_cod_usuar_corren = v_cod_usuar_corren_old 
               v_cod_empres_usuar = v_cod_empres_usuar_old.
        &ENDIF
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina-cambiais DBOProgram 
PROCEDURE pi-elimina-cambiais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-nr-contrato LIKE contr-titulo-exp.nr-contrato NO-UNDO.
    DEF INPUT PARAM p-dt-contrato LIKE contr-titulo-exp.dt-contrato NO-UNDO.
    
    DEF BUFFER b-contr-titulo FOR contr-titulo-exp.

    IF NOT VALID-HANDLE(h-boad391) THEN
        RUN adbo/boad391.p PERSISTENT SET h-boad391.

    FOR EACH contr-titulo-exp 
       WHERE contr-titulo-exp.nr-contrato = p-nr-contrato
       AND   contr-titulo-exp.dt-contrato = p-dt-contrato EXCLUSIVE-LOCK:

        RUN pi-estorna IN h-boad391 (INPUT contr-titulo-exp.ep-codigo,
                                     INPUT contr-titulo-exp.cod-estabel,
                                     INPUT contr-titulo-exp.referencia,
                                     INPUT contr-titulo-exp.dt-referencia,
                                     INPUT contr-titulo-exp.cod-emitente,
                                     INPUT contr-titulo-exp.cod-esp,
                                     INPUT contr-titulo-exp.serie,
                                     INPUT contr-titulo-exp.nr-docto,
                                     INPUT contr-titulo-exp.parcela,
                                     INPUT contr-titulo-exp.dt-vinculado,
                                     INPUT 0).
        
        FOR EACH b-contr-titulo
           WHERE b-contr-titulo.ep-codigo     = contr-titulo-exp.ep-codigo    
             and b-contr-titulo.cod-estabel   = contr-titulo-exp.cod-estabel  
             and b-contr-titulo.cod-emitente  = contr-titulo-exp.cod-emitente 
             and b-contr-titulo.cod-esp       = contr-titulo-exp.cod-esp      
             and b-contr-titulo.serie         = contr-titulo-exp.serie        
             and b-contr-titulo.nr-docto      = contr-titulo-exp.nr-docto     
             and b-contr-titulo.parcela       = contr-titulo-exp.parcela      EXCLUSIVE-LOCK:

            FIND FIRST contrato-exp NO-LOCK
                 WHERE contrato-exp.nr-contrato = b-contr-titulo.nr-contrato
                 AND   contrato-exp.dt-contrato = b-contr-titulo.dt-contrato
                 AND   contrato-exp.situacao    = 9 NO-ERROR.
            IF AVAIL contrato-exp THEN
                ASSIGN b-contr-titulo.situacao = 5.
        END.

        DELETE contr-titulo-exp.
    END.

    DELETE PROCEDURE h-boad391.
                               
    RETURN "OK":U.
END PROCEDURE. /* fim pi-seleciona-titulos */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina-operacao-financeira DBOProgram 
PROCEDURE pi-elimina-operacao-financeira :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var c-ep-codigo like contr-titulo-exp.ep-codigo no-undo.

    assign c-ep-codigo = RowObject.ep-codigo
           i-seq-erro  = 0.

    /*** Carrega bases do EMS 5.0 ***/
    {ecp/ec0005b.i 1}

    /*** Verifica Erro na Conex∆o das Bases ***/
    {ecp/ec0005k.i}

    if i-seq-erro <> 0 then
        RETURN "NOK":U.

    &IF "{&mguni_version}" <= "2.06B" &THEN
    assign v_cod_usuar_corren_old = v_cod_usuar_corren 
           v_cod_empres_usuar_old = v_cod_empres_usuar
           v_cod_usuar_corren     = ""
           v_cod_empres_usuar     = "".

    assign v_cod_grp_usuar_lst_old = v_cod_grp_usuar_lst
           v_cod_grp_usuar_lst     = "".
    
    /*** chama login do usuario ***/
    run prgtec/btb/btb906za.py.

    if v_cod_usuar_corren = "" or 
       v_cod_empres_usuar = "" then do:
        assign v_cod_usuar_corren = v_cod_usuar_corren_old 
               v_cod_empres_usuar = v_cod_empres_usuar_old.
        
       assign v_cod_grp_usuar_lst = v_cod_grp_usuar_lst_old.
       return "NOK":U.
    end.
    assign v_cod_grp_usuar_lst = v_cod_grp_usuar_lst_old.
    &ENDIF
    
    /** Elimina Emprestimo ACE **/
    run prgfin/apl/apl007zu.py (input 1,
                                input "Cancelamento",
                                input "EmprÇstimo",
                                input RowObject.num-id-operac-financ,
                                input "",
                                input "",
                                output table tt_log_erro).

    find first tt_log_erro no-lock no-error.
    if avail tt_log_erro then do:
        /*** Desconecta bases do EMS 5.0 ***/
        {ecp/ec0005b.i 2}

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

        if i-seq-erro <> 0 then
           return "NOK":U.
    end.

    if bfcontrato-exp.tp-emprestimo <> 2 then do:
        /** Busca Historico do Movimento de AVA do ACC **/
        find first contr-emprestimo no-lock 
             where contr-emprestimo.ep-codigo              = bfcontrato-exp.ep-codigo
             and   contr-emprestimo.cod-estabel            = bfcontrato-exp.cod-estabel
             and   contr-emprestimo.referencia             = bfcontrato-exp.referencia
             and   contr-emprestimo.dt-referencia          = bfcontrato-exp.dt-referencia
             and   contr-emprestimo.cod-banco-ems5         = bfcontrato-exp.cod-banco-ems5 
             and   contr-emprestimo.prod-financ            = bfcontrato-exp.prod-financ
             and   contr-emprestimo.operac-financ          = bfcontrato-exp.operac-financ
             and   contr-emprestimo.cod-banco-ems5-d       = RowObject.cod-banco-ems5
             and   contr-emprestimo.operac-financ-d        = RowObject.operac-financ
             and   contr-emprestimo.prod-financ-d          = RowObject.prod-financ
             and   contr-emprestimo.num-id-operac-financ-d = RowObject.num-id-operac-financ
             and   contr-emprestimo.transacao              = 13
             no-error.
        if avail contr-emprestimo and contr-emprestimo.num-seq-movto-operac-financ <> 0 then do:
            assign v-num-id-movto = contr-emprestimo.num-seq-movto-operac-financ.

           /** Elimina Movimento de AVA no ACC **/
           run prgfin/apl/apl007zu.py (input 1,
                                       input "Cancelamento",
                                       input "Movimento",
                                       input bfcontrato-exp.num-id-operac-financ,
                                       input v-num-id-movto,
                                       input "",
                                       output table tt_log_erro).
        end.

        /* fo vicunha nß 870895 Rafael */
        find first tt_log_erro no-lock no-error.
        if avail tt_log_erro then do:
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
        end.
        /* fo vicunha nß 870895 Rafael */
    end.

    /*** Desconecta bases do EMS 5.0 ***/
    {ecp/ec0005b.i 2}

    if i-seq-erro <> 0 then
       RETURN "NOK":U.

    &IF "{&mguni_version}" <= "2.06B" &THEN
    assign v_cod_usuar_corren = v_cod_usuar_corren_old 
           v_cod_empres_usuar = v_cod_empres_usuar_old.
    &ENDIF

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-empresa DBOProgram 
PROCEDURE pi-empresa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var i-ep-codigo like contr-titulo-exp.ep-codigo no-undo.
    def output param p-ep-codigo like contr-titulo-exp.ep-codigo.

    {method/svc/autentic/autentic.i
            &vUserEnterprise="i-ep-codigo"}

    assign p-ep-codigo = i-ep-codigo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-encontra-titulos DBOProgram 
PROCEDURE pi-encontra-titulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&IF "{&mguni_version}" >= "2.07A" &THEN
    def input param p-ep-codigo     LIKE empresa.ep-codigo                   no-undo.
&ELSE
    def input param p-ep-codigo     as int                   no-undo.
&ENDIF
    def input param pInicod-estabel like titulo.cod-estabel  no-undo.
    def input param pEndcod-estabel like titulo.cod-estabel  no-undo.
    def input param pInicod-esp     like titulo.cod-esp      no-undo.
    def input param pEndcod-esp     like titulo.cod-esp      no-undo.
    def input param pIniserie       like titulo.serie        no-undo.
    def input param pEndserie       like titulo.serie        no-undo.
    def input param pIninr-docto    like titulo.nr-docto     no-undo.
    def input param pEndnr-docto    like titulo.nr-docto     no-undo.
    def input param pIniparcela     like titulo.parcela      no-undo.
    def input param pEndparcela     like titulo.parcela      no-undo.
    def input param pInidt-vencimen like titulo.dt-vencimen  no-undo.
    def input param pEnddt-vencimen like titulo.dt-vencimen  no-undo.
    def input param pmo-codigo      like titulo.mo-codigo    no-undo.
    def input param pcod-cliente    like titulo.cod-emitente no-undo.
    def input param pIniproc-exp    like titulo.nr-proc-exp  no-undo.
    def input param pEndproc-exp    like titulo.nr-proc-exp  no-undo.
    def output param table for tt-titulo.

    for each tt-titulo:                          
       delete tt-titulo.
    end.
    FOR EACH tt-param-selecao-tit:
        DELETE tt-param-selecao-tit.
    END.

        
    {cdp/cd1202.i3 i-ep-codigo-usuario}
    if l-conec-bas = yes and l-conec-fin = yes and l-conec-uni = yes then do:

        CREATE tt-param-selecao-tit.
        ASSIGN tt-param-selecao-tit.estabelecimento-ini = pInicod-estabel
               tt-param-selecao-tit.estabelecimento-fim = pEndcod-estabel
               tt-param-selecao-tit.esp-ini             = pInicod-esp
               tt-param-selecao-tit.esp-fim             = pEndcod-esp
               tt-param-selecao-tit.cli-ini             = pcod-cliente
               tt-param-selecao-tit.cli-fim             = pcod-cliente
               tt-param-selecao-tit.docto-ini           = pIninr-docto
               tt-param-selecao-tit.docto-fim           = pEndnr-docto
               tt-param-selecao-tit.vencimen-ini        = pInidt-vencimen
               tt-param-selecao-tit.vencimen-fim        = pEnddt-vencimen
               tt-param-selecao-tit.prev-pag-ini        = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
               tt-param-selecao-tit.prev-pag-fim        = 12/31/9999.
        IF l-select-saque THEN DO:                   
            ASSIGN tt-param-selecao-tit.ind-tip-selec       = "Processo de Exportaá∆o"
                   tt-param-selecao-tit.nr-proc-exp-ini     = pIniproc-exp
                   tt-param-selecao-tit.nr-proc-exp-fim     = pEndproc-exp.
        END.
        ELSE DO:
            ASSIGN tt-param-selecao-tit.ind-tip-selec       = "T°tulo"
                   tt-param-selecao-tit.nr-proc-exp-ini     = ""
                   tt-param-selecao-tit.nr-proc-exp-fim     = "ZZZZZZZZZZZZ".
        END.
        run prgfin/acr/acr788za.py persistent set h-acr788za.
        RUN pi_indica_emissao_saque IN h-acr788za (INPUT YES).
        run pi_seleciona_titulos_cambio_acr in h-acr788za (input p-ep-codigo,
                                                           INPUT "",
                                                           input 12/31/9999,
                                                           input pmo-codigo,
                                                           input table tt-param-selecao-tit,
                                                           INPUT d-dt-emissao,
                                                           output table tt_tit_acr_ems5,
                                                           INPUT NO).
        RUN pi_output_tt_tit_acr_dat_emissao IN h-acr788za (OUTPUT TABLE tt_tit_acr_dat_emissao).
        delete procedure h-acr788za.
        for each tt_tit_acr_ems5
            WHERE tt_tit_acr_ems5.cod_ser_docto >= pIniserie
              AND tt_tit_acr_ems5.cod_ser_docto <= pEndserie
              AND tt_tit_acr_ems5.cod_parcela   >= pIniparcela
              AND tt_tit_acr_ems5.cod_parcela   <= pEndparcela:

            FIND FIRST tt_tit_acr_dat_emissao
                WHERE tt_tit_acr_dat_emissao.tta_cod_estab       = tt_tit_acr_ems5.cod_estab
                  AND tt_tit_acr_dat_emissao.tta_cod_espec_docto = tt_tit_acr_ems5.cod_espec_docto
                  AND tt_tit_acr_dat_emissao.tta_cod_ser_docto   = tt_tit_acr_ems5.cod_ser_docto
                  AND tt_tit_acr_dat_emissao.tta_cod_tit_acr     = tt_tit_acr_ems5.cod_tit_acr
                  AND tt_tit_acr_dat_emissao.tta_cod_parcela     = tt_tit_acr_ems5.cod_parcela NO-ERROR.


            CREATE tt-titulo.
            ASSIGN tt-titulo.cod-estabel    = tt_tit_acr_ems5.cod_estab
                   tt-titulo.cod-esp        = tt_tit_acr_ems5.cod_espec_docto
                   tt-titulo.serie          = tt_tit_acr_ems5.cod_ser_docto
                   tt-titulo.nr-docto       = tt_tit_acr_ems5.cod_tit_acr
                   tt-titulo.parcela        = tt_tit_acr_ems5.cod_parcela
                   tt-titulo.cod-emitente   = tt_tit_acr_ems5.cdn_cliente
                   tt-titulo.dt-emissao     = tt_tit_acr_dat_emissao.tta_dat_emis_docto
                   tt-titulo.dt-vencimen    = tt_tit_acr_ems5.dat_vencto_tit_acr
                   tt-titulo.vl-original-me = tt_tit_acr_dat_emissao.tta_val_origin_tit_acr
                   tt-titulo.vl-saldo-me    = tt_tit_acr_ems5.val_sdo_tit_acr.
        end.

        {cdp/cd1202.i4 i-ep-codigo-usuario} 
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-processo-exportacao DBOProgram 
PROCEDURE pi-processo-exportacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF input  param p-cod-estabel    like contr-titulo-exp.cod-estabel.
def input  param p-nr-proc-exp    like tt-contr-titulo-exp.nr-contrato.
DEF INPUT  PARAM p-serie          AS CHAR NO-UNDO.
DEF INPUT  PARAM p-nr-docto       AS CHAR no-undo.
DEF OUTPUT PARAM p-cod-erro       AS integer no-undo.

assign c-return = "".

if not valid-handle(h-bocx185) then
   run cxbo/bocx185.p persistent set h-bocx185.

run findPk_proc_exp_NF in h-bocx185 (input  p-cod-estabel, 
                                     input  p-nr-proc-exp,
                                     INPUT  p-serie,
                                     INPUT  p-nr-docto,
                                     output c-return).
if c-return = "" then do:
   run getcurrent in h-bocx185 (output table tt-processo-exp).

   find first tt-processo-exp no-lock no-error.
   if avail tt-processo-exp then do:
       assign gr-processo-exp = tt-processo-exp.r-rowid.
       run exp/ex3101.w.
   end.
end.
ELSE DO:
    ASSIGN p-cod-erro = 12291.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-paridade DBOProgram 
PROCEDURE pi-retorna-paridade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-cod-estabel    AS CHAR                            NO-UNDO.
    def input  param p-processo-exp   as char                            no-undo.
    DEF INPUT  PARAM p-moeda-contrato AS INT                             NO-UNDO.
    DEF INPUT  PARAM p-moeda-cambial  AS INT                             NO-UNDO.
    def output param p-paridade       as decimal format ">>9.9999999999" no-undo.
    
    DEF VAR data-processo AS DATE no-undo.
    DEF VAR p-empresa AS INT no-undo.
    DEF VAR d-cotacao-contrato AS DEC no-undo.
    DEF VAR d-cotacao-cambial  AS DEC no-undo.
    DEF VAR h-acr788 AS HANDLE no-undo.

    RUN pi-empresa (OUTPUT p-empresa).

    ASSIGN c-return = "".

    {cdp/cd1202.i3 p-empresa}
    if l-conec-bas = yes and l-conec-fin = yes and l-conec-uni = yes  then do:

        /* Procura data de embarque *******************************/
        if not valid-handle(h-bocx185) then
           run cxbo/bocx185.p persistent set h-bocx185.

        run findPk_proc_exp in h-bocx185 (input  p-cod-estabel,
                                          input  p-processo-exp,
                                          output c-return).
        if c-return = "" then do:
           run getcurrent in h-bocx185 (output table tt-processo-exp).
    
           find first tt-processo-exp no-lock no-error.
           if avail tt-processo-exp then do:
              assign data-processo = tt-processo-exp.dt-embarque.
           end.
        end.
        else do:
             for each RowErrors:
                 delete RowErrors.
             end.
             RUN utp/ut-msgs.p (input "msg":u, input 26109, input "").
    
             create RowErrors.
             assign RowErrors.ErrorSequence    = i-seq-erro
                    RowErrors.ErrorNumber      = 26109
                    RowErrors.ErrorParameters  = ""
                    RowErrors.ErrorType        = ""
                    RowErrors.ErrorSubType     = "ERROR"
                    RowErrors.ErrorDescription = return-value.
        end.
        
        /***********************************************************/
        /* Procura cotaá∆o das moedas na data de embarque **********/
        RUN prgfin/acr/acr788za.py persistent set h-acr788.
        RUN pi_retorna_cotacao IN h-acr788 (INPUT STRING(p-empresa),
                                            INPUT  p-cod-estabel,
                                            INPUT  P-MOEDA-cambial, /* indice */
                                            INPUT  P-MOEDA-contrato, /* base */
                                            INPUT  data-processo,
                                            OUTPUT d-cotacao-contrato).
        delete procedure h-acr788.

        ASSIGN p-paridade = d-cotacao-contrato.
        /***********************************************************/
        {cdp/cd1202.i4 p-empresa}
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-valor-a-vincular DBOProgram 
PROCEDURE pi-retorna-valor-a-vincular :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param v-ep-codigo   like contrato-exp.ep-codigo   no-undo.
    def input  param v-cod-estabel like contrato-exp.cod-estabel no-undo.
    def input  param v-nr-contrato like contrato-exp.nr-contrato no-undo.
    def input  param v-dt-contrato like contrato-exp.dt-contrato no-undo.
    def output param vl-a-liquidar-tit as   decimal.
    
    DEF VAR v-sl-liquidar-tit          AS DECIMAL NO-UNDO.

    def buffer bf-contr-titulo-exp5 for  contr-titulo-exp. 
    def buffer bf-contrato-exp      for  contrato-exp. 

    assign vl-a-liquidar-tit = 0.
    for each bf-contr-titulo-exp5
       where bf-contr-titulo-exp5.nr-contrato = v-nr-contrato
       and   bf-contr-titulo-exp5.dt-contrato = v-dt-contrato NO-LOCK:
       
       find first bfcontrato-exp no-lock
            where bfcontrato-exp.ep-codigo     = bf-contr-titulo-exp5.ep-codigo
              and bfcontrato-exp.cod-estabel   = bf-contr-titulo-exp5.cod-estabel
              and bfcontrato-exp.referencia    = bf-contr-titulo-exp5.referencia
              and bfcontrato-exp.dt-referencia = bf-contr-titulo-exp5.dt-referencia no-error.
       IF AVAIL bfcontrato-exp                               AND 
          bfcontrato-exp.tp-contrato-exp = 3                     AND 
          bf-contr-titulo-exp5.sl-liquidar-mo-contrato <> 0 THEN
          ASSIGN v-sl-liquidar-tit = bf-contr-titulo-exp5.sl-liquidar-mo-contrato.
       ELSE
          ASSIGN v-sl-liquidar-tit = bf-contr-titulo-exp5.sl-liquidar-me.
       
        assign vl-a-liquidar-tit = vl-a-liquidar-tit + v-sl-liquidar-tit.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PI-RETORNA-VINCULADO-MO-CONTRATO DBOProgram 
PROCEDURE PI-RETORNA-VINCULADO-MO-CONTRATO :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-referencia AS CHAR NO-UNDO.
    DEF INPUT PARAM p-dt-referencia AS DATE NO-UNDO.
    DEF INPUT PARAM p-dt-vinculado AS DATE NO-UNDO.
&IF "{&mguni_version}" >= "2.07A" &THEN
    DEF INPUT PARAM p-empresa LIKE empresa.ep-codigo   NO-UNDO.
&ELSE
    DEF INPUT PARAM p-empresa AS INT   NO-UNDO.
&ENDIF
    DEF INPUT PARAM p-estabel AS CHAR  NO-UNDO.
    DEF INPUT PARAM p-especie AS CHAR  NO-UNDO.
    DEF INPUT PARAM p-serie   AS CHAR  NO-UNDO.
    DEF INPUT PARAM p-nr-docto AS CHAR NO-UNDO.
    DEF INPUT PARAM p-parcela  AS CHAR NO-UNDO.
    DEF INPUT PARAM p-cliente  AS INT  NO-UNDO.
    DEF OUTPUT PARAM p-moeda   AS INT NO-UNDO.
    DEF OUTPUT PARAM p-paridade-impl AS DEC NO-UNDO.
    DEF OUTPUT PARAM p-valor-vinculado AS DEC  NO-UNDO.
    DEF OUTPUT PARAM p-saldo-liquidar-mo-contrato AS DEC NO-UNDO.

    DEF BUFFER bfcontr-titulo-exp FOR contr-titulo-exp.
    DEF BUFFER bfcontrato-exp     FOR contrato-exp.
        
    ASSIGN p-valor-vinculado            = 0
           p-saldo-liquidar-mo-contrato = 0.

    IF p-dt-vinculado <> ? THEN DO:
       FIND FIRST bfcontr-titulo-exp 
            WHERE bfcontr-titulo-exp.ep-codigo     = p-empresa
            AND   bfcontr-titulo-exp.cod-estabel   = p-estabel
            AND   bfcontr-titulo-exp.referencia    = p-referencia
            AND   bfcontr-titulo-exp.dt-referencia = p-dt-referencia
            AND   bfcontr-titulo-exp.cod-emitente  = p-cliente
            AND   bfcontr-titulo-exp.cod-esp       = p-especie
            AND   bfcontr-titulo-exp.serie         = p-serie
            AND   bfcontr-titulo-exp.nr-docto      = p-nr-docto
            AND   bfcontr-titulo-exp.parcela       = p-parcela
            AND   bfcontr-titulo-exp.dt-vinculado  = p-dt-vinculado NO-LOCK no-error.
    END.
    ELSE DO:
       FIND FIRST bfcontr-titulo-exp 
            WHERE bfcontr-titulo-exp.ep-codigo     = p-empresa
            AND   bfcontr-titulo-exp.cod-estabel   = p-estabel
            AND   bfcontr-titulo-exp.referencia    = p-referencia
            AND   bfcontr-titulo-exp.dt-referencia = p-dt-referencia
            AND   bfcontr-titulo-exp.cod-emitente  = p-cliente
            AND   bfcontr-titulo-exp.cod-esp       = p-especie
            AND   bfcontr-titulo-exp.serie         = p-serie
            AND   bfcontr-titulo-exp.nr-docto      = p-nr-docto
            AND   bfcontr-titulo-exp.parcela       = p-parcela NO-LOCK no-error.
    END.

    IF NOT AVAIL bfcontr-titulo-exp THEN DO:
       IF p-dt-vinculado <> ? THEN DO:
        FIND FIRST RowObject 
             WHERE RowObject.ep-codigo     = p-empresa
             AND   RowObject.cod-estabel   = p-estabel
             AND   RowObject.referencia    = p-referencia
             AND   RowObject.dt-referencia = p-dt-referencia
             AND   RowObject.cod-emitente  = p-cliente
             AND   RowObject.cod-esp       = p-especie
             AND   RowObject.serie         = p-serie
             AND   RowObject.nr-docto      = p-nr-docto
             AND   RowObject.parcela       = p-parcela
             AND   RowObject.dt-vinculado  = p-dt-vinculado NO-LOCK no-error.
       END.
       ELSE DO:
        FIND FIRST RowObject 
             WHERE RowObject.ep-codigo     = p-empresa
             AND   RowObject.cod-estabel   = p-estabel
             AND   RowObject.referencia    = p-referencia
             AND   RowObject.dt-referencia = p-dt-referencia
             AND   RowObject.cod-emitente  = p-cliente
             AND   RowObject.cod-esp       = p-especie
             AND   RowObject.serie         = p-serie
             AND   RowObject.nr-docto      = p-nr-docto
             AND   RowObject.parcela       = p-parcela NO-LOCK no-error.
       END.
    END.
    IF AVAIL RowObject 
    OR AVAIL bfcontr-titulo-exp THEN do:
        IF AVAIL RowObject THEN
            find FIRST bfcontrato-exp where
                 bfcontrato-exp.nr-contrato    = RowObject.nr-contrato and
                 bfcontrato-exp.dt-contrato    = RowObject.dt-contrato  NO-LOCK NO-ERROR.
        ELSE
            find FIRST bfcontrato-exp where
                 bfcontrato-exp.nr-contrato    = bfcontr-titulo-exp.nr-contrato and
                 bfcontrato-exp.dt-contrato    = bfcontr-titulo-exp.dt-contrato NO-LOCK NO-ERROR.

        IF l-funcao-arbitragem = YES THEN DO:
            RUN adbo/boad355.p persistent set h-boad355.
            run pi-verificar-produto in h-boad355 (output v-pagar,
                                                   output v-receber).
            delete procedure h-boad355.
            IF  v-receber = "EMS 5" THEN DO:
                &IF "{&mgadm_version}":U < "2.06b":U &THEN             
                    IF  NUM-ENTRIES(IF AVAIL RowObject THEN RowObject.char-2 ELSE bfcontr-titulo-exp.char-2,";") > 1 THEN do:
                        ASSIGN p-moeda                      = IF AVAIL RowObject THEN dec(ENTRY(1, RowObject.char-2, ";")) ELSE dec(ENTRY(1, bfcontr-titulo-exp.char-2, ";"))
                               p-paridade-impl              = IF AVAIL RowObject THEN dec(ENTRY(2, RowObject.char-2, ";")) ELSE dec(ENTRY(2, bfcontr-titulo-exp.char-2, ";")) 
                               p-valor-vinculado            = IF AVAIL RowObject THEN dec(ENTRY(3, RowObject.char-2, ";")) ELSE dec(ENTRY(3, bfcontr-titulo-exp.char-2, ";"))
                               p-saldo-liquidar-mo-contrato = IF AVAIL RowObject THEN dec(ENTRY(4, RowObject.char-2, ";")) ELSE dec(ENTRY(4, bfcontr-titulo-exp.char-2, ";")).
                    END.
                    ELSE 
                        ASSIGN p-moeda                      = bfcontrato-exp.moeda
                               p-paridade-impl              = 1
                               p-valor-vinculado            = IF AVAIL RowObject THEN RowObject.vl-vinculado-me ELSE bfcontr-titulo-exp.vl-vinculado-me
                               p-saldo-liquidar-mo-contrato = IF AVAIL RowObject THEN RowObject.sl-liquidar-me  ELSE bfcontr-titulo-exp.sl-liquidar-me.
                &else
                    IF AVAIL RowObject THEN do:                        
                        ASSIGN p-moeda           = RowObject.moeda
                               p-paridade-impl   = RowObject.vl-paridade
                               p-valor-vinculado = IF RowObject.vl-vinculado-mo-contrato <> 0 THEN RowObject.vl-vinculado-mo-contrato
                                             ELSE RowObject.vl-vinculado-me
                               p-saldo-liquidar-mo-contrato = IF RowObject.sl-liquidar-mo-contrato <> 0 THEN RowObject.sl-liquidar-mo-contrato
                                                         ELSE RowObject.sl-liquidar-me.
                    END.
                    ELSE
                        IF AVAIL bfcontr-titulo-exp THEN DO:
                            ASSIGN p-moeda           = bfcontr-titulo-exp.moeda
                                   p-paridade-impl   = bfcontr-titulo-exp.vl-paridade
                                   p-valor-vinculado = IF bfcontr-titulo-exp.vl-vinculado-mo-contrato <> 0 THEN bfcontr-titulo-exp.vl-vinculado-mo-contrato
                                                 ELSE bfcontr-titulo-exp.vl-vinculado-me
                                   p-saldo-liquidar-mo-contrato = IF bfcontr-titulo-exp.sl-liquidar-mo-contrato <> 0 THEN bfcontr-titulo-exp.sl-liquidar-mo-contrato
                                                             ELSE bfcontr-titulo-exp.sl-liquidar-me.
                        END.
                &endif
            END.
            ELSE
                ASSIGN p-moeda                      = bfcontrato-exp.moeda
                       p-paridade-impl              = 1
                       p-valor-vinculado            = IF AVAIL RowObject THEN RowObject.vl-vinculado-me ELSE bfcontr-titulo-exp.vl-vinculado-me
                       p-saldo-liquidar-mo-contrato = IF AVAIL RowObject THEN RowObject.sl-liquidar-me  ELSE bfcontr-titulo-exp.sl-liquidar-me.
        END.
        ELSE
            ASSIGN p-moeda                      = bfcontrato-exp.moeda
                   p-paridade-impl              = 1
                   p-valor-vinculado            = IF AVAIL RowObject THEN RowObject.vl-vinculado-me ELSE bfcontr-titulo-exp.vl-vinculado-me
                   p-saldo-liquidar-mo-contrato = IF AVAIL RowObject THEN RowObject.sl-liquidar-me  ELSE bfcontr-titulo-exp.sl-liquidar-me.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seleciona-titulos DBOProgram 
PROCEDURE pi-seleciona-titulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-ep-codigo       LIKE contrato-exp.ep-codigo NO-UNDO.
DEF INPUT PARAM p-cod-estabel     LIKE contrato-exp.cod-estabel NO-UNDO.
DEF input param p-moeda           like contrato-exp.moeda NO-UNDO.
def input param p-referencia      like contrato-exp.referencia NO-UNDO.
def input param p-dt-referencia   like contrato-exp.dt-referencia NO-UNDO.
def input param p-nr-contrato     like contrato-exp.nr-contrato NO-UNDO.
def input param p-dt-contrato     like contrato-exp.dt-contrato NO-UNDO.
def input param p-dt-cambiais     LIKE contrato-exp.dt-cambiais NO-UNDO.
def input param p-dt-liquidacao   like contrato-exp.dt-liquidacao NO-UNDO.
def input param table for tt-param-selecao-tit.
def output param table for tt-tit-acr-selecionados.

define variable v-pagar as char no-undo. /* "EMS 2" ; "EMS 5" */
define variable v-receber as char no-undo. /* "EMS 2" ; "EMS 5" */
define variable h-boad355 as handle no-undo.
define variable h-acr788za as handle no-undo.
define variable de-soma-vinculado as decimal no-undo.
define variable de-atualiza-saldo as decimal no-undo.
DEF VAR p-cliente-nacional AS LOG NO-UNDO.

run adbo/boad355.p persistent set h-boad355.
run pi-verificar-produto in h-boad355 (output v-pagar,
                                       output v-receber).
delete procedure h-boad355.

case v-receber :
    when "EMS 5" then do: /* busca saldo orig EMS 5.0 */


        {cdp/cd1202.i3 i-ep-codigo-usuario}
        if l-conec-bas = yes and l-conec-fin = yes and l-conec-uni = yes  then do:
            
            /* indica que o sistema deve trazer todos os t°tulos independente da moeda,
               e caso o contrato seja pronto, pode trazer cliente nacional */
            IF l-funcao-arbitragem THEN do:
                ASSIGN p-moeda = ?
                       p-cliente-nacional = NO. 
                find contrato-exp no-lock
                   where contrato-exp.ep-codigo     = p-ep-codigo
                    and  contrato-exp.referencia    = p-referencia
                    AND  contrato-exp.dt-referencia = p-dt-referencia no-error.
                IF  AVAIL contrato-exp 
                AND contrato-exp.tp-contrato-exp = 1 THEN /* pronto */
                    ASSIGN p-cliente-nacional = YES.
            END.
            run prgfin/acr/acr788za.py persistent set h-acr788za.
            run pi_seleciona_titulos_cambio_acr in h-acr788za (input p-ep-codigo,
                                                               INPUT p-cod-estabel,
                                                               input p-dt-liquidacao,
                                                               input p-moeda,
                                                               input table tt-param-selecao-tit,
                                                               INPUT p-dt-contrato,
                                                               output table tt_tit_acr_ems5,
                                                               INPUT p-cliente-nacional).
            delete procedure h-acr788za.
            tit_block:
            for each tt_tit_acr_ems5 no-lock:
                &IF "{&mguni_version}" >= "2.07A" &THEN
                IF p-ep-codigo <> tt_tit_acr_ems5.cod_empresa THEN DO:
                &ELSE
                IF p-ep-codigo <> int(tt_tit_acr_ems5.cod_empresa)THEN DO:
                &ENDIF
                    NEXT tit_block.
                END.

                ASSIGN de-soma-vinculado = 0.
                for each contr-titulo-exp where
                    &IF "{&mguni_version}" >= "2.07A" &THEN
                    contr-titulo-exp.ep-codigo    = tt_tit_acr_ems5.cod_empresa                    
                    &ELSE
                    contr-titulo-exp.ep-codigo    = int(tt_tit_acr_ems5.cod_empresa)
                    &ENDIF
                    and   contr-titulo-exp.cod-estabel  = tt_tit_acr_ems5.cod_estab
                    and   contr-titulo-exp.cod-emitente = tt_tit_acr_ems5.cdn_cliente
                    and   contr-titulo-exp.cod-esp      = tt_tit_acr_ems5.cod_espec_docto
                    and   contr-titulo-exp.serie        = tt_tit_acr_ems5.cod_ser_docto
                    and   contr-titulo-exp.nr-docto     = tt_tit_acr_ems5.cod_tit_acr
                    and   contr-titulo-exp.parcela      = tt_tit_acr_ems5.cod_parcela no-lock:
                    
                    find contrato-exp no-lock
                        where contrato-exp.ep-codigo     = contr-titulo-exp.ep-codigo    
                        and  contrato-exp.cod-estabel   = contr-titulo-exp.cod-estabel   
                        and  contrato-exp.referencia    = contr-titulo-exp.referencia    
                        and  contrato-exp.dt-referencia = contr-titulo-exp.dt-referencia no-error.

                    IF l-destinacao = yes
                    and (avail contrato-exp
                    and  contrato-exp.tp-contrato-exp <> 1)THEN DO:
                        /* AQUI CASO TENHA A FUNÄ«O DEVERµ BUSCAR OS MOVIMENTOS DO TITULO PARA FAZER O CALCULO */
                        FOR EACH movto-contrat-tit-export
                            WHERE movto-contrat-tit-export.cdn-empresa       = contr-titulo-exp.ep-codigo
                            AND   movto-contrat-tit-export.cod-estab         = contr-titulo-exp.cod-estabel
                            AND   movto-contrat-tit-export.cod-refer         = contr-titulo-exp.referencia
                            AND   movto-contrat-tit-export.dat-refer-contrat = contr-titulo-exp.dt-referencia
                            AND   movto-contrat-tit-export.cdn-emitente      = contr-titulo-exp.cod-emitente
                            AND   movto-contrat-tit-export.cod-espec-docto   = contr-titulo-exp.cod-esp
                            AND   movto-contrat-tit-export.cod-serie         = contr-titulo-exp.serie
                            AND   movto-contrat-tit-export.cod-docto         = contr-titulo-exp.nr-docto
                            AND   movto-contrat-tit-export.cod-parcela       = contr-titulo-exp.parcela
                            AND   (movto-contrat-tit-export.cdn-trans        = 1 
                            or     movto-contrat-tit-export.cdn-trans        = 9)
                            AND   movto-contrat-tit-export.log-estorno       = NO NO-LOCK:
                            
                            IF movto-contrat-tit-export.cod-contrat-cambio-orig <> "" 
                            AND movto-contrat-tit-export.cdn-trans = 1   THEN DO:
                                ASSIGN de-soma-vinculado = de-soma-vinculado - movto-contrat-tit-export.val-movto.
                            END.
                            IF movto-contrat-tit-export.cdn-trans        = 9 THEN
                                ASSIGN de-soma-vinculado = de-soma-vinculado + movto-contrat-tit-export.val-movto.
                        END.
                    END.
                    assign de-soma-vinculado = contr-titulo-exp.sl-liquidar-me + de-soma-vinculado.
                end.

                assign de-atualiza-saldo = tt_tit_acr_ems5.val_sdo_tit_acr - de-soma-vinculado.
                if  de-atualiza-saldo <> 0 then do:
                    create tt-tit-acr-selecionados.
                    assign &IF "{&mguni_version}" >= "2.07A" &THEN
                           tt-tit-acr-selecionados.ep-codigo = tt_tit_acr_ems5.cod_empresa
                           &ELSE
                           tt-tit-acr-selecionados.ep-codigo = int(tt_tit_acr_ems5.cod_empresa)
                           &ENDIF
                           tt-tit-acr-selecionados.cod-estabel = tt_tit_acr_ems5.cod_estab
                           tt-tit-acr-selecionados.ctr-referencia = p-referencia
                           tt-tit-acr-selecionados.dt-referencia = p-dt-referencia
                           tt-tit-acr-selecionados.nr-contrato = p-nr-contrato
                           tt-tit-acr-selecionados.dt-contrato = p-dt-contrato
                           tt-tit-acr-selecionados.cod-emitente = tt_tit_acr_ems5.cdn_cliente
                           tt-tit-acr-selecionados.serie = tt_tit_acr_ems5.cod_ser_docto
                           tt-tit-acr-selecionados.cod-esp = tt_tit_acr_ems5.cod_espec_docto
                           tt-tit-acr-selecionados.nr-docto = tt_tit_acr_ems5.cod_tit_acr
                           tt-tit-acr-selecionados.parcela = tt_tit_acr_ems5.cod_parcela
                           tt-tit-acr-selecionados.dt-vencimen = tt_tit_acr_ems5.dat_vencto_tit_acr
                           tt-tit-acr-selecionados.dt-pg-prev = tt_tit_acr_ems5.dat_prev_pagto
                           tt-tit-acr-selecionados.vl-saldo-me = de-atualiza-saldo
                           tt-tit-acr-selecionados.de-vl-vinculado = de-atualiza-saldo
                           tt-tit-acr-selecionados.nr-proc-exp = tt_tit_acr_ems5.nr-proc-exp
                           tt-tit-acr-selecionados.moeda       = tt_tit_acr_ems5.cod_indic_econ. 
                end.
            end.

            {cdp/cd1202.i4 i-ep-codigo-usuario} 
        end.
    end.
    end case.

    RETURN "OK":U.
END PROCEDURE. /* fim pi-seleciona-titulos */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seleciona-titulos-dest DBOProgram 
PROCEDURE pi-seleciona-titulos-dest :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-ep-codigo LIKE contr-titulo-exp.ep-codigo NO-UNDO.
    DEF INPUT PARAM p-cod-port  AS   INT NO-UNDO. 
    def output param table for tt-tit-acr-selecionados.

    DEF VAR v-destinado AS DEC NO-UNDO.
    DEF BUFFER b-movto-contrat-tit-export FOR movto-contrat-tit-export.

    FOR EACH tt-tit-acr-selecionados:
        DELETE tt-tit-acr-selecionados.
    END.
        
    for each contr-titulo-exp
        where contr-titulo-exp.ep-codigo    = p-ep-codigo
        and   contr-titulo-exp.situacao     = 5 no-lock:

        ASSIGN V-DESTINADO = 0.

        FIND FIRST b-movto-contrat-tit-export NO-LOCK
             WHERE b-movto-contrat-tit-export.cdn-empresa       = contr-titulo-exp.ep-codigo            
             AND   b-movto-contrat-tit-export.cod-estab         = contr-titulo-exp.cod-estabel
             AND   b-movto-contrat-tit-export.cod-refer         = contr-titulo-exp.referencia
             AND   b-movto-contrat-tit-export.dat-refer-contrat = contr-titulo-exp.dt-referencia
             AND   b-movto-contrat-tit-export.cdn-emitente      = contr-titulo-exp.cod-emitente
             AND   b-movto-contrat-tit-export.cod-espec-docto   = contr-titulo-exp.cod-esp
             AND   b-movto-contrat-tit-export.cod-serie         = contr-titulo-exp.serie
             AND   b-movto-contrat-tit-export.cod-docto         = contr-titulo-exp.nr-docto
             AND   b-movto-contrat-tit-export.cod-parcela       = contr-titulo-exp.parcela 
             AND   b-movto-contrat-tit-export.cdn-trans         = 2 
             AND   b-movto-contrat-tit-export.log-estorno       = NO NO-ERROR.
        IF AVAIL b-movto-contrat-tit-export AND b-movto-contrat-tit-export.cdn-portador <> p-cod-port THEN
            NEXT.
        
        /*DEVERA CRIA NA BO DE MOVIMENTOS UMA PI QUE BUSQUE ESSES VALORES COMO NO EXEMPLO ABAIXO
        N«O VAI PRECISAR POIS Jµ TEM OS DADOS NA TT-TITULOS-SELECIONADOS
        RUN pi-busca-dados-movto (INPUT tt-titulos-selecionados.ep-codigo,
                                  INPUT tt-titulos-selecionados.cod-estabel,
                                  INPUT tt-titulos-selecionados.cod-emitente,
                                  INPUT tt-titulos-selecionados.referencia,
                                  INPUT tt-titulos-selecionados.dt-referencia,
                                  INPUT tt-titulos-selecionados.cod-esp,
                                  INPUT tt-titulos-selecionados.serie,
                                  INPUT tt-titulos-selecionados.nr-docto,
                                  INPUT tt-titulos-selecionados.parcela,
                                  INPUT 2, /*Movimentos de Liquidaá∆o*/
                                  OUTPUT tt-movto-contrat-orig).
        */
        
        /* IPIRANGA - Aqui n∆o estava considerando o contrato na leitura da tabela, dai misturava a destinaÁ„o de um titulo com o outro */        
        /*VERIFICA VALOR DO TITULO Jµ DESTINADO A OUTROS CONTRATOS*/
        FOR EACH  b-movto-contrat-tit-export
            WHERE b-movto-contrat-tit-export.cdn-empresa       = contr-titulo-exp.ep-codigo            
            AND   b-movto-contrat-tit-export.cod-estab         = contr-titulo-exp.cod-estabel
            AND   b-movto-contrat-tit-export.cod-refer         = contr-titulo-exp.referencia
            AND   b-movto-contrat-tit-export.dat-refer-contrat = contr-titulo-exp.dt-referencia
            AND   b-movto-contrat-tit-export.cdn-emitente      = contr-titulo-exp.cod-emitente
            AND   b-movto-contrat-tit-export.cod-espec-docto   = contr-titulo-exp.cod-esp
            AND   b-movto-contrat-tit-export.cod-serie         = contr-titulo-exp.serie
            AND   b-movto-contrat-tit-export.cod-docto         = contr-titulo-exp.nr-docto
            AND   b-movto-contrat-tit-export.cod-parcela       = contr-titulo-exp.parcela
            /*** IPIRANGA - A data de vinculaá∆o do titulo Ç o today da vinculaá∆o ao pendente de contrato e a 
                 data do movimento Ç a data de vinculaá∆o da tela de destinaá∆o
            AND   b-movto-contrat-tit-export.dat-vinculac-tit  = contr-titulo-exp.dt-vinculado
            ***/
            AND   b-movto-contrat-tit-export.cdn-trans         = 3 
            AND   b-movto-contrat-tit-export.log-estorno       = NO NO-LOCK:

            ASSIGN v-destinado = v-destinado + b-movto-contrat-tit-export.val-movto.
        end.

        /*TITULO TOTALMENTO DESTINADO*/
        IF v-destinado = contr-titulo-exp.vl-vinculado-me THEN
            NEXT.

        {ecp/ec0005.i2 "contr-titulo-exp"
                       "cod-moeda-cambial"
                       "vl-paridade-impl"
                       "vl-vincul-contrato"
                       "vl-saldo-liquidar-mo-contrato"}

        create tt-tit-acr-selecionados.
        assign tt-tit-acr-selecionados.ep-codigo       = contr-titulo-exp.ep-codigo
               tt-tit-acr-selecionados.cod-estabel     = contr-titulo-exp.cod-estabel
               tt-tit-acr-selecionados.ctr-referencia  = contr-titulo-exp.referencia
               tt-tit-acr-selecionados.dt-referencia   = contr-titulo-exp.dt-referencia
               tt-tit-acr-selecionados.nr-contrato     = contr-titulo-exp.nr-contrato
               tt-tit-acr-selecionados.dt-contrato     = contr-titulo-exp.dt-contrato
               tt-tit-acr-selecionados.cod-emitente    = contr-titulo-exp.cod-emitente
               tt-tit-acr-selecionados.serie           = contr-titulo-exp.serie
               tt-tit-acr-selecionados.cod-esp         = contr-titulo-exp.cod-esp
               tt-tit-acr-selecionados.nr-docto        = contr-titulo-exp.nr-docto
               tt-tit-acr-selecionados.parcela         = contr-titulo-exp.parcela
               tt-tit-acr-selecionados.dt-vencimen     = contr-titulo-exp.dt-vencimen
               tt-tit-acr-selecionados.vl-saldo-me     = contr-titulo-exp.vl-vinculado-me - v-destinado
               tt-tit-acr-selecionados.nr-proc-exp     = &IF "{&mgadm_version}":U < "2.06":U &THEN
                                                            contr-titulo-exp.char-1
                                                        &ELSE
                                                            contr-titulo-exp.nr-proc-exp
                                                        &ENDIF
               tt-tit-acr-selecionados.de-vl-vinculado = contr-titulo-exp.vl-vinculado-me - v-destinado
               tt-tit-acr-selecionados.moeda           = cod-moeda-cambial
               tt-tit-acr-selecionados.vl-paridade     = 1
               tt-tit-acr-selecionados.dt-emissao      = contr-titulo-exp.dt-vinculado
               tt-tit-acr-selecionados.r-rowid         = ROWID(contr-titulo-exp). 
    END.

    RETURN "OK":U.
END PROCEDURE. /* fim pi-seleciona-titulos */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-set-data-emissao-saque DBOProgram 
PROCEDURE pi-set-data-emissao-saque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-dt-emissao AS DATE NO-UNDO.

    ASSIGN d-dt-emissao = p-dt-emissao.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-soma-saldo-titulos DBOProgram 
PROCEDURE pi-soma-saldo-titulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param v-ep-codigo   like contrato-exp.ep-codigo   no-undo.
    def input  param v-cod-estabel like contrato-exp.cod-estabel no-undo.
    def input  param v-nr-contrato like contrato-exp.nr-contrato no-undo.
    def input  param v-dt-contrato like contrato-exp.dt-contrato no-undo.
    DEF OUTPUT PARAM vl-titulos-mo-contrato AS DECIMAL.

    def buffer bf-contr-titulo-exp4 for  contr-titulo-exp. 
    
    DEF VAR vl-vincul AS DEC NO-UNDO.
    DEF VAR vl-saldo-1  AS DEC NO-UNDO.

    assign vl-saldo-1           = 0
           vl-titulos-mo-contrato = 0.
    for each bf-contr-titulo-exp4 
       where bf-contr-titulo-exp4.nr-contrato = v-nr-contrato
       and   bf-contr-titulo-exp4.dt-contrato = v-dt-contrato NO-LOCK:


        ASSIGN vl-saldo-1 = 0.

        {ecp/ec0005.i2 "bf-contr-titulo-exp4"
                       "cod-moeda-cambial"
                       "vl-paridade-impl"
                       "vl-vincul"
                       "vl-saldo-1"}

        ASSIGN vl-titulos-mo-contrato = vl-titulos-mo-contrato + vl-saldo-1.

    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-soma-titulos-contrato DBOProgram 
PROCEDURE pi-soma-titulos-contrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param v-ep-codigo   like contrato-exp.ep-codigo   no-undo.
    def input  param v-cod-estabel like contrato-exp.cod-estabel no-undo.
    def input  param v-nr-contrato like contrato-exp.nr-contrato no-undo.
    def input  param v-dt-contrato like contrato-exp.dt-contrato no-undo.
    def output param vl-titulos    as   decimal.

    def buffer bf-contr-titulo-exp4 for  contr-titulo-exp. 

    assign vl-titulos = 0.
    for each bf-contr-titulo-exp4 
       where bf-contr-titulo-exp4.nr-contrato = v-nr-contrato
       and   bf-contr-titulo-exp4.dt-contrato = v-dt-contrato NO-LOCK:
        assign vl-titulos = vl-titulos + bf-contr-titulo-exp4.vl-vinculado-me.
    end.

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
    def input param table for tt-contr-titulo-exp.
    def input param table for tt-contrato-exp.        
    def output param p-qtd-tit   as int format ">,>>>,>9":U no-undo.
    def output param p-vl-liquid as dec format "->>>,>>>,>>>,>>9.99":U no-undo.
    def output param p-vl-tot-vincul  as dec format "->>>,>>>,>>>,>>9.99":U no-undo.
    def output param p-vl-tot-vincul1 as dec format "->>>,>>>,>>>,>>9.99":U no-undo.
    def output param p-vl-tot-liquidado as dec format "->>>,>>>,>>>,>>9.99":U no-undo.
    def output param p-vl-sdo-avincul   as dec format "->>>,>>>,>>>,>>9.99":U no-undo.
    
    def var v-log-sdo-vincular as log init no no-undo.
    
    assign p-qtd-tit   = 0  
           p-vl-liquid = 0
           p-vl-tot-vincul  = 0
           p-vl-tot-vincul1 = 0
           p-vl-tot-liquidado = 0
           p-vl-sdo-avincul   = 0.
                              
    find first tt-contrato-exp no-error.
    for each tt-contr-titulo-exp:
        assign v-log-sdo-vincular = yes.
        if l-funcao-arbitragem then do:
            &if "{&mgadm_version}":U < "2.06B":U &then
                if  num-entries(tt-contr-titulo-exp.char-2,";") > 1 then
                    assign p-vl-tot-vincul1 = p-vl-tot-vincul1 + dec(entry(3, tt-contr-titulo-exp.char-2, ";"))
                           p-vl-liquid = p-vl-liquid + dec(entry(4, tt-contr-titulo-exp.char-2, ";")).
                else 
                    assign p-vl-tot-vincul1 = p-vl-tot-vincul1 + tt-contr-titulo-exp.vl-vinculado-me
                           p-vl-liquid = p-vl-liquid + tt-contr-titulo-exp.sl-liquidar-me.
            &else
                if  tt-contr-titulo-exp.moeda <> 0 then
                    assign p-vl-tot-vincul1 = p-vl-tot-vincul1 + tt-contr-titulo-exp.vl-vinculado-mo-contrato
                           p-vl-liquid      = p-vl-liquid + tt-contr-titulo-exp.sl-liquidar-mo-contrato.
                else
                    assign p-vl-tot-vincul1 = p-vl-tot-vincul1 + tt-contr-titulo-exp.vl-vinculado-me
                           p-vl-liquid     = p-vl-liquid + tt-contr-titulo-exp.sl-liquidar-me.
            &endif
        end.
        else
            assign p-vl-tot-vincul1 = p-vl-tot-vincul1 + tt-contr-titulo-exp.vl-vinculado-me
                   p-vl-liquid      = p-vl-liquid + tt-contr-titulo-exp.sl-liquidar-me.
        assign p-qtd-tit = p-qtd-tit + 1.
    end.

    if avail tt-contrato-exp then do:
       if tt-contrato-exp.tp-contrato-exp = 2 then do:
          if v-log-sdo-vincular then 
             assign p-vl-sdo-avincul = tt-contrato-exp.vl-contrato-me - p-vl-tot-vincul1. 
       end.
       else
          if  tt-contrato-exp.tp-contrato-exp = 1 and 
              tt-contrato-exp.situacao = 1 then 
              assign p-vl-sdo-avincul = 0.
          else 
              assign p-vl-sdo-avincul = tt-contrato-exp.vl-liquidar-me - p-vl-liquid.

       if tt-contrato-exp.tp-contrato-exp = 2 /*Antecipacao*/ then
           assign p-vl-tot-vincul = tt-contrato-exp.vl-contrato-me.
       else
           assign p-vl-tot-vincul = tt-contrato-exp.vl-liquidado-me + p-vl-liquid.       
              
    
       assign p-vl-tot-liquidado  = tt-contrato-exp.vl-liquidado-me.

       if p-vl-tot-liquidado < 0 then
          assign p-vl-tot-liquidado = p-vl-tot-liquidado * -1.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-totalizacao-1 DBOProgram 
PROCEDURE pi-totalizacao-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param table for tt-contr-titulo-exp.
    def input param table for tt-contrato-exp.
    def input param table for tt-param-totalizacao.
    def input param table for tt-emitente.
    def output param p-qtd-tit   as int format ">,>>>,>9":U no-undo.
    def output param p-vl-liquid as dec format "->>>,>>>,>>>,>>9.99":U no-undo.
    def output param p-vl-tot-vincul    as dec format "->>>,>>>,>>>,>>9.99":U no-undo.
    def output param p-vl-tot-liquidado as dec format "->>>,>>>,>>>,>>9.99":U no-undo.
    def output param p-vl-sdo-avincul   as dec format "->>>,>>>,>>>,>>9.99":U no-undo.

    def var v-log-sdo-vincular as log init no no-undo.

    assign p-qtd-tit   = 0  
           p-vl-liquid = 0
           p-vl-tot-vincul = 0  
           p-vl-tot-liquidado = 0
           p-vl-sdo-avincul   = 0.

    find first tt-contrato-exp no-error.
    find first tt-param-totalizacao no-error.
    if avail tt-param-totalizacao then do:
        IF AVAIL tt-contrato-exp THEN DO:
            for each b-contr-titulo-exp
                where &if "{&mgadm_version}":U < "2.06":U &then
                      b-contr-titulo-exp.char-1 >= tt-param-totalizacao.ttv-num-proc-ini
                  and b-contr-titulo-exp.char-1 <= tt-param-totalizacao.ttv-num-proc-fim
                      &else
                      b-contr-titulo-exp.nr-proc-exp >= tt-param-totalizacao.ttv-num-proc-ini
                  and b-contr-titulo-exp.nr-proc-exp <= tt-param-totalizacao.ttv-num-proc-fim
                      &endif
                  and b-contr-titulo-exp.cod-emitente >= tt-param-totalizacao.ttv-cliente-ini
                  and b-contr-titulo-exp.cod-emitente <= tt-param-totalizacao.ttv-cliente-fim
                  and b-contr-titulo-exp.dt-vencimen  >= tt-param-totalizacao.ttv-vencto-ini
                  and b-contr-titulo-exp.dt-vencimen  <= tt-param-totalizacao.ttv-vencto-fim 
                  and b-contr-titulo-exp.situacao     <> 2 
                  and b-contr-titulo-exp.referencia    = tt-contrato-exp.referencia
                  no-lock,
                first tt-emitente
                where tt-emitente.cod-emitente = b-contr-titulo-exp.cod-emitente
                  and tt-emitente.pais >= tt-param-totalizacao.ttv-pais-ini
                  and tt-emitente.pais <= tt-param-totalizacao.ttv-pais-fim no-lock:
                
                assign v-log-sdo-vincular = yes.
    
                if tt-param-totalizacao.ttv-tit-csa-saldo = 9 then do:
                    if l-funcao-arbitragem then do:
                        &if "{&mgadm_version}":U < "2.06B":U &then
                            if  num-entries(b-contr-titulo-exp.char-2,";") > 1 then
                                assign p-vl-liquid = p-vl-liquid + dec(entry(4, b-contr-titulo-exp.char-2, ";")).
                            else
                                assign p-vl-liquid = p-vl-liquid + b-contr-titulo-exp.sl-liquidar-me.
                        &else
                            if b-contr-titulo-exp.moeda <> 0 then
                               assign p-vl-liquid = p-vl-liquid + b-contr-titulo-exp.sl-liquidar-mo-contrato.
                            else
                               assign p-vl-liquid = p-vl-liquid + b-contr-titulo-exp.sl-liquidar-me.
                        &endif
                    end.
                    else
                        assign p-vl-liquid = p-vl-liquid + b-contr-titulo-exp.sl-liquidar-me.
                    assign p-qtd-tit = p-qtd-tit + 1.
                end.
                else do:
                    if (tt-param-totalizacao.ttv-tit-csa-saldo = 0
                    or (tt-param-totalizacao.ttv-tit-csa-saldo = 1 and b-contr-titulo-exp.sl-liquidar-me > 0)
                    or (tt-param-totalizacao.ttv-tit-csa-saldo = 2 and b-contr-titulo-exp.sl-liquidar-me = 0)) then do:
                        if l-funcao-arbitragem then do:
                            &if "{&mgadm_version}":U < "2.06B":U &then
                                if  num-entries(b-contr-titulo-exp.char-2,";") > 1 then
                                    assign p-vl-liquid = p-vl-liquid + dec(entry(4, b-contr-titulo-exp.char-2, ";")).
                                else
                                    assign p-vl-liquid = p-vl-liquid + b-contr-titulo-exp.sl-liquidar-me.
                            &else
                                if b-contr-titulo-exp.moeda <> 0 then
                                   assign p-vl-liquid = p-vl-liquid + b-contr-titulo-exp.sl-liquidar-mo-contrato.
                                else
                                   assign p-vl-liquid = p-vl-liquid + b-contr-titulo-exp.sl-liquidar-me.
                            &endif
                        end.
                        else
                            assign p-vl-liquid = p-vl-liquid + b-contr-titulo-exp.sl-liquidar-me.
                        assign p-qtd-tit = p-qtd-tit + 1.
                    end.
                end.
            end.
        END.
    end.
    IF AVAIL tt-contrato-exp THEN DO:
       ASSIGN p-vl-tot-liquidado  = tt-contrato-exp.vl-liquidado-me.
       IF p-vl-tot-liquidado < 0 THEN
          ASSIGN p-vl-tot-liquidado = p-vl-tot-liquidado * -1.

       if tt-contrato-exp.tp-contrato-exp = 2 THEN DO:
          if  v-log-sdo-vincular then
              ASSIGN p-vl-sdo-avincul = tt-contrato-exp.vl-contrato-me - p-vl-tot-liquidado.
       END.
       else
          if  tt-contrato-exp.tp-contrato-exp = 1
          and tt-contrato-exp.situacao = 1 then
              ASSIGN p-vl-sdo-avincul = 0.
          else
              ASSIGN p-vl-sdo-avincul = tt-contrato-exp.vl-liquidar-me - p-vl-liquid.
              
       
       if tt-contrato-exp.tp-contrato-exp = 2 /*Antecipacao*/ then
           assign p-vl-tot-vincul = tt-contrato-exp.vl-contrato-me.
       else
           assign p-vl-tot-vincul = tt-contrato-exp.vl-liquidado-me + p-vl-liquid.              
    
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-usa-exchange DBOProgram 
PROCEDURE pi-usa-exchange :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def output param l-usa-exchange as log no-undo.

  find first param-global no-lock no-error.
  if avail param-global then 
     assign l-usa-exchange = param-global.log-1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-titulo-vinculado DBOProgram 
PROCEDURE pi-valida-titulo-vinculado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p-nr-contrato as char    no-undo.
    def input  param p-dt-contrato as date    no-undo.
    def output param p-l-vinculado as logical no-undo.

    find first contr-titulo-exp no-lock
         where contr-titulo-exp.nr-contrato = p-nr-contrato
         and   contr-titulo-exp.dt-contrato = p-dt-contrato no-error.
    if avail contr-titulo-exp then
        assign p-l-vinculado = yes.
    else
        assign p-l-vinculado = no. 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-titulos DBOProgram 
PROCEDURE pi-valida-titulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF input  param p-ep-codigo      like contr-titulo-exp.ep-codigo.
    DEF input  param p-cod-estabel    like contr-titulo-exp.cod-estabel.
    def input  param p-cod-emitente   like contr-titulo-exp.cod-emitente.
    def input  param p-cod-esp        like contr-titulo-exp.cod-esp.
    def input  param p-serie          like contr-titulo-exp.serie.
    def input  param p-nr-docto       like contr-titulo-exp.nr-docto.
    def input  param p-parcela        like contr-titulo-exp.parcela.
    DEF OUTPUT PARAM p-moeda LIKE titulo.mo-codigo NO-UNDO.
    def output param table for tt_log_erro.

    define variable v-pagar as char no-undo. /* "EMS 2" ; "EMS 5" */
    define variable v-receber as char no-undo. /* "EMS 2" ; "EMS 5" */
    define variable h-boad355 as handle no-undo.
    define variable h-acr788za as handle no-undo.
    DEF VAR p-cliente-nacional AS LOG NO-UNDO.

    run adbo/boad355.p persistent set h-boad355.
    run pi-verificar-produto in h-boad355 (output v-pagar,
                                           output v-receber).
    delete procedure h-boad355.

    case v-receber :
        when "EMS 5" then do: /* busca saldo orig EMS 5.0 */

            RUN btb/btb009za.p PERSISTENT SET h-btb009za.
            {cdp/cd1202.i3 i-ep-codigo-usuario}
            if  l-conec-bas = yes and l-conec-fin = yes and l-conec-uni = yes  then do:
                /* caso seja contrato pronto pode trazer documento com cliente nacional*/
                IF l-funcao-arbitragem THEN do:
                    ASSIGN p-moeda = ?
                           p-cliente-nacional = YES.
                END.
                run prgfin/acr/acr788za.py persistent set h-acr788za.
                run pi_valida_tit_acr_integr_mec in h-acr788za (INPUT string(p-ep-codigo),
                                                               INPUT p-cod-estabel,
                                                               INPUT p-cod-emitente,
                                                               INPUT p-cod-esp,
                                                               INPUT p-serie,
                                                               INPUT p-nr-docto,
                                                               INPUT p-parcela,
                                                               OUTPUT p-moeda,
                                                               OUTPUT TABLE tt_log_erro,
                                                               INPUT p-cliente-nacional).

                {cdp/cd1202.i4 i-ep-codigo-usuario} 
                IF VALID-HANDLE(h-btb009za) THEN
                   DELETE PROCEDURE h-btb009za.

            end.
        end.
        end case.
RETURN "OK":U.
END PROCEDURE. /* fim pi-valida-titulos */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-antecip DBOProgram 
PROCEDURE pi-verifica-antecip :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p-cod-estabel    like contrato-exp.cod-estabel.
    def input  param p-ep-codigo      like contrato-exp.ep-codigo.
    def input  param p-cod-esp        like contr-titulo-exp.cod-esp.
    def input  param p-cod-emitente   like contr-titulo-exp.cod-emitente.
    def input  param p-dt-emissao     like contr-titulo-exp.dt-contrato.
    def input  param p-moeda          like contrato-exp.moeda.
    def output param p-possui-antec    AS LOGICAL NO-UNDO.

    define variable v-pagar as char no-undo. /* "EMS 2" ; "EMS 5" */
    define variable v-receber as char no-undo. /* "EMS 2" ; "EMS 5" */
    define variable h-boad355 as handle no-undo.
    define variable h-acr788za as handle no-undo.

    run adbo/boad355.p persistent set h-boad355.
    run pi-verificar-produto in h-boad355 (output v-pagar,
                                           output v-receber).
    delete procedure h-boad355.

    case v-receber :
    when "EMS 5" then do: /* verifica antecip EMS 5.0 */
        {cdp/cd1202.i3 i-ep-codigo-usuario}
        if l-conec-bas = yes and l-conec-fin = yes and l-conec-uni = yes  then do:
            run prgfin/acr/acr788za.py persistent set h-acr788za.
            run pi_verifica_antecip_acr in h-acr788za (INPUT  p-ep-codigo,
                                                       input  p-cod-estabel,                           
                                                       input  p-cod-emitente,                         
                                                       input  p-dt-emissao, 
                                                       output p-possui-antec).
            delete procedure h-acr788za.
            {cdp/cd1202.i4 i-ep-codigo-usuario}
        end.
    end.
    end case.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-criacao-tt-correc DBOProgram 
PROCEDURE pi-verifica-criacao-tt-correc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p_cod_banco         as char no-undo.
def input param p_cod_produt_financ as char no-undo.
def input param p_cod_operac_financ as char no-undo.

def output param p_log_contr_acc_vinculacao as log no-undo.

assign p_log_contr_acc_vinculacao = no.

def buffer b-contr-titulo-exp for contr-titulo-exp.
def buffer b-contrato-exp for contrato-exp.

/*Procura um contrato filho(ACE) com a chave da operacao se encontrar verifica se o pai e Emprestimo ACC*/
find first b-contr-titulo-exp no-lock
     where b-contr-titulo-exp.cod-banco-ems5 = p_cod_banco
     and   b-contr-titulo-exp.prod-financ    = p_cod_produt_financ
     and   b-contr-titulo-exp.operac-financ  = p_cod_operac_financ no-error.
if avail b-contr-titulo-exp then do:
    find first b-contrato-exp no-lock
         where b-contrato-exp.nr-contrato   = b-contr-titulo-exp.nr-contrato
         and   b-contrato-exp.dt-contrato   = b-contr-titulo-exp.dt-contrato no-error.
    if avail b-contrato-exp then do:
        if  b-contrato-exp.tp-contrato-exp = 3 /*Emprestimo*/ 
        and b-contrato-exp.tp-emprestimo   = 1 /*ACC*/ then do:
            assign p_log_contr_acc_vinculacao = yes.
        end.
    end.
end.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vincula-titulo-emprestimo DBOProgram 
PROCEDURE pi-vincula-titulo-emprestimo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var c-ep-codigo          like contr-titulo-exp.ep-codigo            no-undo.
    def var cod-banco-ems5       like contr-titulo-exp.cod-banco-ems5       no-undo.
    def var prod-financ          like contr-titulo-exp.prod-financ          no-undo.
    def var operac-financ        like contr-titulo-exp.operac-financ        no-undo.
    def var num-id-operac-financ like contr-titulo-exp.num-id-operac-financ no-undo.
    DEF VAR dt-vencto-acc        LIKE contr-titulo-exp.dt-vencimen          NO-UNDO.

    assign c-ep-codigo = RowObject.ep-codigo.
    {ecp/ec0005b.i 1} /*** conecta bases do EMS 5.0 ***/

    /*** Verifica Erro na Conex∆o das Bases ***/
    {ecp/ec0005k.i}

    if i-seq-erro <> 0 then
       RETURN "NOK":U.
    ASSIGN vl-vincul-contrato = RowObject.vl-vinculado-me.
    
    IF l-funcao-arbitragem THEN do:
        {ecp/ec0005.i2 "RowObject"
                       "cod-moeda-cambial"
                       "vl-paridade-impl"
                       "vl-vincul-contrato"
                       "vl-saldo-liquidar-mo-contrato"}
    END.
   
    /*** Cria Operaá∆o Financeira para contrato ACE ***/
    run ecp/ec0005b.p (input rowobject.nr-contrato,
                       input RowObject.dt-contrato,
                       input RowObject.dt-vinculado,
                       input RowObject.prod-financ,
                       input vl-vincul-contrato, /* RowObject.vl-vinculado-me */ 
                       input TODAY, /* Ser† alterado para a data de vencimento do ACC */
                       output cod-banco-ems5,
                       output prod-financ,
                       output operac-financ,
                       output num-id-operac-financ,
                       OUTPUT dt-vencto-acc,
                       output table tt_log_erro).

    /*** Desconecta bases do EMS 5.0 ***/
    {ecp/ec0005b.i 2}

    assign i-seq-erro = 0.
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
    if i-seq-erro <> 0 then
       return "NOK":U.

    assign RowObject.cod-banco-ems5       = cod-banco-ems5
           RowObject.prod-financ          = prod-financ
           RowObject.operac-financ        = operac-financ
           RowObject.num-id-operac-financ = num-id-operac-financ
           RowObject.situacao             = 2
           RowObject.l-fluxo-caixa        = no.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vld-alt-titulo-cr DBOProgram 
PROCEDURE pi-vld-alt-titulo-cr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF "{&mguni_version}" >= "2.07A" &THEN
    def input  param p-ep-codigo     LIKE empresa.ep-codigo no-undo.
&ELSE
    def input  param p-ep-codigo     as integer no-undo.
&ENDIF
    def input  param p-cod-fornec    as integer no-undo.
    def input  param p-cod-estabel   as char    no-undo.
    def input  param p-cod-esp       as char    no-undo.
    def input  param p-serie         as char    no-undo.
    def input  param p-nr-docto      as char    no-undo.
    def input  param p-parcela       as char    no-undo.
    def INPUT  param p-dt-vencimen   as date    no-undo.
    def output param p-sl-liquidar   as decimal no-undo.
    def output param p-nr-contrato   as char    no-undo.
    def output param p-dt-contrato   as date    no-undo.

    assign p-sl-liquidar  = 0
           p-nr-contrato  = ""
           p-dt-contrato  = ?.         

    for each contr-titulo-exp where contr-titulo-exp.ep-codigo    = p-ep-codigo
                              and   contr-titulo-exp.cod-emitente = p-cod-fornec
                              and   contr-titulo-exp.cod-estabel  = p-cod-estabel
                              and   contr-titulo-exp.cod-esp      = p-cod-esp
                              and   contr-titulo-exp.serie        = p-serie
                              and   contr-titulo-exp.nr-docto     = p-nr-docto
                              and   contr-titulo-exp.parcela      = p-parcela NO-LOCK:

        assign p-sl-liquidar = p-sl-liquidar + contr-titulo-exp.sl-liquidar-me.

        find first bfcontrato-exp no-lock
             where bfcontrato-exp.nr-contrato = contr-titulo-exp.nr-contrato
             and   bfcontrato-exp.dt-contrato = contr-titulo-exp.dt-contrato 
             use-index contrato no-error.

            assign p-nr-contrato  = contr-titulo-exp.nr-contrato
                   p-dt-contrato  = contr-titulo-exp.dt-contrato
                   p-dt-vencimen  = contr-titulo-exp.dt-vencimen.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vld-alt-titulo-cr-new DBOProgram 
PROCEDURE pi-vld-alt-titulo-cr-new :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF "{&mguni_version}" >= "2.07A" &THEN
    def input  param p-ep-codigo     LIKE empresa.ep-codigo no-undo.
&ELSE
    def input  param p-ep-codigo     as integer no-undo.
&ENDIF
    def input  param p-cod-fornec    as integer no-undo.
    def input  param p-cod-estabel   as char    no-undo.
    def input  param p-cod-esp       as char    no-undo.
    def input  param p-serie         as char    no-undo.
    def input  param p-nr-docto      as char    no-undo.
    def input  param p-parcela       as char    no-undo.
    def INPUT-OUTPUT param p-dt-vencimen   as date    no-undo.
    def output param p-sl-liquidar   as decimal no-undo.
    def output param p-nr-contrato   as char    no-undo.
    def output param p-dt-contrato   as date    no-undo.
    def output param p-vl-vinculado-me  as decimal no-undo.

    assign p-sl-liquidar     = 0
           p-nr-contrato     = ""
           p-dt-contrato     = ?
           p-vl-vinculado-me = 0.

    for each contr-titulo-exp where contr-titulo-exp.ep-codigo    = p-ep-codigo
                              and   contr-titulo-exp.cod-emitente = p-cod-fornec
                              and   contr-titulo-exp.cod-estabel  = p-cod-estabel
                              and   contr-titulo-exp.cod-esp      = p-cod-esp
                              and   contr-titulo-exp.serie        = p-serie
                              and   contr-titulo-exp.nr-docto     = p-nr-docto
                              and   contr-titulo-exp.parcela      = p-parcela NO-LOCK:

        assign p-sl-liquidar = p-sl-liquidar + contr-titulo-exp.sl-liquidar-me.

        find first bfcontrato-exp no-lock
             where bfcontrato-exp.nr-contrato = contr-titulo-exp.nr-contrato
             and   bfcontrato-exp.dt-contrato = contr-titulo-exp.dt-contrato 
             use-index contrato no-error.

            assign p-nr-contrato  = contr-titulo-exp.nr-contrato
                   p-dt-contrato  = contr-titulo-exp.dt-contrato.

        IF (bfcontrato-exp.situacao <> 1 AND bfcontrato-exp.situacao <> 5 AND  bfcontrato-exp.situacao <> 9)  THEN
           ASSIGN  p-vl-vinculado-me = p-vl-vinculado-me + contr-titulo-exp.vl-vinculado-me.

    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vld-cancela-titulo-cr DBOProgram 
PROCEDURE pi-vld-cancela-titulo-cr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF "{&mguni_version}" >= "2.07A" &THEN
    def input  param p-ep-codigo     LIKE empresa.ep-codigo no-undo.
&ELSE
    def input  param p-ep-codigo     as integer no-undo.
&ENDIF
    def input  param p-cod-estabel   as char    no-undo.
    def input  param p-cod-esp       as char    no-undo.
    def input  param p-serie         as char    no-undo.
    def input  param p-nr-docto      as char    no-undo.
    def input  param p-parcela       as char    no-undo.

    def output param p-cod-estabel2  as char    no-undo.
    def output param p-referencia    as char    no-undo.
    def output param p-dt-referencia as date    no-undo.

    assign p-cod-estabel2  = ""
           p-referencia    = ""
           p-dt-referencia = ?.

    find first contr-titulo-exp no-lock
        where contr-titulo-exp.ep-codigo   = p-ep-codigo
        and   contr-titulo-exp.cod-estabel = p-cod-estabel
        and   contr-titulo-exp.cod-esp     = p-cod-esp
        and   contr-titulo-exp.serie       = p-serie
        and   contr-titulo-exp.nr-docto    = p-nr-docto
        and   contr-titulo-exp.parcela     = p-parcela no-error.

    if avail contr-titulo-exp then
        assign p-cod-estabel2  = contr-titulo-exp.cod-estabel
               p-referencia    = contr-titulo-exp.referencia
               p-dt-referencia = contr-titulo-exp.dt-referencia.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vld-fluxo-cx-cb DBOProgram 
PROCEDURE pi-vld-fluxo-cx-cb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF "{&mguni_version}" >= "2.07A" &THEN
    def input  param p-ep-codigo   LIKE empresa.ep-codigo no-undo.
&ELSE
    def input  param p-ep-codigo   as integer no-undo.
&ENDIF
    def input  param p-cod-estabel as char    no-undo.
    def input  param p-cod-esp     as char    no-undo.
    def input  param p-serie       as char    no-undo.
    def input  param p-nr-docto    as char    no-undo.
    def input  param p-parcela     as char    no-undo.
    def output param p-sl-liquidar as decimal format "->>>,>>>,>>>,>>9.99" no-undo.

    assign p-sl-liquidar = 0.

    for each contr-titulo-exp  
        where contr-titulo-exp.ep-codigo   = p-ep-codigo
        and   contr-titulo-exp.cod-estabel = p-cod-estabel
        and   contr-titulo-exp.cod-esp     = p-cod-esp
        and   contr-titulo-exp.serie       = p-serie
        and   contr-titulo-exp.nr-docto    = p-nr-docto
        and   contr-titulo-exp.parcela     = p-parcela NO-LOCK:
        if contr-titulo-exp.l-fluxo-caixa = no then do:
            assign p-sl-liquidar = p-sl-liquidar + contr-titulo-exp.sl-liquidar-me.
        end.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintcontrato DBOProgram 
PROCEDURE setConstraintcontrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel-ini LIKE contr-titulo-exp.cod-estabel.
    DEFINE INPUT PARAMETER pcod-estabel-fim LIKE contr-titulo-exp.cod-estabel.
    DEFINE INPUT PARAMETER pcod-fornec-ini  LIKE contr-titulo-exp.cod-emitente.
    DEFINE INPUT PARAMETER pcod-fornec-fim  LIKE contr-titulo-exp.cod-emitente.
    DEFINE INPUT PARAMETER pnr-docto-ini    LIKE contr-titulo-exp.nr-docto.
    DEFINE INPUT PARAMETER pnr-docto-fim    LIKE contr-titulo-exp.nr-docto.
    DEFINE INPUT PARAMETER pdt-vencimen-ini LIKE contr-titulo-exp.dt-vencimen.
    DEFINE INPUT PARAMETER pdt-vencimen-fim LIKE contr-titulo-exp.dt-vencimen.
    DEFINE INPUT PARAMETER pnr-proc-exp-ini AS CHAR.
    DEFINE INPUT PARAMETER pnr-proc-exp-fim AS char.

    assign c-cod-estabel-ini = pcod-estabel-ini
           c-cod-estabel-fim = pcod-estabel-fim
           i-cod-fornec-ini  = pcod-fornec-ini
           i-cod-fornec-fim  = pcod-fornec-fim
           c-nr-docto-ini    = pnr-docto-ini
           c-nr-docto-fim    = pnr-docto-fim
           d-dt-vencimen-ini = pdt-vencimen-ini
           d-dt-vencimen-fim = pdt-vencimen-fim
           c-nr-proc-exp-ini = pnr-proc-exp-ini
           c-nr-proc-exp-fim = pnr-proc-exp-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintContratoExp DBOProgram 
PROCEDURE SetConstraintContratoExp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo     LIKE contr-titulo-exp.ep-codigo     NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel   LIKE contr-titulo-exp.cod-estabel   NO-UNDO.
    DEFINE INPUT PARAMETER preferencia    LIKE contr-titulo-exp.referencia    NO-UNDO.
    DEFINE INPUT PARAMETER pdt-referencia LIKE contr-titulo-exp.dt-referencia NO-UNDO.

    assign i-ep-codigo     = pep-codigo
           c-cod-estabel   = pcod-estabel
           c-referencia    = preferencia
           d-dt-referencia = pdt-referencia.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintContratoExp2 DBOProgram 
PROCEDURE setConstraintContratoExp2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo     LIKE contr-titulo-exp.ep-codigo     NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel   LIKE contr-titulo-exp.cod-estabel   NO-UNDO.
    DEFINE INPUT PARAMETER preferencia    LIKE contr-titulo-exp.referencia    NO-UNDO.
    DEFINE INPUT PARAMETER pdt-referencia LIKE contr-titulo-exp.dt-referencia NO-UNDO.

    assign i-ep-codigo     = pep-codigo
           c-cod-estabel   = pcod-estabel
           c-referencia    = preferencia
           d-dt-referencia = pdt-referencia.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintContratoExp3 DBOProgram 
PROCEDURE setConstraintContratoExp3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE inPUT PARAMETER pnr-contrato  LIKE contr-titulo-EXP.nr-contrato  NO-UNDO.
    DEFINE inPUT PARAMETER pdt-contrato  LIKE contr-titulo-EXP.dt-contrato  NO-UNDO.

    assign c-nr-contrato   = pnr-contrato  
           d-dt-contrato   = pdt-contrato  .

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintContratoExp4 DBOProgram 
PROCEDURE setConstraintContratoExp4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE inPUT PARAMETER pnr-contrato  LIKE contr-titulo-EXP.nr-contrato  NO-UNDO.
    DEFINE inPUT PARAMETER pdt-contrato  LIKE contr-titulo-EXP.dt-contrato  NO-UNDO.

    assign c-nr-contrato   = pnr-contrato  
           d-dt-contrato   = pdt-contrato  .

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintEmpreDigitacao DBOProgram 
PROCEDURE SetConstraintEmpreDigitacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo     LIKE contr-titulo-exp.ep-codigo     NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel   LIKE contr-titulo-exp.cod-estabel   NO-UNDO.
    DEFINE INPUT PARAMETER preferencia    LIKE contr-titulo-exp.referencia    NO-UNDO.
    DEFINE INPUT PARAMETER pdt-referencia LIKE contr-titulo-exp.dt-referencia NO-UNDO.

    assign i-ep-codigo     = pep-codigo
           c-cod-estabel   = pcod-estabel
           c-referencia    = preferencia
           d-dt-referencia = pdt-referencia.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintEmpreDigitacao4 DBOProgram 
PROCEDURE SetConstraintEmpreDigitacao4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   &if "{&mgadm_version}":U >= "2.06B":U &then
    DEFINE INPUT PARAMETER pnr-contrato      LIKE contr-titulo-exp.nr-contrato   NO-UNDO.
    DEFINE INPUT PARAMETER pdt-contrato      LIKE contr-titulo-exp.dt-contrato   NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estab-ini    LIKE contr-titulo-exp.estab-titulo  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estab-fim    LIKE contr-titulo-exp.estab-titulo  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emit-ini     LIKE contr-titulo-exp.cod-emitente  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emit-fim     LIKE contr-titulo-exp.cod-emitente  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-esp-ini      LIKE contr-titulo-exp.cod-esp       NO-UNDO.
    DEFINE INPUT PARAMETER pcod-esp-fim      LIKE contr-titulo-exp.cod-esp       NO-UNDO.
    DEFINE INPUT PARAMETER pserie-ini        LIKE contr-titulo-exp.serie         NO-UNDO.
    DEFINE INPUT PARAMETER pserie-fim        LIKE contr-titulo-exp.serie         NO-UNDO.
    DEFINE INPUT PARAMETER pnr-docto-ini     LIKE contr-titulo-exp.nr-docto      NO-UNDO.
    DEFINE INPUT PARAMETER pnr-docto-fim     LIKE contr-titulo-exp.nr-docto      NO-UNDO.
    DEFINE INPUT PARAMETER pparcela-ini      LIKE contr-titulo-exp.parcela       NO-UNDO.
    DEFINE INPUT PARAMETER pparcela-fim      LIKE contr-titulo-exp.parcela       NO-UNDO.
    DEFINE INPUT PARAMETER pdt-vinculado-ini LIKE contr-titulo-exp.dt-vinculado  NO-UNDO.
    DEFINE INPUT PARAMETER pdt-vinculado-fim LIKE contr-titulo-exp.dt-vinculado  NO-UNDO.
    DEFINE INPUT PARAMETER pdt-vcto-ini      LIKE contr-titulo-exp.dt-vencimen   NO-UNDO.
    DEFINE INPUT PARAMETER pdt-vcto-fim      LIKE contr-titulo-exp.dt-vencimen   NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-ini      LIKE contr-titulo-exp.nr-proc-exp   NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-fim      LIKE contr-titulo-exp.nr-proc-exp   NO-UNDO.    
    
    ASSIGN c-nr-contrato      = pnr-contrato
           d-dt-contrato      = pdt-contrato
           c-cod-estabel-ini  = pcod-estab-ini
           c-cod-estabel-fim  = pcod-estab-fim
           i-cod-fornec-ini   = pcod-emit-ini
           i-cod-fornec-fim   = pcod-emit-fim
           c-cod-esp-ini      = pcod-esp-ini
           c-cod-esp-fim      = pcod-esp-fim
           c-serie-ini        = pserie-ini
           c-serie-fim        = pserie-fim
           c-nr-docto-ini     = pnr-docto-ini
           c-nr-docto-fim     = pnr-docto-fim
           i-parcela-ini      = pparcela-ini
           i-parcela-fim      = pparcela-fim
           d-dt-vinculado-ini = pdt-vinculado-ini
           d-dt-vinculado-fim = pdt-vinculado-fim
           d-dt-vencimen-ini  = pdt-vcto-ini
           d-dt-vencimen-fim  = pdt-vcto-fim
           c-nr-proc-exp-ini  = pnr-proc-ini
           c-nr-proc-exp-fim  = pnr-proc-fim.
    
    RETURN "OK":U.
   &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintMain DBOProgram 
PROCEDURE SetConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF "{&mguni_version}" >= "2.07A" &THEN
    define input parameter p-empresa   LIKE empresa.ep-codigo   no-undo.
&ELSE
    define input parameter p-empresa   as integer   no-undo.
&ENDIF

    assign i-empresa = p-empresa.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintTitulo DBOProgram 
PROCEDURE SetConstraintTitulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintVinculado DBOProgram 
PROCEDURE SetConstraintVinculado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo     LIKE contr-titulo-exp.ep-codigo     NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel   LIKE contr-titulo-exp.cod-estabel   NO-UNDO.
    DEFINE INPUT PARAMETER preferencia    LIKE contr-titulo-exp.referencia    NO-UNDO.
    DEFINE INPUT PARAMETER pdt-referencia LIKE contr-titulo-exp.dt-referencia NO-UNDO.

    assign i-ep-codigo     = pep-codigo
           c-cod-estabel   = pcod-estabel
           c-referencia    = preferencia
           d-dt-referencia = pdt-referencia.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintVinculado2 DBOProgram 
PROCEDURE SetConstraintVinculado2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-contrato LIKE contr-titulo-exp.nr-contrato  NO-UNDO.
    DEFINE INPUT PARAMETER pdt-contrato LIKE contr-titulo-exp.dt-contrato NO-UNDO.

    assign c-nr-contrato  = pnr-contrato
           d-dt-contrato  = pdt-contrato.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintVinculado3 DBOProgram 
PROCEDURE setConstraintVinculado3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter p-nr-proc-exp-ini like contr-titulo-exp.char-1       NO-UNDO.
    define input parameter p-nr-proc-exp-fim like contr-titulo-exp.char-1       NO-UNDO.
    define input parameter p-cod-emit-ini    like contr-titulo-exp.cod-emitente NO-UNDO.
    define input parameter p-cod-emit-fim    like contr-titulo-exp.cod-emitente NO-UNDO.
    define input parameter p-dt-vencto-ini   like contr-titulo-exp.dt-vencimen  NO-UNDO.
    define input parameter p-dt-vencto-fim   like contr-titulo-exp.dt-vencimen  NO-UNDO.


    assign v-nr-proces-ini = p-nr-proc-exp-ini
           v-nr-proces-fim = p-nr-proc-exp-fim
           v-emitente-ini  = p-cod-emit-ini
           v-emitente-fim  = p-cod-emit-fim
           dt-vencto-ini   = p-dt-vencto-ini
           dt-vencto-fim   = p-dt-vencto-fim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintVinculado4 DBOProgram 
PROCEDURE setConstraintVinculado4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   &if "{&mgadm_version}":U >= "2.06B":U &then
    DEFINE INPUT PARAMETER pnr-contrato      LIKE contr-titulo-exp.nr-contrato   NO-UNDO.
    DEFINE INPUT PARAMETER pdt-contrato      LIKE contr-titulo-exp.dt-contrato   NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estab-ini    LIKE contr-titulo-exp.estab-titulo  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estab-fim    LIKE contr-titulo-exp.estab-titulo  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emit-ini     LIKE contr-titulo-exp.cod-emitente  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emit-fim     LIKE contr-titulo-exp.cod-emitente  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-esp-ini      LIKE contr-titulo-exp.cod-esp       NO-UNDO.
    DEFINE INPUT PARAMETER pcod-esp-fim      LIKE contr-titulo-exp.cod-esp       NO-UNDO.
    DEFINE INPUT PARAMETER pserie-ini        LIKE contr-titulo-exp.serie         NO-UNDO.
    DEFINE INPUT PARAMETER pserie-fim        LIKE contr-titulo-exp.serie         NO-UNDO.
    DEFINE INPUT PARAMETER pnr-docto-ini     LIKE contr-titulo-exp.nr-docto      NO-UNDO.
    DEFINE INPUT PARAMETER pnr-docto-fim     LIKE contr-titulo-exp.nr-docto      NO-UNDO.
    DEFINE INPUT PARAMETER pparcela-ini      LIKE contr-titulo-exp.parcela       NO-UNDO.
    DEFINE INPUT PARAMETER pparcela-fim      LIKE contr-titulo-exp.parcela       NO-UNDO.
    DEFINE INPUT PARAMETER pdt-vinculado-ini LIKE contr-titulo-exp.dt-vinculado  NO-UNDO.
    DEFINE INPUT PARAMETER pdt-vinculado-fim LIKE contr-titulo-exp.dt-vinculado  NO-UNDO.
    DEFINE INPUT PARAMETER pdt-vcto-ini      LIKE contr-titulo-exp.dt-vencimen   NO-UNDO.
    DEFINE INPUT PARAMETER pdt-vcto-fim      LIKE contr-titulo-exp.dt-vencimen   NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-ini      LIKE contr-titulo-exp.nr-proc-exp   NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-fim      LIKE contr-titulo-exp.nr-proc-exp   NO-UNDO.    
    
    ASSIGN c-nr-contrato      = pnr-contrato
           d-dt-contrato      = pdt-contrato
           c-cod-estabel-ini  = pcod-estab-ini
           c-cod-estabel-fim  = pcod-estab-fim
           i-cod-fornec-ini   = pcod-emit-ini
           i-cod-fornec-fim   = pcod-emit-fim
           c-cod-esp-ini      = pcod-esp-ini
           c-cod-esp-fim      = pcod-esp-fim
           c-serie-ini        = pserie-ini
           c-serie-fim        = pserie-fim
           c-nr-docto-ini     = pnr-docto-ini
           c-nr-docto-fim     = pnr-docto-fim
           i-parcela-ini      = pparcela-ini
           i-parcela-fim      = pparcela-fim
           d-dt-vinculado-ini = pdt-vinculado-ini
           d-dt-vinculado-fim = pdt-vinculado-fim
           d-dt-vencimen-ini  = pdt-vcto-ini
           d-dt-vencimen-fim  = pdt-vcto-fim
           c-nr-proc-exp-ini  = pnr-proc-ini
           c-nr-proc-exp-fim  = pnr-proc-fim.

    RETURN "OK":U.
   &endif
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

    find  contrato-exp no-lock
        where contrato-exp.nr-contrato   = RowObject.nr-contrato
          and contrato-exp.dt-contrato   = RowObject.dt-contrato no-error.

    if ptype = "Create":U or ptype = "Update":U then do:
        run pi-autenticacao.

        if not avail contrato-exp then do:
            {method/svc/errors/inserr.i
                        &ErrorNumber="19335"
                        &ErrorType="EMS"
                        &ErrorParameters="''"}  /* Nío existe contrato criado para vincular o t≠tulo */
        end.
        else do:
            if contrato-exp.situacao    <> 1 and
               contrato-exp.tp-contrato-exp  = 3 then do:
                if contrato-exp.dt-contrato   > RowObject.dt-vinculado or
                   contrato-exp.dt-liquidacao < RowObject.dt-vinculado then do:
                    {method/svc/errors/inserr.i
                                &ErrorNumber="26442"
                                &ErrorType="EMS"
                                &ErrorParameters="''"}
                end.
            end.
        end.

        if ptype = "Create":U then do:
            if (contrato-exp.tp-contrato-exp = 3)
            and (contrato-exp.tp-emprestimo = 1 OR contrato-exp.tp-emprestimo = 3 OR contrato-exp.tp-emprestimo = 4) then do:

                FIND contr-titulo-exp 
                     WHERE contr-titulo-exp.ep-codigo     = RowObject.ep-codigo
                     AND   contr-titulo-exp.cod-estabel   = RowObject.cod-estabel
                     AND   contr-titulo-exp.referencia    = RowObject.referencia
                     AND   contr-titulo-exp.dt-referencia = RowObject.dt-referencia
                     AND   contr-titulo-exp.cod-emitente  = RowObject.cod-emitente
                     AND   contr-titulo-exp.cod-esp       = RowObject.cod-esp
                     AND   contr-titulo-exp.serie         = RowObject.serie
                     AND   contr-titulo-exp.nr-docto      = RowObject.nr-docto
                     AND   contr-titulo-exp.parcela       = RowObject.parcela
                     AND   contr-titulo-exp.dt-vinculado  = RowObject.dt-vinculado EXCLUSIVE-LOCK no-error.
                if avail contr-titulo-exp then do: 
                   IF contr-titulo-exp.nr-contrato   = RowObject.nr-contrato and 
                      contr-titulo-exp.dt-contrato   = RowObject.dt-contrato THEN

                     {method/svc/errors/inserr.i
                                &ErrorNumber="28454"
                                &ErrorType="EMS"
                                &ErrorParameters="string(RowObject.dt-vinculado) + '~~~~' + 
                                                  string(RowObject.ep-codigo)    + '~~~~' +
                                                  string(RowObject.cod-estabel)  + '~~~~' +                                      
                                                  string(RowObject.cod-emitente) + '~~~~' +  
                                                  string(RowObject.cod-esp)      + '~~~~' +       
                                                  string(RowObject.serie)        + '~~~~' +          
                                                  string(RowObject.nr-docto)     + '~~~~' +      
                                                  string(RowObject.parcela)"}
                end.
            END.
            ELSE DO:
                find contr-titulo-exp
                     where contr-titulo-exp.ep-codigo     = RowObject.ep-codigo
                     and   contr-titulo-exp.cod-estabel   = RowObject.cod-estabel
                     and   contr-titulo-exp.referencia    = RowObject.referencia
                     and   contr-titulo-exp.dt-referencia = RowObject.dt-referencia
                     and   contr-titulo-exp.cod-emitente  = RowObject.cod-emitente
                     and   contr-titulo-exp.cod-esp       = RowObject.cod-esp
                     and   contr-titulo-exp.serie         = RowObject.serie
                     and   contr-titulo-exp.nr-docto      = RowObject.nr-docto
                     and   contr-titulo-exp.parcela       = RowObject.parcela no-lock no-error.
                if avail contr-titulo-exp then do: 
                   IF contr-titulo-exp.nr-contrato   = RowObject.nr-contrato and 
                      contr-titulo-exp.dt-contrato   = RowObject.dt-contrato THEN

                         {method/svc/errors/inserr.i
                                    &ErrorNumber="819"
                                    &ErrorType="EMS"
                                    &ErrorParameters="''"}  /* Titulo j† Cadastrado */
                end.
            END.
        end. /* Create */

    end. /* Create e Update */    

    if ptype = "Delete":U then do:
        if RowObject.vl-vinculado-me <> RowObject.sl-liquidar-me and contrato-exp.tp-contrato-exp <> 2 then do:
            {method/svc/errors/inserr.i
                        &ErrorNumber="19337"
                        &ErrorType="EMS"
                        &ErrorParameters="''"}
        end.
    end. /* Delete */        

    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
