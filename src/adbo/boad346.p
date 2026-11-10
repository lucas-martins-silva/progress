&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/****************************************************************************************   
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*****************************************************************************************/
{include/i-prgvrs.i BOAD346 2.00.00.077 } /*** "010077" 10/06/2025 09:30:37 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad346 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS 
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  ***************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName              BOAD346
&GLOBAL-DEFINE DBOVersion           2.00.00.074
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName            contrato-exp
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName            qr{&TableName} 


/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{adbo/boad346.i RowObject}


/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
def buffer bf-contrato for contrato-exp.
DEF BUFFER bf-crta-remessa-exp FOR crta-remessa-exp.
DEF BUFFER bf-crta-remessa-docto-exp FOR crta-remessa-docto-exp.

def var c-ep-codigo-ini     like contrato-exp.ep-codigo.
def var c-ep-codigo-fim     like contrato-exp.ep-codigo.
def var c-cod-estabel-ini   like contrato-exp.cod-estabel.
def var c-cod-estabel-fim   like contrato-exp.cod-estabel.
def var c-referencia-ini    like contrato-exp.referencia.
def var c-referencia-fim    like contrato-exp.referencia.
def var d-dt-referencia-ini like contrato-exp.dt-referencia.
def var d-dt-referencia-fim like contrato-exp.dt-referencia.
def var c-nr-contrato-ini   like contrato-exp.nr-contrato.
def var c-nr-contrato-fim   like contrato-exp.nr-contrato.
def var d-dt-contrato-ini   like contrato-exp.dt-contrato.
def var d-dt-contrato-fim   like contrato-exp.dt-contrato.
def var i-ep-codigo         like contrato-exp.ep-codigo.
def var c-cod-estabel       like contrato-exp.cod-estabel.
def var c-referencia        like contrato-exp.referencia.
def var d-dt-referencia     like contrato-exp.dt-referencia.
def var v-num-id            like contrato-exp.num-id-contrato-exp.
def var l-liquida-menor     as   logical no-undo.
def var l-cambiais-menor    as   logical no-undo.    
DEF VAR l-altera            AS   LOGICAL NO-UNDO.
def var i-seq-erro          as   integer no-undo.
&IF "{&mguni_version}" >= "2.07A" &THEN
def var c-ep-codigo         LIKE empresa.ep-codigo no-undo.
&ELSE
def var c-ep-codigo         as   integer no-undo.
&ENDIF
def var vl-tit-vinculados   as   decimal no-undo.
def var vl-contr-vincul     as   decimal no-undo.
def var vl-tit-liquidar     as   decimal no-undo.

def var h-acr788za             as handle  no-undo.
def var h-boad355              as handle  no-undo.
def var h-boad347              as handle  no-undo.
def var hshowmsg               as handle  no-undo.
def var v-soma-titulos         as decimal no-undo.
def var v-receber              as char    no-undo.
def var v-pagar                as char    no-undo.
def var c-cod-estabel-ems2     as char    no-undo.
def var c-nr-contrato-ems2     as char    no-undo.
def var da-dt-contrato-ems2    as date    no-undo.
def var c-referencia-ems2      as char    no-undo.
def var da-dt-referencia-ems2  as date    no-undo.
def var i-moeda-ems2           as int     no-undo.
def var de-vl-contrato-me-ems2 as dec     no-undo.
def var c-nr-contrato-ant      as char    no-undo.
DEF VAR d-dt-contrato-ant      as date    no-undo.
DEF VAR l-multi-an             AS LOG     NO-UNDO.

def var l-param-apf as logical no-undo.
def var h-apb919za  as handle  no-undo.

def var l-funcao-melhoria-desp as log     no-undo.
def new global shared var i-ep-codigo-usuario  like empresa.ep-codigo    no-undo.
def new global shared var v_cod_empres_usuar as character format "x(03)" no-undo.
def new global shared var v_cod_usuar_corren as character format "x(12)" no-undo.
def var v_cod_empres_usuar_old as character format "x(3)"  no-undo.
def var v_cod_usuar_corren_old as character format "x(12)" no-undo.
def var c-campo as char no-undo.
{include/i-epc200.i boad346} /* Temp-table tt-epc */

def temp-table tt-contrato-exp NO-UNDO like contrato-exp
    field r-rowid as rowid.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia".

def temp-table tt_campos_mec no-undo
    field ttv_cod_estab_ext    as character format "x(3)"       label "Estabelecimento"    column-label "Estabelecimento"
    field ttv_cod_empresa_ext  as character format "x(3)"       label "C¢digo Empresa Ext" column-label "C¢d Emp Ext"
    field ttv_cod_contrat_2    as character format "x(15)"      label "Nr Contrato"        column-label "Nr Contr"
    field ttv_dat_contrat      as date      format "99/99/9999" label "Dt Contrato"        column-label "Dt Contr"
    field ttv_cod_refer        as character format "x(10)"      label "Referˆncia"         column-label "Referˆncia"
    field ttv_dat_refer        as date      format "99/99/9999" label "Data Referˆncia"    column-label "Data Refer"
    field tta_cod_modul_integr as character format "x(3)"       label "M¢dulo Integracao"  column-label "M¢dulo Integracao".

def temp-table tt_campos_mec_cfl no-undo
    field ttv_cod_estab_ext                as character format "x(3)" label "Estabelecimento" column-label "Estabelecimento"
    field ttv_cod_empresa_ext              as character format "x(3)" label "C¢digo Empresa Ext" column-label "C¢d Emp Ext"
    field ttv_cod_contrat_2                as character format "x(15)" label "Nr Contrato" column-label "Nr Contr"
    field ttv_dat_contrat                  as date format "99/99/9999" label "Dt Contrato" column-label "Dt Contr"
    field ttv_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field ttv_dat_refer                    as date format "99/99/9999" initial ? label "Data Referˆncia" column-label "Data Refer"
    field tta_cod_modul_integr             as character format "x(3)" label "M¢dulo Integracao" column-label "M¢dulo Integracao"
    field ttv_val_despes_mec               as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Valor Desp"
    field ttv_cod_docto_empres_despes      as character format "x(16)" label "Docto Empresa"
    .

def temp-table tt_integr_mec_cfl_despes no-undo
    field tta_cod_estab_contrat_cambio     as character format "x(3)" label "Estab Contr Cƒmbio" column-label "Estab Contr Cƒmbio"
    field tta_cod_contrat_cambio           as character format "x(15)" label "Contrato Cƒmbio" column-label "Contrato Cƒmbio"
    field tta_cod_refer_contrat_cambio     as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_dat_refer_contrat_cambio     as date format "99/99/9999" initial ? label "Dt Referˆncia" column-label "Dt Referˆncia"
    field tta_num_id_movto_fluxo_cx        as integer format "9999999999" initial 0 label "Id Movto Fluxo Cx" column-label "Id Movto Fluxo Cx"
    field tta_num_id_orig_movto_fluxo_cx   as integer format ">>>>,>>9" initial 0 label "Id Origem Movimento" column-label "Id Origem Movimento"
    field ttv_num_tip_despes_mec           as integer format ">>>>,>>9"
    field ttv_val_despes_mec               as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Valor Desp"
    field ttv_cod_docto_empres_despes      as character format "x(16)" label "Docto Empresa"
    .

def temp-table tt_erro_mec no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "Seqˆncia" column-label "Seq"
    field ttv_cod_erro_ems2                as int column-label "Cod Erro"
    field ttv_des_msg_erro_ems2            as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    .

def temp-table tt-erro-aux no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)"
    .

def temp-table tt_chave_tit_acr no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_num_contrat_id_cambio        as integer format "999999999".

def temp-table tt-titulos-antecipacao NO-UNDO like titulo
    field r-rowid         as rowid 
    field de-vl-vinculado as decimal label "Vl Vinculado" format ">,>>>,>>>,>>9.99"
    field ctr-referencia  as char
    field dt-referencia   as date
    field nr-contrato     as char
    field dt-contrato     as date
    field prod-financ     as char
    field dt-vinculado    as date
    field vl-paridade     as dec
    field moeda           as int
    field ctr-referencia-liq as char
    field dt-referencia-liq as date
    field nr-contrato-liq as char
    field dt-contrato-liq as date
    field cod-unid-negoc  as char init "" format "x(3)"
    index codigo          is primary
                             ep-codigo
                             cod-estabel
                             referencia
                             dt-referencia.
                         
def temp-table tt-contratos
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

def new global shared var v_cod_grp_usuar_lst
    as character
    format "x(3)":U
    label "Grupo Usu rios"
    column-label "Grupo"
    no-undo.

def var v_cod_grp_usuar_lst_old
    as character
    format "x(3)":U
    label "Grupo Usu rios"
    column-label "Grupo"
    no-undo.

{adbo/boad346.i3}
{cdp/cdcfgfin.i}   /* Miniflexibilizacao */
{ecp/ec0003.i1}
{crp/crapi003.i}

{adbo/boad346.i2}

/*Definicao de TT de Integracao com ems5*/
{cdp/cdapi533a.i}
{cdp/cd1202.i2}
/* Local Variable Definitions ---                                       */

{ecp/ec0005c.i}  /* Definicoes para conexao EMS 5 */

/*** Verificar se a fun»’o especial estÿ˜ habilitada ***/
{include/getdefinedfunction.i}
assign l-multi-an = &if defined(BF_FIN_MULTI_AN) &then YES &else GetDefinedFunction("SPP-MULTI-AN") &endif.
       l-funcao-melhoria-desp  = &if defined(BF-FIN-INFORM-DESPES) &then yes &else GetDefinedFunction("SPP-INFORM-DESPES") &endif.

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
         HEIGHT             = 6.92
         WIDTH              = 48.72.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDeleteRecord DBOProgram 
PROCEDURE AfterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    for each contr-docto-exp of RowObject exclusive-lock:
       delete contr-docto-exp.
    end.

    for each contr-hist-exp of RowObject exclusive-lock:
        delete contr-hist-exp.
    end.
    
    if RowObject.tp-contrato-exp = 3 then do:
        for each contr-emprestimo of RowObject exclusive-lock:
            delete contr-emprestimo.
        end.
    end.
    
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
    if RowObject.tp-contrato-exp = 2 then do: /* Antecipa‡Æo */
		def var v-ep-codigo like tt-contrato-exp.ep-codigo.
        &IF  "{&mgadm_version}" >= "2.06B" &THEN
        run adbo/boad355.p persistent set h-boad355.
        run pi-verificar-produto in h-boad355 (output v-pagar,
                                                 output v-receber).
        delete procedure h-boad355.

        if  v-pagar = "EMS 5":U then do:
            run prgfin/apb/apb919za.py persistent set h-apb919za (input 1).
		
		    run pi-busca-empresa (output v-ep-codigo).
        
            run pi_verifica_param_apf IN h-apb919za(input v-ep-codigo,
						    				        input RowObject.cod-estabel,
									               output l-param-apf).
        END.

        if l-multi-an then
           assign RowObject.vl-liquidar-me  = RowObject.vl-contrato-me.

        IF l-param-apf THEN DO:
            ASSIGN RowObject.situacao          = 6. /* "Pendente Aprova‡Æo". */
        END.
        ELSE DO:
        &ENDIF
            if l-multi-an then
               assign RowObject.vl-liquidar-me  = RowObject.vl-contrato-me.
            else
               assign RowObject.vl-liquidar-me  = 0.

            assign 
              RowObject.vl-liquidado-me = RowObject.vl-contrato-me
              RowObject.situacao          = 3. /* "Liquidado". */
        &IF  "{&mgadm_version}" >= "2.06B" &THEN
        END.
        &ENDIF
    end.
    
    if RowObject.tp-contrato-exp = 3 then do: /* Emp‚stimo */
        assign RowObject.vl-liquidar-me = RowObject.vl-contrato-me.

        def var h-boad350 as handle no-undo.
        run adbo/boad350.p persistent set h-boad350.
        run pi-cria-registro in h-boad350 (input RowObject.c-time,
                                           input RowObject.check-sum,
                                           input RowObject.cod-banco-ems5,
                                           input RowObject.cod-estabel,
                                           input RowObject.dt-contrato,
                                           input RowObject.dt-referencia,
                                           input today,
                                           input today,
                                           input RowObject.ep-codigo,
                                           input RowObject.nr-contrato,
                                           input RowObject.num-id-operac-financ,
                                           input RowObject.operac-financ,
                                           input RowObject.prod-financ,
                                           input RowObject.referencia,
                                           input RowObject.usuario,
                                           input 4).
        delete procedure h-boad350.    
    end.

    assign RowObject.num-id-contrato-exp = next-value(seq-contrato-exp).

    /*--- Verifica ocorr¼ncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
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
    if RowObject.tp-contrato-exp = 3 then do:
        run pi-busca-empresa in this-procedure (output c-ep-codigo).
        
        /* Conecta Bases EMS 5 */
        {ecp/ec0005b.i 1}
        
        /*** Verifica Erro na ConexÆo das Bases ***/
        {ecp/ec0005k.i}
        
        IF i-seq-erro <> 0 THEN
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
                   v_cod_empres_usuar = v_cod_empres_usuar_old
                   v_cod_grp_usuar_lst = v_cod_grp_usuar_lst_old.
           return "NOK":U.
        end.
        &ENDIF

        run prgfin/apl/apl007zu.py (1,
                                    input  "Cancelamento",
                                    input  "Empr‚stimo",
                                    input  RowObject.num-id-operac-financ,
                                    input  0,
                                    input  today,
                                    output table tt_log_erro).
        
        run prgfin/acr/acr788za.py persistent set h-acr788za.
        run pi_atualiza_repas_pend_apl in h-acr788za (input-output table tt_repas_pend_apl,
                                                      input "Atualiza",
                                                      input RowObject.num-id-operac-financ).
        delete procedure h-acr788za.

        /* Desconecta Bases EMS 5 */
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
            RETURN "NOK":U.
    end.

    &IF "{&mguni_version}" <= "2.06B" &THEN
    assign v_cod_usuar_corren = v_cod_usuar_corren_old 
           v_cod_empres_usuar = v_cod_empres_usuar_old.

    assign v_cod_grp_usuar_lst = v_cod_grp_usuar_lst_old.
    &ENDIF
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeUpdateRecord DBOProgram 
PROCEDURE BeforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var h-boad362 as handle no-undo.

    find first bf-contrato no-lock
         where bf-contrato.nr-contrato = c-nr-contrato-ant
         and   bf-contrato.dt-contrato = d-dt-contrato-ant  no-error. 

