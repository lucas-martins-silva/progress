&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS 
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

{include/i-prgvrs.i BOIN01019 2.00.00.004 } /*** "010004" 13/11/2023 11:45:46 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN01019 MAQ}
&ENDIF

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN01019
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ctbz-recebto
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

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d  acessos a todos os registros, exceto os exclu¡dos pela constraint de seguran‡a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin01019.i RowObject}
{inbo/boin01019.i tt-ctbz-recebto}
{include/i_prdvers.i} /* defini‡Æo do pr‚-processador de versÆo do produto */

DEF TEMP-TABLE tt-ctbz-recebto-aux NO-UNDO LIKE ctbz-recebto
    FIELD r-rowid   AS ROWID
    FIELD it-codigo LIKE ITEM.it-codigo.

DEF TEMP-TABLE tt_xml_input_output NO-UNDO
    FIELD ttv_cod_label                    AS CHARACTER FORMAT "x(8)"  LABEL "Label" column-label "Label"
    FIELD ttv_des_conteudo                 AS CHARACTER FORMAT "x(40)" LABEL "Texto" column-label "Texto"
    FIELD ttv_des_conteudo_aux             AS CHARACTER FORMAT "x(40)"
    FIELD ttv_num_seq_1                    AS INTEGER   FORMAT ">>>,>>9"
    INDEX tt_id
          ttv_cod_label    ASCENDING
          ttv_des_conteudo ASCENDING
          ttv_num_seq_1    ASCENDING
    INDEX tt_2
          ttv_cod_label    ASCENDING.  

DEF TEMP-TABLE tt_log_erros NO-UNDO
    FIELD ttv_num_seq                      AS INTEGER   FORMAT ">>>,>>9" LABEL "Sequˆncia" COLUMN-LABEL "Seq"
    FIELD ttv_num_cod_erro                 AS INTEGER   FORMAT ">>>>,>>9" LABEL "N£mero" COLUMN-LABEL "N£mero"
    FIELD ttv_des_erro                     AS CHARACTER FORMAT "x(80)" LABEL "Inconsistˆncia" COLUMN-LABEL "Inconsistˆncia"
    FIELD ttv_des_ajuda                    AS CHARACTER FORMAT "x(100)" LABEL "Ajuda" COLUMN-LABEL "Ajuda".

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

{adbo/boad107.i tt-estabelec} 
{inbo/boin01019.i2}
{ftp/ftapi068.i tt-movto-ctbl} 
{cdp/cdcfgdis.i}
{utp/ut-glob.i}

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-unid-neg":U THEN ASSIGN pFieldValue = RowObject.cod-unid-neg.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "dsl-histor":U THEN ASSIGN pFieldValue = RowObject.dsl-histor.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "referencia":U THEN ASSIGN pFieldValue = RowObject.referencia.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "val-ctbl":U THEN ASSIGN pFieldValue = RowObject.val-ctbl.
        WHEN "val-ctbl-mo[1]":U THEN ASSIGN pFieldValue = RowObject.val-ctbl-mo[1].
        WHEN "val-ctbl-mo[2]":U THEN ASSIGN pFieldValue = RowObject.val-ctbl-mo[2].
        WHEN "val-ctbl-mo[3]":U THEN ASSIGN pFieldValue = RowObject.val-ctbl-mo[3].
        WHEN "val-ctbl-mo[4]":U THEN ASSIGN pFieldValue = RowObject.val-ctbl-mo[4].
        WHEN "val-ctbl-mo[5]":U THEN ASSIGN pFieldValue = RowObject.val-ctbl-mo[5].
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "num-id":U THEN ASSIGN pFieldValue = RowObject.num-id.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
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
  Purpose:     Retorna valores dos campos do ¡ndice ctbz-re-docto
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo sequencia
               retorna valor do campo ct-codigo
               retorna valor do campo sc-codigo
               retorna valor do campo cod-unid-neg
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE ctbz-recebto.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE ctbz-recebto.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE ctbz-recebto.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE ctbz-recebto.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE ctbz-recebto.sequencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pct-codigo LIKE ctbz-recebto.ct-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER psc-codigo LIKE ctbz-recebto.sc-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-unid-neg LIKE ctbz-recebto.cod-unid-neg NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           psequencia = RowObject.sequencia
           pct-codigo = RowObject.ct-codigo
           psc-codigo = RowObject.sc-codigo
           pcod-unid-neg = RowObject.cod-unid-neg.

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
        WHEN "log-ctbzdo":U THEN ASSIGN pFieldValue = RowObject.log-ctbzdo.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTTsAprop DBOProgram 
