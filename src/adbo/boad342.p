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
{include/i-prgvrs.i BOAD342 2.00.00.050 } /*** "010050" 10/06/2025 09:30:37 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad342 MUT}
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
&GLOBAL-DEFINE DBOName            BOAD342
&GLOBAL-DEFINE DBOVersion         1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName          contr-titulo-imp
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName          qr{&TableName}



{include/i_dbvers.i}
{cdp/cdcfgfin.i}



/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{adbo/boad342.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

/*** Temp-Tables Canc. Docto ***/
{app/apapi018.i}

/*--- Include com definaá∆o da apapi022.p de Antecipaá∆o---*/
{app/apapi022a.i}
/*--- Include utilizada para a conexao do ems 5---*/
{utp/ut-glob.i}
{cdp/cd1202.i5}
{btb/btb009za.i}



/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var i-ep-codigo     like contr-titulo-imp.ep-codigo     no-undo.
def var c-cod-estabel   like contr-titulo-imp.cod-estabel   no-undo.
def var c-referencia    like contr-titulo-imp.referencia    no-undo.
def var d-dt-referencia like contr-titulo-imp.dt-referencia no-undo.
def var i-cod-emitente  like contr-titulo-imp.cod-emitente  no-undo.
def var c-cod-esp       like contr-titulo-imp.cod-esp       no-undo.
def var c-serie         like contr-titulo-imp.serie         no-undo.
def var c-nr-docto      like contr-titulo-imp.nr-docto      no-undo.
def var c-parcela       like contr-titulo-imp.parcela       no-undo.
def var c-nr-contrato   like contr-titulo-imp.nr-contrato   no-undo.
def var d-dt-contrato   like contr-titulo-imp.dt-contrato   no-undo.
def var c-nr-contrato-tela   like contr-titulo-imp.nr-contrato   no-undo.
def var d-dt-contrato-tela   like contr-titulo-imp.dt-contrato   no-undo.

def var c-cod-estabel-ini like contr-titulo-imp.cod-estabel no-undo.
def var c-cod-estabel-fim like contr-titulo-imp.cod-estabel no-undo.
def var i-cod-fornec-ini  like contr-titulo-imp.cod-emitente no-undo.
def var i-cod-fornec-fim  like contr-titulo-imp.cod-emitente no-undo.
def var c-nr-docto-ini    like contr-titulo-imp.nr-docto    no-undo.
def var c-nr-docto-fim    like contr-titulo-imp.nr-docto    no-undo.
def var d-dt-vencimen-ini like contr-titulo-imp.dt-vencimen no-undo.
def var d-dt-vencimen-fim like contr-titulo-imp.dt-vencimen no-undo.

def var i-seq-erro as integer no-undo.
def var l-erro     as logical no-undo.
def var hshowmsg   as handle  no-undo.
def var v-pagar    as char    no-undo. /* "EMS 2" ; "EMS 5" */
def var v-receber  as char    no-undo. /* "EMS 2" ; "EMS 5" */
def var h-boad355  as handle  no-undo.

def new global shared var v_cod_usuar_corren as character no-undo. 
def new global shared var v_cod_empres_usuar as character no-undo. 
def var v_cod_usuar_corren_old               as character no-undo. 
def var v_cod_empres_usuar_old               as CHARACTER no-undo. 

def temp-table tt-param-selecao-tit no-undo
   field estabelecimento-ini like tit-ap.cod-estabel
   field estabelecimento-fim like tit-ap.cod-estabel
   field esp-ini      like tit-ap.cod-esp 
   field esp-fim      like tit-ap.cod-esp
   field fornec-ini   like tit-ap.cod-fornec
   field fornec-fim   like tit-ap.cod-fornec
   field docto-ini    like tit-ap.nr-docto
   field docto-fim    like tit-ap.nr-docto
   field vencimen-ini like tit-ap.dt-vencimen
   field vencimen-fim like tit-ap.dt-vencimen
   field prev-pag-ini like tit-ap.dt-prev-pag
   field prev-pag-fim like tit-ap.dt-prev-pag.

def temp-table tt_tit_ap_ems5 no-undo
    field cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field val_sdo_tit_ap               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Saldo" column-label "Valor Saldo"
    field dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field dat_prev_pagto               as date format "99/99/9999" initial today label "Data Prevista Pgto" column-label "Dt Prev Pagto".


def temp-table tt-tit-ap-selecionados no-undo like tit-ap
    field r-rowid         as rowid 
    field de-vl-vinculado as decimal label "Vl Vinculado" format ">,>>>,>>>,>>9.99"
    field ctr-referencia  as char
    field dt-referencia   as date
    field nr-contrato     as char
    field dt-contrato     as date.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància".

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
    field cod-emitente    as int  format ">>>>>>>>9"           label "Fornecedor"
    field dt-vinculado    as date format "99/99/9999"          label "Dt Vinculado"
    field dt-vencto       as date format "99/99/9999"          label "Dt  Vencto"
    field vl-vinculado-me as dec  format "->>>,>>>,>>>,>>9.99" label "Vl Vinculado ME"
    field sl-liquidar-me  as dec  format "->>>,>>>,>>>,>>9.99" label "Sl Liquidar ME"
    field nr-contrato     as char format "x(15)"               label "Nr.Contrato"
    field dt-contrato     as date format "99/99/9999"          label "Data Contrato".


def temp-table tt-contrato no-undo
&IF "{&mguni_version}" >= "2.07A" &THEN
    field ep-codigo      LIKE empresa.ep-codigo
&ELSE
    field ep-codigo      as int format ">>9"
&ENDIF
&IF "{&mguni_version}" >= "2.07A" &THEN
    field cod-estabel    as char format "x(05)"       label "Est"
&ELSE
    field cod-estabel    as char format "x(3)"       label "Est"
&ENDIF
    field referencia     as char format "x(10)"      label "Referància"
    field dt-referencia  as date format "99/99/9999" label "Dt Ref"
    field nr-contrato    as char format "x(15)"      label "Nr Contr"
    field dt-contrato    as date format "99/99/9999" label "Dt Contr"
    field cod-vendedor   as int format "999"         label "Ven"
    field dt-liquidacao  as date format "99/99/9999" label "Liq"
    field vl-contrato-me as decimal format "->>>,>>>,>>>,>>9.99" label "Vl Contrato ME"
    field r-rowid as rowid.

def temp-table tt-ord-compra-pend no-undo
&IF "{&mguni_version}" >= "2.07A" &THEN
    field cod-estab             as character format "x(05)"
&ELSE
    field cod-estab             as character format "x(3)"
&ENDIF
    field cod-refer             as character format "x(10)"
    field num-seq-refer         as INTEGER   format ">>>9"
    field cod-ord-compra        as character format "x(8)"
    field val-perc-ord-compra   as DECIMAL   format ">>9.99"
    field val-origin-ord-compra as DECIMAL   format "->>,>>>,>>>,>>9.99"
    field val-sdo-ord-compra    as DECIMAL   format "->>,>>>,>>>,>>9.99"
    INDEX codigo IS PRIMARY IS UNIQUE cod-estab
                                      cod-refer
                                      num-seq-refer 
                                      cod-ord-compra ASCENDING.

def temp-table tt-param-totalizacao no-undo
    field ttv-cliente-ini   as int  format '9'
    field ttv-cliente-fim   as int  format '>>>>>>>>9'
    field ttv-vencto-ini    as date format 99/99/9999
    field ttv-vencto-fim    as date format 99/99/9999
    field ttv-pais-ini      as char format 'x(20)'
    field ttv-pais-fim      as char format 'x(20)'
    field ttv-tit-csa-saldo as int  format '9'.

def temp-table tt-contrato-imp no-undo like contrato-imp
    field r-rowid as rowid.

find param-global no-lock no-error.

def temp-table tt-contr-titulo-imp no-undo like contr-titulo-imp
    field r-rowid as rowid.

DEFINE TEMP-TABLE tt-emitente NO-UNDO LIKE emitente
       field r-rowid as rowid
       index nome nome-abrev.

DEF BUFFER b-contr-titulo-imp FOR contr-titulo-imp.

def var h-boad180o as handle no-undo.
def var de-vl-vinculado-me like contr-titulo-imp.vl-vinculado-me no-undo.
def var de-vl-movto-ap as decimal no-undo.
def var p-eliminou as logical no-undo.  
def var c-desc-erro as char no-undo.

{ecp/ec0003.i2} /*arbitragem*/

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


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE aftercreateRecord DBOProgram 
PROCEDURE aftercreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   def var h-boad343 as handle no-undo.
   run adbo/boad343.p persistent set h-boad343.


   run pi-cria-docto-automatico in h-boad343 (input RowObject.ep-codigo,
                                              input RowObject.cod-estabel,
                                              input RowObject.referencia,
                                              input RowObject.dt-referencia,
                                              input RowObject.cod-emitente,
                                              input RowObject.cod-esp,
                                              input RowObject.serie,
                                              input RowObject.nr-docto,
                                              input RowObject.parcela).
   delete procedure h-boad343.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforecreateRecord DBOProgram 