/*    find first bf-contrato no-lock
         where bf-contrato.ep-codigo     = RowObject.ep-codigo
         and   bf-contrato.cod-estabel   = RowObject.cod-estabel
         and   bf-contrato.referencia    = RowObject.referencia
         and   bf-contrato.dt-referencia = RowObject.dt-referencia no-error.  */

    if bf-contrato.nr-contrato <> RowObject.nr-contrato or
       bf-contrato.dt-contrato <> RowObject.dt-contrato then do:
        for each contr-titulo-exp EXCLUSIVE-LOCK
            WHERE contr-titulo-exp.nr-contrato = c-nr-contrato-ant  AND
                  contr-titulo-exp.dt-contrato = d-dt-contrato-ant  :

           assign contr-titulo-exp.nr-contrato = RowObject.nr-contrato
                  contr-titulo-exp.dt-contrato = RowObject.dt-contrato.
        end.
        for each contr-docto-exp of RowObject exclusive-lock:
           assign contr-docto-exp.nr-contrato = RowObject.nr-contrato
                  contr-docto-exp.dt-contrato = RowObject.dt-contrato.
        end.
        for each contr-despesa-exp of RowObject exclusive-lock:
           assign contr-despesa-exp.nr-contrato = RowObject.nr-contrato
                  contr-despesa-exp.dt-contrato = RowObject.dt-contrato.
        end.

        for each crta-remessa-docto-exp exclusive-lock
           where crta-remessa-docto-exp.ind-tipo-documento = 13:
            if crta-remessa-docto-exp.documento = bf-contrato.nr-contrato then
                assign crta-remessa-docto-exp.documento = RowObject.nr-contrato.
        end.

        for each crta-remessa-docto-pend-exp exclusive-lock
           where crta-remessa-docto-pend-exp.ind-tipo-documento = 13:
            if crta-remessa-docto-pend-exp.documento = bf-contrato.nr-contrato then
                assign crta-remessa-docto-pend-exp.documento = RowObject.nr-contrato.
        end.
    end.

    if bf-contrato.situacao <> RowObject.situacao then do:
        run adbo/boad362.p persistent set h-boad362.
        run pi-atualiza-historico in h-boad362 (input bf-contrato.ep-codigo,
                                                input bf-contrato.cod-estabel,
                                                input bf-contrato.referencia,
                                                input bf-contrato.dt-referencia,
                                                input "Situacao do Contrato",
                                                input string({adinc/i02ad346.i 04 bf-contrato.situacao}),
                                                input string({adinc/i02ad346.i 04 RowObject.situacao})).
        delete procedure h-boad362.
    end.

    if bf-contrato.vl-contrato-me <> RowObject.vl-contrato-me then do:
        run adbo/boad362.p persistent set h-boad362.
        run pi-atualiza-historico in h-boad362 (input bf-contrato.ep-codigo,
                                                input bf-contrato.cod-estabel,
                                                input bf-contrato.referencia,
                                                input bf-contrato.dt-referencia,
                                                input "Valor do Contrato ME",
                                                input string(bf-contrato.vl-contrato-me,">,>>>,>>9.99"),
                                                input string(RowObject.vl-contrato-me,">,>>>,>>9.99")).
        delete procedure h-boad362.
    end.
    if bf-contrato.cotacao-dia <> RowObject.cotacao-dia then do:
        run adbo/boad362.p persistent set h-boad362.
        run pi-atualiza-historico in h-boad362 (input bf-contrato.ep-codigo,
                                                input bf-contrato.cod-estabel,
                                                input bf-contrato.referencia,
                                                input bf-contrato.dt-referencia,
                                                input "Cota‡Æo Dia",
                                                input string(bf-contrato.cotacao-dia,">,>>>,>>9.99"),
                                                input string(RowObject.cotacao-dia,">,>>>,>>9.99")).
        delete procedure h-boad362.
    end.
    
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-oper-cambio":U THEN ASSIGN pFieldValue = RowObject.cod-oper-cambio.
        WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
        WHEN "cod-forma-pgto-mec":U THEN ASSIGN pFieldValue = RowObject.cod-forma-pgto-mec.
        WHEN "operac-financ":U THEN ASSIGN pFieldValue = RowObject.operac-financ.
        WHEN "prod-financ":U THEN ASSIGN pFieldValue = RowObject.prod-financ.
        WHEN "referencia":U THEN ASSIGN pFieldValue = RowObject.referencia.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dt-cambiais":U THEN ASSIGN pFieldValue = RowObject.dt-cambiais.
        WHEN "dt-contrato":U THEN ASSIGN pFieldValue = RowObject.dt-contrato.
        WHEN "dt-entr-docto":U THEN ASSIGN pFieldValue = RowObject.dt-entr-docto.
        WHEN "dt-liquidacao":U THEN ASSIGN pFieldValue = RowObject.dt-liquidacao.
        WHEN "dt-referencia":U THEN ASSIGN pFieldValue = RowObject.dt-referencia.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cotacao-dia":U THEN ASSIGN pFieldValue = RowObject.cotacao-dia.
        WHEN "vl-contrato":U THEN ASSIGN pFieldValue = RowObject.vl-contrato.
        WHEN "vl-contrato-me":U THEN ASSIGN pFieldValue = RowObject.vl-contrato-me.
        WHEN "vl-liquidado-me":U THEN ASSIGN pFieldValue = RowObject.vl-liquidado-me.
        WHEN "vl-liquidar-me":U THEN ASSIGN pFieldValue = RowObject.vl-liquidar-me.
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
     def input  param c-param       as char no-undo.
     def output param c-description as char no-undo.

     def var v-ep-codigo like tt-contrato-exp.ep-codigo.
     
     run pi-busca-empresa (output v-ep-codigo).

     find first param-global no-lock no-error.

     case c-table:
        when "texto-padrao-mec":u then do:
            &if defined(BF_FIN_MODUL_CAMBIO) &then
                if param-global.modulo-mec = yes then do:
                    find texto-padrao-mec where texto-padrao-mec.codigo = int(c-param) no-lock no-error.
                    if avail texto-padrao-mec then
                        assign c-description = texto-padrao-mec.descricao.
                    else
                        assign c-description = "".
                end.
            &endif
        end.
        when "cliente":u then do:
            find first emitente
                 where emitente.cod-emitente = integer(c-param)
                 and   emitente.identific      <> 2 no-lock no-error.
            if  avail emitente then
                assign c-description = emitente.nome-abrev.
            else assign c-description = "".
        end.
        when "banco":u then do:
           find banco where banco.cod-banco = int(c-param) no-lock no-error.
           if avail banco then
              assign c-description = banco.nome-banco.
           else
              assign c-description = " ".
        end.
        when "febraban":u then do:
           find first banco where banco.cod-febraban = int(c-param) no-lock no-error.
           if avail banco then
              assign c-description = string(banco.cod-banco).
           else
              assign c-description = " ".
        end.
        when "moeda":u then do:
           find moeda where moeda.mo-codigo = int(c-param) no-lock no-error.
           if avail moeda then
              assign c-description = moeda.descricao.
           else
              assign c-description = " ".
        end.
        when "cotacao":u then do:
           def var d-day as date no-undo.
           assign d-day = date(entry(3, c-param, chr(10))).
           find cotacao where cotacao.mo-codigo   = int(entry(1, c-param, chr(10)))
                        and   cotacao.ano-periodo = entry(2, c-param, chr(10)) no-lock no-error.
           if avail cotacao then
              assign c-description = IF string(cotacao.cotacao[day(d-day)]) = "0" THEN "1" ELSE string(cotacao.cotacao[day(d-day)]).
           else
              assign c-description = "1".
        end.
        when "operac-cambio":u then do:
           find operac-cambio where operac-cambio.cod-oper-cambio = c-param no-lock no-error.
           if avail operac-cambio then
              assign c-description = operac-cambio.nome.
           else
              assign c-description = " ".
        end.
        when "emitente":u then do:
           find emitente where emitente.cod-emitente = int(c-param) no-lock no-error.
           if avail emitente then
              assign c-description = emitente.nome-emit.
           else
              assign c-description = " ".
        end.
        when "portador":U then do:
            find first portador where portador.ep-codigo    = v-ep-codigo 
                                and   portador.cod-portador = int(c-param) no-lock no-error.
            if avail portador then
                assign c-description = portador.nome.
            else
                assign c-description = " ".
        end.
        when "natureza":U then do:
           find emitente where emitente.cod-emitente = int(c-param) no-lock no-error.
           if avail emitente then
              assign c-description = string(emitente.natureza).
           else
              assign c-description = "".
        end.
        when "modalidade":U then do:
            find first portador where portador.ep-codigo    = v-ep-codigo
                                and   portador.cod-portador = int(c-param) no-lock no-error.
            if avail portador then DO:
                &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                    DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
                    ASSIGN cAuxTraducao001 = {adinc/i03ad209.i 04 portador.modalidade}.
                    run utp/ut-liter.p (input replace(trim(cauxtraducao001)," ","_"),
                                        INPUT "",
                                        INPUT "").
                    ASSIGN  c-description = RETURN-VALUE.
                &else
                    ASSIGN c-description = {adinc/i03ad209.i 04 portador.modalidade}.
                &endif
END.
            else
                assign c-description = " ".
        end.                                      
        when "receita":U then do:
            find first tipo-rec-desp where tipo-rec-desp.tp-codigo = int(c-param) no-lock no-error.
            if avail tipo-rec-desp then
                assign c-description = tipo-rec-desp.descricao.
            else
                assign c-description = " ".
        end.
        when "Forma":U then do:
            find first forma-pgto-mec where forma-pgto-mec.cod-forma-pgto-mec = c-param no-lock no-error.
            if avail forma-pgto-mec then
                assign c-description = forma-pgto-mec.descricao.
            else
                assign c-description = " ".
        end.
        when "tipo-docto":U then do:
            find first tipo-docto where tipo-docto.cod-docto = c-param no-lock no-error.
            if avail tipo-docto then
                assign c-description = tipo-docto.conta-contabil.
            else
                assign c-description = " ".
        end.
        when "documento":U then do:
            find first tipo-docto where tipo-docto.cod-docto = c-param no-lock no-error.
            if avail tipo-docto then
                assign c-description = tipo-docto.descricao.
            else
                assign c-description = " ".
        end.
        when "identific":U then do:
           find first emitente where emitente.cod-emitente = int(c-param) no-lock no-error.
           if avail emitente then
              assign c-description = string(emitente.identific).
           else
              assign c-description = "".
        end.
        when "esp-doc":u then do:
           find esp-doc where esp-doc.cod-esp = trim(c-param) no-lock no-error.
           if avail esp-doc then 
              assign c-description = string(esp-doc.tipo).
           else
              assign c-description = "".
        end.
    end case.   
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetTextoFK DBOProgram 
PROCEDURE GetTextoFK :
/*------------------------------------------------------------------------------
    Purpose:     
    Parameters:  <none>
    Notes:       
------------------------------------------------------------------------------*/
    def input  param c-param       as char no-undo.
    def output param c-description as char no-undo.

    &if defined(BF_FIN_MODUL_CAMBIO) &then
        find first param-global no-lock no-error.
        if param-global.modulo-mec = yes then do:
        find texto-padrao-mec where texto-padrao-mec.codigo = int(c-param) no-lock no-error.
            if avail texto-padrao-mec then
                assign c-description = texto-padrao-mec.texto.
            else
                assign c-description = "".
        end.
    &endif

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-comprador":U THEN ASSIGN pFieldValue = RowObject.cod-comprador.
        WHEN "cod-corretor":U THEN ASSIGN pFieldValue = RowObject.cod-corretor.
        &IF "{&mguni_version}" < "2.07A" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "moeda":U THEN ASSIGN pFieldValue = RowObject.moeda.
        WHEN "nr-dias-cambiais":U THEN ASSIGN pFieldValue = RowObject.nr-dias-cambiais.
        WHEN "nr-dias-entr-docto":U THEN ASSIGN pFieldValue = RowObject.nr-dias-entr-docto.
        WHEN "nr-dias-liquidacao":U THEN ASSIGN pFieldValue = RowObject.nr-dias-liquidacao.
        WHEN "num-id-contrato-exp":U THEN ASSIGN pFieldValue = RowObject.num-id-contrato-exp.
        WHEN "num-id-operac-financ":U THEN ASSIGN pFieldValue = RowObject.num-id-operac-financ.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        WHEN "tp-contrato-exp":U THEN ASSIGN pFieldValue = RowObject.tp-contrato-exp.
        WHEN "tp-emprestimo":U THEN ASSIGN pFieldValue = RowObject.tp-emprestimo.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice default
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo     LIKE contrato-exp.ep-codigo     NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel   LIKE contrato-exp.cod-estabel   NO-UNDO.
    DEFINE OUTPUT PARAMETER preferencia    LIKE contrato-exp.referencia    NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-referencia LIKE contrato-exp.dt-referencia NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo     = RowObject.ep-codigo
           pcod-estabel   = RowObject.cod-estabel
           preferencia    = RowObject.referencia
           pdt-referencia = RowObject.dt-referencia.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey3 DBOProgram 
PROCEDURE getKey3 :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice referencia
  Parameters:  
               retorna valor do campo nr-contrato
               retorna valor do campo dt-contrato
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-contrato   LIKE contrato-EXP.nr-contrato  NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-contrato LIKE contrato-EXP.dt-contrato  NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-contrato = RowObject.nr-contrato
           pdt-contrato  = RowObject.dt-contrato.


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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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
  Purpose:     Reposiciona registro com base no ¡ndice default
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE contrato-exp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER preferencia LIKE contrato-exp.referencia NO-UNDO.
    DEFINE INPUT PARAMETER pdt-referencia LIKE contrato-exp.dt-referencia NO-UNDO.

    FIND FIRST bfcontrato-exp WHERE 
        bfcontrato-exp.cod-estabel = pcod-estabel AND 
        bfcontrato-exp.referencia = preferencia AND 
        bfcontrato-exp.dt-referencia = pdt-referencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcontrato-exp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcontrato-exp)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey2 DBOProgram 
PROCEDURE goToKey2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-contrato LIKE contrato-exp.nr-contrato NO-UNDO.
    DEFINE INPUT PARAMETER pdt-contrato LIKE contrato-exp.dt-contrato NO-UNDO.

    FIND FIRST bfcontrato-exp NO-LOCK
         WHERE bfcontrato-exp.nr-contrato = pnr-contrato
           AND bfcontrato-exp.dt-contrato = pdt-contrato NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcontrato-exp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcontrato-exp)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey3 DBOProgram 
PROCEDURE goToKey3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-contrato LIKE contrato-exp.nr-contrato NO-UNDO.

    FIND FIRST bfcontrato-exp NO-LOCK
         WHERE bfcontrato-exp.nr-contrato = pnr-contrato NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcontrato-exp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcontrato-exp)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LinkToContrato DBOProgram 
PROCEDURE LinkToContrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter phandle as handle no-undo.

    run SetConstraintMain in this-procedure.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LinkToTitulo DBOProgram 
PROCEDURE LinkToTitulo :
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
                           
    run SetConstraintTitulo in this-procedure (input i-ep-codigo,
                                               input c-cod-estabel,
                                               input c-referencia,
                                               input d-dt-referencia).

    RETURN "OK":U.                                                    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryContrato DBOProgram 
PROCEDURE OpenQueryContrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
         WHERE (contrato-exp.nr-contrato >= c-nr-contrato-ini and
                contrato-exp.nr-contrato <= c-nr-contrato-fim)
           and (contrato-exp.dt-contrato >= d-dt-contrato-ini and
                contrato-exp.dt-contrato <= d-dt-contrato-fim)
         by contrato-exp.nr-contrato INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryContratoEmprestimo DBOProgram 
PROCEDURE openQueryContratoEmprestimo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
         WHERE (contrato-exp.nr-contrato >= c-nr-contrato-ini and
                contrato-exp.nr-contrato <= c-nr-contrato-fim)
           and (contrato-exp.dt-contrato >= d-dt-contrato-ini and
                contrato-exp.dt-contrato <= d-dt-contrato-fim)
         /*  and  contrato-exp.tp-contrato-exp = 3*/
         by contrato-exp.nr-contrato INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryContratoSaldo DBOProgram 
PROCEDURE openQueryContratoSaldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
         WHERE (contrato-exp.nr-contrato >= c-nr-contrato-ini and
                contrato-exp.nr-contrato <= c-nr-contrato-fim)
           and (contrato-exp.dt-contrato >= d-dt-contrato-ini and
                contrato-exp.dt-contrato <= d-dt-contrato-fim)
           and ( (contrato-exp.vl-liquidar-me  > 0 and contrato-exp.situacao = 2) or 
                 (contrato-exp.tp-contrato-exp = 1 and contrato-exp.situacao  = 1))
         by contrato-exp.nr-contrato INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryContrPronto DBOProgram 
PROCEDURE OpenQueryContrPronto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
         WHERE (contrato-exp.nr-contrato >= c-nr-contrato-ini and
                contrato-exp.nr-contrato <= c-nr-contrato-fim)
           and (contrato-exp.dt-contrato >= d-dt-contrato-ini and
                contrato-exp.dt-contrato <= d-dt-contrato-fim)
           and contrato-exp.tp-contrato-exp = 1
           and contrato-exp.situacao    = 2 /*Contratado*/
         by contrato-exp.nr-contrato INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryContrSemTitulo DBOProgram 
PROCEDURE OpenQueryContrSemTitulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
         WHERE (contrato-exp.nr-contrato >= c-nr-contrato-ini and
                contrato-exp.nr-contrato <= c-nr-contrato-fim)
           and (contrato-exp.dt-contrato >= d-dt-contrato-ini and
                contrato-exp.dt-contrato <= d-dt-contrato-fim)
           and contrato-exp.tp-contrato-exp = 1
           and (contrato-exp.situacao   = 8
            OR  contrato-exp.situacao   = 3)
         by contrato-exp.nr-contrato INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryEmprestimo DBOProgram 
PROCEDURE OpenQueryEmprestimo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
         WHERE contrato-exp.tp-contrato-exp    = 3  INDEXED-REPOSITION.
    RETURN "OK":U.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryProntoDestinado DBOProgram 
PROCEDURE OpenQueryProntoDestinado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
         WHERE contrato-exp.tp-contrato-exp = 1
         AND   (contrato-exp.situacao   = 8 
         OR     contrato-exp.situacao   = 3)
         INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryReferencia DBOProgram 
