DEFINE VARIABLE c-titulo-coluna  AS CHARACTER EXTENT 36 NO-UNDO.
DEFINE VARIABLE d-largura-coluna AS DECIMAL   EXTENT 36 NO-UNDO.
DEFINE VARIABLE c-format-coluna  AS DECIMAL   EXTENT 36 NO-UNDO.
DEFINE VARIABLE c-campo          AS CHARACTER EXTENT 36 NO-UNDO.
DEFINE VARIABLE c-periodo        AS CHARACTER           NO-UNDO.

/** Titulo Colunas Planilha **/
{utp/ut-liter.i Transp * r}
ASSIGN c-titulo-coluna[1]  = RETURN-VALUE.

{utp/ut-liter.i Nome_transp * r}
ASSIGN c-titulo-coluna[2]  = RETURN-VALUE.

{utp/ut-liter.i Estab * r}
ASSIGN c-titulo-coluna[3]  = RETURN-VALUE.  

{utp/ut-liter.i Rota * r}
ASSIGN c-titulo-coluna[4]  = RETURN-VALUE.  

{utp/ut-liter.i Desc_Rota * r}
ASSIGN c-titulo-coluna[5]  = RETURN-VALUE.  

{utp/ut-liter.i Data_Trans * r}    
ASSIGN c-titulo-coluna[6]  = RETURN-VALUE.  

{utp/ut-liter.i Carga * r}
ASSIGN c-titulo-coluna[7]  = RETURN-VALUE.  

{utp/ut-liter.i Situaá∆o * r}
ASSIGN c-titulo-coluna[8]  = RETURN-VALUE. 

{utp/ut-liter.i Tipo_Ve°culo * r}
ASSIGN c-titulo-coluna[9]  = RETURN-VALUE. 

{utp/ut-liter.i Item * r}
ASSIGN c-titulo-coluna[10]  = RETURN-VALUE.

{utp/ut-liter.i Placa * r}
ASSIGN c-titulo-coluna[11]  = RETURN-VALUE.

{utp/ut-liter.i Capac_Veic_(L) * r}
ASSIGN c-titulo-coluna[12]  = RETURN-VALUE.

{utp/ut-liter.i KM_Rodados * r}
ASSIGN c-titulo-coluna[13] = RETURN-VALUE. 

{utp/ut-liter.i KM_Padr∆o_Rota * r}
ASSIGN c-titulo-coluna[14] = RETURN-VALUE.

{utp/ut-liter.i Preáo_Unit_KM_Tab * r}
ASSIGN c-titulo-coluna[15] = RETURN-VALUE.

{utp/ut-liter.i Qtde_Aferida * r}
ASSIGN c-titulo-coluna[16] = RETURN-VALUE.

{utp/ut-liter.i Qtde_Coletada * r}
ASSIGN c-titulo-coluna[17] = RETURN-VALUE. 

{utp/ut-liter.i Diferenáa_Qtde * r}
ASSIGN c-titulo-coluna[18] = RETURN-VALUE.

{utp/ut-liter.i Qtde_Rejeitada * r}
ASSIGN c-titulo-coluna[19] = RETURN-VALUE.

{utp/ut-liter.i Preáo_Unit_Qtde_Tab * r}
ASSIGN c-titulo-coluna[20] = RETURN-VALUE.

{utp/ut-liter.i Preáo_Fixo_Tab * r}
ASSIGN c-titulo-coluna[21] = RETURN-VALUE.

{utp/ut-liter.i Motivo_N∆o_Coleta * r}
ASSIGN c-titulo-coluna[22] = RETURN-VALUE.

{utp/ut-liter.i Pontos_Coleta * r}
ASSIGN c-titulo-coluna[23] = RETURN-VALUE.

{utp/ut-liter.i Pontos_Coleta_Coletados * r}
ASSIGN c-titulo-coluna[24] = RETURN-VALUE.

{utp/ut-liter.i Pontos_Coleta_Bonificados * r}
ASSIGN c-titulo-coluna[25] = RETURN-VALUE.

{utp/ut-liter.i Bìnus_Unit_Pto_Coleta_Tab * r}
ASSIGN c-titulo-coluna[26] = RETURN-VALUE.

{utp/ut-liter.i KM_Bonificados * r}
ASSIGN c-titulo-coluna[27] = RETURN-VALUE.

{utp/ut-liter.i Bìnus_Unit_Km_Tab * r}
ASSIGN c-titulo-coluna[28] = RETURN-VALUE.

{utp/ut-liter.i Custo_Total_-_R$_(Pagar) * r}        
ASSIGN c-titulo-coluna[29] = RETURN-VALUE.

