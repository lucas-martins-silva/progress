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
{include/i-prgvrs.i BOIN841FX 2.00.00.003 } /*** "010003" 07/06/2024 18:26:49  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN841FX MEN}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ≤ um programa PROGRESS
                 que cont≤m a lΩgica de negΩcio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      : BO utilizado apenas para navegaá∆o default e openQueries
                 com apenas uma tabela.
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiªío ---*/
&GLOBAL-DEFINE DBOName item-fornec-umd
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName item-fornec-umd
&GLOBAL-DEFINE TableLabel item-fornec-umd
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com definiªío da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diretΩrio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idºntico ao nome do DBO mas com
      extensío .i ---*/
{inbo/boin841.i RowObject}

/*--- Include com definiªío da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraªío da definiªío da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiªío
      manual da query ---*/
{method/dboqry.i}

/** N∆o elimine a linha abaixo, Ç a chamada EPC **/
{include/i-epc200.i "boin841fx"}

/*Includes FLEX*/
{fch/fchmat/fchmatitemvendorunit.i ttItemVendorUnitVO} 
{fch/fchmat/fchmatitemvendorunit.i ttItemVendorUnitVO2}
{fch/fchmat/fchmatitemvendor.i ttItemVendorVO} 
{fch/fchmat/fchmatstring.i ttStringVO} 

/******************************ATENCAO*************************************
 Pre-processador abaixo responsavel por distinguir o produto que
 esta executando o componente ( Magnus ou EMS ). 
 Se estiver definida a variavel bf-mat-comex 
 ( &if defined(bf-mat-comex) &then ), significa que o produto
 chamador e o Magnus se n∆o, EMS. Utilizado pelo produto Comercio Exterior
**************************************************************************/ 
{cdp/cdcfgmat.i} /* Definicao de pre-processadores - Magnus ou EMS */
{include/i_dbvers.i}
{utp/ut-glob.i}

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
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 2.57
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

/* ************************  Function Prototypes ********************** */
/*
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-cgc DBOProgram 
FUNCTION fn-cgc RETURNS CHARACTER
  ( INPUT i-cod-emitente AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
*/

/**************************** Procedures ************************/
PROCEDURE getItemVendorUnitsIndexes:
/*------------------------------------------------------------------------------
  Purpose:     Retorna °ndices de convers∆o de unidades de medida da 
               Relaá∆o Item X Fornecedor X Unidade Medida
  Parameters:  retorna temptables ttItemVendorUnitVO e RowErrors
  Notes:       
------------------------------------------------------------------------------*/
	DEF input PARAM TABLE FOR ttItemVendorUnitVO.
    def output param table for ttItemVendorUnitVO2.
	DEF OUTPUT PARAM TABLE FOR RowErrors.

    DEF VAR de-indice AS DECIMAL.
	
	for each ttItemVendorUnitVO:
        create ttItemVendorUnitVO2.
        buffer-copy ttItemVendorUnitVO to ttItemVendorUnitVO2 no-error.
		find first item no-lock
			where item.it-codigo = ttItemVendorUnitVO.itemCode no-error.
		if avail item then do:
			{cdp/cd9950.i
                item.un
                ttItemVendorUnitVO.unitOfMeasure 
                ttItemVendorUnitVO.vendorCode}

			assign ttItemVendorUnitVO2.indexToConvertion = de-indice.			
		end.	
	end.
end procedure.