PROCEDURE OpenQueryReferencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if c-cod-estabel-ini = c-cod-estabel-fim then
        OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
             WHERE (contrato-exp.cod-estabel  = c-cod-estabel-ini)
               and (contrato-exp.referencia >= c-referencia-ini and
                    contrato-exp.referencia <= c-referencia-fim)
               and (contrato-exp.dt-referencia >= d-dt-referencia-ini and
                    contrato-exp.dt-referencia <= d-dt-referencia-fim)
             by contrato-exp.cod-estabel INDEXED-REPOSITION.
    else
        OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
             WHERE (contrato-exp.cod-estabel >= c-cod-estabel-ini and
                    contrato-exp.cod-estabel <= c-cod-estabel-fim)
               and (contrato-exp.referencia >= c-referencia-ini and
                    contrato-exp.referencia <= c-referencia-fim)
               and (contrato-exp.dt-referencia >= d-dt-referencia-ini and
                    contrato-exp.dt-referencia <= d-dt-referencia-fim)
             by contrato-exp.cod-estabel INDEXED-REPOSITION.
             

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryReferenciaEmprestimo DBOProgram 
PROCEDURE openQueryReferenciaEmprestimo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if c-cod-estabel-ini = c-cod-estabel-fim then
        OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
             WHERE (contrato-exp.cod-estabel    = c-cod-estabel-ini)
               and (contrato-exp.referencia    >= c-referencia-ini and
                    contrato-exp.referencia    <= c-referencia-fim)
               and (contrato-exp.dt-referencia >= d-dt-referencia-ini and
                    contrato-exp.dt-referencia <= d-dt-referencia-fim)
               /*and  contrato-exp.tp-contrato-exp = 3*/
             by contrato-exp.cod-estabel INDEXED-REPOSITION.    
    else
        OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
             WHERE (contrato-exp.cod-estabel   >= c-cod-estabel-ini and
                    contrato-exp.cod-estabel   <= c-cod-estabel-fim)
               and (contrato-exp.referencia    >= c-referencia-ini and
                    contrato-exp.referencia    <= c-referencia-fim)
               and (contrato-exp.dt-referencia >= d-dt-referencia-ini and
                    contrato-exp.dt-referencia <= d-dt-referencia-fim)
               /*and  contrato-exp.tp-contrato-exp = 3 */
             by contrato-exp.cod-estabel INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryReferenciaSaldo DBOProgram 
PROCEDURE openQueryReferenciaSaldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if c-cod-estabel-ini = c-cod-estabel-fim then
        OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
             WHERE (contrato-exp.cod-estabel    = c-cod-estabel-ini)
               and (contrato-exp.referencia    >= c-referencia-ini and
                    contrato-exp.referencia    <= c-referencia-fim)
               and (contrato-exp.dt-referencia >= d-dt-referencia-ini and
                    contrato-exp.dt-referencia <= d-dt-referencia-fim)
              and ( (contrato-exp.vl-liquidar-me  > 0  and contrato-exp.situacao = 2) or 
                    (contrato-exp.tp-contrato-exp = 1  and contrato-exp.situacao  = 1))
             by contrato-exp.cod-estabel INDEXED-REPOSITION.    
    else
        OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
             WHERE (contrato-exp.cod-estabel >= c-cod-estabel-ini and
                    contrato-exp.cod-estabel <= c-cod-estabel-fim)
               and (contrato-exp.referencia >= c-referencia-ini and
                    contrato-exp.referencia <= c-referencia-fim)
               and (contrato-exp.dt-referencia >= d-dt-referencia-ini and
                    contrato-exp.dt-referencia <= d-dt-referencia-fim)
            and ( (contrato-exp.vl-liquidar-me  > 0 and contrato-exp.situacao = 2) or 
                  (contrato-exp.tp-contrato-exp = 1 and contrato-exp.situacao  = 1))
             by contrato-exp.cod-estabel INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryRefPronto DBOProgram 
PROCEDURE OpenQueryRefPronto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if c-cod-estabel-ini = c-cod-estabel-fim then
        OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
             WHERE (contrato-exp.cod-estabel    = c-cod-estabel-ini)
               and (contrato-exp.referencia    >= c-referencia-ini and
                    contrato-exp.referencia    <= c-referencia-fim)
               and (contrato-exp.dt-referencia >= d-dt-referencia-ini and
                    contrato-exp.dt-referencia <= d-dt-referencia-fim)
               and contrato-exp.tp-contrato-exp = 1
               and contrato-exp.situacao    = 2 /*Contratado*/
             by contrato-exp.cod-estabel INDEXED-REPOSITION.
    else
        OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
             WHERE (contrato-exp.cod-estabel >= c-cod-estabel-ini and
                    contrato-exp.cod-estabel <= c-cod-estabel-fim)
               and (contrato-exp.referencia >= c-referencia-ini and
                    contrato-exp.referencia <= c-referencia-fim)
               and (contrato-exp.dt-referencia >= d-dt-referencia-ini and
                    contrato-exp.dt-referencia <= d-dt-referencia-fim)
               and contrato-exp.tp-contrato-exp = 1
               and contrato-exp.situacao    = 2 /*Contratado*/
             by contrato-exp.cod-estabel INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryRefSemTitulo DBOProgram 
PROCEDURE OpenQueryRefSemTitulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if c-cod-estabel-ini = c-cod-estabel-fim then
        OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
             WHERE (contrato-exp.cod-estabel    = c-cod-estabel-ini)
               and (contrato-exp.referencia    >= c-referencia-ini and
                    contrato-exp.referencia    <= c-referencia-fim)
               and (contrato-exp.dt-referencia >= d-dt-referencia-ini and
                    contrato-exp.dt-referencia <= d-dt-referencia-fim)
               and contrato-exp.tp-contrato-exp = 1
               and (contrato-exp.situacao   = 8 
                OR  contrato-exp.situacao   = 3)
             by contrato-exp.cod-estabel INDEXED-REPOSITION.    
    else
        OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
             WHERE (contrato-exp.cod-estabel   >= c-cod-estabel-ini and
                    contrato-exp.cod-estabel   <= c-cod-estabel-fim)
               and (contrato-exp.referencia    >= c-referencia-ini and
                    contrato-exp.referencia    <= c-referencia-fim)
               and (contrato-exp.dt-referencia >= d-dt-referencia-ini and
                    contrato-exp.dt-referencia <= d-dt-referencia-fim)
               and contrato-exp.tp-contrato-exp = 1
               and (contrato-exp.situacao   = 8 
                OR  contrato-exp.situacao   = 3)
             by contrato-exp.cod-estabel INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySaldo DBOProgram 
PROCEDURE openQuerySaldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
         WHERE ((contrato-exp.situacao = 2       and        
                 contrato-exp.vl-liquidar-me > 0) 
          or     contrato-exp.situacao       = 1)
          and   (contrato-exp.tp-contrato-exp   = 1  or
                 contrato-exp.tp-contrato-exp   = 3) INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQuerySemTitulo DBOProgram 
PROCEDURE OpenQuerySemTitulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
         WHERE contrato-exp.situacao       = 8 and
               contrato-exp.tp-contrato-exp    = 1 INDEXED-REPOSITION.

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
         WHERE contrato-exp.ep-codigo     = c-ep-codigo-ini
           and contrato-exp.cod-estabel   = c-cod-estabel-ini
           and contrato-exp.referencia    = c-referencia-ini
           and contrato-exp.dt-referencia = d-dt-referencia-ini
         by contrato-exp.cod-estabel INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryTpContrato DBOProgram 
PROCEDURE openQueryTpContrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
         WHERE contrato-exp.vl-liquidar-me > 0 and
               contrato-exp.situacao       = 2 and
               contrato-exp.tp-contrato-exp    = 3 INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-acerto-vl-contrato-exp DBOProgram 
PROCEDURE pi-acerto-vl-contrato-exp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-ep-codigo     like contrato-exp.ep-codigo     no-undo.    
    def input param p-cod-estabel   like contrato-exp.cod-estabel   no-undo.
    def input param p-referencia    like contrato-exp.referencia    no-undo.   
    def input param p-dt-referencia like contrato-exp.dt-referencia no-undo.
    def buffer b-contrato-exp for contrato-exp.
    def var vl-total-compl-movto as dec format "->>,>>>,>>>,>>9.99":U decimals 2 no-undo.

    find first b-contrato-exp no-lock
         where b-contrato-exp.ep-codigo     = p-ep-codigo    
         and   b-contrato-exp.cod-estabel   = p-cod-estabel  
         and   b-contrato-exp.referencia    = p-referencia   
         and   b-contrato-exp.dt-referencia = p-dt-referencia no-error.
    if avail b-contrato-exp
    and b-contrato-exp.situacao = 3 /*Liquidado*/ then do:
        for each contr-titulo-exp no-lock
            where contr-titulo-exp.nr-contrato = b-contrato-exp.nr-contrato
            and   contr-titulo-exp.dt-contrato = b-contrato-exp.dt-contrato:

            create tt_chave_tit_acr.
            assign tt_chave_tit_acr.tta_num_contrat_id_cambio = b-contrato-exp.num-id-contrato-exp
                   tt_chave_tit_acr.tta_cod_empresa           = string(contr-titulo-exp.ep-codigo)
                   tt_chave_tit_acr.tta_cod_estab             = contr-titulo-exp.cod-estabel
                   tt_chave_tit_acr.tta_cod_espec_docto       = contr-titulo-exp.cod-esp
                   tt_chave_tit_acr.tta_cod_ser_docto         = contr-titulo-exp.serie
                   tt_chave_tit_acr.tta_cod_tit_acr           = contr-titulo-exp.nr-docto
                   tt_chave_tit_acr.tta_cod_parcela           = contr-titulo-exp.parcela.
        end.

        run pi-busca-empresa in this-procedure (output c-ep-codigo).

        /* Conecta Bases EMS 5 */
        {ecp/ec0005b.i 1}
        
        /*** Verifica Erro na ConexÆo das Bases ***/
        {ecp/ec0005k.i}
        
        if i-seq-erro <> 0 then do:
            {method/showmessage.i1}
            {method/showmessage.i2}
      
            for each RowErrors:
                delete RowErrors.
            end.

            return "NOK":U.
        end.
        
        &IF "{&mguni_version}" <= "2.06B" &THEN
        assign v_cod_usuar_corren_old = v_cod_usuar_corren 
               v_cod_empres_usuar_old = v_cod_empres_usuar
               v_cod_usuar_corren     = ""
               v_cod_empres_usuar     = "".
    
        assign v_cod_grp_usuar_lst_old = v_cod_grp_usuar_lst
               v_cod_grp_usuar_lst     = "".
        
        /*** chama login do usuario ***/
        run prgtec/btb/btb906za.py.
        
        if v_cod_usuar_corren = "" 
        or v_cod_empres_usuar = "" then do:
            assign v_cod_usuar_corren = v_cod_usuar_corren_old 
                   v_cod_empres_usuar = v_cod_empres_usuar_old
                   v_cod_grp_usuar_lst = v_cod_grp_usuar_lst_old.
           return "NOK":U.
        end.
        &ENDIF

        if not valid-handle(h-acr788za) then
            run prgfin/acr/acr788za.py persistent set h-acr788za.

        run pi_totalizar_compl_movto in h-acr788za (input table tt_chave_tit_acr,
                                                    output vl-total-compl-movto).
        delete procedure h-acr788za.

        /* Desconecta Bases EMS 5 */
        {ecp/ec0005b.i 2}

        /*** Verifica Erro na DesconexÆo das Bases ***/
        {ecp/ec0005k.i}

        if i-seq-erro <> 0 then do:

            {method/showmessage.i1}
            {method/showmessage.i2}
      
            for each RowErrors:
                delete RowErrors.
            end.

            return "NOK":U.
        end.

        if  vl-total-compl-movto <> 0 
        and vl-total-compl-movto <> b-contrato-exp.vl-contrato then do:
            find first contrato-exp exclusive-lock
                 where contrato-exp.ep-codigo     = b-contrato-exp.ep-codigo    
                 and   contrato-exp.cod-estabel   = b-contrato-exp.cod-estabel  
                 and   contrato-exp.referencia    = b-contrato-exp.referencia   
                 and   contrato-exp.dt-referencia = b-contrato-exp.dt-referencia no-error.
            if avail contrato-exp then
                assign contrato-exp.vl-contrato = vl-total-compl-movto.
        end.
    end.

    &IF "{&mguni_version}" <= "2.06B" &THEN
    assign v_cod_usuar_corren = v_cod_usuar_corren_old 
           v_cod_empres_usuar = v_cod_empres_usuar_old.

    assign v_cod_grp_usuar_lst = v_cod_grp_usuar_lst_old.
    &ENDIF
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-acrescenta-contrato DBOProgram 
PROCEDURE pi-acrescenta-contrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input        param p-nr-contrato like contrato-exp.nr-contrato.
    def input-output param table for tt-contrato-exp.

    find first contrato-exp no-lock
         where     contrato-exp.nr-contrato = p-nr-contrato 
         use-index contrato no-error.
    if avail contrato-exp           and 
       contrato-exp.tp-contrato-exp = 1 then do:
        create tt-contrato-exp.
        buffer-copy contrato-exp to tt-contrato-exp.
    
        RETURN "OK":U.
    end.
    else
        RETURN "NOK":U.

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
    /*** Procedure utilizada no m½dulo de cŸmbio ***/

    def input  param p-ep-codigo   like titulo.ep-codigo   no-undo.
    def input  param p-cod-estabel like titulo.cod-estabel no-undo.
    def input  param p-cod-esp     like titulo.cod-esp     no-undo.
    def input  param p-serie       like titulo.serie       no-undo.
    def input  param p-nr-docto    like titulo.nr-docto    no-undo.
    def input  param p-parcela     like titulo.parcela     no-undo.
    def output param table         for  tt-contratos.

    &if defined(BF_FIN_MODUL_CAMBIO) &then
        find first param-global no-lock no-error.
        if param-global.modulo-mec = yes then do:
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
                    where contrato-exp.ep-codigo     = contr-titulo-exp.ep-codigo     and
                            contrato-exp.cod-estabel   = contr-titulo-exp.cod-estabel   and
                            contrato-exp.referencia    = contr-titulo-exp.referencia    and
                            contrato-exp.dt-referencia = contr-titulo-exp.dt-referencia no-lock:
                    
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
                end.
            end.
        end.
    &endif

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-saldo-contrato DBOProgram 
PROCEDURE pi-atualiza-saldo-contrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-ep-codigo     like contrato-exp.ep-codigo           no-undo.
    def input param p-cod-estabel   like contrato-exp.cod-estabel         no-undo.
    def input param p-referencia    like contrato-exp.referencia          no-undo.
    def input param p-dt-referencia like contrato-exp.dt-referencia       no-undo.
    def input param p-ind-situacao  as   integer                          no-undo.
    def input param p-vl-liquidar   as   decimal format "->>>,>>>,>>9.99" no-undo.
    def input param p-vl-liquidado  as   decimal format "->>>,>>>,>>9.99" no-undo.
    def buffer bf-contrato-exp      for  contrato-exp.

    def var h-boad362 as handle no-undo.
                 
    run adbo/boad362.p persistent set h-boad362.

    find bf-contrato-exp where bf-contrato-exp.ep-codigo     = p-ep-codigo   and
                               /*bf-contrato-exp.cod-estabel   = p-cod-estabel and nÆo deve ser mais usado o estabelecimento*/
                               bf-contrato-exp.referencia    = p-referencia  and
                               bf-contrato-exp.dt-referencia = p-dt-referencia exclusive-lock no-error.
    if  not avail bf-contrato-exp then do:
        RETURN "NOK":U.
    end.
    
    IF bf-contrato-exp.situacao <> 9 and 
       bf-contrato-exp.situacao <> 1  THEN DO:
        assign bf-contrato-exp.vl-liquidar-me  = bf-contrato-exp.vl-liquidar-me  - p-vl-liquidar
               bf-contrato-exp.vl-liquidado-me = bf-contrato-exp.vl-liquidado-me + p-vl-liquidado.
    END.

    if p-ind-situacao = 1 then do:
        IF bf-contrato-exp.situacao = 9 THEN DO:
            run pi-atualiza-historico in h-boad362 (input bf-contrato-exp.ep-codigo,
                                                    input bf-contrato-exp.cod-estabel,
                                                    input bf-contrato-exp.referencia,
                                                    input bf-contrato-exp.dt-referencia,
                                                    input "Situacao do Contrato",
                                                    input string({adinc/i02ad346.i 04 bf-contrato-exp.situacao}),
                                                    input string({adinc/i02ad346.i 04 1})).
            assign bf-contrato-exp.situacao = 1.
        END.
        IF bf-contrato-exp.situacao = 3 THEN DO:
            run pi-atualiza-historico in h-boad362 (input bf-contrato-exp.ep-codigo,
                                                    input bf-contrato-exp.cod-estabel,
                                                    input bf-contrato-exp.referencia,
                                                    input bf-contrato-exp.dt-referencia,
                                                    input "Situacao do Contrato",
                                                    input string({adinc/i02ad346.i 04 bf-contrato-exp.situacao}),
                                                    input string({adinc/i02ad346.i 04 2})).
            assign bf-contrato-exp.situacao = 2.
        END.
    end.

    if bf-contrato-exp.situacao = 3 then do:
        run pi-atualiza-historico in h-boad362 (input bf-contrato-exp.ep-codigo,
                                                input bf-contrato-exp.cod-estabel,
                                                input bf-contrato-exp.referencia,
                                                input bf-contrato-exp.dt-referencia,
                                                input "Situacao do Contrato",
                                                input string({adinc/i02ad346.i 04 bf-contrato-exp.situacao}),
                                                input string({adinc/i02ad346.i 04 2})).
        assign bf-contrato-exp.situacao = 2.
    end.

    if p-ind-situacao = 3 then do:
        IF bf-contrato-exp.situacao         = 2                              and
           bf-contrato-exp.vl-liquidado-me  = bf-contrato-exp.vl-contrato-me THEN DO:
            run pi-atualiza-historico in h-boad362 (input bf-contrato-exp.ep-codigo,
                                                    input bf-contrato-exp.cod-estabel,
                                                    input bf-contrato-exp.referencia,
                                                    input bf-contrato-exp.dt-referencia,
                                                    input "Situacao do Contrato",
                                                    input string({adinc/i02ad346.i 04 bf-contrato-exp.situacao}),
                                                    input string({adinc/i02ad346.i 04 3})).
            assign bf-contrato-exp.situacao = 3.
        END.
        IF bf-contrato-exp.situacao = 1 THEN DO:
            ASSIGN l-altera = YES.
            FOR EACH contr-titulo-exp  
               WHERE contr-titulo-exp.nr-contrato  = bf-contrato-exp.nr-contrato
                AND  contr-titulo-exp.dt-contrato  = bf-contrato-exp.dt-contrato  NO-LOCK:
                IF contr-titulo-exp.sl-liquidar-me <> 0 THEN
                    ASSIGN l-altera = NO.
            END.
            
            IF l-altera = YES THEN DO:
                run pi-atualiza-historico in h-boad362 (input bf-contrato-exp.ep-codigo,
                                                        input bf-contrato-exp.cod-estabel,
                                                        input bf-contrato-exp.referencia,
                                                        input bf-contrato-exp.dt-referencia,
                                                        input "Situacao do Contrato",
                                                        input string({adinc/i02ad346.i 04 bf-contrato-exp.situacao}),
                                                        input string({adinc/i02ad346.i 04 9})).
                assign bf-contrato-exp.situacao = 9.
            END.
        END.
    end.

    if p-ind-situacao = 5 then do:
        run pi-atualiza-historico in h-boad362 (input bf-contrato-exp.ep-codigo,
                                                input bf-contrato-exp.cod-estabel,
                                                input bf-contrato-exp.referencia,
                                                input bf-contrato-exp.dt-referencia,
                                                input "Situacao do Contrato",
                                                input string({adinc/i02ad346.i 04 bf-contrato-exp.situacao}),
                                                input string({adinc/i02ad346.i 04 5})).
        assign bf-contrato-exp.situacao = 5.
    end.
    
    if p-ind-situacao = 8 then do:
        run pi-atualiza-historico in h-boad362 (input bf-contrato-exp.ep-codigo,
                                                input bf-contrato-exp.cod-estabel,
                                                input bf-contrato-exp.referencia,
                                                input bf-contrato-exp.dt-referencia,
                                                input "Situacao do Contrato",
                                                input string({adinc/i02ad346.i 04 bf-contrato-exp.situacao}),
                                                input string({adinc/i02ad346.i 04 8})).
        assign bf-contrato-exp.situacao = 8.
    end.

    if p-ind-situacao = 98 then do:
        /*** Cancela Liquida‡Æo Cambio Futuro ***/
        run pi-atualiza-historico in h-boad362 (input bf-contrato-exp.ep-codigo,
                                                input bf-contrato-exp.cod-estabel,
                                                input bf-contrato-exp.referencia,
                                                input bf-contrato-exp.dt-referencia,
                                                input "Situacao do Contrato",
                                                input string({adinc/i02ad346.i 04 bf-contrato-exp.situacao}),
                                                input string({adinc/i02ad346.i 04 2})).
        assign bf-contrato-exp.situacao = 2.
    end.

    if valid-handle(h-boad362) then
        delete procedure h-boad362.

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
    def var i-ep-codigo like contrato-exp.ep-codigo.
    def var c-usuario   like contrato-exp.usuario.
    
    {method/svc/autentic/autentic.i
            &vUserEnterprise="i-ep-codigo"
            &vUserName="c-usuario"}
    
    assign RowObject.ep-codigo = i-ep-codigo
           RowObject.usuario   = c-usuario
           RowObject.c-time   = string(TIME, "HH:MM")
           RowObject.dt-today = today.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-baixa-titulo DBOProgram 
