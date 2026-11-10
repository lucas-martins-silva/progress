

IF ErrorStatus THEN DO:

    ASSIGN i-cont = 0.
    FOR EACH ttError:

        CASE TransactionName:

          WHEN "UnitOfMeasure" THEN /* Inicio -- Projeto Internacional */
DO:
{utp/ut-liter.i "Unidade_Medida" *}

            ASSIGN c-desc-entidade = RETURN-VALUE.
END. 

          WHEN "Item" THEN /* Inicio -- Projeto Internacional */
DO:
{utp/ut-liter.i "Item" *}

            ASSIGN c-desc-entidade = RETURN-VALUE.
END. 

          WHEN "PlaymentPlan" THEN /* Inicio -- Projeto Internacional */
DO:
{utp/ut-liter.i "Condi‡Æo_de_Pagamento" *}

            ASSIGN c-desc-entidade = RETURN-VALUE.
END. 

          WHEN "InventoryGroup" THEN /* Inicio -- Projeto Internacional */
DO:
{utp/ut-liter.i "Grupo_de_estoque" *}

            ASSIGN c-desc-entidade = RETURN-VALUE.
END. 

          WHEN "VendorItem" THEN /* Inicio -- Projeto Internacional */
DO:
{utp/ut-liter.i "Item_x_Fornecedor" *}

            ASSIGN c-desc-entidade = RETURN-VALUE.
END. 

          WHEN "CustomerVendor" THEN /* Inicio -- Projeto Internacional */
DO:
{utp/ut-liter.i "Fornecedor" *}

            ASSIGN c-desc-entidade = RETURN-VALUE.
END. 

          WHEN "Site" THEN /* Inicio -- Projeto Internacional */
DO:
{utp/ut-liter.i "Estabelecimento" *}

            ASSIGN c-desc-entidade = RETURN-VALUE.
END. 

          WHEN "Carrier" THEN /* Inicio -- Projeto Internacional */
DO:
{utp/ut-liter.i "Transportador" *}

			ASSIGN c-desc-entidade = RETURN-VALUE.
END. 
			
		  WHEN "Currency" THEN /* Inicio -- Projeto Internacional */
DO:
{utp/ut-liter.i "Moeda" *}

			ASSIGN c-desc-entidade = RETURN-VALUE.	
END. 

          WHEN "CurrencyRate" THEN /* Inicio -- Projeto Internacional */
DO:
{utp/ut-liter.i "Cota‡Æo_de_Moeda" *}

            ASSIGN c-desc-entidade = RETURN-VALUE.
END. 

          WHEN "MaterialUser" THEN /* Inicio -- Projeto Internacional */
DO:
{utp/ut-liter.i "Comprador" *}

            ASSIGN c-desc-entidade = RETURN-VALUE.
END. 

          WHEN "PurchaseOrderLine" THEN /* Inicio -- Projeto Internacional */
DO:
{utp/ut-liter.i "Ordem_de_compra" *}

            ASSIGN c-desc-entidade = RETURN-VALUE.
END. 

          WHEN "PurchaseOrder" THEN /* Inicio -- Projeto Internacional */
DO:
{utp/ut-liter.i "Pedido_de_compra" *}

            ASSIGN c-desc-entidade = RETURN-VALUE.
END. 
        END CASE.

        ASSIGN i-cont = i-cont + 1.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Erro_ao_integrar" *}
        RUN setError IN hMessageHandler (INPUT i-cont,
                                         INPUT "business_error",
                                         INPUT RETURN-VALUE + " " + c-desc-entidade + ": " + ttError.ErrorDescription + " (" + ttError.ErrorCode + ")").

        CREATE tt_log_erro.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Erro_ao_integrar" *}
        ASSIGN tt_log_erro.ttv_num_cod_erro = i-cont
               tt_log_erro.ttv_des_msg_erro = RETURN-VALUE + " " + c-desc-entidade + ": " + ttError.ErrorDescription + " (" + ttError.ErrorCode + ")".

    END.

END.
