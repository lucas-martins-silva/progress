/************************************************************** 
* AF0502.i3 ImpressÆo das notas para Excel
*
**************************************************************/

assign c-dt-indice-fim = string(month({1}.dt-indice),"99") + "/" + string(year({1}.dt-indice),"9999").
put unformatted {1}.tipo                 + ";".
put unformatted {1}.cod-estabel          + ";".
put unformatted c-dt-indice-fim          + ";".
put unformatted string({1}.cod-emitente) + ";".
put unformatted {1}.nome-emit            + ";".
put unformatted {1}.it-codigo            + ";".
put unformatted {1}.desc-item            + ";".
put unformatted string({1}.nr-controle)  + ";".
put unformatted {1}.descricao            + ";".
put unformatted string({1}.indice,"->>9.9999") + ";".
put unformatted string({1}.percentual, ">>9.99")   + ";".
put unformatted string({1}.nota, "->>9.999") skip.