PROCEDURE pi-baixa-titulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-produto as char no-undo.
def input param table for tt-doc-b-cr.
def input param table for tt-lin-b-cr.
def input param table for tt-cheque-pend.
def input param table for tt-lin-ant.
def input param table for tt-lin-prev.
def input param table for tt-impto-tit-pend-cr.
def input param table for tt-relacto-pend-titulo-cheq.
def input-output param table for tt-retorno-lin-b-cr.

def var c-ep-codigo like contrato-exp.ep-codigo.
def var c-usuario   like contrato-exp.usuario.

if  p-produto = "EMS 2" then do:
    /**************************** CHAMADA EPC CECRISA *************************/
    if  c-nom-prog-upc-mg97 <> "" then DO:

        
        find first tt-lin-b-cr no-lock no-error.
        if avail tt-lin-b-cr then do:

            ASSIGN c-campo = string(tt-lin-b-cr.ep-codigo)   + ";" + tt-lin-b-cr.cod-estabel        + ";" +
                             tt-lin-b-cr.cod-esp             + ";" + tt-lin-b-cr.serie              + ";" +
                             tt-lin-b-cr.nr-docto            + ";" + tt-lin-b-cr.parcela            + ";" +
                             string(tt-lin-b-cr.vl-baixa-me) + ";" + string(tt-lin-b-cr.dt-credito) + ";" +
                             string(tt-lin-b-cr.Cotacao-dia) + ";" + STRING(tt-lin-b-cr.dt-pgto)    + ";" +
                             tt-lin-b-cr.referencia          + ";" + STRING(tt-lin-b-cr.portador).  
        end.

        find first tt-doc-b-cr no-lock no-error.
        if avail tt-doc-b-cr then do:
            
            assign c-campo = c-campo + ";" + string(tt-doc-b-cr.dt-credito).
        end.

        for each tt-epc where tt-epc.cod-event = 'Saldo_Comis_Cecrisa':
            delete tt-epc.
        end.

        {include/i-epc200.i2 &CodEvent='"Saldo_Comis_Cecrisa"'
                             &CodParameter='"chave_titulo"'
                             &ValueParameter="c-campo"}

        {include/i-epc201.i "Saldo_Comis_Cecrisa"}

        for first tt-epc no-lock
            where tt-epc.cod-event     = "Saldo_Comis_Cecrisa":U 
              and tt-epc.cod-parameter = "Erro_Liquidacao_Cecrisa":U:

            if num-entries(tt-epc.val-parameter) >= 4 then do:
                create tt-retorno-lin-b-cr.
                assign tt-retorno-lin-b-cr.cod-erro  = entry(1,tt-epc.val-parameter,";")
                       tt-retorno-lin-b-cr.desc-erro = entry(2,tt-epc.val-parameter,";")
                       tt-retorno-lin-b-cr.situacao  = if entry(3,tt-epc.val-parameter,";") = "yes" then yes else no
                       tt-retorno-lin-b-cr.cod-chave = entry(4,tt-epc.val-parameter,";"). 
                return "OK":U.
            END.
        end.
    end.
    /**************************************************************************/
    
end.
else
  if  p-produto = "EMS 5" then do:
      {method/svc/autentic/autentic.i
          &vUserEnterprise="c-ep-codigo"
          &vUserName="c-usuario"}
      
      for each tt-docto-cr:
          delete tt-docto-cr.
      end.
      for each tt-linha-cr1:
          delete tt-linha-cr1.
      end.
      
      for each tt-doc-b-cr:
          create tt-docto-cr.
          assign tt-docto-cr.ep-codigo   = tt-doc-b-cr.ep-codigo
                 tt-docto-cr.referencia  = tt-doc-b-cr.referencia
                 tt-docto-cr.cod-usuario = c-usuario
                 tt-docto-cr.dt-movto    = tt-doc-b-cr.dt-credito.

          FIND FIRST tt-lin-b-cr NO-LOCK
               WHERE tt-lin-b-cr.ep-codigo  = tt-doc-b-cr.ep-codigo
                 AND tt-lin-b-cr.referencia = tt-doc-b-cr.referencia NO-ERROR.
          IF  AVAIL tt-lin-b-cr THEN
              ASSIGN tt-docto-cr.cod-estabel = tt-lin-b-cr.cod-estabel.
      end.
      
      find first tt-lin-b-cr no-error.
      if avail tt-lin-b-cr then do:
          find first contrato-exp no-lock
               where contrato-exp.ep-codigo     = tt-lin-b-cr.ep-codigo     
               and   contrato-exp.cod-estabel   = tt-lin-b-cr.estabel-mec  
               and   contrato-exp.referencia    = tt-lin-b-cr.referencia-mec    
               and   contrato-exp.dt-referencia = tt-lin-b-cr.dt-referencia-mec no-error.
      end.

      for each tt-lin-b-cr:
          create tt-linha-cr1.
          assign tt-linha-cr1.ep-codigo      = tt-lin-b-cr.ep-codigo
                 tt-linha-cr1.referencia     = tt-lin-b-cr.referencia
                 tt-linha-cr1.cod-estabel    = tt-lin-b-cr.cod-estabel
                 tt-linha-cr1.cod-esp        = tt-lin-b-cr.cod-esp
                 tt-linha-cr1.serie          = tt-lin-b-cr.serie
                 tt-linha-cr1.nr-docto       = tt-lin-b-cr.nr-docto
                 tt-linha-cr1.parcela        = tt-lin-b-cr.parcela
                 tt-linha-cr1.cod-portador   = tt-lin-b-cr.portador
                 tt-linha-cr1.modalidade     = tt-lin-b-cr.modalidade
                 tt-linha-cr1.cod-emitente   = tt-lin-b-cr.cod-emitente
                 tt-linha-cr1.mo-codigo      = tt-lin-b-cr.mo-codigo
                 tt-linha-cr1.vl-baixa-me    = if avail contrato-exp
                                               and contrato-exp.situacao = 1 /*Pendente de Contrato*/ then 
                                                   tt-lin-b-cr.vl-baixa-me
                                               else tt-lin-b-cr.vl-baixa
                 tt-linha-cr1.vl-cotacao     = 1 / tt-lin-b-cr.cotacao-dia /*tt-lin-b-cr.vl-baixa-me / tt-lin-b-cr.vl-baixa*/
                 tt-linha-cr1.dt-credito     = tt-lin-b-cr.dt-credito
                 tt-linha-cr1.nr-contrato    = tt-lin-b-cr.nr-contrato
                 tt-linha-cr1.dt-contrato    = tt-lin-b-cr.dt-contrato
                 tt-linha-cr1.num-id-contrato-exp = tt-lin-b-cr.num-id-contrato-exp
                 tt-linha-cr1.estabel-mec    = tt-lin-b-cr.estabel-mec
                 tt-linha-cr1.referencia-mec = tt-lin-b-cr.referencia-mec
                 tt-linha-cr1.dt-referencia-mec = tt-lin-b-cr.dt-referencia-mec
                 tt-linha-cr1.dt-baixa       = tt-lin-b-cr.dt-pgto

                 /* Este campo armazena valor em real ref liquidi‡Æo no cambio, 
                    pois ocorria erro de centavo, devido arredondamento */
                 tt-linha-cr1.vl-liquido = tt-lin-b-cr.vl-baixa-me.
      end.
      
      /* conexÆo bases ems5 */
&IF "{&mguni_version}" >= "2.07A" &THEN
      {cdp/cd1202.i3 c-ep-codigo}
&ELSE
      {cdp/cd1202.i3 INT(c-ep-codigo)}
&ENDIF
      
      if l-conec-bas = no or l-conec-fin = no or l-conec-uni = no then do:
         for each tt_erros_conexao:
             CREATE tt-retorno-lin-b-cr.
             ASSIGN tt-retorno-lin-b-cr.cod-erro  = STRING(tt_erros_conexao.cd-erro)
                    tt-retorno-lin-b-cr.desc-erro = tt_erros_conexao.mensagem.
         end.
         return "OK":U.
      end.
      
      &IF "{&mguni_version}" <= "2.06B" &THEN
      assign v_cod_grp_usuar_lst_old = v_cod_grp_usuar_lst
             v_cod_usuar_corren_old  = v_cod_usuar_corren 
             v_cod_empres_usuar_old  = v_cod_empres_usuar
             v_cod_usuar_corren      = ""
             v_cod_empres_usuar      = "".

      assign v_cod_grp_usuar_lst     = "".
      
      /*** chama login do usuario ***/
      run prgtec/btb/btb906za.py.

      if v_cod_usuar_corren = "" 
      or v_cod_empres_usuar = "" then do:
         assign v_cod_usuar_corren = v_cod_usuar_corren_old 
                v_cod_empres_usuar = v_cod_empres_usuar_old
                v_cod_grp_usuar_lst = v_cod_grp_usuar_lst_old.
         return "NOK":U.
      end.
      &ENDIF
      
      RUN prgfin/acr/acr790zb.p (input  table tt-docto-cr,
                                 input  table tt-linha-cr1,
                                 output table tt_log_erro).

      &IF "{&mguni_version}" <= "2.06B" &THEN
      assign v_cod_grp_usuar_lst = v_cod_grp_usuar_lst_old
             v_cod_usuar_corren  = v_cod_usuar_corren_old 
             v_cod_empres_usuar  = v_cod_empres_usuar_old.
      &ENDIF

      /* DesconexÆo bases ems5 */
&IF "{&mguni_version}" >= "2.07A" &THEN
      {cdp/cd1202.i4 c-ep-codigo}
&ELSE
      {cdp/cd1202.i4 INT(c-ep-codigo)}
&ENDIF
      
      for each tt_log_erro:
          create tt-retorno-lin-b-cr.
          ASSIGN tt-retorno-lin-b-cr.cod-erro  = STRING(tt_log_erro.ttv_num_cod_erro)
                 tt-retorno-lin-b-cr.cod-chave = '1'
                 tt-retorno-lin-b-cr.desc-erro = tt_log_erro.ttv_des_msg_erro.
          
          create tt-retorno-lin-b-cr.
          ASSIGN tt-retorno-lin-b-cr.cod-erro  = STRING(tt_log_erro.ttv_num_cod_erro)
                 tt-retorno-lin-b-cr.cod-chave = '2'
                 tt-retorno-lin-b-cr.desc-erro = tt_log_erro.ttv_des_msg_ajuda.
      end.
  end.
  
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-banco-portador DBOProgram 
PROCEDURE pi-banco-portador :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input  param p-ep-codigo    like portador.ep-codigo    no-undo.
def input  param p-cod-portador like portador.cod-portador no-undo.
def output param v-cod-banco    like portador.cod-banco    no-undo. 

find first portador
    where portador.ep-codigo    = p-ep-codigo
    and   portador.cod-portador = p-cod-portador no-lock no-error.
if  avail portador then
    assign v-cod-banco = portador.cod-banco.
else
    assign v-cod-banco = 0.

return "ok":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-alteracao-operac-financ DBOProgram 
PROCEDURE pi-busca-alteracao-operac-financ :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER p-num-id-operac-financ AS INTEGER.
    def input parameter p-vl-vincular as dec  no-undo.
    

    run pi-busca-empresa in this-procedure (output c-ep-codigo).

    /* Conecta Bases EMS 5 */
    {ecp/ec0005b.i 1}
    
    /*** Verifica Erro na Conex’o das Bases ***/
    {ecp/ec0005k.i}
    
    if i-seq-erro <> 0 then do:
        {method/showmessage.i1}
        {method/showmessage.i2}
  
        for each RowErrors:
            delete RowErrors.
        end.

        return "NOK":U.
    end.

    &IF "{&mguni_version}" <= "2.06B" &THEN
    assign v_cod_usuar_corren_old = v_cod_usuar_corren 
           v_cod_empres_usuar_old = v_cod_empres_usuar
           v_cod_usuar_corren     = ""
           v_cod_empres_usuar     = "".

    assign v_cod_grp_usuar_lst_old = v_cod_grp_usuar_lst
           v_cod_grp_usuar_lst     = "".
    
    /*** chama login do usuario ***/
    run prgtec/btb/btb906za.py.
    
    if v_cod_usuar_corren = "" 
    or v_cod_empres_usuar = "" then do:
        assign v_cod_usuar_corren = v_cod_usuar_corren_old 
               v_cod_empres_usuar = v_cod_empres_usuar_old
               v_cod_grp_usuar_lst = v_cod_grp_usuar_lst_old.
        return "NOK":U.
    end.
    &ENDIF

    if not valid-handle(h-acr788za) then
        run prgfin/acr/acr788za.py persistent set h-acr788za.

        run pi_altera_operac_financ in h-acr788za(input p-num-id-operac-financ,
                                                  input p-vl-vincular).

    delete procedure h-acr788za.

    /* Desconecta Bases EMS 5 */
    {ecp/ec0005b.i 2}

    /*** Verifica Erro na Desconex’o das Bases ***/
    {ecp/ec0005k.i}

    if i-seq-erro <> 0 then do:

        {method/showmessage.i1}
        {method/showmessage.i2}
  
        for each RowErrors:
            delete RowErrors.
        end.

        return "NOK":U.
    end.

    &IF "{&mguni_version}" <= "2.06B" &THEN
    assign v_cod_grp_usuar_lst = v_cod_grp_usuar_lst_old.           
    assign v_cod_usuar_corren = v_cod_usuar_corren_old 
           v_cod_empres_usuar = v_cod_empres_usuar_old.
    &ENDIF
    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-campos-ems2 DBOProgram 
