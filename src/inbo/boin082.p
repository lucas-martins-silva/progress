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
{include/i-prgvrs.i BOIN082 2.00.00.008 } /*** "010008" 23/11/2023 16:19:41  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin082 MUT}
&ENDIF


/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      : BO utilizado apenas para navega‡Æo default e openQueries
                 com apenas uma tabela.
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName cotacao-item
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName cotacao-item
&GLOBAL-DEFINE TableLabel cotacao-item
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/
{inbo/boin082.i RowObject}


DEFINE TEMP-TABLE tt-cotacao-item NO-UNDO LIKE cotacao-item 
    FIELD r-rowid AS ROWID. 



/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
{method/dboqry.i}

/** NÆo elimine a linha abaixo, ‚ a chamada EPC **/
{include/i-epc200.i "boin082"}

/* Local Buffer Definitions ---  */

def buffer b-cotacao      for cotacao-item.

DEFINE BUFFER bf{&TableName} FOR {&TableName}.
   DEF VAR cItCodigo       AS CHAR NO-UNDO.
   DEF VAR iNumeroOrdem    AS INT  NO-UNDO.  
   DEF VAR iCodEmitenteIni AS INT init 0 NO-UNDO. 
   DEF VAR iCodEmitenteFim AS INT init 999999999 NO-UNDO.

def var iNumOrdem  as int no-undo initial 0.
def var ccod-comprado as char   no-undo.
def var h-boiv011     as handle no-undo.

def var h-boin706 as handle no-undo.

/******************************ATENCAO*************************************
 Pre-processador abaixo responsavel por distinguir o produto que
 esta executando o componente ( Magnus ou EMS ). 
 Se estiver definida a variavel bf-mat-comex 
 ( &if defined(bf-mat-comex) &then ), significa que o produto
 chamador e o Magnus se nÆo, EMS. Utilizado pelo produto Comercio Exterior
**************************************************************************/ 
{cdp/cdcfgmat.i} /* Definicao de pre-processadores - Magnus ou EMS */
{include/i_dbvers.i}
{utp/ut-glob.i}
{include/i_dbtype.i}

DEF VAR l-api-orcam    AS LOGICAL NO-UNDO INITIAL YES.

/* UPC */
if  c-nom-prog-dpc-mg97  <> "":U
or  c-nom-prog-appc-mg97 <> "":U
or  c-nom-prog-upc-mg97  <> "":U then do:

    for each tt-epc:
       delete tt-epc.
    end.

    create tt-epc.
    assign tt-epc.cod-event     = "Inicio_boin082"
           tt-epc.cod-parameter = "Executa_Api_Orcam"
           tt-epc.val-parameter = "YES". 

    {include/i-epc201.i "Inicio_boin082"}

    find first tt-epc
         where tt-epc.cod-event     = "Inicio_boin082"
         and   tt-epc.cod-parameter = "Executa_Api_Orcam"
         AND   tt-epc.val-parameter = "NO"
         no-lock no-error.
    if  available tt-epc then
        assign l-api-orcam = NO.

    FOR EACH tt-epc:
        DELETE tt-epc.
    END.