PROCEDURE beforecreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    find contrato-imp
         where contrato-imp.nr-contrato   = c-nr-contrato-tela
         and   contrato-imp.dt-contrato   = d-dt-contrato-tela exclusive-lock no-error.

    if avail contrato-imp then do:
        if contrato-imp.tp-contrato-imp = 1 then  /* Pronto */
           assign RowObject.sl-liquidar-me = RowObject.vl-vinculado-me.

        assign RowObject.nr-contrato = contrato-imp.nr-contrato
               RowObject.dt-contrato = contrato-imp.dt-contrato.

    end.
    FIND FIRST contr-titulo-imp NO-LOCK
       WHERE contr-titulo-imp.ep-codigo    = RowObject.ep-codigo
         AND contr-titulo-imp.cod-estabel  = RowObject.cod-estabel
         AND contr-titulo-imp.cod-emitente = RowObject.cod-emitente
         AND contr-titulo-imp.cod-esp      = RowObject.cod-esp
         AND contr-titulo-imp.serie        = RowObject.serie
         AND contr-titulo-imp.nr-docto     = RowObject.nr-docto
         AND contr-titulo-imp.parcela      = RowObject.parcela NO-ERROR.
    IF NOT AVAIL contr-titulo-imp THEN DO:
       ASSIGN  RowObject.log-1 = YES.
    END.
    Return "OK":U.              
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

    run adbo/boad355.p persistent set h-boad355.
    run pi-verificar-produto in h-boad355 (output v-pagar,
                                           output v-receber).
    delete procedure h-boad355.
    
    find first contrato-imp
         where contrato-imp.referencia    = RowObject.referencia
         and   contrato-imp.dt-referencia = RowObject.dt-referencia EXCLUSIVE-LOCK NO-ERROR.

    if contrato-imp.tp-contrato-imp = 2 then do:
        assign contrato-imp.vl-contrato-me = contrato-imp.vl-contrato-me - RowObject.vl-vinculado-me.

        IF v-pagar = "EMS 5" THEN DO:
       
           {cdp/cd1202.i3 i-ep-codigo-usuario}
           if l-conec-bas = yes and l-conec-fin = yes and l-conec-uni = yes  then do:
           
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
                   RETURN "NOK".
               end.
               &ENDIF
               FOR EACH tt-antecip-1:
                   DELETE tt-antecip-1.
               END.
               CREATE tt-antecip-1.
               ASSIGN tt-antecip-1.ep-codigo   = RowObject.ep-codigo
                      tt-antecip-1.cod-estabel = RowObject.cod-estabel
                      tt-antecip-1.cod-fornec  = RowObject.cod-emitente
                      tt-antecip-1.cod-esp     = RowObject.cod-esp
                      tt-antecip-1.serie       = RowObject.serie
                      tt-antecip-1.nr-docto    = RowObject.nr-docto
                      tt-antecip-1.parcela     = RowObject.parcela
                      tt-antecip-1.referencia  = RowObject.char-1
                      tt-antecip-1.data-1      = RowObject.data-1.
               
               run prgfin/apb/apb920za.p (INPUT 2,
                                          input "",
                                          input table tt-antecip-1,
                                          input table tt-ord-compra-pend,
                                          output table tt_log_erro).

               {cdp/cd1202.i4 i-ep-codigo-usuario}
               
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
               if i-seq-erro <> 0 then do:
                   IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
                       RETURN "NOK":U.
               end.
           END.
           ELSE DO:
               assign i-seq-erro = 0.
               for each tt_erros_conexao:
                   IF   tt_erros_conexao.cd-erro = 25823 THEN DO:
                        run utp/ut-msgs.p (input "help":U, input 25823, input tt_erros_conexao.param-1).
                            
                        assign i-seq-erro = i-seq-erro + 10.
                        create RowErrors.
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter AS CHARACTER NO-UNDO.
                        ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-tt-erros-conexaopa AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "tt_erros_conexao.param-1" *}
                        ASSIGN c-lbl-liter-tt-erros-conexaopa = TRIM(RETURN-VALUE).
                        assign RowErrors.ErrorSequence    = i-seq-erro
                               RowErrors.ErrorNumber      = tt_erros_conexao.cd-erro
                               RowErrors.ErrorParameters  = c-lbl-liter-tt-erros-conexaopa
                               RowErrors.ErrorType        = ""
                               RowErrors.ErrorSubType     = "ERROR"
                               RowErrors.ErrorDescription = tt_erros_conexao.mensagem
                               RowErrors.ErrorHelp        = c-lbl-liter.
                   END.
                   ELSE DO:
                       assign i-seq-erro = i-seq-erro + 10.
                       create RowErrors.
                       assign RowErrors.ErrorSequence    = i-seq-erro
                              RowErrors.ErrorNumber      = tt_erros_conexao.cd-erro
                              RowErrors.ErrorParameters  = ""
                              RowErrors.ErrorType        = ""
                              RowErrors.ErrorSubType     = "ERROR"
                              RowErrors.ErrorDescription = tt_erros_conexao.mensagem
                              RowErrors.ErrorHelp        = tt_erros_conexao.param-1.
                   END.
               end. 
               if i-seq-erro <> 0 then do:
                   IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
                       RETURN "NOK":U.
               end.
           END.
        END.
    end. /** Antecipaá∆o **/
    IF RowObject.log-1 = YES THEN DO:
       FIND FIRST b-contr-titulo-imp EXCLUSIVE-LOCK
          WHERE b-contr-titulo-imp.ep-codigo    = RowObject.ep-codigo
            AND b-contr-titulo-imp.cod-estabel  = RowObject.cod-estabel
            AND b-contr-titulo-imp.cod-emitente = RowObject.cod-emitente
            AND b-contr-titulo-imp.cod-esp      = RowObject.cod-esp
            AND b-contr-titulo-imp.serie        = RowObject.serie
            AND b-contr-titulo-imp.nr-docto     = RowObject.nr-docto
            AND b-contr-titulo-imp.parcela      = RowObject.parcela
            AND b-contr-titulo-imp.nr-contrato  <> RowObject.nr-contrato NO-ERROR.
       IF AVAIL b-contr-titulo-imp THEN DO:
          ASSIGN  b-contr-titulo-imp.log-1 = YES.
       END.
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BuscaChaveTela DBOProgram 
PROCEDURE BuscaChaveTela :
/*------------------------------------------------------------------------------
  Purpose:     grava dados da chave secundaria em variaveis
  Parameters:  dados tela
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-nr-contrato   like contr-titulo-imp.nr-contrato    no-undo.
    def input param p-dt-contrato   like contr-titulo-imp.dt-contrato    no-undo.

    ASSIGN c-nr-contrato-tela  = p-nr-contrato
           d-dt-contrato-tela  = p-dt-contrato  .
    
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
        WHEN "cod-esp":U THEN ASSIGN pFieldValue = RowObject.cod-esp.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        WHEN "nr-docto":U THEN ASSIGN pFieldValue = RowObject.nr-docto.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
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

   case c-table:
      when "emitente":u then do:
         find emitente where emitente.cod-emitente = int(c-param) no-lock no-error.
         if avail emitente then
            assign c-description = emitente.nome-emit.
         else
            assign c-description = "".
      end.
   end.
   
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE contr-titulo-imp.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE contr-titulo-imp.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER preferencia LIKE contr-titulo-imp.referencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-referencia LIKE contr-titulo-imp.dt-referencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE contr-titulo-imp.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-esp LIKE contr-titulo-imp.cod-esp NO-UNDO.
    DEFINE OUTPUT PARAMETER pserie LIKE contr-titulo-imp.serie NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-docto LIKE contr-titulo-imp.nr-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pparcela LIKE contr-titulo-imp.parcela NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-estabel = RowObject.cod-estabel
           preferencia = RowObject.referencia
           pdt-referencia = RowObject.dt-referencia
           pcod-emitente = RowObject.cod-emitente
           pcod-esp = RowObject.cod-esp
           pserie = RowObject.serie
           pnr-docto = RowObject.nr-docto
           pparcela = RowObject.parcela.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetNomeAbrev DBOProgram 
PROCEDURE GetNomeAbrev :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter p-opcao       as   integer.
    def input parameter p-nr-contrato like contr-titulo-imp.nr-contrato.
    def input parameter p-dt-contrato like contr-titulo-imp.dt-contrato.
    def input-output parameter table for tt-emitente.

    if p-opcao = 1 then do:
        FOR EACH {&tablename} NO-LOCK
            WHERE contr-titulo-imp.nr-contrato = p-nr-contrato 
            and   contr-titulo-imp.dt-contrato = p-dt-contrato:
            if not can-find(first tt-emitente where 
                            tt-emitente.cod-emitente = contr-titulo-imp.cod-emitente) then do:
                find emitente 
                   where emitente.cod-emitente = contr-titulo-imp.cod-emitente
                   no-lock no-error.
                create tt-emitente.
                assign tt-emitente.cod-emitente   = contr-titulo-imp.cod-emitente
                       tt-emitente.nome-abrev = if avail emitente then emitente.nome-abrev else ""
                       tt-emitente.pais       = if avail emitente then emitente.pais else "".
            end.
        end.
    end.
    else do:
        FOR EACH {&tablename} NO-LOCK
           WHERE (contr-titulo-imp.cod-estabel >= c-cod-estabel-ini and
                  contr-titulo-imp.cod-estabel <= c-cod-estabel-fim)
             and (contr-titulo-imp.cod-emitente  >= i-cod-fornec-ini and
                  contr-titulo-imp.cod-emitente  <= i-cod-fornec-fim)
             and (contr-titulo-imp.nr-docto    >= c-nr-docto-ini and
                  contr-titulo-imp.nr-docto    <= c-nr-docto-fim)
             and (contr-titulo-imp.dt-vencimen >= d-dt-vencimen-ini and
                  contr-titulo-imp.dt-vencimen <= d-dt-vencimen-fim) AND
                  contr-titulo-imp.log-1 = YES:
            if not can-find(first tt-emitente where 
                            tt-emitente.cod-emitente = contr-titulo-imp.cod-emitente) then do:
                find emitente 
                   where emitente.cod-emitente = contr-titulo-imp.cod-emitente
                   no-lock no-error.
                create tt-emitente.
                assign tt-emitente.cod-emitente   = contr-titulo-imp.cod-emitente
                       tt-emitente.nome-abrev = if avail emitente then emitente.nome-abrev else "".
            end.
        end.
    end.

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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE contr-titulo-imp.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE contr-titulo-imp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER preferencia LIKE contr-titulo-imp.referencia NO-UNDO.
    DEFINE INPUT PARAMETER pdt-referencia LIKE contr-titulo-imp.dt-referencia NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE contr-titulo-imp.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pcod-esp LIKE contr-titulo-imp.cod-esp NO-UNDO.
    DEFINE INPUT PARAMETER pserie LIKE contr-titulo-imp.serie NO-UNDO.
    DEFINE INPUT PARAMETER pnr-docto LIKE contr-titulo-imp.nr-docto NO-UNDO.
    DEFINE INPUT PARAMETER pparcela LIKE contr-titulo-imp.parcela NO-UNDO.

    FIND FIRST bfcontr-titulo-imp WHERE 
        bfcontr-titulo-imp.ep-codigo = pep-codigo AND 
        bfcontr-titulo-imp.cod-estabel = pcod-estabel AND 
        bfcontr-titulo-imp.referencia = preferencia AND 
        bfcontr-titulo-imp.dt-referencia = pdt-referencia AND 
        bfcontr-titulo-imp.cod-emitente = pcod-emitente AND 
        bfcontr-titulo-imp.cod-esp = pcod-esp AND 
        bfcontr-titulo-imp.serie = pserie AND 
        bfcontr-titulo-imp.nr-docto = pnr-docto AND 
        bfcontr-titulo-imp.parcela = pparcela NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcontr-titulo-imp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcontr-titulo-imp)).
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
    
    DEFINE INPUT PARAMETER pep-codigo    LIKE contr-titulo-imp.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE contr-titulo-imp.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel  LIKE contr-titulo-imp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-esp      LIKE contr-titulo-imp.cod-esp NO-UNDO.
    DEFINE INPUT PARAMETER pserie        LIKE contr-titulo-imp.serie NO-UNDO.
    DEFINE INPUT PARAMETER pnr-docto     LIKE contr-titulo-imp.nr-docto NO-UNDO.
    DEFINE INPUT PARAMETER pparcela      LIKE contr-titulo-imp.parcela NO-UNDO.

    FIND FIRST bfcontr-titulo-imp WHERE 
        bfcontr-titulo-imp.ep-codigo = pep-codigo AND 
        bfcontr-titulo-imp.cod-emitente = pcod-emitente AND 
        bfcontr-titulo-imp.cod-estabel = pcod-estabel AND 
        bfcontr-titulo-imp.cod-esp = pcod-esp AND 
        bfcontr-titulo-imp.serie = pserie AND 
        bfcontr-titulo-imp.nr-docto = pnr-docto AND 
        bfcontr-titulo-imp.parcela = pparcela NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcontr-titulo-imp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcontr-titulo-imp)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToContrato-imp DBOProgram 
PROCEDURE linkToContrato-imp :
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
                           
    run setConstraintContratoImp in this-procedure (input i-ep-codigo,
                                                    input c-cod-estabel,
                                                    input c-referencia,
                                                    input d-dt-referencia).
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToContrato-imp2 DBOProgram 
PROCEDURE linkToContrato-imp2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter phandle as handle no-undo.
    
    run getkey2 in phandle (output c-nr-contrato ,
                           output d-dt-contrato ).
                          
    run setConstraintContratoImp2 in this-procedure (input c-nr-contrato ,
                                                     input d-dt-contrato ).
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToContrato-imp3 DBOProgram 
PROCEDURE linkToContrato-imp3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter phandle as handle no-undo.
    
    run getkey2 in phandle (output c-nr-contrato ,
                           output d-dt-contrato ).
                          
    run setConstraintContratoImp3 in this-procedure (input c-nr-contrato ,
                                                     input d-dt-contrato ).
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryContr-titulo-imp DBOProgram 
PROCEDURE openQueryContr-titulo-imp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
         WHERE (contr-titulo-imp.cod-estabel >= c-cod-estabel-ini and
                contr-titulo-imp.cod-estabel <= c-cod-estabel-fim)
           and (contr-titulo-imp.cod-emitente  >= i-cod-fornec-ini and
                contr-titulo-imp.cod-emitente  <= i-cod-fornec-fim)
           and (contr-titulo-imp.nr-docto    >= c-nr-docto-ini and
                contr-titulo-imp.nr-docto    <= c-nr-docto-fim)
           and (contr-titulo-imp.dt-vencimen >= d-dt-vencimen-ini and
                contr-titulo-imp.dt-vencimen <= d-dt-vencimen-fim) AND
                contr-titulo-imp.log-1 = YES
           BY contr-titulo-imp.cod-estabel
           BY contr-titulo-imp.cod-emitente
           BY contr-titulo-imp.cod-esp
           BY contr-titulo-imp.serie
           BY contr-titulo-imp.nr-docto
           BY contr-titulo-imp.parcela.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryContratoImp DBOProgram 
PROCEDURE openQueryContratoImp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
        WHERE contr-titulo-imp.ep-codigo     = i-ep-codigo and
              contr-titulo-imp.cod-estabel   = c-cod-estabel and
              contr-titulo-imp.referencia    = c-referencia and
              contr-titulo-imp.dt-referencia = d-dt-referencia 
              by contr-titulo-imp.dt-vencimen
              by contr-titulo-imp.nr-docto.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryContratoImp2 DBOProgram 
PROCEDURE openQueryContratoImp2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
        WHERE contr-titulo-imp.nr-contrato = c-nr-contrato and
              contr-titulo-imp.dt-contrato = d-dt-contrato 
              by contr-titulo-imp.dt-vencimen
              by contr-titulo-imp.nr-docto.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryContratoImp3 DBOProgram 
PROCEDURE openQueryContratoImp3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
        WHERE contr-titulo-imp.nr-contrato = c-nr-contrato and
              contr-titulo-imp.dt-contrato = d-dt-contrato AND
              contr-titulo-imp.sl-liquidar-me > 0 
              by contr-titulo-imp.dt-vencimen
              by contr-titulo-imp.nr-docto
              BY contr-titulo-imp.ep-codigo ~ 
              BY contr-titulo-imp.cod-estabel ~
              BY contr-titulo-imp.referencia ~
              BY contr-titulo-imp.dt-referencia ~
              BY contr-titulo-imp.cod-emitente ~
              BY contr-titulo-imp.cod-esp ~
              BY contr-titulo-imp.serie ~
              BY contr-titulo-imp.parcela.

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

    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
        BY contr-titulo-imp.cod-estabel
        BY contr-titulo-imp.cod-emitente
        BY contr-titulo-imp.cod-esp
        BY contr-titulo-imp.serie
        BY contr-titulo-imp.nr-docto
        BY contr-titulo-imp.parcela.
        

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain2 DBOProgram 
PROCEDURE openQueryMain2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
        BY contr-titulo-imp.cod-estabel
        BY contr-titulo-imp.cod-emitente
        BY contr-titulo-imp.cod-esp
        BY contr-titulo-imp.serie
        BY contr-titulo-imp.nr-docto
        BY contr-titulo-imp.parcela.
        
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
         WHERE contrato-imp.vl-liquidar-me > 0 and
           contrato-imp.situacao = 2.
    RETURN "OK":U.
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
    def var          h-boad361       as handle  no-undo.

    for each contr-titulo-imp where contr-titulo-imp.ep-codigo    = p-ep-codigo
                              and   contr-titulo-imp.cod-emitente = p-cod-fornec
                              and   contr-titulo-imp.cod-estabel  = p-cod-estabel
                              and   contr-titulo-imp.cod-esp      = p-cod-esp
                              and   contr-titulo-imp.serie        = p-serie
                              and   contr-titulo-imp.nr-docto     = p-nr-docto
                              and   contr-titulo-imp.parcela      = p-parcela EXCLUSIVE-LOCK:
                              
        if not valid-handle(h-boad361) then
            run adbo/boad361.p persistent set h-boad361.

        run pi-atualiza-historico2 in h-boad361 (input contr-titulo-imp.ep-codigo,
                                                 input contr-titulo-imp.cod-estabel,
                                                 input contr-titulo-imp.referencia,
                                                 input contr-titulo-imp.dt-referencia,
                                                 input "Data de Vencimento",
                                                 input string(contr-titulo-imp.dt-vencimen),
                                                 input string(p-dt-vencimen),
                                                 input contr-titulo-imp.nr-docto,
                                                 input contr-titulo-imp.serie,
                                                 input contr-titulo-imp.cod-esp,
                                                 input contr-titulo-imp.cod-emitente).
        assign contr-titulo-imp.dt-vencimen = p-dt-vencimen.
    end.

    if valid-handle(h-boad361) then
        delete procedure h-boad361.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-contr-titulo-exp DBOProgram 
PROCEDURE pi-altera-contr-titulo-exp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-nr-contrato-old as char format "x(15)"    no-undo.
    def input param p-dt-contrato-old as date format 99/99/9999 no-undo.
    def input param p-nr-contrato-new as char format "x(15)"    no-undo.
    def input param p-dt-contrato-new as date format 99/99/9999 no-undo.

    for each contr-titulo-imp exclusive-lock
        where contr-titulo-imp.nr-contrato = p-nr-contrato-old
        and   contr-titulo-imp.dt-contrato = p-dt-contrato-old:

        if contr-titulo-imp.nr-contrato <> p-nr-contrato-new then
            assign contr-titulo-imp.nr-contrato = p-nr-contrato-new.

        if contr-titulo-imp.dt-contrato <> p-dt-contrato-new then
            assign contr-titulo-imp.dt-contrato = p-dt-contrato-new.
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
    def input param p-ep-codigo     like contr-titulo-imp.ep-codigo      no-undo.
    def input param p-cod-estabel   like contr-titulo-imp.cod-estabel    no-undo.
    def input param p-referencia    like contr-titulo-imp.referencia     no-undo.
    def input param p-dt-referencia like contr-titulo-imp.dt-referencia  no-undo.
    def input param p-cod-emitente  like contr-titulo-imp.cod-emitente   no-undo.
    def input param p-cod-esp       like contr-titulo-imp.cod-esp        no-undo.
    def input param p-serie         like contr-titulo-imp.serie          no-undo.
    def input param p-nr-docto      like contr-titulo-imp.nr-docto       no-undo.
    def input param p-parcela       like contr-titulo-imp.parcela        no-undo.
    def input param p-nr-contrato   like contr-titulo-imp.nr-contrato    no-undo.
    def input param p-dt-contrato   like contr-titulo-imp.dt-contrato    no-undo.
    def input param p-vl-baixa      like contr-titulo-imp.sl-liquidar-me no-undo.

    def buffer bf-contr-titulo-imp for contr-titulo-imp.

    find bf-contr-titulo-imp
        where bf-contr-titulo-imp.ep-codigo = p-ep-codigo
          and bf-contr-titulo-imp.cod-estabel = p-cod-estabel
          and bf-contr-titulo-imp.referencia = p-referencia
          and bf-contr-titulo-imp.dt-referencia = p-dt-referencia
          and bf-contr-titulo-imp.cod-emitente = p-cod-emitente
          and bf-contr-titulo-imp.cod-esp = p-cod-esp
          and bf-contr-titulo-imp.serie = p-serie
          and bf-contr-titulo-imp.nr-docto = p-nr-docto
          and bf-contr-titulo-imp.parcela = p-parcela
          and bf-contr-titulo-imp.nr-contrato = p-nr-contrato
          and bf-contr-titulo-imp.dt-contrato = p-dt-contrato
          exclusive-lock no-error.

    if  avail bf-contr-titulo-imp then
        assign bf-contr-titulo-imp.sl-liquidar-me = bf-contr-titulo-imp.sl-liquidar-me - p-vl-baixa.

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
    def var c-usuario like contr-titulo-imp.usuario.

    {method/svc/autentic/autentic.i
            &vUserName="c-usuario"}

    assign RowObject.usuario   = c-usuario
           RowObject.c-time   = string(TIME, "HH:MM")
           RowObject.dt-today = today.

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
    def input  param p-ep-codigo      like contr-titulo-imp.ep-codigo.
    def input  param p-cod-estabel    like contr-titulo-imp.cod-estabel.
    def input  param p-cod-emitente   like contr-titulo-imp.cod-emitente.
    def input  param p-cod-esp        like contr-titulo-imp.cod-esp.
    def input  param p-serie          like contr-titulo-imp.serie.
    def input  param p-nr-docto       like contr-titulo-imp.nr-docto.
    def input  param p-parcela        like contr-titulo-imp.parcela.
    def output param de-saldo-orig as decimal no-undo.
    def output param d-dt-vencimen as date no-undo.
    
    define variable h-apb798za as handle no-undo.
    
    assign d-dt-vencimen = ?.

    run adbo/boad355.p persistent set h-boad355.
    run pi-verificar-produto in h-boad355 (output v-pagar,
                                           output v-receber).
    delete procedure h-boad355.

    case v-pagar :
    when "EMS 5" then do: /* busca saldo orig EMS 5.0 */
        {cdp/cd1202.i3 i-ep-codigo-usuario}
        if l-conec-bas = yes and l-conec-fin = yes and l-conec-uni = yes  then do:
                
            run prgfin/apb/apb798za.py persistent set h-apb798za.
            run pi_busca_saldo_tit_ap in h-apb798za (input p-ep-codigo,                           
                                                     input p-cod-estabel,                         
                                                     input p-cod-emitente, 
                                                     input p-cod-esp,      
                                                     input p-serie,        
                                                     input p-nr-docto,
                                                     input p-parcela,
                                                     output de-saldo-orig,                                       
                                                     output d-dt-vencimen).
            delete procedure h-apb798za.
            {cdp/cd1202.i4 i-ep-codigo-usuario}
        end.
    end.
    end case.

    RETURN "OK":U.