PROCEDURE pi-busca-campos-ems2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p-num-id-contrato as integer no-undo.
    def output param table for tt_campos_mec.

    for each tt_campos_mec:
        delete tt_campos_mec.
    end.

    find first contr-despesa-exp where contr-despesa-exp.int-1 = p-num-id-contrato no-lock no-error.
    if avail contr-despesa-exp then do:
        find contrato-exp no-lock
             where contrato-exp.ep-codigo     = contr-despesa-exp.ep-codigo
             and   contrato-exp.cod-estabel   = contr-despesa-exp.cod-estabel
             and   contrato-exp.referencia    = contr-despesa-exp.referencia
             and   contrato-exp.dt-referencia = contr-despesa-exp.dt-referencia no-error.
        if avail contrato-exp then do:
            create tt_campos_mec.
            assign tt_campos_mec.ttv_cod_estab_ext    = contrato-exp.cod-estabel
                   tt_campos_mec.ttv_cod_empresa_ext  = string(contrato-exp.ep-codigo)
                   tt_campos_mec.ttv_cod_contrat_2    = contrato-exp.nr-contrato
                   tt_campos_mec.ttv_dat_contrat      = contrato-exp.dt-contrato
                   tt_campos_mec.ttv_cod_refer        = contrato-exp.referencia
                   tt_campos_mec.ttv_dat_refer        = contrato-exp.dt-referencia
                   tt_campos_mec.tta_cod_modul_integr = "EXP".
        end.
    end.
    else do:
        find first contrato-exp where contrato-exp.num-id-contrato-exp = p-num-id-contrato no-lock no-error.
        if avail contrato-exp then do:
            create tt_campos_mec.
            assign tt_campos_mec.ttv_cod_estab_ext    = contrato-exp.cod-estabel
                   tt_campos_mec.ttv_cod_empresa_ext  = string(contrato-exp.ep-codigo)
                   tt_campos_mec.ttv_cod_contrat_2    = contrato-exp.nr-contrato
                   tt_campos_mec.ttv_dat_contrat      = contrato-exp.dt-contrato
                   tt_campos_mec.ttv_cod_refer        = contrato-exp.referencia
                   tt_campos_mec.ttv_dat_refer        = contrato-exp.dt-referencia
                   tt_campos_mec.tta_cod_modul_integr = "EXP".
        end.
        ELSE DO:
            FIND movto-contrat-tit-export NO-LOCK
                WHERE movto-contrat-tit-export.cdn-trans   = 4 /*devolucao*/ 
                AND   movto-contrat-tit-export.num-livre-1 = p-num-id-contrato NO-ERROR.
            IF  AVAIL movto-contrat-tit-export THEN DO:
                find contrato-exp no-lock
                     where contrato-exp.ep-codigo     = movto-contrat-tit-export.cdn-empresa
                     and   contrato-exp.cod-estabel   = movto-contrat-tit-export.cod-estab
                     and   contrato-exp.referencia    = movto-contrat-tit-export.cod-refer
                     and   contrato-exp.dt-referencia = movto-contrat-tit-export.dat-refer-contrat no-error.
                if avail contrato-exp then do:
                    create tt_campos_mec.
                    assign tt_campos_mec.ttv_cod_estab_ext    = contrato-exp.cod-estabel
                           tt_campos_mec.ttv_cod_empresa_ext  = string(contrato-exp.ep-codigo)
                           tt_campos_mec.ttv_cod_contrat_2    = contrato-exp.nr-contrato
                           tt_campos_mec.ttv_dat_contrat      = contrato-exp.dt-contrato
                           tt_campos_mec.ttv_cod_refer        = contrato-exp.referencia
                           tt_campos_mec.ttv_dat_refer        = contrato-exp.dt-referencia
                           tt_campos_mec.tta_cod_modul_integr = "EXP".
                end.
            END.
        END.
    end.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-campos-ems2-cfl DBOProgram 
PROCEDURE pi-busca-campos-ems2-cfl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-num-id-contrato as integer no-undo.
    def input-output param table for tt_campos_mec_cfl.

    find first contr-despesa-exp where contr-despesa-exp.int-1 = p-num-id-contrato no-lock no-error.
    if avail contr-despesa-exp then do:
        find first contrato-exp no-lock
             where contrato-exp.ep-codigo     = contr-despesa-exp.ep-codigo
             and   contrato-exp.cod-estabel   = contr-despesa-exp.cod-estabel
             and   contrato-exp.referencia    = contr-despesa-exp.referencia
             and   contrato-exp.dt-referencia = contr-despesa-exp.dt-referencia no-error.
        if avail contrato-exp then do:
            create tt_campos_mec_cfl.
            assign tt_campos_mec_cfl.ttv_cod_estab_ext           = contrato-exp.cod-estabel
                   tt_campos_mec_cfl.ttv_cod_empresa_ext         = string(contrato-exp.ep-codigo)
                   tt_campos_mec_cfl.ttv_cod_contrat_2           = contrato-exp.nr-contrato
                   tt_campos_mec_cfl.ttv_dat_contrat             = contrato-exp.dt-contrato
                   tt_campos_mec_cfl.ttv_cod_refer               = contrato-exp.referencia
                   tt_campos_mec_cfl.ttv_dat_refer               = contrato-exp.dt-referencia
                   tt_campos_mec_cfl.tta_cod_modul_integr        = "EXP"
                   tt_campos_mec_cfl.ttv_val_despes_mec          = contr-despesa-exp.valor-movto    
                   tt_campos_mec_cfl.ttv_cod_docto_empres_despes = contr-despesa-exp.nr-docto-emp.
        end.
    end.
    ELSE DO:
        FIND FIRST val-movto-contrat-tit-export no-lock
            WHERE val-movto-contrat-tit-export.num-id-val-movto-contrat = p-num-id-contrato NO-ERROR.
        IF AVAIL val-movto-contrat-tit-export THEN DO:
            FIND FIRST movto-contrat-tit-export NO-LOCK
                WHERE movto-contrat-tit-export.num-id-movto-contrat = val-movto-contrat-tit-export.num-id-movto-contrat NO-ERROR.
            IF AVAIL movto-contrat-tit-export THEN DO:
                FIND FIRST contr-titulo-exp
                    WHERE contr-titulo-exp.cod-esp      = movto-contrat-tit-export.cod-espec-docto 
                      AND contr-titulo-exp.cod-estabel  = movto-contrat-tit-export.cod-estab
                      AND contr-titulo-exp.dt-vinculado = movto-contrat-tit-export.dat-vinculac-tit
                      AND contr-titulo-exp.ep-codigo    = movto-contrat-tit-export.cdn-empresa
                      AND contr-titulo-exp.nr-docto     = movto-contrat-tit-export.cod-docto
                      AND contr-titulo-exp.parcela      = movto-contrat-tit-export.cod-parcela
                      AND contr-titulo-exp.serie        = movto-contrat-tit-export.cod-serie NO-LOCK NO-ERROR.
                IF AVAIL contr-titulo-exp THEN DO:
                    FIND FIRST contrato-exp NO-LOCK
                         WHERE contrato-exp.cod-estabel    = contr-titulo-exp.cod-estabel
                           AND contrato-exp.ep-codigo      = contr-titulo-exp.ep-codigo
                           AND contrato-exp.dt-referencia  = contr-titulo-exp.dt-referencia
                           AND contrato-exp.referencia     = contr-titulo-exp.referencia no-error.
                    IF AVAIL contrato-exp THEN DO:
                        create tt_campos_mec_cfl.
                        assign tt_campos_mec_cfl.ttv_cod_estab_ext           = contrato-exp.cod-estabel
                               tt_campos_mec_cfl.ttv_cod_empresa_ext         = string(contrato-exp.ep-codigo)
                               tt_campos_mec_cfl.ttv_cod_contrat_2           = contrato-exp.nr-contrato
                               tt_campos_mec_cfl.ttv_dat_contrat             = contrato-exp.dt-contrato
                               tt_campos_mec_cfl.ttv_cod_refer               = contrato-exp.referencia
                               tt_campos_mec_cfl.ttv_dat_refer               = contrato-exp.dt-referencia
                               tt_campos_mec_cfl.tta_cod_modul_integr        = "EXP"
                               tt_campos_mec_cfl.ttv_val_despes_mec          = 0
                               tt_campos_mec_cfl.ttv_cod_docto_empres_despes = "".
                    END.
                END.
            END.
        END.
    END.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-conta-credito DBOProgram 
PROCEDURE pi-busca-conta-credito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p-cod-portador like portador.cod-portador.
    def output param p-moeda        like portador.mo-codigo.
    def output param p-conta-saldo  like cta-corrente.conta-saldo.

&IF "{&mguni_version}" >= "2.07A" &THEN
    def var i-ep-codigo LIKE empresa.ep-codigo.
&ELSE
    def var i-ep-codigo as integer.
&ENDIF
    
    {method/svc/autentic/autentic.i
            &vUserEnterprise="i-ep-codigo"}

    assign p-moeda       = 999
           p-conta-saldo = "".

    find first portador no-lock
         where portador.ep-codigo    = i-ep-codigo
         and   portador.cod-portador = p-cod-portador no-error.

    if avail portador then do:
        find first cta-corrente no-lock
             where cta-corrente.cod-banco    = portador.cod-banco
             and   cta-corrente.agencia      = portador.agencia
             and   cta-corrente.conta-corren = portador.conta-corren no-error.
    
        if avail cta-corrente then
            assign p-moeda       = portador.mo-codigo
                   p-conta-saldo = cta-corrente.conta-saldo.
    end.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-contrato DBOProgram 
PROCEDURE pi-busca-contrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param r-contrato      as   rowid                      no-undo.
    def output param p-cod-estabel   like contrato-exp.cod-estabel   no-undo.
    def output param p-referencia    like contrato-exp.referencia    no-undo.
    def output param p-dt-referencia like contrato-exp.dt-referencia no-undo.

    assign p-cod-estabel   = ""
           p-referencia    = ""
           p-dt-referencia = ?.

    find contrato-exp where rowid(contrato-exp) = r-contrato no-lock no-error.
    if avail contrato-exp then
        assign p-cod-estabel   = contrato-exp.cod-estabel
               p-referencia    = contrato-exp.referencia
               p-dt-referencia = contrato-exp.dt-referencia.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-estabelecimento-2 DBOProgram 
PROCEDURE pi-busca-estabelecimento-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p-cod-estabel like contrato-exp.cod-estabel no-undo.
    def output param p_cod_estab2 as char no-undo.

    assign p_cod_estab2 = "".

    run pi-busca-empresa in this-procedure (output c-ep-codigo).

    /* Conecta Bases EMS 5 */
    {ecp/ec0005b.i 1}
    
    /*** Verifica Erro na Conex’o das Bases ***/
    {ecp/ec0005k.i}
    
    if i-seq-erro <> 0 then do:
        {method/showmessage.i1}
        {method/showmessage.i2}
  
        for each RowErrors:
            delete RowErrors.
        end.

        return "NOK":U.
    end.

    &IF "{&mguni_version}" <= "2.06B" &THEN
    assign v_cod_usuar_corren_old = v_cod_usuar_corren 
           v_cod_empres_usuar_old = v_cod_empres_usuar
           v_cod_usuar_corren     = ""
           v_cod_empres_usuar     = "".

    assign v_cod_grp_usuar_lst_old = v_cod_grp_usuar_lst
           v_cod_grp_usuar_lst     = "".
    
    /*** chama login do usuario ***/
    run prgtec/btb/btb906za.py.
    
    if v_cod_usuar_corren = "" 
    or v_cod_empres_usuar = "" then do:
        assign v_cod_usuar_corren = v_cod_usuar_corren_old 
               v_cod_empres_usuar = v_cod_empres_usuar_old
               v_cod_grp_usuar_lst = v_cod_grp_usuar_lst_old.
        return "NOK":U.
    end.
    assign v_cod_grp_usuar_lst = v_cod_grp_usuar_lst_old.           
    &ENDIF
    
    if not valid-handle(h-acr788za) then
        run prgfin/acr/acr788za.py persistent set h-acr788za.

    run pi_busca_estabelecimento_2 in h-acr788za (input p-cod-estabel,
                                                  output p_cod_estab2).

    delete procedure h-acr788za.

    /* Desconecta Bases EMS 5 */
    {ecp/ec0005b.i 2}

    /*** Verifica Erro na Desconex’o das Bases ***/
    {ecp/ec0005k.i}

    if i-seq-erro <> 0 then do:

        {method/showmessage.i1}
        {method/showmessage.i2}
  
        for each RowErrors:
            delete RowErrors.
        end.

        return "NOK":U.
    end.

    &IF "{&mguni_version}" <= "2.06B" &THEN
    assign v_cod_usuar_corren = v_cod_usuar_corren_old 
           v_cod_empres_usuar = v_cod_empres_usuar_old.
    &ENDIF    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-portador-cta DBOProgram 
PROCEDURE pi-busca-portador-cta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p-cod-banco  like portador.cod-banco.
    def input  param p-agencia    like portador.agencia.
    def input  param p-cta-corren like portador.conta-corren.
    def output param p-portador   like portador.cod-portador.
    def output param p-modalidade like portador.modalidade.

    find first portador no-lock
         where portador.cod-banco    = p-cod-banco
         and   portador.agencia      = p-agencia
         and   portador.conta-corren = p-cta-corren no-error.
    if avail portador then
        assign p-portador   = portador.cod-portador
               p-modalidade = portador.modalidade.

    RETURN "OK":U.
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
    def input param  p-referencia    like contrato-exp.referencia.
    def input param  p-dt-referencia like contrato-exp.dt-referencia.
    def output param p-rowid as rowid.

    find first contrato-exp no-lock
         where contrato-exp.referencia    = p-referencia
         and   contrato-exp.dt-referencia = p-dt-referencia no-error.
    if avail contrato-exp then
        assign p-rowid = rowid(contrato-exp).
    else
        assign p-rowid = ?.

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
    def output param table for tt-contrato-exp.
    
    def buffer b-contrato-exp for contrato-exp.

    for each b-contrato-exp no-lock:
        create tt-contrato-exp.
        buffer-copy b-contrato-exp to tt-contrato-exp.
    end.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-checa-paridade-contrato DBOProgram 
PROCEDURE pi-checa-paridade-contrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-ep-codigo         LIKE crta-remessa-exp.ep-codigo.      
DEF INPUT PARAM p-cod-estabel       LIKE crta-remessa-exp.cod-estabel.        
DEF INPUT PARAM p-nr-crta-remessa   LIKE crta-remessa-exp.nr-crta-remessa.
    
    FIND FIRST bf-crta-remessa-exp WHERE 
    bf-crta-remessa-exp.ep-codigo       =   p-ep-codigo         AND 
    bf-crta-remessa-exp.cod-estabel     =   p-cod-estabel       AND 
    bf-crta-remessa-exp.nr-crta-remessa =   p-nr-crta-remessa
    NO-LOCK NO-ERROR.
    
    IF AVAIL bf-crta-remessa-exp THEN DO:    

        FOR EACH bf-crta-remessa-docto-exp WHERE 
            bf-crta-remessa-docto-exp.ep-codigo             =   p-ep-codigo         AND 
            bf-crta-remessa-docto-exp.cod-estabel           =   p-cod-estabel       AND 
            bf-crta-remessa-docto-exp.nr-crta-remessa       =   p-nr-crta-remessa   AND
            bf-crta-remessa-docto-exp.ind-tipo-documento    =   13 
            NO-LOCK:
        
            IF can-find(FIRST bf-contrato WHERE
                        bf-contrato.nr-contrato =   bf-crta-remessa-docto-exp.documento AND
                        bf-contrato.moeda       <>   bf-crta-remessa-exp.mo-codigo) 
                THEN
                
                RETURN "OK":U.
        END.
    END.
    
    RETURN "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-antecipacao DBOProgram 
PROCEDURE pi-cria-antecipacao :
def input parameter p-cod-estabel    as char no-undo.
def input parameter p-nr-contrato    as char no-undo.
def input parameter p-dt-contrato    as date no-undo.
def input parameter p-referencia     as char no-undo.
def input parameter p-dt-referencia  as date no-undo.
def input parameter p-mo-moeda       as int  no-undo.
def input parameter p-vl-contrato-me as dec  no-undo.
def input parameter table for tt-titulos-antecipacao.
def input parameter table for tt-doc-i-cr.
def input parameter table for tt-lin-i-cr.
def input parameter table for tt-ext-lin-i-cr.
def input parameter table for tt-lin-prev.
def input parameter table for tt-cheque-pend.
def input parameter table for tt-impto-tit-pend-cr.
def input parameter table for tt-his-tit-pend.
def input parameter table for tt-relacto-pend-titulo-cheq.