PROCEDURE getTTsAprop :
/*------------------------------------------------------------------------------
/** Programa: ftapi069.p                                                     **/             
/** Objetivo: Consultar movimentos de apropria‡Æo de FRETE                   **/
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAM pr-cod-estabel  LIKE ctbz-recebto.cod-estabel.
  DEFINE INPUT PARAM pr-ct-codigo    LIKE ctbz-recebto.ct-codigo.
  DEFINE INPUT PARAM pr-sc-codigo    LIKE ctbz-recebto.sc-codigo.
  DEFINE INPUT PARAM pr-dt-trans     LIKE ctbz-recebto.dt-trans.
  DEFINE INPUT PARAM pr-cod-unid-neg LIKE ctbz-recebto.cod-unid-neg.
  
  DEFINE OUTPUT PARAMETER TABLE FOR tt-movto-ctbl.

  DEFINE VARIABLE l-fasb    AS LOGICAL NO-UNDO.
  DEFINE VARIABLE l-cmi     AS LOGICAL NO-UNDO.
  DEFINE VARIABLE i-mo-fasb AS INTEGER NO-UNDO.
  DEFINE VARIABLE i-mo-cmi  AS INTEGER NO-UNDO.

  DEFINE VARIABLE v_cod_estabelec         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE v_cod_empresa           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE v_cod_indic_econ        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE v_cod_finalid_econ      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE v_cod_finalid_econ_fasb AS CHARACTER NO-UNDO.
  DEFINE VARIABLE v_cod_finalid_econ_cmi  AS CHARACTER NO-UNDO.
  
  FIND FIRST param-global NO-LOCK NO-ERROR.
  FIND FIRST param-estoq  NO-LOCK NO-ERROR.

  {cep/ce9990.i} /* Busca moeda fasb no arquivo param-fasb */
  {cep/ce9991.i} /* Busca moeda cmi no arquivo param-fasb  */

  IF l-fasb THEN ASSIGN i-mo-fasb = param-fasb.moeda-fasb.
            ELSE ASSIGN i-mo-fasb = 0.  

  IF l-cmi THEN ASSIGN i-mo-cmi  = param-fasb.moeda-cmi.
           ELSE ASSIGN i-mo-cmi  = 0.
  
  DEFINE VARIABLE i-empresa LIKE param-global.empresa-prin     NO-UNDO.
  
  ASSIGN i-empresa = param-global.empresa-prin.
  
  EMPTY TEMP-TABLE tt-movto-ctbl.
  EMPTY TEMP-TABLE tt_xml_input_output.

  ASSIGN v_cod_finalid_econ      = "":U
         v_cod_finalid_econ_fasb = "":U
         v_cod_finalid_econ_cmi  = "":U.

  FIND estabelec NO-LOCK
     WHERE estabelec.cod-estabel = pr-cod-estabel NO-ERROR.

  CREATE tt_xml_input_output.
  ASSIGN tt_xml_input_output.ttv_cod_label    = "Fun‡Æo":U
         tt_xml_input_output.ttv_des_conteudo = "Contabiliza‡äes 2.00":U
         tt_xml_input_output.ttv_num_seq_1    = 1.

  CREATE tt_xml_input_output.
  ASSIGN tt_xml_input_output.ttv_cod_label    = "Produto":U
         tt_xml_input_output.ttv_des_conteudo = "EMS 5":U
         tt_xml_input_output.ttv_num_seq_1    = 1.

  CREATE tt_xml_input_output.
  ASSIGN tt_xml_input_output.ttv_cod_label    = "Empresa":U
         tt_xml_input_output.ttv_des_conteudo = STRING(estabelec.ep-codigo)
         tt_xml_input_output.ttv_num_seq_1    = 1.

  CREATE tt_xml_input_output.
  ASSIGN tt_xml_input_output.ttv_cod_label    = "Estabel":U
         tt_xml_input_output.ttv_des_conteudo = STRING(pr-cod-estabel)
         tt_xml_input_output.ttv_num_seq_1    = 1.

  CREATE tt_xml_input_output.
  ASSIGN tt_xml_input_output.ttv_cod_label    = "Moeda":U
         tt_xml_input_output.ttv_des_conteudo = "0;" + STRING(pr-dt-trans, "99/99/9999":U)
         tt_xml_input_output.ttv_num_seq_1    = 1.

  CREATE tt_xml_input_output.
  ASSIGN tt_xml_input_output.ttv_cod_label    = "Finalid":U
         tt_xml_input_output.ttv_des_conteudo = "0":U /* Corrente */
         tt_xml_input_output.ttv_num_seq_1    = 1.

  IF l-fasb THEN DO:
    CREATE tt_xml_input_output.
    ASSIGN tt_xml_input_output.ttv_cod_label    = "Finalid":U
           tt_xml_input_output.ttv_des_conteudo = STRING(i-mo-fasb)
           tt_xml_input_output.ttv_num_seq_1    = 2.
  END.

  IF l-cmi THEN DO:
    CREATE tt_xml_input_output.
    ASSIGN tt_xml_input_output.ttv_cod_label    = "Finalid":U
           tt_xml_input_output.ttv_des_conteudo = STRING(i-mo-cmi)
           tt_xml_input_output.ttv_num_seq_1    = 3.
  END.

  RUN prgint/utb/utb786za.py (INPUT-OUTPUT TABLE tt_xml_input_output,
                                    OUTPUT TABLE tt_log_erros).

  FOR EACH tt_xml_input_output:
    IF tt_xml_input_output.ttv_cod_label = "Empresa":U THEN
      ASSIGN v_cod_empresa = tt_xml_input_output.ttv_des_conteudo_aux.

    IF tt_xml_input_output.ttv_cod_label = "Estabel":U THEN
      ASSIGN v_cod_estabelec = tt_xml_input_output.ttv_des_conteudo_aux.

    IF tt_xml_input_output.ttv_cod_label = "Moeda":U THEN
      ASSIGN v_cod_indic_econ = tt_xml_input_output.ttv_des_conteudo_aux.

    IF tt_xml_input_output.ttv_cod_label = "Finalid":U AND 
       tt_xml_input_output.ttv_num_seq_1 = 1 THEN
      ASSIGN v_cod_finalid_econ = tt_xml_input_output.ttv_des_conteudo_aux.

    IF tt_xml_input_output.ttv_cod_label = "Finalid":U AND 
       tt_xml_input_output.ttv_num_seq_1 = 2 THEN
      ASSIGN v_cod_finalid_econ_fasb = tt_xml_input_output.ttv_des_conteudo_aux.

    IF tt_xml_input_output.ttv_cod_label = "Finalid":U AND 
       tt_xml_input_output.ttv_num_seq_1 = 3 THEN
      ASSIGN v_cod_finalid_econ_cmi = tt_xml_input_output.ttv_des_conteudo_aux.

  END.
  
  FOR EACH ctbz-recebto NO-LOCK
     WHERE ctbz-recebto.cod-estabel  = pr-cod-estabel
       AND ctbz-recebto.ct-codigo    = pr-ct-codigo     
       AND ctbz-recebto.sc-codigo    = pr-sc-codigo   
       AND ctbz-recebto.dt-trans     = pr-dt-trans    
       AND ctbz-recebto.cod-unid-neg = pr-cod-unid-neg:
  
      CREATE tt-movto-ctbl.
      ASSIGN tt-movto-ctbl.ep-codigo              = i-empresa
             tt-movto-ctbl.nro-docto              = ctbz-recebto.nro-docto
             tt-movto-ctbl.cod-emitente           = ctbz-recebto.cod-emitente
             tt-movto-ctbl.serie-docto            = ctbz-recebto.serie-docto
             tt-movto-ctbl.nat-operacao           = ctbz-recebto.nat-operacao
             tt-movto-ctbl.num-id-movto-ctbl      = ctbz-recebto.num-id
             tt-movto-ctbl.sequencia              = ctbz-recebto.sequencia
             tt-movto-ctbl.cod-estabel            = ctbz-recebto.cod-estabel
             tt-movto-ctbl.referencia             = ctbz-recebto.referencia
             tt-movto-ctbl.ct-conta               = ctbz-recebto.ct-codigo
             tt-movto-ctbl.sc-conta               = ctbz-recebto.sc-codigo
             tt-movto-ctbl.dt-trans               = ctbz-recebto.dt-trans
             tt-movto-ctbl.valor-cont             = IF ctbz-recebto.val-ctbl <> 0 THEN ctbz-recebto.val-ctbl * -1
                                                                                  ELSE ctbz-recebto.val-ctbl-cred
             tt-movto-ctbl.cod-unid-negoc         = ctbz-recebto.cod-unid-neg
             tt-movto-ctbl.char-1                 = v_cod_finalid_econ.

      IF l-fasb THEN DO:
        CREATE tt-movto-ctbl.
        ASSIGN tt-movto-ctbl.ep-codigo              = i-empresa
               tt-movto-ctbl.nro-docto              = ctbz-recebto.nro-docto
               tt-movto-ctbl.cod-emitente           = ctbz-recebto.cod-emitente
               tt-movto-ctbl.serie-docto            = ctbz-recebto.serie-docto
               tt-movto-ctbl.nat-operacao           = ctbz-recebto.nat-operacao
               tt-movto-ctbl.num-id-movto-ctbl      = ctbz-recebto.num-id
               tt-movto-ctbl.sequencia              = ctbz-recebto.sequencia
               tt-movto-ctbl.cod-estabel            = ctbz-recebto.cod-estabel
               tt-movto-ctbl.referencia             = ctbz-recebto.referencia
               tt-movto-ctbl.ct-conta               = ctbz-recebto.ct-codigo
               tt-movto-ctbl.sc-conta               = ctbz-recebto.sc-codigo
               tt-movto-ctbl.dt-trans               = ctbz-recebto.dt-trans
               tt-movto-ctbl.valor-cont             = IF ctbz-recebto.val-ctbl-mo[1] <> 0 THEN ctbz-recebto.val-ctbl-mo[1] * -1
                                                                                          ELSE ctbz-recebto.val-ctbl-cred-mo[1]
               tt-movto-ctbl.cod-unid-negoc         = ctbz-recebto.cod-unid-neg
               tt-movto-ctbl.char-1                 = v_cod_finalid_econ_fasb.
      END.

      IF l-cmi THEN DO:
        CREATE tt-movto-ctbl.
        ASSIGN tt-movto-ctbl.ep-codigo              = i-empresa
               tt-movto-ctbl.nro-docto              = ctbz-recebto.nro-docto
               tt-movto-ctbl.cod-emitente           = ctbz-recebto.cod-emitente
               tt-movto-ctbl.serie-docto            = ctbz-recebto.serie-docto
               tt-movto-ctbl.nat-operacao           = ctbz-recebto.nat-operacao
               tt-movto-ctbl.num-id-movto-ctbl      = ctbz-recebto.num-id
               tt-movto-ctbl.sequencia              = ctbz-recebto.sequencia
               tt-movto-ctbl.cod-estabel            = ctbz-recebto.cod-estabel
               tt-movto-ctbl.referencia             = ctbz-recebto.referencia
               tt-movto-ctbl.ct-conta               = ctbz-recebto.ct-codigo
               tt-movto-ctbl.sc-conta               = ctbz-recebto.sc-codigo
               tt-movto-ctbl.dt-trans               = ctbz-recebto.dt-trans
               tt-movto-ctbl.valor-cont             = IF ctbz-recebto.val-ctbl-mo[2] <> 0 THEN ctbz-recebto.val-ctbl-mo[2] * -1
                                                                                          ELSE ctbz-recebto.val-ctbl-cred-mo[2]
               tt-movto-ctbl.cod-unid-negoc         = ctbz-recebto.cod-unid-neg
               tt-movto-ctbl.char-1                 = v_cod_finalid_econ_cmi.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram  
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice ctbz-re-docto
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo sequencia
               recebe valor do campo ct-codigo
               recebe valor do campo sc-codigo
               recebe valor do campo cod-unid-neg
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE ctbz-recebto.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE ctbz-recebto.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE ctbz-recebto.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE ctbz-recebto.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE ctbz-recebto.sequencia NO-UNDO.
    DEFINE INPUT PARAMETER pct-codigo LIKE ctbz-recebto.ct-codigo NO-UNDO.
    DEFINE INPUT PARAMETER psc-codigo LIKE ctbz-recebto.sc-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-unid-neg LIKE ctbz-recebto.cod-unid-neg NO-UNDO.

    FIND FIRST bfctbz-recebto WHERE 
        bfctbz-recebto.serie-docto = pserie-docto AND 
        bfctbz-recebto.nro-docto = pnro-docto AND 
        bfctbz-recebto.cod-emitente = pcod-emitente AND 
        bfctbz-recebto.nat-operacao = pnat-operacao AND 
        bfctbz-recebto.sequencia = psequencia AND 
        bfctbz-recebto.ct-codigo = pct-codigo AND 
        bfctbz-recebto.sc-codigo = psc-codigo AND 
        bfctbz-recebto.cod-unid-neg = pcod-unid-neg NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfctbz-recebto THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfctbz-recebto)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE contabilizacaoGFE DBOProgram 