END PROCEDURE. /* fim pi-busca-saldo-orig */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-saldo-titulo DBOProgram 
PROCEDURE pi-busca-saldo-titulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p-ep-codigo      like contr-titulo-imp.ep-codigo.
    def input  param p-cod-estabel    like contr-titulo-imp.cod-estabel.
    def input  param p-cod-emitente   like contr-titulo-imp.cod-emitente.
    def input  param p-cod-esp        like contr-titulo-imp.cod-esp.
    def input  param p-serie          like contr-titulo-imp.serie.
    def input  param p-nr-docto       like contr-titulo-imp.nr-docto.
    def input  param p-parcela        like contr-titulo-imp.parcela.
    def output param p-soma-vinculado as   decimal.
    def var h-bocx250                 as   handle  no-undo.
    def var c-esp-tit-transit         as   char    no-undo.
    def var c-return                  as   char    no-undo.

    assign p-soma-vinculado = 0.

    find first param-global no-lock no-error.
    if param-global.modulo-07 = yes then do:
       run cxbo/bocx250.p persistent set h-bocx250.

       /*** posiciona registro ***/
       run findCodigo in h-bocx250 (input p-cod-estabel,
                                    output c-return).
       /*** verifica se t°tulo em transito oriundo ***/
       if c-return = "" then 
           run getCharfield in h-bocx250 (input "esp-tit-transit":U,
                                          output c-esp-tit-transit).
       delete procedure h-bocx250.
    end.

    for each b-contr-titulo-imp
        where b-contr-titulo-imp.ep-codigo    = p-ep-codigo
        and   b-contr-titulo-imp.cod-estabel  = p-cod-estabel
        and   b-contr-titulo-imp.cod-emitente = p-cod-emitente
        and   b-contr-titulo-imp.cod-esp      = p-cod-esp
        and   b-contr-titulo-imp.serie        = p-serie
        and   b-contr-titulo-imp.nr-docto     = p-nr-docto
        and   b-contr-titulo-imp.parcela      = p-parcela no-lock:

        if b-contr-titulo-imp.cod-esp = c-esp-tit-transit then
           next.

        assign p-soma-vinculado = p-soma-vinculado + b-contr-titulo-imp.sl-liquidar-me.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-saldo-vinculado-titulo DBOProgram 
