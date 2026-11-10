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
{include/i-prgvrs.i BOIN688 2.00.00.027 } /*** "010027" 24/11/2023 13:25:26  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin688 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
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
&GLOBAL-DEFINE DBOName BOIN688
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName item-fornec-estab
&GLOBAL-DEFINE TableLabel Item do Fornecedor
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{inbo/boin688.i RowObject}
{inbo/boin178.i tt-item-fornec}
{inbo/boin688.i tt-item-fornec-estab}

{cdp/cdcfgmat.i} /* Include uso de pre-processadores */

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/** * Definiá‰es Multi-Planta * **/
def var i-tipo-movto  as integer no-undo.
def var l-cria        as logical no-undo.
def var c-comp-aux    as char    no-undo.    
{mpp/mpapi011.i}
{cdp/cd7300.i1}
/** * Fim Definiá‰es Multi-Planta * **/ 

/*--------------  procedure AtualizaUnidMedItemFornec   -------------------*/
def var  c-seg-usuario  as  char   no-undo.
def buffer b-item-fornec-estab for item-fornec-estab.
def buffer bfitem for item.

DEFINE VARIABLE i-x                 AS INTEGER  NO-UNDO. /* contador utilizada na include cc0105.i1 */
DEFINE VARIABLE de-soma             AS DECIMAL  NO-UNDO. /* utilizado na verificacao do percentual de compra */
DEFINE VARIABLE de-perc-compra      AS DECIMAL  NO-UNDO. /* utilizado na verificacao do percentual de compra */
DEFINE VARIABLE de-indice           AS DECIMAL  NO-UNDO.
DEFINE VARIABLE de-prazo            AS DECIMAL  NO-UNDO. /* utilizada na include cc0105.i1 */
DEFINE VARIABLE de-taxa-per         AS DECIMAL  NO-UNDO. /* utilizada na include cc0105.i1 */
DEFINE VARIABLE l-integra-paradigma AS LOGICAL  NO-UNDO.
DEFINE VARIABLE l-erro-un           AS LOGICAL  NO-UNDO.
DEFINE VARIABLE l-create            AS LOGICAL  NO-UNDO. /* para distinguir entre create e update.*/
DEFINE VARIABLE l-alt-med           AS LOGICAL  NO-UNDO.
DEFINE VARIABLE l-alt-lote          AS LOGICAL  NO-UNDO.
DEFINE VARIABLE l-preco-bruto       AS LOGICAL  NO-UNDO. /* utilizada na include cc0105.i1  e
                                                        na procedure InicializaPrecoIpiQtde*/

DEFINE VARIABLE cEstab            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cItem             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cItemIni          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cItemFin          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cItemFornIni      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cItemFornFin      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cEstabini         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cItemFim          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cEstabFim         AS CHARACTER   NO-UNDO.

DEFINE VARIABLE iEmitente         AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-severa          AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-normal          AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-atenua          AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-pr-bom          AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-pr-oti          AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-pr-exc          AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cod-emitenteIni AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cod-emitenteFim AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cont            AS INTEGER     NO-UNDO.

DEFINE VARIABLE h-axssu006          AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-boin082           AS HANDLE    NO-UNDO.
DEFINE VARIABLE r-rowid             AS ROWID     NO-UNDO.

def temp-table tt_log_erro  no-undo
    field ttv_num_cod_erro  as int  initial ?
    field ttv_des_msg_ajuda as char initial ?
    field ttv_des_msg_erro  as char initial ?.

FIND FIRST funcao NO-LOCK
     WHERE funcao.cd-funcao = "spp-portal-paradigma":U
       AND funcao.ativo NO-ERROR.

IF AVAIL funcao THEN DO:

    IF NOT AVAIL param-compra THEN
        FIND FIRST param-compra NO-LOCK NO-ERROR.

    IF &if "{&bf_mat_versao_ems}" < "2.09" &then
           SUBSTRING(param-compra.char-2,103,1) = "S":U
       &ELSE
           param-compra.log-portal-paradigma
       &ENDIF
    THEN DO:
        ASSIGN l-integra-paradigma = YES.
    END.
END.


/*--------------- InicializaPrecoIpiQtde --------------------*/
def var de-val-orig     as   decimal format ">>>>>>>>>>>>>>9,99" NO-UNDO.
def var da-data         like cotacao-item.data-cotacao           NO-UNDO.
def var l-tabela-g      as   log init yes                        NO-UNDO.
def var de-preco-unit   like ordem-compra.preco-unit label "Preco Un" format "zzzzzzzz9.9999" NO-UNDO.
/*-----------------------------------------------------------*/