END.

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
         HEIGHT             = 2.58
         WIDTH              = 41.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

        def var r-aux-oracle as rowid no-undo.
        assign  r-aux-oracle = rowid(cotacao-item).

        release cotacao-item.

     &IF "{&ems_dbtype}":U <> "progress":U &THEN 
        ROWID(cotacao-item).
     &ENDIF

        run repositionRecord in this-procedure (input r-aux-oracle).

    return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if  "{&mgadm_version}" >= "2.04" &then

        /*API de Execucao Orcamentaria*/
        IF  l-api-orcam THEN
            RUN cdp/cdapi182.p (INPUT ?,                /*rowid cotacao*/
                                INPUT TABLE rowobject,  /*registro alterado*/
                                INPUT 1,                /*funcao: 1-BeforeCreateRecord da Cotacao*/
                                OUTPUT TABLE RowErrors APPEND). /*tt que retorna erro*/
    &endif  

    IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    ELSE
        RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:    Executa Update
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/
  &if defined(bf-mat-comex) &then            
  &else     

        /** INÖCIO DO CàDIGO TRANSFERIDO DA TRIGGER DE DELETE **/

        DISABLE TRIGGERS FOR DUMP OF cotacao-item.

        /*** Se o comando acima nÆo funcionar, usar esse que est  em coment rio ****
            /* Ignora as Triggers */
            ON WRITE OF cotacao-item OVERRIDE DO:
            END.
        ***/

        /** def buffer b-cotacao for cotacao-item. - definido no Definitions do DBO **/

        find ordem-compra where
             ordem-compra.numero-ordem = cotacao-item.numero-ordem
             exclusive-lock no-error.

        if cotacao-item.numero-ordem <> ? and 
           cotacao-item.numero-ordem <> 0 then do:
            find cota-item-reaj
                 where cota-item-reaj.it-codigo   =
                       cotacao-item.it-codigo
                   and cota-item-reaj.numero-ordem =
                       cotacao-item.numero-ordem
                   and cota-item-reaj.cod-emitente =
                       cotacao-item.cod-emitente
                   and cota-item-reaj.data-cotacao  =
                       cotacao-item.data-cotacao
                 EXCLUSIVE-LOCK no-error.

            if param-global.modulo-in and
               ordem-compra.num-ord-inv <> 0 then do:
               run ivbo/boiv011.p persistent set h-boiv011.    
               run DeleteCotacaoInv in h-boiv011 (input rowid(cotacao-item), 
                                                  input-output table RowErrors).
               delete procedure h-boiv011.                                 
            end.           


			/********************************** Aprova‡Æo Eletr“nica **************************************/
			find first param-compra no-lock no-error.
			IF avail param-compra and param-compra.log-1 AND cotacao-item.numero-ordem <> 0 THEN DO:
				/* Solic. Cota‡ao ou varia‡Æo pre‡o do item */   
				IF AVAIL ordem-compra AND ordem-compra.nr-requisicao <> 0 THEN DO:
				   FIND it-requisicao WHERE 
						it-requisicao.nr-requisicao = ordem-compra.nr-requisicao AND
						it-requisicao.it-codigo     = ordem-compra.it-codigo AND
						it-requisicao.sequencia     = ordem-compra.sequencia EXCLUSIVE-LOCK NO-ERROR.
				   IF AVAIL it-requisicao THEN DO:
					   FOR FIRST requisicao
						   WHERE requisicao.nr-requisicao = it-requisicao.nr-requisicao NO-LOCK:
					   END.

					   IF CAN-FIND(FIRST funcao 
								   WHERE funcao.cd-funcao = "Integra_MLA_EMS":U 
									 AND funcao.ativo     = YES) THEN DO:
						   IF AVAIL requisicao THEN DO:
							   IF requisicao.tp-requis = 3 THEN  /*solicitacao de cotacao*/
								  RUN cdp/cdapi171.p (5,3, ROWID(it-requisicao)). /*solicitacao de cotacao*/
							   ELSE
								   IF requisicao.tp-requis = 2 THEN
										RUN cdp/cdapi171.p (1,3, ROWID(it-requisicao)). /*solicitacao de compras*/
						   END.
					   END.
					   ELSE DO:
						   RUN cdp/cdapi171.p (5,3, ROWID(it-requisicao)). /*solicitacao de cotacao*/
					   END.
				   END.
				END.

				RUN cdp/cdapi171.p (3,3, ROWID(cotacao-item)).
			END.
			/********************************************************************************************************/
			
            if avail ordem-compra and ordem-compra.num-pedido = 0 
               and cotacao-item.data-cotacao <> &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF then do:
                find first b-cotacao where
                    b-cotacao.numero-ordem = ordem-compra.numero-ordem and
                    rowid(b-cotacao)       <> rowid(cotacao-item)      and
                    b-cotacao.cot-aprovada no-lock no-error.
                if available b-cotacao then do:
                   if ordem-compra.situacao <> 3 then do:
                      assign ordem-compra.situacao = 3  /*"T" - Cotada*/.              
                      for each prazo-compra where
                               prazo-compra.numero-ordem = ordem-compra.numero-ordem exclusive-lock:
                          assign prazo-compra.situacao = ordem-compra.situacao.
                      end.           
                   end.     
                end.    
                else do:
                   /* Execucao Orcamentaria - Financas */
                   &IF "{&mgadm_version}" >= "2.04" &THEN
                       run cdp/cdapi195.p(rowid(ordem-compra),rowid(cotacao-item)).
                   &ENDIF 
                   find first b-cotacao where
                        b-cotacao.numero-ordem = ordem-compra.numero-ordem and
                        rowid(b-cotacao)       <> rowid(cotacao-item)      and
                        b-cotacao.data-cotacao <> &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF no-lock no-error.
                   if available b-cotacao then do:
                       if ordem-compra.situacao <> 5 then do:
                          assign ordem-compra.situacao = 5
                                 .  /*"M" - Em cotacao*/
                          for each prazo-compra where
                                   prazo-compra.numero-ordem = ordem-compra.numero-ordem exclusive-lock:
                              assign prazo-compra.situacao = ordem-compra.situacao.
                          end.               
                       end.
                   end.    
                   else do:
                       if ordem-compra.situacao <> 1 then do:
                          assign ordem-compra.situacao = 1.  /*"N" - NÆo Confirmada*/
                          for each prazo-compra where
                                   prazo-compra.numero-ordem = ordem-compra.numero-ordem exclusive-lock:
                              assign prazo-compra.situacao = ordem-compra.situacao.
                          end.
                       end.     
                   end. 

				   assign ordem-compra.cod-emitente = 0
                          ordem-compra.data-cotacao = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF
                          ordem-compra.pre-unit-for = 0
                          ordem-compra.preco-fornec = 0
                          ordem-compra.preco-unit   = 0
                          ordem-compra.preco-orig   = 0
                          ordem-compra.mo-codigo    = 0
                          ordem-compra.cod-cond-pag = 0
                          ordem-compra.contato      = ""
                          ordem-compra.expectativa  = NO
                          overlay(ordem-compra.char-2,80,1) = "".
                end.
            end.    
        end.
        else do:
            find cota-item-reaj
                 where cota-item-reaj.it-codigo   =
                       cotacao-item.it-codigo
                   and cota-item-reaj.numero-ordem = 0
                   and cota-item-reaj.cod-emitente =
                       cotacao-item.cod-emitente
                   and cota-item-reaj.data-cotacao  =
                       cotacao-item.data-cotacao
                 EXCLUSIVE-LOCK no-error.
        end.
        if  avail cota-item-reaj then
            delete cota-item-reaj.

        /** Fim das valida‡äes de elimina‡Æo **/

        /** NÆo elimine a linha abaixo, ‚ a chamada EPC **/
        {include/i-epc102.i cotacao-item}

        /** Inicio da elimina‡Æo em cascata **/

        /** x:/desenv/database/tgin/tdp/tdin082.p **/

        /** FIM DA LàGICA DA TRIGGER DE DELETE **/

        /** Elimina‡Æo das despesas da cotacao a partir 
            da versÆo 2.04B ***************************/
        &if  defined(bf_mat_despes_compra_inter) &then

            /* Executa a boin706 persistente */
            {inbo/boin706.i1}

            /** For each na tabela desp-cotacao-item para 
                elimina‡Æo das despesas da cotacao **/
            {inbo/bopin706.i2}

            /* Elimina handle da boin706 */
            {inbo/boin706.i3}

        &endif


    RETURN "OK":U.
  &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if  "{&mgadm_version}" >= "2.04" &then
        /*API de Execucao Orcamentaria*/

        IF  l-api-orcam THEN
            RUN cdp/cdapi182.p (INPUT ROWID(cotacao-item), /*rowid cotacao-item*/
                                INPUT TABLE rowobject,     /*registro alterado*/
                                INPUT 1,                   /*funcao: 1-BeforeUpdateRecord da Cotacao*/
                                OUTPUT TABLE Rowerrors APPEND).   /*tt que retorna erro*/
    &endif 

    IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    ELSE 
        RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCotacao DBOProgram 