PROCEDURE pi-busca-saldo-vinculado-titulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p-ep-codigo      like contr-titulo-imp.ep-codigo.
    def input  param p-cod-estabel    like contr-titulo-imp.cod-estabel.
    def input  param p-cod-emitente   like contr-titulo-imp.cod-emitente.
    def input  param p-cod-esp        like contr-titulo-imp.cod-esp.
    def input  param p-serie          like contr-titulo-imp.serie.
    def input  param p-nr-docto       like contr-titulo-imp.nr-docto.
    def input  param p-parcela        like contr-titulo-imp.parcela.
    def output param p-soma-vinculado as   decimal.


    assign p-soma-vinculado = 0.

    for each  contr-titulo-imp
        where contr-titulo-imp.ep-codigo    = p-ep-codigo
        and   contr-titulo-imp.cod-estabel  = p-cod-estabel
        and   contr-titulo-imp.cod-emitente = p-cod-emitente
        and   contr-titulo-imp.cod-esp      = p-cod-esp
        and   contr-titulo-imp.serie        = p-serie
        and   contr-titulo-imp.nr-docto     = p-nr-docto
        and   contr-titulo-imp.parcela      = p-parcela no-lock:
        
        assign p-soma-vinculado = p-soma-vinculado + contr-titulo-imp.vl-vinculado-me.
    end.

    RETURN "OK":U.
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
   def input param pInicod-estabel   like contr-titulo-imp.cod-estabel   no-undo.
   def input param pEndcod-estabel   like contr-titulo-imp.cod-estabel   no-undo.
   def input param pInireferencia    like contr-titulo-imp.referencia    no-undo.
   def input param pEndreferencia    like contr-titulo-imp.referencia    no-undo.
   def input param pInidt-referencia like contr-titulo-imp.dt-referencia no-undo.
   def input param pEnddt-referencia like contr-titulo-imp.dt-referencia no-undo.
   def input param pInicod-emitente  like contr-titulo-imp.cod-emitente  no-undo.
   def input param pEndcod-emitente  like contr-titulo-imp.cod-emitente  no-undo.
   def input param pIninr-contrato   like contr-titulo-imp.nr-contrato   no-undo.
   def input param pEndnr-contrato   like contr-titulo-imp.nr-contrato   no-undo.
   def input param pIninr-docto      like contr-titulo-imp.nr-docto      no-undo.
   def input param pEndnr-docto      like contr-titulo-imp.nr-docto      no-undo.
   def output param table for tt-digita.
   def input-output parameter table for tt-emitente.

   def var i-ep-codigo like contr-titulo-imp.ep-codigo.
   def var h-acomp as handle no-undo.
    
    {method/svc/autentic/autentic.i
            &vUserEnterprise="i-ep-codigo"}

   for each tt-digita exclusive-lock:
      delete tt-digita.
   end.

   run utp/ut-acomp.p persistent set h-acomp.
   run pi-inicializar in h-acomp (input "Aguarde...").

   for each contr-titulo-imp
      where contr-titulo-imp.ep-codigo      = i-ep-codigo       and
            contr-titulo-imp.cod-estabel   >= pInicod-estabel   and
            contr-titulo-imp.cod-estabel   <= pEndcod-estabel   and
            contr-titulo-imp.referencia    >= pInireferencia    and
            contr-titulo-imp.referencia    <= pEndreferencia    and
            contr-titulo-imp.dt-referencia >= pInidt-referencia and
            contr-titulo-imp.dt-referencia <= pEnddt-referencia and
            contr-titulo-imp.cod-emitente  >= pInicod-emitente  and
            contr-titulo-imp.cod-emitente  <= pEndcod-emitente  and
            contr-titulo-imp.nr-contrato   >= pIninr-contrato   and
            contr-titulo-imp.nr-contrato   <= pEndnr-contrato   and
            contr-titulo-imp.nr-docto      >= pIninr-docto      and
            contr-titulo-imp.nr-docto      <= pEndnr-docto no-lock:

      if not can-find(tt-emitente where 
                      tt-emitente.cod-emitente = contr-titulo-imp.cod-emitente) then do:
          find emitente 
             where emitente.cod-emitente = contr-titulo-imp.cod-emitente
             no-lock no-error.
          create tt-emitente.
          assign tt-emitente.cod-emitente   = contr-titulo-imp.cod-emitente
                 tt-emitente.nome-abrev = if avail emitente then emitente.nome-abrev else "".
      end.

      create tt-digita.
      assign tt-digita.cod-estabel     = contr-titulo-imp.cod-estabel
             tt-digita.cod-esp         = contr-titulo-imp.cod-esp
             tt-digita.serie           = contr-titulo-imp.serie
             tt-digita.nr-docto        = contr-titulo-imp.nr-docto
             tt-digita.parcela         = contr-titulo-imp.parcela
             tt-digita.cod-emitente    = contr-titulo-imp.cod-emitente
             tt-digita.dt-vinculado    = contr-titulo-imp.dt-vinculado
             tt-digita.dt-vencto       = contr-titulo-imp.dt-vencimen
             tt-digita.sl-liquidar-me  = contr-titulo-imp.sl-liquidar-me
             tt-digita.vl-vinculado-me = contr-titulo-imp.vl-vinculado-me
             tt-digita.nr-contrato     = contr-titulo-imp.nr-contrato   
             tt-digita.dt-contrato     = contr-titulo-imp.dt-contrato.      

      find first contrato-imp no-lock
           where contrato-imp.nr-contrato = contr-titulo-imp.nr-contrato
           and   contrato-imp.dt-contrato = contr-titulo-imp.dt-contrato 
           use-index contrato no-error.

      if  avail contrato-imp and contrato-imp.situacao = 1 then /* pendente de contrato */       
          assign tt-digita.nr-contrato     = ''
                 tt-digita.dt-contrato     = ?.
      
      run pi-acompanhar in h-acomp (input tt-digita.nr-docto + "/" + tt-digita.parcela).
   end.
   run pi-finalizar in h-acomp.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-titulos-do-contrato DBOProgram 
