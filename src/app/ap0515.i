/*************************************************************************
**
** PD0515.I - Importa‡Æo de Dados do Estoque 
**
*************************************************************************/
 
{utp/ut-liter.i Empresa___________________________________ MAP R}
assign c-layout-rg1[1] = "1," + return-value + ",03," + c-inteiro  + ",00,," + c-obrigat.

{utp/ut-liter.i Referˆncia________________________________ MAP R}
assign c-layout-rg1[2] = "2," + return-value + ",10," + c-caracter  + ",00,," + c-obrigat.

{utp/ut-liter.i Sequˆncia_________________________________ MAP R}
assign c-layout-rg1[3] = "3," + return-value + ",6," + c-inteiro  + ",10,," + c-obrigat.

{utp/ut-liter.i S‚rie_____________________________________ MAP R}
assign c-layout-rg1[4] = "4," + return-value + ",5," + c-caracter + ",00,," + c-obrigat.

{utp/ut-liter.i N£mero_Documento__________________________ MAP R}
assign c-layout-rg1[5] = "5," + return-value + ",16," + c-caracter + ",00,," + c-obrigat.

{utp/ut-liter.i Parcela___________________________________ MAP R}
assign c-layout-rg1[6] = "6," + return-value + ",2," + c-caracter + ",00,," + c-obrigat.

{utp/ut-liter.i Fornecedor________________________________ MAP R}
assign c-layout-rg1[7] = "7," + return-value + ",6," + c-inteiro  + ",00,," + c-obrigat.

{utp/ut-liter.i Data_EmissÆo______________________________ MAP R}
assign c-layout-rg1[8] = "8," + return-value + ",10," + c-data + ",00,," + c-obrigat.

{utp/ut-liter.i Data_Vencimento___________________________ MAP R}
assign c-layout-rg1[9] = "9," + return-value + ",10," + c-data + ",00,," + c-obrigat.

{utp/ut-liter.i Valor_Original____________________________ MAP R}
assign c-layout-rg1[10] = "10," + return-value + ",15," + c-decimal + ",00,2," + c-obrigat.

{utp/ut-liter.i Data_Desconto_____________________________ MAP R}
assign c-layout-rg1[11] = "11," + return-value + ",10," + c-data + ",00,," + c-obrigat.

{utp/ut-liter.i Valor_Desconto____________________________ MAP R}
assign c-layout-rg1[12] = "12," + return-value + ",15," + c-decimal + ",00,2," + c-obrigat.

{utp/ut-liter.i Estado____________________________________ MAP R}
assign c-layout-rg1[13] = "13," + return-value + ",1," + c-inteiro  + ",00,," + c-obrigat.
                                                                       
{utp/ut-liter.i Conta_____________________________________ MAP R}
assign c-layout-rg1[14] = "14," + return-value + ",8," + c-caracter  + ",00,," + c-obrigat.

{utp/ut-liter.i Sub_Conta_____________________________________ MAP R}
assign c-layout-rg1[15] = "15," + return-value + ",8," + c-caracter + ",00,," + c-obrigat.

{utp/ut-liter.i Origem________________________________________ MAP R}
assign c-layout-rg1[16] = "16," + return-value + ",2," + c-inteiro + ",01,," + c-obrigat.

{utp/ut-liter.i Estabelecimento_______________________________ MAP R}
assign c-layout-rg1[17] = "17," + return-value + ",3," + c-caracter + ",00,," + c-obrigat.

{utp/ut-liter.i Portador______________________________________ MAP R}
assign c-layout-rg1[18] = "18," + return-value + ",5," + c-inteiro  + ",00,," + c-obrigat.

{utp/ut-liter.i Esp‚cie_______________________________________ MAP R}
assign c-layout-rg1[19] = "19," + return-value + ",2," + c-caracter + ",00,," + c-obrigat.

{utp/ut-liter.i Perc_Multa___________________________________ MAP R}
assign c-layout-rg1[20] = "20," + return-value + ",4," + c-decimal + ",00,2," + c-obrigat.

{utp/ut-liter.i Valor_Juros__________________________________ MAP R}
assign c-layout-rg1[21] = "21," + return-value + ",15," + c-decimal + ",00,2," + c-obrigat.

{utp/ut-liter.i Seq_Importa‡Æo_______________________________ MAP R}
assign c-layout-rg1[22] = "22," + return-value + ",6," + c-inteiro + ",00,," + c-obrigat.

{utp/ut-liter.i Data_Transa‡Æo_______________________________ MAP R}
assign c-layout-rg1[23] = "23," + return-value + ",10," + c-data + ",00,," + c-obrigat.

{utp/ut-liter.i Valor_Imposto_________________________________ MAP R}
assign c-layout-rg1[24] = "24," + return-value + ",15," + c-decimal  + ",00,2," + c-obrigat.

{utp/ut-liter.i Percentual_Juros______________________________ MAP R}
assign c-layout-rg1[25] = "25," + return-value + ",3," + c-decimal + ",00,5," + c-obrigat.
                                                                      
