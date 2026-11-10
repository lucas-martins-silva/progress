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
{include/i-prgvrs.i BOAD341 2.00.00.058 } /*** "010058" 10/06/2025 09:30:37 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad341 MUT}
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
&GLOBAL-DEFINE DBOName              BOAD341
&GLOBAL-DEFINE DBOVersion           1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName            contrato-imp
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName            qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{adbo/boad341.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Include com definaá∆o do Serviáo de Autenticaá∆o---*/
{method/svc/autentic/autentic.i}

/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var c-cod-estabel-ini   like contrato-imp.cod-estabel.
def var c-cod-estabel-fim   like contrato-imp.cod-estabel.
def var c-referencia-ini    like contrato-imp.referencia.
def var c-referencia-fim    like contrato-imp.referencia.
def var d-dt-referencia-ini like contrato-imp.dt-referencia.
def var d-dt-referencia-fim like contrato-imp.dt-referencia.
def var c-nr-contrato-ini   like contrato-imp.nr-contrato.
def var c-nr-contrato-fim   like contrato-imp.nr-contrato.
def var d-dt-contrato-ini   like contrato-imp.dt-contrato.
def var d-dt-contrato-fim   like contrato-imp.dt-contrato.
def var i-num-id            as integer no-undo.
def var c-desc-erro         as char    no-undo.
def var c-cod-event         as char    no-undo.
DEF VAR c-rowid-contrato-imp AS ROWID.

/*** vari†veis para o LinkToTit-ap ***/
def var i-ep-codigo     like contr-titulo-imp.ep-codigo     no-undo.
def var c-cod-estabel   like contr-titulo-imp.cod-estabel   no-undo.
def var c-referencia    like contr-titulo-imp.referencia    no-undo.
def var d-dt-referencia like contr-titulo-imp.dt-referencia no-undo.

def temp-table tt-contrato-imp like contrato-imp
    field r-rowid as rowid.

def temp-table tt_campos_mec no-undo
    field ttv_cod_estab_ext    as character format "x(3)"       label "Estabelecimento"    column-label "Estabelecimento"
    field ttv_cod_empresa_ext  as character format "x(3)"       label "C¢digo Empresa Ext" column-label "C¢d Emp Ext"
    field ttv_cod_contrat_2    as character format "x(15)"      label "Nr Contrato"        column-label "Nr Contr"
    field ttv_dat_contrat      as date      format "99/99/9999" label "Dt Contrato"        column-label "Dt Contr"
    field ttv_cod_refer        as character format "x(10)"      label "Referància"         column-label "Referància"
    field ttv_dat_refer        as date      format "99/99/9999" label "Data Referància"    column-label "Data Refer"
    field tta_cod_modul_integr as character format "x(3)"       label "M¢dulo Integracao"  column-label "M¢dulo Integracao".

def temp-table tt_chave_tit_apb no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_emitente                 as integer   format ">>>>>>>>9" label "Fornecedor" column-label "Fornec"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_num_contrat_id_cambio        as integer   format "999999999".

def temp-table tt_log_erros_aed no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "SequÍncia" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N˙mero"
    field ttv_des_erro_aed                 as character format "x(225)" label "InconsistÍncia" column-label "InconsistÍncia"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda"
    index tt_id                           
          ttv_num_seq                      ascending
          ttv_num_cod_erro                 ascending
    .

def var vl-tit-vinculados as decimal no-undo.
def var vl-tot-contrato-imp as decimal no-undo.

def var c-ep-codigo               like contr-titulo-imp.ep-codigo.
def var i-seq-erro                as integer                 no-undo.
def var hshowmsg                  as handle                  no-undo.
def var v-cod-matriz-trad-org-ext as char                    no-undo.
DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR NO-UNDO.
def var l-param-apf as logical no-undo.
def var h-apb919za  as handle  no-undo.
def var h-boad355   as handle  no-undo.
def var v-pagar     as character no-undo.
def var v-receber   as character no-undo.
DEF VAR l-param-proces-pagto AS LOGICAL NO-UNDO.

DEF NEW GLOBAL SHARED VAR l-del-mla AS LOGICAL NO-UNDO.

/*** temp-tables antecipacao ***/
{app/apapi022a.i}
{app/apapi003a.i}
{adbo/boad341.i2}
{cdp/cd1202.i5}
{btb/btb009za.i}

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
         HEIGHT             = 4.04
         WIDTH              = 36.86.
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
&IF  "{&mgadm_version}" >= "2.06B" &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDeleteRecord DBOProgram 
PROCEDURE AfterDeleteRecord :


END PROCEDURE.

&ENDIF

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforecreateRecord DBOProgram 
PROCEDURE beforecreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
    if RowObject.tp-contrato-imp = 2 THEN DO: /* Antecipaá∆o */
		def var v-ep-codigo like tt-contrato-imp.ep-codigo.
		
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

        IF l-param-apf THEN DO:
            ASSIGN RowObject.situacao          = 6. /* "Pendente Aprovaá∆o". */
        END.
        ELSE DO:
        &ENDIF
            assign RowObject.vl-liquidar-me  = 0
              RowObject.vl-liquidado-me = RowObject.vl-contrato-me
              RowObject.situacao          = 3. /* "Liquidado". */
        &IF  "{&mgadm_version}" >= "2.06B" &THEN
        END.
        &ENDIF
    END.
    
    if RowObject.tp-contrato-imp = 1 then do: /* Pronto */
       assign RowObject.vl-liquidar-me = RowObject.vl-contrato-me.
          
       if RowObject.situacao = 3 then /* "Liquidado" */
          {method/svc/errors/inserr.i
                    &ErrorNumber="19420"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}  /* Contrato n∆o pode ser liquidado */
    end.
    
    assign i-num-id = 0.
    for each contrato-imp no-lock
        by contrato-imp.num-id-contrato-imp  desc:
        if contrato-imp.num-id-contrato-imp > i-num-id then do:
           assign i-num-id = contrato-imp.num-id-contrato-imp.      
           leave.
        end.
    end.
    assign RowObject.num-id-contrato-imp = i-num-id + 1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
	&IF  "{&mgadm_version}" >= "2.06B" &THEN
    
	IF l-del-mla = NO THEN DO:
		
        ASSIGN c-rowid-contrato-imp = RowObject.r-Rowid.
		run afp/af0124.p (input 3, 
						  input 25,
						  input c-rowid-contrato-imp, /* rowed da tabela do cambio */
						  output table tt_log_erros_aed).
	END.					  
    &ENDIF
    
    for each contr-docto-imp of RowObject exclusive-lock:
        delete contr-docto-imp.
    end.
    for each contr-hist-imp of RowObject exclusive-lock:
        delete contr-hist-imp.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeupdateRecord DBOProgram 
PROCEDURE beforeupdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if contrato-imp.nr-contrato <> RowObject.nr-contrato or
       contrato-imp.dt-contrato <> RowObject.dt-contrato
    then do:
        for each contr-titulo-imp of RowObject exclusive-lock:
           assign contr-titulo-imp.nr-contrato = RowObject.nr-contrato
                  contr-titulo-imp.dt-contrato = RowObject.dt-contrato.
        end.
        for each contr-docto-imp of RowObject exclusive-lock:
           assign contr-docto-imp.nr-contrato = RowObject.nr-contrato
                  contr-docto-imp.dt-contrato = RowObject.dt-contrato.
        end.
        for each contr-despesa-imp of RowObject exclusive-lock:
           assign contr-despesa-imp.nr-contrato = RowObject.nr-contrato
                  contr-despesa-imp.dt-contrato = RowObject.dt-contrato.
        end.
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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-oper-cambio":U THEN ASSIGN pFieldValue = RowObject.cod-oper-cambio.
        WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cotacao-dia":U THEN ASSIGN pFieldValue = RowObject.cotacao-dia.
        WHEN "vl-liquidado-me":U THEN ASSIGN pFieldValue = RowObject.vl-liquidado-me.
        WHEN "vl-liquidar-me":U THEN ASSIGN pFieldValue = RowObject.vl-liquidar-me.
        WHEN "vl-contrato":U THEN ASSIGN pFieldValue = RowObject.vl-contrato.
        WHEN "vl-contrato-me":U THEN ASSIGN pFieldValue = RowObject.vl-contrato-me.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetDescConta DBOProgram 