PROCEDURE pi-busca-titulos-do-contrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /*** Procedure utilizada no m¢dulo de cÉmbio ***/
    def input param p-ep-codigo    like contr-titulo-imp.ep-codigo   no-undo.
    def input param p-cod-estabel  like contr-titulo-imp.cod-estabel no-undo.
    def input param p-cod-esp      like contr-titulo-imp.cod-esp     no-undo.
    def input param p-serie        like contr-titulo-imp.serie       no-undo.
    def input param p-nr-docto     like contr-titulo-imp.nr-docto    no-undo.
    def input param p-parcela      like contr-titulo-imp.parcela     no-undo.
    def input param p-cod-emitente like contr-titulo-imp.cod-emitente no-undo.
    def output param table for tt-contrato.


    for each tt-contrato:
       delete tt-contrato.
    end.
    
    FOR EACH contr-titulo-imp
       where contr-titulo-imp.ep-codigo    = p-ep-codigo and
             contr-titulo-imp.cod-estabel  = p-cod-estabel and
             contr-titulo-imp.cod-emitente = p-cod-emitente and
             contr-titulo-imp.cod-esp      = p-cod-esp and
             contr-titulo-imp.serie        = p-serie and
             contr-titulo-imp.nr-docto     = p-nr-docto and
             contr-titulo-imp.parcela      = p-parcela NO-LOCK:
             
         

/*       for each contrato-imp
          where contrato-imp.ep-codigo     = contr-titulo-imp.ep-codigo and
                contrato-imp.cod-estabel   = contr-titulo-imp.cod-estabel and
                contrato-imp.referencia    = contr-titulo-imp.referencia and
                contrato-imp.dt-referencia = contr-titulo-imp.dt-referencia no-lock: */
    
        for each contrato-imp
          where contrato-imp.NR-CONTRATO  = contr-titulo-imp.NR-CONTRATO and
                contrato-imp.DT-CONTRATO  = contr-titulo-imp.DT-CONTRATO no-lock:

          create tt-contrato.
          assign tt-contrato.ep-codigo      = contrato-imp.ep-codigo
                 tt-contrato.cod-estabel    = contrato-imp.cod-estabel
                 tt-contrato.referencia     = contrato-imp.referencia
                 tt-contrato.dt-referencia  = contrato-imp.dt-referencia
                 tt-contrato.nr-contrato    = contrato-imp.nr-contrato
                 tt-contrato.dt-contrato    = contrato-imp.dt-contrato
                 tt-contrato.cod-vendedor   = contrato-imp.cod-vendedor
                 tt-contrato.dt-liquidacao  = contrato-imp.dt-liquidacao
                 tt-contrato.vl-contrato-me = contrato-imp.vl-contrato-me
                 tt-contrato.r-rowid        = rowid(contrato-imp).

          if  contrato-imp.situacao = 1 then /* pendente de contrato */       
              assign tt-contrato.nr-contrato    = ''
                     tt-contrato.dt-contrato    = ?.     
       end.
    end. 
    
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

def input parameter table for tt-tit-ap-selecionados.
def input parameter c-tipo-contrato as char.

    assign cQueryUseded = "Main".
    for each RowObject exclusive-lock:
       delete RowObject.
    end.
    for each tt-tit-ap-selecionados:
        create RowObject.
        assign RowObject.ep-codigo       = tt-tit-ap-selecionados.ep-codigo
               RowObject.cod-estabel     = tt-tit-ap-selecionados.cod-estabel
               RowObject.referencia      = tt-tit-ap-selecionados.ctr-referencia
               RowObject.dt-referencia   = tt-tit-ap-selecionados.dt-referencia
               RowObject.nr-contrato     = tt-tit-ap-selecionados.nr-contrato
               RowObject.dt-contrato     = tt-tit-ap-selecionados.dt-contrato
               RowObject.cod-emitente    = tt-tit-ap-selecionados.cod-fornec
               RowObject.serie           = tt-tit-ap-selecionados.serie
               RowObject.cod-esp         = tt-tit-ap-selecionados.cod-esp
               RowObject.nr-docto        = tt-tit-ap-selecionados.nr-docto
               RowObject.parcela         = tt-tit-ap-selecionados.parcela
               RowObject.dt-vencimen     = tt-tit-ap-selecionados.dt-vencimen
               RowObject.sl-liquidar-me  = if c-tipo-contrato = '2' then 0 else tt-tit-ap-selecionados.de-vl-vinculado
               RowObject.vl-vinculado-me = tt-tit-ap-selecionados.de-vl-vinculado
               RowObject.char-1          = tt-tit-ap-selecionados.char-1.

        run createRecord in this-procedure.
    end.
/*    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN*/
       RETURN return-value.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-posiciona-registro DBOProgram 