PROCEDURE getItemVendorUnits:
/*------------------------------------------------------------------------------
  Purpose:     Retorna registros de unidades de medida da 
               Relaá∆o Item X Fornecedor X Unidade Medida
  Parameters:  retorna temptables ttItemVendorUnitVO e RowErrors
  Notes:       
------------------------------------------------------------------------------*/


    DEF INPUT  PARAM TABLE FOR ttItemVendorVO.
    DEF OUTPUT PARAM TABLE FOR ttItemVendorUnitVO2.
    DEF OUTPUT PARAM TABLE FOR RowErrors.
    find first param-compra no-lock no-error.
    empty temp-table ttItemVendorUnitVO no-error.
    for each ttItemVendorVO:
        for first item-fornec fields(it-codigo cod-emitente unid-med-for)
            where item-fornec.it-codigo    = ttItemVendorVO.itemCode
              and item-fornec.cod-emitente = ttItemVendorVO.vendorCode no-lock: end.
        if avail item-fornec then do:
            create ttItemVendorUnitVO.
            assign ttItemVendorUnitVO.itemCode      = item-fornec.it-codigo
                   ttItemVendorUnitVO.vendorCode    = item-fornec.cod-emitente
                   ttItemVendorUnitVO.unitOfMeasure = item-fornec.unid-med-for
                   ttItemVendorUnitVO.enableFunctionMultipleUnits = avail param-compra and param-compra.log-multi-unid-medid.
            for first tab-unidade where tab-unidade.un = item-fornec.unid-med-for no-lock:
                assign ttItemVendorUnitVO.unitOfMeasureDescription = tab-unidade.descricao.
            end.
            if avail param-compra 
                 and param-compra.log-multi-unid-medid then do:
                for each item-fornec-umd fields (it-codigo cod-emitente unid-med-for) no-lock
                   where item-fornec-umd.it-codigo    = item-fornec.it-codigo
                     and item-fornec-umd.cod-emitente = item-fornec.cod-emitente
					 and item-fornec-umd.log-ativo    = yes:
                    create ttItemVendorUnitVO.
                    assign ttItemVendorUnitVO.itemCode          = item-fornec-umd.it-codigo
                           ttItemVendorUnitVO.vendorCode        = item-fornec-umd.cod-emitente
                           ttItemVendorUnitVO.unitOfMeasure     = item-fornec-umd.unid-med-for
                           ttItemVendorUnitVO.enableFunctionMultipleUnits = avail param-compra and param-compra.log-multi-unid-medid.
                    for first tab-unidade where tab-unidade.un  = item-fornec-umd.unid-med-for no-lock:
                        assign ttItemVendorUnitVO.unitOfMeasureDescription = tab-unidade.descricao.
                    end.
                end.
            end.
        end.
        else do:        
            /*--- UPC ---*/
            if  c-nom-prog-dpc-mg97  <> "":U
            or  c-nom-prog-appc-mg97 <> "":U
            or  c-nom-prog-upc-mg97  <> "":U then do:
    
                FOR EACH tt-epc:
                    DELETE tt-epc.
                END.
    
                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "BOIN841FX_LoadUnitOfMeasure"
                       tt-epc.cod-parameter = "LoadUnitOfMeasure"
                       tt-epc.val-parameter = "YES".
    
                {include/i-epc201.i "BOIN841FX_LoadUnitOfMeasure"}    
                
            end. 
        
            find first tt-epc
                     where tt-epc.cod-event     = "BOIN841FX_LoadUnitOfMeasure"
                     and   tt-epc.cod-parameter = "ReturnUnitOfMeasure"
                     AND   tt-epc.val-parameter = "YES"
                     no-lock no-error.
            if  available tt-epc then DO:   
                /*REGRA CUSTOMIZA«√O - CARREGA APENAS A UNIDADE INTERNA DO ITEM*/ 
                find first item no-lock
    			where item.it-codigo = ttItemVendorVO.itemCode no-error.
    	         if avail item then do:
                    create ttItemVendorUnitVO.
                    assign ttItemVendorUnitVO.itemCode      = ttItemVendorVO.itemCode
                           ttItemVendorUnitVO.vendorCode    = ttItemVendorVO.vendorCode
                           ttItemVendorUnitVO.unitOfMeasure = item.un 
                           ttItemVendorUnitVO.enableFunctionMultipleUnits = avail param-compra and param-compra.log-multi-unid-medid.
                   for first tab-unidade where tab-unidade.un = item.un no-lock:
                       assign ttItemVendorUnitVO.unitOfMeasureDescription = tab-unidade.descricao.
                   end.                
                END.    
            END.
            ELSE DO:
                /*REGRA PRODUTO - CARREGA TODOS AS UNIDADE DE MEDIDAS*/
                for each tab-unidade no-lock:
                    create ttItemVendorUnitVO.
                    assign ttItemVendorUnitVO.itemCode      = ttItemVendorVO.itemCode
                           ttItemVendorUnitVO.vendorCode    = ttItemVendorVO.vendorCode 
                           ttItemVendorUnitVO.unitOfMeasure = tab-unidade.un
                           ttItemVendorUnitVO.unitOfMeasureDescription = tab-unidade.descricao
                           ttItemVendorUnitVO.enableFunctionMultipleUnits = avail param-compra and param-compra.log-multi-unid-medid.
                end.
            END.
            FOR EACH tt-epc:
                    DELETE tt-epc.
            END.
         end.  
      end.
      run getItemVendorUnitsIndexes (input table ttItemVendorUnitVO,   
                                     output table ttItemVendorUnitVO2,
                                     output table RowErrors).   
