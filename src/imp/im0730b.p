/********************************************************************************
** Copyright DATASUL S.A. (2014)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0730B 2.00.00.033 } /*** "010033" 17/08/2026 03:18:46 ***/

{include/i-epc200.i im0730b}

&IF "{&EMSFND_VERSION}":U >= "1.00":U &THEN
    {include/i-license-manager.i im0730b MIM}
&ENDIF

{imp/im0730.i} /* Include com a tt-param */

PROCEDURE pi-traduz-literais:
/*------------------------------------------------------------------------------
  Purpose:     Busca a traduá∆o das literais
  Parameters:  p-valor-linha: Valor da linha (character)
               tt-param: Temp-table de parÉmetros (temp-table)
               p-valor-literal: Valor da literal (character)
               p-tipo-formatacao: Tipo da formataáao do campo (character)
               p-alinha-direita: Indica se deve ser alinhado a direita (logical)
                
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM p-valor-linha       AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM TABLE FOR tt-param.
    DEFINE OUTPUT PARAM p-valor-literal     AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAM p-tipo-formatacao   AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAM p-alinha-direita    AS LOGICAL NO-UNDO.

    FIND FIRST tt-param NO-ERROR.

    ASSIGN p-valor-literal = ?.
    
    /* Traduz Literais */
    IF p-valor-linha MATCHES "*#lit-*":U  THEN DO:

        /* Traduz literais do Pedido de Compra */
        IF tt-param.lPedidoCompra AND p-valor-linha MATCHES "*#lit-pc-*":U THEN DO:

            CASE p-valor-linha:

                WHEN TRIM("#lit-pc-num-pedido	":U) THEN DO: 
                    {utp/ut-liter.i Pedido }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pc-cod-estabel	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Estabel }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pc-data-pedido	":U) THEN DO: 
                    {utp/ut-liter.i Data_Pedido }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pc-cod-emitente	":U) THEN DO: 
                    {utp/ut-liter.i Fornecedor }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.
                END.
                WHEN TRIM("#lit-pc-cod-emit-terc	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Emit_Entrega }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.
                END.
                WHEN TRIM("#lit-pc-nr-processo	":U) THEN DO: 
                    {utp/ut-liter.i Processo }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.
                END.
                WHEN TRIM("#lit-pc-cod-transp	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Transp }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.
                END.
                WHEN TRIM("#lit-pc-des-via-transp	":U) THEN DO: 
                    {utp/ut-liter.i Via_Transporte }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.
                END.
                WHEN TRIM("#lit-pc-cod-cond-pag	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Cond_Pagto }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.
                END.
                WHEN TRIM("#lit-pc-responsavel	":U) THEN DO: 
                    {utp/ut-liter.i Respons†vel }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                           p-tipo-formatacao = "@":U.
                END.
                WHEN TRIM("#lit-pc-nr-contrato	":U) THEN DO: 
                    {utp/ut-liter.i N£mero_Contrato }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.
                END.
                WHEN TRIM("#lit-pc-situacao	":U) THEN DO: 
                    {utp/ut-liter.i Situaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                           p-tipo-formatacao = "@":U.
                END.
                WHEN TRIM("#lit-pc-nome-estabel	":U) THEN DO: 
                    {utp/ut-liter.i Estabelecimento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.
                END.
                WHEN TRIM("#lit-pc-nome-ab-terc	":U) THEN DO: 
                    {utp/ut-liter.i Emitente_Entrega }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pc-nome-ab-transp	":U) THEN DO: 
                    {utp/ut-liter.i Transportador }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.
                END.
                WHEN TRIM("#lit-pc-des-cond-pag	":U) THEN DO: 
                    {utp/ut-liter.i Condiá∆o_Pagamento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                           p-tipo-formatacao = "@":U.
                END.
            END.
        END.
            
        /* Traduz literais do Fornecedor */
        IF tt-param.lFornecedor AND p-valor-linha MATCHES "*#lit-for-*":U THEN DO:

            CASE p-valor-linha:

                WHEN TRIM("#lit-for-cod-emitente	":U) THEN DO: 
                    {utp/ut-liter.i C¢digo }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.
                END.
                WHEN TRIM("#lit-for-nome-abrev	":U) THEN DO: 
                    {utp/ut-liter.i Nome_Abreviado }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.
                END.
                WHEN TRIM("#lit-for-nome-emit	":U) THEN DO: 
                    {utp/ut-liter.i Nome }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.
                END.
                WHEN TRIM("#lit-for-endereco	":U) THEN DO: 
                    {utp/ut-liter.i Endereáo }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.
                END.
                WHEN TRIM("#lit-for-bairro	":U) THEN DO: 
                    {utp/ut-liter.i Bairro }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.
                END.
                WHEN TRIM("#lit-for-cidade	":U) THEN DO: 
                    {utp/ut-liter.i Cidade }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.
                           
                END.
                WHEN TRIM("#lit-for-estado	":U) THEN DO: 
                    {utp/ut-liter.i UF }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-for-cep	":U) THEN DO: 
                    {utp/ut-liter.i CEP }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-for-cod-pais":U) THEN DO: 
                    {utp/ut-liter.i C¢digo_Pa°s }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-for-pais	":U) THEN DO: 
                    {utp/ut-liter.i Pa°s }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-for-zip-code	":U) THEN DO: 
                    {utp/ut-liter.i Zip_Code }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-for-endereco_text	":U) THEN DO: 
                    {utp/ut-liter.i Endereáo_Completo }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-for-cod-gr-forn	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Grupo }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-for-contato	":U) THEN DO: 
                    {utp/ut-liter.i Contato }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-for-telefone-1	":U) THEN DO: 
                    {utp/ut-liter.i Telefone_1 }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-for-telefone-2	":U) THEN DO: 
                    {utp/ut-liter.i Telefone_2 }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-for-ramal-1	":U) THEN DO: 
                    {utp/ut-liter.i Ramal_1 }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-for-ramal-2	":U) THEN DO: 
                    {utp/ut-liter.i Ramal_2 }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-for-caixa-postal	":U) THEN DO: 
                    {utp/ut-liter.i Caixa_Postal }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-for-e-mail	":U) THEN DO: 
                    {utp/ut-liter.i E-mail }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-for-cod-idioma	":U) THEN DO: 
                    {utp/ut-liter.i Idioma_Padr∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-for-cod-rep	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Representante }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-for-cod-itiner-imp	":U) THEN DO: 
                    {utp/ut-liter.i C¢digo_Itiner†rio_Padr }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-for-cod-incoterm-imp	":U) THEN DO: 
                    {utp/ut-liter.i Incoterm }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-for-cod-ident-fisc-exter	":U) THEN DO: 
                    {utp/ut-liter.i Identificacao_Fiscal }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-for-des-gr-forn	":U) THEN DO: 
                    {utp/ut-liter.i Grupo }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-for-des-itiner-imp	":U) THEN DO: 
                    {utp/ut-liter.i Itiner†rio_Padr∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
            END.
        END.
        /* Traduz literais do Processo de Importaá∆o */
        IF tt-param.lProcessoImp AND p-valor-linha MATCHES "*#lit-pi-*":U THEN DO:

            CASE p-valor-linha:

                WHEN TRIM("#lit-pi-cod-estabel	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Estabel }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-nr-proc-imp	":U) THEN DO: 
                    {utp/ut-liter.i Processo_Importaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-num-pedido	":U) THEN DO: 
                    {utp/ut-liter.i Pedido }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-cod-itiner	":U) THEN DO: 
                    {utp/ut-liter.i C¢digo_Itiner†rio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-dt-emissao	":U) THEN DO: 
                    {utp/ut-liter.i Data_Emiss∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-cod-transportador	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Transportador }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-des-via-transp	":U) THEN DO: 
                    {utp/ut-liter.i Via_Transporte }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-des-situacao	":U) THEN DO: 
                    {utp/ut-liter.i Situaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-cdn-corretor-cambio-import	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Corretor_CÉmbio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-cdn-despa-exter-import	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Despachante_Ext }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-cdn-segurad-import	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Seguradora }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-cdn-corretor-import	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Corretor }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-cod-despachante	":U) THEN DO: 
                    {utp/ut-liter.i C¢digo_Despachante }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-cod-exportador	":U) THEN DO: 
                    {utp/ut-liter.i C¢digo_Exportador }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-cod-consignatario	":U) THEN DO: 
                    {utp/ut-liter.i C¢digo_Consignat†rio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-cod-agente	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Agente_Cargas }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-nr-conhecimento	":U) THEN DO: 
                    {utp/ut-liter.i Conhecimento_Transporte }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-carta-credito	":U) THEN DO: 
                    {utp/ut-liter.i Carta_CrÇdito }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-destino-documentacao	":U) THEN DO: 
                    {utp/ut-liter.i Destino_da_Documentaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-regime-import	":U) THEN DO: 
                    {utp/ut-liter.i Regime_Importaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-estab-fisc	":U) THEN DO: 
                    {utp/ut-liter.i Estabel_Fiscal }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-contrato-cambio	":U) THEN DO: 
                    {utp/ut-liter.i Contrato_CÉmbio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-nome-estabel	":U) THEN DO: 
                    {utp/ut-liter.i Estabelecimento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-des-itiner	":U) THEN DO: 
                    {utp/ut-liter.i Itiner†rio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-nome-ab-transp	":U) THEN DO: 
                    {utp/ut-liter.i Transportador }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-nome-corretor-cambio	":U) THEN DO: 
                    {utp/ut-liter.i Corretor_CÉmbio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-nome-despa-exter	":U) THEN DO: 
                    {utp/ut-liter.i Despachante_Ext }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-nome-segurad	":U) THEN DO: 
                    {utp/ut-liter.i Seguradora }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-nome-corretor	":U) THEN DO: 
                    {utp/ut-liter.i Corretor }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-nome-despachante	":U) THEN DO: 
                    {utp/ut-liter.i Despachante }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-nome-consignatario	":U) THEN DO: 
                    {utp/ut-liter.i Consignat†rio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-pi-nome-agente	":U) THEN DO: 
                    {utp/ut-liter.i Agente_Cargas }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
            END.
        END.
        /* Traduz literais da Ordem de Compra */
        IF tt-param.lOrdemCompra AND p-valor-linha MATCHES "*#lit-oc-*":U THEN DO:

            CASE p-valor-linha:

                WHEN TRIM("#lit-oc-num-pedido	":U) THEN DO: 
                    {utp/ut-liter.i Pedido }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-numero-ordem	":U) THEN DO: 
                    {utp/ut-liter.i Ordem }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-it-codigo	":U) THEN DO: 
                    {utp/ut-liter.i Item }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-cod-estabel	":U) THEN DO: 
                    {utp/ut-liter.i Estabelecimento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-requisitante	":U) THEN DO: 
                    {utp/ut-liter.i Requisitante }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-cod-comprado	":U) THEN DO: 
                    {utp/ut-liter.i Comprador }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-cod-unid-negoc	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Unidade_Neg¢cio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-ct-codigo	":U) THEN DO: 
                    {utp/ut-liter.i Conta }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-sc-codigo	":U) THEN DO: 
                    {utp/ut-liter.i Centro_Custo }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-tp-despesa	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Tipo_Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-data-emissao	":U) THEN DO: 
                    {utp/ut-liter.i Data_Emiss∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#des-cod-unid-negoc	":U) THEN DO: 
                    {utp/ut-liter.i Unidade_Neg¢cio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-des-ct-codigo	":U) THEN DO: 
                    {utp/ut-liter.i Desc_Conta }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-des-sc-codigo	":U) THEN DO: 
                    {utp/ut-liter.i Desc_Centro_Custo }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-des-situacao	":U) THEN DO: 
                    {utp/ut-liter.i Situaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-qt-solic	":U) THEN DO: 
                    {utp/ut-liter.i Qtde }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-oc-nr-contrato	":U) THEN DO: 
                    {utp/ut-liter.i N£mero_Contrato }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-num-seq-item	":U) THEN DO: 
                    {utp/ut-liter.i Sequància_Item }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-narrativa	":U) THEN DO: 
                    {utp/ut-liter.i Narrativa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-data-cotacao	":U) THEN DO: 
                    {utp/ut-liter.i Data_Cotaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-un	":U) THEN DO: 
                    {utp/ut-liter.i Unidade_Medida }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-preco-unit	":U) THEN DO: 
                    {utp/ut-liter.i Preáo_Unit†rio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U 
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-oc-pre-unit-for	":U) THEN DO: 
                    {utp/ut-liter.i Preáo_Unit_Fornec }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-oc-preco-fornec	":U) THEN DO: 
                    {utp/ut-liter.i Preáo_Fornecedor }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-oc-mo-codigo	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-frete	":U) THEN DO: 
                    {utp/ut-liter.i Frete_Incluso }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-valor-frete	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Frete }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U 
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-oc-aliquota-ipi	":U) THEN DO: 
                    {utp/ut-liter.i Aliquota_IPI }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U 
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-oc-aliquota-icm	":U) THEN DO: 
                    {utp/ut-liter.i Aliquota_ICMS }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U 
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-oc-aliquota-ii	":U) THEN DO: 
                    {utp/ut-liter.i Al°quota_II }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-oc-valor-taxa	":U) THEN DO: 
                    {utp/ut-liter.i Taxa_Financ }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U 
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-oc-perc-descto	":U) THEN DO: 
                    {utp/ut-liter.i %_Descto }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-oc-valor-descto	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Descto }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U 
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-oc-cod-incoterm	":U) THEN DO: 
                    {utp/ut-liter.i Incoterm }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-cod-fabricante	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Fabricante }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-nome-abrev-fabricante	":U) THEN DO: 
                    {utp/ut-liter.i Nome_Fabricante }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-nome-estabel	":U) THEN DO: 
                    {utp/ut-liter.i Nome_Estabelecimento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-regime-impot	":U) THEN DO: 
                    {utp/ut-liter.i Regime_Importaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-des-cod-unid-negoc	":U) THEN DO: 
                    {utp/ut-liter.i Unidade_Neg¢cio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-des-moeda	":U) THEN DO: 
                    {utp/ut-liter.i Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-des-tp-despesa	":U) THEN DO: 
                    {utp/ut-liter.i Tipo_Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-cod-pto-controle-base  ":U) THEN DO: 
                    {utp/ut-liter.i Cod_Ponto_Controle_Base }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-des-pto-controle-base	":U) THEN DO: 
                    {utp/ut-liter.i Ponto_Controle_Base }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-mapa-cotacao	":U) THEN DO: 
                    {utp/ut-liter.i Mapa_Cotaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-cdn-pais-orig	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Pa°s_Origem }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-des-pais-orig	":U) THEN DO: 
                    {utp/ut-liter.i Pa°s_Origem }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-ex-tarifario	":U) THEN DO: 
                    {utp/ut-liter.i Ex-tarif†rio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-cod-itinerario	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Itiner†rio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-oc-des-itinerario	":U) THEN DO: 
                    {utp/ut-liter.i Itiner†rio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
            END.
        END.
        /* Traduz literais do Item */
        IF tt-param.lItem AND p-valor-linha MATCHES "*#lit-it-*":U THEN DO:

            CASE p-valor-linha:

                WHEN TRIM("#lit-it-it-codigo	":U) THEN DO: 
                    {utp/ut-liter.i Item }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-it-desc-item	":U) THEN DO: 
                    {utp/ut-liter.i Descriá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-it-narrativa	":U) THEN DO: 
                    {utp/ut-liter.i Narrativa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-it-un	":U) THEN DO: 
                    {utp/ut-liter.i Unid_Medida }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-it-ge-codigo	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Grupo_Estoque }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-it-fm-codigo	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Fam°lia }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-it-inform-compl	":U) THEN DO: 
                    {utp/ut-liter.i Inf_Complementar }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-it-des-obsoleto	":U) THEN DO: 
                    {utp/ut-liter.i Situaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-it-class-fiscal	":U) THEN DO: 
                    {utp/ut-liter.i Classificaá∆o_Fiscal }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = '0000"."00"."00':U.
                END.
                WHEN TRIM("#lit-it-des-codigo-orig	":U) THEN DO: 
                    {utp/ut-liter.i Origem }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-it-des-tipo-contr	":U) THEN DO: 
                    {utp/ut-liter.i Tipo_Controle }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-it-ge-descricao	":U) THEN DO: 
                    {utp/ut-liter.i Grupo_Estoque }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-it-fm-descricao	":U) THEN DO: 
                    {utp/ut-liter.i Fam°lia }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
            END. 
        END.
        /* Traduz literais do Embarque */
        IF tt-param.lEmbarqueImp AND p-valor-linha MATCHES "*#lit-emb-*":U THEN DO:

            CASE p-valor-linha:

                WHEN TRIM("#lit-emb-cod-estabel	":U) THEN DO: 
                    {utp/ut-liter.i Estabelecimento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-embarque	":U) THEN DO: 
                    {utp/ut-liter.i Embarque }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-cod-despachante	":U) THEN DO: 
                    {utp/ut-liter.i C¢digo_Despachante }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-cod-transportador	":U) THEN DO: 
                    {utp/ut-liter.i C¢digo_Transportador }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-des-via-transp	":U) THEN DO: 
                    {utp/ut-liter.i Via_Transporte }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-cod-incoterm	":U) THEN DO: 
                    {utp/ut-liter.i Incoterm }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-declaracao-import	":U) THEN DO: 
                    {utp/ut-liter.i Declaraá∆o_Importaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-data-DI	":U) THEN DO: 
                    {utp/ut-liter.i Data_DI }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-carta-credito	":U) THEN DO: 
                    {utp/ut-liter.i Carta_CrÇdito }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-narrativa	":U) THEN DO: 
                    {utp/ut-liter.i Narrativa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-des-situacao	":U) THEN DO: 
                    {utp/ut-liter.i Situaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-embarque-ori	":U) THEN DO: 
                    {utp/ut-liter.i Embarque_Original }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-cod-conhecto-master	":U) THEN DO: 
                    {utp/ut-liter.i Conhecimento_Master }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-cod-conhecto-house	":U) THEN DO: 
                    {utp/ut-liter.i Conhecimento_House }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-cdn-corretor-cambio-import	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Corretor_CÉmbio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-cdn-despa-exter-import	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Despachante_Ext }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-cdn-segurad-import	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Seguradora }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-cdn-corretor-import	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Corretor }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-cdn-pto-despch	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Ponto_Despacho }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-cdn-pto-embarq	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Ponto_Embarque }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-cdn-pto-desembar	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Ponto_Desembarque }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-cdn-pto-chegad	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Ponto_Chegada_Empresa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-nome-despachante	":U) THEN DO: 
                    {utp/ut-liter.i Despachante }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-nome-transportador	":U) THEN DO: 
                    {utp/ut-liter.i Transportador }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-nome-corretor-cambio	":U) THEN DO: 
                    {utp/ut-liter.i Corretor_CÉmbio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-nome-despa-exter	":U) THEN DO: 
                    {utp/ut-liter.i Despachante_Ext }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-nome-estabel	":U) THEN DO: 
                    {utp/ut-liter.i Nome_Estabelecimento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-nome-segurad	":U) THEN DO: 
                    {utp/ut-liter.i Seguradora }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-nome-corretor	":U) THEN DO: 
                    {utp/ut-liter.i Corretor }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-des-pto-despch	":U) THEN DO: 
                    {utp/ut-liter.i Ponto_Despacho }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-des-pto-embarq	":U) THEN DO: 
                    {utp/ut-liter.i Ponto_Embarque }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-des-pto-desembar	":U) THEN DO: 
                    {utp/ut-liter.i Ponto_Desembarque }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-des-pto-chegad	":U) THEN DO: 
                    {utp/ut-liter.i Ponto_Chegada_Empresa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-di-ems 	":U) THEN DO: 
                    {utp/ut-liter.i DI_EMS }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-des-natur-cambial	":U) THEN DO: 
                    {utp/ut-liter.i Natureza_Cambial }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-rof	":U) THEN DO: 
                    {utp/ut-liter.i ROF }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-dias-transporte-total	":U) THEN DO: 
                    {utp/ut-liter.i Dias_Transporte_Total }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-contabilizado":U) THEN DO: 
                    {utp/ut-liter.i Contabilizado }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-emb-pto-incoterm":U) THEN DO: 
                    {utp/ut-liter.i Pto_Incoterm_Relacionada }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
            END.
        END.
        /* Traduz literais das Parcelas */
        IF tt-param.lParcelas AND p-valor-linha MATCHES "*#lit-par-*":U THEN DO:

            CASE p-valor-linha:

                WHEN TRIM("#lit-par-numero-ordem	":U) THEN DO: 
                    {utp/ut-liter.i Ordem }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-par-parcela	":U) THEN DO: 
                    {utp/ut-liter.i Parcela }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-par-quantidade	":U) THEN DO: 
                    {utp/ut-liter.i Qtde }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-par-un	":U) THEN DO: 
                    {utp/ut-liter.i Unid_Medida }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-par-cod-refer	":U) THEN DO: 
                    {utp/ut-liter.i Referància }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-par-qtd-sal-forn	":U) THEN DO: 
                    {utp/ut-liter.i Qtde_Saldo_Fornec }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-par-quantid-orig	":U) THEN DO: 
                    {utp/ut-liter.i Qtde_Original }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-par-quant-saldo	":U) THEN DO: 
                    {utp/ut-liter.i Qtde_Saldo }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-par-quant-rejeit	":U) THEN DO: 
                    {utp/ut-liter.i Qtde_Dev }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-par-quant-receb	":U) THEN DO: 
                    {utp/ut-liter.i Qtde_Recebida }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-par-data-entrega	":U) THEN DO: 
                    {utp/ut-liter.i Data_Entrega }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-par-des-situacao	":U) THEN DO: 
                    {utp/ut-liter.i Situaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-par-licenca-import	":U) THEN DO: 
                    {utp/ut-liter.i Licenáa_Importaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
            END.
        END.
        /* Traduz literais do Hist¢rico Embarque */
        IF tt-param.lAcompEmb AND p-valor-linha MATCHES "*#lit-he-*":U THEN DO:

            CASE p-valor-linha:

                WHEN TRIM("#lit-he-cod-estabel	":U) THEN DO: 
                    {utp/ut-liter.i Estabelecimento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-he-embarque	":U) THEN DO: 
                    {utp/ut-liter.i Embarque }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-he-cod-itiner	":U) THEN DO: 
                    {utp/ut-liter.i C¢digo_Itiner†rio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-he-cod-pto-contr	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Ponto_Controle }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-he-sequencia	":U) THEN DO: 
                    {utp/ut-liter.i Seq }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-he-id-meio-transp	":U) THEN DO: 
                    {utp/ut-liter.i Ve°culo_Transp }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-he-dt-previsao	":U) THEN DO: 
                    {utp/ut-liter.i Previs∆o_Original }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-he-dt-ult-previsao	":U) THEN DO: 
                    {utp/ut-liter.i Èltima_Previs∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-he-dt-efetiva	":U) THEN DO: 
                    {utp/ut-liter.i Data_Efetiva }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-he-observacao	":U) THEN DO: 
                    {utp/ut-liter.i Obs }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-he-descricao	":U) THEN DO: 
                    {utp/ut-liter.i Descriá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-he-nr-dias	":U) THEN DO: 
                    {utp/ut-liter.i Dias_Trajeto }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-he-des-itiner	":U) THEN DO: 
                    {utp/ut-liter.i Itiner†rio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-he-nome-estabel	":U) THEN DO: 
                    {utp/ut-liter.i Nome_Estabelecimento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
            END.
        END.
        /* Traduz literais de Despesas do Embarque */
        IF tt-param.lAcompEmb AND p-valor-linha MATCHES "*#lit-de-*":U THEN DO:

            CASE p-valor-linha:
                WHEN TRIM("#lit-de-cod-estabel	":U) THEN DO: 
                    {utp/ut-liter.i Estabelecimento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-de-embarque	":U) THEN DO: 
                    {utp/ut-liter.i Embarque }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-de-cod-itiner	":U) THEN DO: 
                    {utp/ut-liter.i C¢digo_Itiner†rio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-de-cod-pto-contr	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Ponto_Controle }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-de-cod-desp	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-de-cod-emitente-desp	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Fornec_Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-de-cod-cond-pag	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Cond_Pagto }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-de-val-desp	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U 
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-de-mo-codigo	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-de-log-despes-ja-recbda	":U) THEN DO: 
                    {utp/ut-liter.i Despesa_j†_Recebida }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-de-cod-incoterm-rat	":U) THEN DO: 
                    {utp/ut-liter.i Incoterm_de_Rateio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-de-log-forma-preco-compra	":U) THEN DO: 
                    {utp/ut-liter.i Forma_Preáo_Compra }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-de-descricao	":U) THEN DO: 
                    {utp/ut-liter.i Descriá∆o_Despesa_Import }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-de-des-itiner	":U) THEN DO: 
                    {utp/ut-liter.i Itiner†rio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-de-des-pto-contr	":U) THEN DO: 
                    {utp/ut-liter.i Ponto_Controle }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-de-nome-emitente-desp	":U) THEN DO: 
                    {utp/ut-liter.i Fornec_Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-de-des-cond-pag	":U) THEN DO: 
                    {utp/ut-liter.i Condiá∆o_Pagamento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-de-des-moeda	":U) THEN DO: 
                    {utp/ut-liter.i Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-de-nome-estabel	":U) THEN DO: 
                    {utp/ut-liter.i Nome_Estabelecimento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
            END.
        END.

        /* Traduz literais Titulos Material em Transito */
        IF tt-param.lMaterialTransito AND p-valor-linha MATCHES "#lit-mt-*":U THEN DO:
            CASE p-valor-linha:
                WHEN TRIM("#lit-mt-cod-estabel":U) THEN DO: 
                    {utp/ut-liter.i Estabelecimento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-mt-nome-estabel":U) THEN DO: 
                    {utp/ut-liter.i Nome_Estabelecimento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-mt-embarque":U) THEN DO: 
                    {utp/ut-liter.i Embarque }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-mt-ep-codigo":U) THEN DO: 
                    {utp/ut-liter.i Empresa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-mt-cod-emitente":U) THEN DO: 
                    {utp/ut-liter.i Fornecedor }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-mt-nome-emitente":U) THEN DO: 
                    {utp/ut-liter.i Nome_Fornecedor }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-mt-cod-especie") THEN DO:
                    {utp/ut-liter.i EspÇcie }  
                    ASSIGN p-valor-literal  = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.           
                END.
                WHEN TRIM("#lit-mt-serie":U) THEN DO: 
                    {utp/ut-liter.i SÇrie }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-mt-nr-docto") THEN DO:
                    {utp/ut-liter.i Documento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-mt-parcela":U) THEN DO: 
                    {utp/ut-liter.i Parcela }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-mt-situacao":U) THEN DO: 
                    {utp/ut-liter.i Situaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                           p-tipo-formatacao = "@":U.
                END.
                WHEN TRIM("#lit-mt-data-emissao":U) THEN DO: 
                    {utp/ut-liter.i Data_Emiss∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-mt-prev-pag") THEN DO:
                    {utp/ut-liter.i Previs∆o_Pagamento}
                    ASSIGN p-valor-literal   = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.
                END.
                WHEN TRIM("#lit-mt-moeda":U) THEN DO: 
                    {utp/ut-liter.i Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-mt-vl-orig":U) THEN DO:
                    {utp/ut-liter.i Valor_Original}
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U.           
                END.
                WHEN TRIM("#lit-mt-vl-saldo":U) THEN DO:
                    {utp/ut-liter.i Valor_Saldo}
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U.           
                END.
                WHEN TRIM("#lit-mt-pto-incoterm":U) THEN DO: 
                    {utp/ut-liter.i Ponto_Incoterm }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-mt-dt-incoterm":U) THEN DO: 
                    {utp/ut-liter.i Dt_Efetiva_Incoterm }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.

            END CASE.
        END.

        /* Traduz literais do Declaraá∆o de Importaá∆o */
        IF tt-param.lDeclaImport AND p-valor-linha MATCHES "*#lit-di-*":U THEN DO:

            CASE p-valor-linha:
                WHEN TRIM("#lit-di-num-di-ems	":U) THEN DO: 
                    {utp/ut-liter.i DI_EMS }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-di-cod-estab	":U) THEN DO: 
                    {utp/ut-liter.i Estabelecimento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-di-cod-di-siscomex	":U) THEN DO: 
                    {utp/ut-liter.i DI_Siscomex }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-di-dat-di	":U) THEN DO: 
                    {utp/ut-liter.i Data_da_DI }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-di-des-tip-decla-import	":U) THEN DO: 
                    {utp/ut-liter.i Tipo_Declaraá∆o_Import }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-di-des-caract-operac	":U) THEN DO: 
                    {utp/ut-liter.i Caracteristica_Operaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-di-cdn-consign	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Consignat†rio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-di-des-modalid-despch	":U) THEN DO: 
                    {utp/ut-liter.i Modalidade_Despacho }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-di-cdn-urf-entr	":U) THEN DO: 
                    {utp/ut-liter.i URF_Entrada_Pa°s }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-di-cdn-urf-despch	":U) THEN DO: 
                    {utp/ut-liter.i URF_Despacho }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-di-cdn-pais-proceden	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Pais_Procedància }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-di-cdn-agent-carg-import	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Agente_Cargas }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-di-des-via-transp-di	":U) THEN DO: 
                    {utp/ut-liter.i Via_Transporte }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-di-des-docto-carg	":U) THEN DO: 
                    {utp/ut-liter.i Documento_Chegada_Carga }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-di-cod-identif	":U) THEN DO: 
                    {utp/ut-liter.i Identificaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-di-cdn-transpdor	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Transportador }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-di-des-tip-conhecto	":U) THEN DO: 
                    {utp/ut-liter.i Tipo_Conhecimento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-di-cod-conhecto-master	":U) THEN DO: 
                    {utp/ut-liter.i Conhecimento_Master }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-di-cod-conhecto-house	":U) THEN DO: 
                    {utp/ut-liter.i Conhecimento_House }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-di-val-peso-liq-di	":U) THEN DO: 
                    {utp/ut-liter.i Peso_Liquido }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U 
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-di-val-peso-brut-merc	":U) THEN DO: 
                    {utp/ut-liter.i Peso_Bruto_Mercadoria }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-di-val-peso-embal-di	":U) THEN DO: 
                    {utp/ut-liter.i Peso_Embalagem }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U 
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-di-val-peso-brut-tot-di	":U) THEN DO: 
                    {utp/ut-liter.i Peso_Bruto_Total }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-di-num-seq-retif	":U) THEN DO: 
                    {utp/ut-liter.i Sequància_Retificaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-di-des-motiv-retif	":U) THEN DO: 
                    {utp/ut-liter.i Motivo_Retificaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-di-dat-retif	":U) THEN DO: 
                    {utp/ut-liter.i Data_Retificaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-di-val-vmld	":U) THEN DO: 
                    {utp/ut-liter.i VMLD }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-di-val-vmld-me	":U) THEN DO: 
                    {utp/ut-liter.i VMLD_Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-di-val-vmle	":U) THEN DO: 
                    {utp/ut-liter.i VMLE }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-di-val-vmle-me	":U) THEN DO: 
                    {utp/ut-liter.i VMLE_Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-di-val-vmcv	":U) THEN DO: 
                    {utp/ut-liter.i VMCV }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U 
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-di-val-vmcv-me	":U) THEN DO: 
                    {utp/ut-liter.i VMCV_Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U 
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-di-val-frete	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Frete }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-di-val-frete-me	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Frete_Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-di-val-seguro	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Seguro }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-di-val-seguro-me	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Seguro_Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-di-val-acresc	":U) THEN DO: 
                    {utp/ut-liter.i Vl_AcrÇscimo }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-di-val-acresc-me	":U) THEN DO: 
                    {utp/ut-liter.i Vl_AcrÇscimo_Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-di-val-despes-nac	":U) THEN DO: 
                    {utp/ut-liter.i Despesas_Nacionalizaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-di-val-despes-nac-me	":U) THEN DO: 
                    {utp/ut-liter.i Despesas_Nacionalizaá∆o_Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-di-val-despes-di	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Despesa_DI }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-di-val-despes-di-me	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Despesa_DI_Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-di-val-despes-compltar	":U) THEN DO: 
                    {utp/ut-liter.i Despesas_Complementares }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-di-val-despes-compltar-me	":U) THEN DO: 
                    {utp/ut-liter.i Despesas_Complementares_Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-di-nome-consign	":U) THEN DO: 
                    {utp/ut-liter.i Consignat†rio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-di-nome-agent-carg	":U) THEN DO: 
                    {utp/ut-liter.i Agente_Cargas }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-di-nome-transpdor	":U) THEN DO: 
                    {utp/ut-liter.i Transportador }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-di-log-fundap         ":U) THEN DO:
                    {utp/ut-liter.i Fundap? }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.
                END.
                WHEN TRIM("#lit-di-cod-natur-oper     ":U) THEN DO:
                    {utp/ut-liter.i Cod_Natur_Oper }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.
                END.
                WHEN TRIM("#lit-di-des-natur-oper     ":U) THEN DO:
                    {utp/ut-liter.i Natureza_Operaá∆o }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.
                END.
                WHEN TRIM("#lit-di-util-conhecto      ":U) THEN DO:
                    {utp/ut-liter.i Indicativo_Utilizaá∆o }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.
                END.
                WHEN TRIM("#lit-di-recinto-alfand     ":U) THEN DO:
                    {utp/ut-liter.i Recinto_Alfandegado }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.
                END.
                WHEN TRIM("#lit-di-setor-armazenamento":U) THEN DO:
                    {utp/ut-liter.i Setor_Armazenamento }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.
                END.
                WHEN TRIM("#lit-di-val-base-ii        ":U) THEN DO:
                    {utp/ut-liter.i Valor_Base_II }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES. 
                END.
                WHEN TRIM("#lit-di-val-ii-suspenso    ":U) THEN DO:
                    {utp/ut-liter.i Valor_II_Suspenso }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES. 
                END.
                WHEN TRIM("#lit-di-val-ii-recolher    ":U) THEN DO:
                    {utp/ut-liter.i Valor_II_a_Recolher }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES. 
                END.
                WHEN TRIM("#lit-di-val-ii-outros      ":U) THEN DO:
                    {utp/ut-liter.i Valor_II_Outros }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES. 
                END.
                WHEN TRIM("#lit-di-val-base-ipi       ":U) THEN DO:
                    {utp/ut-liter.i Valor_Base_IPI }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES. 
                END.
                WHEN TRIM("#lit-di-val-ipi-suspenso   ":U) THEN DO:
                    {utp/ut-liter.i Valor_IPI_Suspenso }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES. 
                END.
                WHEN TRIM("#lit-di-val-ipi-recolher   ":U) THEN DO:
                    {utp/ut-liter.i Valor_IPI_a_Recolher }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES. 
                END.
                WHEN TRIM("#lit-di-val-ipi-outros     ":U) THEN DO:
                    {utp/ut-liter.i Valor_IPI_Outros }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES. 
                END.
                WHEN TRIM("#lit-di-val-base-pis       ":U) THEN DO:
                    {utp/ut-liter.i Valor_Base_PIS }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES. 
                END.
                WHEN TRIM("#lit-di-val-pis-suspenso   ":U) THEN DO:
                    {utp/ut-liter.i Valor_PIS_Suspenso }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES. 
                END.
                WHEN TRIM("#lit-di-val-pis-recolher   ":U) THEN DO:
                    {utp/ut-liter.i Valor_PIS_a_Recolher }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES. 
                END.
                WHEN TRIM("#lit-di-val-pis-outros     ":U) THEN DO:
                    {utp/ut-liter.i Valor_PIS_Outros }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES. 
                END.
                WHEN TRIM("#lit-di-val-base-cofins    ":U) THEN DO:
                    {utp/ut-liter.i Valor_Base_COFINS }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES. 
                END.
                WHEN TRIM("#lit-di-val-cofins-suspenso":U) THEN DO:
                    {utp/ut-liter.i Valor_COFINS_Suspenso }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES. 
                END.
                WHEN TRIM("#lit-di-val-cofins-recolher":U) THEN DO:
                    {utp/ut-liter.i Valor_COFINS_a_Recolher }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES. 
                END.
                WHEN TRIM("#lit-di-val-cofins-outros  ":U) THEN DO:
                    {utp/ut-liter.i Valor_COFINS_Outros }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES. 
                END.
                WHEN TRIM("#lit-di-val-base-icms      ":U) THEN DO:
                    {utp/ut-liter.i Valor_Base_ICMS }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES. 
                END.
                WHEN TRIM("#lit-di-val-icms-suspenso  ":U) THEN DO:
                    {utp/ut-liter.i Valor_ICMS_Suspenso }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES. 
                END.
                WHEN TRIM("#lit-di-val-icms-recolher  ":U) THEN DO:
                    {utp/ut-liter.i Valor_ICMS_a_Recolher }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES. 
                END.
                WHEN TRIM("#lit-di-val-icms-outros    ":U) THEN DO:
                    {utp/ut-liter.i Valor_ICMS_Outros }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES. 
                END.
            END.
        END.
        /* Traduz literais de Adiá‰es da DI */
        IF tt-param.lAdicoesDI AND p-valor-linha MATCHES "*#lit-adi-*":U THEN DO:

            CASE p-valor-linha:
                WHEN TRIM("#lit-adi-num-di-ems	":U) THEN DO: 
                    {utp/ut-liter.i DI_EMS }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-num-adic	":U) THEN DO: 
                    {utp/ut-liter.i Num_Adiá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                           p-tipo-formatacao = "000":U.                         
                END.
                WHEN TRIM("#lit-adi-cdn-fornec	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Fornecedor }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-val-peso-liq	":U) THEN DO: 
                    {utp/ut-liter.i Peso_Liquido }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-log-emite-fabrican	":U) THEN DO: 
                    {utp/ut-liter.i Fornec._Ç_Fabricante }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-cdn-fabrican	":U) THEN DO: 
                    {utp/ut-liter.i C¢digo_Fabricante }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-cod-classif-fisc	":U) THEN DO: 
                    {utp/ut-liter.i Classificaá∆o_Fiscal }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                           p-tipo-formatacao = '0000"."00"."00':U.
                END.
                WHEN TRIM("#lit-adi-cdn-classif-fisc-ex	":U) THEN DO: 
                    {utp/ut-liter.i Ex_NCM }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-cod-incoterm	":U) THEN DO: 
                    {utp/ut-liter.i Incoterm }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-qtd-ncm	":U) THEN DO: 
                    {utp/ut-liter.i Qtd_NCM }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-cod-contrat-cambio	":U) THEN DO: 
                    {utp/ut-liter.i Contrato_CÉmbio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-cdn-modal-pagto	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Modal_Pagamento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-cdn-moeda	":U) THEN DO: 
                    {utp/ut-liter.i C¢digo_Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-cdn-corretor	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Corretor }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-cdn-banco	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Banco }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-cod-rof	":U) THEN DO: 
                    {utp/ut-liter.i ROF }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-cdn-agent	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Agente }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-cdn-bco-agent	":U) THEN DO: 
                    {utp/ut-liter.i Banco_Agente }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-cod-agenc-agent	":U) THEN DO: 
                    {utp/ut-liter.i Agencia_Agente }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-val-cotac	":U) THEN DO: 
                    {utp/ut-liter.i Cotaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-vmcv	":U) THEN DO: 
                    {utp/ut-liter.i VMCV }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-vmcv-me	":U) THEN DO: 
                    {utp/ut-liter.i VMCV_Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-vmle	":U) THEN DO: 
                    {utp/ut-liter.i VMLE }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-vmle-me	":U) THEN DO: 
                    {utp/ut-liter.i VMLE_Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-vmld	":U) THEN DO: 
                    {utp/ut-liter.i VMLD }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-vmld-me	":U) THEN DO: 
                    {utp/ut-liter.i VMLD_Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-frete	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Frete }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-frete-me	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Frete_Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-cdn-moed-frete	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Moeda_Frete }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-val-seguro	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Seguro }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-seguro-me	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Seguro_Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-cdn-moed-seguro	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Moeda_Seguro }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-val-acresc	":U) THEN DO: 
                    {utp/ut-liter.i Vl_AcrÇscimo }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-acresc-me	":U) THEN DO: 
                    {utp/ut-liter.i Vl_AcrÇscimo_Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-cdn-acresc-moed	":U) THEN DO: 
                    {utp/ut-liter.i Cod_AcrÇscimo_Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-val-deduc	":U) THEN DO: 
                    {utp/ut-liter.i Deduá‰es }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-cdn-moed-deduc	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Moeda_Deduá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-dsl-compl-adic	":U) THEN DO: 
                    {utp/ut-liter.i Complemento_Adiá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-cod-licenc-import	":U) THEN DO: 
                    {utp/ut-liter.i Licenáa_Importaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-des-natur-cambial	":U) THEN DO: 
                    {utp/ut-liter.i Natureza_Cambial }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-nome-fabrican	":U) THEN DO: 
                    {utp/ut-liter.i Fabricante }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-des-modal-pagto	":U) THEN DO: 
                    {utp/ut-liter.i Modal_Pagamento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-des-moeda	":U) THEN DO: 
                    {utp/ut-liter.i Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-nome-corretor	":U) THEN DO: 
                    {utp/ut-liter.i Corretor }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-nome-banco	":U) THEN DO: 
                    {utp/ut-liter.i Banco }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-nome-agent	":U) THEN DO: 
                    {utp/ut-liter.i Agente }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-des-moed-frete	":U) THEN DO: 
                    {utp/ut-liter.i Moeda_Frete }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-des-moed-seguro	":U) THEN DO: 
                    {utp/ut-liter.i Moeda_Seguro }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-des-acresc-moed	":U) THEN DO: 
                    {utp/ut-liter.i Moeda_AcrÇscimo }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-des-moed-deduc	":U) THEN DO: 
                    {utp/ut-liter.i Moeda_Deduá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-adi-nome-fornec        ":U) THEN DO:
                    {utp/ut-liter.i Fornecedor }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.  
                END.
                WHEN TRIM("#lit-adi-naladi-sh          ":U) THEN DO:
                    {utp/ut-liter.i Naladi/SH }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.  
                END.
                WHEN TRIM("#lit-adi-naladi-ncca        ":U) THEN DO:
                    {utp/ut-liter.i Naladi/NCCA }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.  
                END.
                WHEN TRIM("#lit-adi-nbm                ":U) THEN DO:
                    {utp/ut-liter.i NBM }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.  
                END.
                WHEN TRIM("#lit-adi-acordo-aladi       ":U) THEN DO:
                    {utp/ut-liter.i Acordo_ALADI }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.  
                END.
                WHEN TRIM("#lit-adi-tributac-ii        ":U) THEN DO:
                    {utp/ut-liter.i Tributaá∆o_II }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.  
                END.
                WHEN TRIM("#lit-adi-aliq-ii            ":U) THEN DO:
                    {utp/ut-liter.i Al°quota_II }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-log-suspenso-ii    ":U) THEN DO:
                     {utp/ut-liter.i Suspens∆o_II }
                     ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                            p-tipo-formatacao = "@".                         
                END.
                WHEN TRIM("#lit-adi-perc-red-ii	       ":U) THEN DO:
                    {utp/ut-liter.i %Red_II }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-base-ii        ":U) THEN DO:
                    {utp/ut-liter.i Valor_Base_II }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-ii-suspenso    ":U) THEN DO:
                    {utp/ut-liter.i Valor_II_Suspenso }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-ii-recolher    ":U) THEN DO:
                    {utp/ut-liter.i Valor_II_a_Recolher }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-ii-outros      ":U) THEN DO:
                    {utp/ut-liter.i Valor_II_Outros }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-tributac-ipi       ":U) THEN DO:
                    {utp/ut-liter.i Tributaá∆o_IPI }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.  
                END.
                WHEN TRIM("#lit-adi-aliq-ipi           ":U) THEN DO:
                    {utp/ut-liter.i Al°quota_IPI }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-log-suspenso-ipi  ":U) THEN DO:
                     {utp/ut-liter.i Suspens∆o_IPI }
                     ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                            p-tipo-formatacao = "@".                         
                END.
                WHEN TRIM("#lit-adi-perc-red-ipi       ":U) THEN DO:
                    {utp/ut-liter.i %Red_IPI }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-base-ipi       ":U) THEN DO:
                    {utp/ut-liter.i Valor_Base_IPI }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-ipi-suspenso   ":U) THEN DO:
                    {utp/ut-liter.i Valor_IPI_Suspenso }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-ipi-recolher   ":U) THEN DO:
                    {utp/ut-liter.i Valor_IPI_a_Recolher }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-ipi-outros     ":U) THEN DO:
                    {utp/ut-liter.i Valor_IPI_Outros }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-ipi-unit       ":U) THEN DO:	
                     {utp/ut-liter.i Valor_Unit†rio_IPI }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.  
                END.
                WHEN TRIM("#lit-adi-tributac-pis       ":U) THEN DO:
                    {utp/ut-liter.i Tributaá∆o_PIS }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.  
                END.
                WHEN TRIM("#lit-adi-aliq-pis           ":U) THEN DO:
                    {utp/ut-liter.i Al°quota_PIS }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "##0,0000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-log-suspenso-pis  ":U) THEN DO:
                     {utp/ut-liter.i Suspens∆o_PIS }
                     ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                            p-tipo-formatacao = "@".                         
                END.
                WHEN TRIM("#lit-adi-perc-red-pis       ":U) THEN DO:
                    {utp/ut-liter.i %Red_PIS }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-base-pis       ":U) THEN DO:
                    {utp/ut-liter.i Valor_Base_PIS }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-pis-suspenso   ":U) THEN DO:
                    {utp/ut-liter.i Valor_PIS_Suspenso }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-pis-recolher   ":U) THEN DO:
                    {utp/ut-liter.i Valor_PIS_a_Recolher }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-pis-outros     ":U) THEN DO:
                    {utp/ut-liter.i Valor_PIS_Outros }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-pis-unit       ":U) THEN DO:	
                     {utp/ut-liter.i Valor_Unit†rio_PIS }
                     ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                            p-tipo-formatacao = "#.##0,00000":U  
                            p-alinha-direita = YES.
                END.
                WHEN TRIM("#lit-adi-tributac-cofins    ":U) THEN DO:
                     {utp/ut-liter.i Tributaá∆o_COFINS }
                     ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                            p-tipo-formatacao = "@":U.  
                END.
                WHEN TRIM("#lit-adi-aliq-cofins        ":U) THEN DO:
                     {utp/ut-liter.i Al°quota_COFINS }
                     ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                            p-tipo-formatacao = "##0,0000":U  
                            p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-log-suspenso-cofins  ":U) THEN DO:
                     {utp/ut-liter.i Suspens∆o_COFINS }
                     ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                            p-tipo-formatacao = "@".                         
                END.
                WHEN TRIM("#lit-adi-perc-red-cofins    ":U) THEN DO:
                    {utp/ut-liter.i %Red_COFINS }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-base-cofins    ":U) THEN DO:
                     {utp/ut-liter.i Valor_Base_COFINS }
                     ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                            p-tipo-formatacao = "#.##0,00000000":U  
                            p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-cofins-suspenso":U) THEN DO:
                     {utp/ut-liter.i Valor_COFINS_Suspenso }
                     ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                            p-tipo-formatacao = "#.##0,00000000":U  
                            p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-cofins-recolher":U) THEN DO:
                     {utp/ut-liter.i Valor_COFINS_a_Recolher }
                     ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                            p-tipo-formatacao = "#.##0,00000000":U  
                            p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-cofins-outros  ":U) THEN DO:
                     {utp/ut-liter.i Valor_COFINS_Outros }
                     ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                            p-tipo-formatacao = "#.##0,00000000":U  
                            p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-cofins-unit       ":U) THEN DO:	
                     {utp/ut-liter.i Valor_Unit†rio_COFINS }
                     ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                            p-tipo-formatacao = "#.##0,00000":U  
                            p-alinha-direita = YES.
                END.
                WHEN TRIM("#lit-adi-tributac-icms      ":U) THEN DO:
                    {utp/ut-liter.i Tributaá∆o_ICMS }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.  
                END.
                WHEN TRIM("#lit-adi-aliq-icms          ":U) THEN DO:
                    {utp/ut-liter.i Al°quota_ICMS }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-log-suspenso-icms  ":U) THEN DO:
                     {utp/ut-liter.i Suspens∆o_ICMS }
                     ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                            p-tipo-formatacao = "@".                         
                END.
                WHEN TRIM("#lit-adi-perc-red-icms	       ":U) THEN DO:
                    {utp/ut-liter.i %Red_ICMS }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-base-icms      ":U) THEN DO:
                    {utp/ut-liter.i Valor_Base_ICMS }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-icms-suspenso  ":U) THEN DO:
                    {utp/ut-liter.i Valor_ICMS_Suspenso }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-icms-recolher  ":U) THEN DO:
                    {utp/ut-liter.i Valor_ICMS_a_Recolher }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-adi-val-icms-outros    ":U) THEN DO:
                    {utp/ut-liter.i Valor_ICMS_Outros }
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
            END.
        END.
        /* Traduz literais de Ordens da DI */
        IF tt-param.lDeclaImport AND p-valor-linha MATCHES "*#lit-odi-*":U THEN DO:

            CASE p-valor-linha:
                WHEN TRIM("#lit-odi-num-di-ems	":U) THEN DO: 
                    {utp/ut-liter.i DI_EMS }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-odi-cod-estab	":U) THEN DO: 
                    {utp/ut-liter.i Estabelecimento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-odi-cod-embarq	":U) THEN DO: 
                    {utp/ut-liter.i Embarque }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-odi-num-ordem	":U) THEN DO: 
                    {utp/ut-liter.i Ordem }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-odi-num-parcela	":U) THEN DO: 
                    {utp/ut-liter.i Num_Parcela }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-odi-num-adic	":U) THEN DO: 
                    {utp/ut-liter.i Num_Adiá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "000":U.
                END.
                WHEN TRIM("#lit-odi-num-seq	":U) THEN DO: 
                    {utp/ut-liter.i Nr_Sequància }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.
                END.
                WHEN TRIM("#lit-odi-qtd-item	":U) THEN DO: 
                    {utp/ut-liter.i Quantidade_Item }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U 
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-odi-cod-unid-medid-item	":U) THEN DO: 
                    {utp/ut-liter.i Unid_Med_Item }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-odi-val-peso-liq	":U) THEN DO: 
                    {utp/ut-liter.i Peso_L°quido }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U 
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-odi-val-peso-brut-merc	":U) THEN DO: 
                    {utp/ut-liter.i Peso_Bruto_Mercadoria }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U 
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-odi-val-peso-embal	":U) THEN DO: 
                    {utp/ut-liter.i Peso_L°quido_Embalagem }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U 
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-odi-cod-licenc-import	":U) THEN DO: 
                    {utp/ut-liter.i Licenáa_Importaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-odi-qtd-fornec	":U) THEN DO: 
                    {utp/ut-liter.i Qtde_Fornec }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U 
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-odi-cod-unid-med-fornec	":U) THEN DO: 
                    {utp/ut-liter.i Unid_Medida_Forn }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
            END.
        END.
        /* Traduz literais de Hist¢rico da DI */
        IF tt-param.lAcompDI AND p-valor-linha MATCHES "*#lit-hdi-*":U THEN DO:

            CASE p-valor-linha:
                
                WHEN TRIM("#lit-hdi-num-di-ems	":U) THEN DO: 
                    {utp/ut-liter.i DI_EMS }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-hdi-num-seq	":U) THEN DO: 
                    {utp/ut-liter.i Nr_Sequància }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-hdi-cdn-pto-control	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Ponto_Controle }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-hdi-cod-meio-transp	":U) THEN DO: 
                    {utp/ut-liter.i Meio_Transporte }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-hdi-dat-prev-origin	":U) THEN DO: 
                    {utp/ut-liter.i Previs∆o_Original }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-hdi-cdn-pto-nacionaliz	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Ponto_Nacionalizaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-hdi-dat-ult-prev	":U) THEN DO: 
                    {utp/ut-liter.i Èltima_Previs∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-hdi-dat-efetiva	":U) THEN DO: 
                    {utp/ut-liter.i Efetiva }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-hdi-cdn-pto-chegad	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Ponto_Chegada_Empresa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-hdi-descricao	":U) THEN DO: 
                    {utp/ut-liter.i Ponto_Controle }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-hdi-nr-dias	":U) THEN DO: 
                    {utp/ut-liter.i Dias_Trajeto }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-hdi-des-pto-nacionaliz	":U) THEN DO: 
                    {utp/ut-liter.i Ponto_Nacionalizaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-hdi-des-pto-chegad	":U) THEN DO: 
                    {utp/ut-liter.i Ponto_Chegada_Empresa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
            END.
        END.
        /* Traduz literais de Despesas da DI */
        IF tt-param.lAcompDI AND p-valor-linha MATCHES "*#lit-ddi-*":U THEN DO:

            CASE p-valor-linha:

                WHEN TRIM("#lit-ddi-num-di-ems	":U) THEN DO: 
                    {utp/ut-liter.i DI_EMS }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-ddi-cdn-pto-control	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Ponto_Controle }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-ddi-cdn-despes	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-ddi-cdn-emit-despes	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Fornec_Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-ddi-cdn-cond-pagto	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Condiá∆o_Pagamento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-ddi-val-despes	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U 
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-ddi-cdn-moeda	":U) THEN DO: 
                    {utp/ut-liter.i C¢digo_Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-ddi-log-forma-preco-compra	":U) THEN DO: 
                    {utp/ut-liter.i Forma_Preáo_Compra }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-ddi-cod-incoterm-rat	":U) THEN DO: 
                    {utp/ut-liter.i Incoterm_de_Rateio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-ddi-val-cotac-despes-compltar	":U) THEN DO: 
                    {utp/ut-liter.i Cotac∆o_Desp_Compl }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U 
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-ddi-des-tip-incid-nf	":U) THEN DO: 
                    {utp/ut-liter.i Tipo_Incide_Nota_Fiscal }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-ddi-log-incid-vmle	":U) THEN DO: 
                    {utp/ut-liter.i Incide_VMLE }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-ddi-des-pto-control	":U) THEN DO: 
                    {utp/ut-liter.i Ponto_Controle }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-ddi-des-despes	":U) THEN DO: 
                    {utp/ut-liter.i Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-ddi-nome-emit-despes	":U) THEN DO: 
                    {utp/ut-liter.i Fornec_Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-ddi-des-cond-pagto	":U) THEN DO: 
                    {utp/ut-liter.i Condiá∆o_Pagamento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-ddi-des-moeda	":U) THEN DO: 
                    {utp/ut-liter.i Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
            END.
        END.
        /* Traduz literais do Documento */
        IF tt-param.lDocumentos AND p-valor-linha MATCHES "*#lit-doc-*":U THEN DO:
    
            CASE p-valor-linha:
                
                WHEN TRIM("#lit-doc-serie-docto	":U) THEN DO: 
                    {utp/ut-liter.i SÇrie }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-nro-docto	":U) THEN DO: 
                    {utp/ut-liter.i Documento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-cod-emitente	":U) THEN DO: 
                    {utp/ut-liter.i Emitente }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-nat-operacao	":U) THEN DO: 
                    {utp/ut-liter.i Nat_Operaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-cod-estabel	":U) THEN DO: 
                    {utp/ut-liter.i Estabelecimento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-dt-emissao	":U) THEN DO: 
                    {utp/ut-liter.i Data_Emiss∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-des-esp-docto	":U) THEN DO: 
                    {utp/ut-liter.i EspÇcie_Documento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-dt-trans	":U) THEN DO: 
                    {utp/ut-liter.i Data_Transaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-dt-atualiza	":U) THEN DO: 
                    {utp/ut-liter.i Data_Atualizaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-tot-peso	":U) THEN DO: 
                    {utp/ut-liter.i Peso_Total }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U 
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-doc-ct-transit	":U) THEN DO: 
                    {utp/ut-liter.i Conta_Transit¢ria }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-sc-transit	":U) THEN DO: 
                    {utp/ut-liter.i Centro_Custo }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-des-ct-transit	":U) THEN DO: 
                    {utp/ut-liter.i Desc_Conta }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-des-sc-transit	":U) THEN DO: 
                    {utp/ut-liter.i Desc_Centro_Custo }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-des-tipo-docto	":U) THEN DO: 
                    {utp/ut-liter.i Tipo }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-des-via-transp	":U) THEN DO: 
                    {utp/ut-liter.i Via_Transporte }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-despesa-nota	":U) THEN DO: 
                    {utp/ut-liter.i Despesas_Nota }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-doc-valor-embal	":U) THEN DO: 
                    {utp/ut-liter.i Embalagem }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-doc-valor-frete	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Frete }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-doc-valor-mercad	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Total_Merc }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-doc-valor-outras	":U) THEN DO: 
                    {utp/ut-liter.i Outras }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-doc-valor-seguro	":U) THEN DO: 
                    {utp/ut-liter.i Seguro }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-doc-tot-desconto	":U) THEN DO: 
                    {utp/ut-liter.i Total_Descto }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-doc-CE-atual	":U) THEN DO: 
                    {utp/ut-liter.i CE_Atualizado }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-observacao	":U) THEN DO: 
                    {utp/ut-liter.i Observaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-des-mod-frete	":U) THEN DO: 
                    {utp/ut-liter.i Modalidade_Frete }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-estab-fisc	":U) THEN DO: 
                    {utp/ut-liter.i Estabel_Fiscal }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-c-nr-invoice	":U) THEN DO: 
                    {utp/ut-liter.i N£mero_Invoice }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-dt-entr-merc	":U) THEN DO: 
                    {utp/ut-liter.i Data_Entrada_Mercadoria }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-taxa-conv-imp	":U) THEN DO: 
                    {utp/ut-liter.i Taxa_Convers∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-doc-qt-tot-imp	":U) THEN DO: 
                    {utp/ut-liter.i Qtde_Total_Import }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-doc-mo-codigo	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-cotacao-dia	":U) THEN DO: 
                    {utp/ut-liter.i Cotaá∆o_Dia }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-doc-valor-frete-me	":U) THEN DO: 
                    {utp/ut-liter.i Vl_Frete_ME }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-doc-valor-seguro-me	":U) THEN DO: 
                    {utp/ut-liter.i Vl_Seguro_ME }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-doc-valor-embal-me	":U) THEN DO: 
                    {utp/ut-liter.i Vl_Embal_ME }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-doc-valor-outras-me	":U) THEN DO: 
                    {utp/ut-liter.i Vl_Outras_ME }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-doc-tot-desconto-me	":U) THEN DO: 
                    {utp/ut-liter.i Tot_Desconto_ME }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-doc-tot-valor-me	":U) THEN DO: 
                    {utp/ut-liter.i Tot_Valor_ME }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-doc-valor-mercad-me	":U) THEN DO: 
                    {utp/ut-liter.i Vl_Mercado_ME }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-doc-despesa-nota-me	":U) THEN DO: 
                    {utp/ut-liter.i Vl_Despesa_ME }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-doc-tot-taxa-me	":U) THEN DO: 
                    {utp/ut-liter.i Vl_Imposto_ME }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-doc-des-tipo-nota	":U) THEN DO: 
                    {utp/ut-liter.i Tipo_Nota }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-esp-fiscal	":U) THEN DO: 
                    {utp/ut-liter.i EspÇcie_Fiscal }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-embarque	":U) THEN DO: 
                    {utp/ut-liter.i Embarque }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-declaracao-import	":U) THEN DO: 
                    {utp/ut-liter.i Declaraá∆o_Importaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-peso-bruto-tot	":U) THEN DO: 
                    {utp/ut-liter.i Peso_Bruto_Total }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-doc-peso-liquido-tot	":U) THEN DO: 
                    {utp/ut-liter.i Peso_L°quido_Total }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-doc-log-draw-atlzdo	":U) THEN DO: 
                    {utp/ut-liter.i Drawback_Atualizado }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-log-memorando	":U) THEN DO: 
                    {utp/ut-liter.i Memorando_de_Exportaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-des-modalid-transp	":U) THEN DO: 
                    {utp/ut-liter.i Modalidade_Transporte }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-cod-placa	":U) THEN DO: 
                    {utp/ut-liter.i Placa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-cod-uf-placa	":U) THEN DO: 
                    {utp/ut-liter.i UF }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-nome-transp	":U) THEN DO: 
                    {utp/ut-liter.i Transportador }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-cod-entrega	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Entrega }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-endereco	":U) THEN DO: 
                    {utp/ut-liter.i Endereáo }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-bairro	":U) THEN DO: 
                    {utp/ut-liter.i Bairro }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-cep	":U) THEN DO: 
                    {utp/ut-liter.i CEP }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-cidade	":U) THEN DO: 
                    {utp/ut-liter.i Cidade }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-uf	":U) THEN DO: 
                    {utp/ut-liter.i Unid_Federaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-pais	":U) THEN DO: 
                    {utp/ut-liter.i Pa°s }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-cod-chave-aces-nf-eletro	":U) THEN DO: 
                    {utp/ut-liter.i Chave_Acesso_NF-e }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-log-tax-siscomex	":U) THEN DO: 
                    {utp/ut-liter.i Usa_Taxa_Siscomex? }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-des-sit-nf-eletro	":U) THEN DO: 
                    {utp/ut-liter.i Situaá∆o_NF-e }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-des-nat-operacao	":U) THEN DO: 
                    {utp/ut-liter.i Desc_Nat_Operaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-des-moeda	":U) THEN DO: 
                    {utp/ut-liter.i Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-nome-estabel	":U) THEN DO: 
                    {utp/ut-liter.i Nome_Estabelecimento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-nome-emitente	":U) THEN DO: 
                    {utp/ut-liter.i Nome_Fornecedor }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-tipo-docto	":U) THEN DO: 
                    {utp/ut-liter.i Tipo_Documento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-doc-gera-prim-remes-mae	":U) THEN DO: 
                    {utp/ut-liter.i Gera_1¶_Remessa_com_NF_M∆e }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
            END.
        END.
        /* Traduz literais de Itens do Documento */
        IF tt-param.lItensDoc AND p-valor-linha MATCHES "*#lit-itd-*":U THEN DO:
    
            CASE p-valor-linha:

                WHEN TRIM("#lit-itd-serie-docto	":U) THEN DO: 
                    {utp/ut-liter.i SÇrie }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-nro-docto	":U) THEN DO: 
                    {utp/ut-liter.i Documento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-cod-emitente	":U) THEN DO: 
                    {utp/ut-liter.i Emitente }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-nat-operacao	":U) THEN DO: 
                    {utp/ut-liter.i Nat_Operaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-nat-of	":U) THEN DO: 
                    {utp/ut-liter.i Nat_Fiscal }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-class-fiscal	":U) THEN DO: 
                    {utp/ut-liter.i Classificaá∆o_Fiscal }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = '0000"."00"."00':U.
                END.
                WHEN TRIM("#lit-itd-it-codigo	":U) THEN DO: 
                    {utp/ut-liter.i Item }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-des-it-codigo	":U) THEN DO: 
                    {utp/ut-liter.i Descriá∆o_Item }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-sequencia	":U) THEN DO: 
                    {utp/ut-liter.i Seq }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-cod-refer	":U) THEN DO: 
                    {utp/ut-liter.i Referància }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-peso-liquido	":U) THEN DO: 
                    {utp/ut-liter.i Peso_Liq }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-quantidade	":U) THEN DO: 
                    {utp/ut-liter.i Nossa_Qtde }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-un	":U) THEN DO: 
                    {utp/ut-liter.i Unid }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-aliquota-ipi	":U) THEN DO: 
                    {utp/ut-liter.i Al°quota_IPI }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-aliquota-icm	":U) THEN DO: 
                    {utp/ut-liter.i Al°quota_ICMS }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-des-trib-icm	":U) THEN DO: 
                    {utp/ut-liter.i C¢digo_Tributaá∆o_ICMS }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-des-trib-ipi	":U) THEN DO: 
                    {utp/ut-liter.i C¢digo_Tributaá∆o_IPI }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-base-ipi	":U) THEN DO: 
                    {utp/ut-liter.i Base_C†lculo_IPI }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-base-icm	":U) THEN DO: 
                    {utp/ut-liter.i Base_C†lculo_ICMS }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-despesas	":U) THEN DO: 
                    {utp/ut-liter.i Despesas }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-ipi-outras	":U) THEN DO: 
                    {utp/ut-liter.i IPI_Outras }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-icm-outras	":U) THEN DO: 
                    {utp/ut-liter.i ICMS_Outras }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-valor-ipi	":U) THEN DO: 
                    {utp/ut-liter.i Valor_IPI }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-valor-icm	":U) THEN DO: 
                    {utp/ut-liter.i Valor_ICMS }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-preco-unit	":U) THEN DO: 
                    {utp/ut-liter.i Preáo_Unit }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-preco-total	":U) THEN DO: 
                    {utp/ut-liter.i Preáo_Total }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-icm-complem	":U) THEN DO: 
                    {utp/ut-liter.i ICMS_Complementar }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-componente	":U) THEN DO: 
                    {utp/ut-liter.i Componente }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-ct-codigo	":U) THEN DO: 
                    {utp/ut-liter.i Conta }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-sc-codigo	":U) THEN DO: 
                    {utp/ut-liter.i Centro_Custo }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-des-ct-codigo	":U) THEN DO: 
                    {utp/ut-liter.i Desc_Conta }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-des-sc-codigo	":U) THEN DO: 
                    {utp/ut-liter.i Desc_Centro_Custo }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-desconto	":U) THEN DO: 
                    {utp/ut-liter.i Desconto }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-dt-vali-lote	":U) THEN DO: 
                    {utp/ut-liter.i Validade_Lote }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-nat-comp	":U) THEN DO: 
                    {utp/ut-liter.i Natureza_Complementar }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-num-pedido	":U) THEN DO: 
                    {utp/ut-liter.i Pedido }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-numero-ordem	":U) THEN DO: 
                    {utp/ut-liter.i Ordem_Compra }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-parcela	":U) THEN DO: 
                    {utp/ut-liter.i Parcela }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-qt-do-forn	":U) THEN DO: 
                    {utp/ut-liter.i Qtde_Emitente }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-vl-imp-impor	":U) THEN DO: 
                    {utp/ut-liter.i Imposto_Import }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-narrativa	":U) THEN DO: 
                    {utp/ut-liter.i Narrativa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-baixa-ce	":U) THEN DO: 
                    {utp/ut-liter.i Baixa_Estoque }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-c-nr-invoice	":U) THEN DO: 
                    {utp/ut-liter.i N£mero_Invoice }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-i-seq-inv	":U) THEN DO: 
                    {utp/ut-liter.i Seq_Invoice }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-cod-esp	":U) THEN DO: 
                    {utp/ut-liter.i EspÇcie }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-vl-taxa	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Imposto }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-cod-tax	":U) THEN DO: 
                    {utp/ut-liter.i C¢digo_Imposto }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-cota-moeda	":U) THEN DO: 
                    {utp/ut-liter.i Cotaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-data	":U) THEN DO: 
                    {utp/ut-liter.i Data_Movto }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-est-cob	":U) THEN DO: 
                    {utp/ut-liter.i Estab_Cobranáa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-preco-unit-me	":U) THEN DO: 
                    {utp/ut-liter.i Preáo_Unit_ME }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-preco-total-me	":U) THEN DO: 
                    {utp/ut-liter.i Preáo_Total_ME }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-desconto-me	":U) THEN DO: 
                    {utp/ut-liter.i Desconto_ME }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-despesas-me	":U) THEN DO: 
                    {utp/ut-liter.i Despesas_ME }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-nr-ato-concessorio	":U) THEN DO: 
                    {utp/ut-liter.i Nr._Ato_Concess¢rio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-valor-frete	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Frete }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-nr-proc-imp	":U) THEN DO: 
                    {utp/ut-liter.i Processo_Imp }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-declaracao-import	":U) THEN DO: 
                    {utp/ut-liter.i Declaraá∆o_Importaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-peso-bruto-item	":U) THEN DO: 
                    {utp/ut-liter.i Peso_Bruto }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-peso-liquido-item	":U) THEN DO: 
                    {utp/ut-liter.i Peso_L°quido }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-des-tributac-cofins	":U) THEN DO: 
                    {utp/ut-liter.i Trib_COFINS }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-val-aliq-cofins	":U) THEN DO: 
                    {utp/ut-liter.i Al°quota_COFINS }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "##0,0000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-val-base-calc-cofins	":U) THEN DO: 
                    {utp/ut-liter.i Base_C†lculo_COFINS }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-val-cofins	":U) THEN DO: 
                    {utp/ut-liter.i Valor_COFINS }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-des-tributac-pis	":U) THEN DO: 
                    {utp/ut-liter.i Trib_PIS }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-val-aliq-pis	":U) THEN DO: 
                    {utp/ut-liter.i Al°quota_PIS }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "##0,0000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-base-pis	":U) THEN DO: 
                    {utp/ut-liter.i Base_Calculo_PIS }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-valor-pis	":U) THEN DO: 
                    {utp/ut-liter.i Valor_PIS }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-num-ord-import	":U) THEN DO: 
                    {utp/ut-liter.i Num_Ordem_Import }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-num-parc-import	":U) THEN DO: 
                    {utp/ut-liter.i Parcela_Importaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-val-aduana-pis	":U) THEN DO: 
                    {utp/ut-liter.i Val_Aduana_Pis }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-val-despes-aduana-pis	":U) THEN DO: 
                    {utp/ut-liter.i Val_DA_Pis }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-val-aliq-impto-import	":U) THEN DO: 
                    {utp/ut-liter.i Al°quota_II }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-val-aliq-ext-ipi	":U) THEN DO: 
                    {utp/ut-liter.i Aliq_Ext_IPI }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-val-aliq-ext-pis	":U) THEN DO: 
                    {utp/ut-liter.i %_Externo_PIS }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "##0,0000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-val-aliq-ext-cofins	":U) THEN DO: 
                    {utp/ut-liter.i %_Externo_COFINS }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "##0,0000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-val-aliq-ext-icms	":U) THEN DO: 
                    {utp/ut-liter.i Aliq_Ext_ICMS }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-val-aduana-cofins	":U) THEN DO: 
                    {utp/ut-liter.i Val_Adu_COFINS }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-val-despes-aduana-cofins	":U) THEN DO: 
                    {utp/ut-liter.i Desp_Adua_COFINS }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-val-unit-pis-import	":U) THEN DO: 
                    {utp/ut-liter.i Val_Unit_PIS_Imp }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-val-unit-vol-pis-import	":U) THEN DO: 
                    {utp/ut-liter.i Val_Unit_Vol_PIS }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-val-unit-cofins-import	":U) THEN DO: 
                    {utp/ut-liter.i Val_Unit_COFINS_Imp }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-val-unit-vol-cofins-import	":U) THEN DO: 
                    {utp/ut-liter.i Val_Unit_Vol_COFINS }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-val-reduc-cofins-import	":U) THEN DO: 
                    {utp/ut-liter.i Val_Red_COFINS_Imp }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-val-reduc-pis-import	":U) THEN DO: 
                    {utp/ut-liter.i Val_Red_PIS_Imp }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-itd-cod-unid-negoc	":U) THEN DO: 
                    {utp/ut-liter.i Unidade_Neg¢cio }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-log-gerou-ncredito	":U) THEN DO: 
                    {utp/ut-liter.i Gerou_Nota_de_CrÇdito }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-log-nota-ajust-import	":U) THEN DO: 
                    {utp/ut-liter.i NF_ajuste_de_importaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-itd-gera-prim-remes-mae	":U) THEN DO: 
                    {utp/ut-liter.i Gera_1¶_Remessa_com_NF_M∆e }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
            END.
            
            
            /* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-965) */
            IF  l-nt2024002 THEN DO:    
                CASE p-valor-linha:
                    WHEN TRIM("#lit-itd-class-trib-cbs":U) THEN DO: 
                        {utp/ut-liter.i Class_Trib_CBS }
                        ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                               p-tipo-formatacao = "@":U.
                    END.
                    WHEN TRIM("#lit-itd-cst-cbs":U) THEN DO: 
                        {utp/ut-liter.i CST_CBS }
                        ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                               p-tipo-formatacao = "@":U.
                    END.
                    WHEN TRIM("#lit-itd-aliquota-cbs":U) THEN DO: 
                        {utp/ut-liter.i Al°quota_CBS }
                        ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                               p-tipo-formatacao = "#.##0,00":U.
                    END.
                    WHEN TRIM("#lit-itd-base-cbs":U) THEN DO: 
                        {utp/ut-liter.i Base_C†lculo_CBS }
                        ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                               p-tipo-formatacao = "#.##0,00":U.
                    END.
                    WHEN TRIM("#lit-itd-val-cbs":U) THEN DO: 
                        {utp/ut-liter.i Valor_CBS }
                        ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                               p-tipo-formatacao = "#.##0,00":U.
                    END.
                    WHEN TRIM("#lit-itd-class-trib-ibs-uf":U) THEN DO: 
                        {utp/ut-liter.i Class_Trib_IBS_UF }
                        ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                               p-tipo-formatacao = "@":U.
                    END.
                    WHEN TRIM("#lit-itd-cst-ibs-uf":U) THEN DO: 
                        {utp/ut-liter.i CST_IBS_UF }
                        ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                               p-tipo-formatacao = "@":U.
                    END.
                    WHEN TRIM("#lit-itd-aliquota-ibs-uf":U) THEN DO: 
                        {utp/ut-liter.i Al°quota_IBS_UF }
                        ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                               p-tipo-formatacao = "#.##0,00":U.
                    END.
                    WHEN TRIM("#lit-itd-base-ibs-uf":U) THEN DO: 
                        {utp/ut-liter.i Base_C†lculo_IBS_UF }
                        ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                               p-tipo-formatacao = "#.##0,00":U.
                    END.
                    WHEN TRIM("#lit-itd-val-ibs-uf":U) THEN DO: 
                        {utp/ut-liter.i Valor_IBS_UF }
                        ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                               p-tipo-formatacao = "#.##0,00":U.
                    END.
                    WHEN TRIM("#lit-itd-class-trib-ibs-mun":U) THEN DO:
                        {utp/ut-liter.i Class_Trib_IBS_Mun}
                        ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                               p-tipo-formatacao = "@":U.
                    END.
                    WHEN TRIM("#lit-itd-cst-ibs-mun":U) THEN DO:
                        {utp/ut-liter.i CST_IBS_Mun}
                        ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                               p-tipo-formatacao = "@":U.
                    END.
                    WHEN TRIM("#lit-itd-aliquota-ibs-mun":U) THEN DO:
                        {utp/ut-liter.i Al°quota_IBS_Mun}
                        ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                               p-tipo-formatacao = "#.##0,00":U.
                    END. 
                    WHEN TRIM("#lit-itd-base-ibs-mun":U) THEN DO:
                        {utp/ut-liter.i Base_C†lculo_IBS_Mun}
                        ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                               p-tipo-formatacao = "#.##0,00":U.
                    END. 
                    WHEN TRIM("#lit-itd-val-ibs-mun":U) THEN DO:
                        {utp/ut-liter.i Valor_IBS_Mun}
                        ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                               p-tipo-formatacao = "#.##0,00":U.
                    END.
                    WHEN TRIM("#lit-itd-class-trib-is":U) THEN DO:
                        {utp/ut-liter.i Class_Trib_IS}
                        ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                               p-tipo-formatacao = "@":U.
                    END. 
                    WHEN TRIM("#lit-itd-cst-is":U) THEN DO:
                        {utp/ut-liter.i CST_IS}
                        ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                               p-tipo-formatacao = "@":U.
                    END. 
                    WHEN TRIM("#lit-itd-aliquota-is":U) THEN DO:
                        {utp/ut-liter.i Al°quota_IS}
                        ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                               p-tipo-formatacao = "#.##0,00":U.
                    END.
                    WHEN TRIM("#lit-itd-aliq-espec-un-is":U) THEN DO:
                        {utp/ut-liter.i Al°quota_Espec°fica_Un_IS}
                        ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                               p-tipo-formatacao = "#.##0,00000":U.
                    END. 
                    WHEN TRIM("#lit-itd-qtde-tribut-is":U) THEN DO:
                        {utp/ut-liter.i Quantidade_Tribut†vel_IS}
                        ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                               p-tipo-formatacao = "#.##0,00000":U.
                    END. 
                    WHEN TRIM("#lit-itd-base-is":U) THEN DO:
                        {utp/ut-liter.i Base_C†lculo_IS}
                        ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                               p-tipo-formatacao = "#.##0,00":U.
                    END. 
                    WHEN TRIM("#lit-itd-val-is":U) THEN DO:
                        {utp/ut-liter.i Valor_IS}
                        ASSIGN p-valor-literal = TRIM(RETURN-VALUE)
                               p-tipo-formatacao = "#.##0,00":U.
                    END.
                END.
            END.
            /* FIM -- Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-965) */
        END.
        /* Traduz literais de Despesas Item Documento */
        IF tt-param.lDespItemDoc AND p-valor-linha MATCHES "*#lit-did-*":U THEN DO:

            CASE p-valor-linha:

                WHEN TRIM("#lit-did-serie-docto	":U) THEN DO: 
                    {utp/ut-liter.i SÇrie }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-did-nro-docto	":U) THEN DO: 
                    {utp/ut-liter.i Documento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-did-cod-emitente	":U) THEN DO: 
                    {utp/ut-liter.i Emitente }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-did-nat-operacao	":U) THEN DO: 
                    {utp/ut-liter.i Nat_Operaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-did-sequencia	":U) THEN DO: 
                    {utp/ut-liter.i Seq }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-did-cod-emitente-desp	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Fornec_Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-did-cod-desp	":U) THEN DO: 
                    {utp/ut-liter.i C¢digo_Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-did-val-desp	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-did-mo-codigo	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-did-cotacao	":U) THEN DO: 
                    {utp/ut-liter.i Cotaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-did-embarque	":U) THEN DO: 
                    {utp/ut-liter.i Embarque }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-did-cod-estabel	":U) THEN DO: 
                    {utp/ut-liter.i Estabelecimento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-did-num-seq-orig	":U) THEN DO: 
                    {utp/ut-liter.i Nr_Sequància }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-did-dat-cotac	":U) THEN DO: 
                    {utp/ut-liter.i Data_da_Cotaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-did-des-sit-despes	":U) THEN DO: 
                    {utp/ut-liter.i Situaá∆o_AP }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-did-nome-emitente-desp	":U) THEN DO: 
                    {utp/ut-liter.i Fornec_Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-did-des-desp	":U) THEN DO: 
                    {utp/ut-liter.i Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-did-des-moeda	":U) THEN DO: 
                    {utp/ut-liter.i Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
            END.
        END.
        /* Traduz literais de Movimento Estoque */
        IF tt-param.lMovtoEstoq AND p-valor-linha MATCHES "*#lit-lot-*":U THEN DO:

            CASE p-valor-linha:

                WHEN TRIM("#lit-lot-serie-docto	":U) THEN DO: 
                    {utp/ut-liter.i SÇrie }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-lot-nro-docto	":U) THEN DO: 
                    {utp/ut-liter.i Documento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-lot-cod-emitente	":U) THEN DO: 
                    {utp/ut-liter.i Emitente }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-lot-nat-operacao	":U) THEN DO: 
                    {utp/ut-liter.i Nat_Operaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-lot-sequencia	":U) THEN DO: 
                    {utp/ut-liter.i Seq }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-lot-it-codigo	":U) THEN DO: 
                    {utp/ut-liter.i Item }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-lot-cod-refer	":U) THEN DO: 
                    {utp/ut-liter.i Referància }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-lot-cod-depos	":U) THEN DO: 
                    {utp/ut-liter.i Deposito }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-lot-lote	":U) THEN DO: 
                    {utp/ut-liter.i Lote/SÇrie }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-lot-cod-localiz	":U) THEN DO: 
                    {utp/ut-liter.i Localizaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-lot-cod-lote-fabrican	":U) THEN DO: 
                    {utp/ut-liter.i Lote_Fabricante }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-lot-dt-vali-lote	":U) THEN DO: 
                    {utp/ut-liter.i Validade_Lote }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-lot-quantidade	":U) THEN DO: 
                    {utp/ut-liter.i Qtde }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,0000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-lot-des-tipo-nota	":U) THEN DO: 
                    {utp/ut-liter.i Tipo_Nota }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-lot-dat-valid-lote-fabrican	":U) THEN DO: 
                    {utp/ut-liter.i Validade_Lote_Fabricante }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-lot-dat-fabricc-lote	":U) THEN DO: 
                    {utp/ut-liter.i Data_Fabricaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-lot-cdn-fabrican	":U) THEN DO: 
                    {utp/ut-liter.i Fabricante }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-lot-nom-fabrican	":U) THEN DO: 
                    {utp/ut-liter.i Nome_Fabricante }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-lot-cod-lote-orig	":U) THEN DO: 
                    {utp/ut-liter.i Lote_Original }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
            END.
        END.
        /* Traduz literais de Despesas */
        IF tt-param.lDespImp AND p-valor-linha MATCHES "*#lit-des-*" THEN DO:

            CASE p-valor-linha:
                
                WHEN TRIM("#lit-des-serie-docto	":U) THEN DO: 
                    {utp/ut-liter.i SÇrie }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-des-nro-docto	":U) THEN DO: 
                    {utp/ut-liter.i Documento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-des-cod-emitente	":U) THEN DO: 
                    {utp/ut-liter.i Fornecedor }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-des-nat-operacao	":U) THEN DO: 
                    {utp/ut-liter.i Nat_Operaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-des-cod-emitente-desp	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Fornec_Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-des-cod-desp	":U) THEN DO: 
                    {utp/ut-liter.i C¢digo_Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-des-val-desp	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-des-cod-cond-pag	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Condiá∆o_Pagamento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-des-mo-codigo	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-des-cotacao	":U) THEN DO: 
                    {utp/ut-liter.i Cotaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-des-nome-emitente-desp	":U) THEN DO: 
                    {utp/ut-liter.i Fornec_Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-des-des-desp	":U) THEN DO: 
                    {utp/ut-liter.i Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-des-des-cond-pag	":U) THEN DO: 
                    {utp/ut-liter.i Condiá∆o_Pagamento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-des-des-moeda	":U) THEN DO: 
                    {utp/ut-liter.i Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
            END.
        END.
        /* Traduz literais de Duplicatas */
        IF tt-param.lDuplicatas AND p-valor-linha MATCHES "*#lit-dup-*":U THEN DO:

            CASE p-valor-linha:
                WHEN TRIM("#lit-dup-serie-docto	":U) THEN DO: 
                    {utp/ut-liter.i SÇrie_Documento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dup-nro-docto	":U) THEN DO: 
                    {utp/ut-liter.i Duplicata }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dup-cod-emitente	":U) THEN DO: 
                    {utp/ut-liter.i Emitente }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dup-nat-operacao	":U) THEN DO: 
                    {utp/ut-liter.i Nat_Operaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dup-ep-codigo	":U) THEN DO: 
                    {utp/ut-liter.i Empresa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dup-cod-estabel	":U) THEN DO: 
                    {utp/ut-liter.i Estabelecimento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dup-cod-esp	":U) THEN DO: 
                    {utp/ut-liter.i EspÇcie }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dup-parcela	":U) THEN DO: 
                    {utp/ut-liter.i Parcela }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dup-dt-emissao	":U) THEN DO: 
                    {utp/ut-liter.i Data_Emiss∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dup-dt-trans	":U) THEN DO: 
                    {utp/ut-liter.i Data_Transaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dup-dt-vencim	":U) THEN DO: 
                    {utp/ut-liter.i Data_Vencimento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dup-vl-a-pagar	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Duplicata }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-dup-dt-venc-desc	":U) THEN DO: 
                    {utp/ut-liter.i Vencimento_com_Descont }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dup-des-esp-movto	":U) THEN DO: 
                    {utp/ut-liter.i DÇbito/CrÇdito }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dup-estado-cq	":U) THEN DO: 
                    {utp/ut-liter.i Estado_Nota }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dup-desconto	":U) THEN DO: 
                    {utp/ut-liter.i Percentual_Desconto }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-dup-vl-desconto	":U) THEN DO: 
                    {utp/ut-liter.i Descto }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-dup-nr-duplic	":U) THEN DO: 
                    {utp/ut-liter.i N£mero_Duplicata }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dup-observacao	":U) THEN DO: 
                    {utp/ut-liter.i Observaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dup-perc-juros	":U) THEN DO: 
                    {utp/ut-liter.i %_Juros }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-dup-dias-atraso	":U) THEN DO: 
                    {utp/ut-liter.i Dias_Atraso }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dup-perc-mora	":U) THEN DO: 
                    {utp/ut-liter.i %_Multa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-dup-tp-despesa	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Tipo_Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dup-vl-taxa	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Imposto }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-dup-vl-frete	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Frete }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-dup-vl-outros	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Outros }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-dup-mo-codigo	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dup-vl-a-pagar-mo	":U) THEN DO: 
                    {utp/ut-liter.i Vl_Mo_Orig }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-dup-vl-descto-mo	":U) THEN DO: 
                    {utp/ut-liter.i Vl_Desc_Mo_Orig }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-dup-des-tp-despesa	":U) THEN DO: 
                    {utp/ut-liter.i Tipo_Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dup-des-moeda	":U) THEN DO: 
                    {utp/ut-liter.i Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dup-mo-codigo-mo	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Moeda_Orig }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dup-des-moeda-mo	":U) THEN DO: 
                    {utp/ut-liter.i Moeda_Orig }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
            END.
        END.
        /* Traduz literais de Duplicatas de Despesas */
        IF tt-param.lDupDespesas AND p-valor-linha MATCHES "*#lit-dpd-*":U THEN DO:

            CASE p-valor-linha:

                WHEN TRIM("#lit-dpd-serie-docto	":U) THEN DO: 
                    {utp/ut-liter.i SÇrie_Documento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dpd-nro-docto	":U) THEN DO: 
                    {utp/ut-liter.i Duplicata }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dpd-cod-emitente	":U) THEN DO: 
                    {utp/ut-liter.i Emitente }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dpd-nat-operacao	":U) THEN DO: 
                    {utp/ut-liter.i Nat_Operaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dpd-cod-emitente-desp	":U) THEN DO: 
                    {utp/ut-liter.i Fornec_Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dpd-cod-esp	":U) THEN DO: 
                    {utp/ut-liter.i EspÇcie }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dpd-parcela	":U) THEN DO: 
                    {utp/ut-liter.i Parcela }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dpd-dt-emissao	":U) THEN DO: 
                    {utp/ut-liter.i Data_Emiss∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dpd-dt-trans	":U) THEN DO: 
                    {utp/ut-liter.i Data_Transaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dpd-dt-vencim	":U) THEN DO: 
                    {utp/ut-liter.i Data_Vencimento }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dpd-vl-a-pagar	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Duplicata }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-dpd-desconto	":U) THEN DO: 
                    {utp/ut-liter.i Percentual_Desconto }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-dpd-dt-venc-desc	":U) THEN DO: 
                    {utp/ut-liter.i Vencimento_C/_Desconto }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dpd-des-esp-movto	":U) THEN DO: 
                    {utp/ut-liter.i DÇbito/CrÇdito }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dpd-vl-desconto	":U) THEN DO: 
                    {utp/ut-liter.i Desconto }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-dpd-nr-duplic	":U) THEN DO: 
                    {utp/ut-liter.i N£mero_Duplicata }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dpd-observacao	":U) THEN DO: 
                    {utp/ut-liter.i Observaá∆o }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dpd-perc-juros	":U) THEN DO: 
                    {utp/ut-liter.i %_Juros }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-dpd-dias-atraso	":U) THEN DO: 
                    {utp/ut-liter.i Dias_Atraso }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dpd-perc-mora	":U) THEN DO: 
                    {utp/ut-liter.i %_Multa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00000":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-dpd-tp-despesa	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Tipo_Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dpd-historico	":U) THEN DO: 
                    {utp/ut-liter.i Hist¢rico }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dpd-vl-taxa	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Imposto }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-dpd-vl-frete	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Frete }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-dpd-vl-outros	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Outros }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-dpd-valor-a-pagar-me	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Pagar }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-dpd-mo-codigo	":U) THEN DO: 
                    {utp/ut-liter.i Cod_Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dpd-vl-a-pagar-mo	":U) THEN DO: 
                    {utp/ut-liter.i Valor_Dupli_Mo_Orig }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "#.##0,00":U  
                           p-alinha-direita = YES.                         
                END.
                WHEN TRIM("#lit-dpd-nome-emitente-desp	":U) THEN DO: 
                    {utp/ut-liter.i Fornec_Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dpd-des-tp-despesa	":U) THEN DO: 
                    {utp/ut-liter.i Tipo_Despesa }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
                WHEN TRIM("#lit-dpd-des-moeda	":U) THEN DO: 
                    {utp/ut-liter.i Moeda }  
                    ASSIGN p-valor-literal = TRIM(RETURN-VALUE) 
                           p-tipo-formatacao = "@":U.                         
                END.
            END.
        END.
    END.

    RETURN "OK":U.                               
END PROCEDURE.