/*-------Definiá∆o das variavÇis do setConstraintByFornec--------*/

def var i-cod-emitente as int no-undo.

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
         WIDTH              = 41.29.
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


define temp-table RowErrorsAux no-undo like RowErrors.

{method/svc/autentic/autentic.i         
            &vUserName="c-seg-usuario"}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
find first item-fornec
    where item-fornec.it-codigo    = {&tablename}.it-codigo   
    and   item-fornec.cod-emitente = {&TableName}.cod-emitente no-lock no-error.
if avail item-fornec then do:
    assign {&TableName}.tp-inspecao = item-fornec.tp-inspecao.
    do i-cont = 1 to 30:
        assign {&TableName}.aval-insp[i-cont]   = item-fornec.aval-insp[i-cont].  
    end.

end.

           


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if item-fornec-estab.ativo then do:
       find first item-fornec 
            where item-fornec.it-codigo    = item-fornec-estab.it-codigo
              and item-fornec.cod-emitente = item-fornec-estab.cod-emitente EXCLUSIVE-LOCK no-error.
       if avail item-fornec then
       assign item-fornec.ativo = yes.
    end.

    return "OK":U.
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

    /**** Elimina despesas relacionadas ao item-fornec, somente
          a partir da vers∆o 2.04B ****/
    &if defined(bf_mat_despesa_compra_inter) &then
        for each  desp-item-fornec-estab
            where desp-item-fornec-estab.it-codigo   = item-fornec-estab.it-codigo
              and desp-item-fornec-estab.cod-emite   = item-fornec-estab.cod-emitente
              and desp-item-fornec-estab.cod-estabel = item-fornec-estab.cod-estabel
                  exclusive-lock:
            delete desp-item-fornec-estab.
        end.
    &endif


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE comparaItemFornec DBOProgram 
PROCEDURE comparaItemFornec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

        if can-find (first item-fornec-estab where
              item-fornec-estab.it-codigo    = cItem  and
              item-fornec-estab.cod-emitente = i-cod-emitente) then
                return "OK":U.   
        else
                return "NOK":U.   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExecuteValidateStatusFornec DBOProgram 
PROCEDURE ExecuteValidateStatusFornec :
/*------------------------------------------------------------------------------
  Purpose: Verificar a situacao do fonecedor para validar alteracoes na parcela    
  Parameters:  <none>
  Notes:      
------------------------------------------------------------------------------*/
    def var h-boin356vl as handle no-undo.


    if not valid-handle (h-boin356vl) then
        run inbo/boin356vl.p persistent set h-boin356vl.

    run validateStatusFornec in h-boin356vl ( ?,
                                              rowObject.cod-emitente ).
    run getRowErrors in h-boin356vl (output table RowErrorsAux).
    for each RowErrorsAux:
        create RowErrors.
        buffer-copy RowErrorsAux to RowErrors.
    end.
    empty temp-table RowErrorsAux.

    if valid-handle (h-boin356vl) then do:
        delete procedure h-boin356vl.
                         h-boin356vl = ?.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exportaAlteracoesItemFornec DBOProgram 