/**
tt-titulos-antecipacao nÆo foi evolu¡da porque a mesma s¢ ‚ utilizada dentro do processo do cƒmbio, j  a tt-lin-i-cr ‚ utilizada em v rios programas.
*/
    
for each tt-lin-i-cr-1 no-lock:
    delete tt-lin-i-cr-1.
end.
for each tt-lin-i-cr no-lock:
    create tt-lin-i-cr-1.
    buffer-copy tt-lin-i-cr to tt-lin-i-cr-1.
end.

run pi-cria-antecipacao-1(input p-cod-estabel,
                          input p-nr-contrato, 
                          input p-dt-contrato,
                          input p-referencia,
                          input p-dt-referencia,
                          input p-mo-moeda,
                          input p-vl-contrato-me,
                          input table tt-titulos-antecipacao,
                          input table tt-doc-i-cr,
                          input table tt-lin-i-cr-1, 
                          input table tt-ext-lin-i-cr,
                          input table tt-lin-prev,
                          input table tt-cheque-pend,
                          input table tt-impto-tit-pend-cr,
                          input table tt-his-tit-pend,
                          input table tt-relacto-pend-titulo-cheq).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-antecipacao-1 DBOProgram 
PROCEDURE pi-cria-antecipacao-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter p-cod-estabel    as char no-undo.
def input parameter p-nr-contrato    as char no-undo.
def input parameter p-dt-contrato    as date no-undo.
def input parameter p-referencia     as char no-undo.
def input parameter p-dt-referencia  as date no-undo.
def input parameter p-mo-moeda       as int  no-undo.
def input parameter p-vl-contrato-me as dec  no-undo.
def input parameter table for tt-titulos-antecipacao.
def input parameter table for tt-doc-i-cr.
def input parameter table for tt-lin-i-cr-1. 
def input parameter table for tt-ext-lin-i-cr.
def input parameter table for tt-lin-prev.
def input parameter table for tt-cheque-pend.
def input parameter table for tt-impto-tit-pend-cr.
def input parameter table for tt-his-tit-pend.
def input parameter table for tt-relacto-pend-titulo-cheq.

def var c-ep-codigo like contrato-exp.ep-codigo.
def var c-usuario   like contrato-exp.usuario.

/* NÇO CRIARµ AS ANTECIPA€åES NO CONTAS A RECEBER CASO A FUN€ÇO DE MULTIPLAS AN'S ESTEJA ATIVA
   PASSARµ A CRIAR NO BOTÇO DE ATUALIZA€ÇO DE AN'S PENDENTES NA TELA DE CONTRATO DE EXPORTA€ÇO */
IF NOT l-multi-an THEN DO:
run adbo/boad355.p persistent set h-boad355.
run pi-verificar-produto in h-boad355 (output v-pagar,
                                       output v-receber).
delete procedure h-boad355.

if v-receber = 'EMS 2' then do:
   assign c-cod-estabel-ems2     = p-cod-estabel
          c-nr-contrato-ems2     = p-nr-contrato
          da-dt-contrato-ems2    = p-dt-contrato
          c-referencia-ems2      = p-referencia
          da-dt-referencia-ems2  = p-dt-referencia
          i-moeda-ems2           = p-mo-moeda
          de-vl-contrato-me-ems2 = p-vl-contrato-me.
   
   run pi-cria-antecipacao-ems2-1 in this-procedure (input table tt-titulos-antecipacao,
                                                     input table tt-doc-i-cr,
                                                     input table tt-lin-i-cr-1,
                                                     input table tt-ext-lin-i-cr,
                                                     input table tt-lin-prev,
                                                     input table tt-cheque-pend,
                                                     input table tt-impto-tit-pend-cr,
                                                     input table tt-his-tit-pend,
                                                     input table tt-relacto-pend-titulo-cheq).
   if return-value <> "OK":U then do:
      return "NOK":U.
   end.
end.
if v-receber = 'EMS 5' then do:
   find first param-global no-lock no-error.
   
   {method/svc/autentic/autentic.i
       &vUserEnterprise="c-ep-codigo"
       &vUserName="c-usuario"}
   
   for each tt-docto-cr:
       delete tt-docto-cr.
   end.
   for each tt-linha-cr:
       delete tt-linha-cr.
   end.
   
   for each tt-doc-i-cr:
       create tt-docto-cr.
       assign tt-docto-cr.ep-codigo   = tt-doc-i-cr.ep-codigo
              tt-docto-cr.referencia  = tt-doc-i-cr.referencia
              tt-docto-cr.cod-estabel = tt-doc-i-cr.cod-estabel
              tt-docto-cr.cod-usuario = c-usuario
              tt-docto-cr.total-movto = tt-doc-i-cr.total-movto
              tt-docto-cr.dt-movto    = tt-doc-i-cr.dt-movto.
   end.
   
   for each tt-lin-i-cr-1:
       create tt-linha-cr.
       assign tt-linha-cr.ep-codigo      = tt-lin-i-cr-1.ep-codigo
              tt-linha-cr.referencia     = tt-lin-i-cr-1.referencia
              tt-linha-cr.sequencia      = tt-lin-i-cr-1.sequencia
              tt-linha-cr.cod-esp        = tt-lin-i-cr-1.cod-esp
              tt-linha-cr.cod-estabel    = tt-lin-i-cr-1.cod-estabel
              tt-linha-cr.nr-docto       = tt-lin-i-cr-1.nr-docto
              tt-linha-cr.parcela        = tt-lin-i-cr-1.parcela
              tt-linha-cr.cod-emitente   = tt-lin-i-cr-1.cod-emitente
              tt-linha-cr.cod-rep        = tt-lin-i-cr-1.cod-rep
              tt-linha-cr.cod-portador   = tt-lin-i-cr-1.cod-portador
              tt-linha-cr.modalidade     = tt-lin-i-cr-1.modalidade
              tt-linha-cr.dt-emissao     = tt-lin-i-cr-1.dt-emissao
              tt-linha-cr.dt-vencimen    = tt-lin-i-cr-1.dt-vencimen
              tt-linha-cr.vl-bruto       = tt-lin-i-cr-1.vl-bruto
              tt-linha-cr.vl-liquido     = tt-lin-i-cr-1.vl-liquido
              tt-linha-cr.dt-desconto    = tt-lin-i-cr-1.dt-desconto
              tt-linha-cr.vl-desconto    = tt-lin-i-cr-1.vl-desconto
              tt-linha-cr.pedido-rep     = tt-lin-i-cr-1.pedido-rep
              tt-linha-cr.nr-pedcli      = tt-lin-i-cr-1.nr-pedcli
              tt-linha-cr.ct-conta       = tt-lin-i-cr-1.ct-conta
              tt-linha-cr.sc-conta       = tt-lin-i-cr-1.sc-conta
              tt-linha-cr.tp-codigo      = tt-lin-i-cr-1.tp-codigo
              tt-linha-cr.serie          = tt-lin-i-cr-1.serie
              tt-linha-cr.mo-codigo      = tt-lin-i-cr-1.mo-codigo
              tt-linha-cr.vl-bruto-me    = tt-lin-i-cr-1.vl-bruto-me
              tt-linha-cr.vl-liquido-me  = tt-lin-i-cr-1.vl-liquido-me
              tt-linha-cr.vl-desconto-me = tt-lin-i-cr-1.vl-desconto-me
              tt-linha-cr.vl-cotacao     = tt-lin-i-cr-1.cotacao-dia
              tt-linha-cr.cod-unid-negoc = tt-lin-i-cr-1.cod-unid-negoc.
   end.
   
   run prgfin/acr/acr913za.p (input  param-global.sc-format,
                              input  table tt-docto-cr,
                              input  table tt-linha-cr,
                              output table tt_log_erro).
   
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
   
   if can-find(first tt_log_erro) then do:
      {method/showmessage.i1}
      {method/showmessage.i2}
      
      for each RowErrors:
          delete RowErrors.
      end.
      
      return "NOK":U.
   end.
end.
END.
IF NOT L-MULTI-AN THEN DO:
run adbo/boad347.p persistent set h-boad347.
run pi-cria-tabela in h-boad347 (input table tt-titulos-antecipacao).
delete procedure h-boad347.
END.

if return-value <> "OK" then do:
  return "NOK":U.
end.


return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-antecipacao-ems2 DBOProgram 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-antecipacao-ems2 DBOProgram 
PROCEDURE pi-cria-antecipacao-ems2 :
    def input parameter table for tt-titulos-antecipacao.
    def input parameter table for tt-doc-i-cr.
    def input parameter table for tt-lin-i-cr.
    def input parameter table for tt-ext-lin-i-cr.
    def input parameter table for tt-lin-prev.
    def input parameter table for tt-cheque-pend.
    def input parameter table for tt-impto-tit-pend-cr.
    def input parameter table for tt-his-tit-pend.
    def input parameter table for tt-relacto-pend-titulo-cheq.

    for each tt-lin-i-cr-1 no-lock:
       delete tt-lin-i-cr-1.
    end.
    for each tt-lin-i-cr no-lock:
       create tt-lin-i-cr-1.
       buffer-copy tt-lin-i-cr to tt-lin-i-cr-1.
    end.    
        
    run pi-cria-antecipacao-ems2-1(input table tt-titulos-antecipacao,
                                   input table tt-doc-i-cr,
                                   input table tt-lin-i-cr-1,
                                   input table tt-ext-lin-i-cr,
                                   input table tt-lin-prev,
                                   input table tt-cheque-pend,
                                   input table tt-impto-tit-pend-cr,
                                   input table tt-his-tit-pend,
                                   input table tt-relacto-pend-titulo-cheq).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-antecipacao-ems2 DBOProgram 
PROCEDURE pi-cria-antecipacao-ems2-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter table for tt-titulos-antecipacao.
    def input parameter table for tt-doc-i-cr.
    def input parameter table for tt-lin-i-cr-1.
    def input parameter table for tt-ext-lin-i-cr.
    def input parameter table for tt-lin-prev.
    def input parameter table for tt-cheque-pend.
    def input parameter table for tt-impto-tit-pend-cr.
    def input parameter table for tt-his-tit-pend.
    def input parameter table for tt-relacto-pend-titulo-cheq.
    
    assign v-soma-titulos = 0
           l-altera       = no.
    
    for each RowErrors:
        delete RowErrors.
    end.
    
    for each tt-titulos-antecipacao:
        if  tt-titulos-antecipacao.cod-estabel     <> c-cod-estabel-ems2 or
            tt-titulos-antecipacao.nr-contrato     <> c-nr-contrato-ems2 or
            tt-titulos-antecipacao.dt-contrato     <> da-dt-contrato-ems2 or
            tt-titulos-antecipacao.ctr-referencia  <> c-referencia-ems2 or
            tt-titulos-antecipacao.dt-referencia   <> da-dt-referencia-ems2 then do:
            assign l-altera = yes.
        end.
        
        assign v-soma-titulos = v-soma-titulos + tt-titulos-antecipacao.de-vl-vinculado.
    end.
    
    if l-altera = yes then do:
        for each tt-doc-i-cr exclusive-lock:
            assign tt-doc-i-cr.cod-estabel  = c-cod-estabel-ems2
                   tt-doc-i-cr.referencia   = c-referencia-ems2
                   tt-doc-i-cr.dt-movto     = da-dt-referencia-ems2
                   tt-doc-i-cr.mo-codigo    = i-moeda-ems2.
        end.
        
        for each tt-lin-i-cr-1 exclusive-lock:
            assign tt-lin-i-cr-1.referencia    = c-referencia-ems2
                   tt-lin-i-cr-1.cod-estabel   = c-cod-estabel-ems2
                   tt-lin-i-cr-1.mo-codigo     = i-moeda-ems2.
        end.
        
        for each tt-titulos-antecipacao exclusive-lock:
            assign tt-titulos-antecipacao.cod-estabel    = c-cod-estabel-ems2
                   tt-titulos-antecipacao.nr-contrato    = c-nr-contrato-ems2
                   tt-titulos-antecipacao.dt-contrato    = da-dt-contrato-ems2
                   tt-titulos-antecipacao.ctr-referencia = c-referencia-ems2
                   tt-titulos-antecipacao.dt-referencia  = da-dt-referencia-ems2.
            
            if  tt-titulos-antecipacao.dt-vencimen < da-dt-contrato-ems2 then do:
                run utp/ut-msgs.p (input "msg":u,
                                   INPUT 26381,
                                   INPUT "").
                
                create RowErrors.
                assign RowErrors.ErrorSequence    = 10
                       RowErrors.ErrorNumber      = 26381
                       RowErrors.ErrorParameters  = ""
                       RowErrors.ErrorType        = ""
                       RowErrors.ErrorSubType     = "ERROR"
                       RowErrors.ErrorDescription = return-value.
                
                run utp/ut-msgs.p (input "help":u,
                                   INPUT 26381,
                                   INPUT "").
                
                assign RowErrors.ErrorHelp = return-value.
                
                {method/showmessage.i1}
                {method/showmessage.i2}
                
                RETURN "NOK":U.
            end.
        end.
    end.
    
    if  v-soma-titulos <> de-vl-contrato-me-ems2 then do:
        run utp/ut-msgs.p (input "msg",
                           input 19698,
                           input "").
        
        create RowErrors.
        assign RowErrors.ErrorSequence    = 10
               RowErrors.ErrorNumber      = 19698
               RowErrors.ErrorParameters  = ""
               RowErrors.ErrorType        = ""
               RowErrors.ErrorSubType     = "ERROR"
               RowErrors.ErrorDescription = return-value.
        
        {method/showmessage.i1}
        {method/showmessage.i2}
        
        RETURN "NOK":U.
    end.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-Dia-Util DBOProgram 
PROCEDURE pi-Dia-Util :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p-dt-entr-docto as date    no-undo.
    def output param p-dt-nova       as date    no-undo.
&IF "{&mguni_version}" >= "2.07A" &THEN
    def input  param p-ep-codigo     LIKE empresa.ep-codigo no-undo.
&ELSE
    def input  param p-ep-codigo     as integer no-undo.
&ENDIF
    def input  param p-cod-estabel   as char    no-undo.
    def input  param p-sinal         as char    no-undo.

    repeat:
        find first calen-coml
            where calen-coml.ep-codigo   = p-ep-codigo
            and   calen-coml.cod-estabel = p-cod-estabel
            and   calen-coml.data        = p-dt-entr-docto no-lock no-error.

        if not avail calen-coml then do:
            leave.
        end.
        if calen-coml.tipo-dia = 1 then do:
            leave.
        end.

        if p-sinal = "-" then do:
            assign p-dt-entr-docto = p-dt-entr-docto - 1.
        end.
        else do:
            assign p-dt-entr-docto = p-dt-entr-docto + 1.
        end.
    end.

    assign p-dt-nova = p-dt-entr-docto.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava-chave-secundaria-anterior DBOProgram 
PROCEDURE pi-grava-chave-secundaria-anterior :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param p-nr-contrato   like contr-titulo-exp.nr-contrato    no-undo.
def input param p-dt-contrato   like contr-titulo-exp.dt-contrato    no-undo.

ASSIGN c-nr-contrato-ant  = p-nr-contrato
       d-dt-contrato-ant  = p-dt-contrato  .



    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-integra-fluxo-despes-exp DBOProgram 