PROCEDURE GetDescConta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param  i-cod-port   like portador.cod-portador        no-undo.
   def input param  i-modalidade like portador.modalidade      no-undo.
   def output param p-moeda      like portador.mo-codigo       no-undo.
   def output param c-conta      like cta-corrente.conta-saldo no-undo.

   def var v-ep-codigo like tt-contrato-imp.ep-codigo.
   run pi-busca-empresa (output v-ep-codigo).

   assign p-moeda = 99
          c-conta = "".

   find portador where portador.ep-codigo  = v-ep-codigo
                 and   portador.cod-portador   = i-cod-port 
                 and   portador.modalidade = i-modalidade 
                 no-lock no-error.
   if avail portador then do:
      find cta-corrente 
           where cta-corrente.cod-banco = portador.cod-banco and
                 cta-corrente.agencia = portador.agencia and
                 cta-corrente.conta-corren = portador.conta-corren no-lock no-error.
      if avail cta-corrente then
         assign p-moeda = portador.mo-codigo
                c-conta = cta-corrente.conta-saldo.
   end.

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

   run pi-busca-empresa (output i-ep-codigo).

   case c-table:
      when "banco":u then do:
         find banco where banco.cod-banco = int(c-param) no-lock no-error.
         if avail banco then
            assign c-description = banco.nome-banco.
         else
            assign c-description = "".
      end.
      when "moeda":u then do:
         find moeda where moeda.mo-codigo = int(c-param) no-lock no-error.
         if avail moeda then
            assign c-description = moeda.descricao.
         else
            assign c-description = "".
      end.
      when "cotacao":u then do:
         def var d-day as date no-undo.
         assign d-day = date(entry(3, c-param, chr(10))).
         find cotacao where cotacao.mo-codigo   = int(entry(1, c-param, chr(10)))
                      and   cotacao.ano-periodo = entry(2, c-param, chr(10)) no-lock no-error.
         if avail cotacao then
            assign c-description = string(cotacao.cotacao[day(d-day)]).
         else
            assign c-description = "".
      end.
      when "forma-pgto-mec":u then do:
         find forma-pgto-mec where forma-pgto-mec.cod-forma-pgto-mec = c-param no-lock no-error.
         if avail forma-pgto-mec then
            assign c-description = forma-pgto-mec.descricao.
         else
            assign c-description = "".
      end.
      when "operac-cambio":u then do:
         find operac-cambio where operac-cambio.cod-oper-cambio = c-param no-lock no-error.
         if avail operac-cambio then
            assign c-description = operac-cambio.nome.
         else
            assign c-description = "".
      end.
      when "emitente":u then do:
         find emitente where 
              emitente.cod-emitente = int(c-param) and
              emitente.identific   <> 1 no-lock no-error.
         if avail emitente then
            assign c-description = emitente.nome-emit.
         else
            assign c-description = "".
      end.
      when "emitente2":u then do:
         find emitente where 
              emitente.cod-emitente = int(c-param) and
              emitente.identific   <> 1 no-lock no-error.
         if avail emitente then
            assign c-description = emitente.nome-abrev.
         else
            assign c-description = "".
      end.
      when "identific":u then do:
         find emitente where 
              emitente.cod-emitente = int(c-param) no-lock no-error.
         if avail emitente then
            assign c-description = string(emitente.identific).
         else
            assign c-description = "".
      end.
      when "natureza":U then do:
         find emitente where 
              emitente.cod-emitente = int(c-param) and
              emitente.identific   <> 1 no-lock no-error.
         if avail emitente then
            assign c-description = string(emitente.natureza).
         else
            assign c-description = "".
      end.
      when "portador":u then do:
         find portador where portador.ep-codigo  = i-ep-codigo
                       and   portador.cod-portador   = int(entry(1, c-param, chr(10)))
                       and   portador.modalidade = int(entry(2, c-param, chr(10))) 
                       no-lock no-error.
         if avail portador then 
            assign c-description = portador.nome.
         else
            assign c-description = "".
      end.
      when "tipo-rec-desp":u then do:
         find tipo-rec-desp where tipo-rec-desp.tp-codigo = int(c-param) no-lock no-error.
         if avail tipo-rec-desp then 
            assign c-description = tipo-rec-desp.descricao.
         else
            assign c-description = "".
      end.
      when "tipo-esp":u then do:
         find espec-ap where espec-ap.cod-esp = trim(c-param) no-lock no-error.
         if avail espec-ap then 
            assign c-description = string(espec-ap.tipo).
         else
            assign c-description = "".
      end.
      when "documento":U then do:
          find first tipo-docto where tipo-docto.cod-docto = c-param no-lock no-error.
          if avail tipo-docto then
              assign c-description = tipo-docto.descricao.
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
   end.
   return "OK":U.
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
        WHEN "cod-corretor":U THEN ASSIGN pFieldValue = RowObject.cod-corretor.
        WHEN "cod-vendedor":U THEN ASSIGN pFieldValue = RowObject.cod-vendedor.
        &IF "{&mguni_version}" < "2.07A" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "moeda":U THEN ASSIGN pFieldValue = RowObject.moeda.
        WHEN "nr-dias-entr-docto":U THEN ASSIGN pFieldValue = RowObject.nr-dias-entr-docto.
        WHEN "nr-dias-liquidacao":U THEN ASSIGN pFieldValue = RowObject.nr-dias-liquidacao.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        WHEN "tp-contrato-imp":U THEN ASSIGN pFieldValue = RowObject.tp-contrato-imp.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo     LIKE contrato-imp.ep-codigo     NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel   LIKE contrato-imp.cod-estabel   NO-UNDO.
    DEFINE OUTPUT PARAMETER preferencia    LIKE contrato-imp.referencia    NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-referencia LIKE contrato-imp.dt-referencia NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey2 DBOProgram 
PROCEDURE getKey2 :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice referencia
  Parameters:  
               retorna valor do campo nr-contrato
               retorna valor do campo dt-contrato
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-contrato   LIKE contrato-imp.nr-contrato  NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-contrato LIKE contrato-imp.dt-contrato  NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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
  Purpose:     Reposiciona registro com base no °ndice referencia
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo referencia
               recebe valor do campo dt-referencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE contrato-imp.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE contrato-imp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER preferencia LIKE contrato-imp.referencia NO-UNDO.
    DEFINE INPUT PARAMETER pdt-referencia LIKE contrato-imp.dt-referencia NO-UNDO.

    FIND FIRST bfcontrato-imp WHERE 
        bfcontrato-imp.ep-codigo = pep-codigo AND
        bfcontrato-imp.cod-estabel = pcod-estabel AND 
        bfcontrato-imp.referencia = preferencia AND 
        bfcontrato-imp.dt-referencia = pdt-referencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcontrato-imp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcontrato-imp)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey2 DBOProgram 
PROCEDURE goToKey2 :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice contrato
  Parameters:  
               recebe valor do campo nr-contrato
               recebe valor do campo dt-contrato
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-contrato LIKE contrato-imp.nr-contrato NO-UNDO.
    DEFINE INPUT PARAMETER pdt-contrato LIKE contrato-imp.dt-contrato NO-UNDO.

    FIND FIRST bfcontrato-imp NO-LOCK
         WHERE bfcontrato-imp.nr-contrato = pnr-contrato
           AND bfcontrato-imp.dt-contrato = pdt-contrato NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcontrato-imp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcontrato-imp)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey3 DBOProgram 
PROCEDURE goToKey3 :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice contrato
  Parameters:  
               recebe valor do campo nr-contrato
               recebe valor do campo dt-contrato
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-contrato LIKE contrato-imp.nr-contrato NO-UNDO.

    FIND FIRST bfcontrato-imp NO-LOCK
         WHERE bfcontrato-imp.nr-contrato = pnr-contrato NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcontrato-imp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcontrato-imp)).
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
   def input param h-boad260o as handle no-undo.

    run setConstraintMain in this-procedure.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryContrato DBOProgram 
PROCEDURE openQueryContrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
         WHERE (contrato-imp.nr-contrato >= c-nr-contrato-ini and
                contrato-imp.nr-contrato <= c-nr-contrato-fim)
           and (contrato-imp.dt-contrato >= d-dt-contrato-ini and
                contrato-imp.dt-contrato <= d-dt-contrato-fim)
         by contrato-imp.nr-contrato
         by contrato-imp.dt-contrato.
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
         WHERE (contrato-imp.nr-contrato >= c-nr-contrato-ini and
                contrato-imp.nr-contrato <= c-nr-contrato-fim)
           and (contrato-imp.dt-contrato >= d-dt-contrato-ini and
                contrato-imp.dt-contrato <= d-dt-contrato-fim)
           and  contrato-imp.vl-liquidar-me > 0
           and  contrato-imp.situacao = 2
         by contrato-imp.nr-contrato.

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
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryReferencia DBOProgram 
PROCEDURE openQueryReferencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if c-cod-estabel-ini = c-cod-estabel-fim then
        OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
             WHERE (contrato-imp.cod-estabel    = c-cod-estabel-ini)
               and (contrato-imp.referencia    >= c-referencia-ini    and
                    contrato-imp.referencia    <= c-referencia-fim)
               and (contrato-imp.dt-referencia >= d-dt-referencia-ini and
                    contrato-imp.dt-referencia <= d-dt-referencia-fim)
             by contrato-imp.cod-estabel
             by contrato-imp.referencia
             by contrato-imp.dt-referencia.
    else
        OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
             WHERE (contrato-imp.cod-estabel   >= c-cod-estabel-ini   and
                    contrato-imp.cod-estabel   <= c-cod-estabel-fim)
               and (contrato-imp.referencia    >= c-referencia-ini    and
                    contrato-imp.referencia    <= c-referencia-fim)
               and (contrato-imp.dt-referencia >= d-dt-referencia-ini and
                    contrato-imp.dt-referencia <= d-dt-referencia-fim)
             by contrato-imp.cod-estabel
             by contrato-imp.referencia
             by contrato-imp.dt-referencia.
             
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
             WHERE (contrato-imp.cod-estabel    = c-cod-estabel-ini)
               and (contrato-imp.referencia    >= c-referencia-ini and
                    contrato-imp.referencia    <= c-referencia-fim)
               and (contrato-imp.dt-referencia >= d-dt-referencia-ini and
                    contrato-imp.dt-referencia <= d-dt-referencia-fim)
               and  contrato-imp.vl-liquidar-me > 0
               and  contrato-imp.situacao = 2
             by contrato-imp.cod-estabel.    
    else
        OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
             WHERE (contrato-imp.cod-estabel   >= c-cod-estabel-ini and
                    contrato-imp.cod-estabel   <= c-cod-estabel-fim)
               and (contrato-imp.referencia    >= c-referencia-ini and
                    contrato-imp.referencia    <= c-referencia-fim)
               and (contrato-imp.dt-referencia >= d-dt-referencia-ini and
                    contrato-imp.dt-referencia <= d-dt-referencia-fim)
               and  contrato-imp.vl-liquidar-me > 0
               and  contrato-imp.situacao = 2
             by contrato-imp.cod-estabel.

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
               contrato-imp.situacao       = 2.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-acerto-vl-contrato-imp DBOProgram 