PROCEDURE pi-posiciona-registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p-ep-codigo    like tit-ap.ep-codigo.
    def input  param p-cod-estabel  like tit-ap.cod-estabel.
    def input  param p-cod-emitente like tit-ap.cod-fornec.
    def input  param p-cod-esp      like tit-ap.cod-esp.
    def input  param p-serie        like tit-ap.serie.
    def input  param p-nr-docto     like tit-ap.nr-docto.
    def input  param p-parcela      like tit-ap.parcela.
    def output param p-rowid        as   rowid.
    
    find tit-ap where tit-ap.ep-codigo   = p-ep-codigo    and
                      tit-ap.cod-estabel = p-cod-estabel  and
                      tit-ap.cod-fornec  = p-cod-emitente and
                      tit-ap.cod-esp     = p-cod-esp      and
                      tit-ap.serie       = p-serie        and
                      tit-ap.nr-docto    = p-nr-docto     and
                      tit-ap.parcela     = p-parcela      no-lock no-error.
    
    if avail tit-ap then do:
        assign p-rowid = rowid(tit-ap).
        RETURN "OK":U.
    end.
    
    RETURN "NOK":U.
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

def input param p-ep-codigo       like contr-titulo-imp.ep-codigo.
def input param p-cod-estabel     like contr-titulo-imp.cod-estabel.
def input param p-esp-tit-transit as char no-undo.
def input param p-moeda           like tit-ap.moeda no-undo.
def input param p-referencia      like contr-titulo-imp.referencia no-undo.
def input param p-dt-referencia   like contr-titulo-imp.dt-referencia no-undo.
def input param p-nr-contrato     like contr-titulo-imp.nr-contrato no-undo.
def input param p-dt-contrato     like contr-titulo-imp.dt-contrato no-undo.
def input param p-dt-liquidacao   like contrato-imp.dt-liquidacao no-undo.
def input param table for tt-param-selecao-tit.
def output param table for tt-tit-ap-selecionados.

define variable v-pagar as char no-undo. /* "EMS 2" ; "EMS 5" */
define variable v-receber as char no-undo. /* "EMS 2" ; "EMS 5" */
define variable h-boad355 as handle no-undo.
define variable h-apb798za as handle no-undo.
define variable de-soma-vinculado as decimal no-undo.
define variable de-atualiza-saldo as decimal no-undo.

run adbo/boad355.p persistent set h-boad355.
run pi-verificar-produto in h-boad355 (output v-pagar,
                                       output v-receber).
delete procedure h-boad355.

case v-pagar :
    when "EMS 5" then do: /* busca saldo orig EMS 5.0 */
        {cdp/cd1202.i3 i-ep-codigo-usuario}
        if l-conec-bas = yes and l-conec-fin = yes and l-conec-uni = yes  then do:
            run prgfin/apb/apb798za.py persistent set h-apb798za.

            /* VErifica se a funá∆o Arbitragem est† ativa na base, para enviar dados ao APB */
            IF l-funcao-arbitragem = YES THEN DO:
                RUN pi_verif_funcao_e_moeda_estrang in h-apb798za (INPUT l-funcao-arbitragem).
            END.


            run pi_seleciona_titulos_cambio in h-apb798za (INPUT string(p-ep-codigo),
                                                           input p-cod-estabel,
                                                           input p-dt-liquidacao,
                                                           input p-moeda,
                                                           input table tt-param-selecao-tit,
                                                           INPUT p-dt-contrato,
                                                           output table tt_tit_ap_ems5).
            delete procedure h-apb798za.
            for each tt_tit_ap_ems5 no-lock:
                ASSIGN de-soma-vinculado = 0.
                for each contr-titulo-imp where 
                    &IF "{&mguni_version}" >= "2.07A" &THEN
                    contr-titulo-imp.ep-codigo = tt_tit_ap_ems5.cod_empresa                    
                    &ELSE
                    contr-titulo-imp.ep-codigo = int(tt_tit_ap_ems5.cod_empresa)
                    &ENDIF
                    and   contr-titulo-imp.cod-estabel = tt_tit_ap_ems5.cod_estab
                    and   contr-titulo-imp.cod-emitente = tt_tit_ap_ems5.cdn_fornecedor
                    and   contr-titulo-imp.cod-esp = tt_tit_ap_ems5.cod_espec_docto
                    and   contr-titulo-imp.serie = tt_tit_ap_ems5.cod_ser_docto
                    and   contr-titulo-imp.nr-docto = tt_tit_ap_ems5.cod_tit_ap
                    and   contr-titulo-imp.parcela = tt_tit_ap_ems5.cod_parcela no-lock:

                    if  contr-titulo-imp.cod-esp = p-esp-tit-transit then
                        next.

                    assign de-soma-vinculado = contr-titulo-imp.sl-liquidar-me + de-soma-vinculado.
                end.

                assign de-atualiza-saldo = tt_tit_ap_ems5.val_sdo_tit_ap - de-soma-vinculado.

                if  de-atualiza-saldo <> 0 then do:
                    create tt-tit-ap-selecionados.
                    assign &IF "{&mguni_version}" >= "2.07A" &THEN
                           tt-tit-ap-selecionados.ep-codigo = tt_tit_ap_ems5.cod_empresa         
                           &ELSE
                           tt-tit-ap-selecionados.ep-codigo = int(tt_tit_ap_ems5.cod_empresa)
                           &ENDIF
                           tt-tit-ap-selecionados.cod-estabel = tt_tit_ap_ems5.cod_estab
                           tt-tit-ap-selecionados.ctr-referencia = p-referencia
                           tt-tit-ap-selecionados.dt-referencia = p-dt-referencia
                           tt-tit-ap-selecionados.nr-contrato = p-nr-contrato
                           tt-tit-ap-selecionados.dt-contrato = p-dt-contrato
                           tt-tit-ap-selecionados.cod-fornec = tt_tit_ap_ems5.cdn_fornecedor
                           tt-tit-ap-selecionados.serie = tt_tit_ap_ems5.cod_ser_docto
                           tt-tit-ap-selecionados.cod-esp = tt_tit_ap_ems5.cod_espec_docto
                           tt-tit-ap-selecionados.nr-docto = tt_tit_ap_ems5.cod_tit_ap
                           tt-tit-ap-selecionados.parcela = tt_tit_ap_ems5.cod_parcela
                           tt-tit-ap-selecionados.dt-vencimen = tt_tit_ap_ems5.dat_vencto_tit_ap
                           tt-tit-ap-selecionados.dt-prev-pag = tt_tit_ap_ems5.dat_prev_pagto
                           tt-tit-ap-selecionados.vl-saldo-me = de-atualiza-saldo
                           tt-tit-ap-selecionados.de-vl-vinculado = de-atualiza-saldo.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-soma-titulos-contrato DBOProgram 
PROCEDURE pi-soma-titulos-contrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*** varifica se valor vinculado Ç maior q saldo do contrato ***/
    def input  param pep-codigo   like contrato-imp.ep-codigo   no-undo.
    def input  param pcod-estabel like contrato-imp.cod-estabel no-undo.
    def input  param pnr-contrato like contrato-imp.nr-contrato no-undo.
    def input  param pdt-contrato like contrato-imp.dt-contrato no-undo.
    def output param vl-titulos    as   decimal.

    assign vl-titulos = 0.
    for each b-contr-titulo-imp 
       where b-contr-titulo-imp.nr-contrato = pnr-contrato and
             b-contr-titulo-imp.dt-contrato = pdt-contrato no-lock.
        assign vl-titulos = vl-titulos + b-contr-titulo-imp.vl-vinculado-me.
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
    def input param table for tt-contr-titulo-imp.
    def input param table for tt-contrato-imp.
    def input param table for tt-param-totalizacao.
    def input param table for tt-emitente.
    def output param p-qtd-tit   as integer format ">,>>>,>>9":U no-undo.
    def output param p-vl-liquid as decimal format "->>>,>>>,>>>,>>9.99":U no-undo.
    def output param p-vl-tot-vincul as decimal format "->>>,>>>,>>>,>>9.99":U no-undo.
    def output param p-vl-tot-liquidado as decimal format "->>>,>>>,>>>,>>9.99":U no-undo.
    def output param p-vl-sdo-avincul   as decimal format "->>>,>>>,>>>,>>9.99":U no-undo.

    assign p-qtd-tit       = 0
           p-vl-liquid     = 0
           p-vl-tot-vincul = 0
           p-vl-tot-liquidado = 0
           p-vl-sdo-avincul   = 0.

    find first tt-param-totalizacao no-error.
    if not avail tt-param-totalizacao then do:
        for each tt-contr-titulo-imp:
            assign p-vl-liquid     = p-vl-liquid      + tt-contr-titulo-imp.sl-liquidar-me
                   p-vl-tot-vincul = p-vl-tot-vincul  + tt-contr-titulo-imp.vl-vinculado-me
                   p-qtd-tit       = p-qtd-tit        + 1.
        end.
    end.
    else do:
        for each tt-contr-titulo-imp
            where tt-contr-titulo-imp.cod-emitente >= tt-param-totalizacao.ttv-cliente-ini
            and   tt-contr-titulo-imp.cod-emitente <= tt-param-totalizacao.ttv-cliente-fim
            and   tt-contr-titulo-imp.dt-vencimen  >= tt-param-totalizacao.ttv-vencto-ini
            and   tt-contr-titulo-imp.dt-vencimen  <= tt-param-totalizacao.ttv-vencto-fim,
            first tt-emitente 
            where tt-emitente.cod-emitente = tt-contr-titulo-imp.cod-emitente
            and tt-emitente.pais >= tt-param-totalizacao.ttv-pais-ini 
            and tt-emitente.pais <= tt-param-totalizacao.ttv-pais-fim:
                
            if tt-param-totalizacao.ttv-tit-csa-saldo = 9 then do:
                assign p-vl-liquid = p-vl-liquid + tt-contr-titulo-imp.sl-liquidar-me
                       p-qtd-tit   = p-qtd-tit   + 1.
            end.
            else do:
                if (tt-param-totalizacao.ttv-tit-csa-saldo = 0
                or (tt-param-totalizacao.ttv-tit-csa-saldo = 1 and tt-contr-titulo-imp.sl-liquidar-me > 0)
                or (tt-param-totalizacao.ttv-tit-csa-saldo = 2 and tt-contr-titulo-imp.sl-liquidar-me = 0)) then do:
                    assign p-vl-liquid     = p-vl-liquid     + tt-contr-titulo-imp.sl-liquidar-me
                           p-vl-tot-vincul = p-vl-tot-vincul + tt-contr-titulo-imp.vl-vinculado-me
                           p-qtd-tit       = p-qtd-tit       + 1.
                end.
            end.
        end.
    end.
    find first tt-contrato-imp no-error.
    IF AVAIL tt-contrato-imp THEN DO:
       if tt-contrato-imp.tp-contrato-imp = 1 then
          ASSIGN p-vl-sdo-avincul = tt-contrato-imp.vl-liquidar-me - p-vl-liquid.
       else
          ASSIGN p-vl-sdo-avincul = tt-contrato-imp.vl-contrato-me - p-vl-tot-vincul.
    END.

    ASSIGN p-vl-tot-liquidado  = p-vl-tot-vincul - p-vl-liquid.
    IF p-vl-tot-liquidado < 0 THEN
       ASSIGN p-vl-tot-liquidado = p-vl-tot-liquidado * -1.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-titulos DBOProgram 