PROCEDURE pi-integra-fluxo-despes-exp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &IF "{&mguni_version}" >= "2.07A" &THEN
        def input    param p-cdn-empresa like empresa.ep-codigo format "x(03)" no-undo.
    &ELSE
        def input    param p-cdn-empresa as int format ">>9" no-undo.
    &ENDIF
    def input        param p-dat-inic    as date             no-undo.
    def input        param p-dat-fim     as date             no-undo.
    def input-output param table for tt_integr_mec_cfl_despes.
    def input-output param table for tt_erro_mec.     

    def var i-num-seq as int no-undo.

    for each tt-integra-fluxo:
        delete tt-integra-fluxo.
    end.

    for each tt-integra-fluxo-conta:
        delete tt-integra-fluxo-conta.
    end.

    for each tt-integra-cta-corren-2:
        delete tt-integra-cta-corren-2.
    end.

    for each tt-integra-cta-corren:
        delete tt-integra-cta-corren.
    end.

    for each tt-erro-aux:
        delete tt-erro-aux.
    end.

    assign i-num-seq = 0.

    for each contr-despesa-exp where
             contr-despesa-exp.ep-codigo = p-cdn-empresa and
             contr-despesa-exp.dt-movto >= p-dat-inic    and
             contr-despesa-exp.dt-movto <= p-dat-fim
             no-lock:

        find first contrato-exp where
                   contrato-exp.ep-codigo     = contr-despesa-exp.ep-codigo   and
                   contrato-exp.cod-estabel   = contr-despesa-exp.cod-estabel and
                   contrato-exp.referencia    = contr-despesa-exp.referencia  and
                   contrato-exp.dt-referencia = contr-despesa-exp.dt-referencia
                   no-lock no-error.

        if avail contrato-exp then do:

            assign i-num-seq = i-num-seq + 1.

            create tt-integra-fluxo.
            assign tt-integra-fluxo.tp-codigo         = contr-despesa-exp.dec-1
                   tt-integra-fluxo.conta-contabil    = ""
                   tt-integra-fluxo.vl-movto-fluxo    = contr-despesa-exp.valor-movto
                   tt-integra-fluxo.vl-movto-fluxo-me = contr-despesa-exp.valor-movto
                   tt-integra-fluxo.moeda             = 0
                   tt-integra-fluxo.cotacao-dia       = 1
                   tt-integra-fluxo.cod-estabel       = contr-despesa-exp.cod-estabel
                   tt-integra-fluxo.dt-fluxo          = contr-despesa-exp.dt-movto
                   tt-integra-fluxo.dt-emissao        = contr-despesa-exp.dt-movto
                   tt-integra-fluxo.modulo-origem     = "MEC"
                   tt-integra-fluxo.ind-orig-movto    = "MOV"
                   tt-integra-fluxo.num-id-orig-movto = integer(string(string(contrato-exp.num-id-contrato-exp) + string(contr-despesa-exp.sequencia)))
                   tt-integra-fluxo.cod-funcao        = "InclusÆo"
                   tt-integra-fluxo.ind-fluxo-movto   = "SAI"
                   tt-integra-fluxo.ind-tipo-movto    = "RE"
                   tt-integra-fluxo.chave-des-banc    = ""
                   tt-integra-fluxo.unid-negoc        = ""
                   tt-integra-fluxo.num-seq           = i-num-seq.

            &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN

                assign tt-integra-fluxo.cod-tip-trans-cx = contr-despesa-exp.cod-tip-trans-cx
                       tt-integra-fluxo.cod-cta-corren   = contr-despesa-exp.cta-corrente
                       tt-integra-fluxo.conta-contabil   = ""
                       tt-integra-fluxo.ct-conta         = ""
                       tt-integra-fluxo.sc-conta         = ""
                       .

            &ELSE
            
                if  contr-despesa-exp.char-1 <> "" and
                    contr-despesa-exp.char-1 <> ?  and
                    num-entries(contr-despesa-exp.char-1) >= 2 then
                    assign tt-integra-fluxo.conta-contabil = entry(2, contr-despesa-exp.char-1, ",").

                find first conta-contab where
                           conta-contab.ep-codigo     = contr-despesa-exp.ep-codigo       and
                           conta-contab.conta-contabil  = tt-integra-fluxo.conta-contabil
                           no-lock no-error.
                if avail conta-contab then
                    assign tt-integra-fluxo.ct-conta = conta-contab.ct-codigo
                           tt-integra-fluxo.sc-conta = conta-contab.sc-codigo.

            &ENDIF

            if l-funcao-melhoria-desp then do:
                &IF "{&mgadm_version}":U < "2.06B":U &THEN
                    if contr-despesa-exp.dec-2 <> 0 then
                        assign tt-integra-fluxo.vl-movto-fluxo-me = contr-despesa-exp.dec-2.
                &ELSE
                    if contr-despesa-exp.val-movto-desp-me <> 0 then
                        assign tt-integra-fluxo.vl-movto-fluxo-me = contr-despesa-exp.val-movto-desp-me.
                &ENDIF  
            end.

            create tt_integr_mec_cfl_despes.
            assign tt_integr_mec_cfl_despes.tta_cod_estab_contrat_cambio   = contrato-exp.cod-estabel
                   tt_integr_mec_cfl_despes.tta_cod_contrat_cambio         = contrato-exp.nr-contrato
                   tt_integr_mec_cfl_despes.tta_cod_refer_contrat_cambio   = contrato-exp.referencia
                   tt_integr_mec_cfl_despes.tta_dat_refer_contrat_cambio   = contrato-exp.dt-referencia
                   tt_integr_mec_cfl_despes.ttv_val_despes_mec             = tt-integra-fluxo.vl-movto-fluxo
                   tt_integr_mec_cfl_despes.ttv_num_tip_despes_mec         = tt-integra-fluxo.tp-codigo 
                   tt_integr_mec_cfl_despes.tta_num_id_orig_movto_fluxo_cx = tt-integra-fluxo.num-id-orig-movto
                   tt_integr_mec_cfl_despes.ttv_cod_docto_empres_despes    = contr-despesa-exp.nr-docto-emp.

        end.
    end.

    if can-find (first tt-integra-fluxo) then do:

        run cdp/cdapi533a.p (input        table tt-integra-fluxo,
                             input        table tt-integra-fluxo-conta,
                             input        table tt-integra-cta-corren-2,
                             input-output table tt-erro-aux).

        if can-find (first tt-erro-aux) then do:
        
            for each tt-erro-aux:
                
                create tt_erro_mec.
                assign tt_erro_mec.ttv_num_seq           = tt-erro-aux.i-sequen
                       tt_erro_mec.ttv_cod_erro_ems2     = tt-erro-aux.cd-erro
                       tt_erro_mec.ttv_des_msg_erro_ems2 = tt-erro-aux.mensagem.

            end.
        end.
    end.

    return "OK":U.

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
find first contrato-exp no-lock no-error.
if avail contrato-exp then
   RETURN "NOK":U.
ELSE
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-contrato-acc DBOProgram 
PROCEDURE pi-verifica-contrato-acc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*Rodrigo - Inicio - COMPL ATV230811*/
def input  param p-num-id-operac-financ as integer.
def output param p-log-existe           as logical.

assign p-log-existe = no.

find first contrato-exp no-lock
    where contrato-exp.num-id-operac-financ = p-num-id-operac-financ no-error.
if avail contrato-exp and contrato-exp.tp-emprestimo = 1 /*ACC*/ then
    assign p-log-existe = yes.   
/*Rodrigo - Fim - COMPL ATV230811*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-contrato-viculado-operacao DBOProgram 
PROCEDURE pi-verifica-contrato-viculado-operacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-num-id-operac-financ  AS INT.
    def OUTPUT param p-log-existe AS LOG .
    
    assign  p-log-existe = NO.

    find contrato-exp no-lock
        where contrato-exp.num-id-operac-financ = p-num-id-operac-financ   no-error.
    if  avail contrato-exp then
        assign  p-log-existe = yes.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-integracao DBOProgram 
PROCEDURE pi-verifica-integracao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /**** Consistencia p/verificacao de produto  ****/
    def input param p-cod-modul-integr  like integr-mec-modul-funcao.cod-modul-integr.
    def input param p-ind-funcao-integr like integr-mec-modul-funcao.ind-funcao-integr.
    def input param p-cod-empresa       like integr-mec-modul-funcao.cod-empresa.
    def input param p-cod-estab         like integr-mec-modul-funcao.cod-estab.
    
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN

        return "OK":U.

    &ELSE

        find integr-mec-modul-funcao where 
             integr-mec-modul-funcao.cod-modul-integr  = p-cod-modul-integr  and
             integr-mec-modul-funcao.ind-funcao-integr = p-ind-funcao-integr and
             integr-mec-modul-funcao.cod-empresa       = p-cod-empresa       and
             integr-mec-modul-funcao.cod-estab         = p-cod-estab no-lock no-error.
        if avail integr-mec-modul-funcao then
            return "OK":U.

        return "NOK":U.

    &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-moeda-contrato DBOProgram 
PROCEDURE pi-verifica-moeda-contrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT   PARAM c-documento LIKE contrato-exp.nr-contrato.
DEF INPUT   PARAM p-prParent    AS ROWID NO-UNDO.

DEF VAR i-moeda-docto       AS INT NO-UNDO.

FIND FIRST bf-contrato WHERE bf-contrato.nr-contrato = c-documento
    NO-LOCK NO-ERROR.
IF  NOT AVAIL bf-contrato THEN /* se achar contr entra*/
    RETURN "NOK":U.
    
ASSIGN i-moeda-docto = bf-contrato.moeda. /*captura tipo moeda contr novo*/

FIND FIRST crta-remessa-exp
     WHERE ROWID(crta-remessa-exp) =p-prParent NO-LOCK NO-ERROR.

IF AVAIL crta-remessa-exp 
   AND crta-remessa-exp.mo-codigo <> i-moeda-docto THEN DO:  /*se moeda != da carta, entra na condi»’o*/

    FOR EACH crta-remessa-docto-exp NO-LOCK
       WHERE crta-remessa-docto-exp.nr-crta-remessa = crta-remessa-exp.nr-crta-remessa
         AND crta-remessa-docto-exp.cod-estabel = crta-remessa-exp.cod-estabel
         AND crta-remessa-docto-exp.ep-codigo = crta-remessa-exp.ep-codigo
         AND crta-remessa-docto-exp.ind-tipo-documento = 13:
        
       FIND FIRST bf-contrato 
             WHERE bf-contrato.nr-contrato = crta-remessa-docto-exp.documento
              AND (bf-contrato.moeda <> i-moeda-docto AND bf-contrato.moeda <> crta-remessa-exp.mo-codigo)
              NO-LOCK NO-ERROR.

       IF AVAIL bf-contrato THEN DO:       
           
           run utp/ut-msgs.p (input "msg",
                              input 30450,
                              input "").
           create RowErrors.
           assign RowErrors.ErrorSequence    = 10
                  RowErrors.ErrorNumber      = 30450
                  RowErrors.ErrorParameters  = ""
                  RowErrors.ErrorType        = ""
                  RowErrors.ErrorSubType     = "ERROR"
                  RowErrors.ErrorDescription = return-value.

           
           {method/showmessage.i1} 
           {method/showmessage.i2}  

           RETURN "NOK":U.
       END.
    END.    
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-operacao-filho DBOProgram 
PROCEDURE pi-verifica-operacao-filho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-num-id-operac-financ  AS INT.
    def OUTPUT param p-log-existe AS LOG .
    
    assign  p-log-existe = NO.
    
    find first contr-emprestimo
        where contr-emprestimo.num-id-operac-financ-d = p-num-id-operac-financ no-lock no-error.
    IF AVAIL contr-emprestimo THEN do:
        ASSIGN p-log-existe = yes.
    end.            
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintContrato DBOProgram 
PROCEDURE SetConstraintContrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-contrato-ini LIKE contrato-exp.nr-contrato.
    DEFINE INPUT PARAMETER pnr-contrato-fim LIKE contrato-exp.nr-contrato.
    DEFINE INPUT PARAMETER pdt-contrato-ini LIKE contrato-exp.dt-contrato.
    DEFINE INPUT PARAMETER pdt-contrato-fim LIKE contrato-exp.dt-contrato.

    assign c-nr-contrato-ini = pnr-contrato-ini
           c-nr-contrato-fim = pnr-contrato-fim
           d-dt-contrato-ini = pdt-contrato-ini
           d-dt-contrato-fim = pdt-contrato-fim.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintContratoEmprestimo DBOProgram 
PROCEDURE setConstraintContratoEmprestimo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-contrato-ini LIKE contrato-exp.nr-contrato.
    DEFINE INPUT PARAMETER pnr-contrato-fim LIKE contrato-exp.nr-contrato.
    DEFINE INPUT PARAMETER pdt-contrato-ini LIKE contrato-exp.dt-contrato.
    DEFINE INPUT PARAMETER pdt-contrato-fim LIKE contrato-exp.dt-contrato.

    assign c-nr-contrato-ini = pnr-contrato-ini
           c-nr-contrato-fim = pnr-contrato-fim
           d-dt-contrato-ini = pdt-contrato-ini
           d-dt-contrato-fim = pdt-contrato-fim.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintContratoSaldo DBOProgram 
PROCEDURE setConstraintContratoSaldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-contrato-ini LIKE contrato-exp.nr-contrato.
    DEFINE INPUT PARAMETER pnr-contrato-fim LIKE contrato-exp.nr-contrato.
    DEFINE INPUT PARAMETER pdt-contrato-ini LIKE contrato-exp.dt-contrato.
    DEFINE INPUT PARAMETER pdt-contrato-fim LIKE contrato-exp.dt-contrato.

    assign c-nr-contrato-ini = pnr-contrato-ini
           c-nr-contrato-fim = pnr-contrato-fim
           d-dt-contrato-ini = pdt-contrato-ini
           d-dt-contrato-fim = pdt-contrato-fim.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintContrPronto DBOProgram 
PROCEDURE SetConstraintContrPronto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-contrato-ini LIKE contrato-exp.nr-contrato.
    DEFINE INPUT PARAMETER pnr-contrato-fim LIKE contrato-exp.nr-contrato.
    DEFINE INPUT PARAMETER pdt-contrato-ini LIKE contrato-exp.dt-contrato.
    DEFINE INPUT PARAMETER pdt-contrato-fim LIKE contrato-exp.dt-contrato.

    assign c-nr-contrato-ini = pnr-contrato-ini
           c-nr-contrato-fim = pnr-contrato-fim
           d-dt-contrato-ini = pdt-contrato-ini
           d-dt-contrato-fim = pdt-contrato-fim.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintContrSemTitulo DBOProgram 
PROCEDURE SetConstraintContrSemTitulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-contrato-ini LIKE contrato-exp.nr-contrato.
    DEFINE INPUT PARAMETER pnr-contrato-fim LIKE contrato-exp.nr-contrato.
    DEFINE INPUT PARAMETER pdt-contrato-ini LIKE contrato-exp.dt-contrato.
    DEFINE INPUT PARAMETER pdt-contrato-fim LIKE contrato-exp.dt-contrato.

    assign c-nr-contrato-ini = pnr-contrato-ini
           c-nr-contrato-fim = pnr-contrato-fim
           d-dt-contrato-ini = pdt-contrato-ini
           d-dt-contrato-fim = pdt-contrato-fim.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEmprestimo DBOProgram 
PROCEDURE setConstraintEmprestimo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RETURN "OK":U.
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
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintReferencia DBOProgram 
PROCEDURE SetConstraintReferencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel-ini   LIKE contrato-exp.cod-estabel.
    DEFINE INPUT PARAMETER pcod-estabel-fim   LIKE contrato-exp.cod-estabel.
    DEFINE INPUT PARAMETER preferencia-ini    LIKE contrato-exp.referencia.
    DEFINE INPUT PARAMETER preferencia-fim    LIKE contrato-exp.referencia.
    DEFINE INPUT PARAMETER pdt-referencia-ini LIKE contrato-exp.dt-referencia.
    DEFINE INPUT PARAMETER pdt-referencia-fim LIKE contrato-exp.dt-referencia.

    assign c-cod-estabel-ini = pcod-estabel-ini
           c-cod-estabel-fim = pcod-estabel-fim
           c-referencia-ini = preferencia-ini
           c-referencia-fim = preferencia-fim
           d-dt-referencia-ini = pdt-referencia-ini
           d-dt-referencia-fim = pdt-referencia-fim.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintReferenciaEmprestimo DBOProgram 
PROCEDURE setConstraintReferenciaEmprestimo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel-ini   LIKE contrato-exp.cod-estabel.
    DEFINE INPUT PARAMETER pcod-estabel-fim   LIKE contrato-exp.cod-estabel.
    DEFINE INPUT PARAMETER preferencia-ini    LIKE contrato-exp.referencia.
    DEFINE INPUT PARAMETER preferencia-fim    LIKE contrato-exp.referencia.
    DEFINE INPUT PARAMETER pdt-referencia-ini LIKE contrato-exp.dt-referencia.
    DEFINE INPUT PARAMETER pdt-referencia-fim LIKE contrato-exp.dt-referencia.

    assign c-cod-estabel-ini = pcod-estabel-ini
           c-cod-estabel-fim = pcod-estabel-fim
           c-referencia-ini = preferencia-ini
           c-referencia-fim = preferencia-fim
           d-dt-referencia-ini = pdt-referencia-ini
           d-dt-referencia-fim = pdt-referencia-fim.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintReferenciaSaldo DBOProgram 
PROCEDURE setConstraintReferenciaSaldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel-ini   LIKE contrato-exp.cod-estabel.
    DEFINE INPUT PARAMETER pcod-estabel-fim   LIKE contrato-exp.cod-estabel.
    DEFINE INPUT PARAMETER preferencia-ini    LIKE contrato-exp.referencia.
    DEFINE INPUT PARAMETER preferencia-fim    LIKE contrato-exp.referencia.
    DEFINE INPUT PARAMETER pdt-referencia-ini LIKE contrato-exp.dt-referencia.
    DEFINE INPUT PARAMETER pdt-referencia-fim LIKE contrato-exp.dt-referencia.

    assign c-cod-estabel-ini = pcod-estabel-ini
           c-cod-estabel-fim = pcod-estabel-fim
           c-referencia-ini = preferencia-ini
           c-referencia-fim = preferencia-fim
           d-dt-referencia-ini = pdt-referencia-ini
           d-dt-referencia-fim = pdt-referencia-fim.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintRefPronto DBOProgram 