PROCEDURE pi-acerto-vl-contrato-imp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-ep-codigo     like contrato-imp.ep-codigo     no-undo.    
    def input param p-cod-estabel   like contrato-imp.cod-estabel   no-undo.
    def input param p-referencia    like contrato-imp.referencia    no-undo.   
    def input param p-dt-referencia like contrato-imp.dt-referencia no-undo.
    def buffer b-contrato-imp for contrato-imp.
    def var vl-total-compl-movto as dec format "->>,>>>,>>>,>>9.99":U decimals 2 no-undo.
    def var h-apb919za1          as handle  no-undo.

    find first b-contrato-imp no-lock
         where b-contrato-imp.ep-codigo     = p-ep-codigo    
         and   b-contrato-imp.cod-estabel   = p-cod-estabel  
         and   b-contrato-imp.referencia    = p-referencia   
         and   b-contrato-imp.dt-referencia = p-dt-referencia no-error.
    if avail b-contrato-imp
    and b-contrato-imp.situacao = 3 /*Liquidado*/ then do:
        for each contr-titulo-imp no-lock
            where contr-titulo-imp.nr-contrato = b-contrato-imp.nr-contrato
            and   contr-titulo-imp.dt-contrato = b-contrato-imp.dt-contrato:
            
            create tt_chave_tit_apb.
            assign tt_chave_tit_apb.tta_num_contrat_id_cambio = b-contrato-imp.num-id-contrato-imp
                   tt_chave_tit_apb.tta_cod_empresa           = string(contr-titulo-imp.ep-codigo)
                   tt_chave_tit_apb.tta_cod_estab             = contr-titulo-imp.cod-estabel
                   tt_chave_tit_apb.tta_cod_emitente          = contr-titulo-imp.cod-emitente
                   tt_chave_tit_apb.tta_cod_espec_docto       = contr-titulo-imp.cod-esp
                   tt_chave_tit_apb.tta_cod_ser_docto         = contr-titulo-imp.serie
                   tt_chave_tit_apb.tta_cod_tit_ap            = contr-titulo-imp.nr-docto
                   tt_chave_tit_apb.tta_cod_parcela           = contr-titulo-imp.parcela.
            
        end.
        
        if not valid-handle(h-apb919za1) then
            run prgfin/apb/apb919za.py persistent set h-apb919za1(input 1).

        run pi_totalizar_compl_movto_pagto in h-apb919za1(input table tt_chave_tit_apb,
                                                          output vl-total-compl-movto).
        delete procedure h-apb919za1.

        if  vl-total-compl-movto <> 0 
        and vl-total-compl-movto <> b-contrato-imp.vl-contrato then do:
            find first contrato-imp exclusive-lock
                 where contrato-imp.ep-codigo     = b-contrato-imp.ep-codigo    
                 and   contrato-imp.cod-estabel   = b-contrato-imp.cod-estabel  
                 and   contrato-imp.referencia    = b-contrato-imp.referencia   
                 and   contrato-imp.dt-referencia = b-contrato-imp.dt-referencia no-error.
            if avail contrato-imp then
                assign contrato-imp.vl-contrato = vl-total-compl-movto.
        end.
    end.
    return "OK":U.
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
    def input param p-vl-baixa        as decimal no-undo.
    def input param p-nr-contrato     as char    no-undo.
    def input param p-dt-contrato     as date    no-undo.
    def buffer bf-contrato-imp      for contrato-imp.

    find bf-contrato-imp
         where bf-contrato-imp.nr-contrato = p-nr-contrato
           and bf-contrato-imp.dt-contrato = p-dt-contrato exclusive-lock no-error.

    if  avail bf-contrato-imp then do:
        assign bf-contrato-imp.vl-liquidar-me  = bf-contrato-imp.vl-liquidar-me  - p-vl-baixa
               bf-contrato-imp.vl-liquidado-me = bf-contrato-imp.vl-liquidado-me + p-vl-baixa.
        
        if bf-contrato-imp.situacao = 3 then do:
            assign bf-contrato-imp.situacao = 2.
        end.
        
        if bf-contrato-imp.vl-liquidado-me = bf-contrato-imp.vl-contrato-me then do:
            assign bf-contrato-imp.situacao = 3.
        end.
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
    def var i-ep-codigo like contrato-imp.ep-codigo.
    def var c-usuario   like contrato-imp.usuario.
    
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
DEF INPUT  param p-log-cheque   as log     no-undo.
DEF INPUT  param p-produto      as char    no-undo.
DEF INPUT  param p-talonario    as int     no-undo.
DEF INPUT  param table for tt-doc-b-ap.
DEF INPUT  param table for tt-lin-b-ap.
DEF INPUT  param table for tt-l-ant-ap.
DEF INPUT  param table for tt-l-pre-ap.
DEF INPUT  param table for tt-impto-tit-pend-ap.
DEF OUTPUT param table for tt-retorno-lin-b-ap.
def input-output param p_num_bord as integer format ">>>>>9" no-undo.

def var i-ep-codigo like contrato-imp.ep-codigo.
def var c-usuario   like contrato-imp.usuario.
def var v_cod_msg_ini as char     format "x(2)":U  no-undo.
def var v_cod_msg_fim as char     format "x(2)":U  no-undo.
DEF VAR c-cod-erro         AS CHAR                 NO-UNDO.
DEF VAR c-perm-preparador  AS CHAR                 NO-UNDO.
DEF VAR c-perm-liberador   AS CHAR                 NO-UNDO.
DEF VAR c-perm-todos       AS CHAR                 NO-UNDO.
&IF "{&mguni_version}" >= "2.07A" &THEN
def var v_cod_estab_bord   as char format "x(05)":U no-undo.
&ELSE
def var v_cod_estab_bord   as char format "x(3)":U no-undo.
&ENDIF
def var v_cod_portad_bord  as char format "x(5)":U no-undo.

def var h-apb919za  as handle  no-undo.

DEF VAR vl-tot-contrato-imp-aux AS DECIMAL NO-UNDO.
ASSIGN vl-tot-contrato-imp-aux = 0.