PROCEDURE pi-valida-titulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF input  param p-ep-codigo      like contr-titulo-imp.ep-codigo.
DEF input  param p-cod-estabel    like contr-titulo-imp.cod-estabel.
def input  param p-cod-emitente   like contr-titulo-imp.cod-emitente.
def input  param p-cod-esp        like contr-titulo-imp.cod-esp.
def input  param p-serie          like contr-titulo-imp.serie.
def input  param p-nr-docto       like contr-titulo-imp.nr-docto.
def input  param p-parcela        like contr-titulo-imp.parcela.
DEF OUTPUT PARAM p-moeda LIKE tit-ap.moeda NO-UNDO.
def output param table for tt_log_erro.

define variable v-pagar as char no-undo. /* "EMS 2" ; "EMS 5" */
define variable v-receber as char no-undo. /* "EMS 2" ; "EMS 5" */
define variable h-boad355 as handle no-undo.
define variable h-apb798za as handle no-undo.
DEF VAR p-fornec-nacional  AS LOG.

run adbo/boad355.p persistent set h-boad355.
run pi-verificar-produto in h-boad355 (output v-pagar,
                                       output v-receber).
delete procedure h-boad355.

case v-pagar :
    when "EMS 5" then do: /* busca saldo orig EMS 5.0 */
        {cdp/cd1202.i3 i-ep-codigo-usuario}
        if  l-conec-bas = yes and l-conec-fin = yes and l-conec-uni = yes  then do:

            IF l-funcao-arbitragem = YES THEN
               ASSIGN p-fornec-nacional = YES.

            run prgfin/apb/apb798za.py persistent set h-apb798za.
            run pi_valida_tit_ap_integr_mec in h-apb798za (INPUT string(p-ep-codigo),
                                                           INPUT p-cod-estabel,
                                                           INPUT p-cod-emitente,
                                                           INPUT p-cod-esp,
                                                           INPUT p-serie,
                                                           INPUT p-nr-docto,
                                                           INPUT p-parcela,
                                                           OUTPUT p-moeda,
                                                           OUTPUT TABLE tt_log_erro,
                                                           INPUT p-fornec-nacional).             
            delete procedure h-apb798za.
            {cdp/cd1202.i4 i-ep-codigo-usuario} 
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
    def input  param p-ep-codigo      like contr-titulo-imp.ep-codigo.
    def input  param p-cod-estabel    like contr-titulo-imp.cod-estabel.
    def input  param p-cod-emitente   like contr-titulo-imp.cod-emitente.
    def input  param p-dt-vinculado   as date.
    def output param p-possui-antec   as logical.

    define variable v-pagar as char no-undo. /* "EMS 2" ; "EMS 5" */
    define variable v-receber as char no-undo. /* "EMS 2" ; "EMS 5" */
    define variable h-boad355 as handle no-undo.
    define variable h-apb798za as handle no-undo.

    run adbo/boad355.p persistent set h-boad355.
    run pi-verificar-produto in h-boad355 (output v-pagar,
                                           output v-receber).
    delete procedure h-boad355.

    case v-pagar :
    when "EMS 5" then do: /* busca saldo orig EMS 5.0 */

        {cdp/cd1202.i3 i-ep-codigo-usuario}
        if l-conec-bas = yes and l-conec-fin = yes and l-conec-uni = yes  then do:
            run prgfin/apb/apb798za.py persistent set h-apb798za.
            run pi_verifica_antecip in h-apb798za (input p-ep-codigo,
                                             input p-cod-estabel,
                                             input p-cod-emitente,
                                             input p-dt-vinculado,
                                             output p-possui-antec).
            delete procedure h-apb798za.
            {cdp/cd1202.i4 i-ep-codigo-usuario} 
        end.
    end.
    end case.

    RETURN "OK":U.
END PROCEDURE. /* fim pi-verifica-antecip */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vld-alt-titulo-ap DBOProgram 
PROCEDURE pi-vld-alt-titulo-ap :
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
    def output param p-sl-liquidar   as decimal no-undo.
    def output param p-nr-contrato   as char    no-undo.
    def output param p-dt-contrato   as date    no-undo.

    assign p-sl-liquidar  = 0
           p-nr-contrato  = ""
           p-dt-contrato  = ?.         
           
    for each contr-titulo-imp where contr-titulo-imp.ep-codigo    = p-ep-codigo
                              and   contr-titulo-imp.cod-emitente = p-cod-fornec
                              and   contr-titulo-imp.cod-estabel  = p-cod-estabel
                              and   contr-titulo-imp.cod-esp      = p-cod-esp
                              and   contr-titulo-imp.serie        = p-serie
                              and   contr-titulo-imp.nr-docto     = p-nr-docto
                              and   contr-titulo-imp.parcela      = p-parcela NO-LOCK:

        assign p-sl-liquidar = p-sl-liquidar + contr-titulo-imp.sl-liquidar-me.

        find first contrato-imp no-lock
             where contrato-imp.nr-contrato = contr-titulo-imp.nr-contrato
             and   contrato-imp.dt-contrato = contr-titulo-imp.dt-contrato 
             use-index contrato no-error.
        
        if contrato-imp.dt-liquidacao  <  p-dt-vencimen then
            assign p-nr-contrato  = contr-titulo-imp.nr-contrato
                   p-dt-contrato  = contr-titulo-imp.dt-contrato.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vld-cancela-titulo-ap DBOProgram 
PROCEDURE pi-vld-cancela-titulo-ap :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  parameter i-ep-codigo-n    like contr-titulo-imp.ep-codigo    no-undo.
    def input  parameter i-cod-fornec     like contr-titulo-imp.cod-emitente no-undo.
    def input  parameter c-cod-estabel-d  like contr-titulo-imp.cod-estabel  no-undo.
    def input  parameter c-cod-esp-d      like contr-titulo-imp.cod-esp      no-undo.
    def input  parameter c-serie-d        like contr-titulo-imp.serie        no-undo.
    def input  parameter c-nr-docto-d     like contr-titulo-imp.nr-docto     no-undo.
    def input  parameter c-parcela-d      like contr-titulo-imp.parcela      no-undo.
    def output parameter c-cod-estab      like contr-titulo-imp.cod-estabel   no-undo.
    def output parameter c-referencia     like contr-titulo-imp.referencia    no-undo.
    def output parameter d-dt-transacao   like contr-titulo-imp.dt-referencia no-undo.
    
    find first contr-titulo-imp no-lock
        where  contr-titulo-imp.ep-codigo     = i-ep-codigo-n
        and    contr-titulo-imp.cod-emitente  = i-cod-fornec
        and    contr-titulo-imp.cod-estabel   = c-cod-estabel-d
        and    contr-titulo-imp.cod-esp       = c-cod-esp-d
        and    contr-titulo-imp.serie         = c-serie-d
        and    contr-titulo-imp.nr-docto      = c-nr-docto-d
        and    contr-titulo-imp.parcela       = c-parcela-d 
        no-error.
               
        if avail contr-titulo-imp then
           assign c-cod-estab     = contr-titulo-imp.cod-estabel 
                  c-referencia    = contr-titulo-imp.referencia
                  d-dt-transacao  = contr-titulo-imp.dt-referencia.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vld-subst-titulo-ap DBOProgram 
