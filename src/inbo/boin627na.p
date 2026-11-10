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
{include/i-prgvrs.i BOIN627NA 2.00.00.006} /* 24/11/2023 13:25:24 */

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN627NA MUT}
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
&GLOBAL-DEFINE DBOName usuar-mater
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName usuar-mater
&GLOBAL-DEFINE TableLabel usuar-mater
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{inbo/boin627na.i RowObject}
{bhp/bh9999.i1}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE h_api_ccusto AS HANDLE      NO-UNDO.

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
     FIELD ttv_num_cod_erro AS integer INITIAL ?
     FIELD ttv_des_msg_ajuda AS character INITIAL ?
     FIELD ttv_des_msg_erro AS character INITIAL ?.

DEFINE TEMP-TABLE tt-erro NO-UNDO 
    FIELD i-sequen AS INTEGER
    FIELD cd-erro  AS INTEGER
    FIELD mensagem AS CHARACTER FORMAT "x(255)":U
    FIELD c-param  AS CHARACTER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram

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
         HEIGHT             = 2.01
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
        WHEN "nome-usuar":U THEN ASSIGN pFieldValue = RowObject.nome-usuar.
        WHEN "ramal[1]":U THEN ASSIGN pFieldValue = RowObject.ramal[1].
        WHEN "ramal[2]":U THEN ASSIGN pFieldValue = RowObject.ramal[2].
        WHEN "ramal-fax":U THEN ASSIGN pFieldValue = RowObject.ramal-fax.
        WHEN "ramal-modem":U THEN ASSIGN pFieldValue = RowObject.ramal-modem.
        WHEN "telefax":U THEN ASSIGN pFieldValue = RowObject.telefax.
        WHEN "telefone[1]":U THEN ASSIGN pFieldValue = RowObject.telefone[1].
        WHEN "telefone[2]":U THEN ASSIGN pFieldValue = RowObject.telefone[2].
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "cod-grp-compra":U THEN ASSIGN pFieldValue = RowObject.cod-grp-compra.
        WHEN "cod-usuario":U THEN ASSIGN pFieldValue = RowObject.cod-usuario.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "e-mail":U THEN ASSIGN pFieldValue = RowObject.e-mail.
        WHEN "home-page":U THEN ASSIGN pFieldValue = RowObject.home-page.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "telef-modem":U THEN ASSIGN pFieldValue = RowObject.telef-modem.
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
        WHEN "lim-requis":U THEN ASSIGN pFieldValue = RowObject.lim-requis.
        WHEN "lim-requis-manut":U THEN ASSIGN pFieldValue = RowObject.lim-requis-manut.
        WHEN "lim-solic":U THEN ASSIGN pFieldValue = RowObject.lim-solic.
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
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "tp-preco":U THEN ASSIGN pFieldValue = RowObject.tp-preco.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice USUAR-MATER
  Parameters:
               retorna valor dos campos do °ndice USUAR-MATER
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-usuario LIKE usuar-mater.cod-usuario NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-usuario = RowObject.cod-usuario.

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
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-usuar-pregao":U THEN ASSIGN pFieldValue = RowObject.log-usuar-pregao.
        WHEN "perm-alt-cont":U THEN ASSIGN pFieldValue = RowObject.perm-alt-cont.
        WHEN "recebe-e-mail":U THEN ASSIGN pFieldValue = RowObject.recebe-e-mail.
        WHEN "usuar-aprovador":U THEN ASSIGN pFieldValue = RowObject.usuar-aprovador.
        WHEN "usuar-comprador":U THEN ASSIGN pFieldValue = RowObject.usuar-comprador.
        WHEN "usuar-pedido":U THEN ASSIGN pFieldValue = RowObject.usuar-pedido.
        WHEN "usuar-requis":U THEN ASSIGN pFieldValue = RowObject.usuar-requis.
        WHEN "usuar-requis-manut":U THEN ASSIGN pFieldValue = RowObject.usuar-requis-manut.
        WHEN "usuar-solic":U THEN ASSIGN pFieldValue = RowObject.usuar-solic.
        WHEN "classif-solic":U THEN ASSIGN pFieldValue = RowObject.classif-solic.
        WHEN "cont-acesso-cc":U THEN ASSIGN pFieldValue = RowObject.cont-acesso-cc.
        WHEN "corporativo":U THEN ASSIGN pFieldValue = RowObject.corporativo.
        WHEN "envia-e-mail":U THEN ASSIGN pFieldValue = RowObject.envia-e-mail.
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
  Purpose:     Reposiciona registro com base no °ndice USUAR-MATER
  Parameters:
               recebe valor dos campos do °ndice USUAR-MATER
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-usuario LIKE usuar-mater.cod-usuario NO-UNDO.

    FIND FIRST bfusuar-mater WHERE
        bfusuar-mater.cod-usuario = pcod-usuario
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfusuar-mater THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfusuar-mater)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
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
    OPEN QUERY {&QueryName} FOR EACH usuar-mater NO-LOCK INDEXED-REPOSITION.

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
    
    DEFINE VARIABLE v_des_ccusto  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lb-help     AS CHARACTER   NO-UNDO.

    FOR FIRST param-global NO-LOCK:
    END.

    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
    IF pType = "CREATE":U THEN DO:
        IF RowObject.cod-usuario = "":U THEN DO: /*Usu†rio deve ser informado*/
           {utp/ut-liter.i Usu†rio *}
           {method/svc/errors/inserr.i
                  &ErrorNumber="265"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"
                  &ErrorParameters="RETURN-VALUE"}
        END.
        ELSE DO:
            /*o usu†rio de materiais dever† estar cadastrado no foundation sec/sec000aa.r*/
            IF NOT CAN-FIND(FIRST usuar_mestre
                            WHERE usuar_mestre.cod_usuario = rowObject.cod-usuario) THEN DO:
                {utp/ut-liter.i Usu†rio_Mestre *}
                {method/svc/errors/inserr.i
                                    &ErrorNumber="2"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters="RETURN-VALUE"}
            END.
            ELSE DO:
                IF CAN-FIND(FIRST usuar-mater
                            WHERE usuar-mater.cod-usuario = RowObject.cod-usuario) THEN DO:
                    {utp/ut-liter.i Usu†rio_de_Materiais *}
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="8"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" 
                                        &ErrorParameters="RETURN-VALUE"}
                END.
            END.
        END.    
    END.

    IF pType = "CREATE":U
    OR pType = "UPDATE":U THEN DO:

        FOR FIRST param-compra FIELDS(int-2) NO-LOCK:
            IF  param-compra.int-2 = 1
            AND RowObject.usuar-comprador THEN DO:
                IF rowObject.cod-grp-compra = "":U THEN DO:
                    {utp/ut-liter.i Grupo_de_Compras *}
                   {method/svc/errors/inserr.i
                          &ErrorNumber="265"
                          &ErrorType="EMS"
                          &ErrorSubType="ERROR"
                          &ErrorParameters="RETURN-VALUE"}
                END.
                ELSE DO:
                    IF NOT CAN-FIND(FIRST grupo-compra 
                                    WHERE grupo-compra.cod-grp-compra = rowObject.cod-grp-compra) THEN DO:
                        {utp/ut-liter.i Grupo_de_Compras *}
                        {method/svc/errors/inserr.i
                                            &ErrorNumber="2"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR" 
                                            &ErrorParameters="RETURN-VALUE"}
                    END.
                END.
            END.
        END.

        IF TRIM(SUBSTRING(rowObject.char-1,16,5)) = "":U THEN DO:
            {utp/ut-liter.i Estabelecimento *}
            {method/svc/errors/inserr.i
                   &ErrorNumber="265"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"
                   &ErrorParameters="RETURN-VALUE"}
        END.
        ELSE DO:
            IF NOT CAN-FIND(FIRST estabelec 
                            WHERE estabelec.cod-estabel = TRIM(SUBSTRING(rowObject.char-1,16,5))) THEN DO:
                {utp/ut-liter.i Estabelecimento *}
                {method/svc/errors/inserr.i
                                    &ErrorNumber="2"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters="RETURN-VALUE"}
            END.
        END.

        IF NOT VALID-HANDLE(h_api_ccusto) THEN
            RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.
        RUN pi_busca_dados_ccusto IN h_api_ccusto (INPUT "",                     /*EMPRESA DO EMS2. Passa em branco para API de finanáas utilizar a empresa do usu†rio logado*/
                                                   INPUT "",                     /* CODIGO DO PLANO CCUSTO */  
                                                   INPUT RowObject.sc-codigo,    /* CCUSTO */                  
                                                   INPUT TODAY,                  /* DATA DE TRANSACAO */       
                                                   OUTPUT v_des_ccusto,          /* DESCRICAO DO CCUSTO */     
                                                   OUTPUT TABLE tt_log_erro).    /* ERROS */                   
        IF v_des_ccusto = "":U THEN DO:
            {utp/ut-liter.i Centro_de_Custo *}
            {method/svc/errors/inserr.i
                   &ErrorNumber="2"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"
                   &ErrorParameters="RETURN-VALUE"}
        END.
        IF VALID-HANDLE(h_api_ccusto) THEN
            DELETE OBJECT h_api_ccusto.

        IF pType = "UPDATE":U THEN DO:
            IF NOT RowObject.usuar-comprador THEN DO:
                FOR FIRST comprador
                    WHERE comprador.cod-comprado = RowObject.cod-usuario NO-LOCK:
                END.
                IF  AVAIL comprador
                AND ( CAN-FIND (FIRST familia USE-INDEX comprador WHERE 
                                familia.cod-comprado = comprador.cod-comprado) OR 
                      CAN-FIND (FIRST item use-index comprador where
                               item.cod-comprado = comprador.cod-comprado) or 
                      CAN-FIND (first ordem-compra use-index comprador where
                               ordem-compra.cod-comprado = comprador.cod-comprado) or 
                      CAN-FIND (first cotacao-item use-index comprador where
                               cotacao-item.cod-comprado = comprador.cod-comprado) ) THEN DO:
                    {method/svc/errors/inserr.i
                           &ErrorNumber="6709"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"
                           &ErrorParameters="RETURN-VALUE"}
                END.
            END.
        END.
    END.

    IF pType = "DELETE":U THEN DO:
        /*Relacionamento com bancos hist¢ricos*/
        IF  AVAIL param-global
        AND param-global.modulo-bh = YES THEN DO:
             {bhp/bh9999.i 4 Usuar-Mater rowObject.cod-usuario '' '' '' '' ''}
             IF RETURN-VALUE <> "OK":U THEN DO:
                 {utp/ut-liter.i Consulte_o_Log_do_AppServer_para_verificar_o(s)_erro(s) * }
                 ASSIGN c-lb-help = TRIM(RETURN-VALUE).
                 {utp/ut-liter.i Bancos_Hist¢ricos * }
                 {method/svc/errors/inserr.i
                   &ErrorNumber="56208"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"
                   &ErrorParameters="RETURN-VALUE + '~~~~' + c-lb-help"}
             END.
         END.

         /*Verifica relacionamentos com usu†rio*/
         RUN cdp/cdapi175.p (INPUT rowObject.cod-usuario,
                             INPUT 1 ,
                             OUTPUT TABLE tt-erro).
         IF CAN-FIND(FIRST tt-erro) THEN DO:
             FOR EACH tt-erro:
                 CREATE RowErrors.
                 ASSIGN RowErrors.ErrorSequence    = i-sequen
                        RowErrors.ErrorNumber      = cd-erro
                        RowErrors.ErrorDescription = mensagem
                        RowErrors.ErrorParameters  = c-param.
             END.
         END.

         /*MODULO AQR (Aquisiá∆o Produtos Rurais) */
         IF CAN-FIND(FIRST regiao-abrangen 
                     WHERE regiao-abrangen.cod-respons = rowObject.cod-usuario) THEN DO:

             {utp/ut-table.i mgind regiao-abrangen 1}
             ASSIGN c-lb-help = TRIM(RETURN-VALUE).
             {utp/ut-liter.i Usu†rio_de_Materiais * }
             {method/svc/errors/inserr.i
                   &ErrorNumber="5"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"
                   &ErrorParameters="RETURN-VALUE + '~~~~' + c-lb-help"}
        END.

        IF NOT RowObject.usuar-comprador THEN DO:
            FOR FIRST comprador
                WHERE comprador.cod-comprado = RowObject.cod-usuario NO-LOCK:
            END.
            IF  AVAIL comprador
            AND ( CAN-FIND (FIRST familia USE-INDEX comprador WHERE 
                            familia.cod-comprado = comprador.cod-comprado) OR 
                  CAN-FIND (FIRST item use-index comprador where
                           item.cod-comprado = comprador.cod-comprado) or 
                  CAN-FIND (first ordem-compra use-index comprador where
                           ordem-compra.cod-comprado = comprador.cod-comprado) or 
                  CAN-FIND (first cotacao-item use-index comprador where
                           cotacao-item.cod-comprado = comprador.cod-comprado) ) THEN DO:
                {method/svc/errors/inserr.i
                       &ErrorNumber="6709"
                       &ErrorType="EMS"
                       &ErrorSubType="ERROR"
                       &ErrorParameters="RETURN-VALUE"}
            END.
        END.
     END.

    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