PROCEDURE contabilizacaoGFE :
/*:T------------------------------------------------------------------------------
  Purpose:     Desviar a CEAPI e contabilizar os Fretes do GFE
  Parameters:  ROWID da docum-est
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM r-docum-est AS ROWID NO-UNDO.
    DEFINE INPUT PARAM TABLE FOR tt-movto.
    
    DEFINE VARIABLE h-boin879 AS HANDLE  NO-UNDO.
    DEFINE VARIABLE l-fasb    AS LOGICAL NO-UNDO.
    DEFINE VARIABLE l-cmi     AS LOGICAL NO-UNDO.
    DEFINE VARIABLE i-mo-fasb AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-mo-cmi  AS INTEGER NO-UNDO.

    FIND FIRST param-global NO-LOCK NO-ERROR.
    FIND FIRST param-estoq  NO-LOCK NO-ERROR.

    {cep/ce9990.i} /* Busca moeda fasb no arquivo param-fasb */
    {cep/ce9991.i} /* Busca moeda cmi no arquivo param-fasb  */

    FIND docum-est WHERE ROWID(docum-est) = r-docum-est NO-LOCK NO-ERROR.

    IF NOT AVAIL(docum-est) OR (docum-est.ce-atual = YES) THEN 
        RETURN.

    FOR FIRST estabelec FIELDS(cod-estabel) NO-LOCK
        WHERE estabelec.cod-estabel = docum-est.cod-estabel:

        IF NOT AVAIL tt-estabelec THEN DO:
            CREATE tt-estabelec.
            BUFFER-COPY estabelec TO tt-estabelec.
        END.
        
        FIND FIRST tt-estabelec WHERE tt-estabelec.cod-estabel = estabelec.cod-estabel NO-ERROR.

        IF NOT AVAIL(tt-estabelec)THEN 
            RETURN.    

        IF tt-estabelec.log-livre-1 = YES THEN DO:
            /*inicializaþÒo do handle neste ponto para evitar 
              erro caso nÒo tenha sido efetuado a aplicaþÒo do delta 
              com a tabela estab-ctas-impto */ 		  
            IF NOT VALID-HANDLE(h-boin879) THEN
                RUN inbo/boin879.p PERSISTENT SET h-boin879.
                
            RUN busca-ctas-impto IN h-boin879 (INPUT docum-est.dt-trans,
                                               INPUT-OUTPUT TABLE tt-estabelec).
        END.

        FIND FIRST tt-estabelec WHERE tt-estabelec.cod-estabel = estabelec.cod-estabel NO-ERROR.

        IF NOT AVAIL(tt-estabelec)THEN 
            RETURN.    
        
    END.

    FOR EACH tt-movto NO-LOCK
       WHERE tt-movto.serie-docto  = docum-est.serie-docto 
         AND tt-movto.nro-docto    = docum-est.nro-docto 
         AND tt-movto.cod-emitente = docum-est.cod-emitente       
         AND tt-movto.nat-operacao = docum-est.nat-operacao:

        /******* ITEM DD nao precisa conta saldo ********/

        /*Conta aplicaþÒo/despesa*/

        RUN criaLancamento (INPUT tt-movto.ct-db,
	    					INPUT tt-movto.sc-db,
	    					INPUT tt-movto.cod-unid-negoc).
        
        IF  tt-movto.tipo-trans = 1 THEN DO:      /*Entrada*/
            ASSIGN ctbz-recebto.val-ctbl = ctbz-recebto.val-ctbl  
                                          + tt-movto.valor-mat-m[1]
                                          + tt-movto.valor-mob-m[1]
                                          + tt-movto.valor-ggf-m[1].

            IF l-fasb THEN
                ASSIGN ctbz-recebto.val-ctbl-mo[1] = ctbz-recebto.val-ctbl-mo[1]  
                                                     + tt-movto.valor-mat-m[i-mo-fasb]
                                                     + tt-movto.valor-mob-m[i-mo-fasb]
                                                     + tt-movto.valor-ggf-m[i-mo-fasb].

            IF l-cmi THEN
                ASSIGN ctbz-recebto.val-ctbl-mo[2] = ctbz-recebto.val-ctbl-mo[2]
                                                     + tt-movto.valor-mat-m[i-mo-cmi]
                                                     + tt-movto.valor-mob-m[i-mo-cmi]
                                                     + tt-movto.valor-ggf-m[i-mo-cmi].

        END.
        ELSE DO:                                  /*Saída*/  
            ASSIGN ctbz-recebto.val-ctbl-cred = ctbz-recebto.val-ctbl-cred
                                               + tt-movto.valor-mat-m[1]
                                               + tt-movto.valor-mob-m[1]
                                               + tt-movto.valor-ggf-m[1].

            IF l-fasb THEN
                ASSIGN ctbz-recebto.val-ctbl-cred-mo[1] = ctbz-recebto.val-ctbl-cred-mo[1]  
                                                         + tt-movto.valor-mat-m[i-mo-fasb]
                                                         + tt-movto.valor-mob-m[i-mo-fasb]
                                                         + tt-movto.valor-ggf-m[i-mo-fasb].

            IF l-cmi THEN
                ASSIGN ctbz-recebto.val-ctbl-cred-mo[2] = ctbz-recebto.val-ctbl-cred-mo[2]
                                                         + tt-movto.valor-mat-m[i-mo-cmi]
                                                         + tt-movto.valor-mob-m[i-mo-cmi]
                                                         + tt-movto.valor-ggf-m[i-mo-cmi].

        END.
        /*armazena informa‡äes da conta de contra partida - necessarias para o Sped*/
        &IF "{&product_version}" > "12.1.C":U &THEN /*12.1.13*/
            ASSIGN ctbz-recebto.cod-cta-cpart      = tt-movto.ct-codigo 
                   ctbz-recebto.cod-subconta-cpart = tt-movto.sc-codigo.
        &ELSE
            ASSIGN OVERLAY(ctbz-recebto.cod-livre-1,1,20)  = tt-movto.ct-codigo      
                   OVERLAY(ctbz-recebto.cod-livre-1,21,20) = tt-movto.sc-codigo.
        &ENDIF


        /*Conta transitória*/
        RUN criaLancamento (INPUT tt-movto.ct-codigo,
	    					INPUT tt-movto.sc-codigo,
	    					INPUT tt-movto.cod-unid-negoc).
        
        IF  tt-movto.tipo-trans = 1 THEN DO:
            ASSIGN ctbz-recebto.val-ctbl-cred = ctbz-recebto.val-ctbl-cred
                                               + tt-movto.valor-mat-m[1]
                                               + tt-movto.valor-mob-m[1]
                                               + tt-movto.valor-ggf-m[1]
                                               + tt-movto.valor-icm
                                               + tt-movto.valor-ipi
                                               + tt-movto.valor-mob-p[1]  /* PIS */
                                               + tt-movto.valor-ggf-p[1]. /* cofins */
            IF l-fasb THEN
                ASSIGN ctbz-recebto.val-ctbl-cred-mo[1] =  ctbz-recebto.val-ctbl-cred-mo[1]  
                                                         + tt-movto.valor-mat-m[i-mo-fasb]
                                                         + tt-movto.valor-mob-m[i-mo-fasb]
                                                         + tt-movto.valor-ggf-m[i-mo-fasb]
                                                         + tt-movto.vl-icm-fasb[1]
                                                         + tt-movto.vl-ipi-fasb[1]
                                                         + tt-movto.valor-mob-p[i-mo-fasb]  /* PIS */
                                                         + tt-movto.valor-ggf-p[i-mo-fasb]. /* cofins */
            IF l-cmi THEN
                ASSIGN ctbz-recebto.val-ctbl-cred-mo[2] = ctbz-recebto.val-ctbl-cred-mo[2]
                                                        + tt-movto.valor-mat-m[i-mo-cmi]
                                                        + tt-movto.valor-mob-m[i-mo-cmi]
                                                        + tt-movto.valor-ggf-m[i-mo-cmi]
                                                        + tt-movto.vl-icm-fasb[2]
                                                        + tt-movto.vl-ipi-fasb[2]
                                                        + tt-movto.valor-mob-p[i-mo-cmi]  /* PIS */
                                                        + tt-movto.valor-ggf-p[i-mo-cmi]. /* cofins */

        END.
        ELSE DO:
             ASSIGN ctbz-recebto.val-ctbl = ctbz-recebto.val-ctbl
                                           + tt-movto.valor-mat-m[1]
                                           + tt-movto.valor-mob-m[1]
                                           + tt-movto.valor-ggf-m[1]
                                           + tt-movto.valor-icm
                                           + tt-movto.valor-ipi
                                           + tt-movto.valor-mob-p[1]  /* PIS */     
                                           + tt-movto.valor-ggf-p[1]. /* cofins */

            IF l-fasb THEN
                ASSIGN ctbz-recebto.val-ctbl-mo[1] = ctbz-recebto.val-ctbl-mo[1]  
                                                   + tt-movto.valor-mat-m[i-mo-fasb]
                                                   + tt-movto.valor-mob-m[i-mo-fasb]
                                                   + tt-movto.valor-ggf-m[i-mo-fasb]
                                                   + tt-movto.vl-icm-fasb[1]
                                                   + tt-movto.vl-ipi-fasb[1]
                                                   + tt-movto.valor-mob-p[i-mo-fasb]  /* PIS */
                                                   + tt-movto.valor-ggf-p[i-mo-fasb]. /* cofins */

            IF l-cmi THEN
                ASSIGN ctbz-recebto.val-ctbl-mo[2] = ctbz-recebto.val-ctbl-mo[2]
                                                   + tt-movto.valor-mat-m[i-mo-cmi]
                                                   + tt-movto.valor-mob-m[i-mo-cmi]
                                                   + tt-movto.valor-ggf-m[i-mo-cmi]
                                                   + tt-movto.vl-icm-fasb[2]
                                                   + tt-movto.vl-ipi-fasb[2]
                                                   + tt-movto.valor-mob-p[i-mo-cmi]  /* PIS */
                                                   + tt-movto.valor-ggf-p[i-mo-cmi]. /* cofins */

        END.
        
        /*ICM*/
        IF  tt-movto.valor-icm <> 0 THEN DO:
	    	RUN criaLancamento (INPUT tt-estabelec.ct-icm,
	    						INPUT tt-estabelec.sc-icm,
	    						INPUT tt-movto.cod-unid-negoc).	
	    					
            IF  tt-movto.tipo-trans = 1 THEN
                ASSIGN ctbz-recebto.val-ctbl  = ctbz-recebto.val-ctbl + tt-movto.valor-icm.
            ELSE
                ASSIGN ctbz-recebto.val-ctbl-cred = ctbz-recebto.val-ctbl-cred + tt-movto.valor-icm.

            IF l-fasb AND tt-movto.vl-icm-fasb[1] <> 0 THEN DO:
                IF  tt-movto.tipo-trans = 1 THEN 
                    ASSIGN ctbz-recebto.val-ctbl-mo[1] = ctbz-recebto.val-ctbl-mo[1] + tt-movto.vl-icm-fasb[1].
                ELSE
                    ASSIGN ctbz-recebto.val-ctbl-cred-mo[1] = ctbz-recebto.val-ctbl-cred-mo[1] + tt-movto.vl-icm-fasb[1].
            END.

            IF l-cmi AND tt-movto.vl-icm-fasb[2] <> 0 THEN DO:
                IF  tt-movto.tipo-trans = 1 THEN 
                    ASSIGN ctbz-recebto.val-ctbl-mo[2] = ctbz-recebto.val-ctbl-mo[2] + tt-movto.vl-icm-fasb[2].
                ELSE
                    ASSIGN ctbz-recebto.val-ctbl-cred-mo[2] = ctbz-recebto.val-ctbl-cred-mo[2] + tt-movto.vl-icm-fasb[2].
            END.
            /*armazena informa‡äes da conta de contra partida - necessarias para o Sped*/
            &IF "{&product_version}" > "12.1.C":U &THEN /*12.1.13*/
                ASSIGN ctbz-recebto.cod-cta-cpart      = tt-movto.ct-codigo 
                       ctbz-recebto.cod-subconta-cpart = tt-movto.sc-codigo.
            &ELSE
                ASSIGN OVERLAY(ctbz-recebto.cod-livre-1,1,20)  = tt-movto.ct-codigo      
                       OVERLAY(ctbz-recebto.cod-livre-1,21,20) = tt-movto.sc-codigo.
            &ENDIF
        END.    
        
        /*IPI*/
        IF  tt-movto.valor-ipi <> 0 THEN DO:
	    	RUN criaLancamento (INPUT tt-estabelec.ct-ipi,
	    						INPUT tt-estabelec.sc-ipi,
	    						INPUT tt-movto.cod-unid-negoc).		
        
            IF  tt-movto.tipo-trans = 1 THEN
                ASSIGN ctbz-recebto.val-ctbl  = ctbz-recebto.val-ctbl + tt-movto.valor-ipi.
            ELSE
                ASSIGN ctbz-recebto.val-ctbl-cred = ctbz-recebto.val-ctbl-cred + tt-movto.valor-ipi.

            IF l-fasb AND tt-movto.vl-ipi-fasb[1] <> 0 THEN DO:
                IF  tt-movto.tipo-trans = 1 THEN 
                    ASSIGN ctbz-recebto.val-ctbl-mo[1] = ctbz-recebto.val-ctbl-mo[1] + tt-movto.vl-ipi-fasb[1].
                ELSE
                    ASSIGN ctbz-recebto.val-ctbl-cred-mo[1] = ctbz-recebto.val-ctbl-cred-mo[1] + tt-movto.vl-ipi-fasb[1].
            END.

            IF l-cmi AND tt-movto.vl-ipi-fasb[2] <> 0 THEN DO:
                IF  tt-movto.tipo-trans = 1 THEN 
                    ASSIGN ctbz-recebto.val-ctbl-mo[2] = ctbz-recebto.val-ctbl-mo[2] + tt-movto.vl-ipi-fasb[2].
                ELSE
                    ASSIGN ctbz-recebto.val-ctbl-cred-mo[2] = ctbz-recebto.val-ctbl-cred-mo[2] + tt-movto.vl-ipi-fasb[2].
            END.
            /*armazena informa‡äes da conta de contra partida - necessarias para o Sped*/
            &IF "{&product_version}" > "12.1.C":U &THEN /*12.1.13*/
                ASSIGN ctbz-recebto.cod-cta-cpart      = tt-movto.ct-codigo 
                       ctbz-recebto.cod-subconta-cpart = tt-movto.sc-codigo.
            &ELSE
                ASSIGN OVERLAY(ctbz-recebto.cod-livre-1,1,20)  = tt-movto.ct-codigo
                       OVERLAY(ctbz-recebto.cod-livre-1,21,20) = tt-movto.sc-codigo.
            &ENDIF
        END.
        
	    IF tt-movto.valor-mob-p[1]  /* PIS */  <> 0 THEN DO:
	        RUN criaLancamento (INPUT tt-estabelec.cod-cta-pis-recup,
	        					INPUT tt-estabelec.cod-ccusto-pis-recup,
	        					INPUT tt-movto.cod-unid-negoc).			
        
	    	IF  tt-movto.tipo-trans = 1 THEN
	    		ASSIGN ctbz-recebto.val-ctbl  = ctbz-recebto.val-ctbl + tt-movto.valor-mob-p[1].
	    	ELSE
	    		ASSIGN ctbz-recebto.val-ctbl-cred = ctbz-recebto.val-ctbl-cred + tt-movto.valor-mob-p[1].

            IF l-fasb AND tt-movto.valor-mob-p[i-mo-fasb] <> 0 THEN DO:
                IF  tt-movto.tipo-trans = 1 THEN 
                    ASSIGN ctbz-recebto.val-ctbl-mo[1] = ctbz-recebto.val-ctbl-mo[1] + tt-movto.valor-mob-p[i-mo-fasb].
                ELSE
                    ASSIGN ctbz-recebto.val-ctbl-cred-mo[1] = ctbz-recebto.val-ctbl-cred-mo[1] + tt-movto.valor-mob-p[i-mo-fasb].
            END.

            IF l-cmi AND tt-movto.valor-mob-p[i-mo-cmi] <> 0 THEN DO:
                IF  tt-movto.tipo-trans = 1 THEN 
                    ASSIGN ctbz-recebto.val-ctbl-mo[2] = ctbz-recebto.val-ctbl-mo[2] + tt-movto.valor-mob-p[i-mo-cmi].
                ELSE
                    ASSIGN ctbz-recebto.val-ctbl-cred-mo[2] = ctbz-recebto.val-ctbl-cred-mo[2] + tt-movto.valor-mob-p[i-mo-cmi].
            END.
            /*armazena informa‡äes da conta de contra partida - necessarias para o Sped*/
            &IF "{&product_version}" > "12.1.C":U &THEN /*12.1.13*/
                ASSIGN ctbz-recebto.cod-cta-cpart      = tt-movto.ct-codigo 
                       ctbz-recebto.cod-subconta-cpart = tt-movto.sc-codigo.
            &ELSE
                ASSIGN OVERLAY(ctbz-recebto.cod-livre-1,1,20)  = tt-movto.ct-codigo      
                       OVERLAY(ctbz-recebto.cod-livre-1,21,20) = tt-movto.sc-codigo.
            &ENDIF

	    END.
        
	    IF tt-movto.valor-ggf-p[1]  /* cofins */  <> 0 THEN DO:
	        RUN criaLancamento (INPUT tt-estabelec.cod-cta-cofins-recup,
	        					INPUT tt-estabelec.cod-ccusto-cofins-recup,
	        					INPUT tt-movto.cod-unid-negoc).
        
	    	IF  tt-movto.tipo-trans = 1 THEN
	    		ASSIGN ctbz-recebto.val-ctbl  = ctbz-recebto.val-ctbl + tt-movto.valor-ggf-p[1].
                
	    	ELSE
	    		ASSIGN ctbz-recebto.val-ctbl-cred = ctbz-recebto.val-ctbl-cred + tt-movto.valor-ggf-p[1].

            IF l-fasb AND tt-movto.valor-ggf-p[i-mo-fasb] <> 0 THEN DO:
                IF  tt-movto.tipo-trans = 1 THEN 
                    ASSIGN ctbz-recebto.val-ctbl-mo[1] = ctbz-recebto.val-ctbl-mo[1] + tt-movto.valor-ggf-p[i-mo-fasb].
                ELSE
                    ASSIGN ctbz-recebto.val-ctbl-cred-mo[1] = ctbz-recebto.val-ctbl-cred-mo[1] + tt-movto.valor-ggf-p[i-mo-fasb].
            END.

            IF l-cmi AND tt-movto.valor-ggf-p[i-mo-cmi] <> 0 THEN DO:
                IF  tt-movto.tipo-trans = 1 THEN 
                    ASSIGN ctbz-recebto.val-ctbl-mo[2] = ctbz-recebto.val-ctbl-mo[2] + tt-movto.valor-ggf-p[i-mo-cmi].
                ELSE
                    ASSIGN ctbz-recebto.val-ctbl-cred-mo[2] = ctbz-recebto.val-ctbl-cred-mo[2] + tt-movto.valor-ggf-p[i-mo-cmi].
            END.
            /*armazena informa‡äes da conta de contra partida - necessarias para o Sped*/
            &IF "{&product_version}" > "12.1.C":U &THEN /*12.1.13*/
                ASSIGN ctbz-recebto.cod-cta-cpart      = tt-movto.ct-codigo 
                       ctbz-recebto.cod-subconta-cpart = tt-movto.sc-codigo.
            &ELSE
                ASSIGN OVERLAY(ctbz-recebto.cod-livre-1,1,20)  = tt-movto.ct-codigo
                       OVERLAY(ctbz-recebto.cod-livre-1,21,20) = tt-movto.sc-codigo.
            &ENDIF
	    END.

    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaLancamento DBOProgram 