PROCEDURE pi-vld-subst-titulo-ap :
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
    def output param p-cod-estabel2  as char    no-undo.
    def output param p-referencia    as char    no-undo.
    def output param p-dt-referencia as date    no-undo.

    assign p-cod-estabel2  = ""
           p-referencia = ""
           p-dt-referencia = ?.

    find first contr-titulo-imp no-lock
         where contr-titulo-imp.ep-codigo    = p-ep-codigo
           and contr-titulo-imp.cod-emitente = p-cod-fornec
           and contr-titulo-imp.cod-estabel  = p-cod-estabel
           and contr-titulo-imp.cod-esp      = p-cod-esp
           and contr-titulo-imp.serie        = p-serie
           and contr-titulo-imp.nr-docto     = p-nr-docto
           and contr-titulo-imp.parcela      = p-parcela     no-error.
    if avail contr-titulo-imp then do:
        assign p-cod-estabel2  = contr-titulo-imp.cod-estabel
               p-referencia = contr-titulo-imp.referencia
               p-dt-referencia = contr-titulo-imp.dt-referencia.    
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
    DEFINE INPUT PARAMETER pcod-estabel-ini LIKE contr-titulo-imp.cod-estabel.
    DEFINE INPUT PARAMETER pcod-estabel-fim LIKE contr-titulo-imp.cod-estabel.
    DEFINE INPUT PARAMETER pcod-fornec-ini  LIKE contr-titulo-imp.cod-emitente.
    DEFINE INPUT PARAMETER pcod-fornec-fim  LIKE contr-titulo-imp.cod-emitente.
    DEFINE INPUT PARAMETER pnr-docto-ini    LIKE contr-titulo-imp.nr-docto.
    DEFINE INPUT PARAMETER pnr-docto-fim    LIKE contr-titulo-imp.nr-docto.
    DEFINE INPUT PARAMETER pdt-vencimen-ini LIKE contr-titulo-imp.dt-vencimen.
    DEFINE INPUT PARAMETER pdt-vencimen-fim LIKE contr-titulo-imp.dt-vencimen.

    assign c-cod-estabel-ini = pcod-estabel-ini
           c-cod-estabel-fim = pcod-estabel-fim
           i-cod-fornec-ini  = pcod-fornec-ini
           i-cod-fornec-fim  = pcod-fornec-fim
           c-nr-docto-ini    = pnr-docto-ini
           c-nr-docto-fim    = pnr-docto-fim
           d-dt-vencimen-ini = pdt-vencimen-ini
           d-dt-vencimen-fim = pdt-vencimen-fim.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintContratoImp DBOProgram 
PROCEDURE setConstraintContratoImp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo     LIKE contr-titulo-imp.ep-codigo     NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel   LIKE contr-titulo-imp.cod-estabel   NO-UNDO.
    DEFINE INPUT PARAMETER preferencia    LIKE contr-titulo-imp.referencia    NO-UNDO.
    DEFINE INPUT PARAMETER pdt-referencia LIKE contr-titulo-imp.dt-referencia NO-UNDO.
    
    assign i-ep-codigo     = pep-codigo
           c-cod-estabel   = pcod-estabel
           c-referencia    = preferencia
           d-dt-referencia = pdt-referencia.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintContratoImp2 DBOProgram 
PROCEDURE setConstraintContratoImp2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE inPUT PARAMETER pnr-contrato  LIKE contr-titulo-imp.nr-contrato  NO-UNDO.
    DEFINE inPUT PARAMETER pdt-contrato  LIKE contr-titulo-imp.dt-contrato  NO-UNDO.
    
    assign c-nr-contrato   = pnr-contrato  
           d-dt-contrato   = pdt-contrato  .

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintContratoImp3 DBOProgram 
PROCEDURE setConstraintContratoImp3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE inPUT PARAMETER pnr-contrato  LIKE contr-titulo-imp.nr-contrato  NO-UNDO.
    DEFINE inPUT PARAMETER pdt-contrato  LIKE contr-titulo-imp.dt-contrato  NO-UNDO.
    
    assign c-nr-contrato   = pnr-contrato  
           d-dt-contrato   = pdt-contrato  .

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
    def var soma        as dec  no-undo.
    def var i-moeda     as int  no-undo.
    def var c-desc-erro as char no-undo.
    def var c-string1 as char no-undo.

    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/

    run emptyRowErrors in this-procedure.

    run pi-autenticacao.

    if pType = "Update":U then do:
&IF "{&mguni_version}" >= "2.07A" &THEN
        if RowObject.ep-codigo = "" then do:
&ELSE
        if RowObject.ep-codigo = 0 then do:
&ENDIF
           find contrato-imp where 
                contrato-imp.ep-codigo     = i-ep-codigo   and 
                contrato-imp.cod-estabel   = c-cod-estabel and 
                contrato-imp.referencia    = c-referencia  and 
                contrato-imp.dt-referencia = d-dt-referencia no-lock no-error.
           if not avail contrato-imp then do:
              {method/svc/errors/inserr.i
                          &ErrorNumber="19335"
                          &ErrorType="EMS"
                          &ErrorParameters="''"}  /* N∆o existe contrato criado para vincular o t°tulo */
           end.
        end.   

/*        find contrato-imp where 
             contrato-imp.ep-codigo     = RowObject.ep-codigo   and 
             contrato-imp.cod-estabel   = RowObject.cod-estabel and 
             contrato-imp.referencia    = RowObject.referencia  and 
             contrato-imp.dt-referencia = RowObject.dt-referencia no-lock no-error. */
        find contrato-imp where 
             contrato-imp.nr-contrato  = RowObject.nr-contrato and
             contrato-imp.dt-contrato  = RowObject.dt-contrato no-lock no-error.

        if not avail contrato-imp then do:
           {method/svc/errors/inserr.i
                       &ErrorNumber="19335"
                       &ErrorType="EMS"
                       &ErrorParameters="''"}  /* N∆o existe contrato criado para vincular o t°tulo */
        end.
    end.
 
    if pType = "Create":U then do:
       if can-find(first contr-titulo-imp where contr-titulo-imp.ep-codigo     = RowObject.ep-codigo  /* Verifica ocorrància de chave duplicada */
                                            and contr-titulo-imp.cod-estabel   = RowObject.cod-estabel
                                            and contr-titulo-imp.referencia    = RowObject.referencia
                                            and contr-titulo-imp.dt-referencia = RowObject.dt-referencia
                                            and contr-titulo-imp.cod-emitente  = RowObject.cod-emitente
                                            and contr-titulo-imp.cod-esp       = RowObject.cod-esp
                                            and contr-titulo-imp.serie         = RowObject.serie
                                            and contr-titulo-imp.nr-docto      = RowObject.nr-docto
                                            and contr-titulo-imp.parcela       = RowObject.parcela) then do:
          {utp/ut-liter.i T°tulo *}
          assign c-string1 = return-value.

          {method/svc/errors/inserr.i
                      &ErrorNumber="7"
                      &ErrorType="EMS"
                      &ErrorParameters="c-string1"}  /* T°tulo j† cadastrado */
       end.


    end.

    if pType = "Update":U then do:
       if avail contrato-imp and
          contrato-imp.tp-contrato-imp <> 2 and
          contrato-imp.situacao = 3 then do:  /* Liquidado */
          {method/svc/errors/inserr.i
                     &ErrorNumber="19334"
                     &ErrorType="EMS"
                     &ErrorParameters="''"}
       end.
    end.

    if pType = "Create":U or 
       pType = "Update":U then do:
    
       if RowObject.vl-vinculado-me = 0 then
          {method/svc/errors/inserr.i
                      &ErrorNumber="309"
                      &ErrorType="EMS"
                      &ErrorParameters="''"}

       if avail contrato-imp                                  and
          contrato-imp.situacao <> 1   then do:
          
           /* FO 929018
          RowObject.dt-vencimen  > contrato-imp.dt-liquidacao then do:
          assign c-desc-erro = string(contrato-imp.dt-liquidacao,"99/99/9999") + "~~" +
                               string(RowObject.dt-vencimen,"99/99/9999")      + "~~" +
                               string(RowObject.ep-codigo)                     + "~~" +
                               RowObject.cod-est                               + "~~" +
                               RowObject.cod-esp                               + "~~" +
                               RowObject.serie                                 + "~~" +
                               RowObject.nr-docto                              + "~~" +
                               RowObject.parcela.
          {method/svc/errors/inserr.i
                      &ErrorNumber="25059"
                      &ErrorType="EMS"
                      &ErrorParameters="c-desc-erro"} 
          */

          if contrato-imp.tp-contrato-imp <> 2 then do:  /* Se n∆o for Antecipaá∆o */
              find first espec-ap
                   where espec-ap.cod-esp = RowObject.cod-esp no-lock no-error.
              if avail espec-ap then do:
                  if espec-ap.tipo <> 1 then do:
                      {method/svc/errors/inserr.i
                                  &ErrorNumber="276"
                                  &ErrorType="EMS"
                                  &ErrorParameters="''"}  /* EspÇcie Inv†lida */
                  end.
              end.
          end.
       end.

    end.

    if pType = "Delete":U then do:
       if avail contrato-imp                                    and
          contrato-imp.tp-contrato-imp  <> 2                        and
          RowObject.vl-vinculado-me <> RowObject.sl-liquidar-me then do:
          {method/svc/errors/inserr.i
                      &ErrorNumber="19337"
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