end procedure.

PROCEDURE getQuotationQuantityConverted:
/*------------------------------------------------------------------------------
  Purpose:     Busca quantidade da cotaá∆o convertida conforme fator de convers∆o
               da unidade de medida da cotaá∆o.
  Parameters:  recebe item x fornecedor x unidade e n£mero da ordem
               retorna quantidade convertida
  Notes:       
------------------------------------------------------------------------------*/


    DEF INPUT PARAM TABLE FOR ttItemVendorUnitVO.
    DEF INPUT PARAM purchaseRequisition AS integer.
    DEF OUTPUT PARAM TABLE FOR ttStringVO.
    DEF OUTPUT PARAM TABLE FOR RowErrors.

    def var de-quantidade like ordem-compra.qt-solic no-undo. 
    DEF VAR de-indice AS decimal no-undo.
    def var c-un      like item.un no-undo.
	
    for first ttItemVendorUnitVO no-lock:
       
       find first item no-lock
			where item.it-codigo = ttItemVendorUnitVO.itemCode no-error.
		if avail item then do:
            assign c-un = item.un.
            for first ordem-compra 
                where ordem-compra.numero-ordem = purchaseRequisition no-lock:
                for first prazo-compra 
                    where prazo-compra.numero-ordem = ordem-compra.numero-ordem no-lock:
                    assign c-un = prazo-compra.un.
                end.
                assign de-quantidade = ordem-compra.qt-solic.
            end.
			{cdp/cd9950.i
                c-un
                ttItemVendorUnitVO.unitOfMeasure 
                ttItemVendorUnitVO.vendorCode}
            create ttStringVO.
			assign ttStringVO.stringName = string(de-quantidade * de-indice).			
		end.	
	end.

    
end procedure.


/* ************************  Function Implementations ***************** */

/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-cgc DBOProgram 
FUNCTION fn-cgc RETURNS CHARACTER
  ( INPUT i-cod-emitente AS INT) :

  DEF VAR c-format AS CHAR FORMAT "X(20)" NO-UNDO.
  DEF VAR c-cgc    AS CHAR FORMAT "X(20)" NO-UNDO.

  ASSIGN c-format = "X(19)".
  IF NOT AVAIL param-global THEN
     FIND FIRST param-global NO-LOCK NO-ERROR.

  IF NOT AVAIL emitente OR 
        (AVAIL emitente AND emitente.cod-emitente <>  i-cod-emitente )THEN
      FIND FIRST emitente 
            WHERE emitente.cod-emitente = i-cod-emitente NO-LOCK NO-ERROR.

   IF AVAIL emitente AND AVAIL param-global THEN DO:
      IF emitente.natureza = 1 THEN
          ASSIGN c-format = formato-id-pessoal.
      ELSE
          IF emitente.natureza = 2 THEN
             ASSIGN c-format = formato-id-federal.   
      ASSIGN c-cgc = STRING(emitente.cgc, c-format).
   END.

  RETURN c-cgc.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME*/
