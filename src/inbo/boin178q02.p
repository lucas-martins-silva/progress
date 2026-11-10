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
{include/i-prgvrs.i BOIN178Q02 2.00.00.004} /*** "010004" 23/11/2023 16:19:44  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN178Q02 MUT}
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
&GLOBAL-DEFINE DBOName item-fornec
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName item-fornec
&GLOBAL-DEFINE TableLabel item-fornec
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (boin178.p) est† com as funá‰es de inclui (createRecord), 
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas, 
**  porque S‡ nela foram implementadas as triggers do dicion†rio.
**  Para desabilitar as procedures foram usados os prÇ-processadores abaixo.
**  A procedure validateRecord dessa DBO n∆o deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{inbo/boin178.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
/*{method/dboqry.i}*/

DEFINE QUERY {&QueryName} for {&TableName},ordem-compra scrolling.

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

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
         HEIGHT             = 15.71
         WIDTH              = 42.
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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "numero-nota":U THEN ASSIGN pFieldValue = RowObject.numero-nota.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
        WHEN "serie-nota":U THEN ASSIGN pFieldValue = RowObject.serie-nota.
        WHEN "unid-med-for":U THEN ASSIGN pFieldValue = RowObject.unid-med-for.
        WHEN "cd-referencia":U THEN ASSIGN pFieldValue = RowObject.cd-referencia.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "item-do-forn":U THEN ASSIGN pFieldValue = RowObject.item-do-forn.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
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
        WHEN "perc-dev-forn":U THEN ASSIGN pFieldValue = RowObject.perc-dev-forn.
        WHEN "perc-pont-forn":U THEN ASSIGN pFieldValue = RowObject.perc-pont-forn.
        WHEN "qt-max-ordem":U THEN ASSIGN pFieldValue = RowObject.qt-max-ordem.
        WHEN "rendimento":U THEN ASSIGN pFieldValue = RowObject.rendimento.
        WHEN "niv-qua-ac":U THEN ASSIGN pFieldValue = RowObject.niv-qua-ac.
        WHEN "concentracao":U THEN ASSIGN pFieldValue = RowObject.concentracao.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "fator-conver":U THEN ASSIGN pFieldValue = RowObject.fator-conver.
        WHEN "lote-minimo":U THEN ASSIGN pFieldValue = RowObject.lote-minimo.
        WHEN "lote-mul-for":U THEN ASSIGN pFieldValue = RowObject.lote-mul-for.
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
        WHEN "aval-insp[16]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[16].
        WHEN "classe-repro":U THEN ASSIGN pFieldValue = RowObject.classe-repro.
        WHEN "perc-compra":U THEN ASSIGN pFieldValue = RowObject.perc-compra.
        WHEN "num-casa-dec":U THEN ASSIGN pFieldValue = RowObject.num-casa-dec.
        WHEN "ped-fornec":U THEN ASSIGN pFieldValue = RowObject.ped-fornec.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-mensagem":U THEN ASSIGN pFieldValue = RowObject.cod-mensagem.
        WHEN "conceito":U THEN ASSIGN pFieldValue = RowObject.conceito.
        WHEN "criticidade":U THEN ASSIGN pFieldValue = RowObject.criticidade.
        WHEN "hora-fim":U THEN ASSIGN pFieldValue = RowObject.hora-fim.
        WHEN "hora-ini":U THEN ASSIGN pFieldValue = RowObject.hora-ini.
        WHEN "aval-insp[1]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[1].
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
        WHEN "tempo-ressup":U THEN ASSIGN pFieldValue = RowObject.tempo-ressup.
        WHEN "tp-inspecao":U THEN ASSIGN pFieldValue = RowObject.tp-inspecao.
        WHEN "aval-insp[17]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[17].
        WHEN "aval-insp[18]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[18].
        WHEN "aval-insp[19]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[19].
        WHEN "aval-insp[20]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[20].
        WHEN "aval-insp[21]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[21].
        WHEN "aval-insp[22]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[22].
        WHEN "aval-insp[23]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[23].
        WHEN "aval-insp[24]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[24].
        WHEN "aval-insp[25]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[25].
        WHEN "aval-insp[26]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[26].
        WHEN "aval-insp[27]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[27].
        WHEN "aval-insp[28]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[28].
        WHEN "aval-insp[29]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[29].
        WHEN "aval-insp[30]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[30].
        WHEN "horiz-fixo":U THEN ASSIGN pFieldValue = RowObject.horiz-fixo.
        WHEN "ind-pont":U THEN ASSIGN pFieldValue = RowObject.ind-pont.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "niv-inspecao":U THEN ASSIGN pFieldValue = RowObject.niv-inspecao.
        WHEN "aval-insp[12]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[12].
        WHEN "aval-insp[13]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[13].
        WHEN "aval-insp[14]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[14].
        WHEN "aval-insp[15]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[15].
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
    DEFINE OUTPUT PARAMETER pit-codigo LIKE item-fornec.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE item-fornec.cod-emitente NO-UNDO.

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
        WHEN "reaj-tabela":U THEN ASSIGN pFieldValue = RowObject.reaj-tabela.
        WHEN "contr-forn":U THEN ASSIGN pFieldValue = RowObject.contr-forn.
        WHEN "cot-aut":U THEN ASSIGN pFieldValue = RowObject.cot-aut.
        WHEN "ativo":U THEN ASSIGN pFieldValue = RowObject.ativo.
        WHEN "usa-contrato":U THEN ASSIGN pFieldValue = RowObject.usa-contrato.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter i-abertura as integer no-undo.

    case i-abertura:
        when 1 then 
            run openQueryStatic ("Main":U).
    end case.
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
    OPEN QUERY {&QueryName} FOR EACH {&TableName} where 
                                     {&TableName}.it-codigo = item.it-codigo NO-LOCK, LAST  
                                     ordem-compra use-index compra-forn where 
                                     ordem-compra.cod-emitente =   {&TableName}.cod-emitente and   
                                     ordem-compra.it-codigo    =   {&TableName}.it-codigo and                                        
                                     ordem-compra.num-pedido   <> 0 NO-LOCK INDEXED-REPOSITION. 
     RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint1 DBOProgram 
PROCEDURE setConstraint1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE input parameter p-chave as rowid no-undo. 

  run setConstraintMain (p-chave).  
  
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
    def input param prItem as rowid no-undo.
    
    find first item where rowid(item) = prItem no-lock no-error.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