PROCEDURE findCotacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    &if defined(bf-mat-comex) &then         

        DEFINE INPUT  PARAMETER pnumero-ordem LIKE cotacao-item.numero-ordem NO-UNDO.
        DEFINE INPUT  PARAMETER pcod-emitente LIKE cotacao-item.cod-emitente NO-UNDO.
        DEFINE INPUT  PARAMETER pit-codigo    LIKE cotacao-item.it-codigo    NO-UNDO.
        DEFINE INPUT  PARAMETER pdata-cotacao LIKE cotacao-item.data-cotacao NO-UNDO.
        DEFINE OUTPUT PARAMETER pcreturn      AS   char                      NO-UNDO.
        
        RUN setConstraintNumOrdem (input pnumero-ordem). 
        run openQueryStatic       (input "ByCotacao":U).

        run goToKey (input pnumero-ordem,
                     input pcod-emitente,
                     input pit-codigo,
                     input pdata-cotacao).

        if return-value = "OK" then assign pcreturn = "".  /* esse ‚ o valor esperado nas interfaces 1.1 */
        if return-value = "NOK" then do:
            {utp/ut-table.i mgind cotacao-item 1}
            run utp/ut-msgs.p (input "msg":U,
                               input 2,
                               input return-value).
            assign pcreturn =  return-value.  
            /* essa ‚ a mensagem esperada nas interfaces 1.1  qdo nÆo acha o registro */
        end.

    &else

        DEFINE INPUT  PARAMETER pnumero-ordem LIKE cotacao-item.numero-ordem NO-UNDO.
        DEFINE INPUT  PARAMETER pcod-emitente LIKE cotacao-item.cod-emitente NO-UNDO.
        DEFINE INPUT  PARAMETER pit-codigo    LIKE cotacao-item.it-codigo    NO-UNDO.
        DEFINE INPUT  PARAMETER pseq-cotac    LIKE cotacao-item.seq-cotac    NO-UNDO.
        DEFINE OUTPUT PARAMETER pcreturn      AS   char                      NO-UNDO.
        
        RUN setConstraintNumOrdem (input pnumero-ordem). 
        run openQueryStatic       (input "ByCotacao":U).
        run goToKey (input pnumero-ordem,
                     input pcod-emitente,
                     input pit-codigo,
                     input pseq-cotac).

        if return-value = "OK" then assign pcreturn = "".  /* esse ‚ o valor esperado nas interfaces 1.1 */
        if return-value = "NOK" then do:
            {utp/ut-table.i mgind {&TABLENAME} 1}
            run utp/ut-msgs.p (input "msg":U,
                               input 2,
                               input return-value).
            assign pcreturn =  return-value.  
            /* essa ‚ a mensagem esperada nas interfaces 1.1  qdo nÆo acha o registro */
        end.

    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCotacaoAprovada DBOProgram 
