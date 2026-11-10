
/******************************************************************
**
** i01ad435.i  Campo: mapa-tip-reg-layout.idi-contdo-layout
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Id Federal
&glob val2 Tipo de Processo
&glob val3 Dia Geraá∆o 
&glob val4 Màs Geraá∆o 
&glob val5 Ano Geraá∆o 
&glob val6 Hora Geraá∆o 
&glob val7 SeqÅància
&glob val8 Banco 
&glob val9 Agencia Bancaria 
&glob val10 Id Federal Fornecedor 
&glob val11 Nome Fornecedor 
&glob val12 T°tulo Banc†rio 
&glob val13 Dia Vencimento 
&glob val14 Màs Vencimento 
&glob val15 Ano Vencimento 
&glob val16 Dia Emiss∆o 
&glob val17 Màs Emiss∆o 
&glob val18 Ano Emiss∆o 
&glob val19 Valor T°tulos Banc†rio 
&glob val20 Dia Desconto 
&glob val21 Màs Desconto 
&glob val22 Ano Desconto 
&glob val23 Valor Desconto 
&glob val24 Dia Multa 
&glob val25 Màs Multa 
&glob val26 Ano Multa 
&glob val27 Valor Multa 
&glob val28 C¢digo de Barras
&glob val29 Carteira Bancaria 
&glob val30 Tipo de Movimento 
&glob val31 Id Federal Sacador/Avalista 
&glob val32 Nome Sacador/Avalista
&glob val33 Conta Corrente
&glob val34 Modalidade
&glob val35 Campo Livre
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1  ID Federal 
&glob val2  Tipo de Proceso  
&glob val3  D°a Genercn            
&glob val4  Mes Genercn  
&glob val5  A§o Generac  
&glob val6  Hora Gen  
&glob val7  Secuencia 
&glob val8  Banco  
&glob val9  Agencia Bancaria  
&glob val10 Id Federal Proveedor  
&glob val11 Nombre Proveedr  
&glob val12 T°tulo Bancario  
&glob val13 D°a Vencimiento  
&glob val14 Mes Vencimien  
&glob val15 A§o Vencimien  
&glob val16 D°a Emisn  
&glob val17 Mes Emisi¢n  
&glob val18 A§o Emisi¢n  
&glob val19 Valor T°tulos Bancario  
&glob val20 D°a Descuen  
&glob val21 Mes Descuen  
&glob val22 A§o Descuen
&glob val23 Valor Descuento
&glob val24 D°a Multa  
&glob val25 Mes Multa  
&glob val26 A§o Multa  
&glob val27 Valor Multa  
&glob val28 C¢digo de Barras 
&glob val29 Cartera Bancaria  
&glob val30 Tipo de Transaccn 
&glob val31 Id Federal Sacador/Avalista  
&glob val32 Nombr Sacadr/Avalista
&glob val33 Cuenta Corriente
&glob val34 Modalidad
&glob val35 Campo Libre
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1  Federal ID 
&glob val2  Process Type  
&glob val3  Generat Day            
&glob val4  Gener Mth  
&glob val5  Generac Yr  
&glob val6  Gen Time  
&glob val7  Sequence 
&glob val8  Bank  
&glob val9  Bank Branch  
&glob val10 Supplier Fed ID  
&glob val11 Vendor Name  
&glob val12 Banking Doc  
&glob val13 Due Date  
&glob val14 Due Date Mth  
&glob val15 Due Dt Year  
&glob val16 Print Day  
&glob val17 Print Mth  
&glob val18 Print Year  
&glob val19 Bank Document Amount  
&glob val20 Discount Day  
&glob val21 Discount Mth  
&glob val22 Discount Yr  
&glob val23 Discount Amount
&glob val24 Penlt Day  
&glob val25 Penlt Mth  
&glob val26 Penalt Yr  
&glob val27 Penalty Amt  
&glob val28 Bar Code 
&glob val29 Bank Portfolio  
&glob val30 Transaction Type 
&glob val31 Drawee/Guarantor Fed ID  
&glob val32 Drawee/Guarantor Name
&glob val33 Checking Account
&glob val34 Modality 
&glob val35 Empty Field
&ENDIF
          
{include/ind11-50.i {1} {2}}
/* Fim */