PROCEDURE exportaAlteracoesItemFornec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pRowItemFornEstab AS ROWID   NO-UNDO.
    DEFINE INPUT  PARAMETER l-confirma        AS LOGICAL NO-UNDO.
    DEFINE INPUT  PARAMETER l-alterados       AS LOGICAL NO-UNDO.
    DEFINE INPUT  PARAMETER table for tt-item-fornec.

    /* Api de exportaá∆o */
    run ccp/ccapi030.p (input pRowItemFornEstab,
                        input l-confirma,
                        input l-alterados,
                        input table tt-item-fornec,
                        output table tt-item-fornec-estab).

    find first tt-item-fornec-estab no-lock no-error.

    IF AVAIL tt-item-fornec-estab THEN DO:
        run repositionRecord in this-procedure(tt-item-fornec-estab.r-rowid).
        run setRecord in this-procedure(input table tt-item-fornec-estab).
        run updateRecord in this-procedure.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "numero-nota":U THEN ASSIGN pFieldValue = RowObject.numero-nota.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
        WHEN "serie-nota":U THEN ASSIGN pFieldValue = RowObject.serie-nota.
        WHEN "cd-referencia":U THEN ASSIGN pFieldValue = RowObject.cd-referencia.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "item-do-forn":U THEN ASSIGN pFieldValue = RowObject.item-do-forn.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "unid-med-for":U THEN ASSIGN pFieldValue = RowObject.unid-med-for.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "fator-conver":U THEN ASSIGN pFieldValue = RowObject.fator-conver.
        WHEN "perc-dev-forn":U THEN ASSIGN pFieldValue = RowObject.perc-dev-forn.
        WHEN "perc-pont-forn":U THEN ASSIGN pFieldValue = RowObject.perc-pont-forn.
        WHEN "qt-max-ordem":U THEN ASSIGN pFieldValue = RowObject.qt-max-ordem.
        WHEN "rendimento":U THEN ASSIGN pFieldValue = RowObject.rendimento.
        WHEN "lote-minimo":U THEN ASSIGN pFieldValue = RowObject.lote-minimo.
        WHEN "lote-mul-for":U THEN ASSIGN pFieldValue = RowObject.lote-mul-for.
        WHEN "niv-qua-ac":U THEN ASSIGN pFieldValue = RowObject.niv-qua-ac.
        WHEN "concentracao":U THEN ASSIGN pFieldValue = RowObject.concentracao.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "criticidade":U THEN ASSIGN pFieldValue = RowObject.criticidade.
        WHEN "hora-fim":U THEN ASSIGN pFieldValue = RowObject.hora-fim.
        WHEN "hora-ini":U THEN ASSIGN pFieldValue = RowObject.hora-ini.
        WHEN "horiz-fixo":U THEN ASSIGN pFieldValue = RowObject.horiz-fixo.
        WHEN "ind-pont":U THEN ASSIGN pFieldValue = RowObject.ind-pont.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "num-casa-dec":U THEN ASSIGN pFieldValue = RowObject.num-casa-dec.
        WHEN "ped-fornec":U THEN ASSIGN pFieldValue = RowObject.ped-fornec.
        WHEN "perc-compra":U THEN ASSIGN pFieldValue = RowObject.perc-compra.
        WHEN "tempo-ressup":U THEN ASSIGN pFieldValue = RowObject.tempo-ressup.
        WHEN "tp-inspecao":U THEN ASSIGN pFieldValue = RowObject.tp-inspecao.
        WHEN "aval-insp[1]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[1].
        WHEN "aval-insp[17]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[17].
        WHEN "aval-insp[18]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[18].
        WHEN "aval-insp[19]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[19].
        WHEN "aval-insp[20]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[20].
        WHEN "aval-insp[21]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[21].
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "aval-insp[24]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[24].
        WHEN "aval-insp[25]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[25].
        WHEN "aval-insp[26]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[26].
        WHEN "aval-insp[27]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[27].
        WHEN "aval-insp[28]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[28].
        WHEN "aval-insp[29]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[29].
        WHEN "aval-insp[30]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[30].
        WHEN "classe-repro":U THEN ASSIGN pFieldValue = RowObject.classe-repro.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-mensagem":U THEN ASSIGN pFieldValue = RowObject.cod-mensagem.
        WHEN "conceito":U THEN ASSIGN pFieldValue = RowObject.conceito.
        WHEN "niv-inspecao":U THEN ASSIGN pFieldValue = RowObject.niv-inspecao.
        WHEN "aval-insp[22]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[22].
        WHEN "aval-insp[23]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[23].
        WHEN "aval-insp[2]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[2].
        WHEN "aval-insp[3]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[3].
        WHEN "aval-insp[4]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[4].
        WHEN "aval-insp[5]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[5].
        WHEN "aval-insp[6]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[6].
        WHEN "aval-insp[7]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[7].
        WHEN "aval-insp[8]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[8].
        WHEN "aval-insp[9]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[9].
        WHEN "aval-insp[10]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[10].
        WHEN "aval-insp[11]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[11].
        WHEN "aval-insp[12]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[12].
        WHEN "aval-insp[13]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[13].
        WHEN "aval-insp[14]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[14].
        WHEN "aval-insp[15]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[15].
        WHEN "aval-insp[16]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[16].
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ONDE-COMPRA
  Parameters:
               retorna valor dos campos do °ndice ONDE-COMPRA
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE item-fornec-estab.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE item-fornec-estab.cod-emitente NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo.
    ASSIGN pcod-emitente = RowObject.cod-emitente.

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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cot-aut":U THEN ASSIGN pFieldValue = RowObject.cot-aut.
        WHEN "reaj-tabela":U THEN ASSIGN pFieldValue = RowObject.reaj-tabela.
        WHEN "ativo":U THEN ASSIGN pFieldValue = RowObject.ativo.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "usa-contrato":U THEN ASSIGN pFieldValue = RowObject.usa-contrato.
        WHEN "contr-forn":U THEN ASSIGN pFieldValue = RowObject.contr-forn.
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
               retorna status do processo
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
  Purpose:     Reposiciona registro com base no °ndice ONDE-COMPRA
  Parameters:
               recebe valor dos campos do °ndice ONDE-COMPRA
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE item-fornec-estab.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE item-fornec-estab.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE item-fornec-estab.cod-estabel NO-UNDO.

    FIND FIRST bfitem-fornec-estab WHERE
        bfitem-fornec-estab.it-codigo    = pit-codigo AND
        bfitem-fornec-estab.cod-emitente = pcod-emitente and
        bfitem-fornec-estab.cod-estabel  = pcod-estabel
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-fornec-estab THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-fornec-estab)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToItemUniEstab DBOProgram 
PROCEDURE linkToItemUniEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  Handle do DBO pai.
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter ph-itemUniEstab as handle no-undo.
    RUN GetKey in ph-itemUniEstab (output cItem, output cEstab).
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItemEstabCodEmitente DBOProgram 
PROCEDURE openQueryItemEstabCodEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        open query {&QueryName} for each {&TableName} where
                                         {&tablename}.it-codigo    >= cItemIni          and
                                         {&TableName}.cod-emitente >= i-cod-emitenteIni and
                                         {&TableName}.cod-estabel  >= cEstabini         and
                                         {&tablename}.it-codigo    <= cItemFim          and
                                         {&TableName}.cod-emitente <= i-cod-emitenteFim and
                                         {&TableName}.cod-estabel  <= cEstabFim
                                         no-lock INDEXED-REPOSITION.
        return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH item-fornec-estab NO-LOCK INDEXED-REPOSITION.    
    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfFornec DBOProgram 