if  p-produto = "EMS 5" then do:

    FOR EACH tt-retorno-lin-b-ap:
        DELETE tt-retorno-lin-b-ap.
    END.
    
    for each tt_log_erros:
        delete tt_log_erros.
    end.
    {method/svc/autentic/autentic.i
          &vUserEnterprise="i-ep-codigo"
          &vUserName="c-usuario"}
    
    run prgint/ufn/ufn908za.py (input  1,
                                input  18,
                                output v-cod-matriz-trad-org-ext).
    
    if  v-cod-matriz-trad-org-ext = '' then do:
        run utp/ut-msgs.p (input "help",
                           input 27792,
                           input "").
        create tt-retorno-lin-b-ap.
        assign tt-retorno-lin-b-ap.desc-erro  = trim(return-value)
               tt-retorno-lin-b-ap.cod-erro   = "27792":U
               tt-retorno-lin-b-ap.situacao   = no
               tt-retorno-lin-b-ap.cod-chave  = "".
        
        return "NOK":U.
    end.
    
    for each RowErrors:                     delete RowErrors.                     end.
    for each tt-retorno-lin-b-ap:           delete tt-retorno-lin-b-ap.           end.
    for each tt_integr_apb_pagto:           delete tt_integr_apb_pagto.           end.
    for each tt_integr_apb_bord_lote_pagto: delete tt_integr_apb_bord_lote_pagto. end.
    for each tt_integr_cambio_ems5:         delete tt_integr_cambio_ems5.         end.
    
    run prgfin/apb/apb919za.py persistent set h-apb919za (input 1).
    
        
    FIND FIRST tt-doc-b-ap NO-LOCK NO-ERROR.
    IF  AVAIL tt-doc-b-ap THEN DO:
        run pi_validar_usuar_estab_apb_mec IN h-apb919za (INPUT tt-doc-b-ap.ep-codigo,
                                                          INPUT tt-doc-b-ap.cod-estabel,
                                                          OUTPUT c-cod-erro,
                                                          OUTPUT TABLE tt_log_erro).
         
         IF  CAN-FIND(FIRST tt_log_erro) THEN DO:
             FOR EACH tt_log_erro:
                 create tt-retorno-lin-b-ap.
                 assign tt-retorno-lin-b-ap.cod-erro   = STRING(tt_log_erro.ttv_num_cod_erro)
                        tt-retorno-lin-b-ap.situacao   = no
                        tt-retorno-lin-b-ap.cod-chave  = "".
                 if  tt_log_erro.ttv_des_msg_ajuda = '' then
                     assign tt-retorno-lin-b-ap.desc-erro = tt_log_erro.ttv_des_msg_erro.
                 else
                     assign tt-retorno-lin-b-ap.desc-erro = tt_log_erro.ttv_des_msg_ajuda.
             end.
             return "NOK":U.
         end.
         
         IF c-cod-erro = "602" AND
            (ENTRY(1,c-cod-erro,",") = "no"
             AND ENTRY(2,c-cod-erro,",") = "no"
             AND ENTRY(3,c-cod-erro,",") = "no"
             AND ENTRY(4,c-cod-erro,",") = "no") THEN DO:
             run utp/ut-msgs.p (input "help",
                input 18728,
                input "").
             create tt-retorno-lin-b-ap.
             assign tt-retorno-lin-b-ap.desc-erro  = trim(return-value)
                    tt-retorno-lin-b-ap.cod-erro   = "18728":U
                    tt-retorno-lin-b-ap.situacao   = no
                    tt-retorno-lin-b-ap.cod-chave  = "".
             return "NOK":U.
         END.
         ELSE DO:
              IF  ENTRY(2,c-cod-erro,",") = "no" THEN DO:
                  run utp/ut-msgs.p (input "help",
                     input 2015,
                     input "").
                  create tt-retorno-lin-b-ap.
                  assign tt-retorno-lin-b-ap.desc-erro  = trim(return-value)
                         tt-retorno-lin-b-ap.cod-erro   = "2015":U
                         tt-retorno-lin-b-ap.situacao   = no
                         tt-retorno-lin-b-ap.cod-chave  = "".
                  return "NOK":U.
              END.
              ELSE DO:
                 ASSIGN c-perm-preparador = "no"
                        c-perm-liberador  = "no"  
                        c-perm-todos      = "no".
                 IF  NUM-ENTRIES(c-cod-erro) > 3 THEN DO:
                     IF ENTRY(2,c-cod-erro,",") = "yes" THEN
                        ASSIGN c-perm-preparador = "yes".
    
                     IF  ENTRY(2,c-cod-erro,",") = "yes" AND
                         ENTRY(3,c-cod-erro,",") = "yes" THEN
                        ASSIGN c-perm-liberador = "yes".
             
                     IF (ENTRY(2,c-cod-erro,",") = "yes"
                        AND ENTRY(3,c-cod-erro,",") = "yes"
                        AND ENTRY(4,c-cod-erro,",") = "yes") THEN
                            ASSIGN c-perm-todos = "yes".
                 END.
             END.
         END.
    END.
    IF c-perm-todos = "yes" THEN DO:
        for each tt-doc-b-ap no-lock:
            create tt_integr_apb_pagto.
            assign tt_integr_apb_pagto.tta_cod_empresa              = string(tt-doc-b-ap.ep-codigo)
                   tt_integr_apb_pagto.tta_cod_refer                = tt-doc-b-ap.referencia
                   tt_integr_apb_pagto.tta_dat_transacao            = tt-doc-b-ap.data-movto
                   tt_integr_apb_pagto.tta_val_tot_lote_pagto_efetd = 0
                   tt_integr_apb_pagto.tta_val_tot_lote_pagto_infor = 0
                   tt_integr_apb_pagto.tta_cod_usuar_pagto          = c-usuario
                   tt_integr_apb_pagto.ttv_rec_table_parent         = &IF {&ROWID_READY} = YES &THEN ROWID(tt_integr_apb_pagto) &ELSE RECID(tt_integr_apb_pagto) &ENDIF
                   tt_integr_apb_pagto.tta_cod_estab_ext            = tt-doc-b-ap.cod-estabel
                   tt_integr_apb_pagto.tta_cod_finalid_econ_ext     = '0'
                   tt_integr_apb_pagto.tta_cod_livre_1              = "no".
            IF p-log-cheque = no then do:              
               find first tt-lin-b-ap no-lock no-error.
               if p_num_bord = 0 then do:
                   run pi_busca_num_bordero_1 in h-apb919za (input  string(tt-lin-b-ap.ep-codigo),
                                                             input  tt-lin-b-ap.estabel-mec,
                                                             input  string(tt-lin-b-ap.portador),
                                                             input  '1',
                                                             output p_num_bord,
                                                             output v_cod_msg_ini,
                                                             output v_cod_msg_fim,
                                                             output table tt_log_erros_atualiz,
                                                             output v_cod_estab_bord,
                                                             output v_cod_portad_bord).
    
                   if  can-find(first tt_log_erros_atualiz) then do:
                       for each tt_log_erros_atualiz:
                           create tt-retorno-lin-b-ap.
                           assign tt-retorno-lin-b-ap.cod-erro   = string(tt_log_erros_atualiz.ttv_num_mensagem)
                                  tt-retorno-lin-b-ap.situacao   = no
                                  tt-retorno-lin-b-ap.cod-chave  = "".
                           if  tt_log_erros_atualiz.ttv_des_msg_ajuda = '' then
                               assign tt-retorno-lin-b-ap.desc-erro = tt_log_erros_atualiz.ttv_des_msg_erro.
                           else
                               assign tt-retorno-lin-b-ap.desc-erro = tt_log_erros_atualiz.ttv_des_msg_ajuda.
                       end.
                       return "NOK":U.
                   end.
               end.
    
               ASSIGN tt_integr_apb_pagto.ttv_ind_tip_atualiz   = "bordero"
                      tt_integr_apb_pagto.tta_cod_portad_ext    = string(tt-lin-b-ap.portador)
                      tt_integr_apb_pagto.tta_cod_modalid_ext   = '1'
                      tt_integr_apb_pagto.ttv_log_atualiz_refer = no
                      tt_integr_apb_pagto.tta_num_bord_ap       = p_num_bord
                      tt_integr_apb_pagto.tta_cod_msg_inic      = v_cod_msg_ini
                      tt_integr_apb_pagto.tta_cod_msg_fim       = v_cod_msg_fim.
            end.
            ELSE DO:
               assign tt_integr_apb_pagto.ttv_log_atualiz_refer = YES
                      tt_integr_apb_pagto.ttv_ind_tip_atualiz   = "lote".
               /*alteraá∆o feita pois na traduá∆o de lote no ems2 Ç diferente do ems5, 
                 isto est† causando problemas na integraá∆o do cÉmbio em inglàs*/    
               IF tt_integr_apb_pagto.ttv_ind_tip_atualiz = "lot" THEN
                   ASSIGN tt_integr_apb_pagto.ttv_ind_tip_atualiz   = "Btch".
            END.
        end. 
    
        for each tt-lin-b-ap no-lock:
            create tt_integr_apb_bord_lote_pagto.
            assign tt_integr_apb_bord_lote_pagto.tta_cod_empresa           = string(tt-lin-b-ap.ep-codigo)
                   tt_integr_apb_bord_lote_pagto.tta_cod_refer             = tt-lin-b-ap.referencia
                   tt_integr_apb_bord_lote_pagto.tta_cod_espec_docto       = tt-lin-b-ap.cod-esp
                   tt_integr_apb_bord_lote_pagto.tta_cod_ser_docto         = tt-lin-b-ap.serie
                   tt_integr_apb_bord_lote_pagto.tta_cdn_fornecedor        = tt-lin-b-ap.cod-fornec
                   tt_integr_apb_bord_lote_pagto.tta_cod_tit_ap            = tt-lin-b-ap.nr-docto
                   tt_integr_apb_bord_lote_pagto.tta_cod_parcela           = tt-lin-b-ap.parcela
                   tt_integr_apb_bord_lote_pagto.tta_val_cotac_indic_econ  = (tt-lin-b-ap.vl-baixa-me / tt-lin-b-ap.vl-baixa)
                   tt_integr_apb_bord_lote_pagto.tta_val_pagto             = tt-lin-b-ap.vl-baixa
                   tt_integr_apb_bord_lote_pagto.tta_log_critic_atualiz_ok = NO
                   tt_integr_apb_bord_lote_pagto.tta_val_variac_cambial    = 0
                   tt_integr_apb_bord_lote_pagto.ttv_rec_table_child       = &IF {&ROWID_READY} = YES &THEN ROWID(tt_integr_apb_bord_lote_pagto)  &ELSE RECID(tt_integr_apb_bord_lote_pagto)  &ENDIF
                   tt_integr_apb_bord_lote_pagto.ttv_rec_table_parent      = tt_integr_apb_pagto.ttv_rec_table_parent
                   tt_integr_apb_bord_lote_pagto.tta_cod_portad_ext        = string(tt-lin-b-ap.portador)
                   tt_integr_apb_bord_lote_pagto.tta_cod_modalid_ext       = '1'
                   tt_integr_apb_bord_lote_pagto.tta_cod_finalid_econ_ext  = '0'.
            
            if  p-log-cheque then do:
                assign tt_integr_apb_bord_lote_pagto.tta_num_talon_cheq        = p-talonario
                       tt_integr_apb_bord_lote_pagto.tta_num_cheque            = tt-lin-b-ap.nr-cheque
                       tt_integr_apb_bord_lote_pagto.tta_ind_favorec_cheq      = if tt-lin-b-ap.nominal = 1 then
                                                                                    "Portador"
                                                                                  else
                                                                                     if tt-lin-b-ap.nominal = 2 then
                                                                                        "Fornecedor"
                                                                                     else "outros"
                       tt_integr_apb_bord_lote_pagto.tta_nom_favorec_cheq      = if tt-lin-b-ap.nominal = 0 or tt-lin-b-ap.nominal = 3 then
                                                                                    tt-lin-b-ap.favorecido
                                                                                 else "".
            end.
            assign tt_integr_apb_bord_lote_pagto.tta_cod_livre_1       = tt-lin-b-ap.nr-contrato
                                                                         + chr(10) + string(tt-lin-b-ap.dt-contrato)
                                                                         + chr(10) + string(tt-lin-b-ap.num-id-contrato-imp)
                                                                         + chr(10) + tt-lin-b-ap.estabel-mec
                                                                         + chr(10) + tt-lin-b-ap.referencia-mec
                                                                         + chr(10) + string(tt-lin-b-ap.dt-referencia-mec).
            create tt_integr_cambio_ems5.
            assign tt_integr_cambio_ems5.ttv_rec_table_child           = &IF {&ROWID_READY} = YES &THEN ROWID(tt_integr_apb_bord_lote_pagto) &ELSE RECID(tt_integr_apb_bord_lote_pagto) &ENDIF
                   tt_integr_cambio_ems5.ttv_rec_table_parent          = tt_integr_apb_pagto.ttv_rec_table_parent
                   tt_integr_cambio_ems5.ttv_cod_contrat_cambio        = tt-lin-b-ap.nr-contrato
                   tt_integr_cambio_ems5.ttv_dat_contrat_cambio_import = tt-lin-b-ap.dt-contrato
                   tt_integr_cambio_ems5.ttv_num_contrat_id_cambio     = tt-lin-b-ap.num-id-contrato-imp
                   tt_integr_cambio_ems5.ttv_cod_estab_contrat_cambio  = tt-lin-b-ap.estabel-mec
                   tt_integr_cambio_ems5.ttv_cod_refer_contrat_cambio  = tt-lin-b-ap.referencia-mec
                   tt_integr_cambio_ems5.ttv_dat_refer_contrat_cambio  = tt-lin-b-ap.dt-referencia-mec.
    
            assign vl-tot-contrato-imp     = vl-tot-contrato-imp     + tt-lin-b-ap.vl-baixa-me
                   vl-tot-contrato-imp-aux = vl-tot-contrato-imp-aux + tt_integr_apb_bord_lote_pagto.tta_val_pagto.
            find first contrato-imp
                 where contrato-imp.nr-contrato = tt-lin-b-ap.nr-contrato
                   and contrato-imp.dt-contrato = tt-lin-b-ap.dt-contrato
                   and contrato-imp.vl-contrato-me = vl-tot-contrato-imp no-lock no-error.
            if avail contrato-imp then do:
                
                if round(vl-tot-contrato-imp * contrato-imp.cotacao-dia, 2) <> contrato-imp.vl-contrato then
                    assign tt_integr_apb_bord_lote_pagto.tta_val_pagto = tt_integr_apb_bord_lote_pagto.tta_val_pagto + ((vl-tot-contrato-imp * contrato-imp.cotacao-dia) - contrato-imp.vl-contrato).
                else if round(vl-tot-contrato-imp-aux / contrato-imp.cotacao-dia, 2) = vl-tot-contrato-imp
                     and vl-tot-contrato-imp-aux <> contrato-imp.vl-contrato then
                        assign tt_integr_apb_bord_lote_pagto.tta_val_pagto = tt_integr_apb_bord_lote_pagto.tta_val_pagto - (vl-tot-contrato-imp-aux - contrato-imp.vl-contrato).
                
            end.
        end.
    
        run prgfin/apb/apb902zb.py(input  1,
                                   input  table tt_integr_apb_pagto,
                                   output table tt_log_erros_atualiz,
                                   input  table tt_integr_apb_bord_lote_pagto,
                                   input  table tt_integr_apb_abat_prev,
                                   input  table tt_integr_apb_abat_antecip,
                                   input  table tt_integr_apb_impto_impl_pend,
                                   input  v-cod-matriz-trad-org-ext,
                                   input  table tt_integr_cambio_ems5).
        
        if can-find(first tt_log_erros_atualiz) then do:
            for each tt_log_erros_atualiz:
                create tt-retorno-lin-b-ap.
                assign tt-retorno-lin-b-ap.cod-erro   = string(tt_log_erros_atualiz.ttv_num_mensagem)
                       tt-retorno-lin-b-ap.situacao   = no
                       tt-retorno-lin-b-ap.cod-chave  = "".
                if  tt_log_erros_atualiz.ttv_des_msg_ajuda = '' then
                    assign tt-retorno-lin-b-ap.desc-erro = tt_log_erros_atualiz.ttv_des_msg_erro.
                else
                    assign tt-retorno-lin-b-ap.desc-erro = tt_log_erros_atualiz.ttv_des_msg_ajuda.
            end.
        end.
        else do:
            if  p_num_bord <> 0 
            and v_cod_estab_bord  <> ""
            and v_cod_portad_bord <> "" then do:
                assign c-cod-event = "show".
                run utp/ut-msgs.p (input c-cod-event, 
                                   input 31782, 
                                   input v_cod_estab_bord  + "~~" + v_cod_portad_bord + "~~" + string(p_num_bord)).
            end.
        end.
    END.
    ELSE DO:
        IF c-perm-preparador = "yes" OR
           c-perm-liberador  = "yes" THEN DO:
    
            for each tt-lin-b-ap no-lock:
                find first contrato-imp no-lock
                     where contrato-imp.ep-codigo           = tt-lin-b-ap.ep-codigo 
                     and   contrato-imp.cod-estabel         = tt-lin-b-ap.estabel-mec
                     and   contrato-imp.num-id-contrato-imp = tt-lin-b-ap.num-id-contrato-imp
                     no-error.
    
                create tt_proces_pagto_mec.
                assign tt_proces_pagto_mec.tta_cod_empresa            = string(tt-lin-b-ap.ep-codigo)
                       tt_proces_pagto_mec.tta_cod_estab              = tt-lin-b-ap.cod-estabel
                       tt_proces_pagto_mec.tta_cod_espec_docto        = tt-lin-b-ap.cod-esp
                       tt_proces_pagto_mec.tta_cod_ser_docto          = tt-lin-b-ap.serie
                       tt_proces_pagto_mec.tta_cod_tit_ap             = tt-lin-b-ap.nr-docto
                       tt_proces_pagto_mec.tta_cod_parcela            = tt-lin-b-ap.parcela
                       tt_proces_pagto_mec.tta_cdn_fornecedor         = tt-lin-b-ap.cod-fornec
                       tt_proces_pagto_mec.tta_num_seq_pagto_tit_ap   = 0
                       tt_proces_pagto_mec.tta_cod_portador           = string(tt-lin-b-ap.portador)
                       tt_proces_pagto_mec.tta_dat_vencto_tit_ap      = tt-lin-b-ap.dt-vencimen
                       tt_proces_pagto_mec.tta_dat_prev_pagto         = tt-lin-b-ap.dt-vencimen
                       tt_proces_pagto_mec.tta_cod_indic_econ         = IF AVAIL contrato-imp THEN string(contrato-imp.moeda) ELSE string(tt-lin-b-ap.mo-codigo)
                       tt_proces_pagto_mec.tta_ind_modo_pagto         = ""
                       tt_proces_pagto_mec.tta_cod_refer_antecip_pef  = ""
                       tt_proces_pagto_mec.tta_cod_livre_1            = tt-lin-b-ap.nr-contrato
                                                                        + chr(10) + string(tt-lin-b-ap.dt-contrato)
                                                                        + chr(10) + string(tt-lin-b-ap.num-id-contrato-imp)
                                                                        + chr(10) + tt-lin-b-ap.estabel-mec
                                                                        + chr(10) + tt-lin-b-ap.referencia-mec
                                                                        + chr(10) + string(tt-lin-b-ap.dt-referencia-mec)
                                                                        + chr(10) + string(contrato-imp.cotacao-dia).
                                                                        
                    
                IF  c-perm-preparador = "yes" THEN 
                    ASSIGN tt_proces_pagto_mec.tta_ind_sit_proces_pagto = "Preparado"
                           tt_proces_pagto_mec.tta_cod_usuar_prepar_pagto = v_cod_usuar_corren
                           tt_proces_pagto_mec.tta_dat_prepar_pagto       =  tt-lin-b-ap.dt-baixa.
    
    
                if  c-perm-liberador = "yes" then
                    ASSIGN tt_proces_pagto_mec.tta_ind_sit_proces_pagto   = "Liberado"
                           tt_proces_pagto_mec.tta_cod_usuar_liber_pagto  = v_cod_usuar_corren
                           tt_proces_pagto_mec.tta_dat_liber_pagto        = tt-lin-b-ap.dt-baixa
                           tt_proces_pagto_mec.tta_val_liberd_pagto       = tt-lin-b-ap.vl-baixa-me
                           tt_proces_pagto_mec.tta_val_liber_pagto_orig   = tt-lin-b-ap.vl-baixa-me
                           tt_proces_pagto_mec.tta_cod_usuar_prepar_pagto = v_cod_usuar_corren
                           tt_proces_pagto_mec.tta_dat_prepar_pagto       = tt-lin-b-ap.dt-baixa.
                    
            end.
            run pi_cria_proces_pagto in h-apb919za (input  TABLE tt_proces_pagto_mec,
                                                    output TABLE tt_log_erros).
    
            IF  CAN-FIND(FIRST tt_log_erros) THEN DO:
                FOR EACH tt_log_erros:
                    create tt-retorno-lin-b-ap.
                    assign tt-retorno-lin-b-ap.cod-erro   = STRING(tt_log_erros.ttv_num_cod_erro)
                           tt-retorno-lin-b-ap.situacao   = no
                           tt-retorno-lin-b-ap.cod-chave  = "".
                    if  tt_log_erros.ttv_des_ajuda = '' then
                        assign tt-retorno-lin-b-ap.desc-erro = tt_log_erros.ttv_des_erro.
                    else
                        assign tt-retorno-lin-b-ap.desc-erro = tt_log_erros.ttv_des_ajuda.
                end.
                return "NOK":U.
            end.
        END.
    END.
    delete procedure h-apb919za.