PROCEDURE findCotacaoAprovada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    &if defined(bf-mat-comex) &then            
    &else 
        DEFINE INPUT  PARAMETER pnumero-ordem LIKE cotacao-item.numero-ordem NO-UNDO.
        DEFINE OUTPUT PARAMETER pcreturn      AS   char                      NO-UNDO.
        
        RUN setConstraintNumOrdem (input pnumero-ordem). 
        run openQueryStatic       (input "ByCotacao":U).
        run goToCotacaoAprovada (input pnumero-ordem).

        if return-value = "OK" then assign pcreturn = "".  /* esse ‚ o valor esperado nas interfaces 1.1 */
        if return-value = "NOK" then do:
            {utp/ut-table.i mgind {&TABLENAME} 1}
            run utp/ut-msgs.p (input "msg":U,
                               input 2,
                               input return-value).
            assign pcreturn =  return-value.  
            /* essa ‚ a mensagem esperada nas interfaces 1.1  qdo nÆo acha o registro */
        end.
    &endif        
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

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "motivo-apr":U THEN ASSIGN pFieldValue = RowObject.motivo-apr.
        WHEN "nr-tab":U THEN ASSIGN pFieldValue = RowObject.nr-tab.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
        WHEN "aprovador":U THEN ASSIGN pFieldValue = RowObject.aprovador.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
        WHEN "contato":U THEN ASSIGN pFieldValue = RowObject.contato.
        WHEN "hora-atualiz":U THEN ASSIGN pFieldValue = RowObject.hora-atualiz.        
        &if defined(bf-mat-comex) &then            
            WHEN "narrativa[1]":U THEN ASSIGN pFieldValue = RowObject.narrativa[1].
            WHEN "narrativa[2]":U THEN ASSIGN pFieldValue = RowObject.narrativa[2].
            WHEN "narrativa[3]":U THEN ASSIGN pFieldValue = RowObject.narrativa[3].
            WHEN "narrativa[4]":U THEN ASSIGN pFieldValue = RowObject.narrativa[4].
            WHEN "narrativa[5]":U THEN ASSIGN pFieldValue = RowObject.narrativa[5].                
            WHEN "u-char-1":U THEN ASSIGN pFieldValue = RowObject.u-char-1.                    
        &else         
            WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.        
            WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
            WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.            
        &endif
        &if "{&bf_mat_versao_ems}" >= "2.09" &then
            when "cod-cotac-portal":U then assign pFieldValue = rowObject.cod-cotac-portal.
            when "cod-respos-fornec":U then assign pFieldValue = rowObject.cod-respos-fornec.
        &endif
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

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-atualiz":U THEN ASSIGN pFieldValue = RowObject.data-atualiz.
        WHEN "data-cotacao":U THEN ASSIGN pFieldValue = RowObject.data-cotacao.
        &if defined(bf-mat-comex) &then   
        &else
            WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
            WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.        
        &endif        
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

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "perc-descto":U THEN ASSIGN pFieldValue = RowObject.perc-descto.
        WHEN "pre-unit-for":U THEN ASSIGN pFieldValue = RowObject.pre-unit-for.
        WHEN "preco-fornec":U THEN ASSIGN pFieldValue = RowObject.preco-fornec.
        WHEN "preco-unit":U THEN ASSIGN pFieldValue = RowObject.preco-unit.
        WHEN "valor-descto":U THEN ASSIGN pFieldValue = RowObject.valor-descto.
        WHEN "valor-frete":U THEN ASSIGN pFieldValue = RowObject.valor-frete.
        WHEN "valor-taxa":U THEN ASSIGN pFieldValue = RowObject.valor-taxa.
        WHEN "aliquota-icm":U THEN ASSIGN pFieldValue = RowObject.aliquota-icm.
        WHEN "aliquota-ipi":U THEN ASSIGN pFieldValue = RowObject.aliquota-ipi.
        WHEN "aliquota-iss":U THEN ASSIGN pFieldValue = RowObject.aliquota-iss.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "ind-reajuste":U THEN ASSIGN pFieldValue = RowObject.ind-reajuste.
        &if defined(bf-mat-comex) &then     
            WHEN "u-dec-1":U THEN ASSIGN pFieldValue = RowObject.u-dec-1.                
        &else
            WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.                
        &endif        
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

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "nr-dias-taxa":U THEN ASSIGN pFieldValue = RowObject.nr-dias-taxa.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "prazo-entreg":U THEN ASSIGN pFieldValue = RowObject.prazo-entreg.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "dias-validade":U THEN ASSIGN pFieldValue = RowObject.dias-validade.
        WHEN "cdn-pais-orig":U THEN ASSIGN pFieldValue = RowObject.cdn-pais-orig.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.      
        &if defined(bf-mat-comex) &then     
        &else
            WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.        
            WHEN "num-proc-entr-edi":U THEN ASSIGN pFieldValue = RowObject.num-proc-entr-edi.
            WHEN "num-proc-envio-edi":U THEN ASSIGN pFieldValue = RowObject.num-proc-envio-edi.            
            WHEN "seq-cotac":U THEN ASSIGN pFieldValue = RowObject.seq-cotac.            
            WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-transp.            
            WHEN "codigo-icm":U THEN ASSIGN pFieldValue = RowObject.codigo-icm.
            WHEN "ind-orig-entrada":U THEN ASSIGN pFieldValue = RowObject.ind-orig-entrada.            
            WHEN "ind-via-envio":U THEN ASSIGN pFieldValue = RowObject.ind-via-envio.            
        &endif                
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice COTACAO
  Parameters:
               retorna valor dos campos do ¡ndice COTACAO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then     
    &else
        DEFINE OUTPUT PARAMETER pnumero-ordem LIKE cotacao-item.numero-ordem NO-UNDO.
        DEFINE OUTPUT PARAMETER pcod-emitente LIKE cotacao-item.cod-emitente NO-UNDO.
        DEFINE OUTPUT PARAMETER pit-codigo LIKE cotacao-item.it-codigo NO-UNDO.
        DEFINE OUTPUT PARAMETER pseq-cotac LIKE cotacao-item.seq-cotac NO-UNDO.

        /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
              retornada flag "NOK":U ---*/
        IF NOT AVAILABLE RowObject THEN
           RETURN "NOK":U.

        ASSIGN pnumero-ordem = RowObject.numero-ordem.
        ASSIGN pcod-emitente = RowObject.cod-emitente.
        ASSIGN pit-codigo = RowObject.it-codigo.
        ASSIGN pseq-cotac = RowObject.seq-cotac.
        RETURN "OK":U.        
    &endif           
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

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "possui-reaj":U THEN ASSIGN pFieldValue = RowObject.possui-reaj.
        WHEN "reaj-tabela":U THEN ASSIGN pFieldValue = RowObject.reaj-tabela.
        WHEN "taxa-financ":U THEN ASSIGN pFieldValue = RowObject.taxa-financ.
        WHEN "codigo-ipi":U THEN ASSIGN pFieldValue = RowObject.codigo-ipi.
        WHEN "cot-aprovada":U THEN ASSIGN pFieldValue = RowObject.cot-aprovada.
        WHEN "frete":U THEN ASSIGN pFieldValue = RowObject.frete.
        &if defined(bf-mat-comex) &then     
            WHEN "codigo-icm":U THEN ASSIGN pFieldValue = RowObject.codigo-icm.                
        &else
            WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.        
            WHEN "reajusta-cotacao":U THEN ASSIGN pFieldValue = RowObject.reajusta-cotacao.            
            WHEN "ind-ret-cotacao":U THEN ASSIGN pFieldValue = RowObject.ind-ret-cotacao.            
        &endif    
        &if "{&bf_mat_versao_ems}" >= "2.09" &then
            when "log-congela-cotac":U then assign pFieldValue = rowObject.log-congela-cotac.
            when "log-integr-portal":U then assign pFieldValue = rowObject.log-integr-portal.
        &endif    
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
    &if defined(bf-mat-comex) &then     
    &else
        DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
        DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

        /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
              retornada flag "NOK":U ---*/
        IF NOT AVAILABLE RowObject THEN
            RETURN "NOK":U.

        CASE pFieldName:
            OTHERWISE RETURN "NOK":U.
        END CASE.
        RETURN "OK":U.        
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToCotacaoAprovada DBOProgram 
PROCEDURE goToCotacaoAprovada :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro em uma cotacao que esteja aprovada
  Parameters:
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then     
    &else
        DEFINE INPUT PARAMETER pnumero-ordem LIKE cotacao-item.numero-ordem NO-UNDO.

        FIND FIRST bfcotacao-item WHERE
            bfcotacao-item.numero-ordem = pnumero-ordem AND
            bfcotacao-item.cot-aprovada = YES
            NO-LOCK NO-ERROR.

        /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
        IF NOT AVAILABLE bfcotacao-item THEN
            RETURN "NOK":U.

        /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
              existam erros serÿ retornada flag "NOK":U ---*/
        RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcotacao-item)).
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        RETURN "OK":U.            
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToCotacaoOrdem DBOProgram 
PROCEDURE goToCotacaoOrdem :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro
  Parameters:  ipar1  :  piNumeroOrdem : numero da ordem.
               ipar2  :  piCodEmitente : codigo do Emitente.
               ipar3  :  pcItCodigo    : codigo do Item.                
  Notes:
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then     
    &else
        DEFINE INPUT PARAMETER piNumeroOrdem LIKE cotacao-item.numero-ordem NO-UNDO.
        DEFINE INPUT PARAMETER piCodEmitente as   inte                      NO-UNDO.
        DEFINE INPUT PARAMETER pcItCodigo    as   char                      NO-UNDO.

        FIND FIRST bfcotacao-item WHERE
            bfcotacao-item.numero-ordem = piNumeroOrdem AND
            bfcotacao-item.cod-emitente = piCodEmitente AND
            bfcotacao-item.it-codigo    = pcItCodigo    NO-LOCK NO-ERROR.

        /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
        IF NOT AVAILABLE bfcotacao-item THEN
            RETURN "NOK":U.

        /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
              existam erros serÿ retornada flag "NOK":U ---*/
        RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcotacao-item)).
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        RETURN "OK":U.            
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice COTACAO
  Parameters:
               recebe valor dos campos do ¡ndice COTACAO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then         

        DEFINE INPUT PARAMETER pnumero-ordem LIKE cotacao-item.numero-ordem NO-UNDO.
        DEFINE INPUT PARAMETER pcod-emitente LIKE cotacao-item.cod-emitente NO-UNDO.
        DEFINE INPUT PARAMETER pit-codigo    LIKE cotacao-item.it-codigo    NO-UNDO.
        DEFINE INPUT PARAMETER pdata-cotacao LIKE cotacao-item.data-cotacao NO-UNDO.

        FIND FIRST bfcotacao-item WHERE
            bfcotacao-item.numero-ordem = pnumero-ordem AND
            bfcotacao-item.cod-emitente = pcod-emitente AND
            bfcotacao-item.it-codigo    = pit-codigo AND
            bfcotacao-item.data-cotacao = pdata-cotacao
            NO-LOCK NO-ERROR.

        /*--- Verifica se registro foi encontrado, em caso de erro ser˜ retornada flag "NOK":U ---*/
        IF NOT AVAILABLE bfcotacao-item THEN
            RETURN "NOK":U.

        /*--- Reposiciona query atravýs de rowid e verifica a ocorr¬ncia de erros, caso
              existam erros ser˜ retornada flag "NOK":U ---*/
        RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcotacao-item)).
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.

        RETURN "OK":U.

    &else    
        DEFINE INPUT PARAMETER pnumero-ordem LIKE cotacao-item.numero-ordem NO-UNDO.
        DEFINE INPUT PARAMETER pcod-emitente LIKE cotacao-item.cod-emitente NO-UNDO.
        DEFINE INPUT PARAMETER pit-codigo LIKE cotacao-item.it-codigo NO-UNDO.
        DEFINE INPUT PARAMETER pseq-cotac LIKE cotacao-item.seq-cotac NO-UNDO.

        FIND FIRST bfcotacao-item WHERE
            bfcotacao-item.numero-ordem = pnumero-ordem AND
            bfcotacao-item.cod-emitente = pcod-emitente AND
            bfcotacao-item.it-codigo = pit-codigo AND
            bfcotacao-item.seq-cotac = pseq-cotac
            NO-LOCK NO-ERROR.

        /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
        IF NOT AVAILABLE bfcotacao-item THEN
            RETURN "NOK":U.

        /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
              existam erros serÿ retornada flag "NOK":U ---*/
        RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcotacao-item)).
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.

        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToItem DBOProgram 