{utp/ut-liter.i Dias_Atraso___________________________________ MAP R}
assign c-layout-rg1[26] = "26," + return-value + ",3," + c-inteiro + ",00,," + c-obrigat.

{utp/ut-liter.i Percentual_Mora________________________________ MAP R}
assign c-layout-rg1[27] = "27," + return-value + ",3," + c-decimal + ",00,5," + c-obrigat.

{utp/ut-liter.i Observa‡Æo_____________________________________ MAP R}
assign c-layout-rg1[28] = "28," + return-value + ",80," + c-caracter + ",00,," + c-obrigat.

{utp/ut-liter.i C¢digo_Barras__________________________________ MAP R}
assign c-layout-rg1[29] = "29," + return-value + ",40," + c-caracter + ",00,," + c-obrigat.

{utp/ut-liter.i Valor_IR_______________________________________ MAP R}
assign c-layout-rg1[30] = "30," + return-value + ",15," + c-decimal  + ",00,2," + c-obrigat.

{utp/ut-liter.i Tipo_Despesa___________________________________ MAP R}
assign c-layout-rg1[31] = "31," + return-value + ",3," + c-inteiro + ",00,," + c-obrigat.

{utp/ut-liter.i Hist¢rico______________________________________ MAP R}
assign c-layout-rg1[32] = "32," + return-value + ",80," + c-caracter + ",00,," + c-obrigat.

{utp/ut-liter.i Hist¢rico_PadrÆo_______________________________ MAP R}
assign c-layout-rg1[33] = "33," + return-value + ",3," + c-inteiro + ",00,," + c-obrigat.

{utp/ut-liter.i C¢digo_Reten‡Æo________________________________ MAP R}
assign c-layout-rg1[34] = "34," + return-value + ",5," + c-inteiro + ",00,," + c-obrigat.

{utp/ut-liter.i Fatura_________________________________________ MAP R}
assign c-layout-rg1[35] = "35," + return-value + ",7," + c-inteiro + ",00,," + c-obrigat.

{utp/ut-liter.i Valor_FASB_____________________________________ MAP R}
assign c-layout-rg1[36] = "36," + return-value + ",12," + c-decimal  + ",00,2," + c-obrigat.

{utp/ut-liter.i Valor_Pres_____________________________________ MAP R}
assign c-layout-rg1[37] = "37," + return-value + ",12," + c-decimal + ",00,2," + c-obrigat.

{utp/ut-liter.i Valor_CMI______________________________________ MAP R}
assign c-layout-rg1[38] = "38," + return-value + ",12," + c-decimal + ",00,2," + c-obrigat.

{utp/ut-liter.i C¢digo_Controle________________________________ MAP R}
assign c-layout-rg1[39] = "39," + return-value + ",15," + c-caracter + ",00,," + c-obrigat.

{utp/ut-liter.i Tem_Hist¢rico__________________________________ MAP R}
assign c-layout-rg1[40] = "40," + return-value + ",1," + c-logico + ",00,," + c-obrigat.

{utp/ut-liter.i Valor_IR_Antec_________________________________ MAP R}
assign c-layout-rg1[41] = "41," + return-value + ",15," + c-decimal + ",00,2," + c-obrigat.

{utp/ut-liter.i N£mero_Ordem_Inv_______________________________ MAP R}
assign c-layout-rg1[42] = "42," + return-value + ",6," + c-inteiro  + ",00,," + c-obrigat.

{utp/ut-liter.i Tipo_Pagamento_________________________________ MAP R}
assign c-layout-rg1[43] = "43," + return-value + ",2," + c-inteiro + ",00,," + c-obrigat.

{utp/ut-liter.i Conta_D‚bito___________________________________ MAP R}
assign c-layout-rg1[44] = "44," + return-value + ",17," + c-caracter + ",00,," + c-obrigat.



/**** Vari veis Lote *****/


{utp/ut-liter.i Empresa___________________________________ MAP R}
assign c-layout-rg2[1] = "1," + return-value + ",03," + c-inteiro  + ",00,," + c-obrigat.

{utp/ut-liter.i Referˆncia________________________________ MAP R}
assign c-layout-rg2[2] = "2," + return-value + ",10," + c-caracter  + ",00,," + c-obrigat.

{utp/ut-liter.i Estabelecimento_______________________________ MAP R}
assign c-layout-rg2[3] = "3," + return-value + ",3," + c-caracter + ",00,," + c-obrigat.

{utp/ut-liter.i Esp‚cie_______________________________________ MAP R}
assign c-layout-rg2[4] = "4," + return-value + ",2," + c-caracter + ",00,," + c-obrigat.

{utp/ut-liter.i Data-Movto____________________________________ MAP R}
assign c-layout-rg2[5] = "5," + return-value + ",10," + c-data  + ",00,," + c-obrigat.

{utp/ut-liter.i Valor_Movto___________________________________ MAP R}
assign c-layout-rg2[6] = "6," + return-value + ",15," + c-decimal + ",00,02," + c-obrigat.


/**** Fim Vari veis Lote ****/