END.

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
    
    find first contr-despesa-imp where contr-despesa-imp.int-1 = p-num-id-contrato no-lock no-error.
    if avail contr-despesa-imp then do:
        find contrato-imp no-lock
             where contrato-imp.ep-codigo     = contr-despesa-imp.ep-codigo
             and   contrato-imp.cod-estabel   = contr-despesa-imp.cod-estabel
             and   contrato-imp.referencia    = contr-despesa-imp.referencia
             and   contrato-imp.dt-referencia = contr-despesa-imp.dt-referencia no-error.
        if avail contrato-imp then do:
            create tt_campos_mec.
            assign tt_campos_mec.ttv_cod_estab_ext    = contrato-imp.cod-estabel
                   tt_campos_mec.ttv_cod_empresa_ext  = string(contrato-imp.ep-codigo)
                   tt_campos_mec.ttv_cod_contrat_2    = contrato-imp.nr-contrato
                   tt_campos_mec.ttv_dat_contrat      = contrato-imp.dt-contrato
                   tt_campos_mec.ttv_cod_refer        = contrato-imp.referencia
                   tt_campos_mec.ttv_dat_refer        = contrato-imp.dt-referencia
                   tt_campos_mec.tta_cod_modul_integr = "IMP".
        end.
    end.
    else do:
        find first contrato-imp where contrato-imp.num-id-contrato-imp = p-num-id-contrato no-lock no-error.
        if avail contrato-imp then do:
            create tt_campos_mec.
            assign tt_campos_mec.ttv_cod_estab_ext    = contrato-imp.cod-estabel
                   tt_campos_mec.ttv_cod_empresa_ext  = string(contrato-imp.ep-codigo)
                   tt_campos_mec.ttv_cod_contrat_2    = contrato-imp.nr-contrato
                   tt_campos_mec.ttv_dat_contrat      = contrato-imp.dt-contrato
                   tt_campos_mec.ttv_cod_refer        = contrato-imp.referencia
                   tt_campos_mec.ttv_dat_refer        = contrato-imp.dt-referencia
                   tt_campos_mec.tta_cod_modul_integr = "IMP".
        end.
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
   def input  param r-rowid         as   rowid                      no-undo.
   def output param p-ep-codigo     like contrato-imp.ep-codigo     no-undo.
   def output param p-cod-estabel   like contrato-imp.cod-estabel   no-undo.
   def output param p-referencia    like contrato-imp.referencia    no-undo.
   def output param p-dt-referencia like contrato-imp.dt-referencia no-undo.
   
   find contrato-imp where rowid(contrato-imp) = r-rowid no-lock no-error.
   if avail contrato-imp then do:
      assign p-ep-codigo     = contrato-imp.ep-codigo
             p-cod-estabel   = contrato-imp.cod-estabel
             p-referencia    = contrato-imp.referencia
             p-dt-referencia = contrato-imp.dt-referencia.
   end.
   else RETURN "NOK":U.
   
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
    def output param  i-ep-codigo like contrato-imp.ep-codigo.
    
    {method/svc/autentic/autentic.i
            &vUserEnterprise="i-ep-codigo"}
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-num-id-contrato DBOProgram 
PROCEDURE pi-busca-num-id-contrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Retorna o num-id do contrato de importaá∆o pela chave do contrato       
------------------------------------------------------------------------------*/
    /**** Verificap/verificacao de produto  ****/
    def input param p-ep-codigo     like contrato-imp.ep-codigo. 
    def input param p-cod-estabel   like contrato-imp.cod-estabel. 
    def input param p-referencia    like contrato-imp.referencia.
    def input param p-dt-referencia like contrato-imp.dt-referencia.
    DEF OUTPUT PARAM p-num-id       LIKE contrato-imp.num-id-contrato-imp.
    DEF OUTPUT PARAM p-usuario      LIKE contrato-imp.usuario.
    
    FIND FIRST contrato-imp NO-LOCK
        WHERE contrato-imp.ep-codigo     = p-ep-codigo
          AND contrato-imp.cod-estabel   = p-cod-estabel
          AND contrato-imp.referencia    = p-referencia
          AND contrato-imp.dt-referencia = p-dt-referencia NO-ERROR.
    IF AVAIL contrato-imp THEN DO:
        ASSIGN p-num-id = contrato-imp.num-id-contrato-imp
               p-usuario = contrato-imp.usuario.
        RETURN "OK":U.
    END.
    ELSE
        RETURN "NOK":U.

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
         and   portador.conta-corren = p-cta-corren 
         and   portador.modalidade   = 1             no-error.
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
    def input param  p-referencia    like contrato-imp.referencia.
    def input param  p-dt-referencia like contrato-imp.dt-referencia.
    def output param p-rowid as rowid.

    find first contrato-imp no-lock
         where contrato-imp.referencia    = p-referencia
         and   contrato-imp.dt-referencia = p-dt-referencia no-error.
    if avail contrato-imp then
        assign p-rowid = rowid(contrato-imp).
    else
        assign p-rowid = ?.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-tipo-contrato-imp DBOProgram 