PROCEDURE openQueryOfFornec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE
                                         {&TableName}.cod-emitente  = iEmitente 
                                         NO-LOCK 
                                         BY {&TableName}.cod-estabel 
                                         INDEXED-REPOSITION.
        RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfItemEstab DBOProgram 
PROCEDURE openQueryOfItemEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        open query {&QueryName} for each {&TableName} where
                                         {&tablename}.it-codigo    = cItem  and
                                         {&TableName}.cod-estabel  = cEstab                                          
                                         no-lock INDEXED-REPOSITION.                                     
                                         
        return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfItemEstabCodEmitente DBOProgram 
PROCEDURE openQueryOfItemEstabCodEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        open query {&QueryName} for each {&TableName} where
                                         {&tablename}.it-codigo    = cItem          and
                                         {&TableName}.cod-emitente = i-cod-emitente and
                                         {&TableName}.cod-estabel  = cEstab
                                         no-lock INDEXED-REPOSITION.
        return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfItemFornec DBOProgram 
PROCEDURE openQueryOfItemFornec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        open query {&QueryName} for each {&TableName} where
                                         {&tablename}.it-codigo    = cItem  and
                                         {&TableName}.cod-emitente = i-cod-emitente
                                         no-lock INDEXED-REPOSITION.
        return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfTpInsp DBOProgram 
PROCEDURE openQueryOfTpInsp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        open query {&QueryName} for each {&TableName} 
                                    where {&TableName}.tp-inspecao = i-severa
                                    or    {&TableName}.tp-inspecao = i-normal
                                    or    {&TableName}.tp-inspecao = i-atenua
                                    or    {&TableName}.tp-inspecao = i-pr-bom
                                    or    {&TableName}.tp-inspecao = i-pr-oti
                                    or    {&TableName}.tp-inspecao = i-pr-exc
                                        no-lock INDEXED-REPOSITION.
        return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodEmitenteItemEstab DBOProgram 
