/******************************************************************
**  Objeto: i03ad039.i
**  Campo: cond-pagto.char-1,44,2 - Meios de Pagamento [NF-e]
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1  01 - Dinheiro         
&glob val2  02 - Cheque           
&glob val3  03 - CartÆo de Cr‚dito
&glob val4  04 - CartÆo de D‚bito 
&glob val5  05 - CartÆo da Loja (Private Label)    
&glob val6  10 - Vale Alimenta‡Æo 
&glob val7  11 - Vale Refei‡Æo    
&glob val8  12 - Vale Presente    
&glob val9  13 - Vale Combust¡vel 
&glob val9  14 - Duplicata Mercantil 
&glob val10 15 - Boleto Banc rio
&glob val11 16 - Dep¢sito Banc rio
&glob val12 17 - Pagamento Instantƒneo (PIX)-Dinƒmico
&glob val13 18 - TED (Transferˆncia Eletr“nica Dispon¡vel)
&glob val14 19 - Prog. Fidelidade/Cashback/Cr‚d. Virtual
&glob val15 20 - Pagamento Instantƒneo (PIX)-Est tico
&glob val16 21 - Cr‚dito em Loja
&glob val17 22 - Pagamento Eletr“nico nÆo Informado
&glob val18 23 - Pagamento Instantƒneo (PIX)-Autom tico
&glob val19 24 - TEF (Book Transfer) 
&glob val20 90 - Sem pagamento    
&glob val21 91 - Pagamento Posterior    
&glob val22 99 - Outros
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1  01 - Dinero
&glob val2  02 - Cheque
&glob val3  03 - Tarjeta de Cr‚dito
&glob val4  04 - Tarjeta de D‚bito
&glob val5  05 - Tarjeta Tienda (Private Label) 
&glob val6  10 - Ticket Canasta
&glob val7  11 - Ticket Restaurante
&glob val8  12 - Cup¢n de Regalo
&glob val9  13 - Ticket Auto
&glob val9  14 - Comercio duplicado 
&glob val10 15 - Boleta Bancaria
&glob val11 16 - Dep¢sito Bancario
&glob val12 17 - Pago instant neo (PIX)-Din mica
&glob val13 18 - Transferencia bancaria/Cartera digital
&glob val14 19 - Prog. Fidelizaci¢n/Cashback/Cr‚d. Virtual
&glob val15 20 - Pago instant neo (PIX)-Est tico
&glob val16 21 - Cr‚dito de la tienda
&glob val17 22 - Pago electr¢nico no informado
&glob val18 23 - Pago Instant neo (PIX)-Autom tico
&glob val19 24 - TEF (Book Transfer) 
&glob val20 90 - Sin Pago
&glob val21 91 - Pago Diferido
&glob val22 99 - Otros
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1  01 - Money          
&glob val2  02 - Check          
&glob val3  03 - Credit Card    
&glob val4  04 - Debit Card     
&glob val5  05 - Store Credit (Private Label)   
&glob val6  10 - Food Voucher   
&glob val7  11 - Meal Voucher   
&glob val8  12 - Gift voucher   
&glob val9  13 - Fuel Voucher  
&glob val9  14 - Trade Duplicate 
&glob val10 15 - Bank Slip
&glob val11 16 - Bank Deposit
&glob val12 17 - Instant Payment (PIX)-Dynamic
&glob val13 18 - Bank transfer/Digital Wallet
&glob val14 19 - Loyalty program/Cashback/Virtual Credit
&glob val15 20 - Instant Payment (PIX)ÎStatic
&glob val16 21 - Store Credit
&glob val17 22 - Electronic payment not informed
&glob val18 23 - Instant Payment (PIX)-Automatic
&glob val19 24 - TEF (Book Transfer) 
&glob val20 90 - Without Payment
&glob val21 91 - Deferred Payment
&glob val22 99 - Others
&ENDIF

{include/ind11-50.i {1} {2}}
/*{include/ind51500.i {1} {2}}*/

/* fim */