PROCEDURE linkToItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then     
    &else
        def input param ph-item as handle no-undo.

        RUN GetKey IN ph-item (output citcodigo).
        RETURN "OK":U.        
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToOrdem-Compra DBOProgram 
PROCEDURE linkToOrdem-Compra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then     
    &else
        def input param ph-ordem as handle no-undo.

        RUN GetKey IN ph-ordem (output ccod-comprado,
                                output inumeroordem).
        RUN GetCharField IN ph-ordem (input "it-codigo", output citcodigo).
        RETURN "OK":U.        
    &endif

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
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

 define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
           RUN openQueryStatic (input "Main":U). 

        &if defined(bf-mat-comex) &then     
        &else           
            when 4 then
               RUN openQueryStatic (input "byCodEmitente":U). 

            when 5 then
               RUN openQueryStatic (input "byDataCotacao":U). 
        &endif

    end case.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByCodEmitente DBOProgram 
PROCEDURE openQueryByCodEmitente :
/*------------------------------------------------------------------------------
  Purpose: Busca conjunto de registros da tabela cotacao-item desde que 
           exista o c¢digo do item cadastrado para a cota‡Æo na tabela 
           item j  posicionado pelo setConstraint. 
           Os registros sÆo ordenados pelo c¢digo do emitente.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then     
    &else

        OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE 
                   {&tablename}.it-codigo = citcodigo NO-LOCK
                BY {&TableName}.cod-emitente                 
                INDEXED-REPOSITION.                   
        RETURN "OK":U.                

    &endif


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByCodEmitente2 DBOProgram 
PROCEDURE openQueryByCodEmitente2 :
/*------------------------------------------------------------------------------
  Purpose: Busca conjunto de registros da tabela cotacao-item desde que 
           exista o c¢digo do item cadastrado para a cota‡Æo na tabela 
           item j  posicionado pelo setConstraint. 
           Os registros sÆo ordenados pelo c¢digo do emitente.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then     
    &else

        OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE
                   {&TableName}.numero-ordem = iNumeroOrdem AND
                   {&tablename}.it-codigo    = citcodigo NO-LOCK
                BY {&TableName}.cod-emitente 
                INDEXED-REPOSITION.   
        RETURN "OK":U.                                         

    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByCotacao DBOProgram 
PROCEDURE openQueryByCotacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QueryName} for each {&TableName} where
                             {&TableName}.numero-ordem = iNumOrdem 
                             NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.                                
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDataCotacao DBOProgram 
PROCEDURE openQueryByDataCotacao :
/*------------------------------------------------------------------------------
  Purpose:  Busca conjunto de registros da tabela cotacao-item desde que 
            exista o c¢digo do item cadastrado para a cota‡Æo na tabela 
            item j  posicionado pelo setConstraint. 
            Os registros sÆo ordenados pela data da cota‡Æo.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then     
    &else

        OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE 
                   {&tablename}.it-codigo = citcodigo NO-LOCK
                BY {&TableName}.data-cotacao 
                BY {&TableName}.cod-emitente
                BY {&TableName}.numero-ordem
                INDEXED-REPOSITION.   

        RETURN "OK":U.                                                         

    &endif


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByItcodigo DBOProgram 
PROCEDURE openQueryByItcodigo :
/*------------------------------------------------------------------------------
  Purpose: Busca conjunto de registros da tabela cotacao-item que sejam nÆo 
           pendentes dentro de uma faixa de c¢digo do fornecedor.  
           Os registros sÆo ordenados pelo c¢digo do item.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then     
    &else

        OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE 
                   {&tablename}.it-codigo     = cItCodigo       AND
                   {&TableName}.numero-ordem  = iNumeroOrdem    AND 
                   {&TableName}.data-cotacao <> &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF      AND
                   {&TableName}.cod-emitente >= iCodEmitenteIni AND
                   {&TableName}.cod-emitente <= iCodEmitenteFim NO-LOCK
                   INDEXED-REPOSITION.   
        RETURN "OK":U.  

    &endif


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
    OPEN QUERY {&QueryName} FOR EACH cotacao-item NO-LOCK indexed-reposition.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

 
&IF DEFINED(EXCLUDE-pi-retorna-tt-cotcao-item) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-tt-cotacao-item Procedure
PROCEDURE pi-retorna-tt-cotacao-item:

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
 &if defined(bf-mat-comex) &then     
    &else
        DEFINE INPUT PARAMETER piNumeroOrdem LIKE cotacao-item.numero-ordem NO-UNDO.
        DEFINE INPUT PARAMETER piCodEmitente as   inte                      NO-UNDO.
        DEFINE INPUT PARAMETER pcItCodigo    as   char                      NO-UNDO.
        DEFINE OUTPUT PARAMETER TABLE FOR tt-cotacao-item.

        FOR EACH bfcotacao-item WHERE
            bfcotacao-item.numero-ordem = piNumeroOrdem AND
            bfcotacao-item.cod-emitente = piCodEmitente AND
            bfcotacao-item.it-codigo    = pcItCodigo    NO-LOCK:                
                
            BUFFER-COPY bfcotacao-item TO tt-cotacao-item. 
            ASSIGN tt-cotacao-item.r-rowid = ROWID(bfcotacao-item).                               
                
        END.        
        
        RETURN "OK":U.            
    &endif

END PROCEDURE.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then     
    &else

        DEF INPUT PARAM pcItCodigo       AS CHAR NO-UNDO.
        DEF INPUT PARAM piNumeroOrdem    AS INT  NO-UNDO.
        DEF INPUT PARAM piCodEmitenteIni AS INT  NO-UNDO.
        DEF INPUT PARAM piCodEmitenteFim AS INT  NO-UNDO.


        run setConstraintItCodigo  (pcItCodigo,
                                    piNumeroOrdem,
                                    piCodEmitenteIni,
                                    piCodEmitenteFim).

        RETURN "OK":U.                                    

    &endif      


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint3 DBOProgram 
PROCEDURE setConstraint3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then     
    &else

        DEF INPUT PARAM prItem AS ROWID NO-UNDO.

        run setConstraintOFItem (prItem).

        RETURN "OK":U.

    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintbyCodEmitente DBOProgram 
PROCEDURE setConstraintbyCodEmitente :
/*------------------------------------------------------------------------------
  Purpose:  Carregas vari vei p/ openQueryByCodEmitente2   
  Parameters: 
             ipar1 : pcItCodigo       : C¢digo do item
             ipar2 : piNumeroOrdem    : N£mero da ordem
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then     
    &else

        DEF INPUT PARAM pcItCodigo       AS CHAR NO-UNDO.
        DEF INPUT PARAM piNumeroOrdem    AS INT  NO-UNDO.


        ASSIGN cItCodigo       = pcItCodigo
               iNumeroOrdem    = piNumeroOrdem.

        RETURN "OK":U.

    &endif        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItCodigo DBOProgram 
PROCEDURE setConstraintItCodigo :
/*------------------------------------------------------------------------------
  Purpose:  Carregas vari vei p/ openQueryByItCodigo   
  Parameters: 
             ipar1 : pcItCodigo       : C¢digo do item
             ipar2 : piNumeroOrdem    : N£mero da ordem
             ipar3 : piCodEmitenteIni : C¢digo do emitente inicial
             ipar4 : piCodEmitenteFim : C¢digo do emitente final
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then     
    &else

        DEF INPUT PARAM pcItCodigo       AS CHAR NO-UNDO.
        DEF INPUT PARAM piNumeroOrdem    AS INT  NO-UNDO.
        DEF INPUT PARAM piCodEmitenteIni AS INT  NO-UNDO.
        DEF INPUT PARAM piCodEmitenteFim AS INT  NO-UNDO.


        ASSIGN cItCodigo       = pcItCodigo
               iNumeroOrdem    = piNumeroOrdem
               iCodEmitenteIni = piCodEmitenteIni
               iCodEmitenteFim = piCodEmitenteFim.

        RETURN "OK":U.

    &endif        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNumOrdem DBOProgram 
PROCEDURE setConstraintNumOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*ParÆmetros:
           ipar1  : piNumOrdem : Numero da ordem corrente da interface.
*/

    &if defined(bf-mat-comex) &then    
        def input param piNumOrdem as int no-undo.

        assign iNumOrdem = piNumOrdem.    
    &else
        def input param piNumOrdem as int no-undo.

        assign iNumOrdem = piNumOrdem.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOFItem DBOProgram 