PROCEDURE setConstraintCodEmitenteItemEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pcItemIni        as character no-undo.
    def input param pcItemFim        as character no-undo.
    def input param piCodEmitenteIni as int   no-undo.
    def input param piCodEmitenteFim as int   no-undo.
    def input param piEstabIni       as char no-undo.
    def input param piEstabFim       as char no-undo.


       assign cItemIni          = pcItemIni 
              cEstabIni         = piEstabIni
              i-cod-emitenteIni = piCodEmitenteIni
              cItemFim          = pcItemFim
              cEstabFim         = piEstabFim               
              i-cod-emitenteFim = piCodEmitenteFim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodEmitenteOfItemEstab DBOProgram 
PROCEDURE setConstraintCodEmitenteOfItemEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param piCodEmitente as int   no-undo.
    def input param prItemEstab   as rowid no-undo.

    find item-uni-estab where rowid(item-uni-estab) = prItemEstab no-lock no-error.    
    if avail item-uni-estab then
       assign cItem  = item-uni-estab.it-codigo
              cEstab = item-uni-estab.cod-estabel.
    assign i-cod-emitente = piCodEmitente.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintComparaItemFornec DBOProgram 
PROCEDURE setConstraintComparaItemFornec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pcitem    as  char  no-undo.
    def input param pcfornec  as  int   no-undo. 
    assign cItem          = pcitem
           i-cod-emitente = pcfornec.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfItemFornec DBOProgram 
PROCEDURE setConstraintOfItemFornec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param prItemFornec   as rowid no-undo.

    find item-fornec where rowid(item-fornec) = prItemFornec no-lock no-error.
    if avail item-fornec then
       assign cItem          = item-fornec.it-codigo
              i-cod-emitente = item-fornec.cod-emitente.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintTpInsp DBOProgram 
PROCEDURE setConstraintTpInsp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pi-isevera as int   no-undo.
    def input param pi-inormal as int   no-undo.
    def input param pi-iatenua as int   no-undo.
    def input param pi-ipr-bom as int   no-undo.
    def input param pi-ipr-oti as int   no-undo.
    def input param pi-ipr-exc as int   no-undo.
    

    assign i-severa  = pi-isevera
           i-normal  = pi-inormal
           i-atenua  = pi-iatenua
           i-pr-bom  = pi-ipr-bom
           i-pr-oti  = pi-ipr-oti
           i-pr-exc  = pi-ipr-exc.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setContraintOfFornec DBOProgram 