PROCEDURE pi-busca-tipo-contrato-imp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param  p-nr-contrato as char no-undo.
    def input param  p-dt-contrato as date no-undo.
    def output param p-tp-contrato-imp like contrato-imp.tp-contrato-imp no-undo.
   
    find first contrato-imp no-lock
         where contrato-imp.nr-contrato = p-nr-contrato
         and   contrato-imp.dt-contrato = p-dt-contrato no-error.
    if avail contrato-imp then 
        assign p-tp-contrato-imp = contrato-imp.tp-contrato-imp.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-antecipacao DBOProgram 
PROCEDURE pi-cria-antecipacao :
    def input        param p-num-talon-ch   as char       no-undo.
    def input        param p-pagar          as char       no-undo.
    def input-output param table for tt-antecip.
    def input-output param table for tt-previsao.
    def input-output param table for tt-log-tit-ap.
    def input-output param table for tt-ord-compra-pend.
    
   for each tt-antecip-1 no-lock:
       delete tt-antecip-1.
   end.
   for each tt-antecip no-lock:
       create tt-antecip-1.
       buffer-copy tt-antecip to tt-antecip-1.
   end.
            
   run pi-cria-antecipacao-1(input p-num-talon-ch,
                             input p-pagar,
                             input-output table tt-antecip-1,
                             input-output table tt-previsao,
                             input-output table tt-log-tit-ap,
                             input-output table tt-ord-compra-pend).
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-antecipacao DBOProgram 
PROCEDURE pi-cria-antecipacao-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input        param p-num-talon-ch   as char       no-undo.
    def input        param p-pagar          as char       no-undo.
    def input-output param table for tt-antecip-1.
    def input-output param table for tt-previsao.
    def input-output param table for tt-log-tit-ap.
    def input-output param table for tt-ord-compra-pend.
    
    def var h-apapi022a  as handle no-undo.
    
    if  can-find(first tt-antecip-1) then do:
        if  p-pagar = "EMS 5" then do:
            run pi-busca-empresa (output c-ep-codigo).
            
            run prgfin/apb/apb920za.p (input 1,
                                       input p-num-talon-ch,
                                       input table tt-antecip-1,
                                       input table tt-ord-compra-pend,
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
               create tt-log-tit-ap.
               assign tt-log-tit-ap.cod-erro = 1.
               
               {method/showmessage.i1}
               {method/showmessage.i2}
               
               for each RowErrors:
                   delete RowErrors.
               end.
            end.
        end.
    end.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-encontra-titulos-vinculados DBOProgram 
PROCEDURE pi-encontra-titulos-vinculados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if can-find (first contr-titulo-imp of RowObject) then do:
       return "NOK":U.
    end.
    else
       return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-soma DBOProgram 
PROCEDURE pi-valida-soma :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcod-estabel   LIKE contrato-imp.cod-estabel         NO-UNDO.
    DEFINE INPUT  PARAMETER preferencia    LIKE contrato-imp.referencia          NO-UNDO.
    DEFINE INPUT  PARAMETER pdt-referencia LIKE contrato-imp.dt-referencia       NO-UNDO.
    DEFINE OUTPUT PARAMETER soma           LIKE contr-titulo-imp.vl-vinculado-me NO-UNDO.
    def var i-empresa like contr-titulo-imp.ep-codigo no-undo.
    
    {method/svc/autentic/autentic.i
            &vUserEnterprise="i-empresa"}

    for each contr-titulo-imp
       where contr-titulo-imp.ep-codigo = i-empresa and
             contr-titulo-imp.cod-estabel = pcod-estabel and
             contr-titulo-imp.referencia = preferencia and
             contr-titulo-imp.dt-referencia = pdt-referencia no-lock:
       assign soma = soma + contr-titulo-imp.vl-vinculado-me.       
    end.
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

FIND FIRST contrato-imp NO-LOCK NO-ERROR.
if avail contrato-imp then
   RETURN "NOK":U.
ELSE
   RETURN "OK":U.

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

        find first integr-mec-modul-funcao 
             where integr-mec-modul-funcao.cod-modul-integr  = p-cod-modul-integr
               and integr-mec-modul-funcao.ind-funcao-integr = p-ind-funcao-integr
               and integr-mec-modul-funcao.cod-empresa       = p-cod-empresa
               and integr-mec-modul-funcao.cod-estab         = p-cod-estab no-lock no-error.
    
        if avail integr-mec-modul-funcao then
            return "OK":U.
    
        return "NOK":U.

    &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintContrato DBOProgram 
PROCEDURE setConstraintContrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-contrato-ini LIKE contrato-imp.nr-contrato.
    DEFINE INPUT PARAMETER pnr-contrato-fim LIKE contrato-imp.nr-contrato.
    DEFINE INPUT PARAMETER pdt-contrato-ini LIKE contrato-imp.dt-contrato.
    DEFINE INPUT PARAMETER pdt-contrato-fim LIKE contrato-imp.dt-contrato.

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
    DEFINE INPUT PARAMETER pnr-contrato-ini LIKE contrato-imp.nr-contrato.
    DEFINE INPUT PARAMETER pnr-contrato-fim LIKE contrato-imp.nr-contrato.
    DEFINE INPUT PARAMETER pdt-contrato-ini LIKE contrato-imp.dt-contrato.
    DEFINE INPUT PARAMETER pdt-contrato-fim LIKE contrato-imp.dt-contrato.

    assign c-nr-contrato-ini = pnr-contrato-ini
           c-nr-contrato-fim = pnr-contrato-fim
           d-dt-contrato-ini = pdt-contrato-ini
           d-dt-contrato-fim = pdt-contrato-fim.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintReferencia DBOProgram 
PROCEDURE setConstraintReferencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel-ini   LIKE contrato-imp.cod-estabel.
    DEFINE INPUT PARAMETER pcod-estabel-fim   LIKE contrato-imp.cod-estabel.
    DEFINE INPUT PARAMETER preferencia-ini    LIKE contrato-imp.referencia.
    DEFINE INPUT PARAMETER preferencia-fim    LIKE contrato-imp.referencia.
    DEFINE INPUT PARAMETER pdt-referencia-ini LIKE contrato-imp.dt-referencia.
    DEFINE INPUT PARAMETER pdt-referencia-fim LIKE contrato-imp.dt-referencia.

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
    DEFINE INPUT PARAMETER pcod-estabel-ini   LIKE contrato-imp.cod-estabel.
    DEFINE INPUT PARAMETER pcod-estabel-fim   LIKE contrato-imp.cod-estabel.
    DEFINE INPUT PARAMETER preferencia-ini    LIKE contrato-imp.referencia.
    DEFINE INPUT PARAMETER preferencia-fim    LIKE contrato-imp.referencia.
    DEFINE INPUT PARAMETER pdt-referencia-ini LIKE contrato-imp.dt-referencia.
    DEFINE INPUT PARAMETER pdt-referencia-fim LIKE contrato-imp.dt-referencia.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintTit-ap DBOProgram 
PROCEDURE setconstraintTit-ap :
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

    def var c-string1 as char no-undo.
    
    if ptype = "Create":U then do:
       {utp/ut-liter.i Contrato *}
       assign c-string1 = return-value.
       run pi-busca-empresa (output c-ep-codigo).
       if can-find(contrato-imp where contrato-imp.ep-codigo     = c-ep-codigo /* Verifica ocorrància de chave duplicada */
                                  and contrato-imp.cod-estabel   = RowObject.cod-estabel
                                  and contrato-imp.referencia    = RowObject.referencia
                                  and contrato-imp.dt-referencia = RowObject.dt-referencia) then do:
                                    {method/svc/errors/inserr.i
                                                &ErrorNumber="7"
                                                &ErrorType="EMS"
                                                &ErrorParameters="c-string1"}  /* Contrato j† cadastrado */
       
       end.

       if can-find(contrato-imp where contrato-imp.ep-codigo     = c-ep-codigo  /* Verifica ocorrància de chave duplicada */
                                   and contrato-imp.cod-estabel   <> RowObject.cod-estabel
                                   and contrato-imp.referencia    = RowObject.referencia
                                   and contrato-imp.dt-referencia = RowObject.dt-referencia) then do:
                                     {method/svc/errors/inserr.i
                                                 &ErrorNumber="27942"
                                                 &ErrorType="EMS"
                                                 &ErrorParameters="''"}  /* referÍncia ja utilizada em outro estabelecimento */

       end.
                                     
       if ( RowObject.nr-contrato <> "" or
          RowObject.nr-contrato  =  ? ) and
          RowObject.situacao <> 1  then do:
          if can-find(contrato-imp 
                      where contrato-imp.nr-contrato = RowObject.nr-contrato
                        and contrato-imp.dt-contrato = RowObject.dt-contrato) then
             {method/svc/errors/inserr.i
                         &ErrorNumber="25060"
                         &ErrorType="EMS"
                         &ErrorParameters="''"}
       end.
       
       if RowObject.cod-estabel <> "" then do:
          if can-find(estabelec where
                      estabelec.cod-estabel = RowObject.cod-estabel) = no then do:
             {method/svc/errors/inserr.i
                         &ErrorNumber="777"
                         &ErrorType="EMS"
                         &ErrorParameters="RowObject.cod-estabel"}   
          end.
       end. 
       else do:
          {method/svc/errors/inserr.i
                       &ErrorNumber="3645"
                       &ErrorType="EMS"
                       &ErrorParameters="''"}
       end.
       
       if RowObject.referencia = "" then
          {method/svc/errors/inserr.i
                       &ErrorNumber="15083"
                       &ErrorType="EMS"
                       &ErrorParameters="''"}

       if RowObject.dt-referencia = ? then
            {method/svc/errors/inserr.i
                        &ErrorNumber="19326"
                        &ErrorType="EMS"
                        &ErrorParameters="''"}
       
       if RowObject.tp-contrato-imp = 1 then do:  /* Pronto */
          if RowObject.situacao = 3 then   /* Liquidado */
             {method/svc/errors/inserr.i
                         &ErrorNumber="19420"
                         &ErrorType="EMS"
                         &ErrorParameters="''"}  /* Contrato n∆o pode ter situaáao liquidado */
       end.   /* Pronto */

       if RowObject.situacao = 5 then   /* Cancelado */
          {method/svc/errors/inserr.i
                      &ErrorNumber="19380"
                      &ErrorType="EMS"
                      &ErrorParameters="''"}
    end.

    if ptype = "Update":U then do:
        assign vl-tit-vinculados = 0.
/*        for each contr-titulo-imp
            where contr-titulo-imp.ep-codigo     = RowObject.ep-codigo
            and   contr-titulo-imp.cod-estabel   = RowObject.cod-estabel
            and   contr-titulo-imp.referencia    = RowObject.referencia
            and   contr-titulo-imp.dt-referencia = RowObject.dt-referencia: */
        for each contr-titulo-imp
        where contr-titulo-imp.NR-CONTRATO = RowObject.NR-CONTRATO
        and   contr-titulo-imp.DT-CONTRATO   = RowObject.DT-CONTRATO no-lock: /* CRIS */
            assign vl-tit-vinculados = vl-tit-vinculados + contr-titulo-imp.vl-vinculado-me.
        end.
        
        if RowObject.vl-contrato-me < vl-tit-vinculados then
            {method/svc/errors/inserr.i
                    &ErrorNumber="26261"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

        if RowObject.situacao = 3 and vl-tit-vinculados <> 0 then  /* Liquidado */
            {method/svc/errors/inserr.i
                       &ErrorNumber="26094"
                       &ErrorType="EMS"
                       &ErrorParameters="''"}  /* Contrato n∆o pode ser alterado por ser liquidado */

        if RowObject.vl-contrato-me < RowObject.vl-liquidado-me then
            {method/svc/errors/inserr.i
                       &ErrorNumber="26114"
                       &ErrorType="EMS"
                       &ErrorParameters="''"}  /* Contrato n∆o pode ser alterado por ser liquidado */
    end.
  
    if ptype = "Create":U or 
       ptype = "Update":U then do:

       if RowObject.nr-contrato <> "" AND RowObject.situacao <> 1  then do:
           find first bf{&TableName}
                where (bf{&TableName}.ep-codigo     <> RowObject.ep-codigo
                or     bf{&TableName}.cod-estabel   <> RowObject.cod-estabel
                or     bf{&TableName}.referencia    <> RowObject.referencia
                or     bf{&TableName}.dt-referencia <> RowObject.dt-referencia)
                and    bf{&TableName}.nr-contrato   =  RowObject.nr-contrato no-lock no-error.
           if avail bf{&TableName} then do:
               {method/svc/errors/inserr.i
                           &ErrorNumber="26235"
                           &ErrorType="EMS"
                           &ErrorParameters= "bf{&TableName}.cod-estabel + '~~~~' +~
                                              bf{&TableName}.referencia  + '~~~~' +~
                                              string(bf{&TableName}.dt-referencia)"}   /* Nr. do Contrato j† existe */
           end.
       end.

       if RowObject.dt-contrato < RowObject.dt-referencia then do:
           {method/svc/errors/inserr.i
                       &ErrorNumber="26225"
                       &ErrorType="EMS"
                       &ErrorParameters= "''"}   /* Data do Contrato deve ser maior ou igual a Data de Referància */
       end.
            
       if RowObject.nr-contrato <> ""
       and RowObject.vl-contrato-me = 0 and
            RowObject.situacao <> 1 then do:
           {method/svc/errors/inserr.i
                       &ErrorNumber="26231"
                       &ErrorType="EMS"
                       &ErrorParameters= "''"}   /* Valor do contrato dever† ser informado */
       end.
       
       if RowObject.cod-forma-pgto-mec <> "" or
          RowObject.cod-forma-pgto-mec  =  ? then do:
            if can-find (first forma-pgto-mec where forma-pgto-mec.cod-forma-pgto-mec = RowObject.cod-forma-pgto-mec) = no then
                {method/svc/errors/inserr.i
                           &ErrorNumber="19701"
                           &ErrorType="EMS"
                           &ErrorParameters="''"}
       end.

       run pi-autenticacao.

       if RowObject.moeda = 0 then
          {method/svc/errors/inserr.i
                       &ErrorNumber="19327"
                       &ErrorType="EMS"
                       &ErrorParameters="''"}
       
       if can-find (first moeda where moeda.mo-codigo = RowObject.moeda) = no then
          {method/svc/errors/inserr.i
                      &ErrorNumber="930"
                      &ErrorType="EMS"
                      &ErrorParameters="''"}

       if RowObject.nr-contrato <> "" and 
          RowObject.dt-contrato  =  ? then
          {method/svc/errors/inserr.i
                      &ErrorNumber="19379"
                      &ErrorType="EMS"
                      &ErrorParameters="''"}

       if RowObject.dt-contrato <> ? and RowObject.nr-contrato = "" then
          {method/svc/errors/inserr.i
                      &ErrorNumber="7829"
                      &ErrorType="EMS"
                      &ErrorParameters="''"}

       if RowObject.cod-oper-cambio <> "" or
          RowObject.cod-oper-cambio  =  ? then do:
          find operac-cambio where operac-cambio.cod-oper-cambio = RowObject.cod-oper-cambio no-lock no-error.
          if not avail operac-cambio then do:
             {method/svc/errors/inserr.i
                         &ErrorNumber="19352"
                         &ErrorType="EMS"
                         &ErrorParameters="''"}
          end.
       end.
    
       find banco where banco.cod-banco = RowObject.cod-vendedor no-lock no-error.
       if not avail banco then do:
          if RowObject.situacao <> 1 then do: /* Diferente de Pendente Contrato */
             {method/svc/errors/inserr.i
                         &ErrorNumber="19330"
                         &ErrorType="EMS"
                         &ErrorParameters="''"} /* C¢digo do vendedor n∆o existe na tabela banco */
          end.
       end.

       if RowObject.cod-vendedor = 0 and RowObject.situacao <> 1 then do:
            {method/svc/errors/inserr.i
                        &ErrorNumber="19331"
                        &ErrorType="EMS"
                        &ErrorParameters="''"}  /* C¢digo do vendedor deve ser diferente de 0 */ 
       end.

       if RowObject.tp-contrato-imp = 2 then do:  /* Antecipaá∆o */
          if  RowObject.nr-contrato = "" then 
            {method/svc/errors/inserr.i
                        &ErrorNumber="7829"
                        &ErrorType="EMS"
                        &ErrorParameters="''"}
          
          if RowObject.dt-contrato = ? then
               {method/svc/errors/inserr.i
                           &ErrorNumber="19328"
                           &ErrorType="EMS"
                           &ErrorParameters="''"} 
          
          if RowObject.vl-contrato-me = 0 then 
               {method/svc/errors/inserr.i
                           &ErrorNumber="19329"
                           &ErrorType="EMS"
                           &ErrorParameters="''"} 
          
       end. /* Antecipaá∆o */ 
                
       if RowObject.cod-corretor <> 0 then do:
          if can-find (first emitente where emitente.cod-emitente = RowObject.cod-corretor) = no then
             {method/svc/errors/inserr.i
                         &ErrorNumber="19332"
                         &ErrorType="EMS"
                         &ErrorParameters="''"}
              
       end.
       if RowObject.dt-contrato <> ? then do:
          if RowObject.dt-liquidacao < RowObject.dt-contrato then do:
             {utp/ut-liter.i Dt._Liquidaá∆o~~~~Dt._Contrato *}
             assign c-string1 = return-value.

             {method/svc/errors/inserr.i
                         &ErrorNumber="19333"
                         &ErrorType="EMS"
                         &ErrorParameters="c-string1"}
          end.              
          /* FO 929018
          else do:
             if RowObject.situacao <> 1 then do:
                for each contr-titulo-imp where 
                         contr-titulo-imp.ep-codigo     = RowObject.ep-codigo   and 
                         contr-titulo-imp.cod-estabel   = RowObject.cod-estabel and 
                         contr-titulo-imp.referencia    = RowObject.referencia  and 
                         contr-titulo-imp.dt-referencia = RowObject.dt-referencia no-lock:
                   if contr-titulo-imp.dt-vencimen > RowObject.dt-liquidacao then do:
                      assign c-desc-erro = string(RowObject.dt-liquidacao,"99/99/9999")      + "~~" +
                                           string(contr-titulo-imp.dt-vencimen,"99/99/9999") + "~~" +
                                           string(contr-titulo-imp.ep-codigo)                + "~~" +
                                           contr-titulo-imp.cod-est                          + "~~" +
                                           contr-titulo-imp.cod-esp                          + "~~" +
                                           contr-titulo-imp.serie                            + "~~" +
                                           contr-titulo-imp.nr-docto                         + "~~" +
                                           contr-titulo-imp.parcela.
                      {method/svc/errors/inserr.i
                                  &ErrorNumber="25059"
                                  &ErrorType="EMS"
                                  &ErrorParameters="c-desc-erro"} 
                      leave.            
                   end.                                                
                end.                                                
             end.  
          end.
          */
       end.
       
    end. /* Create e Update */
    
    if ptype = "Delete":U then do:
    /*    find first contr-titulo-imp of  RowObject no-lock no-error. */

        find first contr-titulo-imp no-lock
             where contr-titulo-imp.nr-contrato = RowObject.nr-contrato
             and   contr-titulo-imp.dt-contrato = RowObject.dt-contrato 
             use-index contrato no-error.                               
        if avail contr-titulo-imp then
          {method/svc/errors/inserr.i
                      &ErrorNumber="25454"
                      &ErrorType="EMS"
                      &ErrorParameters="''"}

        find first contr-docto-imp of RowObject no-lock no-error.
        if avail contr-docto-imp then
          {method/svc/errors/inserr.i
                      &ErrorNumber="25454"
                      &ErrorType="EMS"
                      &ErrorParameters="''"}

        find first contr-despesa-imp of RowObject no-lock no-error.
        if avail contr-despesa-imp then
          {method/svc/errors/inserr.i
                      &ErrorNumber="25454"
                      &ErrorType="EMS"
                      &ErrorParameters="''"}

       if RowObject.tp-contrato-imp = 2 then do: /* Antecipaá∆o */
          find first contr-titulo-imp of RowObject no-lock no-error.
          if avail contr-titulo-imp then
            {method/svc/errors/inserr.i
                        &ErrorNumber="25058"
                        &ErrorType="EMS"
                        &ErrorParameters="''"}

       end.

       if RowObject.tp-contrato-imp = 1 and RowObject.situacao <> 3 then do:  /* tipo: Pronto - situaá∆o: Liquidado */
          if RowObject.vl-liquidado-me > 0 then
            {method/svc/errors/inserr.i
                        &ErrorNumber="19334"
                        &ErrorType="EMS"
                        &ErrorParameters="''"} /* Contrato j† sofreu baixa*/

       end.
    end. /* Delete */ 

    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

