/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0002DF 2.00.00.003 } /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC0002DF MBC}
&ENDIF


define temp-table ttLinhaDF NO-UNDO
    field Linha as char format "x(200)".
create ttLinhaDf. assign Linha = "ADD TABLE ~"bc-trans-param~"" .
create ttLinhaDf. assign Linha = "  DUMP-NAME ~"cl022~"" .
create ttLinhaDf. assign Linha = "  TABLE-TRIGGER ~"CREATE~" OVERRIDE PROCEDURE ~"database/tgcl/tcp/tccl022.p~" CRC ~"?~" " .
create ttLinhaDf. assign Linha = "  TABLE-TRIGGER ~"DELETE~" OVERRIDE PROCEDURE ~"database/tgcl/tdp/tdcl022.p~" CRC ~"?~" " .
create ttLinhaDf. assign Linha = "  TABLE-TRIGGER ~"WRITE~" OVERRIDE PROCEDURE ~"database/tgcl/twp/twcl022.p~" CRC ~"?~" " .
create ttLinhaDf. assign Linha = "" .
create ttLinhaDf. assign Linha = "ADD FIELD ~"cd-trans~" OF ~"bc-trans-param~" AS character " .
create ttLinhaDf. assign Linha = "  DESCRIPTION ~"C½digo da transa»’o~"" .
create ttLinhaDf. assign Linha = "  FORMAT ~"x(8)~"" .
create ttLinhaDf. assign Linha = "  INITIAL ~"~"" .
create ttLinhaDf. assign Linha = "  LABEL ~"C½digo Transa»’o~"" .
create ttLinhaDf. assign Linha = "  LABEL-SA ~"R20~"" .
create ttLinhaDf. assign Linha = "  COLUMN-LABEL ~"Transa»’o~"" .
create ttLinhaDf. assign Linha = "  COLUMN-LABEL-SA ~"L9~"" .
create ttLinhaDf. assign Linha = "  VALEXP ~"bc-tipo-trans.cd-trans <> ~"~"~"~"~"" .
create ttLinhaDf. assign Linha = "  VALMSG ~"O c½digo da transa»’o n’o pode ser branco~"" .
create ttLinhaDf. assign Linha = "  HELP ~"C½digo da transa»’o~"" .
create ttLinhaDf. assign Linha = "  ORDER 10" .
create ttLinhaDf. assign Linha = "  MANDATORY" .
create ttLinhaDf. assign Linha = "" .
create ttLinhaDf. assign Linha = "ADD FIELD ~"desc-param~" OF ~"bc-trans-param~" AS character " .
create ttLinhaDf. assign Linha = "  DESCRIPTION ~"Descri»’o do Par³metro~"" .
create ttLinhaDf. assign Linha = "  FORMAT ~"X(300)~"" .
create ttLinhaDf. assign Linha = "  INITIAL ~"~"" .
create ttLinhaDf. assign Linha = "  LABEL ~"Descri»’o~"" .
create ttLinhaDf. assign Linha = "  COLUMN-LABEL ~"Descr~"" .
create ttLinhaDf. assign Linha = "  HELP ~"Descri»’o do Par³metro~"" .
create ttLinhaDf. assign Linha = "  ORDER 20" .
create ttLinhaDf. assign Linha = "" .
create ttLinhaDf. assign Linha = "ADD FIELD ~"cd-param~" OF ~"bc-trans-param~" AS character " .
create ttLinhaDf. assign Linha = "  DESCRIPTION ~"C½digo do par³metro~"" .
create ttLinhaDf. assign Linha = "  FORMAT ~"X(20)~"" .
create ttLinhaDf. assign Linha = "  INITIAL ~"~"" .
create ttLinhaDf. assign Linha = "  LABEL ~"C½digo~"" .
create ttLinhaDf. assign Linha = "  COLUMN-LABEL ~"C½digo~"" .
create ttLinhaDf. assign Linha = "  HELP ~"C½digo do par³metro~"" .
create ttLinhaDf. assign Linha = "  ORDER 30" .
create ttLinhaDf. assign Linha = "" .
create ttLinhaDf. assign Linha = "ADD FIELD ~"param-inteiro~" OF ~"bc-trans-param~" AS integer " .
create ttLinhaDf. assign Linha = "  DESCRIPTION ~"Par³metro com tipo de dado inteiro~"" .
create ttLinhaDf. assign Linha = "  FORMAT ~">>>,>>>,>>9~"" .
create ttLinhaDf. assign Linha = "  INITIAL ~"0~"" .
create ttLinhaDf. assign Linha = "  LABEL ~"Param Inteiro~"" .
create ttLinhaDf. assign Linha = "  COLUMN-LABEL ~"Param Int~"" .
create ttLinhaDf. assign Linha = "  HELP ~"Par³metro com tipo de dado inteiro~"" .
create ttLinhaDf. assign Linha = "  ORDER 40" .
create ttLinhaDf. assign Linha = "" .
create ttLinhaDf. assign Linha = "ADD FIELD ~"param-caracter~" OF ~"bc-trans-param~" AS character " .
create ttLinhaDf. assign Linha = "  DESCRIPTION ~"Par³metro com tipo de dado caracter~"" .
create ttLinhaDf. assign Linha = "  FORMAT ~"X(300)~"" .
create ttLinhaDf. assign Linha = "  INITIAL ~"~"" .
create ttLinhaDf. assign Linha = "  LABEL ~"Param Caracter~"" .
create ttLinhaDf. assign Linha = "  COLUMN-LABEL ~"Par Car~"" .
create ttLinhaDf. assign Linha = "  HELP ~"Par³metro com tipo de dado caracter~"" .
create ttLinhaDf. assign Linha = "  ORDER 50" .
create ttLinhaDf. assign Linha = "" .
create ttLinhaDf. assign Linha = "ADD FIELD ~"param-decimal~" OF ~"bc-trans-param~" AS decimal " .
create ttLinhaDf. assign Linha = "  DESCRIPTION ~"Par³metro com tipo de dado Decimal~"" .
create ttLinhaDf. assign Linha = "  FORMAT ~">>>,>>>,>>>,>>9.9999999999~"" .
create ttLinhaDf. assign Linha = "  INITIAL ~"0~"" .
create ttLinhaDf. assign Linha = "  LABEL ~"Param Decimal~"" .
create ttLinhaDf. assign Linha = "  COLUMN-LABEL ~"Par Dec~"" .
create ttLinhaDf. assign Linha = "  HELP ~"Par³metro com tipo de dado Decimal~"" .
create ttLinhaDf. assign Linha = "  DECIMALS 2" .
create ttLinhaDf. assign Linha = "  ORDER 60" .
create ttLinhaDf. assign Linha = "" .
create ttLinhaDf. assign Linha = "ADD FIELD ~"param-data~" OF ~"bc-trans-param~" AS date " .
create ttLinhaDf. assign Linha = "  DESCRIPTION ~"Par³metro com tipo de dado Data.~"" .
create ttLinhaDf. assign Linha = "  FORMAT ~"99/99/9999~"" .
create ttLinhaDf. assign Linha = "  INITIAL ?" .
create ttLinhaDf. assign Linha = "  LABEL ~"Param Data~"" .
create ttLinhaDf. assign Linha = "  COLUMN-LABEL ~"Param Data~"" .
create ttLinhaDf. assign Linha = "  HELP ~"Par³metro com tipo de dado Data.~"" .
create ttLinhaDf. assign Linha = "  ORDER 70" .
create ttLinhaDf. assign Linha = "" .
create ttLinhaDf. assign Linha = "ADD FIELD ~"param-logico~" OF ~"bc-trans-param~" AS logical " .
create ttLinhaDf. assign Linha = "  DESCRIPTION ~"Par³metro com tipo de dado L½gico.~"" .
create ttLinhaDf. assign Linha = "  FORMAT ~"Sim/Nao~"" .
create ttLinhaDf. assign Linha = "  INITIAL ~"yes~"" .
create ttLinhaDf. assign Linha = "  LABEL ~"Param L½gico~"" .
create ttLinhaDf. assign Linha = "  COLUMN-LABEL ~"Param L½gico~"" .
create ttLinhaDf. assign Linha = "  HELP ~"Par³metro com tipo de dado L½gico.~"" .
create ttLinhaDf. assign Linha = "  ORDER 80" .
create ttLinhaDf. assign Linha = "" .
create ttLinhaDf. assign Linha = "ADD FIELD ~"param-raw~" OF ~"bc-trans-param~" AS raw " .
create ttLinhaDf. assign Linha = "  DESCRIPTION ~"Par³metro com tipo de dado RAW.~"" .
create ttLinhaDf. assign Linha = "  FORMAT ~"x(15000)~"" .
create ttLinhaDf. assign Linha = "  INITIAL ~"~"" .
create ttLinhaDf. assign Linha = "  LABEL ~"Param RAW~"" .
create ttLinhaDf. assign Linha = "  COLUMN-LABEL ~"Par RAW~"" .
create ttLinhaDf. assign Linha = "  HELP ~"Par³metro com tipo de dado RAW.~"" .
create ttLinhaDf. assign Linha = "  ORDER 90" .
create ttLinhaDf. assign Linha = "" .
create ttLinhaDf. assign Linha = "ADD FIELD ~"char-1~" OF ~"bc-trans-param~" AS character " .
create ttLinhaDf. assign Linha = "  FORMAT ~"x(100)~"" .
create ttLinhaDf. assign Linha = "  INITIAL ~"~"" .
create ttLinhaDf. assign Linha = "  COLUMN-LABEL-SA ~"L100~"" .
create ttLinhaDf. assign Linha = "  ORDER 100" .
create ttLinhaDf. assign Linha = "" .
create ttLinhaDf. assign Linha = "ADD FIELD ~"char-2~" OF ~"bc-trans-param~" AS character " .
create ttLinhaDf. assign Linha = "  FORMAT ~"x(100)~"" .
create ttLinhaDf. assign Linha = "  INITIAL ~"~"" .
create ttLinhaDf. assign Linha = "  COLUMN-LABEL-SA ~"L100~"" .
create ttLinhaDf. assign Linha = "  ORDER 110" .
create ttLinhaDf. assign Linha = "" .
create ttLinhaDf. assign Linha = "ADD FIELD ~"dec-1~" OF ~"bc-trans-param~" AS decimal " .
create ttLinhaDf. assign Linha = "  FORMAT ~"->>>>>>>>>>>9.99999999~"" .
create ttLinhaDf. assign Linha = "  INITIAL ~"0~"" .
create ttLinhaDf. assign Linha = "  COLUMN-LABEL-SA ~"R22~"" .
create ttLinhaDf. assign Linha = "  ORDER 120" .
create ttLinhaDf. assign Linha = "" .
create ttLinhaDf. assign Linha = "ADD FIELD ~"dec-2~" OF ~"bc-trans-param~" AS decimal " .
create ttLinhaDf. assign Linha = "  FORMAT ~"->>>>>>>>>>>9.99999999~"" .
create ttLinhaDf. assign Linha = "  INITIAL ~"0~"" .
create ttLinhaDf. assign Linha = "  COLUMN-LABEL-SA ~"R22~"" .
create ttLinhaDf. assign Linha = "  ORDER 130" .
create ttLinhaDf. assign Linha = "" .
create ttLinhaDf. assign Linha = "ADD FIELD ~"int-1~" OF ~"bc-trans-param~" AS integer " .
create ttLinhaDf. assign Linha = "  FORMAT ~"->>>>>>>>>9~"" .
create ttLinhaDf. assign Linha = "  INITIAL ~"0~"" .
create ttLinhaDf. assign Linha = "  COLUMN-LABEL-SA ~"R11~"" .
create ttLinhaDf. assign Linha = "  ORDER 140" .
create ttLinhaDf. assign Linha = "" .
create ttLinhaDf. assign Linha = "ADD FIELD ~"int-2~" OF ~"bc-trans-param~" AS integer " .
create ttLinhaDf. assign Linha = "  FORMAT ~"->>>>>>>>>9~"" .
create ttLinhaDf. assign Linha = "  INITIAL ~"0~"" .
create ttLinhaDf. assign Linha = "  COLUMN-LABEL-SA ~"R11~"" .
create ttLinhaDf. assign Linha = "  ORDER 150" .
create ttLinhaDf. assign Linha = "" .
create ttLinhaDf. assign Linha = "ADD FIELD ~"log-1~" OF ~"bc-trans-param~" AS logical " .
create ttLinhaDf. assign Linha = "  FORMAT ~"Sim/N’o~"" .
create ttLinhaDf. assign Linha = "  INITIAL ~"no~"" .
create ttLinhaDf. assign Linha = "  COLUMN-LABEL-SA ~"L3~"" .
create ttLinhaDf. assign Linha = "  ORDER 160" .
create ttLinhaDf. assign Linha = "" .
create ttLinhaDf. assign Linha = "ADD FIELD ~"log-2~" OF ~"bc-trans-param~" AS logical " .
create ttLinhaDf. assign Linha = "  FORMAT ~"Sim/N’o~"" .
create ttLinhaDf. assign Linha = "  INITIAL ~"no~"" .
create ttLinhaDf. assign Linha = "  COLUMN-LABEL-SA ~"L3~"" .
create ttLinhaDf. assign Linha = "  ORDER 170" .
create ttLinhaDf. assign Linha = "" .
create ttLinhaDf. assign Linha = "ADD FIELD ~"data-1~" OF ~"bc-trans-param~" AS date " .
create ttLinhaDf. assign Linha = "  FORMAT ~"99/99/9999~"" .
create ttLinhaDf. assign Linha = "  INITIAL ?" .
create ttLinhaDf. assign Linha = "  ORDER 180" .
create ttLinhaDf. assign Linha = "" .
create ttLinhaDf. assign Linha = "ADD FIELD ~"data-2~" OF ~"bc-trans-param~" AS date " .
create ttLinhaDf. assign Linha = "  FORMAT ~"99/99/9999~"" .
create ttLinhaDf. assign Linha = "  INITIAL ?" .
create ttLinhaDf. assign Linha = "  ORDER 190" .
create ttLinhaDf. assign Linha = "" .
create ttLinhaDf. assign Linha = "ADD FIELD ~"check-sum~" OF ~"bc-trans-param~" AS character " .
create ttLinhaDf. assign Linha = "  FORMAT ~"x(20)~"" .
create ttLinhaDf. assign Linha = "  INITIAL ~"~"" .
create ttLinhaDf. assign Linha = "  LABEL ~"Check-sum~"" .
create ttLinhaDf. assign Linha = "  ORDER 200" .
create ttLinhaDf. assign Linha = "" .
create ttLinhaDf. assign Linha = "ADD INDEX ~"ch-cod-param~" ON ~"bc-trans-param~" " .
create ttLinhaDf. assign Linha = "  UNIQUE" .
create ttLinhaDf. assign Linha = "  PRIMARY" .
create ttLinhaDf. assign Linha = "  INDEX-FIELD ~"cd-trans~" ASCENDING " .
create ttLinhaDf. assign Linha = "  INDEX-FIELD ~"cd-param~" ASCENDING " .
create ttLinhaDf. assign Linha = "" .
create ttLinhaDf. assign Linha = "." .
create ttLinhaDf. assign Linha = "PSC" .
create ttLinhaDf. assign Linha = "codepage=ibm850" .
create ttLinhaDf. assign Linha = "." .
create ttLinhaDf. assign Linha = "0000004192" .


output to ./xxx.df.
for each ttLinhaDF:
   put unformatted Linha skip.
end.
output close.


create alias dictdb for database mgcld.
run prodict/load_df.p ("./xxx.df").