PROCEDURE setContraintOfFornec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  Handle do DBO pai.
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER pEmitente AS INTE NO-UNDO.
    
    ASSIGN iEmitente = pEmitente.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
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
   
   
   FIND FIRST rowObject NO-ERROR. 

    IF pType = "Create":U then do:
        find bfitem-fornec-estab where
             bfitem-fornec-estab.it-codigo    = rowObject.it-codigo    and
             bfitem-fornec-estab.cod-estabel  = rowObject.cod-estabel  and
             bfitem-fornec-estab.cod-emitente = rowObject.cod-emitente no-lock no-error.
        if avail bfitem-fornec-estab then do:
            {method/svc/errors/inserr.i &ErrorNumber="8"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="'{&TABLELABEL}'":U}
        end.

        find item-fornec where
             item-fornec.it-codigo    = rowObject.it-codigo    and
             item-fornec.cod-emitente = rowObject.cod-emitente no-lock no-error.
        if avail item-fornec and (item-fornec.ativo = no) then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-relacionamento-item-fornecedor AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Relacionamento_Item_Fornecedor" *}
            ASSIGN c-lbl-liter-relacionamento-item-fornecedor = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-uso AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "uso" *}
            ASSIGN c-lbl-liter-uso = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="18721"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter-relacionamento-item-fornecedor + '~~~~' + c-lbl-liter-uso"}
        end.
           &if defined (bf_mat_bloqueio_fornec) &then
               /**valida a situacao do fornecedor antes de criar o relacionamento**/
               run ExecuteValidateStatusFornec.
           &endif
    END.    
    
    IF pType = "Create":U OR pType = "Update":U THEN DO:
        find cond-pagto where 
             cond-pagto.cod-cond-pag = rowObject.cod-cond-pag no-lock no-error.
        if not avail cond-pagto then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-condicao-de-pagamento AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Condiá∆o_de_Pagamento" *}
            ASSIGN c-lbl-liter-condicao-de-pagamento = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter-condicao-de-pagamento"}        
        end.

        IF NOT CAN-FIND(FIRST mguni.moeda 
                        WHERE moeda.mo-codigo = INTEGER(SUBSTRING(rowObject.char-1,1,2))) THEN DO:
             /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-moeda-padrao AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Moeda_Padr∆o" *}
                ASSIGN c-lbl-liter-moeda-padrao = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="7381"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="c-lbl-liter-moeda-padrao"}
        END.
        
        /*valida se a classe reprogramaÁ„o contem um valor entre 1 e 4*/
        if  RowObject.classe-repro <> 1
        and RowObject.classe-repro <> 2
        and RowObject.classe-repro <> 3
        and RowObject.classe-repro <> 4 then do:
            {method/svc/errors/inserr.i &ErrorNumber="56085"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
        end.
        
        find emitente where 
             emitente.cod-emitente = rowObject.cod-emitente and
             emitente.identific    <> 1 no-lock no-error.
        if not avail emitente then do:
            {method/svc/errors/inserr.i &ErrorNumber="7060"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
        end.

        assign de-soma = dec(RowObject.perc-compra).

        /*Considera o total de 100% de compra apenas na tabela item-fornec-estab.*/
        for each  bfitem-fornec-estab
            where bfitem-fornec-estab.it-codigo    = RowObject.it-codigo
              and bfitem-fornec-estab.cod-estabel  = RowObject.cod-estabel
              and bfitem-fornec-estab.cod-emitente <> RowObject.cod-emitente
              and bfitem-fornec-estab.ativo no-lock:
            assign de-soma = de-soma + bfitem-fornec-estab.perc-compra.
        end.

        assign de-perc-compra = dec(RowObject.perc-compra).
        if  (de-perc-compra = 0 and RowObject.contr-forn = yes)
        or  de-soma > 100 then do:
            {method/svc/errors/inserr.i &ErrorNumber="1189"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
        end.

/*        for each b-item-fornec-estab no-lock
 *            where b-item-fornec-estab.it-codigo = RowObject.it-codigo /*item-fornec-estab.it-codigo*/
 *              and b-item-fornec-estab.ativo
 *              and rowid(b-item-fornec-estab) <> RowObject.r-rowid:
 *              assign de-soma = de-soma + b-item-fornec-estab.perc-compra.
 *         end.
 *         assign de-perc-compra = dec(RowObject.perc-compra).
 *         if  (de-perc-compra = 0 and RowObject.contr-forn = yes)
 *         or  de-soma > 100 then do:
 *             {method/svc/errors/inserr.i &ErrorNumber="1189"
 *                                         &ErrorType="EMS":U
 *                                         &ErrorSubType="ERROR":U}
 *         end.*/

        IF NOT CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN do:
            find item-fornec where item-fornec.it-codigo    = rowObject.it-codigo
                             and   item-fornec.cod-emitente = rowObject.cod-emitente NO-LOCK no-error.
            if avail item-fornec then do:
               assign rowObject.unid-med-for = item-fornec.unid-med-for
                      rowObject.num-casa-dec = item-fornec.num-casa-dec
                      rowObject.item-do-forn = item-fornec.item-do-forn
                      rowObject.fator-conver = item-fornec.fator-conver.
            end.
            else do:
               find item where item.it-codigo = rowObject.it-codigo no-lock no-error.
               assign rowObject.unid-med-for = item.un
                      rowObject.num-casa-dec = 0
                      rowObject.item-do-forn = item.it-codigo
                      rowObject.fator-conver = 1.
    
               create item-fornec.
               buffer-copy rowObject except cod-estabel perc-compra to item-fornec.
            end.

            IF l-integra-paradigma THEN DO:
                run adapters/xml/su2/axssu006.p persistent set h-axssu006 (output table tt_log_erro).
                run PITransUpsert in h-axssu006 (input rowid(item-fornec),
                                                 input "add":U,
                                                 output table tt_log_erro).

                for each tt_log_erro no-lock:
                    create RowErrors.
                    assign RowErrors.ErrorNumber      = 17006 
                           RowErrors.ErrorDescription = tt_log_erro.ttv_des_msg_erro
                           RowErrors.ErrorHelp        = tt_log_erro.ttv_des_msg_ajuda
                           RowErrors.ErrorSubType     = "WARNING":U.
                end.

                IF (valid-handle(h-axssu006) 
                     and h-axssu006:type = "PROCEDURE":U 
                     and h-axssu006:file-name = "adapters/xml/su2/axssu006.p":U ) then DO:

                     delete procedure h-axssu006.
                     assign h-axssu006 = ?.
                 END.
            END.
        end.
    END.
   
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