PROCEDURE SetConstraintRefPronto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel-ini   LIKE contrato-exp.cod-estabel.
    DEFINE INPUT PARAMETER pcod-estabel-fim   LIKE contrato-exp.cod-estabel.
    DEFINE INPUT PARAMETER preferencia-ini    LIKE contrato-exp.referencia.
    DEFINE INPUT PARAMETER preferencia-fim    LIKE contrato-exp.referencia.
    DEFINE INPUT PARAMETER pdt-referencia-ini LIKE contrato-exp.dt-referencia.
    DEFINE INPUT PARAMETER pdt-referencia-fim LIKE contrato-exp.dt-referencia.

    assign c-cod-estabel-ini = pcod-estabel-ini
           c-cod-estabel-fim = pcod-estabel-fim
           c-referencia-ini = preferencia-ini
           c-referencia-fim = preferencia-fim
           d-dt-referencia-ini = pdt-referencia-ini
           d-dt-referencia-fim = pdt-referencia-fim.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintRefSemTitulo DBOProgram 
PROCEDURE SetConstraintRefSemTitulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel-ini   LIKE contrato-exp.cod-estabel.
    DEFINE INPUT PARAMETER pcod-estabel-fim   LIKE contrato-exp.cod-estabel.
    DEFINE INPUT PARAMETER preferencia-ini    LIKE contrato-exp.referencia.
    DEFINE INPUT PARAMETER preferencia-fim    LIKE contrato-exp.referencia.
    DEFINE INPUT PARAMETER pdt-referencia-ini LIKE contrato-exp.dt-referencia.
    DEFINE INPUT PARAMETER pdt-referencia-fim LIKE contrato-exp.dt-referencia.

    assign c-cod-estabel-ini = pcod-estabel-ini
           c-cod-estabel-fim = pcod-estabel-fim
           c-referencia-ini = preferencia-ini
           c-referencia-fim = preferencia-fim
           d-dt-referencia-ini = pdt-referencia-ini
           d-dt-referencia-fim = pdt-referencia-fim.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintSaldo DBOProgram 
PROCEDURE setConstraintSaldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintSemTitulo DBOProgram 
PROCEDURE SetConstraintSemTitulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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
    DEFINE INPUT PARAMETER pep-codigo-ini     LIKE contrato-exp.ep-codigo.
    DEFINE INPUT PARAMETER pcod-estabel-ini   LIKE contrato-exp.cod-estabel.
    DEFINE INPUT PARAMETER preferencia-ini    LIKE contrato-exp.referencia.
    DEFINE INPUT PARAMETER pdt-referencia-ini LIKE contrato-exp.dt-referencia.

    assign c-ep-codigo-ini     = pep-codigo-ini
           c-cod-estabel-ini   = pcod-estabel-ini
           c-referencia-ini    = preferencia-ini
           d-dt-referencia-ini = pdt-referencia-ini.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintTpContrato DBOProgram 
PROCEDURE SetConstraintTpContrato :
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
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida‡äes ---*/
    def var c-string1 as char no-undo.

    run pi-autenticacao.
    
    if ptype = "Update":U then do:
       assign l-liquida-menor   = no
              l-cambiais-menor  = no
              vl-tit-vinculados = 0
              vl-contr-vincul   = 0
              vl-tit-liquidar   = 0.

       for each contr-titulo-exp where contr-titulo-exp.nr-contrato  = RowObject.nr-contrato    
                                 and   contr-titulo-exp.dt-contrato  = RowObject.dt-contrato NO-LOCK :
            assign vl-tit-vinculados = vl-tit-vinculados + contr-titulo-exp.vl-vinculado-me.
            assign vl-tit-liquidar = vl-tit-liquidar + contr-titulo-exp.sl-liquidar-me.

            /*** FO 889.440 - Rafael
            if RowObject.dt-liquidacao  < contr-titulo-exp.dt-vencimen then
                assign l-liquida-menor  = yes.
            
            if RowObject.dt-cambiais    < contr-titulo-exp.dt-vencimen then
                assign l-cambiais-menor = yes.
            ***/
        end.
        
        assign vl-contr-vincul = contrato-exp.vl-liquidado-me + vl-tit-liquidar.
        if RowObject.vl-contrato-me < vl-contr-vincul then
            {method/svc/errors/inserr.i
                    &ErrorNumber="26261"
                    &ErrorType="EMS"
                    &ErrorParameters=" "}

        if l-liquida-menor = yes then
            {method/svc/errors/inserr.i
                    &ErrorNumber="25340"
                    &ErrorType="EMS"
                    &ErrorParameters=" "}
    
        if l-cambiais-menor = yes then
            {method/svc/errors/inserr.i
                    &ErrorNumber="25341"
                    &ErrorType="EMS"
                    &ErrorParameters=" "}

        if contrato-exp.situacao = 8 then do:
            if RowObject.situacao <> contrato-exp.situacao then
            {method/svc/errors/inserr.i
                    &ErrorNumber="25976"
                    &ErrorType="EMS"
                    &ErrorParameters=" "}
        end.
    end. /* Update */ 

    if ptype = "Create":U then do:
        
        run pi-busca-empresa in this-procedure (output c-ep-codigo).
        /* Verifica ocorr¼ncia de chave duplicada */
       find first bf-contrato no-lock
            where bf-contrato.ep-codigo     = c-ep-codigo
            and   bf-contrato.cod-estabel   = RowObject.cod-estabel
            and   bf-contrato.referencia    = RowObject.referencia
            and   bf-contrato.dt-referencia = RowObject.dt-referencia no-error.
       if avail bf-contrato then do:
          {utp/ut-liter.i Contrato_de_Cƒmbio_Exporta‡Æo *}
          assign c-string1 = return-value.

           {method/svc/errors/inserr.i
                       &ErrorNumber="7"
                       &ErrorType="EMS"
                       &ErrorParameters="c-string1"}
       end.
               
       find first bf-contrato no-lock
                where bf-contrato.ep-codigo     = c-ep-codigo
                and   bf-contrato.cod-estabel   <> RowObject.cod-estabel
                and   bf-contrato.referencia    = RowObject.referencia
                and   bf-contrato.dt-referencia = RowObject.dt-referencia no-error.
       if avail bf-contrato then do:
            {method/svc/errors/inserr.i
                     &ErrorNumber="27942"
                     &ErrorType="EMS"
                     &ErrorParameters="''"}  /* referˆncia ja utilizada em outro estabelecimento */
       end.
    end.

    if ptype = "Create":U or ptype = "Update":U then do:
        find first bf-contrato where bf-contrato.nr-contrato = RowObject.nr-contrato no-lock no-error.
        if avail bf-contrato then do:
            if not (RowObject.ep-codigo     = bf-contrato.ep-codigo   and
                    RowObject.cod-estabel   = bf-contrato.cod-estabel and
                    RowObject.referencia    = bf-contrato.referencia  and
                    RowObject.dt-referencia = bf-contrato.dt-referencia) and
                    RowObject.situacao   <> 1                      then 
                {method/svc/errors/inserr.i
                            &ErrorNumber="26235"
                            &ErrorType="EMS"
                            &ErrorParameters= "bf-contrato.cod-estabel + '~~~~' +~
                                               bf-contrato.referencia  + '~~~~' +~
                                               string(bf-contrato.dt-referencia)"}

            if bf-contrato.situacao = 3 then do: /* Liquidado */
               if RowObject.situacao <> bf-contrato.situacao then
                  {method/svc/errors/inserr.i
                              &ErrorNumber="26286"
                              &ErrorType="EMS"
                              &ErrorParameters=" "}
            end.
        end.

        assign vl-tit-vinculados = 0
               vl-tit-liquidar   = 0.


        for each contr-titulo-exp where contr-titulo-exp.nr-contrato  = RowObject.nr-contrato    
            and   contr-titulo-exp.dt-contrato  = RowObject.dt-contrato NO-LOCK :
            assign vl-tit-vinculados = vl-tit-vinculados + contr-titulo-exp.vl-vinculado-me
                   vl-tit-liquidar   = vl-tit-liquidar   + contr-titulo-exp.sl-liquidar-me.
        end.

        if RowObject.tp-contrato-exp = 1 then do: /* Pronto */
            assign RowObject.vl-liquidar-me = RowObject.vl-contrato-me - (vl-tit-vinculados - vl-tit-liquidar).
    
/*            if RowObject.nr-contrato <> "" or
               RowObject.nr-contrato  =  ? then do:
                if RowObject.situacao = 1 then do: /* "Pendente de Contrato". */
                    {method/svc/errors/inserr.i
                            &ErrorNumber="25452"
                            &ErrorType="EMS"
                            &ErrorParameters=" "}  /* Contrato n'o pode ser liquidado */
                end.
            end.    */
        end.

       if RowObject.situacao   = 3 then do: /* Liquidado */
          if RowObject.tp-contrato-exp <> 2 then do:  /* Antecipacao */
             {method/svc/errors/inserr.i
                         &ErrorNumber="19420"
                         &ErrorType="EMS"
                         &ErrorParameters=" "}  /* Contrato n'o pode ter situa»ao liquidado */
          end.
       end.

       if RowObject.situacao = 5 then do: /* Cancelado */
          {method/svc/errors/inserr.i
                      &ErrorNumber="26228"
                      &ErrorType="EMS"
                      &ErrorParameters=" "}
       end.

       if RowObject.situacao = 8 then do: /* Liquidado Sem Titulo */
          {utp/ut-liter.i liquidado_sem_titulo *}
          assign c-string1 = return-value.

          {method/svc/errors/inserr.i
                      &ErrorNumber="25922"
                      &ErrorType="EMS"
                      &ErrorParameters="c-string1"}
       end.

       if RowObject.situacao = 9 then do: /* Liquidado Sem Contrato */
          {utp/ut-liter.i liquidado_sem_contrato *}
          assign c-string1 = return-value.
          
          {method/svc/errors/inserr.i
                      &ErrorNumber="25922"
                      &ErrorType="EMS"
                      &ErrorParameters="c-string1"}
       end.

       if RowObject.situacao = 2 then do:
          if RowObject.dt-contrato = ? or
             RowObject.nr-contrato = "" then
             {method/svc/errors/inserr.i
                         &ErrorNumber="19695"
                         &ErrorType="EMS"
                         &ErrorParameters=" "}
       end.

       if RowObject.tp-contrato-exp = 2 then do:
          if RowObject.dt-contrato = ? or
             RowObject.nr-contrato = "" then
             {method/svc/errors/inserr.i
                         &ErrorNumber="26230"
                         &ErrorType="EMS"
                         &ErrorParameters=" "}
       end.

       if RowObject.cod-estabel = "" then
          {method/svc/errors/inserr.i
                       &ErrorNumber="3645"
                       &ErrorType="EMS"
                       &ErrorParameters=" "}

       if RowObject.cod-estabel <> "" then do:
          if can-find (first estabelec where estabelec.cod-estabel = RowObject.cod-estabel) = no then
             {method/svc/errors/inserr.i
                          &ErrorNumber="2061"
                          &ErrorType="EMS"
                          &ErrorParameters=" "}
       end.

       if RowObject.referencia = "" then
          {method/svc/errors/inserr.i
                       &ErrorNumber="15083"
                       &ErrorType="EMS"
                       &ErrorParameters=" "}

       if RowObject.dt-referencia = ? then
            {method/svc/errors/inserr.i
                        &ErrorNumber="19326"
                        &ErrorType="EMS"
                        &ErrorParameters=" "}
       
       if RowObject.moeda = 0 then
          {method/svc/errors/inserr.i
                      &ErrorNumber="4215"
                      &ErrorType="EMS"
                      &ErrorParameters=" "}

       if can-find (first moeda where moeda.mo-codigo = RowObject.moeda) = no then
          {method/svc/errors/inserr.i
                      &ErrorNumber="930"
                      &ErrorType="EMS"
                      &ErrorParameters=" "}

       if RowObject.nr-contrato <> "" and 
          RowObject.dt-contrato  = ? then
          {method/svc/errors/inserr.i
                      &ErrorNumber="19379"
                      &ErrorType="EMS"
                      &ErrorParameters=" "}

       if RowObject.nr-contrato <> "" and
          RowObject.vl-contrato =  0  AND
          RowObject.situacao <> 1 then   /* cris */
          {method/svc/errors/inserr.i
                      &ErrorNumber="26231"
                      &ErrorType="EMS"
                      &ErrorParameters=" "}

       if RowObject.cod-forma-pgto-mec <> "" or
          RowObject.cod-forma-pgto-mec  =  ? then do:
            if can-find (first forma-pgto-mec where forma-pgto-mec.cod-forma-pgto-mec = RowObject.cod-forma-pgto-mec) = no then
                {method/svc/errors/inserr.i
                           &ErrorNumber="19701"
                           &ErrorType="EMS"
                           &ErrorParameters=" "}
       end.

       if RowObject.cod-oper-cambio <> "" or
          RowObject.cod-oper-cambio  =  ? then do:
            if can-find (first operac-cambio where operac-cambio.cod-oper-cambio = RowObject.cod-oper-cambio) = no then
                {method/svc/errors/inserr.i
                           &ErrorNumber="26229"
                           &ErrorType="EMS"
                           &ErrorParameters=" "}
       end.

       if RowObject.cod-corretor <> 0 then do:
            if can-find (first emitente where emitente.cod-emitente = RowObject.cod-corretor) = no then
                {method/svc/errors/inserr.i
                           &ErrorNumber="19332"
                           &ErrorType="EMS"
                           &ErrorParameters=" "}
       end.
       
       if RowObject.dt-contrato <> ? then do:
          if RowObject.dt-liquidacao < RowObject.dt-contrato then
             {method/svc/errors/inserr.i
                         &ErrorNumber="19333"
                         &ErrorType="EMS"
                         &ErrorParameters=" "}

          if RowObject.dt-cambiais < RowObject.dt-contrato then
             {method/svc/errors/inserr.i
                         &ErrorNumber="26232"
                         &ErrorType="EMS"
                         &ErrorParameters=" "}

          if RowObject.dt-entr-docto < RowObject.dt-contrato then
             {method/svc/errors/inserr.i
                         &ErrorNumber="26233"
                         &ErrorType="EMS"
                         &ErrorParameters=" "}
                         
          if  RowObject.tp-contrato-exp <> 3 /*Emprestimo*/
          and RowObject.dt-contrato < RowObject.dt-referencia then
             {method/svc/errors/inserr.i
                         &ErrorNumber="26225"
                         &ErrorType="EMS"
                         &ErrorParameters=" "}
       end.       

       if RowObject.nr-contrato <> "" then do:
           if RowObject.cod-comprador = 0 and
              RowObject.situacao <> 1    then  /* cris */
               {method/svc/errors/inserr.i
                           &ErrorNumber="26226"
                           &ErrorType="EMS"
                           &ErrorParameters=" "}
       end.

       if RowObject.cod-comprador <> 0 then do:
            if can-find (first banco where banco.cod-banco = RowObject.cod-comprador) = no then
                {method/svc/errors/inserr.i
                           &ErrorNumber="26227"
                           &ErrorType="EMS"
                           &ErrorParameters=" "}
       end.

       if   RowObject.tp-contrato-exp = 1
       AND  ptype = "Update":U
       AND  RowObject.vl-liquidar-me = 0
       then
            assign RowObject.situacao = 3.


    end. /* Create e Update */
    
    if ptype = "Delete":U then do:

          FIND FIRST contr-titulo-exp 
              where contr-titulo-exp.nr-contrato  = RowObject.nr-contrato    
              and   contr-titulo-exp.dt-contrato  = RowObject.dt-contrato no-lock no-error.

          if avail contr-titulo-exp then
            {method/svc/errors/inserr.i
                        &ErrorNumber="25454"
                        &ErrorType="EMS"
                        &ErrorParameters=" "}

          find first contr-docto-exp of RowObject no-lock no-error.
          if avail contr-docto-exp then
            {method/svc/errors/inserr.i
                        &ErrorNumber="25454"
                        &ErrorType="EMS"
                        &ErrorParameters=" "}

          find first contr-despesa-exp of RowObject no-lock no-error.
          if avail contr-despesa-exp then
            {method/svc/errors/inserr.i
                        &ErrorNumber="25454"
                        &ErrorType="EMS"
                        &ErrorParameters=" "}

        if RowObject.situacao = 8 or
           RowObject.situacao = 9 then do:   /* Liquidado sem titulo ou liquidado sem contrato */
            {method/svc/errors/inserr.i
                    &ErrorNumber="26145"
                    &ErrorType="EMS"
                    &ErrorParameters=" "}
        end.

        if RowObject.tp-contrato-exp = 1 and  /*   Pronto  */
           RowObject.situacao <> 3 then do:   /* Liquidado */
            if RowObject.vl-liquidar-me <> RowObject.vl-contrato-me then
                {method/svc/errors/inserr.i
                        &ErrorNumber="19334"
                        &ErrorType="EMS"
                        &ErrorParameters=" "}
        end.
    end. /* Delete */ 

    /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