PROCEDURE criaLancamento :
/*:T------------------------------------------------------------------------------
------------------------------------------------------------------------------*/

    DEF INPUT PARAM c-ct-codigo   	 LIKE ctbz-recebto.ct-codigo  	NO-UNDO.
    DEF INPUT PARAM c-sc-codigo   	 LIKE ctbz-recebto.sc-codigo    NO-UNDO.
    DEF INPUT PARAM c-cod-unid-negoc LIKE ctbz-recebto.cod-unid-neg NO-UNDO.

    FIND ctbz-recebto 
        WHERE ctbz-recebto.serie-docto    = docum-est.serie-docto
          AND ctbz-recebto.nro-docto      = docum-est.nro-docto
          AND ctbz-recebto.cod-emitente   = tt-movto.cod-emitente 
          AND ctbz-recebto.nat-operacao   = tt-movto.nat-operacao
          AND ctbz-recebto.sequencia      = tt-movto.sequen-nf
          AND ctbz-recebto.dt-trans       = tt-movto.dt-trans
          AND ctbz-recebto.cod-estabel    = tt-movto.cod-estabel 
          AND ctbz-recebto.ct-codigo      = c-ct-codigo
          AND ctbz-recebto.sc-codigo      = c-sc-codigo
          AND ctbz-recebto.cod-unid-neg   = c-cod-unid-negoc EXCLUSIVE-LOCK NO-ERROR.

	IF NOT AVAIL ctbz-recebto THEN DO:

		CREATE ctbz-recebto.
		ASSIGN ctbz-recebto.serie-docto    = docum-est.serie-docto 
			   ctbz-recebto.nro-docto      = docum-est.nro-docto   
			   ctbz-recebto.cod-emitente   = tt-movto.cod-emitente 
			   ctbz-recebto.nat-operacao   = tt-movto.nat-operacao   
               ctbz-recebto.sequencia      = tt-movto.sequen-nf    /* item-doc-est.sequencia */
               ctbz-recebto.dt-trans       = tt-movto.dt-trans
               ctbz-recebto.cod-estabel    = tt-movto.cod-estabel 
               ctbz-recebto.ct-codigo      = c-ct-codigo           
               ctbz-recebto.sc-codigo      = c-sc-codigo           
               ctbz-recebto.cod-unid-neg   = c-cod-unid-negoc.

	END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE descontabilizacaoGFE DBOProgram 