{utp/ut-liter.i Custo_Total_-_R$_(Padr∆o) * r}       
ASSIGN c-titulo-coluna[30] = RETURN-VALUE.

{utp/ut-liter.i DÇbito_Transportador_(Desconto) * r}       
ASSIGN c-titulo-coluna[31] = RETURN-VALUE.

{utp/ut-liter.i Valor_Liq_Frete * r}        
ASSIGN c-titulo-coluna[32] = RETURN-VALUE.

{utp/ut-liter.i Vl_Frete/Qtde * r}        
ASSIGN c-titulo-coluna[33] = RETURN-VALUE.

{utp/ut-liter.i %_Ocupaá∆o * r}
ASSIGN c-titulo-coluna[34] = RETURN-VALUE.

{utp/ut-liter.i Litros/KM * r}        
ASSIGN c-titulo-coluna[35] = RETURN-VALUE.

{utp/ut-liter.i Regra_Utilizada * r}        
ASSIGN c-titulo-coluna[36] = RETURN-VALUE.



/** Nome dos campos da tabela **/ 
ASSIGN c-campo[1]  = "cod-transp":U
       c-campo[2]  = "nome":U
       c-campo[3]  = "cod-estabel":U
       c-campo[4]  = "cod-rota":U
       c-campo[5]  = "des-rota":U
       c-campo[6]  = "dat-trans":U
       c-campo[7]  = "num-carg":U
       c-campo[8]  = "desc-sit-carg":U
       c-campo[9]  = "des-tip-veic":U
       c-campo[10] = "it-codigo":U
       c-campo[11] = "cod-placa":U
       c-campo[12] = "qtd-capac-vol":U
       c-campo[13] = "km-rodados":U
       c-campo[14] = "val-percur":U       
       c-campo[15] = "val-unit-frete-km":U
       c-campo[16] = "qtd-aferid":U
       c-campo[17] = "qtd-coleta":U
       c-campo[18] = "dif-qtde":U
       c-campo[19] = "qtd-reprovada":U
       c-campo[20] = "val-unit-frete-quant":U
       c-campo[21] = "val-fix-frete":U
       c-campo[22] = "motiv-nao-coleta":U
       c-campo[23] = "qtd-pto-col":U
       c-campo[24] = "num-pto-coletados":U
       c-campo[25] = "qtd-pto-col-bon":U
       c-campo[26] = "val-unit-bonus-pto-col":U
       c-campo[27] = "km-bonif":U
       c-campo[28] = "val-unit-bonus-km":U
       c-campo[29] = "valor-frete-pagar":U
       c-campo[30] = "valor-frete-padrao":U
       c-campo[31] = "val-debit-transp":U
       c-campo[32] = "val-liq-frete":U
       c-campo[33] = "vl-frete-qtde":U
       c-campo[34] = "percent-ocup":U
       c-campo[35] = "lt-km":U
       c-campo[36] = "regra-utiliz":U.
       

ASSIGN d-largura-coluna[1]  = 10.14
       d-largura-coluna[2]  = 17.30
       d-largura-coluna[3]  = 7.7  
       d-largura-coluna[4]  = 12
       d-largura-coluna[5]  = 27
       d-largura-coluna[6]  = 10.15
       d-largura-coluna[7]  = 10 
       d-largura-coluna[8]  = 18
       d-largura-coluna[9]  = 18   
       d-largura-coluna[10] = 18
       d-largura-coluna[11] = 10
       d-largura-coluna[12] = 13
       d-largura-coluna[13] = 13
       d-largura-coluna[14] = 13
       d-largura-coluna[15] = 18
       d-largura-coluna[16] = 18
       d-largura-coluna[17] = 18
       d-largura-coluna[18] = 18
       d-largura-coluna[19] = 12
       d-largura-coluna[20] = 18
       d-largura-coluna[21] = 22
       d-largura-coluna[22] = 17
       d-largura-coluna[23] = 12
       d-largura-coluna[24] = 15       
       d-largura-coluna[25] = 25
       d-largura-coluna[26] = 18
       d-largura-coluna[27] = 18
       d-largura-coluna[28] = 18
       d-largura-coluna[29] = 25
       d-largura-coluna[30] = 25
       d-largura-coluna[31] = 22
       d-largura-coluna[32] = 22
       d-largura-coluna[33] = 22
       d-largura-coluna[34] = 15
       d-largura-coluna[35] = 15
       d-largura-coluna[36] = 100.       
       
{utp/ut-liter.i Per°odo * r}
ASSIGN c-periodo = RETURN-VALUE.

{utp/ut-liter.i Relat¢rio_C†lculo_Frete_Coleta * r}
ASSIGN c-titulo-relat = TRIM(RETURN-VALUE).