PROCEDURE setConstraintOFItem :
/*------------------------------------------------------------------------------
  Purpose:     Posiciona registro do Item de acordo com o rowid parametrizado 
  Parameters:  ipar1 : prItem : rowid do Item
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then     
    &else

        DEF INPUT PARAM prItem AS ROWID NO-UNDO.

        FIND item WHERE 
             ROWID(item) = prItem
             NO-LOCK NO-ERROR.

        assign citcodigo = item.it-codigo.  
        RETURN "OK":U.

    &endif        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsHIS DBOProgram 
PROCEDURE setDefaultsHIS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piNumOrdem as int no-undo.
    DEF OUTPUT PARAM piFabrMedic AS CHAR NO-UNDO.

    DEF VAR i-fabric AS INT NO-UNDO.

    FIND FIRST cotacao-item 
         WHERE cotacao-item.numero-ordem = piNumOrdem 
           AND cotacao-item.cot-aprovada = YES NO-LOCK NO-ERROR.
    IF AVAIL cotacao-item THEN DO:

        &if "{&bf_mat_versao_ems}" >= "2.09":U &then
            ASSIGN i-fabric = cotacao-item.cdn-fab-medic.
        &ELSE                                       
            ASSIGN i-fabric = int(substring(cotacao-item.char-1,127,9)).
        &ENDIF 
        
        &IF "{&bf_mat_versao_ems}" >= "2.062" &then
            FIND FIRST fab-medic NO-LOCK
                 WHERE fab-medic.cdn-fabrican = i-fabric NO-ERROR.
            IF AVAIL fab-medic THEN DO:
                
                ASSIGN piFabrMedic = string(fab-medic.cdn-fabrican) + " - " + fab-medic.nom-fabrican.
    
            END.
        &ENDIF
    END.

    RETURN "OK".

    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaPregaoEletronico DBOProgram 
PROCEDURE validaPregaoEletronico :
/*------------------------------------------------------------------------------
  Purpose:     Posiciona registro do Item de acordo com o rowid parametrizado 
  Parameters:  ipar1 : prItem : rowid do Item
  Notes:       
------------------------------------------------------------------------------*/
    
    FIND FIRST param-compra NO-LOCK NO-ERROR.
    IF AVAIL param-compra THEN DO:
        &IF "{&bf_mat_versao_ems}" >= "2.07" &then   
            IF param-compra.log-param-pregao-eletron AND
               RowObject.ind-via-envio = 17 THEN DO:
                FIND FIRST bfcotacao-item NO-LOCK
                    WHERE bfcotacao-item.numero-ordem = rowObject.numero-ordem 
                      AND bfcotacao-item.cod-emitente = rowObject.cod-emitente 
                      AND bfcotacao-item.it-codigo    = rowObject.it-codigo    
                      AND bfcotacao-item.seq-cotac    = rowObject.seq-cotac NO-ERROR.
                IF AVAIL bfcotacao-item THEN DO:
                    IF bfcotacao-item.un           <> rowObject.un            OR
                       bfcotacao-item.possui-reaj  <> rowObject.possui-reaj   OR
                       bfcotacao-item.preco-fornec <> rowObject.preco-fornec  OR
                       bfcotacao-item.mo-codigo    <> rowObject.mo-codigo     OR
                       bfcotacao-item.codigo-ipi   <> rowObject.codigo-ipi    OR
                       bfcotacao-item.aliquota-ipi <> rowObject.aliquota-ipi  OR
                       bfcotacao-item.aliquota-icm <> rowObject.aliquota-icm  OR
                       bfcotacao-item.aliquota-iss <> rowObject.aliquota-iss  OR
                       bfcotacao-item.codigo-icm   <> rowObject.codigo-icm    OR
                       bfcotacao-item.frete        <> rowObject.frete         OR
                       bfcotacao-item.valor-frete  <> rowObject.valor-frete   OR
                       bfcotacao-item.valor-taxa   <> rowObject.valor-taxa    OR
                       bfcotacao-item.taxa-financ  <> rowObject.taxa-financ   OR
                       bfcotacao-item.nr-dias-taxa <> rowObject.nr-dias-taxa  OR
                       bfcotacao-item.perc-descto  <> rowObject.perc-descto   OR
                       bfcotacao-item.valor-descto <> rowObject.valor-descto  OR
                       bfcotacao-item.prazo-entreg <> rowObject.prazo-entreg  THEN DO:
                        FIND FIRST usuar-mater NO-LOCK 
                            WHERE usuar-mater.cod-usuario = c-seg-usuario NO-ERROR.
                        IF AVAIL usuar-mater THEN DO:
                            IF usuar-mater.log-usuar-pregao THEN DO:
                                /* Inicio -- Projeto Internacional */
                                DEFINE VARIABLE c-lbl-liter-cotacao AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "Cota‡Æo" *}
                                ASSIGN c-lbl-liter-cotacao = TRIM(RETURN-VALUE).
                                {method/svc/errors/inserr.i &ErrorNumber="32715"
                                                            &ErrorType="EMS":U
                                                            &ErrorSubType="WARNING"
                                                            &ErrorParameters="c-lbl-liter-cotacao"}
                            END.
                            ELSE DO:
                                /* Inicio -- Projeto Internacional */
                                DEFINE VARIABLE c-lbl-liter-incluir-alterar-e-eliminar-cot AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "incluir,_alterar_e_eliminar_cota‡äes_para_processos_de_pregÆo_eletr“nico" *}
                                ASSIGN c-lbl-liter-incluir-alterar-e-eliminar-cot = TRIM(RETURN-VALUE).
                                {method/svc/errors/inserr.i &ErrorNumber="25729"
                                                            &ErrorType="EMS":U
                                                            &ErrorSubType="ERROR"
                                                            &ErrorParameters="c-seg-usuario + '~~~~' + c-lbl-liter-incluir-alterar-e-eliminar-cot"}
                            END.
                        END.
                    END.
                END.
            END.
        &ELSEIF "{&bf_mat_versao_ems}" >= "2.062" &then
            IF substring(param-compra.char-2,22,1) = "1" AND 
               RowObject.ind-via-envio             = 17  THEN DO:
                FIND FIRST bfcotacao-item NO-LOCK
                    WHERE bfcotacao-item.numero-ordem = rowObject.numero-ordem 
                      AND bfcotacao-item.cod-emitente = rowObject.cod-emitente 
                      AND bfcotacao-item.it-codigo    = rowObject.it-codigo    
                      AND bfcotacao-item.seq-cotac    = rowObject.seq-cotac NO-ERROR.
                IF AVAIL bfcotacao-item THEN DO:
                    IF bfcotacao-item.un           <> rowObject.un            OR
                       bfcotacao-item.possui-reaj  <> rowObject.possui-reaj   OR
                       bfcotacao-item.preco-fornec <> rowObject.preco-fornec  OR
                       bfcotacao-item.mo-codigo    <> rowObject.mo-codigo     OR
                       bfcotacao-item.codigo-ipi   <> rowObject.codigo-ipi    OR
                       bfcotacao-item.aliquota-ipi <> rowObject.aliquota-ipi  OR
                       bfcotacao-item.aliquota-icm <> rowObject.aliquota-icm  OR
                       bfcotacao-item.aliquota-iss <> rowObject.aliquota-iss  OR
                       bfcotacao-item.codigo-icm   <> rowObject.codigo-icm    OR
                       bfcotacao-item.frete        <> rowObject.frete         OR
                       bfcotacao-item.valor-frete  <> rowObject.valor-frete   OR
                       bfcotacao-item.valor-taxa   <> rowObject.valor-taxa    OR
                       bfcotacao-item.taxa-financ  <> rowObject.taxa-financ   OR
                       bfcotacao-item.nr-dias-taxa <> rowObject.nr-dias-taxa  OR
                       bfcotacao-item.perc-descto  <> rowObject.perc-descto   OR
                       bfcotacao-item.valor-descto <> rowObject.valor-descto  OR
                       bfcotacao-item.prazo-entreg <> rowObject.prazo-entreg  THEN DO:
                        FIND FIRST usuar-mater NO-LOCK 
                            WHERE usuar-mater.cod-usuario = c-seg-usuario NO-ERROR.
                        IF AVAIL usuar-mater THEN DO:
                            IF substring(usuar-mater.char-1,13,1) = "1" THEN DO:
                                /* Inicio -- Projeto Internacional */
                                DEFINE VARIABLE c-lbl-liter-cotacao-2 AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "Cota‡Æo" *}
                                ASSIGN c-lbl-liter-cotacao-2 = TRIM(RETURN-VALUE).
                                {method/svc/errors/inserr.i &ErrorNumber="32715"
                                                            &ErrorType="EMS":U
                                                            &ErrorSubType="WARNING"
                                                            &ErrorParameters="c-lbl-liter-cotacao-2"}
                            END.
                            ELSE DO:
                                /* Inicio -- Projeto Internacional */
                                DEFINE VARIABLE c-lbl-liter-incluir-alterar-e-eliminar-cot-2 AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "incluir,_alterar_e_eliminar_cota‡äes_para_processos_de_pregÆo_eletr“nico" *}
                                ASSIGN c-lbl-liter-incluir-alterar-e-eliminar-cot-2 = TRIM(RETURN-VALUE).
                                {method/svc/errors/inserr.i &ErrorNumber="25729"
                                                            &ErrorType="EMS":U
                                                            &ErrorSubType="ERROR"
                                                            &ErrorParameters="c-seg-usuario + '~~~~' + c-lbl-liter-incluir-alterar-e-eliminar-cot-2"}
                            END.
                        END.
                    END.
                END.
            END.
        &ENDIF
    END.     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then     
    &else

        DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

        /*--- Utilize o par³metro pType para identificar quais as valida‡„es a serem
              executadas ---*/
        /*--- Os valores poss¡veis para o par³metro sÆo: Create, Delete e Update ---*/
        /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do
              include: method/svc/errors/inserr.i ---*/
        /*--- Inclua aqui as valida‡„es ---*/

        
        /*Atualiza campos "char" mandatorios e que estao com "?" - isso causa erro no servidor (erro:1444 e erro:110)*/
        IF RowObject.un           = ? THEN ASSIGN RowObject.un           = "".
        IF RowObject.contato      = ? THEN ASSIGN RowObject.contato      = "".
        IF RowObject.cod-comprado = ? THEN ASSIGN RowObject.cod-comprado = "".
        IF RowObject.aprovador    = ? THEN ASSIGN RowObject.aprovador    = "".
        IF RowObject.usuario      = ? THEN ASSIGN RowObject.usuario      = "".
        IF RowObject.hora-atualiz = ? THEN ASSIGN RowObject.hora-atualiz = "".
        IF RowObject.motivo-apr   = ? THEN ASSIGN RowObject.motivo-apr   = "".
        IF RowObject.narrativa    = ? THEN ASSIGN RowObject.narrativa    = "".
        IF RowObject.nr-tab       = ? THEN ASSIGN RowObject.nr-tab       = "".




        FIND FIRST RowObject NO-LOCK NO-ERROR.

        IF pType = "Create":U then DO:
           if can-find( cotacao-item where
                        cotacao-item.numero-ordem = rowObject.numero-ordem and
                        cotacao-item.cod-emitente = rowObject.cod-emitente and
                        cotacao-item.it-codigo    = rowObject.it-codigo    and
                        cotacao-item.seq-cotac    = rowObject.seq-cotac) then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-cotacao-item AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Cota‡Æo_Item" *}
                ASSIGN c-lbl-liter-cotacao-item = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                   &ErrorNumber="8"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="c-lbl-liter-cotacao-item"}
           end.
        END.


        IF pType = "Delete":U then DO:
            find first param-global no-lock no-error.
            if not avail param-global then do:
                        {method/svc/errors/inserr.i &ErrorNumber="16"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="'param-global'"}
            end.

            IF cotacao-item.numero-ordem <> 0 THEN DO:
                find first ordem-compra where 
                     ordem-compra.numero-ordem = cotacao-item.numero-ordem NO-LOCK no-error.
                if not avail ordem-compra then do:
                        /*ordem-compra nÆo encontrada para a chave informada*/
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-ordem-compra AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "ordem-compra" *}
                        ASSIGN c-lbl-liter-ordem-compra = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i &ErrorNumber="2"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="c-lbl-liter-ordem-compra"}
                end.
            END.
        end.

        RUN validaPregaoEletronico.

        /*--- Verifica ocorrˆncia de erros ---*/
        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
            RETURN "NOK":U.

        RETURN "OK":U.

    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