PROCEDURE descontabilizacaoGFE :
/*:T------------------------------------------------------------------------------
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM r-docum-est AS ROWID   NO-UNDO.

    FIND docum-est WHERE ROWID(docum-est) = r-docum-est NO-LOCK NO-ERROR.

    IF NOT AVAIL(docum-est) THEN 
        RETURN "NOK":U.
    
    IF CAN-FIND(FIRST ctbz-recebto
                WHERE ctbz-recebto.serie-docto  = docum-est.serie-docto
                  AND ctbz-recebto.nro-docto    = docum-est.nro-docto
                  AND ctbz-recebto.cod-emitente = docum-est.cod-emitente
                  AND ctbz-recebto.nat-operacao = docum-est.nat-operacao
                  AND ctbz-recebto.log-ctbzdo) THEN DO:  /*Caso já esteja contabilizado, não deixa desatualizar o documento'*/

        {method/svc/errors/inserr.i 
                &ErrorNumber="1279"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"} 

    END.
    ELSE DO:

        FOR EACH ctbz-recebto EXCLUSIVE-LOCK 
            WHERE ctbz-recebto.serie-docto  = docum-est.serie-docto
              AND ctbz-recebto.nro-docto    = docum-est.nro-docto
              AND ctbz-recebto.cod-emitente = docum-est.cod-emitente
              AND ctbz-recebto.nat-operacao = docum-est.nat-operacao:
                
            DELETE ctbz-recebto.
        
        END.

    END.
 
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaTrocaControleItDD DBOProgram 
PROCEDURE verificaTrocaControleItDD :
/*:T------------------------------------------------------------------------------
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAM c-it-codigo LIKE item.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAM l-troca-ok  AS LOGICAL          NO-UNDO.

    DEFINE VARIABLE l-item-dd          AS LOGICAL NO-UNDO. /* Itens de débito direto  */

    /*verifica se GFE e função no RE0103 está ativa*/
    IF AVAIL param-estoq 
       AND SUBSTRING(param-estoq.char-1,29,1) <> "S":U THEN DO:
    
        ASSIGN l-troca-ok = YES. /*funções desativadas, poderá trocar tipo de controle*/
        RETURN "OK":U.

    END.

    IF CAN-FIND(FIRST item-doc-est
                WHERE item-doc-est.it-codigo = c-it-codigo) THEN DO:

        ASSIGN l-troca-ok = YES.

        FOR EACH docum-est FIELDS(origem cod-emitente serie-docto nat-operacao nro-docto) NO-LOCK
            WHERE docum-est.ce-atual = NO:

            IF l-troca-ok = NO THEN
                LEAVE.

            IF docum-est.origem <> "G":U THEN
                NEXT.

            ASSIGN l-item-dd = YES.

            IF NOT CAN-FIND(FIRST item-doc-est
                            WHERE item-doc-est.cod-emitente = docum-est.cod-emitente            
                              AND item-doc-est.serie-docto  = docum-est.serie-docto 
                              AND item-doc-est.nat-operacao = docum-est.nat-operacao
                              AND item-doc-est.nro-docto    = docum-est.nro-docto
                              AND item-doc-est.it-codigo    = c-it-codigo) THEN
                NEXT.

            FOR EACH item-doc-est FIELDS(it-codigo) NO-LOCK
                WHERE item-doc-est.cod-emitente = docum-est.cod-emitente 
                  AND item-doc-est.serie-docto  = docum-est.serie-docto  
                  AND item-doc-est.nat-operacao = docum-est.nat-operacao 
                  AND item-doc-est.nro-docto    = docum-est.nro-docto:

                FOR FIRST item FIELDS(tipo-contr it-codigo) NO-LOCK
                    WHERE item.it-codigo = item-doc-est.it-codigo:

                    /* verifica se todos os itens do documento são de débito direto */
                    IF item.tipo-contr <> 4 THEN /* 4 - débito direto */
                        ASSIGN l-item-dd = NO.
        
                END.
    
            END.

            IF l-item-dd THEN 
                ASSIGN l-troca-ok = NO.
            ELSE 
                ASSIGN l-troca-ok = YES.

        END.

    END.
    ELSE    /*item não utilizado no recebimento*/
        ASSIGN l-troca-ok = YES.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGradeContabil DBOProgram 
PROCEDURE piRetornaGradeContabil :
/*:T------------------------------------------------------------------------------
  Purpose:     Retornar a grade cont bil do documento
  Parameters:  chave do documento
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pc-serie-docto  LIKE ctbz-recebto.serie-docto  NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nro-docto    LIKE ctbz-recebto.nro-docto    NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cod-emitente LIKE ctbz-recebto.cod-emitente NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nat-operacao LIKE ctbz-recebto.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-ctbz-recebto-aux .

    FOR EACH tt-ctbz-recebto-aux:
        DELETE tt-ctbz-recebto-aux .
    END.

    FOR EACH ctbz-recebto
       WHERE ctbz-recebto.serie-docto  = pc-serie-docto
         AND ctbz-recebto.nro-docto    = pc-nro-docto
         AND ctbz-recebto.cod-emitente = pi-cod-emitente
         AND ctbz-recebto.nat-operacao = pc-nat-operacao NO-LOCK:

        CREATE tt-ctbz-recebto-aux.
        BUFFER-COPY ctbz-recebto TO tt-ctbz-recebto-aux.

        FIND FIRST item-doc-est
             WHERE item-doc-est.serie-docto  = ctbz-recebto.serie-docto
               AND item-doc-est.nro-docto    = ctbz-recebto.nro-docto
               AND item-doc-est.cod-emitente = ctbz-recebto.cod-emitente
               AND item-doc-est.nat-operacao = ctbz-recebto.nat-operacao
               AND item-doc-est.sequencia    = ctbz-recebto.sequencia NO-LOCK NO-ERROR.
        IF AVAIL item-doc-est THEN
            ASSIGN tt-ctbz-recebto-aux.it-codigo = item-doc-est.it-codigo.
        ELSE
            ASSIGN tt-ctbz-recebto-aux.it-codigo = "".

    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaPeriodo DBOProgram 
PROCEDURE piRetornaPeriodo :
/*:T------------------------------------------------------------------------------
  Purpose:     Retornar o per¡odo que foi contabilizado para o estabelecimento
  Parameters:  chave do documento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-cod-estabelec LIKE estabelec.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pda-iniper-x     AS   DATE                  NO-UNDO.
    DEFINE OUTPUT PARAMETER pda-fimper-x     AS   DATE                  NO-UNDO.

    DEFINE VARIABLE d-dt-trans      AS DATE                      NO-UNDO.
    DEFINE VARIABLE i-ano           AS INTEGER FORMAT "9999":U   NO-UNDO.
    DEFINE VARIABLE i-mes           AS INTEGER FORMAT "99":U     NO-UNDO.
    DEFINE VARIABLE i-dia           AS INTEGER FORMAT   "99":U   NO-UNDO.
    DEFINE VARIABLE da-iniper-fech  LIKE ctbz-recebto.dt-trans   NO-UNDO.
    DEFINE VARIABLE da-fimper-fech  LIKE ctbz-recebto.dt-trans   NO-UNDO.

    FIND LAST ctbz-recebto
        WHERE ctbz-recebto.cod-estabel = pc-cod-estabelec
          AND ctbz-recebto.log-ctbzdo  = YES NO-LOCK NO-ERROR.
    IF AVAIL ctbz-recebto THEN
        ASSIGN d-dt-trans = ctbz-recebto.dt-trans.
    ELSE
        ASSIGN d-dt-trans = TODAY.

    ASSIGN i-ano = INT(YEAR(d-dt-trans))
           i-mes = INT(MONTH(d-dt-trans))
           i-dia = INT(DAY(d-dt-trans)).

    RUN cdp/cdapi005.p (INPUT  STRING(i-ano,"9999":U) + STRING(i-mes,"99":U),
                        OUTPUT pda-iniper-x,
                        OUTPUT pda-fimper-x,
                        OUTPUT i-mes,
                        OUTPUT i-ano,
                        OUTPUT da-iniper-fech,
                        OUTPUT da-fimper-fech).    

    if i-mes = ? or                                               
       i-ano = 0 then do:                                             
       {method/svc/errors/inserr.i
                          &ErrorNumber="16459"
                          &ErrorType="EMS"
                          &ErrorSubType="ERROR"
                          &ErrorParameters="''"}
                  
        RETURN "NOK":U.                  
    end.       

    RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
